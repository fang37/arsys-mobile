import 'package:arsys/controllers/auth_controller.dart';
import 'package:arsys/controllers/event_controller.dart';
import 'package:arsys/controllers/user_controller.dart';
import 'package:arsys/views/student/event.dart';
import 'package:arsys/views/student/reseach.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:arsys/views/faculty/home.dart';
import 'package:arsys/views/student/home.dart';
import 'package:arsys/views/user/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final authC = Get.put(AuthController());
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final eventC = Get.put(EventController());
    final userC = Get.put(UserController());

    return GetMaterialApp(
      title: 'Test App',
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(
            name: '/faculty-home',
            page: () => FacultyHome(),
            transition: Transition.noTransition,
            transitionDuration: Duration.zero),
        GetPage(
            name: '/student-home',
            page: () => StudentHome(),
            transition: Transition.noTransition,
            transitionDuration: Duration.zero),
        GetPage(
            name: '/student-research',
            page: () => StudentResearch(),
            transition: Transition.noTransition,
            transitionDuration: Duration.zero),
        GetPage(
            name: '/student-event',
            page: () => StudentEvent(),
            transition: Transition.noTransition,
            transitionDuration: Duration.zero),
        GetPage(name: '/login', page: () => Login()),
      ],
      home: CheckAuth(),
    );
  }
}

class CheckAuth extends StatelessWidget {
  final authC = Get.find<AuthController>();
  @override
  @override
  Widget build(BuildContext context) {
    // Widget child;
    if (authC.isAuth.value) {
      return GetBuilder<AuthController>(
          builder: (c) => Scaffold(
                body: StudentHome(),
              ));
      // Get.toNamed('/home');
    } else {
      return GetBuilder<AuthController>(
          initState: (_) => authC.checkIfLoggedIn(),
          builder: (c) => Scaffold(
                body: Login(),
              ));

      // @override
      // Widget build(BuildContext context) {
      //   Widget child;
      //   if (isAuth) {
      //     child = Home();
      //   } else {
      //     child = Login();
      //   }
      //   return Scaffold(
      //     body: child,
      //   );
      // }
    }
  }
}
