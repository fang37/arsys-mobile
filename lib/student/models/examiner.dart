import 'package:arsys/faculty/models/faculty.dart';
import 'package:arsys/student/models/examiner_score.dart';

abstract class Examiner {
  int id = -1;
  int eventId = -1;
  int applicantId = -1;
  int examinerId = -1;
  int? addition;
  Faculty? faculty;
  bool presence = false;

  // ExaminerScore? score;

  // Examiner.fromJson(Map<String, dynamic> json) {
  //   id = json['id'] ?? -1;
  //   eventId = json['event_id'] ?? -1;
  //   applicantId = json['applicant_id'] ?? -1;
  //   examinerId = json['examiner_id'] ?? -1;
  //   addition = json['addition'] ?? -1;
  //   if (json['faculty'] != null) {
  //     faculty = Faculty.fromJson(json['faculty']);
  //   }
  //   if (json['presence'] != null) {
  //     presence = true;
  //   }
  // }
}

/*
EXAMINER RESPONSE EXAMPLE

  "id": 2337,
  "event_id": 268,
  "applicant_id": 1749,
  "examiner_id": 4,
  "addition": null,
  "created_at": "2022-07-09T19:25:21.000000Z",
  "updated_at": "2022-07-09T19:25:21.000000Z",
  "faculty": {
      "id": 4,
      "code": "INK"
  }
*/