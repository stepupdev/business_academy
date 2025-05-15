// To parse this JSON data, do
//
//     final postByIdResponseModel = postByIdResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:stepup_community/data/posts/posts_models.dart';

PostByIdResponseModel postByIdResponseModelFromJson(String str) => PostByIdResponseModel.fromJson(json.decode(str));

String postByIdResponseModelToJson(PostByIdResponseModel data) => json.encode(data.toJson());

class PostByIdResponseModel {
  bool? success;
  String? message;
  Posts? result;

  PostByIdResponseModel({this.success, this.message, this.result});

  factory PostByIdResponseModel.fromJson(Map<String, dynamic> json) => PostByIdResponseModel(
    success: json["success"],
    message: json["message"],
    result: json["result"] == null ? null : Posts.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {"success": success, "message": message, "result": result?.toJson()};
}
