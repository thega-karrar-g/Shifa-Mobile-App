import 'package:dio/dio.dart';


import 'api_keys.dart';
import 'app_urls.dart';
import 'base_api.dart';

class ConfigApi extends BaseApi {
  static final _configApi = ConfigApi._internal();

  factory ConfigApi() => _configApi;

  ConfigApi._internal();

  Future<dynamic> getAppVersion() async {
    try {
      var response = await api.dioGet(
        AppUrls.appVersion,
      );
      return response.data;
    } on DioException catch (_) {
      //
    }
    return {ApiKeys.responseSuccess: 0};
  }


  Future<dynamic> getSliders() async {
    try {
      var response = await Dio().get('https://transeasysapp.000webhostapp.com/get_sliders.php',);

      // print("*********************************");
      // print(response.data);
      // print("*********************************");
      return response.data;
    }  catch (_) {
      //
      return [];

    }
  }





}
