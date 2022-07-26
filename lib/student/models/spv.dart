import 'package:arsys/student/models/supervisor_score.dart';

class SPV {
  int id = -1;
  int researchId = -1;
  int supervisorId = -1;
  List<SupervisorScore>? supervisorScore = <SupervisorScore>[];

  SPV.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    researchId = json['research_id'];
    supervisorId = json['supervisor_id'];
    for (var score in json['supervisorscore'] ?? []) {
      supervisorScore?.add(SupervisorScore.fromJson(score));
    }
  }

  SupervisorScore? getScore() {
    for (SupervisorScore spv in supervisorScore ?? []) {
      return spv;
    }
    return null;
  }
}


/*
 "id": 2008,
"research_id": 1665,
"supervisor_id": 3,
"bypass": null,
"created_at": "2022-06-15T17:56:04.000000Z",
"updated_at": "2022-06-15T17:56:04.000000Z",
"supervisorscore": [
    {
        "id": 332,
        "event_id": 268,
        "applicant_id": 1748,
        "supervisor_id": 2008,
        "defense_note": null,
        "mark": 200,
        "created_at": "2022-07-19T22:49:23.000000Z",
        "updated_at": "2022-07-19T15:49:23.000000Z"
    }
],
"faculty": {
    "id": 3,
    "user_id": 1,
    "sso_username": "197608272009121001",
    "code": "DDW",
    "upi_code": "2934",
    "nip": "197608272009121001",
    "old_nip": null,
    "front_title": null,
    "rear_title": "Ph.D",
    "first_name": "Didin",
    "last_name": "Wahyudin",
    "duty_id": null,
    "specialization_id": 1,
    "program_id": null,
    "phone": null,
    "email": null,
    "created_at": "2021-03-22T09:34:26.000000Z",
    "updated_at": "2021-03-22T10:16:17.000000Z"
}

*/