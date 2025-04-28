import 'dart:convert';
import 'dart:io';

import 'package:business_application/core/api/api_exception.dart';
import 'package:business_application/core/config/app_router.dart';
import 'package:business_application/core/config/app_routes.dart';
import 'package:business_application/core/services/auth_services.dart';
import 'package:business_application/core/services/connectivity_service.dart';
import 'package:business_application/core/utils/auth_utils.dart';
import 'package:business_application/core/utils/ui_support.dart';
import 'package:business_application/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class APIManager {
  Future<dynamic> postAPICallWithHeader(
    String url,
    Map<String, dynamic> param,
    Map<String, String> headerData,
    BuildContext context,
  ) async {
    debugPrint("Calling API: $url");
    debugPrint("Calling parameters: $param");

    var responseJson;
    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(param),
        headers: headerData,
      );
      debugPrint("api provider bro bro bro bro ${response.body}");
      var data = jsonDecode(response.body);

      if (response.statusCode == 422) {
        Ui.showErrorSnackBar(context, message: data["message"]);
      } else if (response.statusCode == 400) {
        Ui.showErrorSnackBar(context, message: data["message"]);
      } else if (response.statusCode == 403) {
        Ui.showErrorSnackBar(context, message: data["message"]);
      }
      responseJson = _response(response);

      debugPrint("hlw bro ++++++++++++++++++++$responseJson");
    } on SocketException catch (_) {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> putAPICallWithHeader(
    String url,
    Map<String, dynamic> param,
    Map<String, String> headerData,
  ) async {
    debugPrint("Calling API: $url");
    debugPrint("Calling parameters: $param");

    var responseJson;
    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(param),
        headers: headerData,
      );
      debugPrint("api provider bro bro bro bro ${response.body}");
      var data = jsonDecode(response.body);
      if (response.statusCode == 422) {
        Ui.showErrorSnackBar(scaffoldMessengerKey.currentContext!, message: data["message"]);
      } else if (response.statusCode == 400) {
        Ui.showErrorSnackBar(scaffoldMessengerKey.currentContext!, message: data["message"]);
      }
      responseJson = _response(response);

      debugPrint("hlw bro ++++++++++++++++++++$responseJson");
    } on SocketException catch (_) {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> postAPICall(String url, var param, {var header}) async {
    debugPrint("Calling API: $url");
    debugPrint("Calling parameters: $param");

    var responseJson;
    try {
      final response = await http.post(Uri.parse(url), body: param, headers: header);
      debugPrint("status code is ${response.statusCode}");
      debugPrint("status  $response");
      if (response.statusCode == 200) {
        responseJson = _response(response);
        debugPrint('APIManager.postAPICall');
        debugPrint("response is ${response.body}");
      } else if (response.statusCode == 404) {
        responseJson = _response(response);
      } else if (response.statusCode == 405) {
        responseJson = _response(response);
      } else {
        return null;
      }
    } on SocketException catch (_) {
      final isConnect = ConnectivityService.instance.isConnected.value;
      debugPrint("isConnect is $isConnect");
      if (!isConnect) {
        debugPrint("No Internet connection");
      }
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> multipartPostAPI(
    String url,
    Map<String, String> param,
    var images,
    Map<String, String> headerData,
    String parameterName,
  ) async {
    debugPrint("Calling API: $url");
    debugPrint("Calling parameters: $param");
    debugPrint(images);
    debugPrint("Calling parameterName: $parameterName");

    var responseJson;
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields.addAll(param);

      debugPrint('fgdf');

      if (images.isNotEmpty) {
        debugPrint('APIManager.multipartPostAPI');
        for (var item in images) {
          debugPrint("item is $item");
          String fileName = item.path.split("/").last;
          var stream = http.ByteStream(item.openRead());

          stream.cast();

          debugPrint("stream is $stream");
          // get file length

          var length = await item.length(); //imageFile is your image file

          // multipart that takes file
          var multipartFileSign = http.MultipartFile('image', stream, length, filename: fileName);

          request.files.add(multipartFileSign);
        }
      }
      if (headerData.isNotEmpty) {
        debugPrint('APIManager.multipartPostAPI 2');
        request.headers.addAll(headerData);
      }
      debugPrint('APIManager.multipartPostAPI 3');
      http.StreamedResponse streamedResponse = await request.send();
      debugPrint('APIManager.multipartPostAPI 4');
      var response = await http.Response.fromStream(streamedResponse);

      debugPrint("status code is ${response.statusCode}");
      responseJson = _response(response);
      debugPrint(responseJson);
    } on SocketException catch (_) {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> get(String url) async {
    debugPrint("Calling API: $url");
    var responseJson;
    try {
      final response = await http.get(Uri.parse(url));
      debugPrint(response.body);
      responseJson = _response(response);
    } on SocketException catch (_) {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  addArrayDataWithMultipart({
    required String url,
    required Map<String, String> body,
    required List list,
    required String listName,
  }) async {
    // string to uri
    var uri = Uri.parse(url);
    debugPrint("my list is $list");
    debugPrint("my body is $body");
    debugPrint("my url is $url");

    // create multipart request
    var request = http.MultipartRequest("POST", uri);

    // add file to multipart

    for (int i = 0; i < list.length; i++) {
      request.fields["$listName[$i]"] = list[i].toString();
      //request.fields['rate[]'] = rate[i].toString();
    }

    request.fields.addAll(body);

    // send
    http.Response response = await http.Response.fromStream(await request.send());
    debugPrint("status code is ${response.statusCode}");
    debugPrint(response.body);

    var bb = jsonDecode(response.body);
    debugPrint("my array multipart response is $bb");
    return bb;
  }

  Future<dynamic> getWithHeader(String url, Map<String, String> headerData) async {
    debugPrint("Calling API: $url");
    var responseJson;
    try {
      final response = await http.get(Uri.parse(url), headers: headerData);
      debugPrint("my getWithHeader method data response ${response.body}");
      debugPrint("header is $headerData");
      debugPrint("status code is ${response.statusCode}");
      responseJson = _response(response);
    } on FetchDataException catch (_) {
      Get.snackbar(
        "Error",
        "No Internet connection",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } on SocketException catch (_) {
      Get.snackbar(
        "Error",
        "No Internet connection",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    return responseJson;
  }

  dynamic _response(http.Response response) async {
    debugPrint('APIManager._response');
    debugPrint("status code: ${response.statusCode}");
    debugPrint("body: ${response.body}");

    try {
      switch (response.statusCode) {
        case 200:
          return json.decode(response.body);
        case 204:
          return null;
        case 400:
        case 401:
          // // clear current session
          Get.find<AuthService>().removeCurrentUser();
          await AuthUtlity.removeUserData();
          AppRouter.router.go(AppRoutes.signIn);
          var error = json.decode(response.body);
          throw UnauthorisedException(error.toString());
        case 404:
        case 405:
          return json.decode(response.body);
        case 403:
          var error = json.decode(response.body);
          throw UnauthorisedException(error.toString());
        case 500:
          throw UnauthorisedException("Internal Server Error");
        default:
          throw FetchDataException(
            'Error occurred while communicating with Server: ${response.statusCode}',
          );
      }
    } catch (e) {
      debugPrint("⚠️ Error decoding JSON or handling response: $e");
      throw FetchDataException("Unexpected error while parsing response.");
    }
  }

  Future<dynamic> deleteAPICallWithHeader(
    BuildContext context,
    String url, {
    Map<String, String>? headerData,
  }) async {
    debugPrint("Calling DELETE API: $url");

    var responseJson;
    try {
      final response = await http.delete(Uri.parse(url), headers: headerData);
      debugPrint("API Response: ${response.body}");

      var data = jsonDecode(response.body);
      if (response.statusCode == 422 || response.statusCode == 400) {
        Ui.showErrorSnackBar(context, message: data["message"]);
      }
      if (response.statusCode == 200) {
        Ui.showSuccessSnackBar(context, message: data["message"]);
      }

      responseJson = _response(response);
      debugPrint("Processed Response: $responseJson");
    } on SocketException catch (_) {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }
}
