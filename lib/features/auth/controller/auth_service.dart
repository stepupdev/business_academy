import 'package:get/state_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  var userEmail = ''.obs;
  var userDisplayName = ''.obs;
  var userPhoto = ''.obs;
  var userId = ''.obs;
  var userToken = ''.obs;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: "1036640298216-fktikfkdjgbn9aqermkpguc458lvhtjp.apps.googleusercontent.com",
    scopes: ["email"],
    signInOption: SignInOption.standard,
  );

  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        // save the user data
        userEmail.value = user.email;
        userDisplayName.value = user.displayName ?? "";
        userPhoto.value = user.photoUrl ?? "";
        userId.value = user.id;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("userEmail", userEmail.value);
        await prefs.setString("userDisplayName", userDisplayName.value);
        await prefs.setString("userPhoto", userPhoto.value);
        await prefs.setString("userId", userId.value);
        await prefs.setString("userToken", userToken.value);
      }
      return user;
    } catch (error) {
      print("Error during Google sign-in: $error");
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    userEmail.value = "";
    userDisplayName.value = "";
    userPhoto.value = "";
    userId.value = "";
    userToken.value = "";
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("userEmail");
    await prefs.remove("userDisplayName");
    await prefs.remove("userPhoto");
    await prefs.remove("userId");
    await prefs.remove("userToken");
  }
}
