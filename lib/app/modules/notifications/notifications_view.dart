import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../core/language_and_localization/app_strings.dart';
import '../../core/theme_helper/app_styles.dart';
import '../../global_widgets/shared/my_appbar.dart';
import '../../global_widgets/shared/ui_helpers.dart';
import '../../core/assets_helper/app_anim.dart';
import '../drawer_module/drawer_widget/main_drawer_widget.dart';
import 'notifications_logic.dart';
import 'widgets/empty_notification.dart';
import 'widgets/notification_item.dart';

class NotificationsPage extends StatelessWidget {
  final logic = Get.find<NotificationsLogic>();

  NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawerWidget(),
      body: SafeArea(
        minimum: UiHelper.safeAreaPadding,
        child: GetBuilder<NotificationsLogic>(builder: (controller) {
          return Column(
            children: [
              myAppBar2(title: AppStrings.notifications),

              UiHelper.verticalSpaceLarge,


              Expanded(child:
              logic.busy ? Center(child: UiHelper.spinKitProgressIndicator()) :

              logic.notificationList.isEmpty ? EmptyNotification() :
              ListView.builder(
                  itemCount: logic.notificationList.length,
                  itemBuilder: (bc, index) =>
                      Dismissible(
                          direction: DismissDirection.horizontal,
                          onDismissed: (b) {

                          },
                          dragStartBehavior: DragStartBehavior.start,
                          key: UniqueKey(),
                          child: NotificationItem(notificationModel: logic
                              .notificationList[index],))))
            ],
          );
        }),
      ),
    );
  }
}
