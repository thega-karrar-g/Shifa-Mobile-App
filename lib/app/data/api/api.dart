import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart' as mydio;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:http_parser/http_parser.dart';


import '../../base_controller/base_controller.dart';
import '../../modules/booking_home_modules/nurse_services/nurse_services_logic.dart';
import '../../modules/my_profile_module/my_profile/edit_profile_logic.dart';
import '../constants/booking_constants.dart';
import 'api_keys.dart';
import 'app_urls.dart';
import 'interceptor.dart';

class Api extends BaseController {
  static final _instance = Api._internal();

  factory Api() {
    return _instance;
  }

  Api._internal() {
    dio.options = options;

    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    https = IOClient(ioc);
  }

  late IOClient https;
  final ioc = HttpClient();

  //final String _token='709938d3f6711ef8603d3775687e48da2f3261a9';
  //static const String _token='fef8eb88a6f8a044a8dd076ed5fc2f250ebc7792';
  //static const String _token='f7128a1256d2d3ac28271c67e551fd195c55ffc4';
  // static const String token='49a02a1e7b64daeaf3f0c2dcb19abdb18f3bb298';
  //static const String token='b93acb6215c8b5d3c725f77edd58438d51f50a01';
  //static const String token='15edcae1babdb483dfc886103c19e787cd7f786f';
  static const String token = 'f17be66bfacda572e49d36ef456281d2369b67bb';

  //static const String token='c6ea60fe6c0daa29b851a81fff141dca21c0f98c';

  final header = {
    'token': token,
    // 'content-type':'Application/json',
    // 'Accept':'Application/Json',
  };
  final headerPayment = {
    //'token':token,
    'Content-type': 'Application/json',
    'Accept': 'Application/Json',
    'Authorization': 'Bearer MbSWFFd3tEMgVUxVCPehLflP6fe3SYy11X6oZDER',
  };
  final headerSMS = {
    //'token':token,
    'Content-type': 'Application/json',
    'Accept': 'Application/Json',
  };

  var dio = mydio.Dio(); // with default Options

  Future<mydio.Response> dioGet(String endPath) {
    var d = mydio.Dio(mydio.BaseOptions(
      //baseUrl: AppUrls.baseUrl,
      // connectTimeout: 5000,
      // receiveTimeout: 3000,
      headers: {
        'token': token,
        // 'content-type': 'application/json',
        // 'Accept': 'application/json',
        // 'Cookie': 'http://20.86.58.235',
      },
    ));
    d.interceptors.add(AppInterceptors());

    return d.get(
      AppUrls.baseUrl + endPath,
    );
  }

  Future<http.Response> httpUserDetails({String id = '0'}) async {
    var userId = id;

    if (currentUser != null) {
      userId = currentUser!.id;
    }

    Uri u = Uri.parse(AppUrls.baseUrl + AppUrls.userDetails + userId);

    return https.get(u, headers: header);
  }

  Future<mydio.Response> httpLogin(String endPath, {query}) async {
    //  Uri u=Uri.parse(AppUrls.baseUrl + endPath).replace(queryParameters:query );

    //  return https.post(u, headers: header);
    return dioPost(endPath, body: query);
  }

  Future<http.Response> httpRegister(String endPath, {query}) async {
    // Uri url = Uri( host:  AppUrls.baseUrl ,path:AppUrls.endBaseUrl+ endPath,queryParameters: query);

    // print(query);
    Uri u =
        Uri.parse(AppUrls.baseUrl + endPath).replace(queryParameters: query);

    return https.post(u, headers: header);
  }

  Future<http.Response> httpEditProfile(String endPath, {query}) async {
    // Uri url = Uri( host:  AppUrls.baseUrl ,path:AppUrls.endBaseUrl+ endPath,queryParameters: query);

    Uri u =
        Uri.parse(AppUrls.baseUrl + endPath).replace(queryParameters: query);

    return https.post(u, headers: header);
  }

  Future<http.Response> httpChangePassword({query}) async {
    // Uri url = Uri( host:  AppUrls.baseUrl ,path:AppUrls.endBaseUrl+ endPath,queryParameters: query);

    Uri u = Uri.parse(AppUrls.baseUrl + AppUrls.changePassword)
        .replace(queryParameters: query);

    return https.post(u, headers: header);
  }

  mydio.BaseOptions get options {
    // var token = '';
    // if (currentUser != null) {
    //   token = currentUser!.token;
    // }
    return mydio.BaseOptions(
      baseUrl: AppUrls.baseUrl,
      // connectTimeout: 5000,
      // receiveTimeout: 3000,
      headers: {
        'token': token,
        'content-type': 'application/json',
        'Accept': 'application/json',
        'Cookie': 'http://20.86.58.235',
      },
    );
  }

  Future<http.Response> httpGet(String endPath) async {
    Uri url = Uri.parse(AppUrls.baseUrl + endPath);
    // var _user = Get.find<SessionService>().currentUser;

    return http.get(
      url,
      headers: header,
    );
  }

  Future<http.Response> httpGetProfile(String endPath, String token) async {
    Uri url = Uri.parse(AppUrls.baseUrl + endPath);

    var header = {'token': token};

    return http.get(
      url,
      headers: header,
    );
  }

  Future<mydio.Response> dioPost(String endPath, {Map<String, dynamic>? body}) {
    return mydio.Dio(mydio.BaseOptions(
      //baseUrl: AppUrls.baseUrl,
      // connectTimeout: 5000,
      // receiveTimeout: 3000,
      headers: {
        'token': token,
        // 'Content-type': 'application/json',
        // 'Accept': 'application/json'
      },
    )).post(AppUrls.baseUrl + endPath, data: mydio.FormData.fromMap(body!));
  }

  Future<mydio.Response> dioPost2(String endPath,
      {Map<String, dynamic>? body}) {
    return mydio.Dio(mydio.BaseOptions(
      //baseUrl: AppUrls.baseUrl,
      // connectTimeout: 5000,
      // receiveTimeout: 3000,

      followRedirects: false,
      // will not throw errors
      validateStatus: (status) => true,
      headers: {
        'token': token,
        // 'Content-type': 'application/x-www-form-urlencoded',
        // 'Accept': 'application/json'
      },
    )).post(AppUrls.baseUrl + endPath, data: mydio.FormData.fromMap(body!));
  }

  Future<mydio.Response> dioPostPayment(String endPath, {required body}) {
    return mydio.Dio(mydio.BaseOptions(
      // connectTimeout: 5000,
      // receiveTimeout: 3000,
      headers: headerPayment,
    )).post(endPath, data: mydio.FormData.fromMap(body));
  }

  Future<mydio.Response> dioPostSMS(String endPath, {required body}) {
    return mydio.Dio(mydio.BaseOptions(
      // connectTimeout: 5000,
      // receiveTimeout: 3000,
      headers: headerSMS,
    )).post(endPath, data: (body));
  }

  Future<http.Response> httpPost(String endPath,
      {Map<String, dynamic>? body}) async {
    Uri url = Uri.parse(AppUrls.baseUrl + endPath);

    return http.post(url, body: (body), headers: header);
  }

  Future<http.Response> httpPostPayment(String endPath, {dynamic body}) async {
    Uri url = Uri.parse(endPath);

    return http.post(url, body: (body), headers: headerPayment);
  }

  Future<mydio.Response> uploadFileDio({Map<String, String> body = const {}}) async {
    var formData = mydio.FormData.fromMap(body);

    var hasAudio = BookingConstants.audioFile != null;
    var hasAttach = BookingConstants.attachFile != null;
    var hasCamera = BookingConstants.cameraFile != null;
    var fileNameAudio = '';
    var fileNameAttach = '';
    var fileNameCamera = '';

    Uint8List audioBytes = Uint8List(0);
    Uint8List attachBytes = Uint8List(0);
    Uint8List cameraBytes = Uint8List(0);
    mydio.MultipartFile? audioFile, cameraFile, attachFile;

    if (hasAudio) {
      audioBytes = BookingConstants.audioFile!.readAsBytesSync();

      fileNameAudio = BookingConstants.audioFile!.path.split('/').last;
      audioFile = mydio.MultipartFile.fromBytes(audioBytes,
          filename: fileNameAudio, contentType: MediaType('application', '*'));

      formData.files.add(MapEntry(ApiKeys.attachedFile, audioFile));
    }
    if (hasAttach) {
      attachBytes = BookingConstants.attachFile!.readAsBytesSync();

      fileNameAttach = BookingConstants.attachFile!.path.split('/').last;
      attachFile = mydio.MultipartFile.fromBytes(attachBytes,
          filename: fileNameAttach, contentType: MediaType('application', '*'));
      formData.files.add(MapEntry(ApiKeys.attachedFile2, attachFile));
    }
    if (hasCamera) {
      cameraBytes = BookingConstants.cameraFile!.readAsBytesSync();

      fileNameCamera = BookingConstants.cameraFile!.path.split('/').last;

      cameraFile = mydio.MultipartFile.fromBytes(cameraBytes,
          filename: fileNameCamera, contentType: MediaType('application', '*'));

      formData.files.add(MapEntry(ApiKeys.attachedFile3, cameraFile));
    }
    //logger.i(BookingConstants.appointmentType);

    var url = AppUrls.baseUrl +
        AppUrls.createHHCAppointment;

    if (BookingConstants.appointmentType == 'phy') {
      url = AppUrls.baseUrl + AppUrls.createAppointmentPhysiotherapy;
    }
    if (BookingConstants.appointmentType == 'hvd') {
      url = AppUrls.baseUrl + AppUrls.createAppointmentHVD;
    }
    if (Get.isRegistered<NurseServicesLogic>() && Get.find<NurseServicesLogic>().homeService.code == 'Car') {
      url = AppUrls.baseUrl + AppUrls.requestCaregiver;
    }
    if (Get.isRegistered<NurseServicesLogic>() && Get.find<NurseServicesLogic>().homeService.code == 'SM') {
      url = AppUrls.baseUrl + AppUrls.requestSleepMedicine;
    }
    if (BookingConstants.appointmentType == 'pcr') {
      url = AppUrls.baseUrl + AppUrls.createAppointmentPcr;
    }


    // logger.i(url);
    // print(url);

    return await mydio.Dio().post(url,
        options:
            mydio.Options(contentType: 'multipart/form-data', headers: header),
        data: formData);
    // print(response.data);
  }

  Future<mydio.Response> updateImage() async {
    var fileName = EditProfileLogic.profileImage!.path.split('/').last;

    var bytes = await EditProfileLogic.profileImage!.readAsBytes();

    var imageFile = mydio.MultipartFile.fromBytes(bytes,
        filename: fileName, contentType: MediaType('image', '*'));

    var formData = mydio.FormData.fromMap({'': ''});

    formData.files.add(MapEntry(ApiKeys.profileImage, imageFile));

//formData.fields.addAll(body);

    var url = AppUrls.baseUrl + AppUrls.updateProfilePhoto + currentUser!.id;

    var response = await mydio.Dio().put(url,
        options:
            mydio.Options(contentType: 'multipart/form-data', headers: header),
        data: formData);
    return response;
  }
}
