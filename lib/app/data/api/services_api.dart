import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import 'app_urls.dart';
import 'base_api.dart';

class ServiceApi extends BaseApi {
  static final _serviceApi = ServiceApi._internal();

  factory ServiceApi() => _serviceApi;

  ServiceApi._internal();

  Future<http.Response?> getServices() async {
    try {
      var response = await api.httpGet(
        AppUrls.services,
      );
      return response;
    } on DioError catch (_) {
      //
    }
    return null;
  }
}
