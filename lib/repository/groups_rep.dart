import 'package:business_application/core/api/api_manager.dart';
import 'package:business_application/core/api/api_url.dart';
import 'package:business_application/core/services/auth_services.dart';
import 'package:get/get.dart';

class GroupsRep {
  Future getGroups() async {
    APIManager _manager = APIManager();
    final response = await _manager.getWithHeader(ApiUrl.groups, {
      "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result!.token}",
    });
    print("response: $response");
    return response;
  }

  Future getGroupsDetails(String id) async {
    APIManager _manager = APIManager();
    final response = await _manager.getWithHeader("${ApiUrl.groups}/$id", {
      "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result!.token}",
    });
    print("response: $response");
    return response;
  }

  Future getGroupsTopic(String id) async {
    APIManager _manager = APIManager();
    final response = await _manager.getWithHeader("${ApiUrl.groups}/$id/topics", {
      "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result!.token}",
    });
    print("response topic: $response");
    return response;
  }
}
