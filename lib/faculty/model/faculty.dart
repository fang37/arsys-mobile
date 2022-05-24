class Faculty {
  int? id;
  String? firstName;
  String? lastName;
  String? frontTitle;
  String? rearTitle;
  String? code;
  String? nip;
  String? oldNip;
  String role = "faculty";
  int? specializationId;
  String? specialization;
  String? phone;
  String? email;

  Faculty({
    this.id,
    this.firstName,
    this.lastName,
    this.frontTitle,
    this.rearTitle,
    this.code,
    this.nip,
    this.oldNip,
    this.specializationId,
    this.specialization,
    this.phone,
    this.email,
  });

  Faculty.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'] ?? "";
    lastName = json['last_name'] ?? "";
    frontTitle = json['front_title'] ?? "";
    rearTitle = json['rear_title'] ?? "";
    code = json['code'] ?? "";
    nip = json['nip'] ?? "";
    oldNip = json['old_nip'] ?? "";
    specializationId = json['specialization_id'] ?? 99;
    specialization = _specializationName[specializationId];
    phone = json['phone'] ?? "";
    email = json['email'] ?? "";
  }
}

var _specializationName = {
  1: 'Elektronika Industri',
  2: 'Tenaga Elektrik',
  3: 'Telekomunikasi',
  4: 'PTOIR',
  99: '-'
};
