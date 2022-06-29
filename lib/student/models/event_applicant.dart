import 'package:arsys/faculty/models/faculty.dart';
import 'package:arsys/student/models/event.dart';

class EventApplicant {
  int id = -1;
  Event? event;
  Space? space;
  Session? session;
  List<Faculty>? examiner = <Faculty>[];

  EventApplicant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    event = Event.fromJson(json['event']);
    space = json['space'] == null
        ? Space.nullFromJson()
        : Space.fromJson(json['space']);
    session = json['session'] == null
        ? Session.nullFromJson()
        : Session.fromJson(json['session']);
    if (json['examiner'] != null) {
      for (var item in json['examiner']) {
        examiner!.add(Faculty.codeOnlyFromJson(item['faculty']));
      }
    }
  }

  String getExaminerCode() {
    String code = "-";
    for (Faculty ex in examiner!) {
      if (code == "-") {
        code = ex.code!;
      } else {
        code = code + " - " + ex.code!;
      }
    }
    return code;
  }

  String getSupervisorCode() {
    String code = "-";
    for (Faculty ex in examiner!) {
      if (code == "-") {
        code = ex.code!;
      } else {
        code = code + " - " + ex.code!;
      }
    }
    return code;
  }

  String getShareableScheduleLink() {
    String result =
        "${event?.eventName}\nDate: ${event?.getDateInFormat(date: event?.eventDate, format: "dd MMM yyyy")}\nTime: ${session?.time} WIB\nMeeting ID: ${space?.space}\nPasscode: ${space?.passcode}\nLink: ${space?.link}";
    return result;
  }
}

class Space {
  int id = -1;
  String? description;
  String? space;
  String? passcode;
  String? hostKey;
  String? link;

  Space.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'] ?? "";
    space = json['space'] ?? "";
    passcode = json['passcode'] ?? "";
    hostKey = json['host_key'] ?? "";
    link = json['link'] ?? "";
  }

  Space.nullFromJson() {
    description = "-";
    space = "-";
    passcode = "-";
    hostKey = "-";
    link = "-";
  }
}

class Session {
  int id = -1;
  String? time;
  String? type;

  Session.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    time = json['time'] ?? "";
    type = json['type'] ?? "";
  }

  Session.nullFromJson() {
    time = "-";
    type = "";
  }
}

//    "applicant": [
//     {
//         "id": 1743,
//         "room_id": null,
//         "research_id": 1517,
//         "event_id": 259,
//         "event_type": null,
//         "session_id": 1,
//         "space_id": 19,
//         "hold": null,
//         "status": null,
//         "mark_id": null,
//         "created_at": "2022-06-21T18:40:17.000000Z",
//         "updated_at": "2022-06-22T16:58:42.000000Z",
//         "space": {
//             "id": 19,
//             "description": "ARJMeeting",
//             "space": "850 1194 4847",
//             "passcode": "ARJSidang",
//             "host_key": null,
//             "link": "https://us06web.zoom.us/j/85011944847?pwd=UkRTbFNNNnBYWEUvaXBMbjRJWHBmQT09",
//             "created_at": "2022-01-26T03:42:28.000000Z",
//             "updated_at": null
//         },
//         "session": {
//             "id": 1,
//             "time": "07:00-08:00",
//             "type": "defense",
//             "created_at": "2021-04-26T10:14:08.000000Z",
//             "updated_at": "2021-04-05T00:11:19.000000Z"
//         },
//         "examiner": [
//             {
//                 "id": 2334,
//                 "event_id": 259,
//                 "applicant_id": 1743,
//                 "examiner_id": 13,
//                 "addition": null,
//                 "created_at": "2022-06-22T16:57:58.000000Z",
//                 "updated_at": "2022-06-22T16:57:58.000000Z",
//                 "faculty": {
//                     "id": 13,
//                     "code": "ARJ"
//                 }
//             },
//             {
//                 "id": 2335,
//                 "event_id": 259,
//                 "applicant_id": 1743,
//                 "examiner_id": 4,
//                 "addition": null,
//                 "created_at": "2022-06-22T16:59:03.000000Z",
//                 "updated_at": "2022-06-22T16:59:03.000000Z",
//                 "faculty": {
//                     "id": 4,
//                     "code": "INK"
//                 }
//             }
//         ]
//     }
// ]