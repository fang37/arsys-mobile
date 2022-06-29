import 'package:arsys/faculty/views/home.dart';
import 'package:arsys/login/view/login_view.dart';
import 'package:arsys/student/views/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../authentication/authentication_manager.dart';

class OnBoard extends StatelessWidget {
  const OnBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthenticationManager _authManager = Get.find();

    return Obx(() {
      return _authManager.isLogged.value
          ? _homePageView(_authManager.activeRole)
          : LoginView();
    });
  }

  _homePageView(role) {
    print("THIS IS ROLE : $role");
    if (role == "student") {
      return StudentHome();
    } else {
      return FacultyHome();
    }
    ;
  }
}
