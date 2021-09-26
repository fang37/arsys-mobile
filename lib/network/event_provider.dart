import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventProvider extends GetConnect {
  var token;
  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = jsonDecode(localStorage.getString('token'))['token'];
  }

  final url = "http://192.168.1.3:80/api/arsys/";
  // GET REQUEST
  Future<Response> getEvent() async {
    await _getToken();
    return get(url + "event", headers: setHeaders());
  }

  Future<Response> getEvents() async {
    await _getToken();
    return get(url + "events", headers: setHeaders());
  }

  setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
}
