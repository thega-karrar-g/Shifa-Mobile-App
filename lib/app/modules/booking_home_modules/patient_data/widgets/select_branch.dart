import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/language_and_localization/app_strings.dart';
import '../../../../core/theme_helper/app_colors.dart';
import '../../../../core/theme_helper/app_styles.dart';
import '../../../../global_widgets/shared/ui_helpers.dart';
import '../../../../global_widgets/ui.dart';
import '../patient_data_logic.dart';

class SelectBranch extends StatelessWidget {
  const SelectBranch({Key? key,required this.logic}) : super(key: key);



  final PatientDataLogic logic;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

      Row(
        children: [
          Ui.titleGreenUnderLine(
              AppStrings.selectBranch.tr,
              bottomPadding: 8),
        ],
      ),

      // UiHelper.verticalSpaceSmall,


      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:logic.branchList.map((e) => GestureDetector(

            onTap: (){


              logic.updateBranch(e);
            },
            child: Container(

              padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
              margin: EdgeInsets.symmetric(horizontal: 5.w,vertical: 5.h),

              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: logic.selectedBranch==e? AppColors.primaryColor:AppColors.white,
                  border: Border.all(color: AppColors.primaryColor)




              ),

              child: Text( Get.locale.toString().contains('ar')? e.nameAr :e.nameEn,style: AppStyles.primaryStyle(bold: logic.selectedBranch==e,fontSize: 15,color: logic.selectedBranch==e? AppColors.white:AppColors.primaryColor,),),

            ))).toList()),
      ),


        UiHelper.verticalSpaceMedium,


    ],);
  }
}
