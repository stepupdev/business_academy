import 'package:business_application/features/search/data/search_response_model.dart';
import 'package:business_application/repository/community_rep.dart';
import 'package:get/get.dart';

class SearchedController extends GetxController {
  var isLoading = false.obs;

  var search = SearchResponseModel().obs;

  searching(String query, {String? topicId}) async {
    try {
      isLoading(true);
      final response = await CommunityRep().search(query, topicQuery: topicId);
      search(SearchResponseModel.fromJson(response));
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }
}
