// To parse this JSON data, do
//
//     final myPostResponseModel = myPostResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:business_application/data/posts/pagination_model.dart';
import 'package:business_application/data/posts/posts_models.dart';

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
    List<Posts>? data;
    Links? links;
    Meta? meta;

    Result({
        this.data,
        this.links,
        this.meta,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        data: json["data"] == null ? [] : List<Posts>.from(json["data"]!.map((x) => Posts.fromJson(x))),
        links: json["links"] == null ? null : Links.fromJson(json["links"]),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "links": links?.toJson(),
        "meta": meta?.toJson(),
    };
}
