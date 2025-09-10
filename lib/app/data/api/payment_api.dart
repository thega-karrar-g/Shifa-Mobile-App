import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import 'app_urls.dart';
import 'base_api.dart';

class PaymentApi extends BaseApi {
  static final _paymentApi = PaymentApi._internal();

  factory PaymentApi() => _paymentApi;

  PaymentApi._internal();

  Future<http.Response?> getRequestedPayment() async {
    try {
      var response = await api.httpGet(
        AppUrls.requestedPayment + currentUser!.id,
      );
      return response;
    } on DioException catch (_) {
      //
      return null;
    }
  }

  Future<http.Response?> setRequestedPaymentStatus(
      {Map<String, dynamic>? body}) async {
    try {
      var response = await api.httpPost(AppUrls.paymentChecker, body: body);
      return response;
    } on DioException catch (_) {
      //
      return null;
    }
  }

  Future<http.Response?> getInsuranceCompanies() async {
    try {
      var response = await api.httpGet(
        AppUrls.insurance,
      );
      return response;
    } on DioException catch (_) {
      //
      return null;
    }
  }
}
