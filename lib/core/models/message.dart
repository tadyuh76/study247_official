class Message {
  final String? id;
  final String text;
  final String senderId;
  final String senderName;
  final String senderPhotoURL;
  final String createdAt;
  final String type;
  final String? noteId;
  final String? replyingName;
  final String? replyingPhotoURL;
  final String? replyingText;

  Message({
    this.id,
    required this.text,
    required this.senderId,
    required this.senderName,
    required this.senderPhotoURL,
    required this.createdAt,
    required this.type,
    required this.noteId,
    this.replyingName,
    this.replyingPhotoURL,
    this.replyingText,
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
    String? replyingName,
    String? replyingPhotoURL,
    String? replyingText,
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
      replyingName: replyingName ?? this.replyingName,
      replyingPhotoURL: replyingPhotoURL ?? this.replyingPhotoURL,
      replyingText: replyingText ?? this.replyingText,
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
      'replyingName': replyingName,
      'replyingPhotoURL': replyingPhotoURL,
      'replyingText': replyingText,
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
      replyingName: map['replyingName'],
      replyingPhotoURL: map['replyingPhotoURL'],
      replyingText: map['replyingText'],
    );
  }

  @override
  String toString() {
    return 'Message(id: $id, text: $text, senderId: $senderId, senderName: $senderName, senderPhotoURL: $senderPhotoURL, createdAt: $createdAt, type: $type, noteId: $noteId, replyingName: $replyingName, replyingPhotoURL: $replyingPhotoURL, replyingText: $replyingText)';
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
        other.noteId == noteId &&
        other.replyingName == replyingName &&
        other.replyingPhotoURL == replyingPhotoURL &&
        other.replyingText == replyingText;
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
        noteId.hashCode ^
        replyingName.hashCode ^
        replyingPhotoURL.hashCode ^
        replyingText.hashCode;
  }
}
