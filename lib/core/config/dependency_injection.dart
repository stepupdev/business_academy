import 'package:business_application/features/auth/controller/auth_controller.dart';
import 'package:business_application/features/community/controller/community_controller.dart';
import 'package:business_application/features/groups/controller/groups_controller.dart';
import 'package:business_application/features/my_posts/controller/my_posts_controller.dart';
import 'package:business_application/features/save_posts/controller/save_post_controller.dart';
import 'package:get/get.dart';

class DependencyInjection extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());

    Get.lazyPut<CommunityController>(() => CommunityController(), fenix: true);
    Get.lazyPut<MyPostsController>(() => MyPostsController(), fenix: true);
    Get.lazyPut<SavePostController>(() => SavePostController(), fenix: true);
    Get.lazyPut<GroupsController>(() => GroupsController(), fenix: true);
  }
}
