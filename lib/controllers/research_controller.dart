import 'dart:convert';
import 'package:arsys/models/research.dart';
import 'package:arsys/network/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResearchController extends GetxController {
  var research = List<Research>.empty().obs;
  var research_name = {
    1: 'Skripsi',
    2: 'Tugas Akhir',
    3: 'Praktik Industri',
    4: 'Seminar Teknik Elektro',
    5: 'Tesis',
    6: 'Disertasi'
  };

  int id;
  int research_type;
  String research_code;
  String title;
  String abstract;
  String research_milestone;
  String status;
  String approval_date;
  String research_id;

  void snackBarError(String msg) {
    Get.snackbar(
      "ERROR",
      msg,
      duration: Duration(seconds: 2),
    );
  }
}
