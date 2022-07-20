import 'package:arsys/faculty/models/faculty.dart';
import 'package:arsys/models/role.dart';
import 'package:arsys/models/user.dart';

class Student extends User {
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
    id,
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
    userRole = Role.student.value;
    id = json['id'] ?? -1;
    firstName = json['first_name'] ?? "";
    lastName = json['last_name'] ?? "";
    studentNumber = json['student_number'] ?? "";
    specializationId = json['specialization_id'] ?? 99;
    specialization = _specializationName[specializationId];
    gpa = json['gpa'] ?? "";
    status = json['status'] ?? "";
    phone = json['phone'] ?? "";
    email = json['email'] ?? "";

    if (json['supervisor'] != null) {
      supervisor = Faculty.fromJson(json['supervisor']);
    }
  }

  String getFullName() {
    return "$firstName $lastName";
  }

  @override
  String getProfileName() {
    return getFullName();
  }

  @override
  String getRoleName() {
    return role.toUpperCase();
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
