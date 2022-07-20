import 'package:arsys/faculty/models/faculty.dart';
import 'package:arsys/student/models/defense_examiner_score.dart';
import 'package:arsys/student/models/examiner.dart';

class DefenseExaminer extends Examiner {
  DefenseExaminerScore? score;

  DefenseExaminer.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? -1;
    eventId = json['event_id'] ?? -1;
    applicantId = json['applicant_id'] ?? -1;
    examinerId = json['examiner_id'] ?? -1;
    if (json['faculty'] != null) {
      faculty = Faculty.fromJson(json['faculty']);
    }
    if (json['presence'] != null) {
      presence = true;
    }
    if (json['examinerscore'] != null) {
      score = DefenseExaminerScore.fromJson(json['examinerscore']);
    }
  }
}
