import 'package:business_application/features/my_posts/data/my_posts_model.dart';
import 'package:business_application/repository/community_rep.dart';
import 'package:get/get.dart';

class MyPostsController extends GetxController {
  var isLoading = false.obs;
  var myPosts = MyPostResponseModel().obs;

  @override
  void onInit() {
    getMyPosts();
    super.onInit();
  }

  getMyPosts() async {
    try {
      isLoading(true);
      final response = await CommunityRep().getMyPosts();
      if (response != null) {
        myPosts(MyPostResponseModel.fromJson(response));
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }
}
