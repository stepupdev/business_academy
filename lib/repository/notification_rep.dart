import 'package:business_application/core/api/api_manager.dart';
import 'package:business_application/core/api/api_url.dart';
import 'package:business_application/core/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationRep {
  Future getNotifications() async {
    APIManager manager = APIManager();
    final response = await manager.getWithHeader(ApiUrl.notification, {
      "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result!.token}",
    });
    debugPrint("response: $response");
    return response;
  }

  Future checkNotification() async {
    APIManager manager = APIManager();
    final response = await manager.getWithHeader("${ApiUrl.notification}/check", {
      "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result!.token}",
    });
    debugPrint("response: $response");
    return response;
  }

  Future markNotification(String id, BuildContext context) async {
    APIManager manager = APIManager();
    final response = await manager.postAPICallWithHeader("${ApiUrl.notification}/$id/mark-read", {}, {
      "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result!.token}",
    }, context);
    debugPrint("response: $response");
    return response;
  }

  Future markReadUnreadNotification(String id, BuildContext context) async {
    APIManager manager = APIManager();
    final response = await manager.postAPICallWithHeader("${ApiUrl.notification}/$id/mark-read-unread", {}, {
      "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result!.token}",
    }, context);
    debugPrint("response: $response");
    return response;
  }

  Future markAllNotification(BuildContext context) async {
    APIManager manager = APIManager();
    final response = await manager.postAPICallWithHeader("${ApiUrl.notification}/mark-all-read", {}, {
      "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result!.token}",
    }, context);
    debugPrint("response: $response");
    return response;
  }
}
