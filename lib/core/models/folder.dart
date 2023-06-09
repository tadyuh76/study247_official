// ignore_for_file: public_member_api_docs, sort_constructors_first

class Folder {
  String? id;
  final String name;
  final String color;
  final int numOfDocs;

  Folder({
    this.id,
    required this.name,
    required this.color,
    required this.numOfDocs,
  });

  Folder copyWith({
    String? id,
    String? name,
    String? color,
    int? numOfDocs,
  }) {
    return Folder(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      numOfDocs: numOfDocs ?? this.numOfDocs,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'color': color,
      'numOfDocs': numOfDocs,
    };
  }

  factory Folder.fromMap(Map<String, dynamic> map) {
    return Folder(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] as String,
      color: map['color'] as String,
      numOfDocs: map['numOfDocs'] as int,
    );
  }

  @override
  String toString() {
    return 'Folder(id: $id, name: $name, color: $color, numOfDocs: $numOfDocs)';
  }

  @override
  bool operator ==(covariant Folder other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.color == color &&
        other.numOfDocs == numOfDocs;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ color.hashCode ^ numOfDocs.hashCode;
  }
}
