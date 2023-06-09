// ignore_for_file: public_member_api_docs, sort_constructors_first

class Flashcard {
  String? id;
  final String front;
  final String back;
  final int ease;
  final int currentInterval;
  final String title;
  final String noteName;
  final String folderName;

  Flashcard({
    this.id,
    required this.front,
    required this.back,
    required this.ease,
    required this.currentInterval,
    required this.title,
    required this.noteName,
    required this.folderName,
  });

  Flashcard copyWith({
    String? id,
    String? front,
    String? back,
    int? ease,
    int? currentInterval,
    String? title,
    String? noteName,
    String? folderName,
  }) {
    return Flashcard(
      id: id ?? this.id,
      front: front ?? this.front,
      back: back ?? this.back,
      ease: ease ?? this.ease,
      currentInterval: currentInterval ?? this.currentInterval,
      title: title ?? this.title,
      noteName: noteName ?? this.noteName,
      folderName: folderName ?? this.folderName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'front': front,
      'back': back,
      'ease': ease,
      'currentInterval': currentInterval,
      'title': title,
      'noteName': noteName,
      'folderName': folderName,
    };
  }

  factory Flashcard.fromMap(Map<String, dynamic> map) {
    return Flashcard(
      id: map['id'] != null ? map['id'] as String : null,
      front: map['front'] as String,
      back: map['back'] as String,
      ease: map['ease'] as int,
      currentInterval: map['currentInterval'] as int,
      title: map['title'] as String,
      noteName: map['noteName'] as String,
      folderName: map['folderName'] as String,
    );
  }

  @override
  String toString() {
    return 'Flashcard(id: $id, front: $front, back: $back, ease: $ease, currentInterval: $currentInterval, title: $title, noteName: $noteName, folderName: $folderName)';
  }

  @override
  bool operator ==(covariant Flashcard other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.front == front &&
        other.back == back &&
        other.ease == ease &&
        other.currentInterval == currentInterval &&
        other.title == title &&
        other.noteName == noteName &&
        other.folderName == folderName;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        front.hashCode ^
        back.hashCode ^
        ease.hashCode ^
        currentInterval.hashCode ^
        title.hashCode ^
        noteName.hashCode ^
        folderName.hashCode;
  }
}
