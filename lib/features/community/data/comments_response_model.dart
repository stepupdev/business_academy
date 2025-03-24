// To parse this JSON data, do
//
//     final commentsResponseModel = commentsResponseModelFromJson(jsonString);

import 'dart:convert';

CommentsResponseModel commentsResponseModelFromJson(String str) => CommentsResponseModel.fromJson(json.decode(str));

String commentsResponseModelToJson(CommentsResponseModel data) => json.encode(data.toJson());

class CommentsResponseModel {
    bool? success;
    String? message;
    Result? result;

    CommentsResponseModel({
        this.success,
        this.message,
        this.result,
    });

    factory CommentsResponseModel.fromJson(Map<String, dynamic> json) => CommentsResponseModel(
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
    List<CommentsResult>? data;
    Links? links;
    Meta? meta;

    Result({
        this.data,
        this.links,
        this.meta,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        data: json["data"] == null ? [] : List<CommentsResult>.from(json["data"]!.map((x) => CommentsResult.fromJson(x))),
        links: json["links"] == null ? null : Links.fromJson(json["links"]),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "links": links?.toJson(),
        "meta": meta?.toJson(),
    };
}

class CommentsResult {
    int? id;
    int? postId;
    int? parentId;
    String? content;
    User? user;
    List<CommentsResult>? replies;
    bool? isLiked;
    DateTime? createdAt;
    DateTime? updatedAt;

    CommentsResult({
        this.id,
        this.postId,
        this.parentId,
        this.content,
        this.user,
        this.replies,
        this.isLiked,
        this.createdAt,
        this.updatedAt,
    });

    factory CommentsResult.fromJson(Map<String, dynamic> json) => CommentsResult(
        id: json["id"],
        postId: json["post_id"],
        parentId: json["parent_id"],
        content: json["content"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        replies: json["replies"] == null ? [] : List<CommentsResult>.from(json["replies"]!.map((x) => CommentsResult.fromJson(x))),
        isLiked: json["is_liked"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "post_id": postId,
        "parent_id": parentId,
        "content": content,
        "user": user?.toJson(),
        "replies": replies == null ? [] : List<dynamic>.from(replies!.map((x) => x.toJson())),
        "is_liked": isLiked,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
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
