import 'package:business_application/features/save_posts/data/save_posts_res_model.dart';
import 'package:business_application/repository/community_rep.dart';
import 'package:get/get.dart';

class SavePostController extends GetxController {
  final isLoading = false.obs;
  final savePosts = SavePostResponseModel().obs;

  @override
  void onInit() {
    getSavePosts();
    super.onInit();
  }

  getSavePosts() async {
    try {
      isLoading(true);
      final response = await CommunityRep().getSavePosts();
      if (response['message'] == 'Saved posts retrieved successfully') {
        savePosts(SavePostResponseModel.fromJson(response));
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }

  // void getSavedPosts() async {
  //   try {
  //     isLoading(true);
  //     final response = await CommunityRep().getSavedPosts();
  //     savePosts(SavePostsResponseModel.fromJson(response));
  //   } catch (e) {
  //     print(e);
  //   } finally {
  //     isLoading(false);
  //   }
  // }
}
