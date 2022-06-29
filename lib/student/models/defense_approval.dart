import 'package:arsys/faculty/models/faculty.dart';
import 'package:arsys/student/models/defense_model.dart';

class DefenseApproval {
  int? id;
  int? researchId;
  int? approverId;
  int? approverRoleId;
  bool? decision;
  String? approvalDate;

  Faculty? approver;
  ApproverRole? approverRole;
  DefenseModel? defenseModel;

  DefenseApproval.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    researchId = json['research_id'];
    approverId = json['approver_id'];
    approver = Faculty.fromJson(json['faculty']);
    approverRoleId = json['approver_role'];
    approverRole = ApproverRole.fromId(json['approver_role']);
    decision = json['decision'] == 1 ? true : false;
    approvalDate = json['approval_date'] ?? "";
    defenseModel = DefenseModel.fromJson(json['defense_model']);
  }
}

class ApproverRole {
  int? id;
  String? code;
  String? description;

  ApproverRole.fromId(int approverRoleId) {
    id = approverRoleId;
    code = getCode(approverRoleId);
    description = getDesc(approverRoleId);
  }

  String getCode(int id) {
    switch (id) {
      case 1:
        {
          return "SPV";
        }
      case 2:
        {
          return "EXM";
        }
      case 3:
        {
          return "PRG";
        }
      default:
        return "-";
    }
  }

  String getDesc(int id) {
    switch (id) {
      case 1:
        {
          return "Supervisor";
        }
      case 2:
        {
          return "Examiner";
        }
      case 3:
        {
          return "Head of Program Study";
        }
      default:
        return "-";
    }
  }
}

// RESPONSE SAMPLE

// "defense_approval": [
//                 {
//                     "id": 201,
//                     "research_id": 555,
//                     "defense_model": {
//                         "id": 1,
//                         "code": "PRE",
//                         "description": "Pre defense",
//                         "created_at": "2021-03-26T00:48:21.000000Z",
//                         "updated_at": "2021-03-26T00:48:24.000000Z"
//                     },
//                     "approver_id": 15,
//                     "approver_role": 1,
//                     "decision": 1,
//                     "approval_date": "2021-07-19 03:58:07",
//                     "created_at": "2021-07-19T10:58:07.000000Z",
//                     "updated_at": "2021-07-19T10:58:07.000000Z",
//                     "faculty": {
//                         "id": 15,
//                         "user_id": 185,
//                         "sso_username": "197208262005011001",
//                         "code": "AHS",
//                         "upi_code": "2410",
//                         "nip": "197208262005011001",
//                         "old_nip": null,
//                         "front_title": null,
//                         "rear_title": "MT.",
//                         "first_name": "Agus Heri Setya",
//                         "last_name": "Budi",
//                         "duty_id": null,
//                         "specialization_id": 3,
//                         "program_id": null,
//                         "phone": null,
//                         "email": null,
//                         "created_at": "2021-03-22T09:34:26.000000Z",
//                         "updated_at": "2021-10-16T13:44:31.000000Z"
//                     }
//                 },
//                 {
//                     "id": 552,
//                     "research_id": 555,
//                     "defense_model": {
//                         "id": 2,
//                         "code": "PUB",
//                         "description": "Final defense",
//                         "created_at": "2021-03-26T00:48:28.000000Z",
//                         "updated_at": "2021-03-26T00:48:30.000000Z"
//                     },
//                     "approver_id": 4,
//                     "approver_role": 3,
//                     "decision": 1,
//                     "approval_date": "2021-08-12 08:04:15",
//                     "created_at": "2021-08-12T15:04:15.000000Z",
//                     "updated_at": "2021-08-12T15:04:15.000000Z",
//                     "faculty": {
//                         "id": 4,
//                         "user_id": 146,
//                         "sso_username": "132306520",
//                         "code": "INK",
//                         "upi_code": "2338",
//                         "nip": "197709082003121002",
//                         "old_nip": null,
//                         "front_title": null,
//                         "rear_title": "Ph.D",
//                         "first_name": "Iwan",
//                         "last_name": "Kustiawan",
//                         "duty_id": null,
//                         "specialization_id": 3,
//                         "program_id": 2,
//                         "phone": null,
//                         "email": null,
//                         "created_at": "2021-03-22T09:34:26.000000Z",
//                         "updated_at": "2021-10-16T13:44:00.000000Z"
//                     }
//                 }
// ]

// Approver Role Sample
// 1
// code: SPV
// description: Supervisor

// 2
// code: EXM
// description: Examiner

// 3
// code: PRG
// descriptipn: Head of Program Study