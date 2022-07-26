import 'dart:convert';
import 'dart:io';
import 'package:arsys/student/controllers/event_controller.dart';
import 'package:arsys/student/models/event.dart';
import 'package:arsys/views/appbar.dart';
import 'package:flutter/material.dart';
import 'package:arsys/network/network.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:timeline_tile/timeline_tile.dart';

class FacultyEvent extends StatefulWidget {
  @override
  _FacultyEventState createState() => _FacultyEventState();
}

class _FacultyEventState extends State<FacultyEvent> {
  final eventC = Get.find<EventController>();
  String name = "";
  String role = "";
  @override
  void initState() {
    super.initState();
  }

  int _selectedNavbar = 2;
  void _changeSelectedNavBar(int index) {
    setState(() {
      _selectedNavbar = index;
      if (_selectedNavbar == 0) {
        Get.toNamed('/faculty-home');
      }
      if (_selectedNavbar == 1) {
        Get.toNamed('/faculty-supervision');
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
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'My Upcoming Event',
                            style: TextStyle(
                                color: Color(0xff3A4856),
                                fontSize: 20,
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                              onPressed: () {
                                Get.toNamed('/faculty-all-event');
                              },
                              child: const Text(
                                'All Event',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.lightBlueAccent),
                              ))
                        ],
                      ),
                      Expanded(
                        child: FutureBuilder<dynamic>(
                            future: eventC.eventUser(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (!snapshot.hasData) {
                                return const Expanded(
                                    child: Center(
                                        child: Text('No Event Applied')));
                              } else {
                                return ListView.builder(
                                    shrinkWrap: true,
                                    physics: BouncingScrollPhysics(),
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, index) {
                                      return Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Card(
                                            margin: const EdgeInsets.only(
                                                left: 5, right: 5),
                                            elevation: 2.0,
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: ClipPath(
                                              clipper: ShapeBorderClipper(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0))),
                                              child: Material(
                                                child: InkWell(
                                                  onTap: () {
                                                    if (snapshot.data[index]
                                                            .eventType ==
                                                        Type.preDefense.id) {
                                                      Get.toNamed(
                                                          "faculty-event-defense",
                                                          arguments: snapshot
                                                              .data[index]);
                                                    } else if (snapshot
                                                                .data[index]
                                                                .eventType ==
                                                            Type.finalDefense
                                                                .id ||
                                                        snapshot.data[index]
                                                                .eventType ==
                                                            Type.eeSeminar.id) {
                                                      Get.toNamed(
                                                          "faculty-event-seminar",
                                                          arguments: snapshot
                                                              .data[index]);
                                                    }
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      8.0,
                                                                  vertical: 3),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  eventC.iconBuilder(
                                                                      snapshot
                                                                          .data[
                                                                              index]
                                                                          .eventType,
                                                                      40,
                                                                      (index ==
                                                                              0)
                                                                          ? Colors.deepOrangeAccent[
                                                                              100]!
                                                                          : Colors
                                                                              .lightBlueAccent),
                                                                  Text(
                                                                      "${snapshot.data[index].eventName}",
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              20,
                                                                          fontFamily:
                                                                              'OpenSans',
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          color:
                                                                              Color(0xff3A4856))),
                                                                ],
                                                              ),
                                                              Text(
                                                                  "${snapshot.data[index].getDateInFormat(date: snapshot.data[index].eventDate, format: "dd MMM yyyy")}",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontFamily:
                                                                          'OpenSans',
                                                                      color: Color(
                                                                          0xff3A4856))),
                                                            ],
                                                          ),
                                                        ),
                                                        const Divider(
                                                          thickness: 1,
                                                          indent: 5,
                                                          endIndent: 5,
                                                        ),
                                                        Center(
                                                          child: Text(
                                                            "${snapshot.data[index].eventId}",
                                                            style: const TextStyle(
                                                                fontFamily:
                                                                    'Helvetica',
                                                                color: Colors
                                                                    .black54),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              }
                            }),
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
                                      snapshot.data[index].eventName,
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
                                            .data[index].applicationDeadline)),
                                    afterLineStyle: LineStyle(
                                        color: eventC.timelineColor(snapshot
                                            .data[index].applicationDeadline)),
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
                                                .applicationDeadline,
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
                                            .data[index].draftDeadline)),
                                    beforeLineStyle: LineStyle(
                                        color: eventC.timelineColor(snapshot
                                            .data[index].draftDeadline)),
                                    afterLineStyle: LineStyle(
                                        color: eventC.timelineColor(snapshot
                                            .data[index].draftDeadline)),
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
                                                        .draftDeadline !=
                                                    "")
                                                ? snapshot
                                                    .data[index].draftDeadline
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
                                            snapshot.data[index].eventDate)),
                                    beforeLineStyle: LineStyle(
                                        color: eventC.timelineColor(
                                            snapshot.data[index].eventDate)),
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
                                            snapshot.data[index].eventDate,
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
                              percent: snapshot.data[index].getSeatsPercent(),
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
                              center: Text(snapshot.data[index].getSeats(),
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
