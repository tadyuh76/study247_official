import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/features/auth/controllers/auth_controller.dart';
import 'package:study247/features/room/controllers/room_controller.dart';
import 'package:study247/features/room/screens/room_screen/room_screen.dart';
import 'package:study247/features/room_timer/repositories/room_timer_repository.dart';
import 'package:study247/utils/show_snack_bar.dart';

final roomTimerProvider = ChangeNotifierProvider(
  (ref) => RoomTimer(ref)..setup(),
);

class RoomTimer extends ChangeNotifier {
  int roomTimerSessionNo = 1;
  int roomTimerDuration = 0;
  int roomTimerBreaktime = 0;
  String roomTimerStart = "";
  bool isStudying = false;
  bool isPaused = false;

  int remainTime = 0;
  Timer timer = Timer(const Duration(seconds: 1), () {});

  final Ref _ref;

  RoomTimer(this._ref) {
    final room = _ref.read(roomControllerProvider).asData!.value!;

    roomTimerDuration = room.roomTimerDuration;
    roomTimerBreaktime = room.roomTimerBreaktime;
    roomTimerStart = room.roomTimerStart;
    roomTimerSessionNo = room.roomTimerSessionNo;
    isStudying = room.isStudying;
    isPaused = room.isPaused;
  }

  Future<void> updateTimer() async {
    final userId = _ref.read(authControllerProvider).asData!.value!.uid;
    final hostId = _ref.read(roomControllerProvider).asData!.value!.hostUid;

    if (userId == hostId) {
      await _ref.read(roomTimerRepositoryProvider).updateRoomTimer();
    }
  }

  void setup() {
    if (isStudying) {
      setupStudyTimer();
      if (!isPaused) startStudying();
    } else {
      setupBreaktimeTimer();
      if (!isPaused) startBreaktime();
    }
    notifyListeners();
  }

  void setupStudyTimer() {
    final startTime = DateTime.parse(roomTimerStart);
    remainTime = startTime
        .add(Duration(seconds: roomTimerDuration))
        .difference(DateTime.now())
        .inSeconds;
    notifyListeners();
  }

  void setupBreaktimeTimer() {
    final isLongBreak = roomTimerSessionNo % 3 == 0;
    final breaktime = isLongBreak ? roomTimerBreaktime * 3 : roomTimerBreaktime;

    final startTime = DateTime.parse(roomTimerStart);
    remainTime = startTime
        .add(Duration(seconds: breaktime))
        .difference(DateTime.now())
        .inSeconds;
    notifyListeners();
  }

  void startStudying() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remainTime--;

      if (remainTime == 0) {
        timer.cancel();
        isStudying = false;

        roomTimerStart = DateTime.now().toString();
        setupBreaktimeTimer();
        startBreaktime();
        updateTimer();
        // showCustomDialog(
        //   context: globalKey.currentState!.context,
        //   dialog: const BreaktimeDialog(),
        //   canDismiss: false,
        // );
        showSnackBar(globalKey.currentState!.context, "hết giờ học");
      }

      notifyListeners();
    });
  }

  void startBreaktime() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remainTime--;

      if (remainTime == 0) {
        timer.cancel();
        isStudying = true;

        roomTimerStart = DateTime.now().toString();
        roomTimerSessionNo++;
        setupStudyTimer();
        startStudying();
        updateTimer();

        // showCustomDialog(
        //   context: globalKey.currentState!.context,
        //   dialog: const ReturnFromBreaktimeDialog(),
        //   canDismiss: false,
        // );
        showSnackBar(globalKey.currentState!.context, "hết giờ nghỉ");
      }

      notifyListeners();
    });
  }

  void stopTimer() {
    timer.cancel();
    isPaused = true;
    notifyListeners();
  }

  void continueTimer() {
    if (isStudying) {
      startStudying();
    } else {
      startBreaktime();
    }
    isPaused = false;
    notifyListeners();
  }

  void resetTimer() {
    roomTimerSessionNo = 0;
    roomTimerDuration = 0;
    roomTimerBreaktime = 0;
    roomTimerStart = "";
    isStudying = false;
    isPaused = false;

    remainTime = 0;
    timer = Timer(const Duration(seconds: 1), () {});
    updateTimer();
    notifyListeners();
  }
}
