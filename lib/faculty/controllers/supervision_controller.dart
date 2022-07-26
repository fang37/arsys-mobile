import 'dart:convert';
import 'package:arsys/network/network.dart';
import 'package:arsys/network/event_provider.dart';
import 'package:arsys/network/research_provider.dart';
import 'package:arsys/student/models/defense_approval.dart';
import 'package:arsys/student/models/event.dart';
import 'package:arsys/student/models/research.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SupervisionController extends GetxController {
  late Research research;
  var researches = List<Research>.empty().obs;

  Future researchUser() async {
    researches.clear();
    if (researches.value.isEmpty) {
      var response;
      response = await Network().getResearch();
      // print(response.bodyString);

      var body;

      try {
        body = await json.decode(response.bodyString);
      } catch (e) {
        print(e);
        return researches;
      }

      try {
        if (response.statusCode == HttpStatus.ok) {
          researches.value.clear();
          var items = body['research'];
          if (items.length != 0) {
            for (var item in items) {
              researches.add(Research.supervisionFromJson(item));
            }
          }
          print(researches);
        }
        return (researches);
      } catch (e) {
        print(e);
      }
    }
    return (researches);
  }

  Future<List<Research>> researchListUser() async {
    researches.clear();
    if (researches.value.isEmpty) {
      var response;
      // TODO: make dedicated api for research list only
      response = await Network().getResearch();
      // print(response.bodyString);
      var body;

      try {
        body = await json.decode(response.bodyString);
      } catch (e) {
        print(e);
        return researches;
      }

      try {
        if (response.statusCode == HttpStatus.ok) {
          researches.value.clear();
          var items = body['research'];
          if (items.length != 0) {
            for (var item in items) {
              researches.add(Research.supervisionFromJson(item));
            }
          }
          print(researches);
        }
        return (researches);
      } catch (e) {
        print(e);
      }
    }
    return (researches);
  }

  Future researchById(int id) async {
    var response;
    response = await Network().getResearchById(id);
    // print(response.bodyString);

    var body;

    try {
      body = await json.decode(response.bodyString);
    } catch (e) {
      print(e);
      return research;
    }

    try {
      if (response.statusCode == HttpStatus.ok) {
        var item = body['research'];
        // if (items.length != 0) {
        //   for (var item in items) {
        research = Research.supervisionFromJson(item[0]);
        // }
        // }
        print(research);
      }
      return (research);
    } catch (e) {
      print(e);
    }

    return (research);
  }

  Future submitDefenseReport(Research res, int applicantId,
      String defenseResume, String defenseDate) async {
    if (res.getSubmissionType() == SubmissionType.defenseReport) {
      var response;
      response = await Network()
          .submitDefenseReport(res.id, applicantId, defenseResume, defenseDate);
      // print(response.bodyString);

      var body;

      try {
        body = await json.decode(response.bodyString);
      } catch (e) {
        print(e);
        return false;
      }

      try {
        if (response.statusCode == HttpStatus.ok) {
          return true;
          print(res);
        }
        return false;
      } catch (e) {
        print(e);
      }
    }
    return false;
  }

  Future approveDefense(Research res, id) async {
    if (res.id != null &&
        res.defenseApproval
                ?.singleWhere((element) => element.id == id)
                .decision ==
            false) {
      var response;
      response = await Network().approveDefense(id);
      // print(response.bodyString);

      var body;

      try {
        body = await json.decode(response.bodyString);
      } catch (e) {
        print(e);
        return false;
      }

      try {
        if (response.statusCode == HttpStatus.ok) {
          res.defenseApproval
              ?.singleWhere((element) => element.id == id)
              .decision = true;
          print(res);
        }
        return (res.defenseApproval
            ?.singleWhere((element) => element.id == id)
            .decision);
      } catch (e) {
        print(e);
      }
    }
    return (res.defenseApproval
        ?.singleWhere((element) => element.id == id)
        .decision);
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

  Icon approvalIcon(var decision, {double size = 30}) {
    if (decision) {
      return Icon(Icons.check_circle, size: size, color: Colors.greenAccent);
    } else
      return Icon(Icons.block, size: size, color: Colors.redAccent);
  }

  Color timelineColor(bool decision) {
    if (decision) {
      return Colors.greenAccent;
    } else
      return Colors.redAccent;
  }

  Icon proposalDecisionIcon(int decision) {
    switch (decision) {
      case 1:
        {
          return const Icon(Icons.check_circle_rounded,
              size: 30, color: Colors.greenAccent);
        }
      case 2:
        {
          return const Icon(Icons.block_rounded,
              size: 30, color: Colors.redAccent);
        }
      case 3:
        {
          return const Icon(Icons.create_rounded,
              size: 30, color: Colors.blueGrey);
        }
      case 4:
        {
          return const Icon(Icons.co_present_rounded,
              size: 30, color: Colors.blueGrey);
        }
      case 5:
        {
          return const Icon(Icons.playlist_add_check_rounded,
              size: 30, color: Colors.lightBlueAccent);
        }
      default:
        {
          return const Icon(Icons.access_time_rounded,
              size: 30, color: Colors.lightBlueAccent);
        }
    }
  }

  void snackBarError(String msg) {
    Get.snackbar(
      "ERROR",
      msg,
      duration: Duration(seconds: 2),
    );
  }
}
