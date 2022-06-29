class Milestone {
  int? id;
  String? milestone;
  String? model;
  String? phase;
  int? sequence;
  int? status;
  String? description;
  String? message;

  bool proposeButton = false;

  Milestone.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    milestone = json['milestone'] ?? "";
    model = json['milestone_model'] ?? "";
    phase = json['phase'] ?? "";
    sequence = json['sequence'] ?? -1;
    status = json['status'] ?? -1;
    description = json['description'] ?? "";
    message = json['message'] ?? "";
    proposeButton = proposeButtonAssigner(json['propose_button']);
  }

  bool proposeButtonAssigner(var button) {
    if (button == null || button == "") {
      return false;
    } else {
      return true;
    }
  }
}

// "milestone": {
//                 "id": 5,
//                 "milestone": "Pre-defense",
//                 "milestone_model": "defense",
//                 "propose_button": null,
//                 "phase": "Submitted",
//                 "sequence": 5,
//                 "status": 1,
//                 "description": "Pre-defense approval has been requested ",
//                 "message": null,
//                 "created_at": "2020-09-16T17:59:25.000000Z",
//                 "updated_at": "2020-09-16T17:59:23.000000Z"
//             },