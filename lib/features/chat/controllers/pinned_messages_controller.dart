import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/firebase.dart';
import 'package:study247/core/models/message.dart';
import 'package:study247/core/providers/firebase_providers.dart';
import 'package:study247/features/room/controllers/room_controller.dart';

final pinnedMessagesController =
    StreamProvider((ref) => PinnedMessagesController(ref).getPinnedMessages());

class PinnedMessagesController {
  final Ref _ref;
  PinnedMessagesController(this._ref);

  Stream<List<Message>> getPinnedMessages() {
    final roomId = _ref.read(roomControllerProvider).asData!.value!.id;
    final db = _ref.read(firestoreProvider);
    final snapshots = db
        .collection(FirebaseConstants.rooms)
        .doc(roomId)
        .collection(FirebaseConstants.pinnedMessages)
        .orderBy("createdAt", descending: true)
        .snapshots();
    return snapshots.map(
      (event) => event.docs.map((e) => Message.fromMap(e.data())).toList(),
    );
  }
}
