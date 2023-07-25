import 'package:flutter/foundation.dart';

enum UserStatus { active, inactive, studyingSolo, studyingGroup }

class UserModel {
  final String uid;
  final String displayName;
  final String email;
  final String photoURL;
  final int currentStreak;
  final int longestStreak;
  final int masteryLevel;
  final String status;
  final String studyingRoomId;
  final int totalStudyTime;
  final List<String> friends;
  final List<String> badges;
  final Map<String, Map<String, List<int>>> commitBoard;

  DateTime get _now => DateTime.now();
  int get monthStudyTime =>
      commitBoard[_now.year.toString()]![_now.month.toString()]!
          .fold(0, (previousValue, element) => previousValue + element);

  bool isFriendWith(String friendId) {
    return friends.contains(friendId);
  }

  UserModel({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.photoURL,
    required this.currentStreak,
    required this.longestStreak,
    required this.masteryLevel,
    required this.status,
    required this.studyingRoomId,
    required this.badges,
    required this.friends,
    required this.commitBoard,
    required this.totalStudyTime,
  });

  UserModel copyWith({
    String? uid,
    String? displayName,
    String? email,
    String? photoURL,
    int? currentStreak,
    int? longestStreak,
    int? masteryLevel,
    List<String>? badges,
    String? status,
    List<String>? friends,
    String? studyingRoomId,
    Map<String, Map<String, List<int>>>? commitBoard,
    int? totalStudyTime,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoURL: photoURL ?? this.photoURL,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      masteryLevel: masteryLevel ?? this.masteryLevel,
      badges: badges ?? this.badges,
      status: status ?? this.status,
      studyingRoomId: studyingRoomId ?? this.studyingRoomId,
      friends: friends ?? this.friends,
      commitBoard: commitBoard ?? this.commitBoard,
      totalStudyTime: totalStudyTime ?? this.totalStudyTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'photoURL': photoURL,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'masteryLevel': masteryLevel,
      'badges': badges,
      'status': status,
      'friends': friends,
      'studyingRoomId': studyingRoomId,
      'commitBoard': commitBoard,
      'totalStudyTime': totalStudyTime,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    Map<String, dynamic> temp = map['commitBoard'];
    Map<String, Map<String, List<int>>> commitBoard = {};

    for (final year in temp.entries) {
      final Map<String, List<int>> monthBoard = {};

      for (final month in year.value.entries) {
        monthBoard.putIfAbsent(
          month.key,
          () => month.value.cast<int>(),
        );
      }

      commitBoard.putIfAbsent(year.key, () => monthBoard);
    }

    return UserModel(
      uid: map['uid'] ?? '',
      displayName: map['displayName'] ?? '',
      email: map['email'] ?? '',
      photoURL: map['photoURL'] ?? '',
      currentStreak: map['currentStreak']?.toInt() ?? 0,
      longestStreak: map['longestStreak']?.toInt() ?? 0,
      masteryLevel: map['masteryLevel']?.toInt() ?? 0,
      badges: (map['badges'] as List).map((e) => e.toString()).toList(),
      friends: (map['friends'] as List).map((e) => e.toString()).toList(),
      status: map['status'] ?? UserStatus.active.name,
      studyingRoomId: map['studyingRoomId'] ?? '',
      commitBoard: commitBoard,
      totalStudyTime: map['totalStudyTime'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, displayName: $displayName, email: $email, photoURL: $photoURL, currentStreak: $currentStreak, longestStreak: $longestStreak, masteryLevel: $masteryLevel, badges: $badges, status: $status, friends: $friends, studyingRoomId: $studyingRoomId, commitBoard: $commitBoard, totalStudyTime: $totalStudyTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.uid == uid &&
        other.displayName == displayName &&
        other.email == email &&
        other.photoURL == photoURL &&
        other.currentStreak == currentStreak &&
        other.longestStreak == longestStreak &&
        other.masteryLevel == masteryLevel &&
        other.status == status &&
        other.studyingRoomId == studyingRoomId &&
        other.friends == friends &&
        listEquals(other.badges, badges) &&
        mapEquals(other.commitBoard, commitBoard) &&
        other.totalStudyTime == totalStudyTime;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        displayName.hashCode ^
        email.hashCode ^
        photoURL.hashCode ^
        currentStreak.hashCode ^
        longestStreak.hashCode ^
        masteryLevel.hashCode ^
        badges.hashCode ^
        friends.hashCode ^
        status.hashCode ^
        studyingRoomId.hashCode ^
        commitBoard.hashCode ^
        totalStudyTime.hashCode;
  }
}
