import 'dart:convert';

import 'package:arsys/student/models/event.dart';
import 'package:arsys/network/network.dart';
import 'package:arsys/network/event_provider.dart';
import 'package:arsys/student/models/event_applicant.dart';
import 'package:arsys/student/models/examiner.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/research.dart';

class EventController extends GetxController {
  var event = List<Event>.empty().obs;
  var events = List<Event>.empty().obs;
  var applicableEvents = List<Event>.empty().obs;
  var eventApplicants = List<EventApplicant>.empty().obs;
  Event? seminarRoomApplicant;
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
      var response;
      response = await Network().getEvent();
      // print(response.bodyString);

      var body;
      try {
        body = await json.decode(response.bodyString);
      } catch (e) {
        print(e);
        return event;
      }

      try {
        if (response.statusCode == HttpStatus.ok) {
          event.value.clear();
          var bodies = body['event'];
          if (bodies.length != 0) {
            for (var item in bodies) {
              event.add(Event.fromJson(item));
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
      var response;
      response = await Network().getEvents();
      // print(response.bodyString);
      var body;

      try {
        body = await json.decode(response.bodyString);
      } catch (e) {
        print(e);
        return events;
      }

      try {
        if (response.statusCode == HttpStatus.ok) {
          events.value.clear();
          var bodies = body['event'];
          for (var item in bodies) {
            events.add(Event.fromJson(item));
          }
        }
        return (events);
      } catch (e) {
        print(e);
      }
    }
    return (events);
  }

  Future getApplicableEvent(int id) async {
    applicableEvents.clear();
    if (applicableEvents.value.isEmpty) {
      var response;
      response = await Network().getApplicableEventById(id);
      // print(response.bodyString);
      var body;

      try {
        body = await json.decode(response.bodyString);
      } catch (e) {
        print(e);
        return applicableEvents;
      }

      try {
        if (response.statusCode == HttpStatus.ok) {
          applicableEvents.value.clear();
          var bodies = body['event'];
          for (var item in bodies) {
            applicableEvents.add(Event.fromJson(item));
          }
        }
        return (applicableEvents);
      } catch (e) {
        print(e);
      }
    }
    return (applicableEvents);
  }

  Future getEventApplicantByResearch(int researchId) async {
    var response;
    response = await Network().getEventApplicantByResearchId(researchId);
    // print(response.bodyString);
    var body;

    try {
      body = await json.decode(response.bodyString);
    } catch (e) {
      print(e);
      return eventApplicants;
    }

    try {
      if (response.statusCode == HttpStatus.ok) {
        eventApplicants.value.clear();
        var bodies = body['applicant'];
        print(bodies);
        for (var item in bodies) {
          eventApplicants.add(EventApplicant.fromJson(item));
        }
      }
      return (eventApplicants);
    } catch (e) {
      print(e);
    }

    return (eventApplicants);
  }

  Future getEventApplicantByEvent(int eventId) async {
    var response;
    response = await Network().getEventApplicantByEventId(eventId);
    // print(response.bodyString);
    var body;

    try {
      body = await json.decode(response.bodyString);
    } catch (e) {
      print(e);
      return eventApplicants;
    }

    try {
      if (response.statusCode == HttpStatus.ok) {
        eventApplicants.value.clear();
        var bodies = body['applicant'];
        for (var item in bodies) {
          eventApplicants.add(EventApplicant.fromJson(item));
        }
      }
      return (eventApplicants);
    } catch (e) {
      print(e);
    }

    return (eventApplicants);
  }

  Future getSupervisedApplicantByEvent(int eventId) async {
    var response;
    response = await Network().getSupervisedApplicantByEventId(eventId);
    // print(response.bodyString);
    var body;

    try {
      body = await json.decode(response.bodyString);
    } catch (e) {
      print(e);
      return eventApplicants;
    }

    try {
      if (response.statusCode == HttpStatus.ok) {
        eventApplicants.value.clear();
        var bodies = body['applicants'];
        for (var item in bodies) {
          eventApplicants.add(EventApplicant.fromJson(item));
        }
      }
      return (eventApplicants);
    } catch (e) {
      print(e);
    }

    return (eventApplicants);
  }

  Future getSeminarRoomApplicantByEvent(int eventId) async {
    var response;
    response = await Network().getSeminarRoomApplicantByEventId(eventId);
    // print(response.bodyString);
    var body;

    try {
      body = await json.decode(response.bodyString);
    } catch (e) {
      print(e);
      return seminarRoomApplicant;
    }

    try {
      if (response.statusCode == HttpStatus.ok) {
        if (body['event'] != null) {
          seminarRoomApplicant = Event.fromJson(body['event']);
        }
      }
      return (seminarRoomApplicant);
    } catch (e) {
      print(e);
    }

    return (seminarRoomApplicant);
  }

  Future<bool> applyEvent(Research res, int eventId) async {
    if (res.id != null && res.getEventType() == EventType.preDefense ||
        res.getEventType() == EventType.finalDefense) {
      var response;
      response = await Network().applyEvent(res.id, eventId);
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
          print(res);
          return true;
        }
      } catch (e) {
        print(e);
        return false;
      }
    }
    return false;
  }

  Future<bool> setPresenceRoomExaminer(
      List<bool> newPresence, List<Examiner>? examiners) async {
    print("RIGHT HERE");
    var resultResponses = List<bool>.empty(growable: true);
    if (newPresence != null && examiners != null) {
      if (newPresence.length == examiners.length) {
        for (int index = 0; index < examiners.length; index++) {
          if (examiners[index].presence != newPresence[index]) {
            var response;
            response = await Network().setPresenceRoomExaminer(
                examiners[index].id, newPresence[index]);
            print(response.bodyString);
            var body;

            try {
              body = await json.decode(response.bodyString);
            } catch (e) {
              print(e);
              resultResponses.add(false);
            }

            try {
              if (response.statusCode == HttpStatus.ok) {
                resultResponses.add(true);
              }
            } catch (e) {
              print(e);
              resultResponses.add(false);
            }
          }
        }
        return resultResponses.every((element) => element == true);
      }
    }
    return false;
  }

  Future<bool> setMarkRoomExaminer(
      int scoreId, int mark, String? seminarNotes) async {
    print("RIGHT HERE");

    if (scoreId != null && mark != null) {
      var response;
      response = await Network()
          .setMarkRoomExaminer(scoreId, mark, seminarNotes ?? "");
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
        }
      } catch (e) {
        print(e);
        return false;
      }
    }
    return false;
  }

  Future<bool> setSupervisorMark(int supervisorId, int eventId, int applicantId,
      int mark, String? seminarNotes) async {
    if (supervisorId != null &&
        eventId != null &&
        applicantId != null &&
        mark != null) {
      var response;
      response = await Network().setSupervisorMark(
          supervisorId, eventId, applicantId, mark, seminarNotes ?? "");
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
        }
      } catch (e) {
        print(e);
        return false;
      }
    }
    return false;
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
    return TextStyle(fontSize: 16, fontFamily: "OpenSans");
  }

  TextStyle headStyle() {
    return TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontFamily: "OpenSans",
        fontWeight: FontWeight.bold);
  }

  Color timelineColor(String date) {
    if (date != null && date != "") {
      var inputFormat = DateFormat('dd-MM-yyyy HH:mm');
      var inputDate = inputFormat.parse(date);

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
