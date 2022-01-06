import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Network extends GetConnect {
  //if you are using android studio emulator, change localhost to 10.0.2.2
  var token;

  _getToken() async {
    try {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      token = jsonDecode(localStorage.getString('token')!)['token'];
    } catch (e) {
      print(e);
    }
  }

  final url = "http://192.168.1.6:80/api/arsys/";

  authData(data, apiUrl) async {
    var fullUrl = url + apiUrl;
    try {
      return await http.post(Uri.parse(fullUrl),
          body: jsonEncode(data), headers: _setHeaders());
    } catch (e) {
      print(e);
      print("error");
      return false;
    }
  }

  createFcmToken(data) async {
    await _getToken();
    var fullUrl = url + "fcm-create";
    try {
      return await http.post(Uri.parse(fullUrl),
          body: jsonEncode(data), headers: _setHeaders());
    } catch (e) {
      print(e);
      print("error");
      return false;
    }
  }

  removeFcmToken(data) async {
    await _getToken();
    var fullUrl = url + "fcm-remove";
    try {
      return await http.post(Uri.parse(fullUrl),
          body: jsonEncode(data), headers: _setHeaders());
    } catch (e) {
      print(e);
      print("error");
      return false;
    }
  }

  checkAuth() async {
    var fullUrl = url;
    try {
      return await http.post(Uri.parse(fullUrl), headers: _setHeaders());
    } catch (e) {
      print(e);
      return false;
    }
  }

  getData(apiUrl) async {
    var fullUrl = url + apiUrl;
    await _getToken();
    try {
      return await http.get(Uri.parse(fullUrl), headers: _setHeaders());
    } catch (e) {
      print(e);
      return false;
    }
  }

  // EVENT
  Future<Response> getEvent() async {
    await _getToken();
    print("EVENT PROV");

    return get(url + "event", headers: _setHeaders());
  }

  Future<Response> getEvents() async {
    await _getToken();
    return get(url + "events", headers: _setHeaders());
  }

  // RESEARCH
  Future<Response> getResearch() async {
    await _getToken();
    print("RESEARCH PROV");
    return get(url + "research", headers: _setHeaders());
  }

  // TIMETABLE
  Future<Response> getLecture() async {
    await _getToken();
    print("LECTURE PROV");
    return get("http://192.168.1.6:80/api/timetable/lecture",
        headers: _setHeaders());
  }

  Future<Response> getLectures() async {
    await _getToken();
    return get("http://192.168.1.6:80/api/timetable/lectures",
        headers: _setHeaders());
  }

  // PROFILE
  Future<Response> getProfile() async {
    await _getToken();
    print("PROFILE PROV");
    return get(url + "profile", headers: _setHeaders());
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
}
