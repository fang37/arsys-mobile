import 'dart:convert';
import 'dart:io';
import 'package:arsys/student/controllers/event_controller.dart';
import 'package:arsys/student/controllers/research_controller.dart';
import 'package:arsys/student/controllers/student_controller.dart';
import 'package:arsys/student/controllers/research_controller.dart';
import 'package:arsys/views/appbar.dart';
import 'package:flutter/material.dart';
import 'package:arsys/network/network.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class StudentResearch extends StatefulWidget {
  @override
  _StudentResearchState createState() => _StudentResearchState();
}

class _StudentResearchState extends State<StudentResearch> {
  final researchC = Get.find<ResearchController>();

  @override
  void initState() {
    researchC.researchListUser();
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
              onRefresh: refreshResearches,
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Research',
                          style: TextStyle(
                              color: Color(0xff3A4856),
                              fontSize: 20,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Flexible(
                        child: Card(
                          elevation: 4.0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: FutureBuilder<dynamic>(
                              future: researchC.researchListUser(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.data.length == 0) {
                                  return const Expanded(
                                      child:
                                          Center(child: Text('No Research')));
                                } else {
                                  // print(snapshot.data[0].event_name);
                                  // print(snapshot.data.length);
                                  return ClipPath(
                                    clipper: ShapeBorderClipper(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0))),
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (context, index) {
                                          return Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Card(
                                                elevation: 0,
                                                color: researchC
                                                    .cardColorBuilder(snapshot
                                                        .data[index]
                                                        .milestone
                                                        .milestone),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                child: ClipPath(
                                                  clipper: ShapeBorderClipper(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0))),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: researchC
                                                            .cardColorBuilder(
                                                                snapshot
                                                                    .data[index]
                                                                    .milestone
                                                                    .milestone)
                                                        // gradient:
                                                        // LinearGradient(
                                                        //     colors: [
                                                        //   Colors.white,
                                                        //   researchC.cardColorBuilder(
                                                        //       snapshot.data[index]
                                                        //               .milestone[
                                                        //           'milestone'])
                                                        // ],
                                                        //     begin:
                                                        //         FractionalOffset
                                                        //             .centerLeft,
                                                        //     end: FractionalOffset
                                                        //         .centerRight)

                                                        ),
                                                    child: ListTile(
                                                      onTap: () {
                                                        Get.toNamed(
                                                            '/student-research-detail',
                                                            arguments: snapshot
                                                                .data[index]
                                                                .id);
                                                      },
                                                      contentPadding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(10, 10,
                                                                  16, 10),
                                                      isThreeLine: true,
                                                      title: Text(
                                                          snapshot.data[index]
                                                              .researchName,
                                                          style: TextStyle(
                                                              fontSize: 24,
                                                              fontFamily:
                                                                  'OpenSans',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: Colors
                                                                  .white)),
                                                      subtitle: Text(
                                                        "${snapshot.data[index].milestone.milestone} \n${snapshot.data[index].milestone.description}",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'OpenSans'),
                                                      ),
                                                      leading:
                                                          researchC.iconBuilder(
                                                              snapshot
                                                                  .data[index]
                                                                  .researchType,
                                                              65,
                                                              index,
                                                              snapshot
                                                                  .data[index]
                                                                  .milestone
                                                                  .milestone),
                                                      trailing: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            snapshot
                                                                .data[index]
                                                                .milestone
                                                                .phase,
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                fontFamily:
                                                                    'OpenSans',
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ],
                                                      ),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15)),
                                                      // tileColor: Colors.lightBlueAccent[100],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  );
                                }
                              }),
                        ),
                      )
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

  Future refreshResearches() async {
    researchC.researches.clear();
    researchC.researchListUser();
    await Future.delayed(Duration(seconds: 2));
    setState(() {});
  }
}
