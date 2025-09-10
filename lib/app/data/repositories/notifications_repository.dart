
import '../api/api_keys.dart';
import '../api/app_urls.dart';
import '../api/base_api.dart';
import '../models/notification_model.dart';

class NotificationsRepository extends BaseApi{
  static final _notificationsRepository = NotificationsRepository._internal();

  factory NotificationsRepository() {
    return _notificationsRepository;
  }

  NotificationsRepository._internal();


  Future<List<NotificationModel>> getNotificationList() async {
    try {
      var response = await api.dioGet(AppUrls.getNotificationList+currentUser!.id);

      var jsonData = response.data;
// print(jsonData);
      if (jsonData[ApiKeys.responseSuccess] == 1) {
        var d = jsonData['data'] as List;
        var dd = d.map((dr) {
          return NotificationModel.fromJson((dr));
        }).toList();

        return dd;
      } else {
        return [];
      }
    } catch (_) {
      return [];
    }
  }

}
