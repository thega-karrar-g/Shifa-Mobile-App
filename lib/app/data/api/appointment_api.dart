import 'package:dio/dio.dart' as d;
import 'package:http/http.dart' as http;

import 'app_urls.dart';
import 'base_api.dart';

class AppointmentApi extends BaseApi {
  static final _appointmentApi = AppointmentApi._internal();

  factory AppointmentApi() {
    return _appointmentApi;
  }

  AppointmentApi._internal();


  var appointment = (AppUrls.teleAppointments);
  var appointmentCount = (AppUrls.appointmentsCount);

  Future<http.Response?> getAppointments(
      {String type = 'tele', String patientId = ''}) async {
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

        case 'pcr':
          {
            url = AppUrls.pcrAppointments;
          }
          break;

        default:
          {
            url = AppUrls.teleAppointments;
          }
      }
      var id = patientId.isNotEmpty ? patientId : currentUser!.id;
      var response = await api.httpGet(url + id);

      return response;
    } catch (e) {
      //
      return null;
    }
  }

  Future<d.Response?> getAppointments1() async {
    try {
      var response = await api.dioGet(appointment);

      return response;
    } catch (e) {
      return null;

      //
    }
  }

  Future<d.Response?> getAppointmentsTypes({String patientId = ''}) async {
    try {
      var response = await api.dioGet(appointmentCount + patientId);

      return response;
    } catch (e) {
      return null;

      //
    }
  }

  Future<http.Response?> getPrice({String url = AppUrls.homeVisitFee}) async {
    // try {
    var response = await api.httpGet(url);

    return response;
    // } catch (e) {
    //   //
    // }
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

  Future<d.Response?> setPaymentStatus(Map<String, String> data,
      {String url = AppUrls.setPaymentStatus}) async {
    try {
      var response = await api.dioPost(
        url,
        body: data,
      );

      return response;
    } catch (e) {
      //
      print(e.toString());

      return null;
    }
  }

  Future<d.Response?> requestCancelAppointment(Map<String, String> data) async {
    try {
      var response = await api.dioPost(
        AppUrls.requestCancelAppointment,
        body: data,
      );

      return response;
    } catch (e) {
      //
      print(e.toString());

      return null;
    }
  }

  Future<d.Response?> makeBookingWithFileDio(Map<String, String> data) async {
    try {
    var response = await api.uploadFileDio(
      body: data,
    );


    return response;
    } catch (e) {
      //
      print(e.toString());
      return null;

    }
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
  Future<d.Response?> appointmentCheckDiscount(data) async {
    // try {
      var response = await api.dioPost(AppUrls.appointmentCheckDiscount, body: data);

      return response;
    // } catch (e) {
    //   //
    //   return null;
    // }
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
}
