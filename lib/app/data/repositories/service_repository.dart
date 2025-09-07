import 'dart:convert';

import '../api/services_api.dart';
import '../models/nurse_service.dart';
import '../models/pcr_model.dart';

class ServiceRepository {
  static final _serviceRepository = ServiceRepository._internal();

  factory ServiceRepository() {
    return _serviceRepository;
  }

  ServiceRepository._internal();

  final ServiceApi _serviceApi = ServiceApi();

  Future<List<NurseService>> getServicesList() async {

    try {
      var response = await _serviceApi.getServices();

      var jsonData = json.decode(response!.body.toString());

      var d = jsonData['data'] as List;

      var dd = d.map((dr) {
        return NurseService.fromJson((dr));
      }).toList();

      // return dd.where((element) => element.code=='N'||element.code=='V'||element.code=='GCP'||element.code=='MH'||element.code=='IVT'||element.code=='WBSDFC'||element.code=='SM').toList();
      return dd;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<PcrModel>> getPCRServicesList() async {

    try {
      var response = await _serviceApi.getServices();

      var jsonData = json.decode(response!.body.toString());

      var d = jsonData['data'] as List;

      var dd = d.map((dr) {
        return PcrModel.fromJson((dr));
      }).toList();

      return dd.where((element) => element.code != 'false').toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
