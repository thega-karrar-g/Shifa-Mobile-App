import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QrScannerLogic extends GetxController {
  static TextEditingController qrCtrl = TextEditingController();

  onDetect(barcode, args) {
    if (barcode.rawValue == null) {
      debugPrint('Failed to scan Barcode');
    } else {
      final String code = barcode.rawValue!;
      qrCtrl.text = code;

      debugPrint('Barcode found! $code');
      update();
      Future.delayed(
          Duration(
            milliseconds: 500,
          ), () {
        Navigator.pop(Get.context!);
      });
    }
  }
}
