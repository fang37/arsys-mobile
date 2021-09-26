import 'dart:convert';
import 'dart:io';
import 'package:arsys/controllers/event_controller.dart';
import 'package:arsys/views/appbar.dart';
import 'package:flutter/material.dart';
import 'package:arsys/views/user/login.dart';
import 'package:arsys/network/api.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class StudentEvent extends StatefulWidget {
  @override
  _StudentEventState createState() => _StudentEventState();
}

class _StudentEventState extends State<StudentEvent> {
  final eventC = Get.find<EventController>();
  String name;
  String role;
  @override
  void initState() {
    eventC.eventUser();
    eventC.eventsUser();
    super.initState();
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')) ?? "";
    var roles = localStorage.getString('roles') ?? "";

    if (user != null) {
      setState(() {
        name = user['name'];
        role = roles;
      });
    }
  }

  int _selectedNavbar = 2;
  void _changeSelectedNavBar(int index) {
    setState(() {
      _selectedNavbar = index;
      if (_selectedNavbar == 0) {
        Get.toNamed('/student-home');
      }
      if (_selectedNavbar == 1) {
        Get.toNamed('/student-research');
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'All Event',
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Card(
                          elevation: 4.0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: FutureBuilder(
                              future: eventC.eventsUser(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.data.length == 0) {
                                  return Center(
                                    child: Text('No Upcoming Event'),
                                  );
                                } else {
                                  print(snapshot.data[0].event_name);
                                  print(snapshot.data.length);
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ClipPath(
                                        clipper: ShapeBorderClipper(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                        ))),
                                        child: Container(
                                          padding:
                                              EdgeInsetsDirectional.all(10),
                                          color: Colors.lightBlue[100],
                                          child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                    flex: 1,
                                                    child: Text('No',
                                                        style: eventC
                                                            .headStyle())),
                                                Expanded(
                                                    flex: 3,
                                                    child: Text('Event Name',
                                                        style: eventC
                                                            .headStyle())),
                                                Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                        'Application Deadline',
                                                        style: eventC
                                                            .headStyle())),
                                                Expanded(
                                                    flex: 2,
                                                    child: Text('Event Date',
                                                        style: eventC
                                                            .headStyle())),
                                                Expanded(
                                                    flex: 1,
                                                    child: Text('Quota',
                                                        style: eventC
                                                            .headStyle())),
                                              ]),
                                        ),
                                      ),
                                      Expanded(
                                        child: ClipPath(
                                          clipper: ShapeBorderClipper(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                            bottomLeft: Radius.circular(15),
                                            bottomRight: Radius.circular(15),
                                          ))),
                                          child: ListView.builder(
                                              itemCount: snapshot.data.length,
                                              itemBuilder: (context, index) {
                                                return Container(
                                                  color: (index % 2 == 1)
                                                      ? Colors.grey[200]
                                                      : Colors.white,
                                                  padding:
                                                      EdgeInsetsDirectional.all(
                                                          10),
                                                  child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Expanded(
                                                            flex: 1,
                                                            child: Text(
                                                                (index + 1)
                                                                    .toString(),
                                                                style: eventC
                                                                    .rowStyle())),
                                                        Expanded(
                                                          flex: 3,
                                                          child: Text(
                                                              snapshot
                                                                  .data[index]
                                                                  .event_name,
                                                              style: eventC
                                                                  .rowStyle()),
                                                        ),
                                                        Expanded(
                                                          flex: 2,
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                                snapshot
                                                                    .data[index]
                                                                    .application_deadline,
                                                                style: eventC
                                                                    .rowStyle()),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 2,
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                                snapshot
                                                                    .data[index]
                                                                    .event_date,
                                                                style: eventC
                                                                    .rowStyle()),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                                (snapshot.data[index].current ??
                                                                            0)
                                                                        .toString() +
                                                                    '/' +
                                                                    snapshot
                                                                        .data[
                                                                            index]
                                                                        .quota
                                                                        .toString(),
                                                                style: eventC
                                                                    .rowStyle()),
                                                          ),
                                                        ),
                                                      ]),
                                                );
                                              }),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              }),
                        ),
                      ),
                      // Expanded(child: Container()),
                      // Expanded(child: Container()),

                      // Row(
                      //   children: [
                      //     Text('Hello, ', style: TextStyle(fontSize: 20)),
                      //     Text(
                      //       name,
                      //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      //     ),
                      //     Text('  Roles: ' + role)
                      //   ],
                      // )
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
