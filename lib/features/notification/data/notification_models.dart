// To parse this JSON data, do
//
//     final notificationResponseModel = notificationResponseModelFromJson(jsonString);

import 'dart:convert';

NotificationResponseModel notificationResponseModelFromJson(String str) => NotificationResponseModel.fromJson(json.decode(str));

String notificationResponseModelToJson(NotificationResponseModel data) => json.encode(data.toJson());

class NotificationResponseModel {
    bool? success;
    String? message;
    Result? result;

    NotificationResponseModel({
        this.success,
        this.message,
        this.result,
    });

    factory NotificationResponseModel.fromJson(Map<String, dynamic> json) => NotificationResponseModel(
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
    List<NotificationModels>? data;
    Links? links;
    Meta? meta;

    Result({
        this.data,
        this.links,
        this.meta,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        data: json["data"] == null ? [] : List<NotificationModels>.from(json["data"]!.map((x) => NotificationModels.fromJson(x))),
        links: json["links"] == null ? null : Links.fromJson(json["links"]),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "links": links?.toJson(),
        "meta": meta?.toJson(),
    };
}

class NotificationModels {
    int? id;
    int? userId;
    String? type;
    String? notifiableType;
    int? notifiableId;
    bool? isRead;
    String? notifiableUrl;
    FromUser? fromUser;
    DateTime? createdAt;
    DateTime? updatedAt;

    NotificationModels({
        this.id,
        this.userId,
        this.type,
        this.notifiableType,
        this.notifiableId,
        this.isRead,
        this.notifiableUrl,
        this.fromUser,
        this.createdAt,
        this.updatedAt,
    });

    factory NotificationModels.fromJson(Map<String, dynamic> json) => NotificationModels(
        id: json["id"],
        userId: json["user_id"],
        type: json["type"],
        notifiableType: json["notifiable_type"],
        notifiableId: json["notifiable_id"],
        isRead: json["is_read"],
        notifiableUrl: json["notifiable_url"],
        fromUser: json["from_user"] == null ? null : FromUser.fromJson(json["from_user"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "type": type,
        "notifiable_type": notifiableType,
        "notifiable_id": notifiableId,
        "is_read": isRead,
        "notifiable_url": notifiableUrl,
        "from_user": fromUser?.toJson(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}

class FromUser {
    int? id;
    String? name;
    String? email;
    String? avatar;
    DateTime? createdAt;
    DateTime? updatedAt;
    Rank? rank;

    FromUser({
        this.id,
        this.name,
        this.email,
        this.avatar,
        this.createdAt,
        this.updatedAt,
        this.rank,
    });

    factory FromUser.fromJson(Map<String, dynamic> json) => FromUser(
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
