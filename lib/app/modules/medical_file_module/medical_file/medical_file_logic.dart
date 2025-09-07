import 'package:globcare/app/modules/caregive_module/caregiver_home/caregiver_home_view.dart';

import '../../../base_controller/base_controller.dart';
import '../../../core/assets_helper/app_images.dart';
import '../../../core/language_and_localization/app_strings.dart';
import '../../../data/models/home_service.dart';
import '../../../routes/app_route_names.dart';

class MedicalFileLogic extends BaseController {
  List<HomeService> services = [];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    services = [
      HomeService(
          id: 1,
          name: AppStrings.prescriptionList,
          icon: AppImages.iconMedicineList,
          route: AppRouteNames.radiologyLabFiles,
          primary: true,
          code: 'P',
          user: currentUser),
      HomeService(
          id: 1,
          name: AppStrings.labTests,
          icon: AppImages.iconLab,
          route: AppRouteNames.radiologyLabFiles,
          primary: true,
          code: 'L',
          user: currentUser),
      HomeService(
          id: 1,
          name: AppStrings.medFileReport,
          icon: AppImages.iconMedicalReport,
          route: AppRouteNames.radiologyLabFiles,
          primary: true,
          code: 'R',
          user: currentUser),
      HomeService(
          id: 1,
          name: AppStrings.medFileImageTest,
          icon: AppImages.iconXRay,
          route: AppRouteNames.radiologyLabFiles,
          primary: true,
          code: 'X',
          user: currentUser),
      HomeService(
          id: 1,
          name: AppStrings.caregiverFile,
          icon: AppImages.iconCaregiver,
          route: CaregiverHomePage.routeName,
          primary: true,
          code: 'X',
          user: currentUser),
    ];
  }
}
