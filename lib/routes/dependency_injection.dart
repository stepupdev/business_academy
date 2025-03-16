import 'package:business_application/features/auth/controller/auth_service.dart';
import 'package:get/get.dart';

class DependencyInjection extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}