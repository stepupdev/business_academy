// To parse this JSON data, do
//
//     final announcementPostResponseModel = announcementPostResponseModelFromJson(jsonString);

import 'dart:convert';

AnnouncementPostResponseModel announcementPostResponseModelFromJson(String str) => AnnouncementPostResponseModel.fromJson(json.decode(str));

String announcementPostResponseModelToJson(AnnouncementPostResponseModel data) => json.encode(data.toJson());

class AnnouncementPostResponseModel {
    bool? success;
    String? message;
    Result? result;

    AnnouncementPostResponseModel({
        this.success,
        this.message,
        this.result,
    });

    factory AnnouncementPostResponseModel.fromJson(Map<String, dynamic> json) => AnnouncementPostResponseModel(
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
    List<AnnouncementPosts>? data;
    Links? links;
    Meta? meta;

    Result({
        this.data,
        this.links,
        this.meta,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        data: json["data"] == null ? [] : List<AnnouncementPosts>.from(json["data"]!.map((x) => AnnouncementPosts.fromJson(x))),
        links: json["links"] == null ? null : Links.fromJson(json["links"]),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "links": links?.toJson(),
        "meta": meta?.toJson(),
    };
}

class AnnouncementPosts {
    int? id;
    String? content;
    dynamic image;
    dynamic videoUrl;
    int? commentsCount;
    User? user;
    Topic? topic;
    bool? isLiked;
    bool? isSaved;
    DateTime? createdAt;
    DateTime? updatedAt;

    AnnouncementPosts({
        this.id,
        this.content,
        this.image,
        this.videoUrl,
        this.commentsCount,
        this.user,
        this.topic,
        this.isLiked,
        this.isSaved,
        this.createdAt,
        this.updatedAt,
    });

    factory AnnouncementPosts.fromJson(Map<String, dynamic> json) => AnnouncementPosts(
        id: json["id"],
        content: json["content"],
        image: json["image"],
        videoUrl: json["video_url"],
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
        "comments_count": commentsCount,
        "user": user?.toJson(),
        "topic": topic?.toJson(),
        "is_liked": isLiked,
        "is_saved": isSaved,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}

class Topic {
    int? id;
    String? name;
    dynamic icon;
    dynamic postsCount;

    Topic({
        this.id,
        this.name,
        this.icon,
        this.postsCount,
    });

    factory Topic.fromJson(Map<String, dynamic> json) => Topic(
        id: json["id"],
        name: json["name"],
        icon: json["icon"],
        postsCount: json["posts_count"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "icon": icon,
        "posts_count": postsCount,
    };
}

class User {
    int? id;
    String? name;
    String? email;
    String? avatar;
    List<String>? communityIds;
    Rank? rank;
    DateTime? createdAt;
    DateTime? updatedAt;

    User({
        this.id,
        this.name,
        this.email,
        this.avatar,
        this.communityIds,
        this.rank,
        this.createdAt,
        this.updatedAt,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        avatar: json["avatar"],
        communityIds: json["community_ids"] == null ? [] : List<String>.from(json["community_ids"]!.map((x) => x)),
        rank: json["rank"] == null ? null : Rank.fromJson(json["rank"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "avatar": avatar,
        "community_ids": communityIds == null ? [] : List<dynamic>.from(communityIds!.map((x) => x)),
        "rank": rank?.toJson(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}

class Rank {
    int? id;
    String? name;
    int? position;

    Rank({
        this.id,
        this.name,
        this.position,
    });

    factory Rank.fromJson(Map<String, dynamic> json) => Rank(
        id: json["id"],
        name: json["name"],
        position: json["position"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "position": position,
    };
}

class Links {
    String? first;
    dynamic last;
    dynamic prev;
    dynamic next;

    Links({
        this.first,
        this.last,
        this.prev,
        this.next,
    });

    factory Links.fromJson(Map<String, dynamic> json) => Links(
        first: json["first"],
        last: json["last"],
        prev: json["prev"],
        next: json["next"],
    );

    Map<String, dynamic> toJson() => {
        "first": first,
        "last": last,
        "prev": prev,
        "next": next,
    };
}

class Meta {
    int? currentPage;
    int? from;
    String? path;
    int? perPage;
    int? to;

    Meta({
        this.currentPage,
        this.from,
        this.path,
        this.perPage,
        this.to,
    });

    factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        currentPage: json["current_page"],
        from: json["from"],
        path: json["path"],
        perPage: json["per_page"],
        to: json["to"],
    );

    Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "from": from,
        "path": path,
        "per_page": perPage,
        "to": to,
    };
}
