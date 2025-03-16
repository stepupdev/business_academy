import 'dart:convert';
import 'dart:io';
import 'package:business_application/core/utils/ui_support.dart';
import 'package:business_application/core/api/api_exception.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class APIManager {
  Future<dynamic> postAPICallWithHeader(String url, Map<String, dynamic> param, Map<String, String> headerData) async {
    print("Calling API: $url");
    print("Calling parameters: $param");

    var responseJson;
    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode(param), headers: headerData);
      print("api provider bro bro bro bro ${response.body}");
      var data = jsonDecode(response.body);
      if (response.statusCode == 422) {
        Get.showSnackbar(Ui.errorSnackBar(message: data["message"], title: 'Error'.tr));
      } else if (response.statusCode == 400) {
        Get.showSnackbar(Ui.errorSnackBar(message: data["message"], title: 'Error'.tr));
      }
      responseJson = _response(response);

      print("hlw bro ++++++++++++++++++++$responseJson");
    } on SocketException catch (_) {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> postAPICall(String url, var param, {var header}) async {
    print("Calling API: $url");
    print("Calling parameters: $param");

    var responseJson;
    try {
      final response = await http.post(Uri.parse(url), body: param, headers: header);
      print("status code is ${response.statusCode}");
      print("status  ${response}");
      if (response.statusCode == 200) {
        responseJson = _response(response);
        print('APIManager.postAPICall');
        print(responseJson);
      } else if (response.statusCode == 404) {
        responseJson = _response(response);
      } else if (response.statusCode == 405) {
        responseJson = _response(response);
      } else {
        return null;
      }
    } on SocketException catch (_) {
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
    print("Calling API: $url");
    print("Calling parameters: ${param}");
    print(images);
    print(headerData);

    var responseJson;
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields.addAll(param);

      print('fgdf');

      if (images.isNotEmpty) {
        print('APIManager.multipartPostAPI');
        for (var item in images) {
          print(item.runtimeType);
          String fileName = item.path.split("/").last;
          var stream = http.ByteStream(item.openRead());

          stream.cast();

          print(stream);
          // get file length

          var length = await item.length(); //imageFile is your image file

          // multipart that takes file
          var multipartFileSign = http.MultipartFile('image', stream, length, filename: fileName);

          request.files.add(multipartFileSign);
        }
      }
      if (headerData.isNotEmpty) {
        print('APIManager.multipartPostAPI 2');
        request.headers.addAll(headerData);
      }
      print('APIManager.multipartPostAPI 3');
      http.StreamedResponse streamedResponse = await request.send();
      print('APIManager.multipartPostAPI 4');
      var response = await http.Response.fromStream(streamedResponse);

      print(response.statusCode);
      responseJson = _response(response);
      print(responseJson);
    } on SocketException catch (_) {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> get(String url) async {
    print("Calling API: $url");
    var responseJson;
    try {
      final response = await http.get(Uri.parse(url));
      print(response.body);
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
    print("my list is $list");
    print("my body is $body");
    print("my url is $url");

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
    print(response.statusCode);
    print(response.body);

    var bb = jsonDecode(response.body);
    print("my array multipart response is $bb");
    return bb;
  }

  Future<dynamic> getWithHeader(String url, Map<String, String> headerData) async {
    print("Calling API: $url");
    var responseJson;
    try {
      final response = await http.get(Uri.parse(url), headers: headerData);
      print("my getWithHeader method data response ${response.body}");
      responseJson = _response(response);
    } on SocketException catch (_) {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _response(http.Response response) {
    print('APIManager._response');
    print(response);
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 405:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 404:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 500:
        throw UnauthorisedException(response.body.toString());
      default:
        throw FetchDataException(
          'Error occurred while communicating with Server with StatusCode: ${response.statusCode}',
        );
    }
  }
}
