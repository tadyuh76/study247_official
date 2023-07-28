import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/core/models/room.dart';

final roomInfoControllerProvider = StateProvider((ref) => RoomInfoController());

class RoomInfoController {
  RoomModel _room = RoomModel.empty();
  RoomModel get room => _room;

  void updateRoomInfo({
    String? name,
    String? bannerColor,
    String? description,
    int? roomTimerDuration,
    int? roomTimerBreaktime,
    int? maxParticipants,
    List<String>? tags,
    bool? allowMic,
    bool? allowCamera,
  }) {
    _room = _room.copyWith(
      name: name,
      bannerColor: bannerColor,
      description: description,
      roomTimerDuration: roomTimerDuration,
      roomTimerBreaktime: roomTimerBreaktime,
      maxParticipants: maxParticipants,
      tags: tags,
      allowMic: allowMic,
      allowCamera: allowCamera,
    );
  }

  void reset() {
    _room = RoomModel.empty();
  }
}
