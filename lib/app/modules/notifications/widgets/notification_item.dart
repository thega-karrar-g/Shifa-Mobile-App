import 'package:flutter/material.dart';
import 'package:globcare/app/core/assets_helper/app_images.dart';
import 'package:intl/intl.dart' as intl;

import '../../../core/theme_helper/app_colors.dart';
import '../../../core/theme_helper/app_styles.dart';
import '../../../data/models/notification_model.dart';
import '../../../global_widgets/shared/ui_helpers.dart';
import '../../../global_widgets/ui.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({Key? key,required this.notificationModel}) : super(key: key);
  final NotificationModel notificationModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                Column(
                  children: [Ui.circularImg(url: notificationModel.imageUrl, margin: 0,errorImg: AppImages.logoOnly), Spacer()],
                ),
                UiHelper.horizontalSpaceMedium,
                Expanded(
                  child: Column(
                    children: [
                      Text.rich(
                        TextSpan(
                            text:UiHelper.isArabic ? notificationModel.nameAr :  notificationModel.nameEn,
                            style: AppStyles.primaryStyle(bold: true, fontSize: 14),
                            children: [
                              TextSpan(text: '\t'),
                              TextSpan(
                                  text:UiHelper.isArabic?notificationModel.bodyAr: notificationModel.bodyEn,
                                  style: AppStyles.subTitleStyle())
                            ]),
                      ),
                      UiHelper.verticalSpaceSmall,
                      Row(
                        children: [
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Text(
                              intl. DateFormat('yyyy MMM dd hh:mm a').format(DateTime.tryParse(notificationModel.date) ?? DateTime.now()) ,
                              style: AppStyles.subTitleStyle(bold: true),

                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          UiHelper.verticalSpaceSmall,
          Divider(
            color: notificationModel.readed
                ? AppColors.subTitleColor
                : AppColors.primaryColorGreen,
            thickness: 2,
          )
        ],
      ),
    );
  }
}
