import 'dart:convert';
import 'dart:io';
import 'package:arsys/controllers/user_controller.dart';
import 'package:arsys/faculty/controllers/supervision_controller.dart';
import 'package:arsys/student/controllers/event_controller.dart';
import 'package:arsys/student/controllers/research_controller.dart';
import 'package:arsys/student/models/event_applicant.dart';
import 'package:arsys/student/models/research.dart';
import 'package:arsys/student/models/spv.dart';
import 'package:arsys/student/models/supervisor_score.dart';
import 'package:arsys/views/appbar.dart';
import 'package:flutter/material.dart';
import 'package:arsys/network/network.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class FacultyEventSupervisedStudent extends StatefulWidget {
  @override
  _FacultyEventSupervisedStudentState createState() =>
      _FacultyEventSupervisedStudentState();
}

class _FacultyEventSupervisedStudentState
    extends State<FacultyEventSupervisedStudent> {
  final researchC = Get.find<SupervisionController>();
  final eventC = Get.find<EventController>();
  final userC = Get.find<UserController>();
  int eventId = Get.arguments;

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
      appBar: SecondAppBarBuilder("Event Applicant"),
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
                          'Supervised Student',
                          style: TextStyle(
                              color: Color(0xff3A4856),
                              fontSize: 20,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Flexible(
                        child: FutureBuilder<dynamic>(
                            future:
                                eventC.getSupervisedApplicantByEvent(eventId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (!snapshot.hasData) {
                                return const Expanded(
                                    child: Center(
                                        child: Text('No Supervised Student')));
                              } else {
                                List<EventApplicant>? applicants =
                                    List.empty(growable: true);

                                applicants = snapshot.data;
                                var supervisedApplicants = applicants
                                    ?.where((applicant) => applicant.research!
                                        .isSupervisor(userC.getId()))
                                    .cast<EventApplicant?>();

                                // print(applicant);
                                // print(applicants?.where((applicant) => applicant
                                //     .research!.supervisor!
                                //     .where((faculty) => faculty.id == 3)
                                //     .isNotEmpty));

                                return Scrollbar(
                                  interactive: true,
                                  child: ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: supervisedApplicants?.length,
                                      itemBuilder: (context, index) {
                                        EventApplicant? applicant =
                                            supervisedApplicants
                                                ?.elementAt(index);
                                        SPV? spv = applicant?.research
                                            ?.getSPV(userC.getId());
                                        return Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 3),
                                            child: Card(
                                              elevation: 2,
                                              color: Colors.white,
                                              // color: researchC.cardColorBuilder(
                                              //     applicant[index].milestone
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
                                                                  "${applicant?.research?.researchCode}",
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
                                                                  "${applicant?.research?.student?.getFullName()}",
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
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
                                                                  "${applicant?.research?.student?.studentNumber} - ${applicant?.research?.student?.specialization}",
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
                                                                        .center,
                                                                children: [
                                                                  const Text(
                                                                      "MARK",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontFamily:
                                                                              'OpenSans',
                                                                          color:
                                                                              Color(0xff3A4856))),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            5),
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () {
                                                                        if (spv !=
                                                                            null) {
                                                                          inputMarkModal(
                                                                              applicant,
                                                                              spv);
                                                                        }
                                                                      },
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
                                                                              "${applicant?.research?.getSupervisorScore(userC.getId()) ?? 'Unmarked'}",
                                                                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'OpenSans', color: Color(0xff3A4856)))),
                                                                    ),
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
                                                                  "${applicant?.research?.title}",
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
                                                  )),
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

  void inputMarkModal(EventApplicant? applicant, SPV? spv) {
    TextEditingController markController = TextEditingController();
    TextEditingController notesController = TextEditingController();
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(20),
      title: 'Input Mark',
      titleStyle: const TextStyle(
          fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xff3A4856)),
      titlePadding: const EdgeInsets.only(top: 15),
      content: Column(
        children: [
          Form(
            autovalidateMode: AutovalidateMode.always,
            child: TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter mark';
                } else if (int.parse(value) < 0 || int.parse(value) > 400) {
                  return 'Mark must be between 0 and 400';
                }
                return null;
              },
              maxLength: 3,
              controller: markController,
              decoration: const InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                labelText: "Input mark",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                filled: true,
              ),
            ),
          ),
          Form(
            autovalidateMode: AutovalidateMode.always,
            child: TextFormField(
              controller: notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                labelText: "Input seminar's notes",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                filled: true,
              ),
            ),
          ),
        ],
      ),
      textCancel: 'Cancel',
      textConfirm: 'Submit',
      confirm: InkWell(
        onTap: () {
          eventC.setSupervisorMark(spv!.id, applicant!.eventId, applicant.id,
              int.parse(markController.text), notesController.text);
          Get.back();
          setState(() {});
        },
        child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(8.0)),
            child: const Text(
              "Submit",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold),
            )),
      ),
      cancel: InkWell(
        onTap: (() => Get.back()),
        child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(8.0)),
            child: const Text(
              "Cancel",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold),
            )),
      ),
      radius: 15,
    );
  }

  Future refreshResearches() async {
    researchC.researches.clear();
    researchC.researchListUser();
    await Future.delayed(Duration(seconds: 2));
    setState(() {});
  }
}
