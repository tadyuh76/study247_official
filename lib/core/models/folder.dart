class Folder {
  String? id;
  final String name;
  final String color;

  Folder({
    this.id,
    required this.name,
    required this.color,
  });

  Folder copyWith({
    String? id,
    String? name,
    String? color,
  }) {
    return Folder(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color,
    };
  }

  factory Folder.fromMap(Map<String, dynamic> map) {
    return Folder(
      id: map['id'],
      name: map['name'] ?? '',
      color: map['color'] ?? '',
    );
  }

  @override
  String toString() => 'Folder(id: $id, name: $name, color: $color)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Folder &&
        other.id == id &&
        other.name == name &&
        other.color == color;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ color.hashCode;
}
