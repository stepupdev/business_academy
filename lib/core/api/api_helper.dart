import 'package:stepup_community/core/api/api_exception.dart';
import 'package:stepup_community/core/config/app_router.dart';
import 'package:stepup_community/core/utils/ui_support.dart';
import 'package:stepup_community/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/app_routes.dart';
import '../services/auth_services.dart';
import '../utils/auth_utils.dart';

Future<T?> safeApiCall<T>(Future<T> Function() apiCall) async {
  try {
    return await apiCall();
  } on UnauthorisedException catch (_) {
    debugPrint("=================UnauthorisedException===================");
    Get.find<AuthService>().removeCurrentUser();
    await AuthUtlity.removeUserData();
    AppRouter.router.go(AppRoutes.signIn);
    return null;
  } on FetchDataException catch (e) {
    Ui.showErrorSnackBar(scaffoldMessengerKey.currentState!.context, message: e.toString());
    return null;
  } catch (e) {
    Ui.showErrorSnackBar(scaffoldMessengerKey.currentState!.context, message: "Unexpected error: $e");
    return null;
  }
}
