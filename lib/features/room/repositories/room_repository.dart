import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/firebase.dart';
import 'package:study247/core/models/result.dart';
import 'package:study247/core/models/room.dart';
import 'package:study247/core/providers/firebase_providers.dart';
import 'package:study247/features/auth/controllers/auth_controller.dart';

final roomRepositoryProvider = Provider((ref) {
  final db = ref.read(firestoreProvider);
  return RoomRepository(db, ref);
});

class RoomRepository {
  final FirebaseFirestore _db;
  final Ref _ref;
  RoomRepository(this._db, this._ref);

  CollectionReference get roomRef => _db.collection(FirebaseConstants.rooms);

  Future<Result<String, Exception>> createRoom(RoomModel room) async {
    try {
      final roomId = roomRef.doc().id;
      await roomRef.doc(roomId).set(room.copyWith(id: roomId).toMap());
      return Success(roomId);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<RoomModel, Exception>> getRoomById(String roomId) async {
    try {
      final room = await roomRef.doc(roomId).get();
      return Success(RoomModel.fromMap(room.data() as Map<String, dynamic>));
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<String, Exception>> joinRoom(String roomId) async {
    try {
      final user = _ref.read(authControllerProvider).asData!.value!;
      await roomRef
          .doc(roomId)
          .update({"curParticipants": FieldValue.increment(1)});
      await roomRef
          .doc(roomId)
          .collection(FirebaseConstants.participants)
          .doc(user.uid)
          .set(user.toMap());

      return const Success(Constants.successMessage);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<String, Exception>> leaveRoom(String roomId) async {
    try {
      final currentRoomRef = roomRef.doc(roomId);
      final currentRoom = RoomModel.fromMap(
          (await currentRoomRef.get()).data() as Map<String, dynamic>);
      if (currentRoom.curParticipants == 1) {
        await currentRoomRef.delete();
      } else {
        currentRoomRef.update({"curParticipants": FieldValue.increment(-1)});
      }
      return const Success(Constants.successMessage);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
