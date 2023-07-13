import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/firebase.dart';
import 'package:study247/core/models/result.dart';
import 'package:study247/core/models/room.dart';
import 'package:study247/core/providers/firebase_providers.dart';
import 'package:study247/features/meeting/controllers/meeting_controler.dart';
import 'package:study247/features/room/controllers/room_list_controller.dart';
import 'package:study247/utils/show_snack_bar.dart';
import 'package:study247/features/auth/controllers/auth_controller.dart';
import 'package:study247/features/room/controllers/room_info_controller.dart';
import 'package:study247/features/room/repositories/room_repository.dart';

final roomControllerProvider =
    StateNotifierProvider<RoomController, AsyncValue<RoomModel?>>(
  (ref) => RoomController(ref),
);

class RoomController extends StateNotifier<AsyncValue<RoomModel?>> {
  final Ref _ref;
  RoomController(this._ref) : super(const AsyncLoading());

  Future<void> createRoom(BuildContext context) async {
    state = const AsyncLoading();

    RoomModel roomInfo = _ref.read(roomInfoControllerProvider).room;
    final hostUser = _ref.read(authControllerProvider).asData!.value!;
    final meetingId =
        await _ref.read(meetingControllerProvider).createMeeting();
    roomInfo = roomInfo.copyWith(
      meetingId: meetingId,
      hostUid: hostUser.uid,
      hostPhotoUrl: hostUser.photoURL,
      roomTimerStart: DateTime.now().toString(),
    );

    final result = await _ref.read(roomRepositoryProvider).createRoom(roomInfo);

    if (result case Success(value: final roomId)) {
      state = AsyncData(roomInfo.copyWith(id: roomId));
    } else if (result case Failure(:final failure)) {
      if (mounted) {
        showSnackBar(context, failure.toString());
      }
      state = const AsyncData(null);
    }
  }

  Future<void> joinRoom(String roomId) async {
    await _ref.read(roomRepositoryProvider).joinRoom(roomId);
  }

  Future<void> getRoomById(context, String roomId) async {
    final result = await _ref.read(roomRepositoryProvider).getRoomById(roomId);
    if (result case Success(value: final room)) {
      state = AsyncData(room);
    } else {
      showSnackBar(context, "Phòng học đã bị xóa hoặc không tồn tại");
      state = AsyncData(RoomModel.empty());
    }
  }

  Future<void> updateRoom(RoomModel room) async {
    final db = _ref.read(firestoreProvider);
    await db.collection(FirebaseConstants.rooms).doc(room.id).set(room.toMap());
    state = AsyncData(room);
  }

  void reset() {
    state = const AsyncLoading();
  }

  Future<void> leaveRoom() async {
    final roomId = state.asData!.value!.id!;
    await _ref.read(roomRepositoryProvider).leaveRoom(roomId);
    await _ref.read(roomListControllerProvider.notifier).getRoomList();
  }
}
