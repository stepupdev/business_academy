import 'package:business_application/core/api/api_exception.dart';
import 'package:business_application/core/utils/ui_support.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../config/app_routes.dart';
import '../services/auth_services.dart';
import '../utils/auth_utils.dart';

Future<T?> safeApiCall<T>(BuildContext context, Future<T> Function() apiCall) async {
  try {
    return await apiCall();
  } on UnauthorisedException catch (_) {
    debugPrint("=================UnauthorisedException===================");
    Get.find<AuthService>().removeCurrentUser();
    await AuthUtlity.removeUserData();
    context.go(AppRoutes.signIn);
    return null;
  } on FetchDataException catch (e) {
    Ui.showErrorSnackBar(context, message: e.toString());
    return null;
  } catch (e) {
    Ui.showErrorSnackBar(context, message: "Unexpected error: $e");
    return null;
  }
}
