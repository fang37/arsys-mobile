abstract class ExaminerScore {
  int id = -1;
  int examinerId = -1;
  int eventId = -1;
  int applicantId = -1;
  int? mark;

  String getNotes();
}

/*
SeminarExaminerScore
['examiner_id', 'event_id', 'applicant_id', 'mark', 'seminar_note']

DefenseExaminerScore
['applicant_id','examiner_id', 'event_id', 'defense_note', 'mark'];

*/
