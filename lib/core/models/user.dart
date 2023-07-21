import 'package:flutter/foundation.dart';

class UserModel {
  final String uid;
  final String displayName;
  final String email;
  final String photoURL;
  final int currentStreak;
  final int longestStreak;
  final int masteryLevel;
  final List<String> badges;
  final Map<String, Map<String, List<int>>> commitBoard;
  final int totalStudyTime;

  UserModel({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.photoURL,
    required this.currentStreak,
    required this.longestStreak,
    required this.masteryLevel,
    required this.badges,
    required this.commitBoard,
    required this.totalStudyTime,
  });

  UserModel copyWith(
      {String? uid,
      String? displayName,
      String? email,
      String? photoURL,
      int? currentStreak,
      int? longestStreak,
      int? masteryLevel,
      List<String>? badges,
      Map<String, Map<String, List<int>>>? commitBoard,
      int? totalStudyTime}) {
    return UserModel(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoURL: photoURL ?? this.photoURL,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      masteryLevel: masteryLevel ?? this.masteryLevel,
      badges: badges ?? this.badges,
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
      'commitBoard': commitBoard,
      'totalStudyTime': totalStudyTime,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    Map<String, dynamic> temp = map['commitBoard'];
    Map<String, Map<String, List<int>>> commitBoard = {};
    // try {
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
    // } catch (e) {
    //   print('error user from map: $e');
    // }

    return UserModel(
      uid: map['uid'] ?? '',
      displayName: map['displayName'] ?? '',
      email: map['email'] ?? '',
      photoURL: map['photoURL'] ?? '',
      currentStreak: map['currentStreak']?.toInt() ?? 0,
      longestStreak: map['longestStreak']?.toInt() ?? 0,
      masteryLevel: map['masteryLevel']?.toInt() ?? 0,
      badges: (map['badges'] as List).map((e) => e.toString()).toList(),
      commitBoard: commitBoard,
      totalStudyTime: map['totalStudyTime'],
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, displayName: $displayName, email: $email, photoURL: $photoURL, currentStreak: $currentStreak, longestStreak: $longestStreak, masteryLevel: $masteryLevel, badges: $badges, commitBoard: $commitBoard, totalStudyTime: $totalStudyTime)';
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
        commitBoard.hashCode ^
        totalStudyTime.hashCode;
  }
}
