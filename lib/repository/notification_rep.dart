import 'package:business_application/core/api/api_manager_wrapper.dart';
import 'package:business_application/core/api/api_url.dart';
import 'package:business_application/core/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationRep {
  final APIManagerWrapper manager = APIManagerWrapper();
  Future getNotifications() async {
    final response = await manager.getWithHeader(ApiUrl.notification, {
      "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result?.token}",
      "Accept": "application/json",
    });
    debugPrint("response: $response");
    return response;
  }

  Future checkNotification() async {
    // final response = await safeApiCall(
    //   () => manager.getWithHeader("${ApiUrl.notification}/check", {
    //     "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result?.token}",
    //     "Accept": "application/json",
    //   }),
    // );
    final response = await manager.getWithHeader("${ApiUrl.notification}/check", {
      "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result?.token}",
      "Accept": "application/json",
    });
    debugPrint("response: $response");
    return response;
  }

  Future markNotification(String id, BuildContext context) async {
    final response = await manager
        .postAPICallWithHeader(context, "${ApiUrl.notification}/$id/mark-read", {}, {
          "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result!.token}",
          "Accept": "application/json",
        });
    debugPrint("response: $response");
    return response;
  }

  Future markReadUnreadNotification(String id, BuildContext context) async {
    final response = await manager
        .postAPICallWithHeader(context, "${ApiUrl.notification}/$id/mark-read-unread", {}, {
          "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result!.token}",
          "Accept": "application/json",
        });
    debugPrint("response: $response");
    return response;
  }

  Future markAllNotification(BuildContext context) async {
    final response = await manager
        .postAPICallWithHeader(context, "${ApiUrl.notification}/mark-all-read", {}, {
          "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result!.token}",
          "Accept": "application/json",
        });
    debugPrint("response: $response");
    return response;
  }
}
