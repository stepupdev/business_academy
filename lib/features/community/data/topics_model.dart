// To parse this JSON data, do
//
//     final topicsResponseModel = topicsResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:business_application/data/posts/topic_models.dart';

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
    List<Topic>? data;

    Result({
        this.data,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        data: json["data"] == null ? [] : List<Topic>.from(json["data"]!.map((x) => Topic.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}


