import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/core/models/room.dart';

final roomInfoControllerProvider = StateProvider((ref) => RoomInfoController());

class RoomInfoController {
  Room _room = Room.empty();
  Room get room => _room;

  void updateRoomInfo({
    String? name,
    String? bannerColor,
    String? description,
    double? pomodoroDuration,
    double? pomodoroBreaktime,
    int? maxParticipants,
    List<String>? tags,
  }) {
    _room = _room.copyWith(
      name: name,
      bannerColor: bannerColor,
      description: description,
      pomodoroDuration: pomodoroDuration,
      pomodoroBreaktime: pomodoroBreaktime,
      maxParticipants: maxParticipants,
      tags: tags,
    );
  }

  void reset() {
    _room = Room.empty();
  }
}
