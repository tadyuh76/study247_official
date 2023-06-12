import 'dart:async';

import 'package:study247/features/room/screens/room_screen/room_screen.dart';
import 'package:study247/utils/show_snack_bar.dart';

const minute = 60;
final context = globalKey.currentState!.context;

class RoomTimer {
  final int roomTimerDuration;
  final int roomTimerBreaktime;
  String roomTimerStart;
  int roomTimerSessionNo;
  bool isStudying = false;
  bool isBreaktime = false;
  int remainTime = 0;
  Timer timer = Timer(const Duration(seconds: 1), () {});

  void setupStudyTimer() {
    final startTime = DateTime.parse(roomTimerStart);
    remainTime = startTime
        .add(Duration(seconds: roomTimerDuration))
        .difference(DateTime.now())
        .inSeconds;
  }

  void startStudying() {
    if (isStudying || isBreaktime) return;
    isStudying = true;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remainTime--;

      if (remainTime == 0) {
        timer.cancel();
        isStudying = false;

        setupBreaktimeTimer();
        startBreaktime();
        // showCustomDialog(
        //   context: globalKey.currentState!.context,
        //   dialog: const BreaktimeDialog(),
        //   canDismiss: false,
        // );
        showSnackBar(context, "hết giờ học");
      }
    });
  }

  void setupBreaktimeTimer() {
    final isLongBreak = roomTimerSessionNo % 3 == 0;
    roomTimerSessionNo++;

    final breaktime = isLongBreak ? roomTimerBreaktime * 3 : roomTimerBreaktime;
    final startTime = DateTime.parse(roomTimerStart);
    remainTime = startTime
        .add(Duration(seconds: breaktime))
        .difference(DateTime.now())
        .inSeconds;

    roomTimerStart = DateTime.now().toString();
  }

  void startBreaktime() {
    if (isBreaktime) return;
    isBreaktime = true;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remainTime--;
      if (remainTime == 0) {
        timer.cancel();
        isBreaktime = false;

        setupStudyTimer();
        startStudying();

        // showCustomDialog(
        //   context: globalKey.currentState!.context,
        //   dialog: const ReturnFromBreaktimeDialog(),
        //   canDismiss: false,
        // );
        showSnackBar(context, "hết giờ nghỉ");
      }
    });
  }

  void stopTimer() {
    timer.cancel();
    isStudying = false;
    isBreaktime = false;
  }

  RoomTimer({
    required this.roomTimerSessionNo,
    required this.roomTimerDuration,
    required this.roomTimerBreaktime,
    required this.roomTimerStart,
    bool? isStudying,
    bool? isBreaktime,
    int? remainTime,
    Timer? timer,
  });

  factory RoomTimer.empty() {
    return RoomTimer(
      roomTimerSessionNo: 0,
      roomTimerDuration: 25,
      roomTimerBreaktime: 5,
      roomTimerStart: '',
    );
  }

  RoomTimer copyWith({
    int? roomTimerSessionNo,
    int? roomTimerDuration,
    int? roomTimerBreaktime,
    String? roomTimerStart,
  }) {
    return RoomTimer(
      roomTimerSessionNo: roomTimerSessionNo ?? this.roomTimerSessionNo,
      roomTimerDuration: roomTimerDuration ?? this.roomTimerDuration,
      roomTimerBreaktime: roomTimerBreaktime ?? this.roomTimerBreaktime,
      roomTimerStart: roomTimerStart ?? this.roomTimerStart,
      isStudying: isStudying,
      isBreaktime: isBreaktime,
      remainTime: remainTime,
      timer: timer,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'roomTimerSessionNo': roomTimerSessionNo,
      'roomTimerDuration': roomTimerDuration,
      'roomTimerBreaktime': roomTimerBreaktime,
      'roomTimerStart': roomTimerStart,
    };
  }

  factory RoomTimer.fromMap(Map<String, dynamic> map) {
    return RoomTimer(
      roomTimerSessionNo: map['roomTimerSessionNo']?.toInt() ?? 0,
      roomTimerDuration: map['roomTimerDuration']?.toInt() ?? 0,
      roomTimerBreaktime: map['roomTimerBreaktime']?.toInt() ?? 0,
      roomTimerStart: map['roomTimerStart'] ?? '',
    );
  }
  @override
  String toString() {
    return 'RoomTimer(roomTimerSessionNo: $roomTimerSessionNo, roomTimerDuration: $roomTimerDuration, roomTimerBreaktime: $roomTimerBreaktime, roomTimerStart: $roomTimerStart)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RoomTimer &&
        other.roomTimerSessionNo == roomTimerSessionNo &&
        other.roomTimerDuration == roomTimerDuration &&
        other.roomTimerBreaktime == roomTimerBreaktime &&
        other.roomTimerStart == roomTimerStart;
  }

  @override
  int get hashCode {
    return roomTimerSessionNo.hashCode ^
        roomTimerDuration.hashCode ^
        roomTimerBreaktime.hashCode ^
        roomTimerStart.hashCode;
  }
}
