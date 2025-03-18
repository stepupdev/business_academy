import 'package:business_application/features/auth/controller/auth_controller.dart';
import 'package:business_application/features/community/controller/community_controller.dart';
import 'package:get/get.dart';

class DependencyInjection extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());

    Get.lazyPut<CommunityController>(() => CommunityController(), fenix: true);
  }
}
