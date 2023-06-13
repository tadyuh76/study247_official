import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/models/result.dart';
import 'package:study247/features/room/controllers/room_controller.dart';
import 'package:study247/features/room_timer/notifiers/room_timer.dart';

final roomTimerRepositoryProvider = Provider((ref) => RoomTimerRepository(ref));

class RoomTimerRepository {
  final Ref _ref;
  RoomTimerRepository(this._ref);

  Future<Result<String, Exception>> updateRoomTimer() async {
    try {
      final currentRoom = _ref.read(roomControllerProvider).asData!.value!;
      final currentTimer = _ref.read(roomTimerProvider);

      final updatedRoom = currentRoom.copyWith(
        roomTimerSessionNo: currentTimer.roomTimerSessionNo,
        roomTimerDuration: currentTimer.roomTimerDuration,
        roomTimerBreaktime: currentTimer.roomTimerBreaktime,
        roomTimerStart: currentTimer.roomTimerStart,
        isStudying: currentTimer.isStudying,
        isPaused: currentTimer.isPaused,
      );

      await _ref.read(roomControllerProvider.notifier).updateRoom(updatedRoom);

      return const Success(Constants.successMessage);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
