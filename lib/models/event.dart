class Event {
  int id;
  String event_id;
  String event_name;
  String event_code = '-';
  int event_type;
  String application_deadline;
  String event_date;
  String draft_deadline;
  int quota;
  int current;
  String creator;
  int status;

  Event({
    this.id,
    this.event_id,
    this.event_name,
    this.event_code,
    this.event_type,
    this.application_deadline,
    this.event_date,
    this.draft_deadline,
    this.quota,
    this.current,
    this.creator,
    this.status,
  });
}
