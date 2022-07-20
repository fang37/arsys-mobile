import 'dart:convert';

import 'package:arsys/faculty/models/faculty.dart';
import 'package:arsys/models/role.dart';
import 'package:arsys/models/user.dart';
import 'package:arsys/network/network.dart';
import 'package:arsys/network/profile_provider.dart';
import 'package:arsys/student/models/student.dart';
import 'package:arsys/views/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  var user;

  final _roleList = {
    1: 'Admin',
    2: 'Student',
    3: 'Faculty',
    4: 'Specialization',
    5: 'Head of Program Study',
    6: 'Coordinator',
    7: 'Tenaga Kependidikan'
  };

  final _specializationName = {
    1: 'Elektronika Industri',
    2: 'Tenaga Elektrik',
    3: 'Telekomunikasi'
  };

  Future getProfile() async {
    if (user == null || user.id == -1) {
      var response;
      response = await Network().getProfile();
      // print(response.bodyString);

      var body;

      try {
        body = await json.decode(response.bodyString);
        // print(body);
      } catch (e) {
        print(e);
        return user;
      }

      try {
        if (response.statusCode == HttpStatus.ok) {
          if (response.body['role'] == Role.admin.value ||
              response.body['role'] == Role.faculty.value) {
            user = Faculty.fromJson(response.body);
          } else {
            user = Student.fromJson(response.body);
          }
          print(user);
        }
        return (user);
      } catch (e) {
        print(e);
      }
    }
    return (user);
  }

  int getId() {
    return user.id;
  }

  void profileClear() {
    user.id = -1;
  }
}
