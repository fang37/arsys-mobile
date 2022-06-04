class DefenseModel {
  int? id;
  String? code;
  String? description;

  DefenseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    description = json['description'];
  }
}



//  "defense_model": {
//                         "id": 1,
//                         "code": "PRE",
//                         "description": "Pre defense",
//                         "created_at": "2021-03-26T00:48:21.000000Z",
//                         "updated_at": "2021-03-26T00:48:24.000000Z"
//                     },