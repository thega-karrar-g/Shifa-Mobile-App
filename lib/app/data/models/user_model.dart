import 'model_helper.dart';

class AppUser {
  late String id, name, email, phone, token, userType, ssn, location;
  List? fcmToken;
  String? imageUrl;
  String? gender,
      age,
      dob = '',
      maritalStatus,
      bloodType,
      rh,
      identificationCode,
      nationality;

  AppUser(
      {required this.id,
      this.name = '',
      this.email = '',
      this.phone = '',
      this.token = '',
      this.userType = '',
      this.ssn = '',
      this.location = '',
      this.fcmToken,
      this.imageUrl,
      this.rh,
      this.bloodType,
      this.maritalStatus,
      this.gender = '',
      this.dob = '',
      this.age = '',
      this.identificationCode,
      this.nationality = ''});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobile': phone,
      'token': token,
      'identification_code': identificationCode,
      'age': age,
      'ssn': ssn,
      'location': location,
      'dob': dob,
      'gender': gender,
      'marital_status': maritalStatus,
      'ksa_nationality': nationality,
      'blood_type': bloodType,
      'rh': rh,
      'user_type': userType,
      'fcmToken': fcmToken,
      'image_url': imageUrl,
    };
  }

  Map<String, dynamic> toMapGuest() {
    return {
      'id': id,
      'name': name,
      'mobile': phone,
      'ksa_nationality': nationality,
      'type': userType,
      'dob': dob,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] != null
          ? map['id'].toString()
          : map['uid'] != null
              ? map['uid'].toString()
              : '',
      token: ModelHelper.checkString(map['token']),
      userType: ModelHelper.checkString(map['user_type']),
      name: ModelHelper.checkString(map['name']),
      dob: ModelHelper.checkString(map['dob']),
      age: ModelHelper.checkString(map['age']),
      gender: map['gender'] != null
          ? ModelHelper.checkString(map['gender'])
          : map['sex'] != null
              ? ModelHelper.checkString(map['sex'])
              : '',
      ssn: ModelHelper.checkString(map['ssn']),
      location: ModelHelper.checkString(map['street']),
      maritalStatus: ModelHelper.checkString(map['marital_status']),
      bloodType: ModelHelper.checkString(map['blood_type']),
      rh: ModelHelper.checkString(map['rh']),
       identificationCode: map['identification_code'] ??'',
      email: ModelHelper.checkString(map['email']),
      phone: ModelHelper.checkString(map['mobile']),
      imageUrl: map['image_url'] ?? '',
      nationality: ModelHelper.checkString(map['ksa_nationality']),
    );
  }

  factory AppUser.fromMapGuest(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] != null
          ? map['id'].toString()
          : map['uid'] != null
              ? map['uid'].toString()
              : '',
      name: ModelHelper.checkString(map['name']),
      userType: ModelHelper.checkString(map['type']),
      phone: ModelHelper.checkString(map['mobile']),
      nationality: ModelHelper.checkString(map['ksa_nationality']),
      dob: ModelHelper.checkString(map['dob']),
    );
  }
}

class LoginModel {
  int uid = 0, userType = 0;
  String token = '';

  LoginModel({this.uid = 0, this.userType = 0, this.token = ''});

  factory LoginModel.fromMap(map) {
    return LoginModel(
      uid: map['uid'],
      userType: map['user_type'],
      token: map['token'],
    );
  }
}
