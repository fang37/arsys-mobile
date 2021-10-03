import 'dart:convert';

import 'package:arsys/network/api.dart';
import 'package:arsys/views/faculty/home.dart';
import 'package:arsys/views/student/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final box = GetStorage();
  var isAuth = false.obs;
  var isLoading = false.obs;
  var homePage;

  @override
  void onInit() async {
    // TODO: implement onInit
    // print(box.read('isAuth'));
    await GetStorage.init();
    if (box.read('roles') == 'student') {
      homePage = StudentHome();
    } else if (box.read('roles') == 'faculty') {
      homePage = FacultyHome();
    }

    if (box.read('isAuth') != null) {
      isAuth.value = box.read('isAuth');
    }

    super.onInit();
  }
  // MASUKAN ISAUTH KE SHARED PREFERENCES

  void login(String email, String password) async {
    isLoading.value = true;
    // Get.defaultDialog(title: "");
    var data = {'email': email, 'password': password};

    var res = await Network().authData(data, '/login');
    var body = json.decode(res.body);

    if (body['success']) {
      box.write('isAuth', true);
      isAuth.value = true;
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', json.encode(body['token']));
      localStorage.setString('user', json.encode(body['user']));
      localStorage.setString('roles', json.decode(json.encode(body['roles'])));

      if (body['roles'] == 'student') {
        homePage = StudentHome();
        box.write('roles', 'student');
      } else if (body['roles'] == 'faculty') {
        homePage = FacultyHome();
        box.write('roles', 'faculty');
      }
    } else if (body['success'] == false) {
      // _showMsg(body['message']);
      Get.snackbar("Login Failed", body['message'],
          backgroundColor: Colors.white, icon: Icon(Icons.warning_rounded));
    } else {
      Get.snackbar("Login Failed", body["server not responding"],
          backgroundColor: Colors.white, icon: Icon(Icons.warning_rounded));
    }
    isLoading.value = false;
  }

  void logout() async {
    var res = await Network().getData('/logout');
    var body;
    try {
      body = json.decode(res.body);
      print(body);
      if (body['success']) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        box.write('isAuth', false);
        isAuth.value = false;
        // localStorage.remove('user');
        // localStorage.remove('token');
        // localStorage.remove('roles');
        localStorage.clear();
        Get.offAllNamed('/login');
      }
    } catch (e) {
      print(e);
    }
  }

  // void checkIfLoggedIn() async {
  //   SharedPreferences localStorage = await SharedPreferences.getInstance();
  //   var token = localStorage.getString('token');
  //   if (token != null) {
  //     // AuthController.isAuth.value = true;
  //     box.write('isAuth', true);
  //     isAuth.value = true;
  //   } else {
  //     box.write('isAuth', false);
  //     isAuth.value = false;
  //   }
  //   print('check if logged in');
  // }
}
