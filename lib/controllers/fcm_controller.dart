import 'dart:convert';

import 'package:arsys/network/api.dart';
import 'package:arsys/views/faculty/home.dart';
import 'package:arsys/views/student/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FCMController extends GetxController {
  final box = GetStorage();
  var isAuth = false.obs;

  var homePage;

  @override
  void onInit() async {
    super.onInit();
  }

  void receiveNotification() async {
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    // await requestPermission();

    // On notif cliked in terminated
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print(message.data);
        print(message.notification!.title);
      }
    });

    // On notif clicked in background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {});

    // On foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print(
            'Message also contained a notification: ${message.notification!.title}');
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  void sendToken() async {
    String? fcm_token = await FirebaseMessaging.instance.getToken();
    // Get.defaultDialog(title: "");
    var data = {'fcm_token': fcm_token};

    var res = await Network().createFcmToken(data);
    if (res != false) {
      try {
        var body = json.decode(res.body);
        if (body['success']) {
          print("FCM TOKEN SAVED");
        } else if (body['success'] == false) {
        } else {}
      } catch (e) {
        print(e);
      }
    }
  }

  Future removeToken() async {
    String? fcm_token = await FirebaseMessaging.instance.getToken();
    // Get.defaultDialog(title: "");
    var data = {'fcm_token': fcm_token};

    var res = await Network().removeFcmToken(data);
    if (res != false) {
      try {
        var body = json.decode(res.body);
        print(body['message']);
        if (body['success']) {
          await FirebaseMessaging.instance.deleteToken();
          print("FCM TOKEN REMOVED");
        } else if (body['success'] == false) {
        } else {}
      } catch (e) {
        print(e);
      }
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
}
