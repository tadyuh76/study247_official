class Goal {
  final String text;
  bool completed;

  Goal({
    required this.text,
    required this.completed,
  });

  void doneTask() {
    completed = !completed;
  }

  Goal copyWith({
    String? text,
    bool? completed,
  }) {
    return Goal(
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

  factory Goal.fromMap(Map<String, dynamic> map) {
    return Goal(
      text: map['text'] as String,
      completed: map['completed'] as bool,
    );
  }

  @override
  String toString() => 'Goal(text: $text, completed: $completed)';

  @override
  bool operator ==(covariant Goal other) {
    if (identical(this, other)) return true;

    return other.text == text && other.completed == completed;
  }

  @override
  int get hashCode => text.hashCode ^ completed.hashCode;
}
