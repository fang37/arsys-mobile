import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LectureProvider extends GetConnect {
  var token;
  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = jsonDecode(localStorage.getString('token')!)['token'];
  }

  final url = "http://192.168.1.5:80/api/timetable/";
  // GET REQUEST
  Future<Response> getLecture() async {
    await _getToken();
    return get(url + "lecture", headers: setHeaders());
  }

  Future<Response> getLectures() async {
    await _getToken();
    return get(url + "lectures", headers: setHeaders());
  }

  setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
}
