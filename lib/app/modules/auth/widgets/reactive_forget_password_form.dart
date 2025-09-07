import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../core/language_and_localization/app_strings.dart';
import '../../../global_widgets/form_widgets/reactive_text_form.dart';
import '../../../global_widgets/shared/ui_helpers.dart';
import '../../../global_widgets/ui.dart';
import '../../../data/api/api_keys.dart';
import '../auth_controller.dart';

class ReactiveForgetPasswordForm extends StatelessWidget {
  ReactiveForgetPasswordForm({Key? key, required this.title}) : super(key: key);

  final String title;

  final requiredFields = ' '
      '${AppStrings.idNo.tr} *\n'
      '${AppStrings.phoneNum.tr} *\n'
      ''
      '';

  FormGroup buildForm() => fb.group(<String, Object>{
        ApiKeys.idNumberKey: FormControl<String>(
          validators: [
            Validators.required,
          ],
        ),
        ApiKeys.formMobile: [
          '',
          Validators.required,
        ],
      });

  @override
  Widget build(BuildContext context) {
    var hint = Get.locale.toString() == 'ar' ? ' ********5 ' : '  5********  ';

    return GetBuilder<AuthController>(builder: (logic) {
      return ReactiveFormBuilder(
        form: buildForm,
        builder: (context, form, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Ui.titleGreenUnderLine(AppStrings.recoveryPassword,
                        fontSize: 33, fontHeight: 1.5)
                  ],
                ),

                //   UiHelper.verticalSpace(Get.height*.05),

                UiHelper.verticalSpaceMedium,
                ReactiveTextForm.reactiveRegisterTextField(
                    formControlName: ApiKeys.idNumberKey,
                    label: AppStrings.idNo,
                    isSSN: true,
                    length: 10),

                SizedBox(height: 15.h),

                ReactiveTextForm.reactiveRegisterTextField(
                    formControlName: ApiKeys.formMobile,
                    label: AppStrings.phoneNum,
                    isPhone: true,
                    hint: hint,
                    length: 9),

                UiHelper.verticalSpaceLarge,

                Row(
                  children: [
                    Expanded(
                      child: Ui.primaryButton(
                          title:
                              AppStrings.verify.tr.capitalizeFirst.toString(),
                          onTab: () {
                            if (form.valid) {
                              logic.forgetPassword(form.value);
                            } else {
                              // print(form.errors.toString());
                              //  form.markAllAsTouched();
                              logic.buildFailedSnackBar(
                                  msg: '${AppStrings.fillAllRequiredFields.tr}\n\n$requiredFields');
                            }
                          }),
                    ),
                    UiHelper.horizontalSpaceMedium,
                    Expanded(
                      child: Ui.primaryButton(
                          title: AppStrings.back,
                          onTab: () {
                            Get.back();
                          }),
                    )
                  ],
                ),

                SizedBox(
                  height: 10,
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
