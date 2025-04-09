// To parse this JSON data, do
//
//     final groupsByIdResponseModel = groupsByIdResponseModelFromJson(jsonString);

import 'dart:convert';

GroupsByIdResponseModel groupsByIdResponseModelFromJson(String str) => GroupsByIdResponseModel.fromJson(json.decode(str));

String groupsByIdResponseModelToJson(GroupsByIdResponseModel data) => json.encode(data.toJson());

class GroupsByIdResponseModel {
    bool? success;
    String? message;
    Result? result;

    GroupsByIdResponseModel({
        this.success,
        this.message,
        this.result,
    });

    factory GroupsByIdResponseModel.fromJson(Map<String, dynamic> json) => GroupsByIdResponseModel(
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
    dynamic icon;
    String ? imageUrl;
    DateTime? createdAt;
    DateTime? updatedAt;

    Result({
        this.id,
        this.name,
        this.icon,
        this.imageUrl,
        this.createdAt,
        this.updatedAt,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        name: json["name"],
        icon: json["icon"],
        imageUrl: json["image_url"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "icon": icon,
        "image_url": imageUrl,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
