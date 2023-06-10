// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

class Room {
  String? id;
  final String name;
  final String bannerColor;
  final String fileUrl;
  final String fileType;
  final String description;
  final double pomodoroSessionNo;
  final double pomodoroDuration;
  final double pomodoroBreaktime;
  final List<String> tags;
  final int maxParticipants;
  final int curParticipants;
  final String hostPhotoUrl;
  final String hostUid;

  Room({
    this.id,
    required this.name,
    required this.bannerColor,
    required this.fileUrl,
    required this.fileType,
    required this.description,
    required this.pomodoroSessionNo,
    required this.pomodoroDuration,
    required this.pomodoroBreaktime,
    required this.tags,
    required this.maxParticipants,
    required this.curParticipants,
    required this.hostPhotoUrl,
    required this.hostUid,
  });

  factory Room.empty() {
    return Room(
      name: "",
      bannerColor: "blue",
      fileUrl: "",
      fileType: "",
      description: "Vào học cùng mình nhé!",
      pomodoroSessionNo: 0,
      pomodoroDuration: 50,
      pomodoroBreaktime: 10,
      tags: [],
      maxParticipants: 5,
      curParticipants: 0,
      hostPhotoUrl: "",
      hostUid: "",
    );
  }

  Room copyWith({
    String? id,
    String? name,
    String? bannerColor,
    String? fileUrl,
    String? fileType,
    String? description,
    double? pomodoroSessionNo,
    double? pomodoroDuration,
    double? pomodoroBreaktime,
    List<String>? tags,
    int? maxParticipants,
    int? curParticipants,
    String? hostPhotoUrl,
    String? hostUid,
  }) {
    return Room(
      id: id ?? this.id,
      name: name ?? this.name,
      bannerColor: bannerColor ?? this.bannerColor,
      fileUrl: fileUrl ?? this.fileUrl,
      fileType: fileType ?? this.fileType,
      description: description ?? this.description,
      pomodoroSessionNo: pomodoroSessionNo ?? this.pomodoroSessionNo,
      pomodoroDuration: pomodoroDuration ?? this.pomodoroDuration,
      pomodoroBreaktime: pomodoroBreaktime ?? this.pomodoroBreaktime,
      tags: tags ?? this.tags,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      curParticipants: curParticipants ?? this.curParticipants,
      hostPhotoUrl: hostPhotoUrl ?? this.hostPhotoUrl,
      hostUid: hostUid ?? this.hostUid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'bannerColor': bannerColor,
      'fileUrl': fileUrl,
      'fileType': fileType,
      'description': description,
      'pomodoroSessionNo': pomodoroSessionNo,
      'pomodoroDuration': pomodoroDuration,
      'pomodoroBreaktime': pomodoroBreaktime,
      'tags': tags,
      'maxParticipants': maxParticipants,
      'curParticipants': curParticipants,
      'hostPhotoUrl': hostPhotoUrl,
      'hostUid': hostUid,
    };
  }

  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] as String,
      bannerColor: map['bannerColor'] as String,
      fileUrl: map['fileUrl'] as String,
      fileType: map['fileType'] as String,
      description: map['description'] as String,
      pomodoroSessionNo: map['pomodoroSessionNo'] as double,
      pomodoroDuration: map['pomodoroDuration'] as double,
      pomodoroBreaktime: map['pomodoroBreaktime'] as double,
      tags: List<String>.from((map['tags'] as List).map((e) => e.toString())),
      maxParticipants: map['maxParticipants'] as int,
      curParticipants: map['curParticipants'] as int,
      hostPhotoUrl: map['hostPhotoUrl'] as String,
      hostUid: map['hostUid'] as String,
    );
  }

  @override
  String toString() {
    return 'Room(id: $id, name: $name, bannerColor: $bannerColor, fileUrl: $fileUrl, fileType: $fileType, description: $description, pomodoroSessionNo: $pomodoroSessionNo, pomodoroDuration: $pomodoroDuration, pomodoroBreaktime: $pomodoroBreaktime, tags: $tags, maxParticipants: $maxParticipants, curParticipants: $curParticipants, hostPhotoUrl: $hostPhotoUrl, hostUid: $hostUid)';
  }

  @override
  bool operator ==(covariant Room other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.bannerColor == bannerColor &&
        other.fileUrl == fileUrl &&
        other.fileType == fileType &&
        other.description == description &&
        other.pomodoroSessionNo == pomodoroSessionNo &&
        other.pomodoroDuration == pomodoroDuration &&
        other.pomodoroBreaktime == pomodoroBreaktime &&
        listEquals(other.tags, tags) &&
        other.maxParticipants == maxParticipants &&
        other.curParticipants == curParticipants &&
        other.hostPhotoUrl == hostPhotoUrl &&
        other.hostUid == hostUid;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        bannerColor.hashCode ^
        fileUrl.hashCode ^
        fileType.hashCode ^
        description.hashCode ^
        pomodoroSessionNo.hashCode ^
        pomodoroDuration.hashCode ^
        pomodoroBreaktime.hashCode ^
        tags.hashCode ^
        maxParticipants.hashCode ^
        curParticipants.hashCode ^
        hostPhotoUrl.hashCode ^
        hostUid.hashCode;
  }
}
