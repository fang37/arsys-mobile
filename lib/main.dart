import 'package:arsys/authentication/authentication_manager.dart';

import 'package:arsys/login/view/login_view.dart';
import 'package:arsys/student/controllers/event_controller.dart';
import 'package:arsys/firebase/fcm_controller.dart';
import 'package:arsys/student/controllers/lecture_controller.dart';
import 'package:arsys/student/controllers/student_controller.dart';
import 'package:arsys/student/controllers/research_controller.dart';
import 'package:arsys/student/views/all_lecture.dart';
import 'package:arsys/student/views/event.dart';
import 'package:arsys/student/views/home.dart';
import 'package:arsys/student/views/lecture.dart';
import 'package:arsys/student/views/profile.dart';
import 'package:arsys/student/views/reseach.dart';
import 'package:arsys/student/views/research_detail.dart';
import 'package:arsys/views/appbar.dart';
import 'package:arsys/views/faculty/home.dart';
import 'package:arsys/views/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:arsys/login/view/login';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.

  print("Handling a background message: ${message.messageId}");
  print("Handling a background message: ${message.notification!.title}");
}

void main() async {
  await GetStorage.init();
  print('Get Storage Finish Initiate');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await requestPermission();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // final authC = Get.put(AuthController());

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final fcmC = Get.put(FCMController());
    final eventC = Get.put(EventController());
    final profileC = Get.put(StudentController());
    final researchC = Get.put(ResearchController());
    final lectureC = Get.put(LectureController());
    // final fcmC = Get.put(FCMController());

    // authC.checkIfLoggedIn();
    // print(authC.isAuth);

    return GetMaterialApp(
      // initialRoute: '/',
      title: 'ArSys Mobile',
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
        GetPage(
            name: '/student-lecture',
            page: () => Lecture(),
            transition: Transition.noTransition,
            transitionDuration: Duration.zero),
        GetPage(
            name: '/student-lectures',
            page: () => AllLecture(),
            transition: Transition.noTransition,
            transitionDuration: Duration.zero),
        GetPage(
            name: '/student-profile',
            page: () => StudentProfile(),
            transition: Transition.noTransition,
            transitionDuration: Duration.zero),
        GetPage(name: '/login', page: () => LoginView()),
      ],
      home: SplashView(),
    );
  }
}

Future<void> requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
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
