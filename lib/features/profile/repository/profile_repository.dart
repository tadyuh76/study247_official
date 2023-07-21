import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/firebase.dart';
import 'package:study247/core/models/result.dart';
import 'package:study247/core/models/user.dart';
import 'package:study247/core/providers/firebase_providers.dart';
import 'package:study247/features/room/screens/room_screen/room_screen.dart';
import 'package:study247/utils/show_snack_bar.dart';

final profileRepositoryProvider = Provider((ref) {
  final db = ref.read(firestoreProvider);
  return ProfileRepository(db);
});

class ProfileRepository {
  final FirebaseFirestore _db;
  ProfileRepository(this._db);

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
}
