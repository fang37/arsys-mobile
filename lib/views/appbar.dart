import 'dart:convert';
import 'dart:io';
import 'package:arsys/authentication/authentication_manager.dart';
import 'package:arsys/faculty/controllers/faculty_controller.dart';
import 'package:arsys/student/controllers/event_controller.dart';
import 'package:arsys/student/controllers/student_controller.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:arsys/network/network.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

// final authC = Get.find<AuthController>();
AuthenticationManager _authManager = Get.find();
String activeRole = _authManager.activeRole;
final profileC = Get.find<FacultyController>();

PreferredSize HomeAppBarBuilder(context) {
  return PreferredSize(
    preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.25),
    child: AppBar(
      leading: IconButton(
        onPressed: () {},
        icon: Icon(Icons.menu_rounded),
        color: Colors.white,
      ),
      title: const Text("ArSys Mobile",
          style: TextStyle(
              fontSize: 18,
              fontFamily: "Helvetica",
              fontWeight: FontWeight.bold,
              color: Colors.white)),
      actions: [
        IconButton(
          icon: Icon(Icons.logout_rounded),
          color: Colors.white,
          onPressed: () {
            Get.defaultDialog(
                contentPadding: EdgeInsets.all(15),
                title: 'Confirmation',
                titleStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff3A4856)),
                titlePadding: EdgeInsets.only(top: 15),
                content: Text(
                  'Are you sure want to sign out?',
                  style: TextStyle(color: Color(0xff3A4856)),
                ),
                textCancel: 'Cancel',
                textConfirm: 'Yes',
                confirmTextColor: Colors.white,
                radius: 15,
                onConfirm: () {
                  _authManager.logout();
                  Get.back();
                });
          },
        ),
      ],
      flexibleSpace: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(50)),
            gradient: LinearGradient(
                colors: [Colors.lightBlueAccent, Color(0xFF0277E3)],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight)),
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 35, 20, 10),
          // color: Colors.lime,
          child: InkWell(
            onTap: () {
              if (activeRole == 'student') {
                Get.toNamed('/student-profile');
              } else if (activeRole == 'faculty' || activeRole == 'admin') {
                Get.toNamed('/faculty-profile');
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Icon(
                    Icons.account_circle_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                  // decoration: BoxDecoration(
                  //     shape: BoxShape.circle,
                  //     image: DecorationImage(
                  //         image: AssetImage("assets/pas.jpg"),
                  //         fit: BoxFit.fitHeight))
                ),
                FutureBuilder(
                  future: profileC.getProfile(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    } else if (snapshot.hasData) {
                      return Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                profileC.getFullName(),
                                style: TextStyle(
                                    fontSize: 24,
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(profileC.getRole(),
                                // TODO: Gabung profile jadi satu
                                style: TextStyle(
                                  height: 0.9,
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontFamily: 'OpenSans',
                                ))
                          ],
                        ),
                      );
                    }
                    return Text("");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(50))),
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      // actions: [
      // IconButton(
      //   icon: Icon(Icons.logout_rounded),
      //   onPressed: () {
      //     Get.defaultDialog(
      //         contentPadding: EdgeInsets.all(15),
      //         title: 'Confirmation',
      //         titleStyle: TextStyle(
      //             fontSize: 24,
      //             fontWeight: FontWeight.bold,
      //             color: Color(0xff3A4856)),
      //         titlePadding: EdgeInsets.only(top: 15),
      //         content: Text(
      //           'Are you sure want to sign out?',
      //           style: TextStyle(color: Color(0xff3A4856)),
      //         ),
      //         textCancel: 'Cancel',
      //         textConfirm: 'Yes',
      //         confirmTextColor: Colors.white,
      //         radius: 15,
      //         onConfirm: () {
      //           authC.logout();
      //           Get.back();
      //         });

      //     // logout();
      //   },
      // )
      // ],
    ),
  );
}

AppBar AppBarBuilder() {
  return AppBar(
    flexibleSpace: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.lightBlueAccent, Color(0xFF0277E3)],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight)),
    ),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(50))),
    toolbarHeight: 80,
    backgroundColor: Colors.transparent,
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
          future: profileC.getProfile(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      profileC.getFullName(),
                      style: TextStyle(
                        fontFamily: 'Helvetica',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(profileC.getRole(),
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.blue[100],
                        fontFamily: 'Helvetica',
                      ))
                ],
              );
            }
            return Text("");
          },
        ),
      ],
    ),
    actions: [
      IconButton(
        icon: Icon(Icons.logout_rounded),
        onPressed: () {
          Get.defaultDialog(
              contentPadding: EdgeInsets.all(15),
              title: 'Confirmation',
              titleStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff3A4856)),
              titlePadding: EdgeInsets.only(top: 15),
              content: Text(
                'Are you sure want to sign out?',
                style: TextStyle(color: Color(0xff3A4856)),
              ),
              textCancel: 'Cancel',
              textConfirm: 'Yes',
              confirmTextColor: Colors.white,
              radius: 15,
              onConfirm: () {
                _authManager.logout();
                Get.back();
              });

          // logout();
        },
      )
    ],
  );
}

AppBar SecondAppBarBuilder(String title) {
  return AppBar(
    flexibleSpace: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.lightBlueAccent, Color(0xFF0277E3)],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight)),
    ),
    toolbarHeight: 50,
    backgroundColor: Colors.transparent,
    automaticallyImplyLeading: false,
    title: Row(
      children: [
        Container(
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded),
            iconSize: 24,
            onPressed: () {
              Get.back();
            },
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Helvetica',
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
    actions: [
      IconButton(
        icon: Icon(Icons.logout_rounded),
        onPressed: () {
          Get.defaultDialog(
              contentPadding: EdgeInsets.all(15),
              title: 'Confirmation',
              titleStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff3A4856)),
              titlePadding: EdgeInsets.only(top: 15),
              content: Text(
                'Are you sure want to sign out?',
                style: TextStyle(color: Color(0xff3A4856)),
              ),
              textCancel: 'Cancel',
              textConfirm: 'Yes',
              confirmTextColor: Colors.white,
              radius: 15,
              onConfirm: () {
                _authManager.logout();
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
