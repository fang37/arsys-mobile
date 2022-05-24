class Research {
  int? id;
  int? research_type;
  String? research_name; // dict
  String? research_code;
  String? title;
  String? abstract;
  int? research_milestone;
  int? status;
  String? approval_date;
  String? research_id;

  var supervisor;
  var supervise;
  var milestone;
  var defense_approval;

  Research({
    this.id,
    this.research_type,
    this.research_name,
    this.research_code,
    this.title,
    this.abstract,
    this.research_milestone,
    this.status,
    this.approval_date,
    this.research_id,
    this.supervisor,
    this.supervise,
    this.milestone,
    this.defense_approval,
  });
}
