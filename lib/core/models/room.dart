// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

class Room {
  String? id;
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

  Room({
    this.id,
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
  });

  factory Room.empty() {
    return Room(
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
    );
  }

  Room copyWith({
    String? id,
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
  }) {
    return Room(
      id: id ?? this.id,
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
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
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
    };
  }

  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      id: map['id'],
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
    );
  }

  @override
  String toString() {
    return 'Room(id: $id, name: $name, bannerColor: $bannerColor, fileUrl: $fileUrl, fileType: $fileType, description: $description, tags: $tags, maxParticipants: $maxParticipants, curParticipants: $curParticipants, hostPhotoUrl: $hostPhotoUrl, hostUid: $hostUid, roomTimerSessionNo: $roomTimerSessionNo, roomTimerDuration: $roomTimerDuration, roomTimerBreaktime: $roomTimerBreaktime, roomTimerStart: $roomTimerStart, isStudying: $isStudying, isPaused: $isPaused)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Room &&
        other.id == id &&
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
        other.isPaused == isPaused;
  }

  @override
  int get hashCode {
    return id.hashCode ^
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
        isPaused.hashCode;
  }
}
