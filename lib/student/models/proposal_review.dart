import 'package:arsys/faculty/models/faculty.dart';
import 'package:arsys/student/models/defense_approval.dart';
import 'package:arsys/student/models/milestone.dart';

class ProposalReview {
  int? id;
  int? researchId;
  int? reviewerId;
  int? decisionId;
  String? comment;
  String? approvalDate;
  String? decisionCode;
  String? decisionDescription;

  Faculty? reviewer;

  ProposalReview.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    researchId = json['research_id'];
    reviewerId = json['reviewer_id'] ?? -1;
    decisionId = json['decision_id'] ?? -1;
    comment = json['comment'] ?? "";
    approvalDate = json['approval_date'] ?? "";
    decisionCode = getDecisionCode(decisionId!);
    decisionDescription = getDecisionDescription(decisionId!);
    reviewer = Faculty.fromJson(json['faculty']);
  }

  String getDecisionCode(int type) {
    switch (type) {
      case 1:
        {
          return 'APP';
        }
      case 2:
        {
          return 'RJC';
        }
      case 3:
        {
          return 'RVS';
        }
      case 4:
        {
          return 'PRS';
        }
      case 5:
        {
          return 'RSVD';
        }
      default:
        {
          return '-';
        }
    }
  }

  String getDecisionDescription(int type) {
    switch (type) {
      case 1:
        {
          return 'Approve';
        }
      case 2:
        {
          return 'Reject';
        }
      case 3:
        {
          return 'Revise';
        }
      case 4:
        {
          return 'Presentation';
        }
      case 5:
        {
          return 'Revised';
        }
      default:
        {
          return 'No Decision';
        }
    }
  }
}

// Sample
// "proposal_review": [
//                 {
//                     "id": 783,
//                     "research_id": 1664,
//                     "reviewer_id": 26,
//                     "decision_id": 1,
//                     "comment": null,
//                     "approval_date": "2022-05-29 07:31:51",
//                     "created_at": "2022-05-29T14:31:51.000000Z",
//                     "updated_at": "2022-05-29T07:31:51.000000Z",
//                     "faculty": {
//                         "id": 26,
//                         "user_id": 2,
//                         "sso_username": "132314538",
//                         "code": "AIP",
//                         "upi_code": "2355",
//                         "nip": "197004162005011016",
//                         "old_nip": null,
//                         "front_title": "Dr.",
//                         "rear_title": "MT.",
//                         "first_name": "Aip",
//                         "last_name": "Saripudin",
//                         "duty_id": null,
//                         "specialization_id": 3,
//                         "program_id": null,
//                         "phone": null,
//                         "email": null,
//                         "created_at": "2021-03-22T09:34:26.000000Z",
//                         "updated_at": "2021-10-16T13:44:57.000000Z"
//                     }
//                 },
//                 {
//                     "id": 784,
//                     "research_id": 1664,
//                     "reviewer_id": 12,
//                     "decision_id": null,
//                     "comment": null,
//                     "approval_date": null,
//                     "created_at": "2022-05-29T07:30:02.000000Z",
//                     "updated_at": "2022-05-29T07:30:02.000000Z",
//                     "faculty": {
//                         "id": 12,
//                         "user_id": 203,
//                         "sso_username": "132299062",
//                         "code": "SSE",
//                         "upi_code": "2202",
//                         "nip": "197311222001122002",
//                         "old_nip": null,
//                         "front_title": "Dr.",
//                         "rear_title": "S.Pd. MT.",
//                         "first_name": "Siscka",
//                         "last_name": "Elvyanti",
//                         "duty_id": null,
//                         "specialization_id": 3,
//                         "program_id": null,
//                         "phone": null,
//                         "email": null,
//                         "created_at": "2021-03-22T09:34:26.000000Z",
//                         "updated_at": "2021-10-16T13:44:21.000000Z"
//                     }
//                 }
//             ],