class Post {
  final int id;
  final String title;
  final String content;
  final String status;
  final int commentsCount;
  final int likesCount;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.status,
    required this.commentsCount,
    required this.likesCount,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      status: json['status'],
      commentsCount: json['comments_count'],
      likesCount: json['likes_count'],
      userId: json['user_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
