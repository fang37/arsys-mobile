import 'dart:convert';
import 'dart:io';
import 'package:arsys/controllers/event_controller.dart';
import 'package:arsys/controllers/fcm_controller.dart';
import 'package:arsys/controllers/profile_controller.dart';
import 'package:arsys/controllers/research_controller.dart';
import 'package:arsys/views/appbar.dart';
import 'package:flutter/material.dart';
import 'package:arsys/views/user/login.dart';
import 'package:arsys/network/api.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class StudentHome extends StatefulWidget {
  @override
  _StudentHomeState createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  final fcmC = Get.find<FCMController>();
  final researchC = Get.find<ResearchController>();
  final eventC = Get.find<EventController>();
  final profileC = Get.find<ProfileController>();
  @override
  void initState() {
    researchC.researchUser();
    profileC.profileUser();
    eventC.eventUser();
    eventC.eventsUser();
    fcmC.sendToken();
    fcmC.receiveNotification();
    super.initState();
  }

  int _selectedNavbar = 0;
  void _changeSelectedNavBar(int index) {
    setState(() {
      _selectedNavbar = index;
      if (_selectedNavbar == 1) {
        Get.offAndToNamed('/student-research');
      }
      if (_selectedNavbar == 2) {
        Get.toNamed('/student-event');
      }
      if (_selectedNavbar == 3) {
        Get.toNamed('/student-lecture');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F9FE),
      appBar: HomeAppBarBuilder(context),
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
                      Flexible(
                        flex: 1,
                        child: Card(
                            elevation: 2.0,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              padding: EdgeInsets.fromLTRB(0, 3, 0, 8),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadiusDirectional.circular(10),
                                // gradient: LinearGradient(
                                //     colors: [
                                //       Colors.lightBlueAccent,
                                //       Color(0xFF0277E3)
                                //     ],
                                //     begin: Alignment.bottomLeft,
                                //     end: Alignment.topRight)
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                          iconSize: 32,
                                          color: Color(0xff3A4856),
                                          onPressed: () {
                                            Get.toNamed('/student-research');
                                          },
                                          icon: Icon(Icons.book_rounded)),
                                      Text(
                                        "Research",
                                        style: TextStyle(
                                            fontFamily: "OpenSans",
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xff3A4856)),
                                      )
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                          iconSize: 32,
                                          color: Color(0xff3A4856),
                                          onPressed: () {
                                            Get.toNamed('/student-event');
                                          },
                                          icon: Icon(Icons.event)),
                                      Text(
                                        "Event",
                                        style: TextStyle(
                                            fontFamily: "OpenSans",
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xff3A4856)),
                                      )
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                          iconSize: 32,
                                          color: Color(0xff3A4856),
                                          onPressed: () {
                                            Get.toNamed('/student-lecture');
                                          },
                                          icon: Icon(Icons.schedule)),
                                      Text(
                                        "Lecture",
                                        style: TextStyle(
                                            fontFamily: "OpenSans",
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xff3A4856)),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Colors.grey[100],
        color: Colors.grey,
        activeColor: Colors.lightBlueAccent,
        top: 0,
        elevation: 3,
        style: TabStyle.flip,
        height: 60,
        items: [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.book_rounded, title: 'Research'),
          TabItem(icon: Icons.event, title: 'Event'),
          TabItem(icon: Icons.schedule, title: 'Lecture'),
        ],
        initialActiveIndex: _selectedNavbar,
        onTap: _changeSelectedNavBar,
      ),
    );
  }

  Future refreshEvent() async {
    profileC.profileClear();
    profileC.profileUser();
    eventC.event.clear();
    eventC.eventUser();
    eventC.events.clear();
    eventC.eventsUser();
    await Future.delayed(Duration(seconds: 2));
    setState(() {});
  }
}
