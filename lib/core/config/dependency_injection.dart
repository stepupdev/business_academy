import 'package:stepup_community/core/services/auth_services.dart';
import 'package:stepup_community/features/announcements/controller/announcement_controller.dart';
import 'package:stepup_community/features/auth/controller/auth_controller.dart';
import 'package:stepup_community/features/community/controller/community_controller.dart';
import 'package:stepup_community/features/groups/controller/groups_controller.dart';
import 'package:stepup_community/features/home/controller/home_controller.dart';
import 'package:stepup_community/features/menu/controller/menu_controller.dart';
import 'package:stepup_community/features/my_posts/controller/my_posts_controller.dart';
import 'package:stepup_community/features/notification/controller/notification_controller.dart';
import 'package:stepup_community/features/save_posts/controller/save_post_controller.dart';
import 'package:stepup_community/features/search/controller/search_controller.dart';
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
