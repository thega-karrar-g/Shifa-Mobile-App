import 'package:globcare/app/data/models/model_helper.dart';

class NotificationModel {
  NotificationModel(
      {this.id = 0,
      this.nameEn = '',this.nameAr='',this.bodyAr='',this.imageUrl='',this.type='',
      this.bodyEn = '',
      this.date = '',
      this.readed = false});

  int id;
  String nameEn, nameAr, bodyEn,bodyAr , date,imageUrl,type ;
  bool readed = false;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json['id'] ?? 0,
        nameEn: ModelHelper.checkString(json['name_en']),
        nameAr: ModelHelper.checkString(json['name_ar']),
        bodyAr: ModelHelper.checkString(json['content_ar']),
        bodyEn: ModelHelper.checkString(json['content_en']),
        imageUrl: ModelHelper.checkString(json['image_url']),
        type: ModelHelper.checkString(json['type']),
        date: ModelHelper.checkString(json['date']),


      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": nameEn,
        "description": bodyEn,
        "date": date,
      };

  static List<NotificationModel> notifications = [
    NotificationModel(
        id: 1,
        nameEn: 'Kristine Jones',
        bodyEn:
            'It is a long established fact that a reader will be distracted by the readable content of a page.',
        date: '2 hours ago'),
    NotificationModel(
        id: 1,
        nameEn: 'Kay Hicks',
        bodyEn:
            'There are many variations of passages of Lorem Ipsum available.',
        date: '6 hours ago'),
    NotificationModel(
        id: 1,
        nameEn: 'Cheryl Moretti',
        bodyEn:
            'It is a long established fact that a reader will be distracted by the readable content of a page.',
        date: '1 day ago',
        readed: true),
    NotificationModel(
      id: 1,
      nameEn: 'Kristine Jones',
      bodyEn:
          'It is a long established fact that a reader will be distracted by the readable content of a page.',
      date: '3 days ago',
    ),
    NotificationModel(
        id: 1,
        nameEn: 'Cheryl Moretti',
        bodyEn:
            'It is a long established fact that a reader will be distracted by the readable content of a page.',
        date: '1 day ago'),
  ];
}
