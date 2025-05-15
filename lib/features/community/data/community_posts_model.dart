// To parse this JSON data, do
//
//     final postResponseModel = postResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:stepup_community/data/posts/posts_models.dart';

import '../../../data/posts/pagination_model.dart';

PostsResponseModel postResponseModelFromJson(String str) => PostsResponseModel.fromJson(json.decode(str));

String postResponseModelToJson(PostsResponseModel data) => json.encode(data.toJson());

class PostsResponseModel {
  bool? success;
  String? message;
  Result? result;

  PostsResponseModel({this.success, this.message, this.result});

  factory PostsResponseModel.fromJson(Map<String, dynamic> json) => PostsResponseModel(
    success: json["success"],
    message: json["message"],
    result: json["result"] == null ? null : Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {"success": success, "message": message, "result": result?.toJson()};
}

class Result {
  List<Posts>? data;
  Links? links;
  Meta? meta;

  Result({this.data, this.links, this.meta});

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
