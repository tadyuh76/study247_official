class Flashcard {
  String? id;
  final String front;
  final String back;
  final String title;
  final String documentName;
  final String type;
  final String revisableAfter;
  final double ease;
  final double currentInterval;
  final double priorityRate;
  final int level;

  Flashcard({
    this.id,
    required this.front,
    required this.back,
    required this.title,
    required this.documentName,
    required this.type,
    required this.revisableAfter,
    required this.ease,
    required this.currentInterval,
    required this.priorityRate,
    required this.level,
  });

  Flashcard copyWith({
    String? id,
    String? front,
    String? back,
    String? title,
    String? documentName,
    String? type,
    String? revisableAfter,
    double? ease,
    double? currentInterval,
    double? priorityRate,
    int? level,
  }) {
    return Flashcard(
      id: id ?? this.id,
      front: front ?? this.front,
      back: back ?? this.back,
      title: title ?? this.title,
      documentName: documentName ?? this.documentName,
      type: type ?? this.type,
      revisableAfter: revisableAfter ?? this.revisableAfter,
      ease: ease ?? this.ease,
      currentInterval: currentInterval ?? this.currentInterval,
      priorityRate: priorityRate ?? this.priorityRate,
      level: level ?? this.level,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'front': front,
      'back': back,
      'title': title,
      'documentName': documentName,
      'type': type,
      'revisableAfter': revisableAfter,
      'ease': ease,
      'currentInterval': currentInterval,
      'priorityRate': priorityRate,
      'level': level,
    };
  }

  factory Flashcard.fromMap(Map<String, dynamic> map) {
    return Flashcard(
      id: map['id'],
      front: map['front'] ?? '',
      back: map['back'] ?? '',
      title: map['title'] ?? '',
      documentName: map['documentName'] ?? '',
      type: map['type'] ?? '',
      revisableAfter: map['revisableAfter'] ?? '',
      ease: map['ease']?.toDouble() ?? 0.0,
      currentInterval: map['currentInterval']?.toDouble() ?? 0.0,
      priorityRate: map['priorityRate']?.toDouble() ?? 0.0,
      level: map['level']?.toInt() ?? 0,
    );
  }

  @override
  String toString() {
    return 'Flashcard(id: $id, front: $front, back: $back, title: $title, documentName: $documentName, type: $type, revisableAfter: $revisableAfter, ease: $ease, currentInterval: $currentInterval, priorityRate: $priorityRate, level: $level)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Flashcard &&
        other.id == id &&
        other.front == front &&
        other.back == back &&
        other.title == title &&
        other.documentName == documentName &&
        other.type == type &&
        other.revisableAfter == revisableAfter &&
        other.ease == ease &&
        other.currentInterval == currentInterval &&
        other.priorityRate == priorityRate &&
        other.level == level;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        front.hashCode ^
        back.hashCode ^
        title.hashCode ^
        documentName.hashCode ^
        type.hashCode ^
        revisableAfter.hashCode ^
        ease.hashCode ^
        currentInterval.hashCode ^
        priorityRate.hashCode ^
        level.hashCode;
  }
}
