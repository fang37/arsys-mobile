import 'dart:convert';
import 'package:arsys/models/research.dart';
import 'package:arsys/network/event_provider.dart';
import 'package:arsys/network/research_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResearchController extends GetxController {
  var research = List<Research>.empty().obs;
  var research_name = {
    1: 'SKRIPSI',
    2: 'Tugas Akhir',
    3: 'PRAKTIK INDUSTRI',
    4: 'Seminar Teknik Elektro',
    5: 'TESIS',
    6: 'DISERTASI'
  };

  int? id;
  int? research_type;
  String? research_code;
  String? title;
  String? abstract;
  int? research_milestone;
  int? status;
  String? approval_date;
  String? research_id;

  var supervisor;
  var supervise;
  var milestone;
  var defense_approval;

  Future researchUser() async {
    if (research.value.isEmpty) {
      var res;
      res = await ResearchProvider().getResearch();
      print(res.bodyString);
      // print(res.body);
      var body;
      try {
        body = await json.decode(res.bodyString);
      } catch (e) {
        print(e);
        return research;
      }

      try {
        if (body['success']) {
          research.value.clear();
          var bodies = body['research'];
          if (bodies.length != 0) {
            for (var b in bodies) {
              id = b['id'];
              research_type = b['research_type'];
              research_code = b['research_code'];
              title = b['title'];
              abstract = b['abstract'];
              research_milestone = b['research_milestone'];
              status = b['status'];
              approval_date = b['approval_date'];
              research_id = b['research_id'];
              supervisor = b['supervisor'];
              supervise = b['supervise'];
              milestone = b['milestone'];
              defense_approval = b['defense_approval'];

              research.add(Research(
                id: id,
                research_type: research_type,
                research_name: research_name[research_type],
                research_code: research_code,
                title: title,
                abstract: abstract,
                research_milestone: research_milestone,
                status: status,
                approval_date: approval_date,
                research_id: research_id,
                supervisor: supervisor,
                supervise: supervise,
                milestone: milestone,
                defense_approval: defense_approval,
              ));
            }
          }
          print(research);
        }
        return (research);
      } catch (e) {
        print(e);
      }
    }
    return (research);
  }

  Icon iconBuilder(
      int research_type, double size, int index, String milestone) {
    Color color = Colors.white;
    // switch (milestone) {
    //   case 'Pre-defense':
    //     color = Colors.yellow[600];
    //     break;
    //   case 'Final-defense':
    //     color = Colors.deepOrange[300];
    //     break;
    //   case 'Graduated':
    //     color = Colors.green;
    //     break;
    //   default:
    // }
    if (research_type == 1) {
      return Icon(Icons.school, size: size, color: color);
    } else if (research_type == 2) {
      return Icon(Icons.school, size: size, color: color);
    } else if (research_type == 3) {
      return Icon(Icons.build, size: size, color: color);
    } else if (research_type == 4) {
      return Icon(Icons.book, size: size, color: color);
    } else if (research_type == 5) {
      return Icon(Icons.book, size: size, color: color);
    } else
      return Icon(Icons.schedule, size: size, color: color);
  }

  Color cardColorBuilder(String milestone) {
    switch (milestone) {
      case 'Pre-defense':
        return Color(0xFFFED330);
        break;
      case 'Final-defense':
        return Color(0xFFFC5C65);
        break;
      case 'Graduated':
        return Color(0xFF26DE81);
        break;
      case 'Suspended':
        return Color(0xFFA5B1C2);
        break;
      default:
        return Color(0xFF778CA3);
    }
    // switch (milestone) {
    //   case 'Pre-defense':
    //     return Colors.yellowAccent[100];
    //     break;
    //   case 'Final-defense':
    //     return Colors.deepOrange[100];
    //     break;
    //   case 'Graduated':
    //     return Colors.lightGreenAccent[100];
    //     break;
    //   default:
    // }
  }

  Icon bypassIcon(var bypass) {
    if (bypass == 1) {
      return Icon(Icons.check_rounded, size: 24, color: Color(0xFF26DE81));
    } else
      return Icon(Icons.block_rounded, size: 24, color: Color(0xFFFC5C65));
  }

  Icon approvalIcon(var decision) {
    if (decision == 1) {
      return Icon(Icons.check_circle, size: 16, color: Color(0xFF26DE81));
    } else
      return Icon(Icons.block, size: 16, color: Color(0xFFFC5C65));
  }

  void snackBarError(String msg) {
    Get.snackbar(
      "ERROR",
      msg,
      duration: Duration(seconds: 2),
    );
  }
}
