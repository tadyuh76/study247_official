import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/firebase.dart';
import 'package:study247/core/providers/firebase_providers.dart';

import '../../../core/models/result.dart';
import '../../../core/models/room.dart';

final roomListRepositoryProvider = Provider((ref) {
  final db = ref.read(firestoreProvider);
  return RoomListRepository(db);
});

class RoomListRepository {
  final FirebaseFirestore _db;
  RoomListRepository(this._db);
  CollectionReference get roomRef => _db.collection(FirebaseConstants.rooms);

  Future<Result<List<RoomModel>, Exception>> getRoomList() async {
    try {
      final snapshot = await roomRef.get();
      final roomList = snapshot.docs
          .map((e) => RoomModel.fromMap(e.data() as Map<String, dynamic>))
          .toList();
      return Success(roomList);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
