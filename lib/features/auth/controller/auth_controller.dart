import 'package:business_application/core/utils/auth_utils.dart';
import 'package:business_application/features/auth/data/login_response_model.dart';
import 'package:business_application/repository/auth_repo/auth_repo.dart';
import 'package:business_application/services/auth_services.dart';
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
        String? token = googleSignInAuthentication.idToken;
        if (token != null) {
          userToken.value = token;
          print("User token: ${userToken.value}");
        }
        AuthRepository().signInWithGoogle(userToken.value).then((value) async {
          loginResponseModel(LoginResponseModel.fromJson(value));
          print("Login response model: ${loginResponseModel.value.result?.user?.name}");
          if (loginResponseModel.value.success == true) {
            print("Login successful");
            await Get.find<AuthService>().setLogged();
            var data = LoginResponseModel.fromJson(value);
            await Get.find<AuthService>().setUser(data);
            await AuthUtlity.saveUserIdAndToken(data.result!.user!.id.toString(), data.result!.token!);
            if (data.success == true) {
              context.go('/home');
            } else {
              print("Login failed");
            }
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

  Future<void> signOut(BuildContext context) async {
    await _googleSignIn.signOut();
    await Get.find<AuthService>().removeCurrentUser();
    await Get.find<AuthService>().removeLogged();
    context.go('/signin');
  }
}
