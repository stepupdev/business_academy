import 'package:flutter/material.dart';
import 'api_manager.dart';
import 'api_helper.dart';

class APIManagerWrapper {
  final APIManager _apiManager = APIManager();

  Future<dynamic> postAPICallWithHeader(
    BuildContext context,
    String url,
    Map<String, dynamic> param,
    Map<String, String> headerData,
  ) async {
    return await safeApiCall(() async {
      return await _apiManager.postAPICallWithHeader(url, param, headerData, context);
    });
  }

  Future<dynamic> putAPICallWithHeader(
    String url,
    Map<String, dynamic> param,
    Map<String, String> headerData,
  ) async {
    return await safeApiCall(() async {
      return await _apiManager.putAPICallWithHeader(url, param, headerData);
    });
  }

  Future<dynamic> postAPICall( String url, var param, {var header}) async {
    return await safeApiCall(() async {
      return await _apiManager.postAPICall(url, param, header: header);
    });
  }

  Future<dynamic> multipartPostAPI(
    String url,
    Map<String, String> param,
    var images,
    Map<String, String> headerData,
    String parameterName,
  ) async {
    return await safeApiCall(() async {
      return await _apiManager.multipartPostAPI(url, param, images, headerData, parameterName);
    });
  }

  Future<dynamic> get( String url) async {
    return await safeApiCall(() async {
      return await _apiManager.get(url);
    });
  }

  Future<dynamic> getWithHeader(
    String url,
    Map<String, String> headerData,
  ) async {
    return await safeApiCall(() async {
      return await _apiManager.getWithHeader(url, headerData);
    });
  }

  Future<dynamic> deleteAPICallWithHeader(
    BuildContext context,
    String url, {
    Map<String, String>? headerData,
  }) async {
    return await safeApiCall(() async {
      return await _apiManager.deleteAPICallWithHeader(context, url, headerData: headerData);
    });
  }
}
