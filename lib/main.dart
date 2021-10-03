import 'package:arsys/controllers/auth_controller.dart';
import 'package:arsys/controllers/event_controller.dart';
import 'package:arsys/controllers/research_controller.dart';
import 'package:arsys/controllers/profile_controller.dart';
import 'package:arsys/views/appbar.dart';
import 'package:arsys/views/student/event.dart';
import 'package:arsys/views/student/reseach.dart';
import 'package:arsys/views/student/research_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:arsys/views/faculty/home.dart';
import 'package:arsys/views/student/home.dart';
import 'package:arsys/views/user/login.dart';

void main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final authC = Get.put(AuthController());

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final eventC = Get.put(EventController());
    final profileC = Get.put(ProfileController());
    final researchC = Get.put(ResearchController());

    return Obx(() => GetMaterialApp(
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
                name: '/student-research-detail',
                page: () => StudentResearchDetail(),
                transition: Transition.noTransition,
                transitionDuration: Duration.zero),
            GetPage(
                name: '/student-event',
                page: () => StudentEvent(),
                transition: Transition.noTransition,
                transitionDuration: Duration.zero),
            GetPage(name: '/login', page: () => Login()),
          ],
          home: authC.isAuth.value ? authC.homePage : Login(),
        ));
  }
}

// FITUR REMEMBER ME


// class CheckAuth extends StatelessWidget {
//   final authC = Get.find<AuthController>();

//   @override
//   Widget build(BuildContext context) {
//     authC.checkIfLoggedIn();
//     Widget child;
//     if (authC.isAuth.value) {
//       print('isAtuh true');
//       // UPDATE STREAM OBSERVE
//       // return GetBuilder<AuthController>(
//       //     builder: (c) =>
//       return Scaffold(
//         body: StudentHome(),
//         // )
//       );
//       // Get.toNamed('/home');
//     } else {
//       // return GetBuilder<AuthController>(
//       // initState: (_) => authC.checkIfLoggedIn(),
//       // builder: (c) =>
//       return Scaffold(
//         body: Login(),
//         // )
//       );

      // @override
      // Widget build(BuildContext context) {
      //   Widget child;
      //   if (authC.isAuth.value) {
      //     child = Home();
      //   } else {
      //     child = Login();
      //   }
      //   return Scaffold(
      //     body: child,
      //   );
      // }

//     }
//   }
// }
