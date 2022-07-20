import 'package:arsys/student/models/examiner_score.dart';

class SeminarExaminerScore extends ExaminerScore {
  String? seminarNote;

  @override
  String getNotes() {
    return seminarNote ?? "";
  }

  SeminarExaminerScore.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? -1;
    examinerId = json['examiner_id'] ?? -1;
    eventId = json['event_id'] ?? -1;
    applicantId = json['applicant_id'] ?? -1;
    mark = json['mark'] ?? -1;
    seminarNote = json['seminar_note'] ?? "";
  }
}
