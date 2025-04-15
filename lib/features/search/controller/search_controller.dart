import 'package:business_application/features/community/controller/community_controller.dart';
import 'package:business_application/features/search/data/search_response_model.dart';
import 'package:business_application/repository/community_rep.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchedController extends GetxController {
  var isLoading = false.obs;
  var selectedTopic = 0.obs;
  var search = SearchResponseModel().obs;
  var searchTextController = TextEditingController().obs;
  var searchHistory = <String>[].obs;

  var topics = Get.find<CommunityController>().topics.value.obs;
  var searchKeyword = ''.obs; // Add this to store the search keyword

  @override
  void onClose() {
    searchTextController.value.dispose();
    super.onClose();
  }

  searching(String query, {String? topicId}) async {
    try {
      isLoading(true);
      searchKeyword(query); // Update the search keyword
      final response = await CommunityRep().search(query, topicQuery: topicId);
      search(SearchResponseModel.fromJson(response));
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isLoading(false);
    }
  }
}
