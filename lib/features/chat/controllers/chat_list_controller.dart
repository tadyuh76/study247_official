import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/firebase.dart';
import 'package:study247/core/models/message.dart';
import 'package:study247/core/providers/firebase_providers.dart';
import 'package:study247/features/room/controllers/room_controller.dart';

final chatListController =
    StreamProvider((ref) => ChatListController(ref).getChatList());

class ChatListController {
  final Ref _ref;
  ChatListController(this._ref);

  Stream<List<Message>> getChatList() {
    final roomId = _ref.read(roomControllerProvider).asData!.value!.id;
    final db = _ref.read(firestoreProvider);
    final snapshots = db
        .collection(FirebaseConstants.rooms)
        .doc(roomId)
        .collection(FirebaseConstants.messages)
        .orderBy("createdAt", descending: true)
        .snapshots();
    return snapshots.map(
      (event) => event.docs.map((e) => Message.fromMap(e.data())).toList(),
    );
  }
}
