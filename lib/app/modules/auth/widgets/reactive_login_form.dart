import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../core/language_and_localization/app_strings.dart';
import '../../../core/theme_helper/app_styles.dart';
import '../../../data/constants/booking_constants.dart';
import '../../../global_widgets/form_widgets/reactive_text_form.dart';
import '../../../global_widgets/shared/ui_helpers.dart';
import '../../../global_widgets/ui.dart';
import '../../../routes/app_route_names.dart';
import '../../../data/api/api_keys.dart';
import '../auth_controller.dart';

class ReactiveLoginForm extends StatelessWidget {
  ReactiveLoginForm({Key? key, required this.title}) : super(key: key);

  final String title;

  final requiredFields = ' '
      '${AppStrings.idNo.tr} *\n'
      '${AppStrings.password.tr} *\n'
      ''
      '';

  FormGroup buildForm() => fb.group(<String, Object>{
        ApiKeys.smsUserName.toLowerCase(): FormControl<String>(
          validators: [
            Validators.required,
          ],
        ),
        ApiKeys.formPassword: [
          '',
          Validators.required,
          Validators.minLength(4)
        ],
        'rememberMe': false,
      });

  @override
  Widget build(BuildContext context) {
    var questionMark = Get.locale.toString() == 'ar' ? ' ؟ ' : ' ? ';

    return GetBuilder<AuthController>(builder: (logic) {
      return ReactiveFormBuilder(
        form: buildForm,
        builder: (context, form, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (BookingConstants.fromPatientData != true)
                  UiHelper.verticalSpace(Get.height * .05),

                Row(
                  children: [
                    Ui.titleGreenUnderLine(title, fontSize: 33, fontHeight: 1.5)
                  ],
                ),

                Row(
                  children: [
                    Text(
                      AppStrings.loginMsg.tr,
                      style: AppStyles.subTitleStyle(),
                    ),
                  ],
                ),
                //   UiHelper.verticalSpace(Get.height*.05),

                UiHelper.verticalSpaceMedium,
                ReactiveTextForm.reactiveRegisterTextField(
                    formControlName: ApiKeys.smsUserName.toLowerCase(),
                    label: AppStrings.idNo,
                    isSSN: true,
                    length: 10,
                    onTab: () {
                      var remember = logic.rememberBox.read(ApiKeys.remember);
                      if (remember == true) {
                        form.control(ApiKeys.smsUserName.toLowerCase()).value =
                            logic.rememberBox
                                .read(ApiKeys.smsUserName.toLowerCase())
                                .toString();
                        form.control(ApiKeys.formPassword.toLowerCase()).value =
                            logic.rememberBox
                                .read(ApiKeys.formPassword.toLowerCase())
                                .toString();

                        form.markAsTouched();
                      }
                    }),

                SizedBox(height: 15.h),
                ReactiveTextForm.reactiveRegisterPasswordTextField(
                  formControlName: ApiKeys.formPassword,
                  logic: logic,
                  label: AppStrings.password,
                ),
                UiHelper.verticalSpaceMedium,
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRouteNames.forgetPassword);
                  },
                  child: Row(
                    children: [
                      Spacer(),
                      Text(
                        AppStrings.forgetPassword.tr + questionMark,
                        style: AppStyles.primaryStyle(bold: true),
                      ),
                      UiHelper.horizontalSpaceSmall,
                    ],
                  ),
                ),

                Ui.primaryButton(
                    title: AppStrings.logIn.tr.capitalizeFirst.toString(),
                    onTab: () {
                      if (form.valid) {
                        logic.login2(form.value);
                      } else {
                        // print(form.errors.toString());
                        //  form.markAllAsTouched();
                        logic.buildFailedSnackBar(
                            msg: '${AppStrings.fillAllRequiredFields.tr}\n\n$requiredFields\n${AppStrings.passwordLengthHint.tr}');
                      }
                    }),

                SizedBox(
                  height: 10.h,
                ),

                //   SizedBox(height: 60),
              ],
            ),
          );
        },
      );
    });
  }
}
