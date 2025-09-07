import 'dart:convert';

import '../api/payment_api.dart';
import '../models/insurance.dart';
import '../models/requested_payment.dart';

class PaymentRepository {
  static final _paymentRepository = PaymentRepository._internal();

  factory PaymentRepository() {
    return _paymentRepository;
  }

  PaymentRepository._internal();

  final PaymentApi _paymentApi = PaymentApi();

  Future<List<RequestedPayment>> getRequestedPaymentList() async {
    var response = await _paymentApi.getRequestedPayment();

    try{

    var jsonData = json.decode(response!.body.toString());

    var d = jsonData['data'] as List;

    return d.map((dr) {
      return RequestedPayment.fromJson((dr));
    }).toList();

    }catch(_){
      return [];
    }
  }

  Future<dynamic> setRequestedPaymentStatus(
      {Map<String, dynamic>? body}) async {
    var response = await _paymentApi.setRequestedPaymentStatus(body: body);

    try {
      var jsonData = json.decode(response!.body.toString());

      return jsonData;
    } catch (_) {
      return {"success": 0};
    }
  }

  Future<List<Insurance>> getInsuranceList() async {
    var response = await _paymentApi.getRequestedPayment();

    try {
      var jsonData = json.decode(response!.body.toString());

      var d = jsonData['data'] as List;

      return d.map((dr) {
        return Insurance.fromJson((dr));
      }).toList();
    } catch (_) {
      return [];
    }
  }
}
