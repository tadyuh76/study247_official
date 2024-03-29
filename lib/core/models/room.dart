// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

class RoomModel {
  String? id;
  final String meetingId;
  final String name;
  final String bannerColor;
  final String fileUrl;
  final String fileType;
  final String description;
  final List<String> tags;
  final int maxParticipants;
  final int curParticipants;
  final String hostPhotoUrl;
  final String hostUid;
  final int roomTimerSessionNo;
  final int roomTimerDuration;
  final int roomTimerBreaktime;
  final String roomTimerStart;
  final bool isStudying;
  final bool isPaused;
  final bool allowMic;
  final bool allowCamera;

  RoomModel({
    this.id,
    required this.meetingId,
    required this.name,
    required this.bannerColor,
    required this.fileUrl,
    required this.fileType,
    required this.description,
    required this.tags,
    required this.maxParticipants,
    required this.curParticipants,
    required this.hostPhotoUrl,
    required this.hostUid,
    required this.roomTimerSessionNo,
    required this.roomTimerDuration,
    required this.roomTimerBreaktime,
    required this.roomTimerStart,
    required this.isStudying,
    required this.isPaused,
    required this.allowMic,
    required this.allowCamera,
  });

  factory RoomModel.empty() {
    return RoomModel(
      meetingId: "",
      name: "",
      bannerColor: "blue",
      fileUrl: "",
      fileType: "",
      description: "Vào học cùng mình nhé!",
      tags: [],
      maxParticipants: 5,
      curParticipants: 0,
      hostPhotoUrl: "",
      hostUid: "",
      roomTimerSessionNo: 1,
      roomTimerDuration: 50,
      roomTimerBreaktime: 10,
      roomTimerStart: "",
      isStudying: true,
      isPaused: false,
      allowMic: false,
      allowCamera: true,
    );
  }

  RoomModel copyWith({
    String? id,
    String? meetingId,
    String? name,
    String? bannerColor,
    String? fileUrl,
    String? fileType,
    String? description,
    List<String>? tags,
    int? maxParticipants,
    int? curParticipants,
    String? hostPhotoUrl,
    String? hostUid,
    int? roomTimerSessionNo,
    int? roomTimerDuration,
    int? roomTimerBreaktime,
    String? roomTimerStart,
    bool? isStudying,
    bool? isPaused,
    bool? allowMic,
    bool? allowCamera,
  }) {
    return RoomModel(
      id: id ?? this.id,
      meetingId: meetingId ?? this.meetingId,
      name: name ?? this.name,
      bannerColor: bannerColor ?? this.bannerColor,
      fileUrl: fileUrl ?? this.fileUrl,
      fileType: fileType ?? this.fileType,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      curParticipants: curParticipants ?? this.curParticipants,
      hostPhotoUrl: hostPhotoUrl ?? this.hostPhotoUrl,
      hostUid: hostUid ?? this.hostUid,
      roomTimerSessionNo: roomTimerSessionNo ?? this.roomTimerSessionNo,
      roomTimerDuration: roomTimerDuration ?? this.roomTimerDuration,
      roomTimerBreaktime: roomTimerBreaktime ?? this.roomTimerBreaktime,
      roomTimerStart: roomTimerStart ?? this.roomTimerStart,
      isStudying: isStudying ?? this.isStudying,
      isPaused: isPaused ?? this.isPaused,
      allowMic: allowMic ?? this.allowMic,
      allowCamera: allowCamera ?? this.allowCamera,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'meetingId': meetingId,
      'name': name,
      'bannerColor': bannerColor,
      'fileUrl': fileUrl,
      'fileType': fileType,
      'description': description,
      'tags': tags,
      'maxParticipants': maxParticipants,
      'curParticipants': curParticipants,
      'hostPhotoUrl': hostPhotoUrl,
      'hostUid': hostUid,
      'roomTimerSessionNo': roomTimerSessionNo,
      'roomTimerDuration': roomTimerDuration,
      'roomTimerBreaktime': roomTimerBreaktime,
      'roomTimerStart': roomTimerStart,
      'isStudying': isStudying,
      'isPaused': isPaused,
      'allowMic': allowMic,
      'allowCamera': allowCamera,
    };
  }

  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      id: map['id'],
      meetingId: map['meetingId'] ?? '',
      name: map['name'] ?? '',
      bannerColor: map['bannerColor'] ?? '',
      fileUrl: map['fileUrl'] ?? '',
      fileType: map['fileType'] ?? '',
      description: map['description'] ?? '',
      tags: List<String>.from(map['tags']),
      maxParticipants: map['maxParticipants']?.toInt() ?? 0,
      curParticipants: map['curParticipants']?.toInt() ?? 0,
      hostPhotoUrl: map['hostPhotoUrl'] ?? '',
      hostUid: map['hostUid'] ?? '',
      roomTimerSessionNo: map['roomTimerSessionNo']?.toInt() ?? 0,
      roomTimerDuration: map['roomTimerDuration']?.toInt() ?? 0,
      roomTimerBreaktime: map['roomTimerBreaktime']?.toInt() ?? 0,
      roomTimerStart: map['roomTimerStart'] ?? '',
      isStudying: map['isStudying'] ?? false,
      isPaused: map['isPaused'] ?? false,
      allowMic: map['allowMic'] ?? false,
      allowCamera: map['allowCamera'] ?? false,
    );
  }

  @override
  String toString() {
    return 'RoomModel(id: $id, meetingId: $meetingId, name: $name, bannerColor: $bannerColor, fileUrl: $fileUrl, fileType: $fileType, description: $description, tags: $tags, maxParticipants: $maxParticipants, curParticipants: $curParticipants, hostPhotoUrl: $hostPhotoUrl, hostUid: $hostUid, roomTimerSessionNo: $roomTimerSessionNo, roomTimerDuration: $roomTimerDuration, roomTimerBreaktime: $roomTimerBreaktime, roomTimerStart: $roomTimerStart, isStudying: $isStudying, isPaused: $isPaused, allowMic: $allowMic, allowCamera: $allowCamera)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RoomModel &&
        other.id == id &&
        other.meetingId == meetingId &&
        other.name == name &&
        other.bannerColor == bannerColor &&
        other.fileUrl == fileUrl &&
        other.fileType == fileType &&
        other.description == description &&
        listEquals(other.tags, tags) &&
        other.maxParticipants == maxParticipants &&
        other.curParticipants == curParticipants &&
        other.hostPhotoUrl == hostPhotoUrl &&
        other.hostUid == hostUid &&
        other.roomTimerSessionNo == roomTimerSessionNo &&
        other.roomTimerDuration == roomTimerDuration &&
        other.roomTimerBreaktime == roomTimerBreaktime &&
        other.roomTimerStart == roomTimerStart &&
        other.isStudying == isStudying &&
        other.isPaused == isPaused &&
        other.allowMic == allowMic &&
        other.allowCamera == allowCamera;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        meetingId.hashCode ^
        name.hashCode ^
        bannerColor.hashCode ^
        fileUrl.hashCode ^
        fileType.hashCode ^
        description.hashCode ^
        tags.hashCode ^
        maxParticipants.hashCode ^
        curParticipants.hashCode ^
        hostPhotoUrl.hashCode ^
        hostUid.hashCode ^
        roomTimerSessionNo.hashCode ^
        roomTimerDuration.hashCode ^
        roomTimerBreaktime.hashCode ^
        roomTimerStart.hashCode ^
        isStudying.hashCode ^
        isPaused.hashCode ^
        allowMic.hashCode ^
        allowCamera.hashCode;
  }
}
