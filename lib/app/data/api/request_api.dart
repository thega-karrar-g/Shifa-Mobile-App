import 'package:dio/dio.dart' as d;
import 'package:http/http.dart' as http;

import 'app_urls.dart';
import 'base_api.dart';

class RequestApi extends BaseApi {
  static final _appointmentApi = RequestApi._internal();

  factory RequestApi() {
    return _appointmentApi;
  }

  RequestApi._internal();

  var appointment = (AppUrls.teleAppointments);

  Future<http.Response?> getAppointments({String type = 'tele'}) async {
    try {
      String url = AppUrls.teleAppointments;
      switch (type) {
        case 'hhc':
          {
            url = AppUrls.hhcAppointments;
          }
          break;
        case 'tele':
          {
            url = AppUrls.teleAppointments;
          }
          break;

        case 'phy':
          {
            url = AppUrls.physiotherapyAppointments;
          }
          break;

        case 'hvd':
          {
            url = AppUrls.hvdAppointments;
          }
          break;

        default:
          {
            url = AppUrls.teleAppointments;
          }
      }

      var response = await api.httpGet(url + currentUser!.id);

      return response;
    } catch (e) {
      //
      return null;
    }
  }

  Future<d.Response?> getRequests({String id = ''}) async {
    try {
      var response = await api.dioGet(AppUrls.getInstantConsultation + id);

      return response;
    } catch (e) {
      return null;

      //
    }
  }

  Future<http.Response?> getPeriods({String url = AppUrls.periodsHHC}) async {
    // try {
    var response = await api.httpGet(url);

    return response;
    // } catch (e) {
    //   //
    // }
  }

  Future<http.Response?> getPCRPeriods(
      {String url = AppUrls.periodsHHC}) async {
    // try {
    var response = await api.httpGet(url);

    return response;
    // } catch (e) {
    //   //
    // }
  }

  var bookings = AppUrls.createAppointment;

  Future<d.Response?> updateFcmToken(Map<String, String> data) async {
    try {
      var response = await api.dioPost(
        AppUrls.updateFcmToken,
        body: data,
      );

      return response;
    } catch (e) {
      //
      print(e.toString());

      return null;
    }
  }
  Future<d.Response?> setPaymentStatus(Map<String, String> data) async {
    try {
      var response = await api.dioPost(
        AppUrls.setPaymentStatus,
        body: data,
      );

      return response;
    } catch (e) {
      //
      print(e.toString());

      return null;
    }
  }

  Future<d.Response?> createInstantCon(Map<String, String> data) async {
    try {
      var response = await api.dioPost(
        AppUrls.createInstantCon,
        body: data,
      );

      return response;
    } catch (e) {
      //
      // print(e.toString());

      return null;
    }
  }

  Future<d.Response?> makeBookingWithFileDio(Map<String, String> data) async {
    // try {
    var response = await api.uploadFileDio(
      body: data,
    );

    return response;
    // } catch (e) {
    //   //
    //   print(e.toString());
    //   return null;
    //
    // }
  }

  Future<http.Response?> makeBooking(
      {Map<String, dynamic>? data, String type = ''}) async {
    // try {
    var response = await api.httpPost(bookings + type, body: data);

    return response;
    // } catch (e) {
    //   //
    // }
  }

  Future<d.Response?> requestSleepMedicine(data) async {
    try {
      var response =
          await api.dioPost(AppUrls.requestSleepMedicine, body: data);

      return response;
    } catch (e) {
      //
      return null;
    }
  }

  Future<d.Response?> requestCaregiver(data) async {
    try {
      var response = await api.dioPost(AppUrls.requestCaregiver, body: data);

      return response;
    } catch (e) {
      //
      return null;
    }
  }

  Future<d.Response?> contactUs(data) async {
    try {
      var response = await api.dioPost(AppUrls.contactUs, body: data);

      return response;
    } catch (e) {
      //
      return null;
    }
  }

  Future<d.Response?> rateConsultation(Map<String, String> data) async {
    try {
      var response = await api.dioPost(
        AppUrls.rateInstantCon,
        body: data,
      );

      return response;
    } catch (e) {
      //
      print(e.toString());

      return null;
    }
  }
}
