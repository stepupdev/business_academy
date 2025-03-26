// To parse this JSON data, do
//
//     final userResponseModel = userResponseModelFromJson(jsonString);

import 'dart:convert';

UserResponseModel userResponseModelFromJson(String str) => UserResponseModel.fromJson(json.decode(str));

String userResponseModelToJson(UserResponseModel data) => json.encode(data.toJson());

class UserResponseModel {
    bool? success;
    String? message;
    Result? result;

    UserResponseModel({
        this.success,
        this.message,
        this.result,
    });

    factory UserResponseModel.fromJson(Map<String, dynamic> json) => UserResponseModel(
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
    String? name;
    String? email;
    String? avatar;
    Community? community;
    List<String>? communityIds;
    Community? rank;
    DateTime? createdAt;
    DateTime? updatedAt;

    Result({
        this.id,
        this.name,
        this.email,
        this.avatar,
        this.community,
        this.communityIds,
        this.rank,
        this.createdAt,
        this.updatedAt,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        avatar: json["avatar"],
        community: json["community"] == null ? null : Community.fromJson(json["community"]),
        communityIds: json["community_ids"] == null ? [] : List<String>.from(json["community_ids"]!.map((x) => x)),
        rank: json["rank"] == null ? null : Community.fromJson(json["rank"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "avatar": avatar,
        "community": community?.toJson(),
        "community_ids": communityIds == null ? [] : List<dynamic>.from(communityIds!.map((x) => x)),
        "rank": rank?.toJson(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}

class Community {
    int? id;
    String? name;
    DateTime? createdAt;
    DateTime? updatedAt;
    int? position;

    Community({
        this.id,
        this.name,
        this.createdAt,
        this.updatedAt,
        this.position,
    });

    factory Community.fromJson(Map<String, dynamic> json) => Community(
        id: json["id"],
        name: json["name"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        position: json["position"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "position": position,
    };
}
