class SeminarModerator {
  int id = -1;
  int moderatorId = -1;
  int roomId = -1;

  SeminarModerator.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? -1;
    moderatorId = json['moderator_id'] ?? -1;
    roomId = json['room_id'] ?? -1;
  }
}
