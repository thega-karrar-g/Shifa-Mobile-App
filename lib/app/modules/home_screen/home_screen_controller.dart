import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:globcare/app/data/models/notification_model.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../base_controller/base_controller.dart';
import '../../core/assets_helper/app_images.dart';
import '../../core/language_and_localization/app_strings.dart';
import '../../data/api/config_api.dart';
import '../../data/constants/booking_constants.dart';
import '../../data/models/home_service.dart';
import '../../data/models/nurse_service.dart';
import '../../data/models/slides_model.dart';
import '../../data/repositories/notifications_repository.dart';
import '../../data/repositories/instant_consultation_repository.dart';
import '../../global_widgets/project_widget/marquee/speed.dart';
import '../../global_widgets/shared/different_dialogs.dart';
import '../../routes/app_route_names.dart';
import '../../data/api/api_keys.dart';
import '../../services/local_notification_service.dart';
import '../../services/push_notification_service.dart';
import '../booking_home_modules/instant_consultation_module/instant_consultation_states/instant_consultation_states_logic.dart';
import '../booking_home_modules/service_details/service_details_logic.dart';
import '../doctor_module/doctors/doctors_controller.dart';

class HomeScreenController extends BaseController with WidgetsBindingObserver {
  List<Slide> slides = <Slide>[];
static List<NotificationModel> notifications=[];
  final  NotificationsRepository notificationsRepository=NotificationsRepository();

  final InstantConsultationRepository requestRepository = InstantConsultationRepository();

  List<String> images=[];



  static int storeVersion = 0;
  static bool isAppInForeground = false;

  final ConfigApi _configApi = ConfigApi();
  String appGoogleId = 'com.globcare.app';

  GetStorage boxVersion = GetStorage();
  GetStorage slidersBox = GetStorage();

  final ScrollController scrollController = ScrollController();
  final Speed speed = Speed.slow;

  List<String> assetsSlides = [
    AppImages.bg1,
    AppImages.bg2,
    AppImages.bg3,
  ];

  RxInt index = 0.obs;

  updateIndex(int current) {
    index.value = current;
    update();
  }

  navToInstantCon() {
    // soonMessage();
    BookingConstants.reset();




    if(currentUser !=null) {

      bool isRegistered = Get.isRegistered<InstantConsultationStatesLogic>();

      if(isRegistered){


        Get.find<InstantConsultationStatesLogic>().checkData(startTimer: true);

      }
      BookingConstants. paymentFromInstantCons = true;


      Get.toNamed(AppRouteNames.instantConsultation,);
    }

    else{
      buildFailedSnackBar(msg: AppStrings.loginRequired.tr);

      Future.delayed(Duration(seconds: 1),(){

        BookingConstants.fromPatientData = null;

        Get.toNamed(AppRouteNames.login);
       // Get.offAllNamed(AppRouteNames.login);

      });

    }



    //
  }



  Future checkVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int currentVersion = int.parse(packageInfo.buildNumber);

    var config = await _configApi.getAppVersion();

    if (config[ApiKeys.responseSuccess] != 0) {
      String platform = Platform.isAndroid ? 'Android' : 'IOS';
      if (int.tryParse(config['data'][platform]) != null) {
        storeVersion = int.parse(config['data'][platform]);
        boxVersion.write('version', storeVersion);
      }
    } else {
      storeVersion = boxVersion.read('version') ?? 0;
    }

    print(storeVersion);
    print(currentVersion);

    if (storeVersion > currentVersion) {
      DifferentDialog.showUpdateAppDialog();
    }



  }






  void navToDoctors() {
    BookingConstants.serviceName = AppStrings.telemedicine.tr;
    BookingConstants.service = NurseService(
        name: AppStrings.telemedicine, nameAr: 'استشارة طبية فيديو');
    BookingConstants.appointmentType = '';
    DoctorsController.doctorType = 'TD';
    BookingConstants.serviceCode = '';

    // Get.to(LocationTestPage(),arguments: AppRouteNames.doctorBook);
    Get.toNamed(AppRouteNames.doctors, arguments: AppRouteNames.doctorBook);
  }


  updateFcmToken()async{
    String fcmToken=await PushNotificationService().getToken();

    Map<String, String> fcmData = {
      'id': currentUser!.id,
      'type':'1',
      'device_type':Platform.isAndroid?'android':'ios',
      'fcm_token':fcmToken,
    };


  var result=  await requestRepository.updateFcmToken(fcmData);
  // logger.i("data $fcmData");
  // logger.i("result $result");
  }


  getNotificationList()async{

    // setBusy(true);


    notifications=await   notificationsRepository.getNotificationList();
    BaseController.notificationCount=notifications.length;
    // setBusy(false);

  }

  navToServices(HomeService homeService)async{


    if (homeService.next.isNotEmpty) {
      if (homeService.code == 'Tel') {
        BookingConstants.serviceName = AppStrings.telemedicine.tr;
        BookingConstants.service = NurseService(
            name: AppStrings.telemedicine, nameAr: 'استشارة طبية فيديو');
        BookingConstants.appointmentType = '';
        DoctorsController.doctorType = 'TD';
        BookingConstants.serviceCode = '';
        Get.toNamed(homeService.next, arguments: homeService);
      } else {



        if(homeService.route==AppRouteNames.map){

          var p=await Geolocator.checkPermission();

          if(p ==LocationPermission.whileInUse||p==LocationPermission.always){

            ServiceDetailsLogic.serviceCode = homeService.code;
            ServiceDetailsLogic.icon = homeService.icon;
            Get.toNamed(homeService.route, arguments: homeService);

          }
          else{


            var request= await Geolocator.requestPermission();

            if(request ==LocationPermission.whileInUse||request==LocationPermission.always){


              ServiceDetailsLogic.serviceCode = homeService.code;
              ServiceDetailsLogic.icon = homeService.icon;
              Get.toNamed(homeService.route, arguments: homeService);

            }
            else{
              buildFailedSnackBar(msg: AppStrings.selectPermissionLocationMsg.tr);

            await  Geolocator.openAppSettings();

            }

          }


        }else{



          ServiceDetailsLogic.serviceCode = homeService.code;
          ServiceDetailsLogic.icon = homeService.icon;
          Get.toNamed(homeService.route, arguments: homeService);
        }

      }
    } else {
      soonMessage();
    }

  }
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Future.doWhile(_scroll);
    });


    checkVersion();
    if(currentUser !=null) {
      updateFcmToken();

    }
  }

  Future<bool> _scroll() async {
    await Future.delayed(speed.pauseDuration);
    if (scrollController.hasClients) {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: speed.animationDuration, curve: Curves.easeOut);
    }
    await Future.delayed(speed.pauseDuration);
    if (scrollController.hasClients) {
      scrollController.animateTo(scrollController.position.minScrollExtent,
          duration: speed.backDuration, curve: Curves.easeOut);
    }
    return true;
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    WidgetsBinding.instance.removeObserver(this);
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.paused:
        {
          isAppInForeground = true;
        }
        // await player.play();
        break;
      case AppLifecycleState.inactive:
        {
          isAppInForeground = false;
        }
        //await player.stop();
        break;
      case AppLifecycleState.resumed:
        {
          isAppInForeground = false;
        }
        //  await player.stop();
        break;
      case AppLifecycleState.detached:
        {
          isAppInForeground = false;
        }
        // await player.stop();
        // TODO: Handle this case.
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }
}

///.. can be separated into service class
