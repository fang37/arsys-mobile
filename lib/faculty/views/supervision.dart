import 'dart:convert';
import 'dart:io';
import 'package:arsys/faculty/controllers/supervision_controller.dart';
import 'package:arsys/student/controllers/event_controller.dart';
import 'package:arsys/student/controllers/student_controller.dart';
import 'package:arsys/student/controllers/research_controller.dart';
import 'package:arsys/student/models/research.dart';
import 'package:arsys/views/appbar.dart';
import 'package:flutter/material.dart';
import 'package:arsys/network/network.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class FacultySupervision extends StatefulWidget {
  @override
  _FacultySupervisionState createState() => _FacultySupervisionState();
}

class _FacultySupervisionState extends State<FacultySupervision> {
  final researchC = Get.find<SupervisionController>();

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
        Get.toNamed('/faculty-home');
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
                          'Supervision',
                          style: TextStyle(
                              color: Color(0xff3A4856),
                              fontSize: 20,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Flexible(
                        child: FutureBuilder<List<Research>>(
                            future: researchC.researchListUser(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (!snapshot.hasData) {
                                return const Expanded(
                                    child: Center(child: Text('No Research')));
                              } else {
                                return Scrollbar(
                                  interactive: true,
                                  child: ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: snapshot.data?.length,
                                      itemBuilder: (context, index) {
                                        return Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 3),
                                            child: Card(
                                              elevation: 2,
                                              color: Colors.white,
                                              // color: researchC.cardColorBuilder(
                                              //     snapshot.data[index].milestone
                                              //         .milestone),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: ClipPath(
                                                  clipper: ShapeBorderClipper(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0))),
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                      splashColor:
                                                          Colors.lightBlue[100],
                                                      onTap: () {},
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Center(
                                                              child: Text(
                                                                  "${snapshot.data![index].milestone?.description}",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontFamily:
                                                                          'OpenSans',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Color(
                                                                          0xff3A4856))),
                                                            ),
                                                            const Divider(
                                                              thickness: 1,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      5,
                                                                      3,
                                                                      0,
                                                                      0),
                                                              child: Text(
                                                                  "${snapshot.data![index].student?.getFullName()}",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontFamily:
                                                                          'OpenSans',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      color: Color(
                                                                          0xff3A4856))),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8),
                                                              child: Text(
                                                                  "${snapshot.data?[index].student?.studentNumber} - ${snapshot.data?[index].student?.specialization}",
                                                                  style: const TextStyle(
                                                                      fontFamily:
                                                                          'Helvetica',
                                                                      color: Colors
                                                                          .black54)),
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .fromLTRB(8,
                                                                      3, 8, 3),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Container(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              8,
                                                                          vertical:
                                                                              5),
                                                                      decoration: BoxDecoration(
                                                                          color: researchC.cardColorBuilder(snapshot.data?[index].milestone?.milestone ??
                                                                              ""),
                                                                          borderRadius: BorderRadius.circular(
                                                                              10.0)),
                                                                      child: Text(
                                                                          "${snapshot.data?[index].milestone?.milestone}",
                                                                          style: TextStyle(
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontFamily: 'OpenSans',
                                                                              color: Color(0xff3A4856)))),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            5),
                                                                    child: Container(
                                                                        padding: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                8,
                                                                            vertical:
                                                                                5),
                                                                        decoration: BoxDecoration(
                                                                            color: Colors.blueGrey[
                                                                                50],
                                                                            borderRadius: BorderRadius.circular(
                                                                                10.0)),
                                                                        child: Text(
                                                                            "${snapshot.data?[index].milestone?.phase}",
                                                                            style: TextStyle(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontFamily: 'OpenSans',
                                                                                color: Color(0xff3A4856)))),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            const Divider(
                                                              thickness: 1,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(3.0),
                                                              child: Text(
                                                                  "${snapshot.data?[index].title}",
                                                                  overflow:
                                                                      TextOverflow
                                                                          .fade,
                                                                  maxLines: 2,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontFamily:
                                                                          'OpenSans',
                                                                      color: Color(
                                                                          0xff3A4856))),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )

                                                  // ListTile(
                                                  //   onTap: () {
                                                  //     Get.toNamed(
                                                  //         '/student-research-detail',
                                                  //         arguments: snapshot
                                                  //             .data[index].id);
                                                  //   },
                                                  //   contentPadding:
                                                  //       EdgeInsetsDirectional
                                                  //           .fromSTEB(
                                                  //               10, 10, 16, 10),
                                                  //   isThreeLine: true,
                                                  //   title: Text(
                                                  //       snapshot.data[index]
                                                  //           .researchName,
                                                  //       style: TextStyle(
                                                  //           fontSize: 24,
                                                  //           fontFamily:
                                                  //               'OpenSans',
                                                  //           fontWeight:
                                                  //               FontWeight.w700,
                                                  //           color:
                                                  //               Colors.white)),
                                                  //   subtitle: Text(
                                                  //     "${snapshot.data[index].milestone.milestone} \n${snapshot.data[index].milestone.description}",
                                                  //     style: TextStyle(
                                                  //         fontFamily:
                                                  //             'OpenSans'),
                                                  //   ),
                                                  //   leading:
                                                  //       researchC.iconBuilder(
                                                  //           snapshot.data[index]
                                                  //               .researchType,
                                                  //           65,
                                                  //           index,
                                                  //           snapshot
                                                  //               .data[index]
                                                  //               .milestone
                                                  //               .milestone),
                                                  //   trailing: Column(
                                                  //     mainAxisAlignment:
                                                  //         MainAxisAlignment
                                                  //             .center,
                                                  //     children: [
                                                  //       Text(
                                                  //         snapshot.data[index]
                                                  //             .milestone.phase,
                                                  //         style: TextStyle(
                                                  //             fontSize: 16,
                                                  //             fontStyle:
                                                  //                 FontStyle
                                                  //                     .italic,
                                                  //             fontFamily:
                                                  //                 'OpenSans',
                                                  //             color:
                                                  //                 Colors.white),
                                                  //       ),
                                                  //     ],
                                                  //   ),
                                                  //   shape:
                                                  //       RoundedRectangleBorder(
                                                  //           borderRadius:
                                                  //               BorderRadius
                                                  //                   .circular(
                                                  //                       15)),
                                                  //   // tileColor: Colors.lightBlueAccent[100],
                                                  // ),
                                                  ),
                                            ),
                                          ),
                                        );
                                      }),
                                );
                              }
                            }),
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
