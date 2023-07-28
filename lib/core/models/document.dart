import 'package:study247/features/document/widgets/study_mode_dialog.dart';

class Document {
  String? id;
  final String title;
  final String text;
  final String lastEdit;
  final String color;
  final String folderName;
  final String studyMode;

  String get formattedStudyMode => studyMode == StudyMode.longterm.name
      ? "Ghi nhớ dài hạn"
      : "Ôn tập nước rút";

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
    required this.studyMode,
  });

  Document copyWith({
    String? id,
    String? title,
    String? text,
    String? lastEdit,
    String? color,
    String? folderName,
    String? studyMode,
  }) {
    return Document(
      id: id ?? this.id,
      title: title ?? this.title,
      text: text ?? this.text,
      lastEdit: lastEdit ?? this.lastEdit,
      color: color ?? this.color,
      folderName: folderName ?? this.folderName,
      studyMode: studyMode ?? this.studyMode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'text': text,
      'lastEdit': lastEdit,
      'color': color,
      'folderName': folderName,
      'studyMode': studyMode,
    };
  }

  factory Document.fromMap(Map<String, dynamic> map) {
    return Document(
      id: map['id'],
      title: map['title'] ?? '',
      text: map['text'] ?? '',
      lastEdit: map['lastEdit'] ?? '',
      color: map['color'] ?? '',
      folderName: map['folderName'] ?? '',
      studyMode: map['studyMode'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Document(id: $id, title: $title, text: $text, lastEdit: $lastEdit, color: $color, folderName: $folderName, studyMode: $studyMode)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Document &&
        other.id == id &&
        other.title == title &&
        other.text == text &&
        other.lastEdit == lastEdit &&
        other.color == color &&
        other.folderName == folderName &&
        other.studyMode == studyMode;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        text.hashCode ^
        lastEdit.hashCode ^
        color.hashCode ^
        folderName.hashCode ^
        studyMode.hashCode;
  }
}
