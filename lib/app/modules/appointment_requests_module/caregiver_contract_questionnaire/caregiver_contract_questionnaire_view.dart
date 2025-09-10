import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/language_and_localization/app_strings.dart';
import '../../../global_widgets/shared/my_appbar.dart';
import '../../../global_widgets/shared/ui_helpers.dart';
import '../../../global_widgets/ui.dart';
import 'caregiver_contract_questionnaire_logic.dart';
import 'widgets/questionnaire_form.dart';

class CaregiverContractQuestionnairePage extends StatelessWidget {
  final CaregiverContractQuestionnaireLogic logic = Get.put(CaregiverContractQuestionnaireLogic());


  static const routeName="/CaregiverContractQuestionnairePage";

  CaregiverContractQuestionnairePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Ui.myScaffold(
        child: Column(
      children: [
        myAppBar2(title: AppStrings.caregiverContractQuestionnaire),
        UiHelper.verticalSpaceMedium,
        Expanded(
          child: SingleChildScrollView(
            child: GetBuilder<CaregiverContractQuestionnaireLogic>(builder: (logic) {
              return QuestionnaireForm();
            }),
          ),
        ),
      ],
    ));
  }
}
