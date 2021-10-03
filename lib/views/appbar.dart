import 'dart:convert';
import 'dart:io';
import 'package:arsys/controllers/auth_controller.dart';
import 'package:arsys/controllers/event_controller.dart';
import 'package:arsys/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:arsys/views/user/login.dart';
import 'package:arsys/network/api.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

final profileC = Get.find<ProfileController>();
final authC = Get.find<AuthController>();

AppBar AppBarBuilder() {
  return AppBar(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
    toolbarHeight: 80,
    backgroundColor: Colors.lightBlue,
    automaticallyImplyLeading: false,
    title: Row(
      children: [
        Container(
          height: 40,
          width: 40,
          margin: EdgeInsets.only(right: 10),
          child: Icon(
            Icons.account_circle_rounded,
            size: 30,
          ),
          // decoration: BoxDecoration(
          //     shape: BoxShape.circle,
          //     image: DecorationImage(
          //         image: AssetImage("assets/pas.jpg"),
          //         fit: BoxFit.fitHeight))
        ),
        FutureBuilder(
          future: profileC.profileUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData)
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profileC.profile.name ?? "",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Helvetica',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(profileC.profile.role ?? "",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.blue[100],
                        fontFamily: 'Helvetica',
                      ))
                ],
              );
            return Text("");
          },
        ),
      ],
    ),
    actions: [
      IconButton(
        icon: Icon(Icons.power_settings_new),
        onPressed: () {
          Get.defaultDialog(
              title: 'Confirmation',
              content: Text('are you sure want to sign out?'),
              textCancel: 'Cancel',
              textConfirm: 'Yes',
              confirmTextColor: Colors.white,
              onConfirm: () {
                authC.logout();
                Get.back();
              });

          // logout();
        },
      )
    ],
  );
}

// void logout() async {
//   var res = await Network().getData('/logout');
//   var body;
//   try {
//     body = json.decode(res.body);
//     if (body['success']) {
//       SharedPreferences localStorage = await SharedPreferences.getInstance();
//       authC.isAuth.value = false;
//       localStorage.remove('user');
//       // localStorage.remove('token');
//       localStorage.remove('roles');
//     }
//   } catch (e) {
//     print(e);
//   }
// }
