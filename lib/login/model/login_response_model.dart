import 'package:get/get_connect/http/src/status/http_status.dart';

class LoginResponseModel {
  int? statusCode;
  String? token;
  String? role;
  String? message;

  LoginResponseModel({this.statusCode, this.token, this.role, this.message});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    role = json['roles'];
    message = json['message'] ?? "success";
  }
}
