import '../../core/language_and_localization/app_strings.dart';
import '../../core/assets_helper/app_images.dart';

class Slide {
  String? id;
  String? title, description, image, code;
  String? button;
  String? textPosition;
  String? textColor;
  late String buttonTextColor;
  String? buttonColor;
  String? backgroundColor;
  late String indicatorColor;
  String? imageFit;
  String? url;
  bool? enabled = false;

  Slide(
      {this.id = '',
      this.title = '',
      this.description = '',
      this.image = '',
      this.code = ''});

  Slide.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      title = jsonMap['text'] != null ? jsonMap['text'].toString() : '';
      button = jsonMap['button'] != null ? jsonMap['button'].toString() : '';
      textPosition = jsonMap['text_position'] != null
          ? jsonMap['text_position'].toString()
          : '';
      textColor =
          jsonMap['text_color'] != null ? jsonMap['text_color'].toString() : '';
      buttonTextColor = jsonMap['button_text_color'] != null
          ? jsonMap['button_text_color'].toString()
          : '';
      buttonColor = jsonMap['button_color'] != null
          ? jsonMap['button_color'].toString()
          : '';
      backgroundColor = jsonMap['background_color'] != null
          ? jsonMap['background_color'].toString()
          : '';
      indicatorColor = jsonMap['indicator_color'] != null
          ? jsonMap['indicator_color'].toString()
          : '';
      imageFit = jsonMap['image_fit'] != null
          ? jsonMap['image_fit'].toString()
          : 'cover';
      url = jsonMap['url'] != null ? jsonMap['url'].toString() : '';
      enabled = jsonMap['enabled'] as bool;
    } catch (e) {
      id = '';
      title = '';
      button = '';
      textPosition = '';
      textColor = '';
      buttonTextColor = '';
      buttonColor = '';
      backgroundColor = '';
      indicatorColor = '';
      imageFit = '';
      url = '';
      enabled = false;
    }
  }

  Map toMap() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["text"] = title;
    map["button"] = button;
    map["text_position"] = textPosition;
    map["text_color"] = textColor;
    map["button_color"] = buttonColor;
    return map;
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  static List<Slide> slides = [
    Slide(
        title: AppStrings.telemedicine,
        description: AppStrings.telemedicineDescription,
        image: AppImages.iconTeleMed,
        code: 'TD'),
    Slide(
        title: AppStrings.homeVisitDoctor,
        description: AppStrings.hvdDescription,
        image: AppImages.iconHVD,
        code: 'HVD'),
    Slide(
        title: AppStrings.geriatricCare,
        description: AppStrings.geriatricDescription,
        image: AppImages.iconGer,
        code: 'GCP'),
    Slide(
        title: AppStrings.covidPCR,
        description: AppStrings.pcrDescription,
        image: AppImages.iconPcr,
        code: 'PCR'),
    Slide(
        title: AppStrings.homeRadiology,
        description: AppStrings.radiologyDescription,
        image: AppImages.iconXRay,
        code: 'R'),
    Slide(
        title: AppStrings.sleepMedicine,
        description: AppStrings.sleepDescription,
        image: AppImages.iconSleep,
        code: 'SM'),
    Slide(
        title: AppStrings.manHealth,
        description: AppStrings.manHealthDescription,
        image: AppImages.iconMan,
        code: 'MH'),
    Slide(
        title: AppStrings.nurse,
        description: AppStrings.nurseDescription,
        image: AppImages.iconNurse,
        code: 'N'),
    Slide(
        title: AppStrings.homeLaboratory,
        description: AppStrings.homeLaboratoryDescription,
        image: AppImages.iconLab,
        code: 'L'),
    Slide(
        title: AppStrings.physiotherapist,
        description: AppStrings.physiotherapyDescription,
        image: AppImages.iconPhys,
        code: 'PHY'),
    Slide(
        title: AppStrings.ivAntibioticVitamin,
        description: AppStrings.ivTherapyDescription,
        image: AppImages.iconIV,
        code: 'IVT'),
    Slide(
        title: AppStrings.caregiver,
        description: AppStrings.caregiverDescription,
        image: AppImages.iconCaregiver,
        code: 'Car'),
    Slide(
        title: AppStrings.diabeticCare,
        description: AppStrings.diabeticCareDescription,
        image: AppImages.iconDiabetic,
        code: 'Diab'),
    Slide(
        title: AppStrings.vaccination,
        description: AppStrings.vaccinationDescription,
        image: AppImages.iconVac,
        code: 'V'),
    Slide(
        title: AppStrings.woundCare,
        description: AppStrings.woundCareDescription,
        image: AppImages.iconWound,
        code: 'WBSDFC'),
  ];
}
