import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/features/room/screens/room_screen/room_screen.dart';
import 'package:study247/utils/show_snack_bar.dart';

final personalTimerProvider = ChangeNotifierProvider(
  (ref) => PersonalTimer(),
);

class PersonalTimer extends ChangeNotifier {
  int personalTimerSessionNo = 1;
  int personalTimerDuration = 50 * 60;
  int personalTimerBreaktime = 10 * 60;
  String personalTimerStart = DateTime.now().toString();
  bool isStudying = false;
  bool isPaused = false;
  bool init = false;

  int remainTime = 0;
  Timer timer = Timer(const Duration(seconds: 1), () {});

  void updateTimer({
    int? personalTimerDuration,
    int? personalTimerBreaktime,
    String? personalTimerStart,
  }) {
    this.personalTimerDuration =
        personalTimerDuration ?? this.personalTimerDuration;
    this.personalTimerBreaktime =
        personalTimerBreaktime ?? this.personalTimerBreaktime;
    this.personalTimerStart = personalTimerStart ?? this.personalTimerStart;
    notifyListeners();
  }

  void setup() {
    init = true;
    isStudying = true;

    if (isStudying) {
      setupStudyTimer();
      if (!isPaused) startStudying();
    } else {
      setupBreaktimeTimer();
      if (!isPaused) startBreaktime();
    }
  }

  void setupStudyTimer() {
    final startTime = DateTime.parse(personalTimerStart);
    remainTime = startTime
        .add(Duration(seconds: personalTimerDuration))
        .difference(DateTime.now())
        .inSeconds;
    notifyListeners();
  }

  void setupBreaktimeTimer() {
    final isLongBreak = personalTimerSessionNo % 3 == 0;
    final breaktime =
        isLongBreak ? personalTimerBreaktime * 3 : personalTimerBreaktime;

    final startTime = DateTime.parse(personalTimerStart);
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

        personalTimerStart = DateTime.now().toString();
        setupBreaktimeTimer();
        startBreaktime();
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

        personalTimerStart = DateTime.now().toString();
        personalTimerSessionNo++;
        setupStudyTimer();
        startStudying();

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
    isPaused = false;
    notifyListeners();

    if (isStudying) {
      startStudying();
    } else {
      startBreaktime();
    }
  }

  void resetTimer() {
    personalTimerSessionNo = 0;
    personalTimerDuration = 0;
    personalTimerBreaktime = 0;
    personalTimerStart = "";
    isStudying = false;
    isPaused = false;
    init = false;

    remainTime = 0;
    timer.cancel();
    timer = Timer(const Duration(seconds: 1), () {});
    notifyListeners();
  }
}
