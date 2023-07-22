import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/firebase.dart';
import 'package:study247/core/models/result.dart';
import 'package:study247/core/models/user.dart';
import 'package:study247/core/providers/firebase_providers.dart';
import 'package:study247/features/room/screens/solo_room_screen/solo_room_screen.dart';
import 'package:study247/utils/show_snack_bar.dart';

final profileRepositoryProvider = Provider((ref) {
  final db = ref.read(firestoreProvider);
  final storage = ref.read(storageProvider);
  return ProfileRepository(db, storage);
});

class ProfileRepository {
  final FirebaseFirestore _db;
  final FirebaseStorage _storage;
  ProfileRepository(this._db, this._storage);

  Future<Result<String, Exception>> updateStudyTime(UserModel user) async {
    try {
      final snapshot =
          await _db.collection(FirebaseConstants.users).doc(user.uid).get();
      final currentUser =
          UserModel.fromMap(snapshot.data() as Map<String, dynamic>);

      final now = DateTime.now();
      final year = now.year.toString();
      final month = now.month.toString();
      final dayIdx = now.day - 1;

      final updatedCommitBoard = currentUser.commitBoard;
      updatedCommitBoard[year]![month]![dayIdx] += 1;

      int newStreak = currentUser.currentStreak;
      int newLongestStreak = currentUser.longestStreak;
      if (updatedCommitBoard[year]![month]![dayIdx] == 15) {
        newStreak++;
        newLongestStreak = max(newLongestStreak, newStreak);
      }

      int newStudyTime = currentUser.totalStudyTime + 1;
      int newMasteryLevel = currentUser.masteryLevel;
      if (user.masteryLevel != 9 &&
          newStudyTime == minutesToMastery[user.masteryLevel + 1]) {
        newMasteryLevel++;
        showSnackBar(globalKey.currentContext!, "Đã đạt cấp độ tiếp theo!");
      }

      await _db.collection(FirebaseConstants.users).doc(user.uid).update({
        "totalStudyTime": newStudyTime,
        "commitBoard": updatedCommitBoard,
        "currentStreak": newStreak,
        "longestStreak": newLongestStreak,
        "masteryLevel": newMasteryLevel,
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
