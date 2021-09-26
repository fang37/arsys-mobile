import 'dart:convert';
import 'dart:io';
import 'package:arsys/controllers/event_controller.dart';
import 'package:arsys/controllers/user_controller.dart';
import 'package:arsys/views/appbar.dart';
import 'package:flutter/material.dart';
import 'package:arsys/views/user/login.dart';
import 'package:arsys/network/api.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class StudentResearch extends StatefulWidget {
  @override
  _StudentResearchState createState() => _StudentResearchState();
}

class _StudentResearchState extends State<StudentResearch> {
  final userC = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
  }

  int _selectedNavbar = 1;
  void _changeSelectedNavBar(int index) {
    setState(() {
      _selectedNavbar = index;
      if (_selectedNavbar == 0) {
        Get.toNamed('/student-home');
      }
      if (_selectedNavbar == 2) {
        Get.toNamed('/student-event');
      }
      if (_selectedNavbar == 2) () => Get.toNamed('/student-event');
      if (_selectedNavbar == 3) () => Get.toNamed('/student-event');
      if (_selectedNavbar == 4) () => Get.toNamed('/student-event');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBarBuilder(),
      body: Platform.isIOS
          ? Container()
          : RefreshIndicator(
              displacement: 40,
              edgeOffset: 10,
              onRefresh: refreshEvent,
              child: SafeArea(
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Applicant Event',
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Colors.lightBlue,
        items: [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.supervised_user_circle, title: 'Supervise'),
          TabItem(icon: Icons.event, title: 'Event'),
          TabItem(icon: Icons.article, title: 'Review'),
          TabItem(icon: Icons.schedule, title: 'Lecture'),
        ],
        initialActiveIndex: _selectedNavbar,
        onTap: _changeSelectedNavBar,
      ),
    );
  }

  Future refreshEvent() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {});
  }

  void logout() async {
    var res = await Network().getData('/logout');
    var body = json.decode(res.body);
    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
      localStorage.remove('token');
      Get.toNamed('/login');
    }
  }
}
