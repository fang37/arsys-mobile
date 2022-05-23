import 'dart:convert';

import 'package:arsys/controllers/fcm_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'cache_manager.dart';

class AuthenticationManager extends GetxController with CacheManager {
  final box = GetStorage();
  var isLogged = false.obs;
  var isLoading = false.obs;
  var activeRole = "";
  var homePage;
  final fcmC = Get.put(FCMController());

  void login(String? token, String? role) async {
    isLoading.value = true;
    isLogged.value = true;
    await saveToken(token);

    activeRole = role!;
    await saveRole(role);
    isLoading.value = false;
  }

  void logout() async {
    print('LOGOUT function executed');
    removeToken();
    removeRole();
    activeRole = "";
    isLogged.value = false;

    // await fcmC.removeToken();
  }

  void checkLoginStatus() {
    final token = getToken();
    if (token != null) {
      isLogged.value = true;
      activeRole = getRole()!;
    }
  }
}