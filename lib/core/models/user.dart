import 'package:flutter/foundation.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/utils/days_in_month.dart';

enum UserStatus { active, inactive, studyingSolo, studyingGroup }

final userStatusColors = {
  UserStatus.active.name: Palette.complete,
  UserStatus.studyingGroup.name: Palette.primary,
  UserStatus.studyingSolo.name: Palette.warning,
  UserStatus.inactive.name: Palette.darkGrey,
};

final userStatusTitles = {
  UserStatus.active.name: "Đang hoat động",
  UserStatus.studyingGroup.name: "Đang trong phòng học nhóm",
  UserStatus.studyingSolo.name: "Đang trong phòng học cá nhân",
  UserStatus.inactive.name: "Không hoạt động",
};

class UserModel {
  final String uid;
  final String displayName;
  final String email;
  final String photoURL;
  final int currentStreak;
  final int longestStreak;
  final String status;
  final String studyingRoomId;
  final String studyingMeetingId;
  final int totalStudyTime;
  final int totalActiveDays;
  final List<String> friends;
  final List<String> friendRequests;
  final List<String> badges;
  final Map<String, Map<String, List<int>>> commitBoard;

  int getMonthStudyTime({int? month, int? year}) {
    final now = DateTime.now();
    month ??= now.month;
    year ??= now.year;

    return commitBoard[year.toString()]![month.toString()]!
        .fold(0, (previousValue, element) => previousValue + element);
  }

  int getMasteryLevel({int? month, int? year}) {
    final now = DateTime.now();
    month ??= now.month;
    year ??= now.year;

    final studyTime = getMonthStudyTime(month: month, year: year);
    for (int i = minutesToMastery.length - 1; i >= 0; i--) {
      if (studyTime >= minutesToMastery[i]) {
        return i;
      }
    }
    return 0;
  }

  bool isFriendWith(String friendId) {
    return friends.contains(friendId);
  }

  bool isFriendRequestPending(String friendId) {
    return friendRequests.contains(friendId);
  }

  UserModel({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.photoURL,
    required this.currentStreak,
    required this.longestStreak,
    required this.status,
    required this.studyingRoomId,
    required this.studyingMeetingId,
    required this.badges,
    required this.friends,
    required this.friendRequests,
    required this.commitBoard,
    required this.totalStudyTime,
    required this.totalActiveDays,
  });

  factory UserModel.empty({
    String? uid,
    String? displayName,
    String? email,
    String? photoURL,
  }) {
    final thisYear = DateTime.now().year;

    return UserModel(
      uid: uid ?? "",
      displayName: displayName ?? "Khách",
      email: email ?? "",
      photoURL: photoURL ?? "",
      currentStreak: 0,
      longestStreak: 0,
      totalStudyTime: 0,
      totalActiveDays: 0,
      status: UserStatus.active.name,
      studyingRoomId: "",
      studyingMeetingId: "",
      badges: [],
      friends: [],
      friendRequests: [],
      commitBoard: {
        thisYear.toString(): {
          for (int month in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12])
            month.toString():
                List.generate(daysInMonth(month, thisYear), (_) => 0)
        }
      },
    );
  }

  UserModel copyWith(
      {String? uid,
      String? displayName,
      String? email,
      String? photoURL,
      int? currentStreak,
      int? longestStreak,
      int? masteryLevel,
      List<String>? badges,
      String? status,
      List<String>? friends,
      List<String>? friendRequests,
      String? studyingRoomId,
      String? studyingMeetingId,
      Map<String, Map<String, List<int>>>? commitBoard,
      int? totalStudyTime,
      int? totalActiveDays}) {
    return UserModel(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoURL: photoURL ?? this.photoURL,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      badges: badges ?? this.badges,
      status: status ?? this.status,
      studyingRoomId: studyingRoomId ?? this.studyingRoomId,
      studyingMeetingId: studyingMeetingId ?? this.studyingMeetingId,
      friends: friends ?? this.friends,
      friendRequests: friendRequests ?? this.friendRequests,
      commitBoard: commitBoard ?? this.commitBoard,
      totalStudyTime: totalStudyTime ?? this.totalStudyTime,
      totalActiveDays: totalActiveDays ?? this.totalActiveDays,
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
      'badges': badges,
      'status': status,
      'friends': friends,
      'friendRequests': friendRequests,
      'studyingRoomId': studyingRoomId,
      'studyingMeetingId': studyingMeetingId,
      'commitBoard': commitBoard,
      'totalStudyTime': totalStudyTime,
      'totalActiveDays': totalActiveDays,
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
      badges: (map['badges'] as List).map((e) => e.toString()).toList(),
      friends: (map['friends'] as List).map((e) => e.toString()).toList(),
      friendRequests:
          (map['friendRequests'] as List).map((e) => e.toString()).toList(),
      status: map['status'] ?? UserStatus.active.name,
      studyingRoomId: map['studyingRoomId'] ?? '',
      studyingMeetingId: map['studyingMeetingId'] ?? '',
      commitBoard: commitBoard,
      totalStudyTime: map['totalStudyTime'] ?? 0,
      totalActiveDays: map['totalActiveDays'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, displayName: $displayName, email: $email, photoURL: $photoURL, currentStreak: $currentStreak, longestStreak: $longestStreak, badges: $badges, status: $status, friends: $friends, friendRequests: $friendRequests, studyingRoomId: $studyingRoomId, studyingMeetingId: $studyingMeetingId commitBoard: $commitBoard, totalStudyTime: $totalStudyTime, totalActiveDays: $totalActiveDays)';
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
        other.status == status &&
        other.studyingRoomId == studyingRoomId &&
        other.studyingMeetingId == studyingMeetingId &&
        other.friends == friends &&
        other.friendRequests == friendRequests &&
        listEquals(other.badges, badges) &&
        mapEquals(other.commitBoard, commitBoard) &&
        other.totalStudyTime == totalStudyTime &&
        other.totalActiveDays == totalActiveDays;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        displayName.hashCode ^
        email.hashCode ^
        photoURL.hashCode ^
        currentStreak.hashCode ^
        longestStreak.hashCode ^
        badges.hashCode ^
        friends.hashCode ^
        friendRequests.hashCode ^
        status.hashCode ^
        studyingRoomId.hashCode ^
        studyingMeetingId.hashCode ^
        commitBoard.hashCode ^
        totalStudyTime.hashCode ^
        totalActiveDays.hashCode;
  }
}
