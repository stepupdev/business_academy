// To parse this JSON data, do
//
//     final groupsTopicResponseModel = groupsTopicResponseModelFromJson(jsonString);

import 'dart:convert';

GroupsTopicResponseModel groupsTopicResponseModelFromJson(String str) => GroupsTopicResponseModel.fromJson(json.decode(str));

String groupsTopicResponseModelToJson(GroupsTopicResponseModel data) => json.encode(data.toJson());

class GroupsTopicResponseModel {
    bool? success;
    String? message;
    Result? result;

    GroupsTopicResponseModel({
        this.success,
        this.message,
        this.result,
    });

    factory GroupsTopicResponseModel.fromJson(Map<String, dynamic> json) => GroupsTopicResponseModel(
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
    List<GroupTopics>? data;

    Result({
        this.data,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        data: json["data"] == null ? [] : List<GroupTopics>.from(json["data"]!.map((x) => GroupTopics.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class GroupTopics {
    int? id;
    String? name;
    dynamic icon;
    DateTime? createdAt;
    DateTime? updatedAt;
    int? postsCount;

    GroupTopics({
        this.id,
        this.name,
        this.icon,
        this.createdAt,
        this.updatedAt,
        this.postsCount,
    });

    factory GroupTopics.fromJson(Map<String, dynamic> json) => GroupTopics(
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
