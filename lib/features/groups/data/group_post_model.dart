class GroupPost {
  final int id;
  final String content;
  final String? image;
  final String? videoUrl;
  final String createdAt;
  final User? user;
  final Topic? topic;
  final int? commentsCount;
  final bool isLiked;
  final bool isSaved;

  GroupPost({
    required this.id,
    required this.content,
    this.image,
    this.videoUrl,
    required this.createdAt,
    this.user,
    this.topic,
    this.commentsCount,
    this.isLiked = false,
    this.isSaved = false,
  });

  factory GroupPost.fromJson(Map<String, dynamic> json) {
    return GroupPost(
      id: json['id'],
      content: json['content'],
      image: json['image'],
      videoUrl: json['video_url'],
      createdAt: json['created_at'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      topic: json['topic'] != null ? Topic.fromJson(json['topic']) : null,
      commentsCount: json['comments_count'],
      isLiked: json['is_liked'] ?? false,
      isSaved: json['is_saved'] ?? false,
    );
  }
}

class User {
  final String name;
  final String avatar;
  final Rank? rank;

  User({required this.name, required this.avatar, this.rank});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      avatar: json['avatar'],
      rank: json['rank'] != null ? Rank.fromJson(json['rank']) : null,
    );
  }
}

class Rank {
  final String name;

  Rank({required this.name});

  factory Rank.fromJson(Map<String, dynamic> json) {
    return Rank(name: json['name']);
  }
}

class Topic {
  final String name;

  Topic({required this.name});

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(name: json['name']);
  }
}
