// To parse this JSON data, do
//
//     final commentsByIdResponseModel = commentsByIdResponseModelFromJson(jsonString);

import 'dart:convert';

CommentsByIdResponseModel commentsByIdResponseModelFromJson(String str) => CommentsByIdResponseModel.fromJson(json.decode(str));

String commentsByIdResponseModelToJson(CommentsByIdResponseModel data) => json.encode(data.toJson());

class CommentsByIdResponseModel {
    bool? success;
    String? message;
    Result? result;

    CommentsByIdResponseModel({
        this.success,
        this.message,
        this.result,
    });

    factory CommentsByIdResponseModel.fromJson(Map<String, dynamic> json) => CommentsByIdResponseModel(
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
    int? postId;
    int? parentId;
    String? content;
    bool? isLiked;
    DateTime? createdAt;
    DateTime? updatedAt;

    Result({
        this.id,
        this.postId,
        this.parentId,
        this.content,
        this.isLiked,
        this.createdAt,
        this.updatedAt,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        postId: json["post_id"],
        parentId: json["parent_id"],
        content: json["content"],
        isLiked: json["is_liked"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "post_id": postId,
        "parent_id": parentId,
        "content": content,
        "is_liked": isLiked,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
