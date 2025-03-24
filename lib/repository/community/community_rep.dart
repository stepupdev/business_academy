import 'package:business_application/core/api/api_manager.dart';
import 'package:business_application/core/api/api_url.dart';
import 'package:business_application/core/services/auth_services.dart';
import 'package:get/get.dart';

class CommunityRep {
  Future getCommunityPosts() async {
    APIManager _manager = APIManager();
    final response = await _manager.getWithHeader(ApiUrl.communityPosts, {
      "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result!.token}",
    });
    print("response: $response");
    return response;
  }

  Future likePosts(Map<String, dynamic> body) async {
    APIManager _manager = APIManager();
    final response = await _manager.postAPICallWithHeader(ApiUrl.likePost, body, {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result!.token}",
    });
    print("response: $response");
    return response;
  }

  Future savePost(Map<String, dynamic> body) async {
    APIManager _manager = APIManager();
    final response = await _manager.postAPICallWithHeader(ApiUrl.savePost, body, {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result!.token}",
    });
    print("response: $response");
    return response;
  }

  Future getCommentsByPostId(String id) async {
    APIManager _manager = APIManager();
    final response = await _manager.getWithHeader("${ApiUrl.communityPosts}/$id/comments", {
      "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result!.token}",
    });
    print("response: $response");
    return response;
  }

  Future getCommunityPostsById(String id) async {
    APIManager _manager = APIManager();
    final response = await _manager.getWithHeader("${ApiUrl.communityPosts}/$id", {
      "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result!.token}",
    });
    print("response: $response");
    return response;
  }

  Future communityPosts(Map<String, dynamic> body) async {
    APIManager _manager = APIManager();
    final response = await _manager.postAPICallWithHeader(ApiUrl.createPost, body, {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result!.token}",
    });
    print("response: $response");
    return response;
  }

  Future getTopics() async {
    APIManager _manager = APIManager();
    final response = await _manager.getWithHeader(ApiUrl.topics, {
      "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result!.token}",
    });
    print("response: $response");
    return response;
  }

  Future getMyPosts() async {
    APIManager _manager = APIManager();
    final response = await _manager.getWithHeader(ApiUrl.myPosts, {
      "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result!.token}",
    });
    print("response: $response");
    return response;
  }

  Future getSavePosts() async {
    APIManager _manager = APIManager();
    final response = await _manager.getWithHeader(ApiUrl.savePosts, {
      "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result!.token}",
    });
    print("response: $response");
    return response;
  }
}
