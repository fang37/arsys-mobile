import 'dart:convert';

import 'package:arsys/models/event.dart';
import 'package:arsys/models/user.dart';
import 'package:arsys/network/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  var user = User();

  loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userData = jsonDecode(localStorage.getString('user')) ?? "";
    var roles = localStorage.getString('roles') ?? "";
    print(roles);

    if (userData != null) {
      user.name = userData['name'].toString();
      user.role = roles;
      print(user.name);
      print(user.role);
    }
  }
}
