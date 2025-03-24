// To parse this JSON data, do
//
//     final myPostResponseModel = myPostResponseModelFromJson(jsonString);

import 'dart:convert';

MyPostResponseModel myPostResponseModelFromJson(String str) => MyPostResponseModel.fromJson(json.decode(str));

String myPostResponseModelToJson(MyPostResponseModel data) => json.encode(data.toJson());

class MyPostResponseModel {
    bool? success;
    String? message;
    Result? result;

    MyPostResponseModel({
        this.success,
        this.message,
        this.result,
    });

    factory MyPostResponseModel.fromJson(Map<String, dynamic> json) => MyPostResponseModel(
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
    List<Datum>? data;
    Links? links;
    Meta? meta;

    Result({
        this.data,
        this.links,
        this.meta,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        links: json["links"] == null ? null : Links.fromJson(json["links"]),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "links": links?.toJson(),
        "meta": meta?.toJson(),
    };
}

class Datum {
    int? id;
    String? content;
    String? image;
    String? videoUrl;
    int? commentsCount;
    User? user;
    Topic? topic;
    bool? isLiked;
    bool? isSaved;
    DateTime? createdAt;
    DateTime? updatedAt;

    Datum({
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

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
