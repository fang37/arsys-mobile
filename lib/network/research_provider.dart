import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResearchProvider extends GetConnect {
  var token;
  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = jsonDecode(localStorage.getString('token')!)['token'];
  }

  final url = "http://192.168.1.5:80/api/arsys/";
  // GET REQUEST
  Future<Response> getResearch() async {
    await _getToken();
    return get(url + "research", headers: setHeaders());
  }

  setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
}
