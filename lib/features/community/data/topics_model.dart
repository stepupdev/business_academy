// To parse this JSON data, do
//
//     final topicsResponseModel = topicsResponseModelFromJson(jsonString);

import 'dart:convert';

TopicsResponseModel topicsResponseModelFromJson(String str) => TopicsResponseModel.fromJson(json.decode(str));

String topicsResponseModelToJson(TopicsResponseModel data) => json.encode(data.toJson());

class TopicsResponseModel {
    bool? success;
    String? message;
    Result? result;

    TopicsResponseModel({
        this.success,
        this.message,
        this.result,
    });

    factory TopicsResponseModel.fromJson(Map<String, dynamic> json) => TopicsResponseModel(
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
    DateTime? createdAt;
    DateTime? updatedAt;
    int? postsCount;

    Datum({
        this.id,
        this.name,
        this.icon,
        this.createdAt,
        this.updatedAt,
        this.postsCount,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
