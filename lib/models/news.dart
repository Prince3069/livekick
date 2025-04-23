// lib/models/news.dart
class News {
  final String id;
  final String title;
  final String imageUrl;
  final DateTime publishedAt;
  final String? content;

  News({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.publishedAt,
    this.content,
  });

  factory News.fromMap(Map<String, dynamic> map) {
    return News(
      id: map['id'],
      title: map['title'],
      imageUrl: map['imageUrl'],
      publishedAt: DateTime.parse(map['publishedAt']),
      content: map['content'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'publishedAt': publishedAt.toIso8601String(),
      'content': content,
    };
  }
}
