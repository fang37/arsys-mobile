import 'dart:convert';
import 'package:arsys/authentication/cache_manager.dart';
import 'package:arsys/network/network_manager.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Network extends GetConnect {
  //if you are using android studio emulator, change localhost to 10.0.2.2

  final url = "http://192.168.1.7:80/api";

  String arsysUrl(String endpoint) {
    return '$url/arsys/$endpoint';
  }

  String timetableUrl(String endpoint) {
    return '$url/timetable/$endpoint';
  }

  var token;

  // authData(data, apiUrl) async {
  //   var fullUrl = url + apiUrl;
  //   try {
  //     return await http.post(Uri.parse(fullUrl),
  //         body: jsonEncode(data), headers: _setHeaders());
  //   } catch (e) {
  //     print(e);
  //     print("authData error");
  //     return false;
  //   }
  // }

  submitSiasProPre(int? researchId) async {
    if (researchId != null) {
      var data = {'research_id': researchId};
      await _getToken();
      var fullUrl = arsysUrl("research-sias-pro");
      try {
        return post(fullUrl, jsonEncode(data), headers: _setHeaders());
        // return await http.post(Uri.parse(fullUrl),
        //     body: jsonEncode(data), headers: _setHeaders());
      } catch (e) {
        print(e);
        return false;
      }
    } else {
      return false;
    }
  }

  proposeDefense(int? researchId) async {
    if (researchId != null) {
      var data = {'research_id': researchId};
      await _getToken();
      var fullUrl = arsysUrl("research-propose");
      try {
        return post(fullUrl, jsonEncode(data), headers: _setHeaders());
        // return await http.post(Uri.parse(fullUrl),
        //     body: jsonEncode(data), headers: _setHeaders());
      } catch (e) {
        print(e);
        return false;
      }
    } else {
      return false;
    }
  }

  applyEvent(int? researchId, int? eventId) async {
    if (researchId != null) {
      var data = {'research_id': researchId, 'event_id': eventId};
      await _getToken();
      var fullUrl = arsysUrl("event");
      try {
        return post(fullUrl, jsonEncode(data), headers: _setHeaders());
        // return await http.post(Uri.parse(fullUrl),
        //     body: jsonEncode(data), headers: _setHeaders());
      } catch (e) {
        print(e);
        return false;
      }
    } else {
      return false;
    }
  }

  requestTurnitinInvitation(int? researchId) async {
    if (researchId != null) {
      var data = {'research_id': researchId};
      await _getToken();
      var fullUrl = arsysUrl("research-turnitin-invitation");
      try {
        return post(fullUrl, jsonEncode(data), headers: _setHeaders());
        // return await http.post(Uri.parse(fullUrl),
        //     body: jsonEncode(data), headers: _setHeaders());
      } catch (e) {
        print(e);
        return false;
      }
    } else {
      return false;
    }
  }

  submitDefenseReport(int? researchId, int? applicantId, String? defenseResume,
      String? defenseDate) async {
    if (researchId != null &&
        applicantId != null &&
        defenseResume != null &&
        defenseDate != null) {
      var data = {
        'research_id': researchId,
        'applicant_id': applicantId,
        'defense_resume': defenseResume,
        'defense_date': defenseDate
      };
      await _getToken();
      var fullUrl = arsysUrl("research-defense-report");
      try {
        return post(fullUrl, jsonEncode(data), headers: _setHeaders());
        // return await http.post(Uri.parse(fullUrl),
        //     body: jsonEncode(data), headers: _setHeaders());
      } catch (e) {
        print(e);
        return false;
      }
    } else {
      return false;
    }
  }

  createFcmToken(data) async {
    await _getToken();
    var fullUrl = arsysUrl("fcm-create");
    try {
      return post(fullUrl, jsonEncode(data), headers: _setHeaders());
      // return await http.post(Uri.parse(fullUrl),
      //     body: jsonEncode(data), headers: _setHeaders());
    } catch (e) {
      print(e);
      return false;
    }
  }

  removeFcmToken(data) async {
    await _getToken();
    var fullUrl = arsysUrl("fcm-remove");
    try {
      return post(fullUrl, jsonEncode(data), headers: _setHeaders());
      // return await http.post(Uri.parse(fullUrl),
      //     body: jsonEncode(data), headers: _setHeaders());
    } catch (e) {
      print(e);
      return false;
    }
  }

  checkAuth() async {
    try {
      return await http.post(Uri.parse(arsysUrl("")), headers: _setHeaders());
    } catch (e) {
      print(e);
      return false;
    }
  }

  getArsysData(String endpoint) async {
    await _getToken();
    var fullUrl = arsysUrl(endpoint);
    return get(fullUrl, headers: _setHeaders());
  }

  // EVENT
  Future<Response> getEvent() async {
    await _getToken();
    print("GET EVENT");

    return get(arsysUrl("event"), headers: _setHeaders());
  }

  Future<Response> getEvents() async {
    await _getToken();
    return get(arsysUrl("events"), headers: _setHeaders());
  }

  // APPLICABLE EVENT BY RESEARCH ID
  Future<Response> getApplicableEventById(int id) async {
    await _getToken();
    print("GET APPLICABLE EVENT");
    return get(arsysUrl("event-applicable/$id"), headers: _setHeaders());
  }

  // EVENT EVENT BY RESEARCH ID
  Future<Response> getEventApplicantById(int id) async {
    await _getToken();
    print("GET APPLICABLE EVENT");
    return get(arsysUrl("event-applicant/$id"), headers: _setHeaders());
  }

  // RESEARCH
  Future<Response> getResearch() async {
    await _getToken();
    print("GET RESEARCH");
    print(token);
    return get(arsysUrl("research"), headers: _setHeaders());
  }

  // RESEARCH BY ID
  Future<Response> getResearchById(int id) async {
    await _getToken();
    print("GET RESEARCH");
    print(token);
    return get(arsysUrl("research/$id"), headers: _setHeaders());
  }

  // TIMETABLE
  Future<Response> getLecture() async {
    await _getToken();
    print("GET LECTURE");
    return get(timetableUrl("lecture"), headers: _setHeaders());
  }

  Future<Response> getLectures() async {
    await _getToken();
    return get(timetableUrl("lectures"), headers: _setHeaders());
  }

  // PROFILE
  Future<Response> getProfile() async {
    await _getToken();
    print("GET PROFILE");
    return get(arsysUrl("profile"), headers: _setHeaders());
  }

  _getToken() {
    final box = GetStorage();
    token = box.read(CacheManagerKey.TOKEN.toString());
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
}
