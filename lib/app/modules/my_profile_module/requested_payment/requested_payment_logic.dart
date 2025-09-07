import 'dart:io';

import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../base_controller/base_controller.dart';
import '../../../core/language_and_localization/app_strings.dart';
import '../../../data/constants/booking_constants.dart';
import '../../../data/models/requested_payment.dart';
import '../../../data/repositories/payment_repository.dart';
import '../../../global_widgets/shared/different_dialogs.dart';
import '../../../routes/app_route_names.dart';
import '../../booking_home_modules/appointment_base_controllers/appointment_base_controller.dart';

class RequestedPaymentLogic extends BaseController {
  final PaymentRepository _paymentRepository = PaymentRepository();

  List<RequestedPayment> requests = [];
  List<RequestedPaymentGroup> requestsGroup = [];

  static String details = '';
  static int requestId = 1;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    getData();
  }

  getData() async {
    setBusy(true);
    requests = (await _paymentRepository.getRequestedPaymentList())
        .where((element) => element.state.toLowerCase() != 'reject')
        .toList();


    requestsGroup=groupFilesByData(requests);


    update();



    setBusy(false);
  }

  openPayment({bool applePay = false}) async {
    DifferentDialog.showPaymentLoading();

     await AppointmentBaseController().performtrxn(
        orderId: '$requestId',
        failRoute: AppRouteNames.requestedPaymentDetails,
        transType: Platform.isIOS && applePay ? 'applepay' : 'hosted');
  }

  Future<dynamic> setRequestedPaymentStatus(
      {String paymentReference = '',brandName='', bool showDialog = false}) async {
    BookingConstants.paymentFromInstantCons = false;

    if (showDialog) {
      DifferentDialog.showProgressDialog();
    }

   var result=  await _paymentRepository.setRequestedPaymentStatus(body: {
      'payment_id': '$requestId',
      'payment_reference': paymentReference,
      'consultancy_price': paymentReference.isNotEmpty? BookingConstants.price.toString():'0',
     'payment_method_name':brandName,

    });

    print(result);
    if (showDialog) {
      Get.back();
    }
  }





  List< RequestedPaymentGroup> groupFilesByData(List<RequestedPayment> files) {
    final groups = groupBy(files, (RequestedPayment e) {
      var d=(e.date!);
      return DateTime(d.year,d.month,d.day);
    });
    requestsGroup.clear();
    groups.forEach((key, value) {

      requestsGroup.add(RequestedPaymentGroup(dateTime: key,requestedPayment: value));

    });
    requestsGroup.sort((a, b) =>  a.dateTime .compareTo(b.dateTime));
    return  requestsGroup.reversed.toList();
  }

  String dateConverter(DateTime myDate) {
    String date='Today';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    final dateToCheck = myDate;
    final checkDate = DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);
    if (checkDate == today) {
      date = AppStrings.today;
    } else if (checkDate == yesterday) {
      date = AppStrings.yesterday;
    }
    else {
      date = DateFormat("d MMM yyyy",Get.locale.toString()).format(myDate);
    }
    return date;
  }

}
