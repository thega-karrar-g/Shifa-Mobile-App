import 'package:get/get.dart';
import 'package:globcare/app/utils/group_by.dart';
import 'package:intl/intl.dart';

import '../../../base_controller/base_controller.dart';
import '../../../core/language_and_localization/app_strings.dart';
import '../../../data/constants/booking_constants.dart';
import '../../../data/models/period.dart';
import '../../../data/repositories/appointment_repository.dart';
import '../../../routes/app_route_names.dart';
import '../../../data/api/app_urls.dart';

class ChooseDatePeriodLogic extends BaseController {
  double cardHeight = 120, cardCurve = 90;

  int infoIndex = 0, genderIndex = 0, currentIndex = 0;

  final AppointmentRepository _appointmentRepository = AppointmentRepository();

  changeInfoIndex(int index) {
    infoIndex = index;
    update();
  }

  DateTime selectedDay = DateTime.now();

  changeDay(int index) {
    currentIndex = index;
    updateGender(genderIndex);

    selectedDay = periodItems[index].date;
    updateAppointmentDate();

    //updatePeriods( selectedDay);
    update();
  }

  List<PeriodItem> periodItems = [];
  List<Period> periods = [];
  List<String> dayPeriods = [];

  var route = Get.previousRoute;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();

    var url = AppUrls.periodsHHC;

    var isHHC = false;
    switch (Get.previousRoute) {
      case AppRouteNames.nurseServices:
        {
          BookingConstants.appointmentType = '-hhc';
          url = AppUrls.periodsHHC;
          isHHC = true;
        }
        break;

      case AppRouteNames.radiologyPage:
        {
          BookingConstants.appointmentType = '-hhc';
          url = AppUrls.periodsHHC;
          isHHC = true;
        }
        break;

      case AppRouteNames.vaccination:
        {
          BookingConstants.appointmentType = '-hhc';
          url = AppUrls.periodsHHC;
          isHHC = true;
        }
        break;

      case AppRouteNames.physiotherapistServices:
        {
          BookingConstants.appointmentType = 'phy';
          url = AppUrls.periodsPhysiotherapy;
        }
        break;
    }

    setBusy(true);

    String hvp = await _appointmentRepository.getHomeVisitFee();
    BookingConstants.homeVisitPrice = double.parse(hvp).toInt();

    var list = await _appointmentRepository.getPeriodList(url: url);

    var availableList = list.where((element) => element.available > 0);

    if (isHHC) {
      availableList =
          list.where((element) => element.available > 0 && element.type == 'N');
    }

    if (route == AppRouteNames.serviceDetails) {
      String code = Get.arguments ?? 'N';

      if (code == 'SM' || code == 'GCP' || code == 'MH') {
      } else {
        code = 'N';
      }

      BookingConstants.serviceType = code;

      availableList = list
          .where((element) => element.available > 0 && element.type == code);
    }

    periodItems = availableList
        .groupBy((p0) => p0.date)
        .entries
        .map((e) => PeriodItem(date: e.key, periods: e.value))
        .toList();

    if (periodItems.isNotEmpty) {
      selectedDay = periodItems[0].date;
      updateGender(0);
      changeDay(0);
    }

    for (var element in periodItems) {
      print(
          ' date:${element.date.month}-${element.date.day}   length: ${element.periods.length}');
    }

    setBusy(false);
    update();

    //changeDay(selectedDay);
    var d =
        DateTime(selectedDay.year, selectedDay.month, selectedDay.day, 0, 0, 0);

    BookingConstants.appointmentDate = (d);
  }

  List<String> doctorSlots = [];

  static DateTime selectedTime = DateTime.now();
  static String selectedPeriod = '';

  updatePeriods(DateTime dateTime) {
    dayPeriods.clear();

    for (var element in periods) {
      if ((element.date) == dateTime) {
        // periods.add(element.period);

      }
    }
    update();
  }

  calcPrice() {
    BookingConstants.price = 0;
    BookingConstants.price =
        double.parse(BookingConstants.service.price) * BookingConstants.service.quantity;
    if (BookingConstants.service2.id != 0) {
      cardHeight += 50;
      BookingConstants.price += double.parse(BookingConstants.service2.price) *
          BookingConstants.service2.quantity;
    }
    if (BookingConstants.service3.id != 0) {
      cardHeight += 50;

      BookingConstants.price += double.parse(BookingConstants.service3.price) *
          BookingConstants.service3.quantity;
    }
  }

  selectPeriod({String p = ''}) {
    selectedPeriod = p;
    BookingConstants.period = p;

    update();
  }

  updateAppointmentDate() {
    var appointmentDate =
        DateTime(selectedDay.year, selectedDay.month, selectedDay.day, 0, 0, 0);

    selectedTime = (appointmentDate);
    BookingConstants.appointmentDate = selectedTime;
  }

  updateGender(int gender) {
    genderIndex = gender;
    dayPeriods.clear();

    for (var el in periodItems[currentIndex].periods) {
      if (route == AppRouteNames.physiotherapistServices) {
        if (gender == 0) {
          if (el.gender == 'Male') {
            dayPeriods.add(el.period);
          }
        } else if (gender == 1) {
          if (el.gender == 'Female') {
            dayPeriods.add(el.period);
          }
        }
      } else {
        dayPeriods.add(el.period);
      }
    }

    update();
  }

  periodTime(String period) {
    switch (period) {
      case 'morning':
        return ' 9 ${AppStrings.timeAM.tr} - 12 ${AppStrings.timePM.tr}';
      case 'afternoon':
        return ' 1 ${AppStrings.timePM.tr} - 5 ${AppStrings.timePM.tr}';
      case 'evening':
        return ' 6 ${AppStrings.timePM.tr} - 9 ${AppStrings.timePM.tr}';
    }
  }

  navToPatientData() {
    if (selectedPeriod.isNotEmpty) {
      BookingConstants.period = selectedPeriod;
      BookingConstants.appointmentDate = selectedTime;

      // print(BookingVars.period);
      // print(BookingVars.appointmentDate);

      Get.toNamed(AppRouteNames.patientData);
    } else {
      buildFailedSnackBar(msg: AppStrings.selectPeriodMsg.tr);
    }
  }
}
