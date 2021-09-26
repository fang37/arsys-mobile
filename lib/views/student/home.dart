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

class StudentHome extends StatefulWidget {
  @override
  _StudentHomeState createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  final eventC = Get.find<EventController>();
  final userC = Get.find<UserController>();
  @override
  void initState() {
    userC.loadUserData();
    eventC.eventUser();
    // eventC.eventsUser();
    super.initState();
  }

  int _selectedNavbar = 0;
  void _changeSelectedNavBar(int index) {
    setState(() {
      _selectedNavbar = index;
      if (_selectedNavbar == 1) {
        Get.toNamed('/student-research');
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
                          'Applied Event',
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Card(
                          elevation: 4.0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: FutureBuilder(
                              future: eventC.eventUser(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.data.length == 0) {
                                  return Expanded(
                                      child: Center(
                                          child: Text('No Event Applied')));
                                } else {
                                  // print(snapshot.data[0].event_name);
                                  // print(snapshot.data.length);
                                  return ClipPath(
                                    clipper: ShapeBorderClipper(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0))),
                                    child: ListView.builder(
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Text(
                                                snapshot.data[index].event_name,
                                                style: TextStyle(
                                                    fontFamily: 'Helvetica',
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey[800])),
                                            subtitle: Text(snapshot
                                                .data[index].event_date),
                                            leading: eventC.iconBuilder(
                                                snapshot.data[index].event_type,
                                                40,
                                                (index == 0)
                                                    ? Colors
                                                        .deepOrangeAccent[100]
                                                    : Colors.lightBlueAccent),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            // tileColor: Colors.lightBlueAccent[100],
                                          );
                                        }),
                                  );
                                }
                              }),
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
    eventC.event.clear();
    eventC.eventUser();
    eventC.events.clear();
    eventC.eventsUser();
    await Future.delayed(Duration(seconds: 2));
    setState(() {});
  }
}
