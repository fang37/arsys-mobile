import 'dart:convert';

import 'package:arsys/models/event.dart';
import 'package:arsys/models/profile.dart';
import 'package:arsys/network/api.dart';
import 'package:arsys/network/profile_provider.dart';
import 'package:arsys/views/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  Profile profile = new Profile();
  int? id;
  String? name;
  int? role_id;
  String? role;
  var role_list = {
    1: 'Admin',
    2: 'Student',
    3: 'Faculty',
    4: 'Specialization',
    5: 'Head of Program Study',
    6: 'Coordinator',
    7: 'Tenaga Kependidikan'
  };
  String? student_number;
  int? specialization_id;
  String? specialization;
  var specialization_name = {
    1: 'Elektronika Industri',
    2: 'Tenaga Elektrik',
    3: 'Telekomunikasi'
  };
  String? first_name;
  String? last_name;
  var supervisor;
  String? gpa;
  String? status;
  String? phone;
  String? email;

  Future profileUser() async {
    if (profile.id == null) {
      var res;
      res = await Network().getProfile();
      print(res.bodyString);

      // print(res.body);
      var body;
      try {
        body = await json.decode(res.bodyString);
        // print(body);
      } catch (e) {
        // print(e);
        return profile;
      }

      try {
        if (body['success']) {
          id = body['id'] ?? 99;
          role_id = body['role'] ?? 99;
          role = role_list[body['role']] ?? "";
          student_number = body['student_number'] ?? "";
          specialization_id = body['specialization_id'] ?? 99;
          first_name = body['first_name'] ?? "";
          last_name = body['last_name'] ?? "";
          supervisor = body['supervisor'] ?? "";
          gpa = body['gpa'] ?? "";
          status = body['status'] ?? "";
          phone = body['phone'] ?? "";
          email = body['email'] ?? "";

          profile = Profile(
            id: id,
            role_id: role_id,
            role: role!,
            student_number: student_number,
            specialization_id: specialization_id,
            specialization: specialization_name[specialization_id] ?? "",
            first_name: first_name,
            last_name: last_name,
            name: first_name! + " " + last_name!,
            supervisor: supervisor,
            gpa: gpa,
            status: status,
            phone: phone,
            email: email,
          );
          print(profile);
        }
        return (profile);
      } catch (e) {
        print("catch error");
        // print(e);
      }
    }
    print('not empty');
    print(profile.role);
    return (profile);
  }

  void profileClear() {
    profile.id = null;
  }
}
