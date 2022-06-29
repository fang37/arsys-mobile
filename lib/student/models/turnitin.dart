class Turnitin {
  int? id;
  bool approval = false;
  int? score;
  String? approvalDate;

  Turnitin.nullJson({
    this.id = -1,
    this.approval = false,
    this.score = 100,
    this.approvalDate = "",
  });

  Turnitin.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? -1;
    approval = json['approval'] == 1 ? true : false;
    score = json['score'] ?? 100;
    approvalDate = json['approval_date'] ?? "";
  }

  bool isApprove() {
    return approval;
  }
}


// "turnitin_pre_pre": {
//                 "id": 3,
//                 "research_id": 1517,
//                 "event_type": 1,
//                 "approval": null,
//                 "score": null,
//                 "approval_date": null,
//                 "created_at": "2022-05-29T11:58:37.000000Z",
//                 "updated_at": "2022-05-29T11:58:37.000000Z"
//             },