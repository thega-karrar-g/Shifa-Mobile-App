
import '../../../base_controller/base_controller.dart';
import '../../../data/models/refund_request_model.dart';
import '../../../data/repositories/appointment_requests_repository.dart';

class RefundCancelRequestController extends BaseController {

  final AppointmentRequestsRepository appointmentRequestsRepository=AppointmentRequestsRepository();


  List<RefundRequestModel> refundRequests=[];


  getRefundRequests()async{

    setBusy(true);

  refundRequests=await  appointmentRequestsRepository.getRefundRequests();

  setBusy(false);
  }



  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    getRefundRequests();

  }

}
