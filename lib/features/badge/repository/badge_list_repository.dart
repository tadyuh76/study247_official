import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/firebase.dart';
import 'package:study247/core/models/badge.dart';
import 'package:study247/core/models/result.dart';
import 'package:study247/core/providers/firebase_providers.dart';

final badgeListRepositoryProvider = Provider((ref) {
  final db = ref.read(firestoreProvider);
  return BadgeListRepository(db);
});

class BadgeListRepository {
  final FirebaseFirestore _db;
  BadgeListRepository(this._db);

  Future<Result<List<BadgeModel>, Exception>> getBadgeList(
    String userId,
  ) async {
    try {
      final snapshot = await _db
          .collection(FirebaseConstants.users)
          .doc(userId)
          .collection(FirebaseConstants.badgeList)
          .get();
      final badgeList =
          snapshot.docs.map((e) => BadgeModel.fromMap(e.data())).toList();
      badgeList.sort((a, b) => b.name.compareTo(a.name));

      return Success(badgeList);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<String, Exception>> addBadges(
    String userId,
    List<String> newBadges,
  ) async {
    try {
      final badgeList =
          newBadges.map((badgeName) => BadgeModel.fromBadgeName(badgeName));

      //add to collection
      for (int i = 0; i < badgeList.length; i++) {
        await _db
            .collection(FirebaseConstants.users)
            .doc(userId)
            .collection(FirebaseConstants.badgeList)
            .add(badgeList.elementAt(i).toMap());
      }

      return const Success(Constants.successMessage);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
