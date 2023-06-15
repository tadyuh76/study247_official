class Flashcard {
  String? id;
  final String front;
  final String back;
  final double ease;
  final double currentInterval;
  final String title;
  final String documentName;

  Flashcard({
    this.id,
    required this.front,
    required this.back,
    required this.ease,
    required this.currentInterval,
    required this.title,
    required this.documentName,
  });

  Flashcard copyWith(
      {String? id,
      String? front,
      String? back,
      double? ease,
      double? currentInterval,
      String? title,
      String? documentName}) {
    return Flashcard(
      id: id ?? this.id,
      front: front ?? this.front,
      back: back ?? this.back,
      ease: ease ?? this.ease,
      currentInterval: currentInterval ?? this.currentInterval,
      title: title ?? this.title,
      documentName: documentName ?? this.documentName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'front': front,
      'back': back,
      'ease': ease,
      'currentInterval': currentInterval,
      'title': title,
      'documentName': documentName,
    };
  }

  factory Flashcard.fromMap(Map<String, dynamic> map) {
    return Flashcard(
      id: map['id'],
      front: map['front'] ?? '',
      back: map['back'] ?? '',
      ease: map['ease']?.toDouble() ?? 0.0,
      currentInterval: map['currentInterval']?.toDouble() ?? 0.0,
      title: map['title'] ?? '',
      documentName: map['documentName'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Flashcard(id: $id, front: $front, back: $back, ease: $ease, currentInterval: $currentInterval, title: $title, documentName: $documentName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Flashcard &&
        other.id == id &&
        other.front == front &&
        other.back == back &&
        other.ease == ease &&
        other.currentInterval == currentInterval &&
        other.title == title &&
        other.documentName == documentName;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        front.hashCode ^
        back.hashCode ^
        ease.hashCode ^
        currentInterval.hashCode ^
        title.hashCode ^
        documentName.hashCode;
  }
}
