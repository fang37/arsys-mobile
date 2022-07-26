// TODO Approval
// Supervision
// Review
// Upload

import 'dart:convert';
import 'dart:io';
import 'package:arsys/student/controllers/research_controller.dart';
import 'package:arsys/student/models/research.dart';
import 'package:arsys/views/appbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:arsys/network/network.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:timeline_tile/timeline_tile.dart';

class StudentResearchDetail extends StatefulWidget {
  @override
  _StudentResearchDetailState createState() => _StudentResearchDetailState();
}

class _StudentResearchDetailState extends State<StudentResearchDetail> {
  final researchC = Get.find<ResearchController>();
  final researhId = Get.arguments;
  var research;
  ScrollController scrollC = new ScrollController();
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
      // if (_selectedNavbar == 1) () => Get.back();
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
      backgroundColor: const Color(0xFFF0F9FE),
      appBar: SecondAppBarBuilder("Research"),
      body: Platform.isIOS
          ? Container()
          : SafeArea(
              child: Container(
                  padding: const EdgeInsets.all(15),
                  child: FutureBuilder<dynamic>(
                      future: researchC.researchById(researhId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (!snapshot.hasData) {
                          return const Expanded(
                              child: Center(child: Text('No Detail')));
                        } else {
                          research = researchC.research;
                          return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                              text: research.title,
                                              style: const TextStyle(
                                                  fontSize: 24,
                                                  fontFamily: 'OpenSans',
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff3A4856)),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  titleModal(context);
                                                }),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        RichText(
                                          text: TextSpan(
                                              text: " Abstract",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'OpenSans',
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      Colors.lightBlueAccent),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  abstractModal(context);
                                                }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Flexible(
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Card(
                                          elevation: 3,
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: ClipPath(
                                            clipper: ShapeBorderClipper(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0))),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                      color: researchC
                                                          .cardColorBuilder(
                                                              research.milestone
                                                                  .milestone),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(10),
                                                              topRight: Radius
                                                                  .circular(
                                                                      10))),
                                                  child: const Center(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(5.0),
                                                      child: Text(
                                                          "Information!",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black87,
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  'OpenSans',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                    child: Center(
                                                        child:
                                                            SingleChildScrollView(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.0,
                                                        vertical: 8),
                                                    child: Obx(() {
                                                      return RichText(
                                                        text: TextSpan(
                                                            text:
                                                                "${research.information.value}",
                                                            style: const TextStyle(
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    'OpenSans',
                                                                color: Colors
                                                                    .black87),
                                                            recognizer:
                                                                TapGestureRecognizer()
                                                                  ..onTap = () {
                                                                    titleModal(
                                                                        context);
                                                                  }),
                                                      );
                                                    }),
                                                  ),
                                                )))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 6,
                                  child: GridView.count(
                                      // primary: true,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      crossAxisCount: 2,
                                      shrinkWrap: true,
                                      physics: BouncingScrollPhysics(),
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () => approvalModal(context),
                                          child: menuCard(
                                              "Approval", Icons.check_rounded),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            if (research.getSubmissionType() ==
                                                SubmissionType.none) {
                                              return null;
                                            } else if (research
                                                    .getSubmissionType() ==
                                                SubmissionType.defenseReport) {
                                              _navigateAndRefresh(
                                                  '/student-research-event-report');
                                            } else {
                                              submissionModal(context);
                                            }
                                          },
                                          child: menuCard(
                                              "Submission", Icons.send_rounded,
                                              isActive: research
                                                      .getSubmissionType() !=
                                                  SubmissionType.none),
                                        ),
                                        InkWell(
                                          onTap: () =>
                                              proposalReviewModal(context),
                                          child: menuCard("Proposal Review",
                                              Icons.feedback_rounded),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            if (research.getEventType() !=
                                                EventType.none) {
                                              _navigateAndRefresh(
                                                  '/student-research-event');
                                            }
                                            null;
                                          },
                                          child: menuCard("Event",
                                              Icons.calendar_month_rounded,
                                              isActive:
                                                  research.getEventType() !=
                                                      EventType.none),
                                        ),
                                      ]),
                                ),
                                // Expanded(
                                //   flex: 4,
                                //   child: Container(
                                //     color: Colors.pink,
                                //     child: Padding(
                                //       padding: EdgeInsets.all(8.0),
                                //       child: Text(
                                //         'Progress of Supervision',
                                //         style: TextStyle(
                                //             color: Color(0xff3A4856),
                                //             fontSize: 16,
                                //             fontFamily: 'OpenSans',
                                //             fontWeight: FontWeight.bold),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                // superviseBuilder(research: research, researchC: researchC),
                                // Expanded(
                                //     flex: 2, child: Container(color: Colors.lightBlue))
                                // BUAT SCROLLABLE APP NYA
                              ]);
                        }
                      }))),
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Colors.grey[100],
        color: Colors.grey,
        activeColor: Colors.lightBlueAccent,
        top: 0,
        elevation: 3,
        style: TabStyle.flip,
        height: 60,
        items: [
          const TabItem(icon: Icons.home, title: 'Home'),
          const TabItem(icon: Icons.book_rounded, title: 'Research'),
          const TabItem(icon: Icons.event, title: 'Event'),
          const TabItem(icon: Icons.schedule, title: 'Lecture'),
        ],
        initialActiveIndex: _selectedNavbar,
        onTap: _changeSelectedNavBar,
      ),
    );
  }

  Future<dynamic> approvalModal(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter modalstate) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                color: Colors.lightBlueAccent,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Approval of Defense/Seminar',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.bold)),
                        IconButton(
                          onPressed: () {
                            if (Get.isBottomSheetOpen != null) {
                              Get.back();
                            }
                          },
                          icon: const Icon(Icons.close_rounded),
                          color: Colors.white,
                        )
                      ],
                    ),
                    Flexible(
                      child: Card(
                        elevation: 4.0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: ClipPath(
                          clipper: ShapeBorderClipper(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0))),
                          child: Scrollbar(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  controller: scrollC,
                                  // reverse: true,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: research.defenseApproval.length,
                                  itemBuilder: (context, index) {
                                    print(research.defenseApproval.length);
                                    if (research.defenseApproval.length == 0) {
                                      print('no data approval');
                                      return const Expanded(
                                          child: const Center(
                                        child: Text("No Approvement"),
                                      ));
                                    } else {
                                      if (index ==
                                          research.defenseApproval.length) {
                                        scrollC.jumpTo(
                                            scrollC.position.maxScrollExtent);
                                      }
                                      return SizedBox(
                                        child: TimelineTile(
                                          indicatorStyle: IndicatorStyle(
                                              width: 25,
                                              color: researchC.timelineColor(
                                                research.defenseApproval[index]
                                                    .decision,
                                              )),
                                          axis: TimelineAxis.vertical,
                                          beforeLineStyle: LineStyle(
                                              color: researchC.timelineColor(
                                                  research
                                                      .defenseApproval[index]
                                                      .decision)),
                                          afterLineStyle: LineStyle(
                                              color: (index <
                                                      research.defenseApproval
                                                              .length -
                                                          1)
                                                  ? researchC.timelineColor(
                                                      research
                                                          .defenseApproval[
                                                              index + 1]
                                                          .decision)
                                                  : Colors.transparent),
                                          isFirst: (index == 0) ? true : false,
                                          isLast: (index ==
                                                  research.defenseApproval
                                                          .length -
                                                      1)
                                              ? true
                                              : false,
                                          endChild: Container(
                                            margin: const EdgeInsets.all(8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      research
                                                          .defenseApproval[
                                                              index]
                                                          .defenseModel
                                                          .description,
                                                      style: const TextStyle(
                                                          color:
                                                              Color(0xff3A4856),
                                                          fontSize: 16,
                                                          fontFamily:
                                                              'OpenSans',
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),

                                                    Text(
                                                      "${research.defenseApproval[index].approver.code} ${(research.defenseApproval[index].approverRoleId == 3) ? " (Head of Program Approval)" : ""}",
                                                      style: const TextStyle(
                                                          color:
                                                              Color(0xff3A4856),
                                                          fontSize: 16,
                                                          fontFamily:
                                                              'OpenSans'),
                                                    ),
                                                    Text(
                                                      research
                                                          .defenseApproval[
                                                              index]
                                                          .approvalDate,
                                                      style: const TextStyle(
                                                          color:
                                                              Color(0xff3A4856),
                                                          fontSize: 16,
                                                          fontFamily:
                                                              'OpenSans'),
                                                    ),
                                                    // Row(
                                                    //   mainAxisSize: MainAxisSize.min,
                                                    //   children: [
                                                    // researchC.approvalIcon(
                                                    //     research.defense_approval[index]
                                                    //         ['decision']),
                                                    //     Padding(
                                                    //       padding:
                                                    //           const EdgeInsets.only(left: 5),
                                                    //       child: Text(research
                                                    //               .defense_approval[index]
                                                    //           ['defense_model']['description']),
                                                    //     ),
                                                    //     Text(' | '),
                                                    //     Text(research.defense_approval[index]
                                                    //         ['faculty']['code']),
                                                    // Text(
                                                    //   (research.defense_approval[index]
                                                    //               ['approver_role'] ==
                                                    //           3)
                                                    //       ? " (Head of Program Approval)"
                                                    //       : "",
                                                    //   style: TextStyle(
                                                    //       fontWeight: FontWeight.bold),
                                                    // )
                                                    //   ],
                                                    // ),
                                                  ],
                                                ),
                                                researchC.approvalIcon(research
                                                    .defenseApproval[index]
                                                    .decision)
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  }),
                            ),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.lightBlueAccent.shade700,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      child: const Text(
                        "OK",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Helvetica',
                            fontWeight: FontWeight.bold),
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
        shape: const RoundedRectangleBorder(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer);
  }

  Future<dynamic> submissionModal(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter modalstate) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                color: Colors.lightBlueAccent,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Submission',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.bold)),
                        IconButton(
                          onPressed: () {
                            if (Get.isBottomSheetOpen != null) {
                              Get.back();
                            }
                          },
                          icon: const Icon(Icons.close_rounded),
                          color: Colors.white,
                        )
                      ],
                    ),
                    Flexible(
                      child: (research.getSubmissionType() ==
                              SubmissionType.none)
                          ? Text(research.getSubmissionTitle(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'OpenSans',
                              ))
                          : Card(
                              elevation: 4.0,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: ClipPath(
                                clipper: ShapeBorderClipper(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0))),
                                child: Scrollbar(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: FutureBuilder(
                                        builder: (context, snapshot) {
                                      return Column(
                                        children: [
                                          Text(research.getSubmissionTitle(),
                                              style: const TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 16,
                                                  fontFamily: 'OpenSans',
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              research
                                                  .getSubmissionDescription(),
                                              style: const TextStyle(
                                                color: Colors.black87,
                                                fontSize: 16,
                                                fontFamily: 'OpenSans',
                                              )),
                                        ],
                                      );
                                    }),
                                  ),
                                ),
                              ),
                            ),
                    ),
                    research.getSubmissionType() == SubmissionType.none
                        ? Container()
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.lightBlueAccent.shade700,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            child: Text(
                              research.milestone.proposeButton
                                  ? "Propose"
                                  : "SUBMIT",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Helvetica',
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              if (research.getSubmissionType() ==
                                  SubmissionType.none) {
                                return;
                              } else if (research.getSubmissionType() ==
                                  SubmissionType.defenseReport) {
                                _navigateAndRefresh(
                                    '/student-research-event-report');
                              } else {
                                print("THIS IS EVENT REPORT ROUTES");
                                Get.defaultDialog(
                                    contentPadding: EdgeInsets.all(15),
                                    title: 'Confirmation',
                                    titleStyle: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff3A4856)),
                                    titlePadding: EdgeInsets.only(top: 15),
                                    content: Text(
                                      research.getSubmissionDescription(),
                                      style:
                                          TextStyle(color: Color(0xff3A4856)),
                                    ),
                                    textCancel: 'Cancel',
                                    textConfirm: 'Yes',
                                    confirmTextColor: Colors.white,
                                    radius: 15,
                                    onConfirm: () {
                                      researchC.submissionSelector(research);
                                      research.updateInformation();
                                      refreshResearch();

                                      Get.back();
                                      Get.back();
                                    });
                              }
                            },
                          ),
                  ],
                ),
              ),
            );
          });
        },
        shape: const RoundedRectangleBorder(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer);
  }

  Future<dynamic> eventScheduleModal(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter modalstate) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                color: Colors.lightBlueAccent,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Event Detail',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.bold)),
                        IconButton(
                          onPressed: () {
                            if (Get.isBottomSheetOpen != null) {
                              Get.back();
                            }
                          },
                          icon: const Icon(Icons.close_rounded),
                          color: Colors.white,
                        )
                      ],
                    ),
                    Flexible(
                      child: (!research.getSubmissionButton())
                          ? Text(research.getSubmissionTitle(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'OpenSans',
                              ))
                          : Card(
                              elevation: 4.0,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: ClipPath(
                                clipper: ShapeBorderClipper(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0))),
                                child: Scrollbar(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: FutureBuilder(
                                        builder: (context, snapshot) {
                                      return Column(
                                        children: [
                                          Text(research.getSubmissionTitle(),
                                              style: const TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 16,
                                                  fontFamily: 'OpenSans',
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              research
                                                  .getSubmissionDescription(),
                                              style: const TextStyle(
                                                color: Colors.black87,
                                                fontSize: 16,
                                                fontFamily: 'OpenSans',
                                              )),
                                        ],
                                      );
                                    }),
                                  ),
                                ),
                              ),
                            ),
                    ),
                    !research.getSubmissionButton()
                        ? Container()
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.lightBlueAccent.shade700,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            child: const Text(
                              "SUBMIT",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Helvetica',
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              if (research.getSubmissionButton() == false) {
                                return;
                              } else {
                                Get.defaultDialog(
                                    contentPadding: EdgeInsets.all(15),
                                    title: 'Confirmation',
                                    titleStyle: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff3A4856)),
                                    titlePadding: EdgeInsets.only(top: 15),
                                    content: Text(
                                      research.getSubmissionDescription(),
                                      style:
                                          TextStyle(color: Color(0xff3A4856)),
                                    ),
                                    textCancel: 'Cancel',
                                    textConfirm: 'Yes',
                                    confirmTextColor: Colors.white,
                                    radius: 15,
                                    onConfirm: () {
                                      researchC.submissionSelector(research);
                                      research.updateInformation();
                                      refreshResearch();

                                      Get.back();
                                      Get.back();
                                    });
                              }
                            },
                          ),
                  ],
                ),
              ),
            );
          });
        },
        shape: const RoundedRectangleBorder(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer);
  }

  Future<dynamic> proposalReviewModal(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter modalstate) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                color: Colors.lightBlueAccent,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Proposal Review',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.bold)),
                        IconButton(
                          onPressed: () {
                            if (Get.isBottomSheetOpen != null) {
                              Get.back();
                            }
                          },
                          icon: const Icon(Icons.close_rounded),
                          color: Colors.white,
                        )
                      ],
                    ),
                    Flexible(
                      child: Card(
                        elevation: 4.0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: ClipPath(
                          clipper: ShapeBorderClipper(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0))),
                          child: Scrollbar(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),

                                  // reverse: true,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: research.proposalReview.length,
                                  itemBuilder: (context, index) {
                                    print(research.proposalReview.length);
                                    if (research.proposalReview.length == 0) {
                                      print('no proposal review');
                                      return const Expanded(
                                          child: const Center(
                                        child: Text("No Review"),
                                      ));
                                    } else {
                                      return SizedBox(
                                        child: Container(
                                          margin: const EdgeInsets.all(8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${research.proposalReview[index].reviewer.code} (${research.proposalReview[index].decisionDescription})",
                                                    style: const TextStyle(
                                                        color:
                                                            Color(0xff3A4856),
                                                        fontSize: 16,
                                                        fontFamily: 'OpenSans',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    research
                                                        .proposalReview[index]
                                                        .approvalDate,
                                                    style: const TextStyle(
                                                        color:
                                                            Color(0xff3A4856),
                                                        fontSize: 16,
                                                        fontFamily: 'OpenSans'),
                                                  ),
                                                  research.proposalReview[index]
                                                              .comment !=
                                                          ""
                                                      ? Text(
                                                          "${research.proposalReview[index].comment}",
                                                          style: const TextStyle(
                                                              color: Color(
                                                                  0xff3A4856),
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  'OpenSans'),
                                                        )
                                                      : Container(),
                                                ],
                                              ),
                                              researchC.proposalDecisionIcon(
                                                  research.proposalReview[index]
                                                      .decisionId)
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  }),
                            ),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.lightBlueAccent.shade700,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      child: const Text(
                        "OK",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Helvetica',
                            fontWeight: FontWeight.bold),
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
        shape: const RoundedRectangleBorder(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer);
  }

  Card menuCard(String title, IconData icon, {bool isActive = true}) {
    return Card(
      elevation: 2,
      color: !isActive ? Colors.grey : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            size: 30,
          ),
          SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Color(0xff3A4856)),
          )
        ],
      ),
    );
  }

  Future<dynamic> titleModal(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter modalstate) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                color: Colors.white,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Title',
                              style: TextStyle(
                                  color: const Color(0xff3A4856),
                                  fontSize: 16,
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                                onPressed: () {
                                  Clipboard.setData(
                                      new ClipboardData(text: research.title));
                                  Get.snackbar("Text copied!",
                                      "title has been copied to your clipboard",
                                      snackPosition: SnackPosition.BOTTOM);
                                },
                                icon: Icon(Icons.copy,
                                    size: 20, color: Color(0xff3A4856)))
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            if (Get.isBottomSheetOpen != null) {
                              Get.back();
                            }
                          },
                          icon: const Icon(Icons.close_rounded),
                          color: Colors.lightBlueAccent,
                        )
                      ],
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(8, 3, 8, 10),
                        child: Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: SelectableText(
                                research.title,
                                style: const TextStyle(
                                    color: Color(0xff3A4856),
                                    fontSize: 16,
                                    fontFamily: 'OpenSans'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.lightBlueAccent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      child: const Text(
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
        shape: const RoundedRectangleBorder(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer);
  }

  Future<dynamic> abstractModal(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter modalstate) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                color: Colors.white,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Abstract',
                              style: TextStyle(
                                  color: Color(0xff3A4856),
                                  fontSize: 16,
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                                onPressed: () {
                                  Clipboard.setData(new ClipboardData(
                                      text: research.abstract));
                                  Get.snackbar("Text copied!",
                                      "abstract has been copied to your clipboard",
                                      snackPosition: SnackPosition.BOTTOM);
                                },
                                icon: const Icon(Icons.copy,
                                    size: 20, color: Color(0xff3A4856)))
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            if (Get.isBottomSheetOpen != null) {
                              Get.back();
                            }
                          },
                          icon: const Icon(Icons.close_rounded),
                          color: Colors.lightBlueAccent,
                        )
                      ],
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(8, 3, 8, 10),
                        child: Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: SelectableText(
                                research.abstract,
                                style: const TextStyle(
                                    color: Color(0xff3A4856),
                                    fontSize: 16,
                                    fontFamily: 'OpenSans'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.lightBlueAccent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      child: const Text(
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
        shape: const RoundedRectangleBorder(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer);
  }

  Future refreshResearch() async {
    researchC.researchById(researhId);
    // await Future.delayed(Duration(seconds: 2));
    setState(() {});
  }

  void _navigateAndRefresh(String route) async {
    final result = await Get.toNamed(route, arguments: research.id);
    if (result != null) {
      refreshResearch();
      Get.snackbar(result['title'], result['message'],
          backgroundColor: Colors.white, icon: Icon(Icons.check_rounded));
    }
  }
}

class superviseBuilder extends StatelessWidget {
  const superviseBuilder({
    Key? key,
    required this.research,
    required this.researchC,
  }) : super(key: key);

  final research;
  final ResearchController researchC;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        initialData: research,
        // future: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!(snapshot.hasData)) {
            return const Expanded(
                child: Center(child: Text('No Research Selected')));
          } else {
            // print(snapshot.data[0].event_name);
            // print(snapshot.data.length);
            return Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data.supervisor.length,
                  itemBuilder: (context, index) {
                    if (snapshot.data.supervisor.length == 0) {
                      return Container(
                        child: const Center(
                          child: Text("No Supervisor"),
                        ),
                      );
                    } else {
                      return Expanded(
                        flex: 1,
                        child: Card(
                          elevation: 4.0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: ClipPath(
                            clipper: ShapeBorderClipper(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0))),
                            child: Column(
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 8, 10, 8),
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [
                                          Colors.lightBlueAccent,
                                          Color(0xFF0277E3)
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(snapshot.data.supervisor[index].code,
                                          // ['faculty']['code'],
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontFamily: 'OpenSans',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)),
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: researchC.bypassIcon(0)),
                                      const Text("bypass function",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "OpenSans",
                                              fontStyle: FontStyle.italic)),
                                    ],
                                  ),
                                ),
                                SingleChildScrollView(
                                  child: Scrollbar(
                                    isAlwaysShown: true,
                                    child: ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: 0,
                                        itemBuilder: (context, idx) {
                                          if (snapshot.data.supervisor[index]
                                                      .id ==
                                                  0
                                              // snapshot.data
                                              //         .supervise[idx]
                                              //     [
                                              //     'supervisor_id']
                                              ) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: InkWell(
                                                onTap: () {
                                                  showModalBottomSheet(
                                                      context: context,
                                                      builder: (context) {
                                                        return StatefulBuilder(
                                                            builder: (context,
                                                                StateSetter
                                                                    modalstate) {
                                                          return Padding(
                                                            padding: EdgeInsets.only(
                                                                bottom: MediaQuery.of(
                                                                        context)
                                                                    .viewInsets
                                                                    .bottom),
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      20,
                                                                      20,
                                                                      20,
                                                                      30),
                                                              color:
                                                                  Colors.white,
                                                              child: ListView(
                                                                shrinkWrap:
                                                                    true,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      const Text(
                                                                        'Supervise',
                                                                        style: TextStyle(
                                                                            color: Color(
                                                                                0xff3A4856),
                                                                            fontSize:
                                                                                16,
                                                                            fontFamily:
                                                                                'OpenSans',
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      IconButton(
                                                                        onPressed:
                                                                            () {
                                                                          if (Get.isBottomSheetOpen !=
                                                                              null) {
                                                                            Get.back();
                                                                          }
                                                                        },
                                                                        icon: const Icon(
                                                                            Icons.close_rounded),
                                                                        color: Colors
                                                                            .lightBlueAccent,
                                                                      )
                                                                    ],
                                                                  ),
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child:
                                                                        Container(
                                                                      padding:
                                                                          const EdgeInsets.fromLTRB(
                                                                              0,
                                                                              0,
                                                                              0,
                                                                              10),
                                                                      child:
                                                                          Container(
                                                                        width: double
                                                                            .infinity,
                                                                        padding: const EdgeInsets.symmetric(
                                                                            vertical:
                                                                                5,
                                                                            horizontal:
                                                                                8),
                                                                        decoration: const BoxDecoration(
                                                                            gradient:
                                                                                LinearGradient(colors: [
                                                                              Colors.lightBlueAccent,
                                                                              const Color(0xFF0277E3)
                                                                            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                                                                            borderRadius: const BorderRadius.all(Radius.circular(15))),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              SelectableText(
                                                                            "${snapshot.data.supervise[idx]['faculty']['front_title']} ${snapshot.data.supervise[idx]['faculty']['first_name']} ${snapshot.data.supervise[idx]['faculty']['last_name']} ${snapshot.data.supervise[idx]['faculty']['rear_title']}",
                                                                            style: const TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 20,
                                                                                fontFamily: 'OpenSans',
                                                                                fontWeight: FontWeight.w600),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    margin: const EdgeInsetsDirectional
                                                                            .only(
                                                                        bottom:
                                                                            10),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            const Text(
                                                                              "Date : ",
                                                                              style: TextStyle(color: Color(0xff3A4856), fontSize: 16, fontFamily: 'OpenSans', fontWeight: FontWeight.bold),
                                                                            ),
                                                                            Text(
                                                                              "(${(snapshot.data.supervise[idx]['created_at']).substring(0, 10)})",
                                                                              style: const TextStyle(color: Color(0xff3A4856), fontSize: 16, fontFamily: 'OpenSans'),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            const Text(
                                                                              "Status : ",
                                                                              style: TextStyle(color: Color(0xff3A4856), fontSize: 16, fontFamily: 'OpenSans', fontWeight: FontWeight.bold),
                                                                            ),
                                                                            (snapshot.data.supervise[idx]['status'] != null)
                                                                                ? const Icon(Icons.check_circle_rounded, color: Colors.greenAccent)
                                                                                : const Icon(
                                                                                    Icons.timelapse_rounded,
                                                                                    color: Colors.grey,
                                                                                  ),
                                                                            (snapshot.data.supervise[idx]['approval_date'] != null)
                                                                                ? Text(
                                                                                    snapshot.data.supervise[idx]['approval_date'],
                                                                                    style: const TextStyle(color: Color(0xff3A4856), fontSize: 16, fontFamily: 'OpenSans'),
                                                                                  )
                                                                                : const Text("")
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  const Text(
                                                                    "Topic :",
                                                                    style: const TextStyle(
                                                                        color: Color(
                                                                            0xff3A4856),
                                                                        fontSize:
                                                                            16,
                                                                        fontFamily:
                                                                            'OpenSans',
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  Flexible(
                                                                    flex: 1,
                                                                    child:
                                                                        Container(
                                                                      margin:
                                                                          const EdgeInsets.fromLTRB(
                                                                              8,
                                                                              3,
                                                                              8,
                                                                              10),
                                                                      child:
                                                                          Card(
                                                                        elevation:
                                                                            2,
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              Scrollbar(
                                                                            isAlwaysShown:
                                                                                true,
                                                                            child:
                                                                                SingleChildScrollView(
                                                                              physics: const BouncingScrollPhysics(),
                                                                              child: SelectableText(
                                                                                snapshot.data.supervise[idx]['topic'],
                                                                                style: const TextStyle(color: Color(0xff3A4856), fontSize: 16, fontFamily: 'OpenSans'),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const Text(
                                                                    "Message :",
                                                                    style: const TextStyle(
                                                                        color: Color(
                                                                            0xff3A4856),
                                                                        fontSize:
                                                                            16,
                                                                        fontFamily:
                                                                            'OpenSans',
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  Flexible(
                                                                    flex: 1,
                                                                    child:
                                                                        Container(
                                                                      margin:
                                                                          const EdgeInsets.fromLTRB(
                                                                              8,
                                                                              3,
                                                                              8,
                                                                              10),
                                                                      child:
                                                                          Card(
                                                                        elevation:
                                                                            2,
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              Scrollbar(
                                                                            isAlwaysShown:
                                                                                true,
                                                                            child:
                                                                                SingleChildScrollView(
                                                                              physics: const BouncingScrollPhysics(),
                                                                              child: SelectableText(
                                                                                snapshot.data.supervise[idx]['message'],
                                                                                style: const TextStyle(color: Color(0xff3A4856), fontSize: 16, fontFamily: 'OpenSans'),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                        primary:
                                                                            Colors
                                                                                .lightBlueAccent,
                                                                        elevation:
                                                                            0,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(15))),
                                                                    child:
                                                                        const Text(
                                                                      "OK",
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontFamily:
                                                                              'Helvetica'),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      if (Get.isBottomSheetOpen !=
                                                                          null) {
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
                                                      shape:
                                                          const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .vertical(
                                                          top: Radius.circular(
                                                              20),
                                                        ),
                                                      ),
                                                      clipBehavior: Clip
                                                          .antiAliasWithSaveLayer);
                                                },
                                                child: Row(
                                                  children: [
                                                    (snapshot.data.supervise[
                                                                    idx]
                                                                ['status'] !=
                                                            null)
                                                        ? const Icon(
                                                            Icons
                                                                .check_circle_rounded,
                                                            color: Colors
                                                                .greenAccent)
                                                        : const Icon(
                                                            Icons
                                                                .timelapse_rounded,
                                                            color: Colors.grey,
                                                          ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                8, 2, 2, 2),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                snapshot.data
                                                                        .supervise[idx]
                                                                    ['topic'],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    color: Colors
                                                                            .grey[
                                                                        900])),
                                                            Text(
                                                              "(${(snapshot.data.supervise[idx]['created_at']).substring(0, 10)})",
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black54),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                          return Expanded(child: Container());
                                        }),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  }),
            );
          }
        });
  }
}
