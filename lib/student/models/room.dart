import 'package:arsys/student/models/event_applicant.dart';
import 'package:arsys/student/models/examiner.dart';
import 'package:arsys/student/models/seminar_examiner.dart';
import 'package:arsys/student/models/seminar_examiner_score.dart';
import 'package:arsys/student/models/seminar_moderator.dart';

class Room {
  int id = -1;
  int eventId = -1;
  String? roomCode;
  int? spaceId = -1;
  int? sessionId = -1;
  int? moderatorId = -1;
  Space? space;
  Session? session;

  List<EventApplicant>? applicant = <EventApplicant>[];
  List<SeminarExaminer>? examiner = <SeminarExaminer>[];
  List<SeminarModerator>? moderator = <SeminarModerator>[];

  Room.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eventId = json['event_id'];
    roomCode = json['room_code'];
    spaceId = json['space_id'];
    sessionId = json['session_id'];
    moderatorId = json['moderator_id'];
    if (json['applicant'] != null) {
      for (var ex in json['applicant']) {
        applicant?.add(EventApplicant.researchOnlyFromJson(ex));
      }
    }
    if (json['examiner'] != null) {
      for (var ex in json['examiner']) {
        examiner?.add(SeminarExaminer.fromJson(ex));
      }
    }
    if (json['moderator'] != null) {
      for (var mod in json['moderator']) {
        moderator?.add(SeminarModerator.fromJson(mod));
      }
    }
    space = json['space'] == null
        ? Space.nullFromJson()
        : Space.fromJson(json['space']);
    session = json['session'] == null
        ? Session.nullFromJson()
        : Session.fromJson(json['session']);
  }

  List<bool>? getExaminerRoomPresence() {
    var presences = List<bool>.empty(growable: true);
    if (examiner != null) {
      for (SeminarExaminer ex in examiner!) {
        presences.add(ex.presence);
      }
    }
    print("GET EXAMINER != NULL");
    print("$presences");
    return presences;
  }

  bool getExaminerPresence(int facultyId) {
    SeminarExaminer? userExaminer;
    if (examiner != null && examiner!.isNotEmpty) {
      userExaminer = examiner?.singleWhere((ex) => ex.examinerId == facultyId);
      if (userExaminer != null) {
        return userExaminer.presence;
      }
    }
    return false;
  }

  SeminarExaminer? getExaminerByUser(int facultyId) {
    SeminarExaminer? result;
    if (examiner != null) {
      result = examiner?.singleWhere((ex) => ex.examinerId == facultyId);
    }
    return result;
  }

  // int getApplicantScore(int applicantId) {
  //   SeminarExaminerScore? score;
  //   for (SeminarExaminer ex in examiner!) {
  //     score = ex.score?.singleWhere((s) => s.applicantId == applicantId);
  //   }
  // }

  bool isModerator(int id) {
    for (SeminarModerator mod in moderator!) {
      if (mod.moderatorId == id) {
        return true;
      }
    }
    return false;
  }
}

/*
  "id": 57,
  "event_id": 260,
  "room_code": "PUB1",
  "space_id": 19,
  "session_id": 11,
  "moderator_id": 12,
  "created_at": "2022-06-27T22:33:07.000000Z",
  "updated_at": "2022-06-27T15:33:07.000000Z",
   "examiner": [
                            {
                                "id": 290,
                                "event_id": null,
                                "room_id": 57,
                                "examiner_id": 13,
                                "addition": null,
                                "created_at": "2022-06-27T15:08:25.000000Z",
                                "updated_at": "2022-06-27T15:08:25.000000Z"
                            },
                            {
                                "id": 291,
                                "event_id": null,
                                "room_id": 57,
                                "examiner_id": 3,
                                "addition": null,
                                "created_at": "2022-06-27T15:08:33.000000Z",
                                "updated_at": "2022-06-27T15:08:33.000000Z"
                            },
                            {
                                "id": 292,
                                "event_id": null,
                                "room_id": 57,
                                "examiner_id": 26,
                                "addition": null,
                                "created_at": "2022-06-27T15:33:24.000000Z",
                                "updated_at": "2022-06-27T15:33:24.000000Z"
                            }
                            ]
*/