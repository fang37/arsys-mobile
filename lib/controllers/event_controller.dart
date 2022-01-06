import 'dart:convert';

import 'package:arsys/models/event.dart';
import 'package:arsys/network/api.dart';
import 'package:arsys/network/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventController extends GetxController {
  var event = List<Event>.empty().obs;
  var events = List<Event>.empty().obs;
  var event_name = {
    1: 'Pre-defense',
    2: 'Final-defense',
    3: 'EE-Seminar',
    4: 'Industrial Practic',
    5: 'Proposal'
  };
  int? id;
  String? event_id;
  String? event_code;
  int? event_type;
  String? application_deadline;
  String? event_date;
  String? draft_deadline;
  int? quota;
  int? current;
  String creator = "";
  int? status;

  void snackBarError(String msg) {
    Get.snackbar(
      "ERROR",
      msg,
      duration: Duration(seconds: 2),
    );
  }

  Future eventUser() async {
    if (event.value.isEmpty) {
      var res;
      res = await Network().getEvent();
      // print(res.bodyString);
      // print(res.body);
      var body;
      try {
        body = await json.decode(res.bodyString);
        // print(body); v
      } catch (e) {
        print(e);
        return event;
      }

      try {
        if (body['success']) {
          event.value.clear();
          var bodies = body['event'];
          if (bodies.length != 0) {
            for (var b in bodies) {
              id = b['id'];
              event_id = b['event_id'];
              event_code = b['event_code'] ?? "";
              event_type = b['event_type'];
              application_deadline = b['application_deadline'] ?? "";
              event_date = b['event_date'] ?? "";
              draft_deadline = b['draft_deadline'] ?? "";
              quota = b['quota'];
              current = b['current'];
              creator = b['creator'] ?? "";
              status = b['status'];

              if (event_date != null && event_date != "") {
                var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
                var inputDate = inputFormat.parse(event_date!);

                var outputFormat = DateFormat('dd-MM-yyyy HH:mm');
                var outputDate = outputFormat.format(inputDate);

                event_date = outputDate.toString();
              }
              if (application_deadline != null && application_deadline != "") {
                var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
                var inputDate = inputFormat.parse(application_deadline!);

                var outputFormat = DateFormat('dd-MM-yyyy HH:mm');
                var outputDate = outputFormat.format(inputDate);

                application_deadline = outputDate.toString();
              }
              if (draft_deadline != null && draft_deadline != "") {
                var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
                var inputDate = inputFormat.parse(draft_deadline!);

                var outputFormat = DateFormat('dd-MM-yyyy HH:mm');
                var outputDate = outputFormat.format(inputDate);

                draft_deadline = outputDate.toString();
              }

              event.add(Event(
                  id: id,
                  event_id: event_id,
                  event_name: event_name[event_type],
                  event_code: event_code,
                  event_type: event_type,
                  application_deadline: application_deadline,
                  event_date: event_date,
                  draft_deadline: draft_deadline,
                  quota: quota,
                  current: current,
                  creator: creator,
                  status: status));
            }
          }
        }
        return (event);
      } catch (e) {
        print(e);
      }
    }
    return (event);
  }

  Future eventsUser() async {
    if (events.value.isEmpty) {
      var res;
      res = await Network().getEvents();
      // print(res.bodyString);
      // print(res.body);
      var body;
      try {
        body = await json.decode(res.bodyString);
      } catch (e) {
        print(e);
        return events;
      }

      try {
        if (body['success']) {
          events.value.clear();
          var bodies = body['event'];
          for (var b in bodies) {
            id = b['id'];
            event_id = b['event_id'];
            event_code = b['event_code'] ?? "";
            event_type = b['event_type'];
            application_deadline = b['application_deadline'] ?? "";
            event_date = b['event_date'] ?? "";
            draft_deadline = b['draft_deadline'] ?? "";
            quota = b['quota'];
            current = b['current'];
            creator = b['creator'] ?? "";
            status = b['status'];

            if (event_date != null && event_date != "") {
              var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
              var inputDate = inputFormat.parse(event_date!);

              var outputFormat = DateFormat('dd-MM-yyyy HH:mm');
              var outputDate = outputFormat.format(inputDate);

              event_date = outputDate.toString();
            }
            if (application_deadline != null && application_deadline != "") {
              var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
              var inputDate = inputFormat.parse(application_deadline!);

              var outputFormat = DateFormat('dd-MM-yyyy HH:mm');
              var outputDate = outputFormat.format(inputDate);

              application_deadline = outputDate.toString();
            }
            if (draft_deadline != null && draft_deadline != "") {
              var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
              var inputDate = inputFormat.parse(draft_deadline!);

              var outputFormat = DateFormat('dd-MM-yyyy HH:mm');
              var outputDate = outputFormat.format(inputDate);

              draft_deadline = outputDate.toString();
            }

            events.add(Event(
                id: id,
                event_id: event_id,
                event_name: event_name[event_type],
                event_code: event_code,
                event_type: event_type,
                application_deadline: application_deadline,
                event_date: event_date,
                draft_deadline: draft_deadline,
                quota: quota,
                current: current,
                creator: creator,
                status: status));
          }
        }
        return (events);
      } catch (e) {
        print(e);
      }
    }
    return (events);
  }

  // Future refreshEvent() async {
  //   event.clear();
  //   events.clear();
  //   eventUser();
  //   eventsUser();
  //   await Future.delayed(Duration(seconds: 2));
  //   setState(() {};
  // }

  Icon iconBuilder(int event_type, double size, Color color) {
    if (event_type == 1) {
      return Icon(
        Icons.article_outlined,
        size: size,
        color: color,
      );
    } else if (event_type == 2) {
      return Icon(Icons.school_outlined, size: size, color: color);
    } else if (event_type == 3) {
      return Icon(Icons.event_available_outlined, size: size, color: color);
    } else if (event_type == 4) {
      return Icon(Icons.build_outlined, size: size, color: color);
    } else if (event_type == 5) {
      return Icon(Icons.book_outlined, size: size, color: color);
    } else
      return Icon(Icons.schedule_outlined, size: size, color: color);
  }

  TextStyle rowStyle() {
    return TextStyle(fontSize: 15, fontFamily: "Helvetica");
  }

  TextStyle headStyle() {
    return TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontFamily: "Helvetica",
        fontWeight: FontWeight.bold);
  }

  Color timelineColor(String date) {
    if (date != null && date != "") {
      var inputFormat = DateFormat('dd-MM-yyyy HH:mm');
      var inputDate = inputFormat.parse(date!);

      var outputFormat = DateFormat('dd-MM-yyyy');

      var temp = outputFormat.parse(outputFormat.format(DateTime.now()));
      var outputDate = outputFormat.parse(outputFormat.format(inputDate));

      if (temp.compareTo(outputDate) < 0) {
        return Colors.grey;
      }
      if (temp.compareTo(outputDate) == 0) {
        return Colors.redAccent;
      }
      if (temp.compareTo(outputDate) > 0) {
        return Colors.lightBlueAccent;
      }
    }
    return Colors.grey;
  }
}
