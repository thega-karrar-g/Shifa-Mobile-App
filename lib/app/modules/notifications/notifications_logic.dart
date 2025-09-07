
import '../../base_controller/base_controller.dart';
import '../../data/models/notification_model.dart';
import '../../data/repositories/notifications_repository.dart';

class NotificationsLogic extends BaseController {


final  NotificationsRepository notificationsRepository=NotificationsRepository();
  List<NotificationModel> notificationList=[];


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();



getNotificationList();

  }


  getNotificationList()async{

    setBusy(true);

 notificationList=await   notificationsRepository.getNotificationList();

    setBusy(false);

  }

}
