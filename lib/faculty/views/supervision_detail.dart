import 'dart:convert';
import 'dart:io';
import 'package:arsys/controllers/user_controller.dart';
import 'package:arsys/faculty/controllers/supervision_controller.dart';
import 'package:arsys/faculty/models/faculty.dart';
import 'package:arsys/faculty/views/profile.dart';
import 'package:arsys/student/controllers/event_controller.dart';
import 'package:arsys/student/controllers/research_controller.dart';
import 'package:arsys/student/models/defense_approval.dart';
import 'package:arsys/student/models/event_applicant.dart';
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

class SupervisionResearchDetail extends StatefulWidget {
  @override
  _SupervisionResearchDetailState createState() =>
      _SupervisionResearchDetailState();
}

class _SupervisionResearchDetailState extends State<SupervisionResearchDetail> {
  final researchC = Get.find<SupervisionController>();
  final eventC = Get.find<EventController>();
  final profileC = Get.find<UserController>();
  final researchId = Get.arguments;
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
        Get.toNamed('/faculty-home');
      }
      // if (_selectedNavbar == 1) () => Get.back();
      if (_selectedNavbar == 2) {
        Get.toNamed('/faculty-event');
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
      appBar: SecondAppBarBuilder("Supervision"),
      body: Platform.isIOS
          ? Container()
          : SafeArea(
              child: Container(
                  padding: const EdgeInsets.all(15),
                  child: FutureBuilder<dynamic>(
                      future: researchC.researchById(researchId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          research = researchC.research;
                          return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                            text:
                                                research.student?.getFullName(),
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
                                            text: "${research.researchCode}",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'OpenSans',
                                                fontWeight: FontWeight.bold,
                                                color: Colors.lightBlueAccent),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                abstractModal(context);
                                              }),
                                      ),
                                    ],
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: double.infinity,
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
                                            color: Colors.transparent,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Expanded(
                                                child: Scrollbar(
                                                  child: ListView(
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    children: [
                                                      const Center(
                                                        child: Text(
                                                            "Research Data",
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                fontFamily:
                                                                    'OpenSans',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Color(
                                                                    0xff3A4856))),
                                                      ),
                                                      const Divider(
                                                        thickness: 1,
                                                        indent: 10,
                                                        endIndent: 10,
                                                      ),
                                                      const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 10.0),
                                                        child: Center(
                                                          child: Text(
                                                            "Supervisor",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Helvetica',
                                                                color: Colors
                                                                    .black54),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  13, 0, 13, 0),
                                                          child:
                                                              ListView.builder(
                                                                  shrinkWrap:
                                                                      true,
                                                                  physics:
                                                                      const NeverScrollableScrollPhysics(),
                                                                  itemCount: research
                                                                      .supervisor
                                                                      .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return Container(
                                                                        margin: const EdgeInsets.only(
                                                                            bottom:
                                                                                5),
                                                                        padding:
                                                                            const EdgeInsets.all(
                                                                                8),
                                                                        decoration: BoxDecoration(
                                                                            color: Colors.blueGrey[
                                                                                50],
                                                                            borderRadius: BorderRadius.circular(
                                                                                10.0)),
                                                                        child: Text(
                                                                            "${research.supervisor[index].getFullNameAndTitle()}",
                                                                            style: const TextStyle(
                                                                                fontSize: 16,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontFamily: 'Helvetica',
                                                                                color: Color(0xff3A4856))));
                                                                  }),
                                                        ),
                                                      ),
                                                      const Divider(
                                                        thickness: 1,
                                                        indent: 10,
                                                        endIndent: 10,
                                                      ),
                                                      SizedBox(
                                                        width: double.infinity,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              const Text(
                                                                  "Approval",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Helvetica',
                                                                      color: Colors
                                                                          .black54)),
                                                              (research.defenseApproval ==
                                                                      null)
                                                                  ? const Text(
                                                                      "No approval",
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Helvetica',
                                                                          color:
                                                                              Colors.black87))
                                                                  : Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child: SizedBox(
                                                                          width: double.infinity,
                                                                          child: ListView.builder(
                                                                              shrinkWrap: true,
                                                                              physics: const NeverScrollableScrollPhysics(),
                                                                              itemCount: research.defenseApproval.length,
                                                                              itemBuilder: (context, index) {
                                                                                return Container(
                                                                                  margin: const EdgeInsets.only(bottom: 5),
                                                                                  child: IntrinsicHeight(
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Text("${research.defenseApproval[index].defenseModel.description}", style: TextStyle(fontSize: 16, fontFamily: "OpenSans")),
                                                                                        const VerticalDivider(
                                                                                          thickness: 2,
                                                                                          indent: 2,
                                                                                          endIndent: 2,
                                                                                        ),
                                                                                        Text(
                                                                                          "${research.defenseApproval[index].approver.code}",
                                                                                          style: TextStyle(fontSize: 16, fontFamily: "OpenSans"),
                                                                                        ),
                                                                                        const VerticalDivider(
                                                                                          thickness: 2,
                                                                                          indent: 2,
                                                                                          endIndent: 2,
                                                                                        ),
                                                                                        researchC.approvalIcon(research.defenseApproval[index].decision, size: 16),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              })),
                                                                    ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: double.infinity,
                                                        child: ListView.builder(
                                                            physics:
                                                                const NeverScrollableScrollPhysics(),
                                                            shrinkWrap: true,
                                                            itemCount: research
                                                                .defenseApproval
                                                                .where((approval) =>
                                                                    approval.decision ==
                                                                        false &&
                                                                    approval.approverId ==
                                                                        profileC
                                                                            .user
                                                                            .id)
                                                                .length,
                                                            itemBuilder:
                                                                (context, i) {
                                                              var approval = research
                                                                  .defenseApproval
                                                                  .where((element) =>
                                                                      element.decision ==
                                                                          false &&
                                                                      element.approverId ==
                                                                          profileC
                                                                              .user
                                                                              .id)
                                                                  .elementAt(i);
                                                              return Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        10,
                                                                        10,
                                                                        10,
                                                                        0),
                                                                child: SizedBox(
                                                                  width: double
                                                                      .infinity,
                                                                  child:
                                                                      ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                        primary: Colors
                                                                            .lightBlueAccent
                                                                            .shade700,
                                                                        elevation:
                                                                            0,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(15))),
                                                                    child: Text(
                                                                      "Approve ${approval.defenseModel?.description}",
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontFamily:
                                                                              'Helvetica',
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      Get.defaultDialog(
                                                                          contentPadding: EdgeInsets.all(15),
                                                                          title: 'Confirmation',
                                                                          titleStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xff3A4856)),
                                                                          titlePadding: EdgeInsets.only(top: 15),
                                                                          content: Text(
                                                                            "Approve this ${approval.defenseModel?.description}",
                                                                            style:
                                                                                TextStyle(color: Color(0xff3A4856)),
                                                                          ),
                                                                          textCancel: 'Cancel',
                                                                          textConfirm: 'Yes',
                                                                          confirmTextColor: Colors.white,
                                                                          radius: 15,
                                                                          onConfirm: () {
                                                                            researchC.approveDefense(research,
                                                                                approval.id);
                                                                            refreshResearch();

                                                                            Get.back();
                                                                          });
                                                                    },
                                                                  ),
                                                                ),
                                                              );
                                                            }),
                                                      ),
                                                      SizedBox(
                                                        width: double.infinity,
                                                        child: FutureBuilder<
                                                                dynamic>(
                                                            future: eventC
                                                                .getEventApplicantByResearch(
                                                                    research
                                                                        .id),
                                                            builder: (context,
                                                                snapshot) {
                                                              if (snapshot
                                                                      .connectionState ==
                                                                  ConnectionState
                                                                      .waiting) {
                                                                return const Center(
                                                                  child:
                                                                      CircularProgressIndicator(),
                                                                );
                                                              } else if (!snapshot
                                                                  .hasData) {
                                                                return const Expanded(
                                                                    child: Center(
                                                                        child: Text(
                                                                            'No Event')));
                                                              } else {
                                                                return SizedBox(
                                                                  width: double
                                                                      .infinity,
                                                                  child: Column(
                                                                    children: [
                                                                      const Divider(
                                                                          thickness:
                                                                              1,
                                                                          indent:
                                                                              10,
                                                                          endIndent:
                                                                              10),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.symmetric(horizontal: 10),
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            const Text("Applied Event",
                                                                                style: TextStyle(fontFamily: 'Helvetica', color: Colors.black54)),
                                                                            Padding(
                                                                              padding: EdgeInsets.all(8.0),
                                                                              child: ListView.builder(
                                                                                  shrinkWrap: true,
                                                                                  physics: const NeverScrollableScrollPhysics(),
                                                                                  itemCount: snapshot.data.length,
                                                                                  itemBuilder: (context, index) {
                                                                                    return Container(
                                                                                        margin: EdgeInsets.only(bottom: 10),
                                                                                        child: Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Container(
                                                                                                margin: EdgeInsets.only(bottom: 5),
                                                                                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                                                                                decoration: BoxDecoration(
                                                                                                  borderRadius: BorderRadius.circular(10.0),
                                                                                                  color: Colors.blueGrey[50],
                                                                                                ),
                                                                                                child: Text("${snapshot.data[index].event.eventName}",
                                                                                                    style: const TextStyle(
                                                                                                      fontSize: 16,
                                                                                                      fontWeight: FontWeight.w600,
                                                                                                      fontFamily: 'Helvetica',
                                                                                                      color: Color(0xff3A4856),
                                                                                                    ))),
                                                                                            Container(
                                                                                                margin: EdgeInsets.only(bottom: 5),
                                                                                                padding: EdgeInsets.symmetric(horizontal: 8),
                                                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
                                                                                                child: Wrap(
                                                                                                  direction: Axis.horizontal,
                                                                                                  crossAxisAlignment: WrapCrossAlignment.end,
                                                                                                  spacing: 8,
                                                                                                  children: [
                                                                                                    const Icon(
                                                                                                      Icons.date_range_rounded,
                                                                                                      color: Colors.redAccent,
                                                                                                    ),
                                                                                                    Text(
                                                                                                      "${snapshot.data[index].session.time}, ${snapshot.data[index].event.getDateInFormat(date: snapshot.data[index].event.eventDate, format: "dd MMM yyyy")}",
                                                                                                      style: const TextStyle(
                                                                                                        fontSize: 16,
                                                                                                        fontFamily: 'Helvetica',
                                                                                                        color: Color(0xff3A4856),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                )),
                                                                                            Container(
                                                                                                padding: EdgeInsets.symmetric(horizontal: 8),
                                                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
                                                                                                child: Wrap(
                                                                                                  direction: Axis.horizontal,
                                                                                                  crossAxisAlignment: WrapCrossAlignment.end,
                                                                                                  alignment: WrapAlignment.start,
                                                                                                  runAlignment: WrapAlignment.start,
                                                                                                  spacing: 8,
                                                                                                  children: [
                                                                                                    const Icon(
                                                                                                      Icons.person_search_rounded,
                                                                                                      color: Colors.lightBlueAccent,
                                                                                                    ),
                                                                                                    const Text(
                                                                                                      "Examiner",
                                                                                                      style: TextStyle(
                                                                                                        fontSize: 16,
                                                                                                        fontFamily: 'OpenSans',
                                                                                                        fontWeight: FontWeight.bold,
                                                                                                        color: Colors.lightBlueAccent,
                                                                                                      ),
                                                                                                    ),
                                                                                                    Text(
                                                                                                      "${snapshot.data[index].getExaminerCode()}",
                                                                                                      style: const TextStyle(
                                                                                                        fontSize: 16,
                                                                                                        fontFamily: 'Helvetica',
                                                                                                        color: Color(0xff3A4856),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                )),
                                                                                          ],
                                                                                        ));
                                                                                  }),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              }
                                                              ;
                                                            }),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
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
        items: const [
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
                                          child: Center(
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
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer);
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
                            const Text(
                              'Title',
                              style: TextStyle(
                                  color: Color(0xff3A4856),
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
    researchC.researchById(researchId);
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
