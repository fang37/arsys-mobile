import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../authentication/authentication_manager.dart';
import '../model/login_request_model.dart';
import '../service/login_service.dart';

class LoginViewModel extends GetxController {
  late final LoginService _loginService;
  late final AuthenticationManager _authManager;

  @override
  void onInit() {
    super.onInit();
    _loginService = Get.put(LoginService());
    _authManager = Get.find();
  }

  Future<void> loginUser(String email, String password) async {
    final response = await _loginService
        .fetchLogin(LoginRequestModel(email: email, password: password));

    if (response != null) {
      if (response.statusCode == HttpStatus.ok) {
        /// Set isLogin to true
        _authManager.login(response.token, response.role);
      } else if (response.statusCode == HttpStatus.unauthorized) {
        // Show user a dialog about the error response
        Get.snackbar("Login Failed", response.message!,
            backgroundColor: Colors.white, icon: Icon(Icons.warning_rounded));
      }
    } else {
      Get.snackbar("Login Failed", "server not responding",
          backgroundColor: Colors.white, icon: Icon(Icons.warning_rounded));
    }
  }
}
