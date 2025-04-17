import 'package:business_application/data/posts/topic_models.dart';
import 'package:business_application/data/user/user_models.dart';

class Posts {
    int? id;
    String? content;
    String? image;
    String? videoUrl;
    int? groupId;
    int? commentsCount;
    User? user;
    Topic? topic;
    bool? isLiked;
    bool? isSaved;
    DateTime? createdAt;
    DateTime? updatedAt;

    Posts({
        this.id,
        this.content,
        this.image,
        this.videoUrl,
        this.groupId,
        this.commentsCount,
        this.user,
        this.topic,
        this.isLiked,
        this.isSaved,
        this.createdAt,
        this.updatedAt,
    });

    factory Posts.fromJson(Map<String, dynamic> json) => Posts(
        id: json["id"],
        content: json["content"],
        image: json["image"],
        videoUrl: json["video_url"],
        groupId: json["group_id"],
        commentsCount: json["comments_count"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        topic: json["topic"] == null ? null : Topic.fromJson(json["topic"]),
        isLiked: json["is_liked"],
        isSaved: json["is_saved"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "content": content,
        "image": image,
        "video_url": videoUrl,
        "group_id": groupId,
        "comments_count": commentsCount,
        "user": user?.toJson(),
        "topic": topic?.toJson(),
        "is_liked": isLiked,
        "is_saved": isSaved,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}