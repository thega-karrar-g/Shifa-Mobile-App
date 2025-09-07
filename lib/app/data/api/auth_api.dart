import 'package:dio/dio.dart';
import 'package:globcare/app/core/language_and_localization/app_strings.dart';
import 'package:globcare/app/data/api/api_keys.dart';
import 'package:http/http.dart' as http;

import 'app_urls.dart';
import 'base_api.dart';

class AuthApi extends BaseApi {
  static final _loginApi = AuthApi._internal();

  factory AuthApi() {
    return _loginApi;
  }

  AuthApi._internal();

  var login = AppUrls.getUrl(AppUrls.loginPatient, withExtension: false);
  var registerPatient =
      AppUrls.getUrl(AppUrls.registerPatient, withExtension: false);
  var registration = AppUrls.registration;
  var edit = AppUrls.editProfile;
  var profile = AppUrls.getUrl(AppUrls.userDetails, withExtension: false);

  Future<Response?> getMembers() async {
    try {
      var response = await api.dioGet(AppUrls.getMembers + currentUser!.id);

      return response;
    } catch (e) {
      return null;

      //
    }
  }

  Future<http.Response?> getLogin(query) async {
    try {
      var response = await api.httpPost(login, body: query);

      return response;
    } catch (e) {
      return null;

      //
    }
  }

  Future<http.Response?> getUserDetailsHttp({String id = '0'}) async {
    var response = await api.httpUserDetails(id: id);

    return response;
  }

  Future<Response?> getLoginHttp(query) async {
    try {
      //  var q="?login=smartmind&password=medical25@Sm%2321&db=smartmind_medical&device_type=1";

      var response = await api.httpLogin(login, query: query);

      return response;
    } catch (_) {
      return null;
    }
  }

  Future<Response?> forgetPasswordHttp(query) async {
    //  try {
    //  var q="?login=smartmind&password=medical25@Sm%2321&db=smartmind_medical&device_type=1";

    var response = await api.httpLogin(AppUrls.forgetPassword, query: query);

    return response;
    // }catch(_){
    //
    // }
  }
  Future<Response?> resetPasswordHttp(query) async {
    //  try {
    //  var q="?login=smartmind&password=medical25@Sm%2321&db=smartmind_medical&device_type=1";

    var response = await api.httpLogin(AppUrls.resetPassword, query: query);

    return response;
    // }catch(_){
    //
    // }
  }

  Future<http.Response?> getRegisterGuestHttp(query) async {
    //  try {

    //  var q="?login=smartmind&password=medical25@Sm%2321&db=smartmind_medical&device_type=1";

    var response =
        await api.httpRegister(AppUrls.registerPatientGuest, query: query);

    return response;
  }

  Future<dynamic> addMemberHttp(Map<String, dynamic> body) async {
    var resFail={ApiKeys.responseSuccess:0,ApiKeys.responseMessage:AppStrings.thereIsProblem};

    try {


      var response = await api.dioPost2(AppUrls.addMember, body: body);

      if(response.statusCode==200){

      return response.data;}

      else{
        return resFail;
      }

    } catch (e) {
      return resFail;
    }
  }

  Future<http.Response?> getRegisterHttp(query) async {
    //  try {

    //  var q="?login=smartmind&password=medical25@Sm%2321&db=smartmind_medical&device_type=1";

    var response = await api.httpRegister(registerPatient, query: query);

    return response;
  }

  Future<http.Response?> editProfileHttp(query) async {
    //  try {

    //  var q="?login=smartmind&password=medical25@Sm%2321&db=smartmind_medical&device_type=1";

    var response =
        await api.httpEditProfile(edit + currentUser!.id, query: query);

    return response;
  }

  Future<http.Response?> changePasswordHttp(query) async {
    //  try {

    //  var q="?login=smartmind&password=medical25@Sm%2321&db=smartmind_medical&device_type=1";

    var response = await api.httpChangePassword(query: query);

    return response;
  }

  Future<Response?> editProfileImageHttp() async {
    var response = await api.updateImage();

    return response;
  }

  Future<Response?> register(query) async {
    try {
      var response = await api.dioPost(registration, body: query);

      return response;
    } catch (e) {
      return null;

      //
    }
  }

  Future<http.Response?> getProfile(String endPath, String token) async {
    try {
      var response = await api.httpGetProfile(endPath, token);

      return response;
    } catch (e) {
      return null;

      //
    }
  }
}
