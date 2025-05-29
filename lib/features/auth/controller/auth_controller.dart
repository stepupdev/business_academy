import 'package:stepup_community/core/config/app_routes.dart';
import 'package:stepup_community/core/services/auth_services.dart';
import 'package:stepup_community/core/services/connectivity_service.dart';
import 'package:stepup_community/core/utils/auth_utils.dart';
import 'package:stepup_community/core/utils/ui_support.dart';
import 'package:stepup_community/features/auth/data/login_response_model.dart';
import 'package:stepup_community/repository/auth_repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  var userToken = ''.obs;
  var loginResponseModel = LoginResponseModel().obs;
  var isLoading = false.obs;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: "1036640298216-fktikfkdjgbn9aqermkpguc458lvhtjp.apps.googleusercontent.com",
    scopes: ["email"],
  );

  signInWithGoogle(BuildContext context) async {
    try {
      isLoading.value = true;

      final isConnect = Get.find<ConnectivityService>().isConnected();
      if (!isConnect) {
        debugPrint("No internet connection");
        isLoading.value = false;
        Ui.showErrorSnackBar(context, message: "No internet connection");
        return;
      }
      await _googleSignIn.signOut();
      debugPrint("Google Sign In started");
      final user = await _googleSignIn.signIn();
      if (user != null) {
        GoogleSignInAuthentication googleSignInAuthentication = await user.authentication;
        String? token = googleSignInAuthentication.accessToken;
        debugPrint("access Token === $token");
        debugPrint("id token ------ ${googleSignInAuthentication.accessToken}");
        if (token != null) {
          userToken.value = token;
          debugPrint("User token: ${userToken.value}");
        }
        AuthRepository().signInWithGoogle(userToken.value).then((value) async {
          loginResponseModel(LoginResponseModel.fromJson(value));
          debugPrint("Login response model: ${loginResponseModel.value.result?.user?.name}");
          if (loginResponseModel.value.success == true) {
            var data = LoginResponseModel.fromJson(value);
            await Get.find<AuthService>().setUser(data);
            debugPrint("Login successful");

            // ✅ Save User Token & Info
            await AuthUtlity.saveUserIdAndToken(data.result!.user!.id.toString(), data.result!.token!);
            await AuthUtlity.saveUserInfo(data);

            debugPrint("✅ User logged in successfully.");
            context.go('/home'); // Navigate to Home
            await Get.find<AuthService>().getCurrentUser();
          } else {
            isLoading.value = false;
          }
        });
      }
    } catch (error) {
      isLoading.value = false;
      debugPrint("Error: $error");
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut(BuildContext context) async {
    await _googleSignIn.signOut();
    await Get.find<AuthService>().removeCurrentUser();
    await Get.find<AuthService>().removeLogged();

    // Remove token and userId from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user_id');

    context.go(AppRoutes.signIn);
  }
}
