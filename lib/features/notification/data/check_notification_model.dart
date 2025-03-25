// To parse this JSON data, do
//
//     final checkNotificationResponseModel = checkNotificationResponseModelFromJson(jsonString);

import 'dart:convert';

CheckNotificationResponseModel checkNotificationResponseModelFromJson(String str) => CheckNotificationResponseModel.fromJson(json.decode(str));

String checkNotificationResponseModelToJson(CheckNotificationResponseModel data) => json.encode(data.toJson());

class CheckNotificationResponseModel {
    bool? success;
    String? message;
    Result? result;

    CheckNotificationResponseModel({
        this.success,
        this.message,
        this.result,
    });

    factory CheckNotificationResponseModel.fromJson(Map<String, dynamic> json) => CheckNotificationResponseModel(
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
    bool? hasNotifications;

    Result({
        this.hasNotifications,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        hasNotifications: json["has_notifications"],
    );

    Map<String, dynamic> toJson() => {
        "has_notifications": hasNotifications,
    };
}
