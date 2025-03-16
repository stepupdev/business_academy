import 'package:business_application/features/auth/data/login_response_model.dart';
import 'package:business_application/repository/auth_repo/auth_repo.dart';
import 'package:flutter/widgets.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  var userToken = ''.obs;
  var loginResponseModel = LoginResponseModel().obs;

  var isLoading = false.obs;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: "1036640298216-fktikfkdjgbn9aqermkpguc458lvhtjp.apps.googleusercontent.com",
    scopes: ["email"],
    signInOption: SignInOption.standard,
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
        AuthRepository().signInWithGoogle(userToken.value).then((value) {
          loginResponseModel(LoginResponseModel.fromJson(value));
          print("Login response model: ${loginResponseModel.value.result?.user?.name}");
          if (loginResponseModel.value.success == true) {
            print("Login successful");
            context.go('/home');
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
    context.go('/signin');
  }
}
