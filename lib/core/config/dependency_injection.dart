import 'package:business_application/core/services/auth_services.dart';
import 'package:business_application/features/announcements/controller/announcement_controller.dart';
import 'package:business_application/features/auth/controller/auth_controller.dart';
import 'package:business_application/features/community/controller/community_controller.dart';
import 'package:business_application/features/groups/controller/groups_controller.dart';
import 'package:business_application/features/home/controller/home_controller.dart';
import 'package:business_application/features/menu/controller/menu_controller.dart';
import 'package:business_application/features/my_posts/controller/my_posts_controller.dart';
import 'package:business_application/features/notification/controller/notification_controller.dart';
import 'package:business_application/features/save_posts/controller/save_post_controller.dart';
import 'package:business_application/features/search/controller/search_controller.dart';
import 'package:get/get.dart';

class DependencyInjection extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());

    Get.lazyPut<CommunityController>(() => CommunityController(), fenix: true);
    Get.lazyPut<MyPostsController>(() => MyPostsController(), fenix: true);
    Get.lazyPut<SavePostController>(() => SavePostController(), fenix: true);
    Get.lazyPut<GroupsController>(() => GroupsController(), fenix: true);
    Get.lazyPut<NotificationController>(() => NotificationController(), fenix: true);
    Get.lazyPut<UserMenuController>(() => UserMenuController(), fenix: true);
    Get.lazyPut<SearchedController>(() => SearchedController(), fenix: true);
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => AuthService(), fenix: true);
    Get.lazyPut(() => AnnouncementController(), fenix: true);
  }
}
