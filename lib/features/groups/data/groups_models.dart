// To parse this JSON data, do
//
//     final groupsResponseModel = groupsResponseModelFromJson(jsonString);

import 'dart:convert';

GroupsResponseModel groupsResponseModelFromJson(String str) => GroupsResponseModel.fromJson(json.decode(str));

String groupsResponseModelToJson(GroupsResponseModel data) => json.encode(data.toJson());

class GroupsResponseModel {
    bool? success;
    String? message;
    Result? result;

    GroupsResponseModel({
        this.success,
        this.message,
        this.result,
    });

    factory GroupsResponseModel.fromJson(Map<String, dynamic> json) => GroupsResponseModel(
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

    Result({
        this.data,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    int? id;
    String? name;
    dynamic icon;
    String? imageUrl;
    DateTime? createdAt;
    DateTime? updatedAt;

    Datum({
        this.id,
        this.name,
        this.icon,
        this.imageUrl,
        this.createdAt,
        this.updatedAt,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
