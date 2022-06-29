import 'package:intl/intl.dart';

class Event {
  int? id;
  String? eventId;
  String? eventName;
  String? eventCode;
  int? eventType;
  String? applicationDeadline;
  String? eventDate;
  String? draftDeadline;
  int? quota;
  int? current;
  String? creator;
  int? status;

  Event({
    this.id,
    this.eventId,
    this.eventName,
    this.eventCode,
    this.eventType,
    this.applicationDeadline,
    this.eventDate,
    this.draftDeadline,
    this.quota,
    this.current,
    this.creator,
    this.status,
  });

  Event.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eventId = json['event_id'];
    eventCode = json['event_code'] ?? "-";
    eventType = json['event_type'];
    eventName = getEventName(json['event_type']);
    applicationDeadline = dateFormatter(json['application_deadline']);
    eventDate = dateFormatter(json['event_date']);
    draftDeadline = dateFormatter(json['draft_deadline']);
    quota = json['quota'] ?? -1;
    current = json['current'] ?? -1;
    creator = json['creator'] ?? "";
    status = json['status'] ?? -1;
  }

  String getEventName(type) {
    switch (type) {
      case 1:
        return 'Pre-defense';
      case 2:
        return 'Final-defense';
      case 3:
        return 'EE-Seminar';
      case 4:
        return 'Industrial Practic';
      case 5:
        return 'Proposal';
      default:
        return '';
    }
  }

  String dateFormatter(date) {
    if (date != null && date != "") {
      var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
      var inputDate = inputFormat.parse(date!);

      var outputFormat = DateFormat('dd-MM-yyyy HH:mm');
      var outputDate = outputFormat.format(inputDate);
      return outputDate.toString();
    } else {
      return "";
    }
  }

  String getDateInFormat({var date, String format = "dd MMM yyyy, HH.mm"}) {
    if (date != null && date != "") {
      var inputFormat = DateFormat('dd-MM-yyyy HH:mm');
      var inputDate = inputFormat.parse(date!);

      var outputFormat = DateFormat(format);
      var outputDate = outputFormat.format(inputDate);
      return outputDate.toString();
    } else {
      return "";
    }
  }

  String getSeats() {
    if (quota! >= 0) {
      if (current! >= 0) {
        return "${current!}/${quota!}";
      } else {
        return "?/${quota!}";
      }
    } else {
      return "?";
    }
  }

  double getSeatsPercent() {
    if (current! >= 0 && quota! >= 0) {
      return current! / quota!;
    } else {
      return 0;
    }
  }

  getExaminerCode() {}
}
// EVENT RESPONSE SAMPLE

// "event": [
//         {
//             "id": 257,
//             "event_id": "PRE-05012022",
//             "event_code": null,
//             "event_type": 1,
//             "application_deadline": "2021-12-31 17:00:00",
//             "event_date": "2022-01-05 07:00:00",
//             "draft_deadline": "2021-12-31 17:00:00",
//             "quota": 9,
//             "current": null,
//             "creator": null,
//             "status": 1,
//             "created_at": "2022-01-03T09:18:47.000000Z",
//             "updated_at": "2022-01-03T09:18:47.000000Z"
//         },
//         {
//             "id": 256,
//             "event_id": "PRE-06012022",
//             "event_code": null,
//             "event_type": 1,
//             "application_deadline": "2022-01-02 17:00:00",
//             "event_date": "2022-01-06 07:00:00",
//             "draft_deadline": "2022-01-02 17:00:00",
//             "quota": 9,
//             "current": null,
//             "creator": null,
//             "status": null,
//             "created_at": "2022-01-03T09:18:47.000000Z",
//             "updated_at": "2022-01-03T09:18:47.000000Z"
//         },
// ]
