import 'package:arsys/faculty/models/faculty.dart';
import 'package:intl/intl.dart';

class Lecture {
  int? id;
  // int? research_type;
  String? name; // subject[name]
  String? code; // subject[code]
  String? credit; // subject[credit]
  String? semester; // subject[semester]
  String? programName; // program[abbrev]
  int? programId; // program[abbrev]
  String? room; // room[name]
  String? daytime; // daytime
  String? teamName = ""; // daytime

  // var desc;
  // var subject;
  // var student;
  // var program;
  // var room;

  Lecture({
    this.id,
    // this.research_type,
    this.name,
    this.code,
    this.credit,
    this.semester,
    this.programName,
    this.programId,
    this.room,
    this.daytime,
    // this.desc,
    // this.subject,
    // this.student,
    // this.program,
    // this.room,
    this.teamName,
  });

  Lecture.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['subject']['name'] ?? "";
    code = json['subject']['code'] ?? "";
    credit = json['subject']['credit'] ?? "";
    semester = json['subject']['semester'] ?? "";
    programName = json['program']['abbrev'] ?? "";
    programId = json['program']['id'];
    room = json['room_id'] != null ? json['room']['name'] : "-";
    daytime = formatDaytime(json['daytime']);
    for (var item in json['teams']) {
      if (teamName == "") {
        teamName = (item['faculty']['code']) ?? '';
      } else {
        teamName = teamName! + " - " + ((item['faculty']['code']) ?? '');
      }
    }
  }

  String? formatDaytime(date) {
    if (date != null) {
      // daytime = daytime!.substring(
      //     0, daytime!.length - 3); //remove seconds in daytime
      var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
      var inputDate = inputFormat.parse(date!);

      var outputFormat = DateFormat('EEEE HH:mm');
      var outputDate = outputFormat.format(inputDate);

      var endFormat = DateFormat('HH:mm');
      var endDaytime = endFormat
          .format(inputDate.add(Duration(minutes: (50 * int.parse(credit!)))));

      // daytime = end_daytime.toString();
      String formattedDaytime =
          outputDate.toString() + "-${endDaytime.toString()}";
      return formattedDaytime;
    }
    return "";
  }
}
