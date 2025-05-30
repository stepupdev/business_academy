import 'dart:convert';
import 'dart:io';

import 'package:business_application/core/api/api_manager.dart';
import 'package:business_application/core/api/api_url.dart';
import 'package:business_application/core/services/auth_services.dart';
import 'package:business_application/core/utils/ui_support.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CommunityRep {
  Future getCommunityPosts({Map<String, dynamic>? params, String? fullUrl}) async {
    APIManager manager = APIManager();
    final uri =
        fullUrl != null ? Uri.parse(fullUrl) : Uri.parse(ApiUrl.communityPosts).replace(queryParameters: params);
    debugPrint("Fetching posts with URI: ${uri.toString()}");
    final response = await manager.getWithHeader(uri.toString(), {
      "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result!.token}",
    });
    debugPrint("Posts response: $response");
    return response;
  }

  Future createComments(Map<String, dynamic> body, BuildContext context) async {
    APIManager manager = APIManager();
    final response = await manager.postAPICallWithHeader(ApiUrl.createComments, body, {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result!.token}",
    }, context);
    debugPrint("response: $response");
    // if (response['success'] == true) {
    //   Ui.showSuccessSnackBar(context, message: response['message']);
    // }
    return response;
  }

  Future deleteComment(String commentId, BuildContext context) async {
    APIManager manager = APIManager();
    final response = await manager.deleteAPICallWithHeader(
      context,
      "${ApiUrl.comments}/$commentId/delete",
      headerData: {"Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result!.token}"},
    );
    debugPrint("response: $response");
    return response;
  }

  Future likePosts(Map<String, dynamic> body, BuildContext context) async {
    APIManager manager = APIManager();
    final response = await manager.postAPICallWithHeader(ApiUrl.likePost, body, {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result!.token}",
    }, context);
    debugPrint("response: $response");
    return response;
  }

  Future savePost(Map<String, dynamic> body, BuildContext context) async {
    APIManager manager = APIManager();
    final response = await manager.postAPICallWithHeader(ApiUrl.savePost, body, {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result!.token}",
    }, context);
    debugPrint("response: $response");
    return response;
  }

  Future getCommentsByPostId({required String id, String? fullUrl}) async {
    APIManager manager = APIManager();
    final url = fullUrl ?? "${ApiUrl.communityPosts}/$id/comments";
    final response = await manager.getWithHeader(url, {
      "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result!.token}",
    });
    debugPrint("response: $response");
    return response;
  }

  Future getCommunityPostsById(String id) async {
    APIManager manager = APIManager();
    final response = await manager.getWithHeader("${ApiUrl.communityPosts}/$id", {
      "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result!.token}",
    });
    debugPrint("response: $response");
    return response;
  }

  Future communityPosts({
    required String content,
    required String topicId,
    File? imageFile,
    String? videoUrl,
    String? groupId, // Add groupId parameter
  }) async {
    var uri = Uri.parse(ApiUrl.createPost);
    var request = http.MultipartRequest("POST", uri);

    // Add text fields
    request.fields['content'] = content;
    request.fields['topic_id'] = topicId;
    if (groupId != null) {
      request.fields['group_id'] = groupId; // Include group_id if provided
    }
    if (videoUrl != null && videoUrl.isNotEmpty) {
      request.fields['video_url'] = videoUrl;
    }

    // Add image if provided
    if (imageFile != null) {
      var stream = http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();
      var multipartFile = http.MultipartFile('image', stream, length, filename: imageFile.path.split("/").last);
      request.files.add(multipartFile);
    }

    // Add headers (including Authorization)
    request.headers.addAll({
      'Accept': 'application/json',
      "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result!.token}",
    });

    // Send request and get response
    http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    debugPrint("Response: ${response.statusCode}");
    debugPrint("Body: ${response.body}");

    return jsonDecode(response.body);
  }

  Future deletePost(String postId, BuildContext context) async {
    APIManager manager = APIManager();
    final response = await manager.deleteAPICallWithHeader(
      context,
      "${ApiUrl.communityPosts}/delete/$postId",
      headerData: {"Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result!.token}"},
    );
    debugPrint("response: $response");
    return response;
  }

  Future updatePosts({
    required String content,
    required String postId,
    required String topicId,
    File? imageFile,
    String? videoUrl,
    String? groupId, // Add groupId parameter
  }) async {
    var uri = Uri.parse("${ApiUrl.postUpdate}/$postId");
    var request = http.MultipartRequest("POST", uri);

    // Add text fields
    request.fields['content'] = content;
    request.fields['topic_id'] = topicId;
    if (groupId != null) {
      request.fields['group_id'] = groupId; // Include group_id if provided
    }
    if (videoUrl != null && videoUrl.isNotEmpty) {
      request.fields['video_url'] = videoUrl;
    }

    // Add image if provided
    if (imageFile != null) {
      var stream = http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();
      var multipartFile = http.MultipartFile('image', stream, length, filename: imageFile.path.split("/").last);
      request.files.add(multipartFile);
    }

    // Add headers (including Authorization)
    request.headers.addAll({
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result!.token}",
    });

    // Send request and get response
    http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    debugPrint("Response: ${response.statusCode}");
    debugPrint("Body: ${response.body}");

    return jsonDecode(response.body);
  }

  Future getTopics() async {
    APIManager manager = APIManager();
    final response = await manager.getWithHeader(ApiUrl.topics, {
      "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result!.token}",
    });
    debugPrint("response: $response");
    return response;
  }

  Future getMyPosts({String? fullUrl}) async {
    APIManager manager = APIManager();
    final uri = fullUrl != null ? Uri.parse(fullUrl) : Uri.parse(ApiUrl.myPosts);
    final response = await manager.getWithHeader(uri.toString(), {
      "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result!.token}",
    });
    debugPrint("response: $response");
    return response;
  }

  Future getSavePosts({String? fullUrl}) async {
    APIManager manager = APIManager();
    final uri = fullUrl != null ? Uri.parse(fullUrl) : Uri.parse(ApiUrl.savePosts);
    final response = await manager.getWithHeader(uri.toString(), {
      "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result!.token}",
    });
    debugPrint("response: $response");
    return response;
  }

  Future getUser() async {
    APIManager manager = APIManager();
    final response = await manager.getWithHeader(ApiUrl.user, {
      "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result!.token}",
    });
    debugPrint("response: $response");
    return response;
  }

  Future fetchCommunities() async {
    APIManager manager = APIManager();
    final response = await manager.getWithHeader(ApiUrl.communities, {
      "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result!.token}",
    });
    debugPrint("response: $response");
    return response;
  }

  Future changeCommunity(Map<String, dynamic> body, BuildContext context) async {
    APIManager manager = APIManager();
    final response = await manager.postAPICallWithHeader("${ApiUrl.communities}/change", body, {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result!.token}",
    }, context);
    debugPrint("response: $response");
    if (response['success'] == true) {
      Ui.showSuccessSnackBar(context, message: response['message']);
    } else {
      Ui.showErrorSnackBar(context, message: response['message']);
    }
    return response;
  }

  Future search(String queryParameters, {String? topicQuery, String? groupQuery}) async {
    APIManager manager = APIManager();
    final uri = Uri.parse(ApiUrl.search).replace(
      queryParameters: {
        'q': queryParameters,
        if (topicQuery != null) 'topic_id': topicQuery,
        if (groupQuery != null) 'group_id': groupQuery,
      },
    );
    final response = await manager.getWithHeader(uri.toString(), {
      "Authorization": "Bearer ${Get.find<AuthService>().currentUser.value.result!.token}",
    });
    debugPrint("response: $response");
    return response;
  }
}
