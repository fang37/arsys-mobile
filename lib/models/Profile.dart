class Profile {
  String? name;
  int? id;
  int? role_id;
  String? role = "";
  String? student_number;
  int? specialization_id;
  String? specialization;
  String? first_name = "";
  String? last_name = "";
  var supervisor;
  String? gpa;
  String? status;
  String? phone;
  String? email;

  Profile({
    this.id,
    this.role_id,
    this.role,
    this.student_number,
    this.specialization_id,
    this.specialization,
    this.name,
    this.first_name,
    this.last_name,
    this.supervisor,
    this.gpa,
    this.status,
    this.phone,
    this.email,
  });
}
