// To parse this JSON data, do
//
//     final searchResponseModel = searchResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:stepup_community/data/posts/pagination_model.dart';
import 'package:stepup_community/data/posts/posts_models.dart';

SearchResponseModel searchResponseModelFromJson(String str) => SearchResponseModel.fromJson(json.decode(str));

String searchResponseModelToJson(SearchResponseModel data) => json.encode(data.toJson());

class SearchResponseModel {
  bool? success;
  String? message;
  Result? result;

  SearchResponseModel({this.success, this.message, this.result});

  factory SearchResponseModel.fromJson(Map<String, dynamic> json) => SearchResponseModel(
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

// class Datum {
//     int? id;
//     String? content;
//     dynamic image;
//     String? videoUrl;
//     int? commentsCount;
//     User? user;
//     Topic? topic;
//     bool? isLiked;
//     bool? isSaved;
//     DateTime? createdAt;
//     DateTime? updatedAt;

//     Datum({
//         this.id,
//         this.content,
//         this.image,
//         this.videoUrl,
//         this.commentsCount,
//         this.user,
//         this.topic,
//         this.isLiked,
//         this.isSaved,
//         this.createdAt,
//         this.updatedAt,
//     });

//     factory Datum.fromJson(Map<String, dynamic> json) => Datum(
//         id: json["id"],
//         content: json["content"],
//         image: json["image"],
//         videoUrl: json["video_url"],
//         commentsCount: json["comments_count"],
//         user: json["user"] == null ? null : User.fromJson(json["user"]),
//         topic: json["topic"] == null ? null : Topic.fromJson(json["topic"]),
//         isLiked: json["is_liked"],
//         isSaved: json["is_saved"],
//         createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
//         updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "content": content,
//         "image": image,
//         "video_url": videoUrl,
//         "comments_count": commentsCount,
//         "user": user?.toJson(),
//         "topic": topic?.toJson(),
//         "is_liked": isLiked,
//         "is_saved": isSaved,
//         "created_at": createdAt?.toIso8601String(),
//         "updated_at": updatedAt?.toIso8601String(),
//     };
// }
