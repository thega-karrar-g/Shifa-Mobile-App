import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../base_controller/base_controller.dart';
import '../../core/language_and_localization/app_strings.dart';
import '../../data/models/home_service.dart';
import '../../data/models/m_file.dart';
import '../../data/repositories/files_repository.dart';
import '../../data/api/app_urls.dart';
import '../../utils/ext_storage.dart';

class FilesLogic extends BaseController {
  var dir = '';
  final FilesRepository _filesRepository = FilesRepository();

  var title = (Get.arguments as HomeService).name;
  var code = (Get.arguments as HomeService).code;
  var user = (Get.arguments as HomeService).user!;

  bool labImageStatus = true;

  bool isLabOrImage = false;

  updateLabImageStatus(bool status) {


    if(code=='X'||code=='L') {


      /// true => tests
      /// false => requests
      labImageStatus = status;
      currentFiles.clear();
      if (!status) {
        if (code == 'X') {
          ///  image requests
          currentFiles.addAll(
              files.where((element) => element.name.startsWith('IM')));
          print(currentFiles.length);
        }
        else {
          ///  image tests

          currentFiles.addAll(
              files.where((element) => element.name.startsWith('LT')));
        }
      }
      else {
        if (code == 'L') {

          ///  Lab tests

          currentFiles.addAll(
              files.where((element) => element.name.startsWith('LR')));
        }
        else {
          ///  Lab requests

          currentFiles.addAll(
              files.where((element) => element.name.startsWith('IR')));
        }
      }
    }

    currentFiles=currentFiles.toSet().toList();

    filesGroup=  groupFilesByData(currentFiles);
    update();
  }

  GlobalKey key = GlobalKey();

  List<MyFile> files = [],currentFiles=[];
  List<MyFileGroup> filesGroup=[];

  var granted = false;
  var url = AppUrls.prescriptionUrls;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    switch(code){

      case 'R':{
        url = AppUrls.reportUrls;

      }break;

      case 'X':{
        url = AppUrls.imageTestsUrls;

      }break;
      case 'L':{
        url = AppUrls.labTestsUrls;

      }break;
      case 'P':{
        url = AppUrls.prescriptionUrls;

      }break;
      case 'IC':{
        url = AppUrls.prescriptionUrls;

      }break;
      default: {
        url = AppUrls.prescriptionUrls;

      }
    }

    if (code == 'R') {
      url = AppUrls.reportUrls;
    }
    isLabOrImage = code == 'X' || code == 'L';

    if (await ExtStorage.getStoragePermission()==true) {
      setGranted(true);

      dir = (await ExtStorage.getDir()).path;

      // Either the permission was already granted before or the user just granted it.

    } else {
      setGranted(false);
    }

      getFiles(code: code);

  }

  setGranted(bool status) {
    granted = status;
    update();
  }

  getFiles({String code = 'R'}) async {
    setBusy(true);
    currentFiles.clear();
    files = await _filesRepository.getFileList(id: user.id, url: url);
    if (code == 'P' || code == 'IC') {
      var instantConFiles = await _filesRepository.getFileList(
          id: user.id, url: AppUrls.getInstantConsultation);

      files = [
        ...instantConFiles.where((element) => element.state == 'completed'),
        ...files
      ];

      currentFiles.addAll(files);
    }
    if (code == 'X' ) {
      var requests = await _filesRepository.getFileList(
          id: user.id, url: AppUrls.imageRequestUrls);

      files.addAll(requests);

    }
    if (code == 'L' ) {
      var requests = await _filesRepository.getFileList(
          id: user.id, url: AppUrls.labRequestsUrls);

      files.addAll(requests);

    }

    //print(object)

    files=files.toSet().toList();

    currentFiles.addAll(files);
   filesGroup= groupFilesByData(files);


   filesGroup.forEach((element) {


     print("files length ${element.files.length }");

   });


    updateLabImageStatus(true);


    setBusy(false);
  }





  List< MyFileGroup> groupFilesByData(List<MyFile> files) {
    final groups = groupBy(files, (MyFile e) {
      var d=DateTime.parse(e.date);
      return DateTime(d.year,d.month,d.day);
    });
    filesGroup.clear();
    groups.forEach((key, value) {

      filesGroup.add(MyFileGroup(dateTime: key,files: value));

    });
     filesGroup.sort((a, b) =>  a.dateTime .compareTo(b.dateTime));
    return  filesGroup.reversed.toList();
  }

  String dateConverter(DateTime myDate) {
    String date='Today';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    final dateToCheck = myDate;
    final checkDate = DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);
    if (checkDate == today) {
      date = AppStrings.today;
    } else if (checkDate == yesterday) {
      date = AppStrings.yesterday;
    }
    else {
      date = DateFormat("d MMM yyyy",Get.locale.toString()).format(myDate);
    }
    return date;
  }



}
