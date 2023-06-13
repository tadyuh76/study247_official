class File {
  final String url;
  final String type;
  File({
    required this.url,
    required this.type,
  });

  File copyWith({
    String? url,
    String? type,
  }) {
    return File(
      url: url ?? this.url,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'type': type,
    };
  }

  factory File.fromMap(Map<String, dynamic> map) {
    return File(
      url: map['url'] ?? '',
      type: map['type'] ?? '',
    );
  }

  @override
  String toString() => 'File(url: $url, type: $type)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is File && other.url == url && other.type == type;
  }

  @override
  int get hashCode => url.hashCode ^ type.hashCode;
}
