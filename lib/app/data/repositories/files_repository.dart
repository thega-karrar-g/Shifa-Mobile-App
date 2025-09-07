import '../api/api_keys.dart';
import '../api/app_urls.dart';
import '../api/files_api.dart';
import '../models/m_file.dart';

class FilesRepository {
  static final _prescriptionRepository = FilesRepository._internal();

  factory FilesRepository() {
    return _prescriptionRepository;
  }

  FilesRepository._internal();

  final FilesApi _prescriptionApi = FilesApi();

  Future<List<MyFile>> getFileList(
      {String id = '', String url = AppUrls.prescriptionUrls}) async {
    try {
      var response = await _prescriptionApi.getFiles(id: id, url: url);

      var jsonData = response!.data;

      if (jsonData[ApiKeys.responseSuccess] == 1) {
        var d = jsonData['data'] as List;
        var dd = d.map((dr) {
          return MyFile.fromJson((dr));
        }).toList();

        return dd;
      } else {
        return [];
      }
    } catch (_) {
      return [];
    }
  }

  var d = [
    {
      "id": 3,
      "name": "PR0003",
      "patient": "[HP0002] Ahmed Ali ",
      "doctor": "فياض القصير جدا",
      "date": "2021-10-11 05:34:59",
      "info": "",
      "prescription_line": [
        {
          "name": "acetazolamide",
          "indication": "Cholera",
          "dose": "1",
          "start_treatment": "2021-10-02 10:58:15",
          "end_treatment": ""
        }
      ]
    },
    {
      "id": 2,
      "name": "PR0002",
      "patient": "[HP0002] Ahmed Ali ",
      "doctor": "عمر الطويل",
      "date": "2021-10-11 05:34:59",
      "info": "",
      "prescription_line": []
    },
    {
      "id": 1,
      "name": "PR0001",
      "patient": "[HP0002] Ahmed Ali ",
      "doctor": "فياض القصير جدا",
      "date": "2021-10-11 05:34:59",
      "info": "",
      "prescription_line": []
    }
  ];
}
