class SessionGoal {
  final String text;
  bool completed;

  SessionGoal({
    required this.text,
    required this.completed,
  });

  void doneTask() {
    completed = !completed;
  }

  SessionGoal copyWith({
    String? text,
    bool? completed,
  }) {
    return SessionGoal(
      text: text ?? this.text,
      completed: completed ?? this.completed,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'completed': completed,
    };
  }

  factory SessionGoal.fromMap(Map<String, dynamic> map) {
    return SessionGoal(
      text: map['text'] as String,
      completed: map['completed'] as bool,
    );
  }

  @override
  String toString() => 'Goal(text: $text, completed: $completed)';

  @override
  bool operator ==(covariant SessionGoal other) {
    if (identical(this, other)) return true;

    return other.text == text && other.completed == completed;
  }

  @override
  int get hashCode => text.hashCode ^ completed.hashCode;
}
