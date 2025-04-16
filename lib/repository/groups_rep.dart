import 'package:business_application/core/api/api_manager.dart';
import 'package:business_application/core/api/api_url.dart';
import 'package:business_application/core/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupsRep {
  Future getGroups() async {
    APIManager manager = APIManager();
    final response = await manager.getWithHeader(ApiUrl.groups, {
      "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result?.token}",
    });
    debugPrint("response: $response");
    return response;
  }

  Future getGroupsDetails(String id) async {
    APIManager manager = APIManager();
    final response = await manager.getWithHeader("${ApiUrl.groups}/$id", {
      "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result?.token}",
    });
    debugPrint("response: $response");
    return response;
  }

  Future getGroupsTopic(String id) async {
    APIManager manager = APIManager();
    final response = await manager.getWithHeader("${ApiUrl.groups}/$id/topics", {
      "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result?.token}",
    });
    debugPrint("response topic: $response");
    return response;
  }
}
