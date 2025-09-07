import 'model_helper.dart';

class MyFile {
  MyFile(
      {this.id,
      this.name = '',
      this.date = '',
      this.link = '',
      this.state = '',
      this.isExist = false});

  int? id;
  String name = '', date = '', link = '', state = '';
  bool isExist = false;

  factory MyFile.fromJson(Map<String, dynamic> json) => MyFile(
        id: json["id"] as int,
        name: ModelHelper.checkString(json["name"]),
        date: ModelHelper.checkString(json["date"]),
        link: ModelHelper.checkString(json["link"]),
        state: ModelHelper.checkString(json["state"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "date": date,
        "url": link,
      };
}
class MyFileGroup{

  MyFileGroup({required this.dateTime,this.files=const[]});
  DateTime dateTime;
  List<MyFile> files=[];



}