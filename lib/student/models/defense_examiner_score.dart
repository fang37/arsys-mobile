import 'package:arsys/student/models/examiner_score.dart';

class DefenseExaminerScore extends ExaminerScore {
  String? defenseNote;

  @override
  String getNotes() {
    return defenseNote ?? "";
  }

  DefenseExaminerScore.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? -1;
    examinerId = json['examiner_id'] ?? -1;
    eventId = json['event_id'] ?? -1;
    mark = json['mark'] ?? -1;
    defenseNote = json['seminar_note'] ?? "";
  }
}
