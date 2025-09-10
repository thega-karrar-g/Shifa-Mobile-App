import 'package:dio/dio.dart';

import 'base_api.dart';

class PaymentApi extends BaseApi {
  static final _paymentApi = PaymentApi._internal();

  factory PaymentApi() => _paymentApi;

  PaymentApi._internal();

  Future<Response?> makePaymentRequest({required dynamic body}) async {
    try {
      var mBody = {
        'date': '2023-02-28',
        'provider_id': 1,
        'service_id': 3,
        'service_type': 'package',
        'member_ids': '',
        'is_user_included': 1,
        'location_id': 1,
//coupon:202202
        'payment_method_id': 9
      };
      var response = await api.dioPostPayment(
          'https://eazycare.app/api/v1/direct-order',
          body: mBody);
      return response;
    } on DioException catch (_) {
      //
      return null;
    }
  }
}
