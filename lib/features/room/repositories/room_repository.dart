import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/firebase.dart';
import 'package:study247/core/models/result.dart';
import 'package:study247/core/models/room.dart';
import 'package:study247/core/providers/firebase_providers.dart';

final roomRepositoryProvider = Provider((ref) {
  final db = ref.read(firestoreProvider);
  return RoomRepository(db);
});

class RoomRepository {
  final FirebaseFirestore _db;
  RoomRepository(this._db);

  CollectionReference get roomRef => _db.collection(FirebaseConstants.rooms);

  Future<Result<String, Exception>> createRoom(Room room) async {
    try {
      final roomId = roomRef.doc().id;
      await roomRef.doc(roomId).set(room.copyWith(id: roomId).toMap());
      return Success(roomId);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<Room, Exception>> getRoomById(String roomId) async {
    try {
      final room = await roomRef.doc(roomId).get();
      return Success(Room.fromMap(room.data() as Map<String, dynamic>));
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
