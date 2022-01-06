class Lecture {
  int? id;
  // int? research_type;
  String? name; // subject[name]
  String? code; // subject[code]
  String? credit; // subject[credit]
  String? semester; // subject[semester]
  String? class_code; // student[code]
  int? grade; // student[grade]
  String? program_name; // program[abbrev]
  int? program_id; // program[abbrev]
  String? room; // room[name]
  String? daytime; // daytime
  String? team_name; // daytime

  // var desc;
  // var subject;
  // var student;
  // var program;
  // var room;
  var team;

  Lecture({
    this.id,
    // this.research_type,
    this.name,
    this.code,
    this.credit,
    this.semester,
    this.class_code,
    this.grade,
    this.program_name,
    this.program_id,
    this.room,
    this.daytime,
    // this.desc,
    // this.subject,
    // this.student,
    // this.program,
    // this.room,
    this.team_name,
    this.team,
  });
}
