import 'dart:convert';

import 'package:arsys/faculty/models/faculty.dart';
import 'package:arsys/network/network.dart';
import 'package:arsys/network/profile_provider.dart';
import 'package:arsys/student/models/student.dart';
import 'package:arsys/views/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FacultyController extends GetxController {
  Faculty faculty = Faculty();
  // int? id;
  // String? firstName;
  // String? lastName;
  // String role = "student";
  // String? studentNumber;
  // int? specializationId;
  // String? specialization;
  // String? gpa;
  // String? status;
  // String? phone;
  // String? email;
  // Faculty? supervisor;

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
    if (faculty.id == null) {
      var response;
      response = await Network().getProfile();
      // print(response.bodyString);

      var body;

      try {
        body = await json.decode(response.bodyString);
        // print(body);
      } catch (e) {
        print(e);
        return faculty;
      }

      try {
        if (response.statusCode == HttpStatus.ok) {
          faculty = Faculty.fromJson(response.body);
          print(faculty);
        }
        return (faculty);
      } catch (e) {
        print(e);
      }
    }
    return (faculty);
  }

  String getFullName() {
    return faculty.getFullNameAndTitle();
  }

  String getRole() {
    return faculty.role;
  }

  void profileClear() {
    faculty.id = null;
  }
}
