// To parse this JSON data, do
//
//     final postByIdResponseModel = postByIdResponseModelFromJson(jsonString);

import 'dart:convert';

PostByIdResponseModel postByIdResponseModelFromJson(String str) => PostByIdResponseModel.fromJson(json.decode(str));

String postByIdResponseModelToJson(PostByIdResponseModel data) => json.encode(data.toJson());

class PostByIdResponseModel {
    bool? success;
    String? message;
    Result? result;

    PostByIdResponseModel({
        this.success,
        this.message,
        this.result,
    });

    factory PostByIdResponseModel.fromJson(Map<String, dynamic> json) => PostByIdResponseModel(
        success: json["success"],
        message: json["message"],
        result: json["result"] == null ? null : Result.fromJson(json["result"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "result": result?.toJson(),
    };
}

class Result {
    int? id;
    String? content;
    String? image;
    String? videoUrl;
    DateTime? createdAt;
    DateTime? updatedAt;
    int? commentsCount;
    User? user;
    Topic? topic;
    bool? isLiked;
    bool? isSaved;

    Result({
        this.id,
        this.content,
        this.image,
        this.videoUrl,
        this.createdAt,
        this.updatedAt,
        this.commentsCount,
        this.user,
        this.topic,
        this.isLiked,
        this.isSaved,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        content: json["content"],
        image: json["image"],
        videoUrl: json["video_url"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        commentsCount: json["comments_count"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        topic: json["topic"] == null ? null : Topic.fromJson(json["topic"]),
        isLiked: json["is_liked"],
        isSaved: json["is_saved"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "content": content,
        "image": image,
        "video_url": videoUrl,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "comments_count": commentsCount,
        "user": user?.toJson(),
        "topic": topic?.toJson(),
        "is_liked": isLiked,
        "is_saved": isSaved,
    };
}

class Topic {
    int? id;
    String? name;
    dynamic icon;
    DateTime? createdAt;
    DateTime? updatedAt;
    dynamic postsCount;

    Topic({
        this.id,
        this.name,
        this.icon,
        this.createdAt,
        this.updatedAt,
        this.postsCount,
    });

    factory Topic.fromJson(Map<String, dynamic> json) => Topic(
        id: json["id"],
        name: json["name"],
        icon: json["icon"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        postsCount: json["posts_count"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "icon": icon,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "posts_count": postsCount,
    };
}

class User {
    int? id;
    String? name;
    String? email;
    String? avatar;
    DateTime? createdAt;
    DateTime? updatedAt;
    Rank? rank;

    User({
        this.id,
        this.name,
        this.email,
        this.avatar,
        this.createdAt,
        this.updatedAt,
        this.rank,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        avatar: json["avatar"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        rank: json["rank"] == null ? null : Rank.fromJson(json["rank"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "avatar": avatar,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "rank": rank?.toJson(),
    };
}

class Rank {
    int? id;
    String? name;
    int? position;
    DateTime? createdAt;
    DateTime? updatedAt;

    Rank({
        this.id,
        this.name,
        this.position,
        this.createdAt,
        this.updatedAt,
    });

    factory Rank.fromJson(Map<String, dynamic> json) => Rank(
        id: json["id"],
        name: json["name"],
        position: json["position"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "position": position,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
