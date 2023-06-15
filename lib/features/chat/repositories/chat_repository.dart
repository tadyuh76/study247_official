import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/firebase.dart';
import 'package:study247/core/models/message.dart';
import 'package:study247/core/models/result.dart';
import 'package:study247/core/providers/firebase_providers.dart';
import 'package:study247/features/room/controllers/room_controller.dart';

final chatRepositoryProvider = Provider((ref) => ChatRepository(ref));

class ChatRepository {
  final Ref _ref;
  ChatRepository(this._ref);

  Future<Result<String, Exception>> sendMessage(Message message) async {
    try {
      final roomId = _ref.read(roomControllerProvider).asData!.value!.id;
      final db = _ref.read(firestoreProvider);
      final messageRef = db
          .collection(FirebaseConstants.rooms)
          .doc(roomId)
          .collection(FirebaseConstants.messages)
          .doc();
      await messageRef.set(message.copyWith(id: messageRef.id).toMap());
      return const Success(Constants.successMessage);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<String, Exception>> pinMessage(Message message) async {
    try {
      final db = _ref.read(firestoreProvider);
      final roomId = _ref.read(roomControllerProvider).asData!.value!.id;
      await db
          .collection(FirebaseConstants.rooms)
          .doc(roomId)
          .collection(FirebaseConstants.pinnedMessages)
          .doc(message.id)
          .set(message.toMap());

      return const Success(Constants.successMessage);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<String, Exception>> unpinMessage(Message message) async {
    try {
      final db = _ref.read(firestoreProvider);
      final roomId = _ref.read(roomControllerProvider).asData!.value!.id;
      await db
          .collection(FirebaseConstants.rooms)
          .doc(roomId)
          .collection(FirebaseConstants.pinnedMessages)
          .doc(message.id)
          .delete();

      return const Success(Constants.successMessage);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
