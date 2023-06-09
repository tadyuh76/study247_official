// ignore_for_file: public_member_api_docs, sort_constructors_first

class Message {
  String? id;
  final String text;
  final String senderId;
  final String senderName;
  final String senderPhotoURL;
  final String createdAt;
  final String type;
  final String noteId;

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
    return <String, dynamic>{
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
      id: map['id'] != null ? map['id'] as String : null,
      text: map['text'] as String,
      senderId: map['senderId'] as String,
      senderName: map['senderName'] as String,
      senderPhotoURL: map['senderPhotoURL'] as String,
      createdAt: map['createdAt'] as String,
      type: map['type'] as String,
      noteId: map['noteId'] as String,
    );
  }

  @override
  String toString() {
    return 'Message(id: $id, text: $text, senderId: $senderId, senderName: $senderName, senderPhotoURL: $senderPhotoURL, createdAt: $createdAt, type: $type, noteId: $noteId)';
  }

  @override
  bool operator ==(covariant Message other) {
    if (identical(this, other)) return true;

    return other.id == id &&
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
