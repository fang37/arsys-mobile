import 'package:arsys/faculty/models/faculty.dart';
import 'package:arsys/student/models/examiner.dart';
import 'package:arsys/student/models/seminar_examiner_score.dart';

class SeminarExaminer extends Examiner {
  List<SeminarExaminerScore>? score = <SeminarExaminerScore>[];

  SeminarExaminer.fromJson(Map<String, dynamic> json) {
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
    if (json['score'] != null) {
      for (var s in json['score']) {
        score?.add(SeminarExaminerScore.fromJson(s));
      }
    } else {}
  }

  int? getApplicantScore(int appId) {
    int? applicantScore;
    if (score != null && score!.isNotEmpty) {
      // TODO: APPLICANT BISA EMPTY
      for (SeminarExaminerScore? s in score!) {
        if (s?.applicantId == appId) {
          applicantScore = s?.mark;
        }
      }
    }
    if (applicantScore == -1) {
      return null;
    }
    return applicantScore;
  }

  int? getApplicantScoreId(int appId) {
    int? scoreId;
    if (score != null && score!.isNotEmpty) {
      // TODO: APPLICANT BISA EMPTY
      // for (SeminarExaminerScore? s in score) {}
      scoreId = score?.singleWhere((s) => s.applicantId == appId).id;
    }
    if (scoreId == -1) {
      return null;
    }
    return scoreId;
  }
}
