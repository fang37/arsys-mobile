import 'dart:convert';
import 'dart:io';
import 'package:arsys/student/controllers/event_controller.dart';
import 'package:arsys/views/appbar.dart';
import 'package:flutter/material.dart';
import 'package:arsys/network/network.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:timeline_tile/timeline_tile.dart';

class StudentEvent extends StatefulWidget {
  @override
  _StudentEventState createState() => _StudentEventState();
}

class _StudentEventState extends State<StudentEvent> {
  final eventC = Get.find<EventController>();
  String name = "";
  String role = "";
  @override
  void initState() {
    eventC.eventUser();
    eventC.eventsUser();
    super.initState();
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!) ?? "";
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
      if (_selectedNavbar == 3) {
        Get.toNamed('/student-lecture');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F9FE),
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
                              color: Color(0xff3A4856),
                              fontSize: 20,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Card(
                          // elevation: 4.0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: FutureBuilder<dynamic>(
                              future: eventC.eventUser(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (!snapshot.hasData) {
                                  return Expanded(
                                      child: Center(
                                          child: Text('No Event Applied')));
                                } else {
                                  // print(snapshot.data[0].event_name);
                                  // print(snapshot.data.length);
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      physics: BouncingScrollPhysics(),
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        return ClipPath(
                                          clipper: ShapeBorderClipper(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0))),
                                          child: ListTile(
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
                                                        .deepOrangeAccent[100]!
                                                    : Colors.lightBlueAccent),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            onTap: () {
                                              eventModal(
                                                  context, snapshot, index);
                                            },
                                          ),
                                        );
                                      });
                                }
                              }),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'All Event',
                          style: TextStyle(
                              color: Color(0xff3A4856),
                              fontSize: 20,
                              fontFamily: 'OpenSans',
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
                          child: FutureBuilder<dynamic>(
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
                                  // print(snapshot.data[0].event_name);
                                  // print(snapshot.data!.length);
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
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                colors: [
                                                  Colors.lightBlueAccent,
                                                  Color(0xFF0277E3)
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight),
                                          ),
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
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(15),
                                              bottomRight: Radius.circular(15)),
                                          child: ListView.builder(
                                              physics: BouncingScrollPhysics(),
                                              itemCount: snapshot.data.length,
                                              itemBuilder: (context, index) {
                                                return Container(
                                                  color: (index % 2 == 1)
                                                      ? Colors.blue[50]
                                                      : Colors.white,
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              Expanded(
                                                                  flex: 1,
                                                                  child: Text(
                                                                      (index +
                                                                              1)
                                                                          .toString(),
                                                                      style: eventC
                                                                          .rowStyle())),
                                                              Expanded(
                                                                flex: 3,
                                                                child: Text(
                                                                    snapshot
                                                                        .data[
                                                                            index]
                                                                        .event_name,
                                                                    style: eventC
                                                                        .rowStyle()),
                                                              ),
                                                              Expanded(
                                                                flex: 2,
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                      snapshot
                                                                          .data[
                                                                              index]
                                                                          .application_deadline,
                                                                      style: eventC
                                                                          .rowStyle()),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 2,
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                      snapshot
                                                                          .data[
                                                                              index]
                                                                          .event_date,
                                                                      style: eventC
                                                                          .rowStyle()),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 1,
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Text(
                                                                      (snapshot.data[index].current ?? 0)
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
                                                      ),
                                                      onTap: () {
                                                        eventModal(context,
                                                            snapshot, index);
                                                      },
                                                    ),
                                                  ),
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

  Future<dynamic> eventModal(
      BuildContext context, AsyncSnapshot<dynamic> snapshot, int index) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter modalstate) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 30),
                color: Colors.white,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Event Detail',
                          style: TextStyle(
                              color: Color(0xff3A4856),
                              fontSize: 16,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () {
                            if (Get.isBottomSheetOpen != null) {
                              Get.back();
                            }
                          },
                          icon: Icon(Icons.close_rounded),
                          color: Colors.lightBlueAccent,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 8),
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                            Colors.lightBlueAccent,
                                            Color(0xFF0277E3)
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: Center(
                                    child: Text(
                                      snapshot.data[index].event_name,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontFamily: 'OpenSans',
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  child: TimelineTile(
                                    indicatorStyle: IndicatorStyle(
                                        width: 25,
                                        color: eventC.timelineColor(snapshot
                                            .data[index].application_deadline)),
                                    afterLineStyle: LineStyle(
                                        color: eventC.timelineColor(snapshot
                                            .data[index].application_deadline)),
                                    endChild: Container(
                                      margin: EdgeInsets.all(8),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Application Deadline',
                                            style: TextStyle(
                                                color: Color(0xff3A4856),
                                                fontSize: 16,
                                                fontFamily: 'OpenSans',
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            snapshot.data[index]
                                                .application_deadline,
                                            style: TextStyle(
                                                color: Color(0xff3A4856),
                                                fontSize: 16,
                                                fontFamily: 'OpenSans'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    isFirst: true,
                                  ),
                                ),
                                SizedBox(
                                  child: TimelineTile(
                                    indicatorStyle: IndicatorStyle(
                                        width: 25,
                                        color: eventC.timelineColor(snapshot
                                            .data[index].draft_deadline)),
                                    beforeLineStyle: LineStyle(
                                        color: eventC.timelineColor(snapshot
                                            .data[index].draft_deadline)),
                                    afterLineStyle: LineStyle(
                                        color: eventC.timelineColor(snapshot
                                            .data[index].draft_deadline)),
                                    endChild: Container(
                                      margin: EdgeInsets.all(8),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Draft Deadline',
                                            style: TextStyle(
                                                color: Color(0xff3A4856),
                                                fontSize: 16,
                                                fontFamily: 'OpenSans',
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            (snapshot.data[index]
                                                        .draft_deadline !=
                                                    "")
                                                ? snapshot
                                                    .data[index].draft_deadline
                                                : "missing",
                                            style: TextStyle(
                                                color: Color(0xff3A4856),
                                                fontSize: 16,
                                                fontFamily: 'OpenSans'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  child: TimelineTile(
                                    indicatorStyle: IndicatorStyle(
                                        width: 25,
                                        color: eventC.timelineColor(
                                            snapshot.data[index].event_date)),
                                    beforeLineStyle: LineStyle(
                                        color: eventC.timelineColor(
                                            snapshot.data[index].event_date)),
                                    isLast: true,
                                    endChild: Container(
                                      padding: EdgeInsets.all(8),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Event Date',
                                            style: TextStyle(
                                                color: Color(0xff3A4856),
                                                fontSize: 16,
                                                fontFamily: 'OpenSans',
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            snapshot.data[index].event_date,
                                            style: TextStyle(
                                                color: Color(0xff3A4856),
                                                fontSize: 16,
                                                fontFamily: 'OpenSans'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: CircularPercentIndicator(
                              radius:
                                  MediaQuery.of(context).size.width / 2 * 0.7,
                              lineWidth: 15.0,
                              animation: true,
                              percent: (snapshot.data[index].current ?? 0) /
                                  snapshot.data[index].quota,
                              footer: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'QUOTA',
                                  style: TextStyle(
                                      color: Color(0xff3A4856),
                                      fontSize: 16,
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              center: Text(
                                  "${snapshot.data[index].current ?? '?'} / ${snapshot.data[index].quota}",
                                  style: TextStyle(
                                      color: Color(0xff3A4856),
                                      fontSize: 24,
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.bold)),
                              linearGradient: LinearGradient(
                                  colors: [
                                    Colors.lightBlueAccent,
                                    Color(0xFF0277E3)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight),
                            ))
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.lightBlueAccent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      child: Text(
                        "OK",
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'Helvetica'),
                      ),
                      onPressed: () {
                        if (Get.isBottomSheetOpen != null) {
                          Get.back();
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          });
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer);
  }

  Future refreshEvent() async {
    eventC.event.clear();
    eventC.eventUser();
    eventC.events.clear();
    eventC.eventsUser();
    await Future.delayed(Duration(seconds: 2));
    setState(() {});
  }

  // void logout() async {
  //   var res = await Network().getData('/logout');
  //   var body = json.decode(res.body);
  //   if (body['success']) {
  //     SharedPreferences localStorage = await SharedPreferences.getInstance();
  //     localStorage.remove('user');
  //     localStorage.remove('token');
  //     Get.toNamed('/login');
  //   }
  // }
}
