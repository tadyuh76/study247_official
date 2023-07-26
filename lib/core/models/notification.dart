/// Type of the notification.
///
/// [friendAccept]: a friend accepted user's request
///
/// [friendRequest]: a person request to be friend with user
///
/// [newBadge]: a new badge acquired
///
/// [levelUp]: monthly level up
enum NotificationType { friendAccept, friendRequest, newBadge, levelUp }

/// Status of the notification.
///
/// [accepted]: accepted a friend request.
///
/// [rejected]: rejected a friend request.
///
/// [pending]: sent to user, but not open to see yet.
///
/// [seen]: sent to user, and user saw it.
enum NotificationStatus { accepted, rejected, pending, seen }

class Notification {
  final String type;
  final String text;
  final String timestamp;
  final String photoURL;
  final String payload; // e.g. userId
  final String status;

  Notification({
    required this.type,
    required this.text,
    required this.timestamp,
    required this.photoURL,
    required this.payload,
    required this.status,
  });

  Notification copyWith({
    String? type,
    String? text,
    String? timestamp,
    String? photoURL,
    String? payload,
    String? status,
  }) {
    return Notification(
      type: type ?? this.type,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      photoURL: photoURL ?? this.photoURL,
      payload: payload ?? this.payload,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'text': text,
      'timestamp': timestamp,
      'photoURL': photoURL,
      'payload': payload,
      'status': status,
    };
  }

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      type: map['type'] ?? '',
      text: map['text'] ?? '',
      timestamp: map['timestamp'] ?? '',
      photoURL: map['photoURL'] ?? '',
      payload: map['payload'] ?? '',
      status: map['status'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Notification(type: $type, text: $text, timestamp: $timestamp, photoURL: $photoURL, payload: $payload, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Notification &&
        other.type == type &&
        other.text == text &&
        other.timestamp == timestamp &&
        other.photoURL == photoURL &&
        other.payload == payload &&
        other.status == status;
  }

  @override
  int get hashCode {
    return type.hashCode ^
        text.hashCode ^
        timestamp.hashCode ^
        photoURL.hashCode ^
        payload.hashCode ^
        status.hashCode;
  }
}
