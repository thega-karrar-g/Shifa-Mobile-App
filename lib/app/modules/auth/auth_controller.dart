import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';


import '../../base_controller/base_controller.dart';
import '../../core/language_and_localization/app_strings.dart';
import '../../data/api/api.dart';
import '../../data/api/auth_api.dart';
import '../../data/constants/booking_constants.dart';
import '../../data/models/questionnaire.dart';
import '../../data/models/user_model.dart';
import '../../global_widgets/shared/different_dialogs.dart';
import '../../routes/app_route_names.dart';
import '../../data/api/api_keys.dart';
import '../appointment/appointment_types_logic.dart';
import '../booking_home_modules/instant_consultation_module/instant_consultation_home/instant_consultation_home_logic.dart';
import '../booking_home_modules/instant_consultation_module/instant_consultation_home/instant_consultation_home_view.dart';
import '../booking_home_modules/instant_consultation_module/instant_consultation_states/instant_consultation_states_logic.dart';
import '../booking_home_modules/patient_data/patient_data_logic.dart';
import '../home_tabs/home_tabs_controller.dart';
import '../select_patient/select_patient_logic.dart';

class AuthController extends BaseController {
  final AuthApi _authApi = AuthApi();
  final GetStorage rememberBox = GetStorage();

  bool hidePassword = true;
  bool isLoading = false;
  int profileIndex = 0;
  RxInt genderIndex = 0.obs;

  int step = 0;
  TextEditingController dobTextEditingController = TextEditingController();

  DateTime? dob = DateTime.now();

  updateDateTime(DateTime dateTime) {
    dob = dateTime;
    update();
  }

  var mapUser = {};
  var resultLocation = '';
  int gender = 0;

  String genderType = 'Male';
  final Questionnaire nationality = Questionnaire(
    question: AppStrings.nationality,
  );


  updateNationality(bool value) {
    nationality.answer = value;
    update();
  }

  updateGender(int index) {
    gender = index;
    genderType = gender == 0 ? 'Male' : 'Female';

    update();
  }

  updateStep(int st) {
    step = st;
    update();
  }

  updateLocation(String? txt) {
    if (txt != null && txt.isNotEmpty) {
      resultLocation = txt;
    } else {
      buildFailedSnackBar(msg: AppStrings.selectLocationMsg.tr);
    }

    update();
  }

  updateGenderIndex(int selected) {
    genderIndex.value = selected;
    update();
  }

  updateProfileIndex(int selected) {
    profileIndex = selected;
    update();
  }

  updatePassword(bool hide) {
    hidePassword = hide;
    update();
  }

  updateLoading(bool load) {
    isLoading = load;
    update();
  }

  void login2(Map<String, dynamic> allValues) async {
    if (!noInternetConnection()) {
      setBusy(true);

      await DifferentDialog.showProgressDialog();
      var username =
          allValues[ApiKeys.smsUserName.toLowerCase()].toString().trim();
      var password =
          allValues[ApiKeys.formPassword.toLowerCase()].toString().trim();
      var data = {
        ApiKeys.smsUserName.toLowerCase(): username,
        ApiKeys.formPassword.toLowerCase(): password,
        // 'db': 'GlobcarePro',
        // 'db': 'shifa_server_db',
      };

      _authApi.getLoginHttp(data).then((value) async {
        try {
          if (value != null) {
            var jsonResponse = (value.data);

            Get.back();

           // print(jsonResponse);
            if (jsonResponse['success'] == 1) {
              rememberBox.write(ApiKeys.remember.toLowerCase(), true);
              rememberBox.write(ApiKeys.smsUserName.toLowerCase(), username);
              rememberBox.write(ApiKeys.formPassword, password);

              var userMap = jsonResponse['data'];

              AppUser user = AppUser.fromMap(userMap);
              user.token = Api.token;
              user.userType = '1';

           await   authService.saveUserInfoToHive(user);

            await  authService.setupDb();

              var mf = Get.find<SelectPatientLogic>();
              var appointmentTypesCtrl = Get.find<AppointmentTypesLogic>();

              mf.onInit();
              appointmentTypesCtrl.onInit();

              if(BookingConstants.fromPatientData ==true ) {



                if(InstantConsultationHomeLogic.fromInstantConsultation){
                  InstantConsultationHomeLogic.fromInstantConsultation = false;

                  //   Get.offNamedUntil(InstantConsultationHomePage.routeName,ModalRoute.withName(AppRouteNames.home),);

                  Get.offNamedUntil(AppRouteNames.homeTabs,(route)=>false);
                  Get.toNamed(
                    InstantConsultationHomePage.routeName,
                  );

                }
                else{
                  // Get.back(result: true);
                  Get.offNamedUntil(AppRouteNames.patientData,ModalRoute.withName(PatientDataLogic.previousRoute),);

                  // Get.toNamed(AppRouteNames.patientData);
                }



              }

              else{



                if(Get.isRegistered<InstantConsultationStatesLogic>()){


                  Get.delete<InstantConsultationStatesLogic>(force: true);
                  Get.put(InstantConsultationStatesLogic(),permanent: true);

                }

                Get.offNamedUntil(AppRouteNames.homeTabs,(route)=>false);

              }


            } else if (jsonResponse['success'] == 0) {
              buildFailedSnackBar(msg: AppStrings.invalidData.tr);
//Get.back();
            }
          } else {
            Get.back();

            buildFailedSnackBar(msg: AppStrings.thereIsProblem.tr);
          }

          setBusy(false);
        } catch (e) {
          Get.back();

          buildFailedSnackBar(msg: AppStrings.thereIsProblem.tr);
          setBusy(false);
          print(e.toString());
        }
      });
    } else {
      buildFailedSnackBar(msg: AppStrings.checkInternet.tr);
    }
  }

  void forgetPassword(Map<String, dynamic> allValues) async {
    if (!noInternetConnection()) {
      setBusy(true);

      await DifferentDialog.showProgressDialog();

      var data = {
        'mobile': '966${allValues['mobile']}'  ,
        'ssn': allValues['ssn'],
        'user_type': '1',
      };
      _authApi.forgetPasswordHttp(data).then((value) async {
        try {
          var jsonResponse = (value!.data);

         // logger.i(jsonResponse);
          Get.back();

          if (jsonResponse['success'] == 1) {
            var userMap = jsonResponse['data'];

            AppUser user = AppUser.fromMap(userMap);
            user.token = Api.token;
            user.userType = '1';

            // authService.saveUserInfoToHive(user);

            Get.toNamed(AppRouteNames.verify, arguments: user);
          } else if (jsonResponse['success'] == 0) {
            buildFailedSnackBar(msg: AppStrings.invalidData.tr);
//Get.back();
          }

          setBusy(false);
        } catch (e) {
          Get.back();

          setBusy(false);
          print(e.toString());
        }
      });
    } else {
      buildFailedSnackBar(msg: AppStrings.checkInternet.tr);
    }
  }
  Future resetPassword(Map<String, dynamic> allValues) async {
    if (!noInternetConnection()) {
      setBusy(true);

      await DifferentDialog.showProgressDialog();

      var data = {
        'patient_id': allValues['id']  ,
        'new_password': allValues['code'],
      };
      _authApi.resetPasswordHttp(data).then((value) async {
        try {
          var jsonResponse = (value!.data);

          Get.back();

          if (jsonResponse['success'] == 0) {
            buildFailedSnackBar(msg: AppStrings.invalidData.tr);
//Get.back();
          }

          setBusy(false);
        } catch (e) {
          Get.back();

          setBusy(false);
          print(e.toString());
        }
      });
    } else {
      buildFailedSnackBar(msg: AppStrings.checkInternet.tr);
    }
  }

  void getUserDetails({String id = '0'}) async {
    if (!noInternetConnection()) {
      setBusy(true);

      _authApi.getUserDetailsHttp(id: id).then((value) async {
        try {
          var jsonResponse = json.decode(value!.body);

          if (jsonResponse['success'] == 1) {
            var userMap = jsonResponse['data'] as List;

            AppUser user = AppUser.fromMap(userMap[0]);
            user.token = Api.token;
            user.userType = '1';

            authService.saveUserInfoToHive(user);



            // if(BookingVars.fromPatientData !=null){
            //
            //   Get.back();
            // }
            // else{
            //   Get.offAllNamed(AppRouteNames.home);
            // }

          } else if (jsonResponse['success'] == 0) {
            setBusy(false);
          }

          setBusy(false);
        } catch (e) {
          setBusy(false);
        }
      });
    } else {}
  }

  void register(Map<String, dynamic> data) async {
    if (!noInternetConnection()) {
      setBusy(true);

      DifferentDialog.showProgressDialog();

      _authApi.getRegisterHttp(data).then((value) async {
        try {
          var respo = json.decode(value!.body.toString());

          Get.back();
          if (respo['success'] == 1) {
            // print('id:************************* ${respo['data']['id']} ');
            // login2({'username':data['ssn'],'password':data['password']});
            //  buildSuccessSnackBar(msg: respo['data']['message']);

            var userMap = respo['data'];

            AppUser user = AppUser.fromMap(userMap);
            user.token = Api.token;
            user.userType = '1';

            authService.saveUserInfoToHive(user);

            await  authService.setupDb();

            var mf = Get.find<SelectPatientLogic>();
            var appointmentTypesCtrl = Get.find<AppointmentTypesLogic>();

            mf.onInit();
            appointmentTypesCtrl.onInit();

            if (BookingConstants.fromPatientData != null) {
              Get.back();
            } else {
              String id = '';
              if (currentUser != null) {
                id = currentUser!.id;
              }

              Get.offNamedUntil(AppRouteNames.homeTabs,(route)=>false,arguments: id);

            }

            setBusy(false);

            //   await DifferentDialog.hideProgressDialog();
            //  DifferentDialog.showRegisterSuccessDialog2();

            // Get.toNamed(AppRouteNames.successRegister);

          } else {
            buildFailedSnackBar(msg: respo['message']);
          }

          setBusy(false);
        } catch (e) {
          setBusy(false);
        }
      });
    } else {
      buildFailedSnackBar(msg: AppStrings.checkInternet.tr);
    }
  }

  Future<dynamic> addMember(Map<String, dynamic> data) async {
    if (!noInternetConnection()) {
      setBusy(true);

      DifferentDialog.showProgressDialog();

      _authApi.addMemberHttp(data).then((value) async {
      //  try {
            var response = (value);


            Get.back();
            if (response['success'] == 1) {
              var mf = Get.find<SelectPatientLogic>();
              var appointmentTypesCtrl = Get.find<AppointmentTypesLogic>();

              mf.onInit();
              appointmentTypesCtrl.onInit();

              var back = await DifferentDialog.showRequestServiceSuccessDialog(
                  msg: AppStrings.newMemberMsg, isBack: true);

              if (back == true) {
                Get.back(result: true);
              }

              setBusy(false);
            } else {
              buildFailedSnackBar(msg: response['message'].toString().tr);
            }


          setBusy(false);
        // } catch (e) {
        //   Get.back();
        // //  buildFailedSnackBar(msg: AppStrings.thereIsProblem.tr);
        //
        //   setBusy(false);
        // }
      });
    } else {
      buildFailedSnackBar(msg: AppStrings.checkInternet.tr);
    }
  }

  void registerGuest(Map<String, dynamic> data) async {
    if (!noInternetConnection()) {
      setBusy(true);

      DifferentDialog.showProgressDialog();
      print(data);
      _authApi.getRegisterGuestHttp(data).then((value) async {
        try {
          var respo = json.decode(value!.body.toString());

          Get.back();
          if (respo['success'] == 1) {
            // login2({'username':data['ssn'],'password':data['password']});
            //  buildSuccessSnackBar(msg: respo['data']['message']);

            var userMap = respo['data'];
            userMap['mobile'] = data['mobile'];
            userMap['dob'] = '2022-1-1';
            AppUser user = AppUser.fromMapGuest(userMap);
            user.token = Api.token;
            user.userType = '2';
            user.dob = '2022-1-1';

            authService.saveUserGuestInfoToHive(user);

            if (BookingConstants.fromPatientData != null) {
              Get.back();
            } else {
              Get.offAllNamed(AppRouteNames.homeTabs);
            }

            setBusy(false);

            //   await DifferentDialog.hideProgressDialog();
            //  DifferentDialog.showRegisterSuccessDialog2();

            // Get.toNamed(AppRouteNames.successRegister);

          } else {
            buildFailedSnackBar(msg: respo['message']);
          }

          setBusy(false);
        } catch (e) {
          setBusy(false);
        }
      });
    } else {
      buildFailedSnackBar(msg: AppStrings.checkInternet.tr);
    }
  }

  void editProfile(Map<String, dynamic> data) async {
    //  var dob = DateFormat('yyyy-MM-dd').format(data['dob']);
    var myData = {
      'login': data['login'],
      'name': data['name'],
      'password': data['password'],
    };

    DifferentDialog.showProgressDialog();

    _authApi.register(myData).then((value) {
      if (value!.data!['success'] == 1) {
      } else {
        buildFailedSnackBar(msg: value.data['message']);
      }
    });

    // var result = await _userRepository.loginWithEmailThenGetUserData(user);
    await DifferentDialog.hideProgressDialog();

    //  Get.toNamed(AppRouteNames.home);
  }


  final addressController = TextEditingController(text: '');

  changePassword(query) async {
    DifferentDialog.showProgressDialog();

    var edit = await _authApi.changePasswordHttp(query);

    var jsonRes = json.decode(edit!.body.toString());

    Get.back();

    if (jsonRes['success'] == 1) {
      var res = await DifferentDialog.showEditProfileSuccessDialog(
          msg: AppStrings.passwordUpdateSuccessfully);

      if (res) {
        Get.back();
      }
    } else {
      buildFailedSnackBar(msg: jsonRes['message'].toString());
      return false;
    }
  }

  registerMap(map) => {
        'name': map['fname'] + '  ' + map['midname'] + '  ' + map['lastname'],
        'username': map['mobile'],
        'password': map['password'],
        'email': map['login'],
        'mobile': map['mobile'],
        'street': map['location'],
        'ssn': map['ssn'],
        'gender': map['gender'],
        'dob': DateFormat('dd/MM/yyyy')
            .format(DateTime.parse(map['dob'].toString().substring(0, 10))),
      };


}
