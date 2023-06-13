// ignore_for_file: public_member_api_docs, sort_constructors_first

class Message {
  String? id;
  final String text;
  final String senderId;
  final String senderName;
  final String senderPhotoURL;
  final String createdAt;
  final String type;
  String? noteId;

  Message({
    this.id,
    required this.text,
    required this.senderId,
    required this.senderName,
    required this.senderPhotoURL,
    required this.createdAt,
    required this.type,
    required this.noteId,
  });

  Message copyWith({
    String? id,
    String? text,
    String? senderId,
    String? senderName,
    String? senderPhotoURL,
    String? createdAt,
    String? type,
    String? noteId,
  }) {
    return Message(
      id: id ?? this.id,
      text: text ?? this.text,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderPhotoURL: senderPhotoURL ?? this.senderPhotoURL,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      noteId: noteId ?? this.noteId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'senderId': senderId,
      'senderName': senderName,
      'senderPhotoURL': senderPhotoURL,
      'createdAt': createdAt,
      'type': type,
      'noteId': noteId,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      text: map['text'] ?? '',
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? '',
      senderPhotoURL: map['senderPhotoURL'] ?? '',
      createdAt: map['createdAt'] ?? '',
      type: map['type'] ?? '',
      noteId: map['noteId'],
    );
  }

  @override
  String toString() {
    return 'Message(id: $id, text: $text, senderId: $senderId, senderName: $senderName, senderPhotoURL: $senderPhotoURL, createdAt: $createdAt, type: $type, noteId: $noteId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Message &&
        other.id == id &&
        other.text == text &&
        other.senderId == senderId &&
        other.senderName == senderName &&
        other.senderPhotoURL == senderPhotoURL &&
        other.createdAt == createdAt &&
        other.type == type &&
        other.noteId == noteId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        text.hashCode ^
        senderId.hashCode ^
        senderName.hashCode ^
        senderPhotoURL.hashCode ^
        createdAt.hashCode ^
        type.hashCode ^
        noteId.hashCode;
  }
}
