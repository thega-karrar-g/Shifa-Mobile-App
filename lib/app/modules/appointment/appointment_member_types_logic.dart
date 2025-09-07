import 'package:get/get.dart';

import '../../base_controller/base_controller.dart';
import '../../core/assets_helper/app_images.dart';
import '../../core/language_and_localization/app_strings.dart';
import '../../data/constants/booking_constants.dart';
import '../../data/models/count.dart';
import '../../data/models/home_service.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/appointment_repository.dart';
import '../booking_home_modules/service_details/service_details_logic.dart';
import 'appointment_controller.dart';

class AppointmentMemberTypesLogic extends BaseController {
  final AppointmentRepository _appointmentRepository = AppointmentRepository();

  var count = Count();

  List<HomeService> appointmentTypes = [];

  AppUser user = Get.arguments;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    AppointmentController.user = user;

    getCount();
  }

  getCount() async {
    setBusy(true);
    count = await _appointmentRepository.getAppointmentTypesCount(
        patientId: user.id);

    appointmentTypes.clear();

    if (count.tele > 0) {
      appointmentTypes.add(
        HomeService(
            id: 1,
            name: AppStrings.telemedicineAppointments,
            description: AppStrings.telemedicineAppointments,
            icon: AppImages.iconTeleMed,
            code: 'tele'),
      );
    }

    if (count.phys > 0) {
      appointmentTypes.add(HomeService(
          id: 1,
          name: AppStrings.physiotherapistAppointments,
          description: AppStrings.physiotherapistAppointments,
          icon: AppImages.iconPhys,
          code: 'phy'));
    }

    if (count.hhc > 0) {
      appointmentTypes.add(
        HomeService(
            id: 1,
            name: AppStrings.hhcAppointments,
            description: AppStrings.hhcAppointments,
            icon: AppImages.iconNurse,
            code: 'hhc'),
      );
    }

    if (count.pcr > 0) {
      appointmentTypes.add(
        HomeService(
            id: 1,
            name: AppStrings.pcrAppointments,
            description: AppStrings.pcrAppointments,
            icon: AppImages.iconPcr,
            code: 'pcr'),
      );
    }

    if (count.hvd > 0) {
      appointmentTypes.add(HomeService(
          id: 1,
          name: AppStrings.homeVisitAppointments,
          description: AppStrings.homeVisitAppointments,
          icon: AppImages.iconHVD,
          code: 'hvd'));
    }
    setBusy(false);
  }

  onAppointmentTypeTab(HomeService homeService){
    if (homeService.next.isNotEmpty) {
      if (homeService.code == 'PCR') {
        //PatientDataLogic.appointmentType='-hhc';
        BookingConstants.isPcr = true;
      } else {
        BookingConstants.isPcr = false;
      }
      ServiceDetailsLogic.serviceCode = homeService.code;

      Get.toNamed(homeService.next, arguments: homeService);
    } else {
      soonMessage();
    }
  }

}
