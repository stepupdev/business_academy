import 'package:business_application/core/api/api_manager.dart';
import 'package:business_application/core/api/api_url.dart';
import 'package:flutter/material.dart';

class AuthRepository {
  Future signInWithGoogle(String token) async {
    APIManager manager = APIManager();
    final response = await manager.postAPICall(ApiUrl.login, {"token": token});
    debugPrint("response: $response");
    return response;
  }
}
