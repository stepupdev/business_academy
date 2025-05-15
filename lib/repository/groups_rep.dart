import 'package:stepup_community/core/api/api_manager_wrapper.dart';
import 'package:stepup_community/core/api/api_url.dart';
import 'package:stepup_community/core/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupsRep {
  final APIManagerWrapper manager = APIManagerWrapper();
  Future getGroups() async {
    final response = await manager.getWithHeader(ApiUrl.groups, {
      "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result?.token}",
      "Accept": "application/json",
    });
    debugPrint("response: $response");
    return response;
  }

  Future getGroupsDetails(String id) async {
    final response = await manager.getWithHeader("${ApiUrl.groups}/$id", {
      "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result?.token}",
      "Accept": "application/json",
    });
    debugPrint("response: $response");
    return response;
  }

  Future getGroupsTopic(String id) async {
    final response = await manager.getWithHeader("${ApiUrl.groups}/$id/topics", {
      "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result?.token}",
      "Accept": "application/json",
    });
    debugPrint("response topic: $response");
    return response;
  }
}
