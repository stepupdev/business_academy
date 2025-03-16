import 'package:business_application/core/api/api_manager.dart';
import 'package:business_application/core/api/api_url.dart';

class AuthRepository {
  Future signInWithGoogle(String token) async {
    APIManager _manager = APIManager();
    final response = await _manager.postAPICall(
      ApiUrl.login,
      {
        "token" : token,
      }
    );
    print("response: $response");
    return response;
  }
}