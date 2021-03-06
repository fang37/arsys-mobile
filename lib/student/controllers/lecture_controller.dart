import 'dart:convert';
import 'package:arsys/student/models/lecture.dart';
import 'package:arsys/network/network.dart';
import 'package:arsys/network/event_provider.dart';
import 'package:arsys/network/lecture_provider.dart';
import 'package:arsys/network/research_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class LectureController extends GetxController {
  var lecture = List<Lecture>.empty().obs;
  var lectures = List<Lecture>.empty().obs;

  // };
  // int? id;
  // String? name; // subject[name]
  // String? code; // subject[code]
  // String? credit; // subject[credit]
  // String? semester; // subject[semester]
  // String? program_name; // program[abbrev]
  // int? program_id; // program[abbrev]
  // String? room; // room[name]
  // String? daytime; // daytime
  // String team_name = ""; // daytime

  var team;

  Future? lectureUser() async {
    if (lecture.value.isEmpty) {
      var response;
      response = await Network().getLecture(); // LECTURE PROVIDER
      var body;
      try {
        body = await json.decode(response.bodyString);
      } catch (e) {
        print(e);
        return lecture;
      }

      try {
        if (response.statusCode == HttpStatus.ok) {
          lecture.value.clear();
          var bodies = body['schedules'];
          if (bodies.length != 0) {
            for (var item in bodies) {
              lecture.add(Lecture.fromJson(item));
            }
          }
        }
        // from low to high according to price
        lecture.sort((a, b) => a.semester!.compareTo(b.semester!));
        // lecture.sort((a, b) => a.class_code!.compareTo(b.class_code!));
        return (lecture);
      } catch (e) {
        print(e);
      }
    }
    return (lecture);
  }

  Future allLecture() async {
    if (lectures.value.isEmpty) {
      var response;
      response = await Network().getLectures(); // LECTURE PROVIDER
      var body;

      try {
        body = await json.decode(response.bodyString);
      } catch (e) {
        print(e);
        return lectures;
      }

      try {
        if (response.statusCode == HttpStatus.ok) {
          lectures.value.clear();
          var bodies = body['schedules'];
          if (bodies.length != 0) {
            for (var item in bodies) {
              lectures.add(Lecture.fromJson(item));
            }
          }
        }
        // from low to high according to price
        lectures.sort((a, b) => a.semester!.compareTo(b.semester!));
        // lecture.sort((a, b) => a.class_code!.compareTo(b.class_code!));
        return (lectures);
      } catch (e) {
        print(e);
      }
    }
    return (lectures);
  }

  // Icon iconBuilder(
  //     int research_type, double size, int index, String milestone) {
  //   Color color = Colors.white;
  //   // switch (milestone) {
  //   //   case 'Pre-defense':
  //   //     color = Colors.yellow[600];
  //   //     break;
  //   //   case 'Final-defense':
  //   //     color = Colors.deepOrange[300];
  //   //     break;
  //   //   case 'Graduated':
  //   //     color = Colors.green;
  //   //     break;
  //   //   default:
  //   // }
  //   if (research_type == 1) {
  //     return Icon(Icons.school, size: size, color: color);
  //   } else if (research_type == 2) {
  //     return Icon(Icons.school, size: size, color: color);
  //   } else if (research_type == 3) {
  //     return Icon(Icons.build, size: size, color: color);
  //   } else if (research_type == 4) {
  //     return Icon(Icons.book, size: size, color: color);
  //   } else if (research_type == 5) {
  //     return Icon(Icons.book, size: size, color: color);
  //   } else
  //     return Icon(Icons.schedule, size: size, color: color);
  // }

  // Color cardColorBuilder(String milestone) {
  //   switch (milestone) {
  //     case 'Pre-defense':
  //       return Color(0xFFFED330);
  //       break;
  //     case 'Final-defense':
  //       return Color(0xFFFC5C65);
  //       break;
  //     case 'Graduated':
  //       return Color(0xFF26DE81);
  //       break;
  //     case 'Suspended':
  //       return Color(0xFFA5B1C2);
  //       break;
  //     default:
  //       return Color(0xFF778CA3);
  //   }
  //   // switch (milestone) {
  //   //   case 'Pre-defense':
  //   //     return Colors.yellowAccent[100];
  //   //     break;
  //   //   case 'Final-defense':
  //   //     return Colors.deepOrange[100];
  //   //     break;
  //   //   case 'Graduated':
  //   //     return Colors.lightGreenAccent[100];
  //   //     break;
  //   //   default:
  //   // }
  // }

  // Icon bypassIcon(var bypass) {
  //   if (bypass == 1) {
  //     return Icon(Icons.check_rounded, size: 24, color: Color(0xFF26DE81));
  //   } else
  //     return Icon(Icons.block_rounded, size: 24, color: Color(0xFFFC5C65));
  // }

  // Icon approvalIcon(var decision) {
  //   if (decision == 1) {
  //     return Icon(Icons.check_circle, size: 16, color: Color(0xFF26DE81));
  //   } else
  //     return Icon(Icons.block, size: 16, color: Color(0xFFFC5C65));
  // }

  void snackBarError(String msg) {
    Get.snackbar(
      "ERROR",
      msg,
      duration: Duration(seconds: 2),
    );
  }
}
