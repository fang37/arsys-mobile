import 'package:arsys/student/models/examiner_score.dart';

class SupervisorScore {
  int id = -1;
  int eventId = -1;
  int applicantId = -1;
  int supervisorId = -1;
  String? defenseNote;
  int? mark;

  String getNotes() {
    return defenseNote ?? "";
  }

  SupervisorScore.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? -1;
    eventId = json['event_id'] ?? -1;
    applicantId = json['applicant_id'] ?? -1;
    supervisorId = json['supervisor_id'] ?? -1;
    defenseNote = json['defense_note'] ?? "";
    mark = json['mark'] ?? -1;
  }
}

/*

 "supervisorscore": [
      {
          "id": 331,
          "event_id": 259,
          "applicant_id": 1743,
          "supervisor_id": 1871,
          "defense_note": null,
          "mark": 400,
          "created_at": "2022-07-19T22:48:56.000000Z",
          "updated_at": "2022-07-19T15:48:56.000000Z"
      }
  ],

*/
