// ignore_for_file: public_member_api_docs, sort_constructors_first

class Document {
  String? id;
  final String title;
  final String text;
  final String lastEdit;
  final String color;
  final String folderName;

  String get formattedLastEdit {
    final lastEditTime = DateTime.parse(lastEdit);

    final lastEditHour = lastEditTime.hour.toString().padLeft(2, "0");
    final lastEditMinute = lastEditTime.minute.toString().padLeft(2, "0");

    final lastEditDay =
        "${lastEditTime.day}/${lastEditTime.month}/${lastEditTime.year}";

    return "$lastEditHour:$lastEditMinute - $lastEditDay";
  }

  Document({
    this.id,
    required this.title,
    required this.text,
    required this.lastEdit,
    required this.color,
    required this.folderName,
  });

  Document copyWith({
    String? id,
    String? title,
    String? text,
    String? lastEdit,
    String? color,
    String? folderName,
  }) {
    return Document(
      id: id ?? this.id,
      title: title ?? this.title,
      text: text ?? this.text,
      lastEdit: lastEdit ?? this.lastEdit,
      color: color ?? this.color,
      folderName: folderName ?? this.folderName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'text': text,
      'lastEdit': lastEdit,
      'color': color,
      'folderName': folderName,
    };
  }

  factory Document.fromMap(Map<String, dynamic> map) {
    return Document(
      id: map['id'] != null ? map['id'] as String : null,
      title: map['title'] as String,
      text: map['text'] as String,
      lastEdit: map['lastEdit'] as String,
      color: map['color'] as String,
      folderName: map['folderName'] as String,
    );
  }

  @override
  String toString() {
    return 'Note(id: $id, title: $title, text: $text, lastEdit: $lastEdit, color: $color, folderName: $folderName)';
  }

  @override
  bool operator ==(covariant Document other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.text == text &&
        other.lastEdit == lastEdit &&
        other.color == color &&
        other.folderName == folderName;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        text.hashCode ^
        lastEdit.hashCode ^
        color.hashCode ^
        folderName.hashCode;
  }
}
