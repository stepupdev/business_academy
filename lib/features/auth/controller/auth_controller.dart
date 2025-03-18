import 'package:business_application/core/config/app_routes.dart';
import 'package:business_application/core/utils/auth_utils.dart';
import 'package:business_application/features/auth/data/login_response_model.dart';
import 'package:business_application/repository/auth_repo/auth_repo.dart';
import 'package:business_application/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
      final user = await _googleSignIn.signIn();
      if (user != null) {
        GoogleSignInAuthentication googleSignInAuthentication = await user.authentication;
        String? token = googleSignInAuthentication.accessToken;
        print("access Token === $token");
        print("id token ------ ${googleSignInAuthentication.accessToken}");
        if (token != null) {
          userToken.value = token;
          print("User token: ${userToken.value}");
        }
        AuthRepository().signInWithGoogle(userToken.value).then((value) async {
          loginResponseModel(LoginResponseModel.fromJson(value));
          print("Login response model: ${loginResponseModel.value.result?.user?.name}");
          if (loginResponseModel.value.success == true) {
            var data = LoginResponseModel.fromJson(value);
            await Get.find<AuthService>().setUser(data);
            print("Login successful");

            // ✅ Save User Token & Info
            await AuthUtlity.saveUserIdAndToken(data.result!.user!.id.toString(), data.result!.token!);
            await AuthUtlity.saveUserInfo(data);

            print("✅ User logged in successfully.");
            context.go('/home'); // Navigate to Home
            await Get.find<AuthService>().getCurrentUser();
          } else {
            print("Login failed");
          }
        });
      }
    } catch (error) {
      isLoading.value = false;
      print("Error during Google sign-in: $error");
      return null;
    } finally {
      isLoading.value = false;
    }
  }
  // signInWithGoogle(BuildContext context) async {
  //   try {
  //     isLoading.value = true;

  //     GoogleSignIn googleSignIn = GoogleSignIn();
  //     GoogleSignInAccount? existingUser = await googleSignIn.signInSilently();
  //     GoogleSignInAccount? user = existingUser ?? await googleSignIn.signIn();

  //     if (user != null) {
  //       GoogleSignInAuthentication googleAuth = await user.authentication;
  //       String? token = googleAuth.accessToken;

  //       if (token != null) {
  //         userToken.value = token;
  //         print("🔹 Google Sign-In Token: $token");

  //         AuthRepository().signInWithGoogle(userToken.value).then((value) async {
  //           loginResponseModel(LoginResponseModel.fromJson(value));

  //           if (loginResponseModel.value.success == true) {
  //             var data = LoginResponseModel.fromJson(value);

  //             // ✅ Save User Token & Info
  //             await AuthUtlity.saveUserIdAndToken(data.result!.user!.id.toString(), data.result!.token!);
  //             await AuthUtlity.saveUserInfo(data);

  //             print("✅ User logged in successfully.");
  //             context.go('/home'); // Navigate to Home
  //           } else {
  //             print("❌ Login failed.");
  //           }
  //         });
  //       }
  //     }
  //   } catch (error) {
  //     print("❌ Error during Google Sign-in: $error");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> signOut(BuildContext context) async {
    await _googleSignIn.signOut();
    await Get.find<AuthService>().removeCurrentUser();
    await Get.find<AuthService>().removeLogged();
    context.go(AppRoutes.signIn);
  }
}
