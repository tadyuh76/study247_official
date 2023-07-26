import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/badge.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/firebase.dart';
import 'package:study247/core/models/result.dart';
import 'package:study247/core/models/user.dart';
import 'package:study247/core/providers/firebase_providers.dart';
import 'package:study247/features/badge/controller/badge_list_controller.dart';

final profileRepositoryProvider = Provider((ref) {
  final db = ref.read(firestoreProvider);
  final storage = ref.read(storageProvider);
  return ProfileRepository(ref, db, storage);
});

class ProfileRepository {
  final Ref _ref;
  final FirebaseFirestore _db;
  final FirebaseStorage _storage;
  ProfileRepository(this._ref, this._db, this._storage);

  Future<Result<String, Exception>> updateStudyTime(String userId) async {
    try {
      final snapshot =
          await _db.collection(FirebaseConstants.users).doc(userId).get();
      final currentUser =
          UserModel.fromMap(snapshot.data() as Map<String, dynamic>);

      final updatedUser = _checkForAchievements(currentUser);

      await _db
          .collection(FirebaseConstants.users)
          .doc(userId)
          .set(updatedUser.toMap());

      return const Success(Constants.successMessage);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  UserModel _checkForAchievements(UserModel user) {
    final List<String> newBadges = [];

    // check for hardwork badge
    final newStudyTime = user.totalStudyTime + 1;
    for (int i = hardworkBadgeRequirements.length - 1; i >= 0; i--) {
      final badgeName = "${i + 1}_hardwork";
      if (newStudyTime / 60 >= hardworkBadgeRequirements[i] &&
          !user.badges.contains(badgeName)) {
        newBadges.add(badgeName);
        break;
      }
    }

    // check for focus badge
    final now = DateTime.now();
    final year = now.year.toString();
    final month = now.month.toString();
    final dayIdx = now.day - 1;

    final updatedCommitBoard = user.commitBoard;
    updatedCommitBoard[year]![month]![dayIdx] += 1;
    final todayStudyTime = updatedCommitBoard[year]![month]![dayIdx];

    for (int i = focusBadgeRequirements.length - 1; i >= 0; i--) {
      final badgeName = "${i + 1}_focus";
      if (todayStudyTime / 60 >= focusBadgeRequirements[i] &&
          !user.badges.contains(badgeName)) {
        newBadges.add(badgeName);
        break;
      }
    }

    int newStreak = user.currentStreak;
    int newLongestStreak = user.longestStreak;
    int totalActiveDays = user.totalActiveDays;
    if (todayStudyTime == 15) {
      newStreak++;
      totalActiveDays++;
      newLongestStreak = max(newLongestStreak, newStreak);

      // check for discipline badge
      for (int i = disciplineBadgeRequirements.length - 1; i >= 0; i--) {
        final badgeName = "${i + 1}_discipline";
        if (newStreak >= disciplineBadgeRequirements[i] &&
            !user.badges.contains(badgeName)) {
          newBadges.add(badgeName);
          break;
        }
      }

      // check for persevere badge
      for (int i = persevereBadgeRequirements.length - 1; i >= 0; i--) {
        final badgeName = "${i + 1}_persevere";
        if (totalActiveDays >= persevereBadgeRequirements[i] &&
            !user.badges.contains(badgeName)) {
          newBadges.add(badgeName);
          break;
        }
      }
    }

    _ref.read(badgeListControllerProvider.notifier).addBadges(newBadges);

    return user.copyWith(
      totalStudyTime: newStudyTime,
      totalActiveDays: totalActiveDays,
      currentStreak: newStreak,
      longestStreak: newLongestStreak,
      commitBoard: updatedCommitBoard,
      badges: user.badges..addAll(newBadges),
    );
  }

  Future<Result<String, Exception>> addFriend(
    String userId,
    String friendId,
  ) async {
    try {
      await _db.collection(FirebaseConstants.users).doc(userId).update({
        "friends": FieldValue.arrayUnion([friendId])
      });
      return const Success(Constants.successMessage);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<String, Exception>> unFriend(
    String userId,
    String friendId,
  ) async {
    try {
      await _db.collection(FirebaseConstants.users).doc(userId).update({
        "friends": FieldValue.arrayRemove([friendId])
      });
      return const Success(Constants.successMessage);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<String, Exception>> updateUserStatus(
    String userId,
    UserStatus status,
    String studyingRoomId,
    String studyingMeetingId,
  ) async {
    try {
      _db.collection(FirebaseConstants.users).doc(userId).update({
        "status": status.name,
        "studyingRoomId": studyingRoomId,
        "studyingMeetingId": studyingMeetingId,
      });
      return const Success(Constants.successMessage);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<String, Exception>> updateProfile({
    required String userId,
    String? newDisplayName,
    Uint8List? imageBytes,
  }) async {
    try {
      String? newPhotoURL;
      if (imageBytes != null) {
        newPhotoURL = await _uploadProfileImage(userId, imageBytes);
      }
      final snapshot =
          await _db.collection(FirebaseConstants.users).doc(userId).get();
      final user = UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
      final newUser = user.copyWith(
        displayName: newDisplayName ?? user.displayName,
        photoURL: newPhotoURL ?? user.photoURL,
      );
      await _db
          .collection(FirebaseConstants.users)
          .doc(userId)
          .set(newUser.toMap());

      return const Success(Constants.successMessage);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<String> _uploadProfileImage(
    String userId,
    Uint8List imageBytes,
  ) async {
    final result =
        await _storage.ref("profileImgs/$userId").putData(imageBytes);
    final photoURL = await result.ref.getDownloadURL();
    return photoURL;
  }
}
