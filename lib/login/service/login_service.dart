import '../model/login_request_model.dart';
import '../model/login_response_model.dart';

import 'package:get/get_connect.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

/// LoginService responsible to communicate with web-server
/// via authenticaton related APIs
class LoginService extends GetConnect {
  final String loginUrl = 'http://192.168.1.7:80/api/arsys/login';
  // final String registerUrl = '';

  Future<LoginResponseModel?> fetchLogin(LoginRequestModel model) async {
    final response = await post(loginUrl, model.toJson());

    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.unauthorized) {
      LoginResponseModel loginResponModel =
          LoginResponseModel.fromJson(response.body);
      loginResponModel.statusCode = response.statusCode;
      return loginResponModel;
    } else {
      return null;
    }
  }

  // Future<RegisterResponseModel?> fetchRegister(
  //     RegisterRequestModel model) async {
  //   final response = await post(registerUrl, model.toJson());

  //   if (response.statusCode == HttpStatus.ok) {
  //     return RegisterResponseModel.fromJson(response.body);
  //   } else {
  //     return null;
  //   }
  // }
}
