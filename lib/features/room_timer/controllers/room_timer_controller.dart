import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/core/models/room_timer.dart';
import 'package:study247/features/room/controllers/room_controller.dart';
import 'package:study247/features/room_timer/providers/remain_time_provider.dart';

final roomTimerControllerProvider =
    StateNotifierProvider<RoomTimerController, RoomTimer>(
  (ref) => RoomTimerController(ref)..init(),
);

class RoomTimerController extends StateNotifier<RoomTimer> {
  final Ref _ref;
  RoomTimerController(this._ref) : super(RoomTimer.empty());
  int remainTime = 0;

  void init() {
    final currentRoom = _ref.read(roomControllerProvider).asData!.value!;
    final roomTimer = RoomTimer(
      roomTimerSessionNo: currentRoom.roomTimerSessionNo,
      roomTimerDuration: currentRoom.roomTimerDuration,
      roomTimerBreaktime: currentRoom.roomTimerBreaktime,
      roomTimerStart: currentRoom.roomTimerStart,
    );

    state = roomTimer;
    state.setupStudyTimer();
    state.startStudying();

    Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      final provider = _ref.read(remainTimeProvider.notifier);
      provider.update((i) => state.remainTime);
    });
  }
}
