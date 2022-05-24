import 'package:arsys/faculty/model/faculty.dart';

class Student {
  int? id;
  String? firstName;
  String? lastName;
  String role = "student";
  String? studentNumber;
  int? specializationId;
  String? specialization;
  String? gpa;
  String? status;
  String? phone;
  String? email;
  Faculty? supervisor;

  Student({
    this.id,
    this.firstName,
    this.lastName,
    this.studentNumber,
    this.specializationId,
    this.specialization,
    this.gpa,
    this.status,
    this.phone,
    this.email,
  });

  Student.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'] ?? "";
    lastName = json['last_name'] ?? "";
    studentNumber = json['student_number'] ?? "";
    specializationId = json['specialization_id'] ?? 99;
    specialization = _specializationName[specializationId];
    gpa = json['gpa'] ?? "";
    status = json['status'] ?? "";
    phone = json['phone'] ?? "";
    email = json['email'] ?? "";
    print(json['supervisor']);
    supervisor = Faculty.fromJson(json['supervisor']);
  }
}

final _roleList = {
  1: 'Admin',
  2: 'Student',
  3: 'Faculty',
  4: 'Specialization',
  5: 'Head of Program Study',
  6: 'Coordinator',
  7: 'Tenaga Kependidikan'
};

var _specializationName = {
  1: 'Elektronika Industri',
  2: 'Tenaga Elektrik',
  3: 'Telekomunikasi',
  4: 'PTOIR',
  99: '-'
};
