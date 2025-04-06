import 'package:business_application/core/api/api_manager.dart';
import 'package:business_application/core/api/api_url.dart';
import 'package:business_application/core/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationRep {
  Future getNotifications() async {
    APIManager _manager = APIManager();
    final response = await _manager.getWithHeader(ApiUrl.notification, {
      "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result!.token}",
    });
    print("response: $response");
    return response;
  }

  Future checkNotification() async {
    APIManager _manager = APIManager();
    final response = await _manager.getWithHeader("${ApiUrl.notification}/check", {
      "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result!.token}",
    });
    print("response: $response");
    return response;
  }

  Future markNotification(String id, BuildContext context) async {
    APIManager _manager = APIManager();
    final response = await _manager.postAPICallWithHeader("${ApiUrl.notification}/$id/mark-read-unread", {}, {
      "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result!.token}",
    }, context);
    print("response: $response");
    return response;
  }

  Future markAllNotification(BuildContext context) async {
    APIManager _manager = APIManager();
    final response = await _manager.postAPICallWithHeader("${ApiUrl.notification}/mark-all-read", {}, {
      "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result!.token}",
    }, context);
    print("response: $response");
    return response;
  }
}
