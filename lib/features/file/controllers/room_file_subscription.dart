import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/firebase.dart';
import 'package:study247/core/models/file.dart';
import 'package:study247/core/providers/firebase_providers.dart';
import 'package:study247/features/room/controllers/room_controller.dart';

final roomFileSubscriptionProvider = StreamProvider.autoDispose(
    (ref) => RoomFileSubscription(ref).watchRoomFile());

class RoomFileSubscription {
  final Ref _ref;
  RoomFileSubscription(this._ref);

  Stream<File?> watchRoomFile() {
    try {
      final roomId = _ref.read(roomControllerProvider).asData!.value!.id;
      final db = _ref.read(firestoreProvider);
      final roomStream = db
          .collection(FirebaseConstants.rooms)
          .doc(roomId)
          .collection("file")
          .doc("1")
          .snapshots();

      return roomStream.map((event) => File.fromMap(event.data() ?? {}));
    } catch (e) {
      // print(e);
    }
    return Stream.value(File(type: "", url: ""));
  }
}
