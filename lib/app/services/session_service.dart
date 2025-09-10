import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../data/models/user_model.dart';
import '../routes/app_route_names.dart';

class SessionService extends GetxService {
  final String currentUserKey = 'currentUser';
  final String currentUserGuestKey = 'currentUserGuest';

  AppUser? _currentUser;

  late GetStorage userBox = GetStorage();

  AppUser? get currentUser => _currentUser;

  setupDb() async {
    fetchCurrentUserGuest();
    fetchCurrentUser();
  }

  Future fetchCurrentUser() async{
    if (!userBox.hasData(currentUserKey)) {
      if (!userBox.hasData(currentUserGuestKey)) {
        return;
      } else {
        fetchCurrentUserGuest();
      }
      return;
    }

    Map<String, dynamic>? user;
    user = Map<String, dynamic>.from(jsonDecode(userBox.read(currentUserKey)));

    _currentUser = AppUser.fromMap(user);

return;
  }

  void fetchCurrentUserGuest() {
    if (!userBox.hasData(currentUserGuestKey)) {
      return;
    }

    Map<String, dynamic>? user;
    user = Map<String, dynamic>.from(
        jsonDecode(userBox.read(currentUserGuestKey)));

    print('user:***************************************************  $user');
    _currentUser = AppUser.fromMapGuest(user);
  }

  saveUserInfoToHive(AppUser user) async {
    signOutGuest();

    _currentUser = user;
    // fetchCurrentUser();
    try {
      await userBox.write(currentUserKey, jsonEncode(user.toMap()));
     await fetchCurrentUser();
      return true;
    } catch (e) {
      return e.toString();
    }
  }

  saveUserGuestInfoToHive(AppUser user) async {
    try {
      await userBox.write(currentUserGuestKey, jsonEncode(user.toMapGuest()));
      fetchCurrentUserGuest();
      return true;
    } catch (e) {
      return e.toString();
    }
  }

  bool checkUserSignIn() {
    if (currentUser != null) {
      if (currentUser!.userType == '1') {
        return true;
      }
      return false;
    } else {
      return false;
    }
  }

  bool checkGuestSignIn() {
    if (currentUser != null) {
      if (currentUser!.userType == '2') {
        return true;
      }
      return false;
    } else {
      return false;
    }
  }

  Future signOut() async {
    _currentUser = null;
    if (userBox.hasData(currentUserKey)) {
      await userBox.remove(currentUserKey);
      Get.offAllNamed(AppRouteNames.login);
    }
  }

  Future signOutGuest() async {
    _currentUser = null;
    if (userBox.hasData(currentUserGuestKey)) {
      await userBox.remove(currentUserGuestKey);
      // Get.offAllNamed(AppRouteNames.home);

    }
  }
}
