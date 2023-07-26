import 'package:study247/constants/badge.dart';

class BadgeModel {
  final String name;
  final String title;
  final String description;
  final String timestamp;

  BadgeModel({
    required this.name,
    required this.title,
    required this.description,
    required this.timestamp,
  });

  factory BadgeModel.fromBadgeName(String badgeName, [DateTime? timestamp]) {
    return BadgeModel(
      name: badgeName,
      title: badgeTitles[badgeName]!,
      description: badgeDescriptions[badgeName]!,
      timestamp:
          timestamp != null ? timestamp.toString() : DateTime.now().toString(),
    );
  }

  BadgeModel copyWith({
    String? name,
    String? title,
    String? timestamp,
    String? description,
  }) {
    return BadgeModel(
      name: name ?? this.name,
      title: title ?? this.title,
      timestamp: timestamp ?? this.timestamp,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'title': title,
      'timestamp': timestamp,
      'description': description,
    };
  }

  factory BadgeModel.fromMap(Map<String, dynamic> map) {
    return BadgeModel(
      name: map['name'] ?? '',
      title: map['title'] ?? '',
      timestamp: map['timestamp'] ?? '',
      description: map['description'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Badge(name: $name, title: $title, timestamp: $timestamp, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BadgeModel &&
        other.name == name &&
        other.title == title &&
        other.timestamp == timestamp &&
        other.description == description;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        title.hashCode ^
        timestamp.hashCode ^
        description.hashCode;
  }
}
