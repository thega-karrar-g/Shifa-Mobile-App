import 'package:get/get.dart';

import 'notifications_logic.dart';

class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NotificationsLogic());
  }
}
