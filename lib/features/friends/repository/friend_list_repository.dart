import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/firebase.dart';
import 'package:study247/core/models/result.dart';
import 'package:study247/core/models/user.dart';
import 'package:study247/core/providers/firebase_providers.dart';

final friendListRepositoryProvider = Provider((ref) {
  final db = ref.read(firestoreProvider);
  return FriendListRepository(db);
});

class FriendListRepository {
  final FirebaseFirestore _db;
  FriendListRepository(this._db);

  Future<Result<List<UserModel>, Exception>> getFriendList(
    List<String> friendIds,
  ) async {
    try {
      if (friendIds.isEmpty) return const Success([]);

      final snapshot = await _db
          .collection(FirebaseConstants.users)
          .where("uid", whereIn: friendIds)
          .get();
      final friendList =
          snapshot.docs.map((e) => UserModel.fromMap(e.data())).toList();

      return Success(friendList);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
