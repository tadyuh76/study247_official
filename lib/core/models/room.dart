// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

class Room {
  String? id;
  final String name;
  final String bannerColor;
  final String fileUrl;
  final String fileType;
  final String description;
  final String pomodoroType;
  final String pomodoroDuration;
  final List<dynamic> tags;
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
    required this.pomodoroType,
    required this.pomodoroDuration,
    required this.tags,
    required this.maxParticipants,
    required this.curParticipants,
    required this.hostPhotoUrl,
    required this.hostUid,
  });

  Room copyWith({
    String? id,
    String? name,
    String? bannerColor,
    String? fileUrl,
    String? fileType,
    String? description,
    String? pomodoroType,
    String? pomodoroDuration,
    List<dynamic>? tags,
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
      pomodoroType: pomodoroType ?? this.pomodoroType,
      pomodoroDuration: pomodoroDuration ?? this.pomodoroDuration,
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
      'pomodoroType': pomodoroType,
      'pomodoroDuration': pomodoroDuration,
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
      pomodoroType: map['pomodoroType'] as String,
      pomodoroDuration: map['pomodoroDuration'] as String,
      tags: List<dynamic>.from((map['tags'] as List<dynamic>)),
      maxParticipants: map['maxParticipants'] as int,
      curParticipants: map['curParticipants'] as int,
      hostPhotoUrl: map['hostPhotoUrl'] as String,
      hostUid: map['hostUid'] as String,
    );
  }

  @override
  String toString() {
    return 'Room(id: $id, name: $name, bannerColor: $bannerColor, fileUrl: $fileUrl, fileType: $fileType, description: $description, pomodoroType: $pomodoroType, pomodoroDuration: $pomodoroDuration, tags: $tags, maxParticipants: $maxParticipants, curParticipants: $curParticipants, hostPhotoUrl: $hostPhotoUrl, hostUid: $hostUid)';
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
        other.pomodoroType == pomodoroType &&
        other.pomodoroDuration == pomodoroDuration &&
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
        pomodoroType.hashCode ^
        pomodoroDuration.hashCode ^
        tags.hashCode ^
        maxParticipants.hashCode ^
        curParticipants.hashCode ^
        hostPhotoUrl.hashCode ^
        hostUid.hashCode;
  }
}
