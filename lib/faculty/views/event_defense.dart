// TODO Approval
// Supervision
// Review
// Upload

import 'dart:convert';
import 'dart:io';
import 'package:arsys/controllers/user_controller.dart';
import 'package:arsys/student/controllers/event_controller.dart';
import 'package:arsys/student/controllers/research_controller.dart';
import 'package:arsys/student/models/defense_examiner.dart';
import 'package:arsys/student/models/event.dart';
import 'package:arsys/student/models/event_applicant.dart';
import 'package:arsys/student/models/examiner.dart';
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

class FacultyEventDefense extends StatefulWidget {
  @override
  _FacultyEventDefenseState createState() => _FacultyEventDefenseState();
}

class _FacultyEventDefenseState extends State<FacultyEventDefense> {
  final researchC = Get.find<ResearchController>();
  final eventC = Get.find<EventController>();
  final userC = Get.find<UserController>();
  late Event event = Get.arguments;
  ScrollController scrollC = new ScrollController();
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
      // if (_selectedNavbar == 1) () => Get.back();
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
      backgroundColor: const Color(0xFFF0F9FE),
      appBar: SecondAppBarBuilder("Event Applicants"),
      body: Platform.isIOS
          ? Container()
          : SafeArea(
              child: Container(
                  padding: const EdgeInsets.all(15),
                  child: eventApplicant(context))),
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

  Column eventApplicant(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                      text:
                          "${event.eventName} - ${event.getDateInFormat(date: event.eventDate, format: "dd MMM yyyy")}",
                      style: const TextStyle(
                          fontSize: 24,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.bold,
                          color: Color(0xff3A4856)),
                      recognizer: TapGestureRecognizer()..onTap = () {}),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Expanded(
          //   flex: 2,
          //   child: informationCard(context),
          // ),
          Expanded(
              child: FutureBuilder<dynamic>(
                  future: eventC.getEventApplicantByEvent(event.id ?? -1),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (!snapshot.hasData) {
                      return const Expanded(
                          child: Center(child: Text('No Upcoming Event')));
                    } else {
                      return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            EventApplicant? applicant = snapshot.data[index];
                            return FutureBuilder<dynamic>(
                                future: researchC
                                    .researchById(applicant?.researchId ?? -1),
                                builder: (context, researchSnapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (researchSnapshot.hasData) {
                                    Research research = researchSnapshot.data;
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
                                            color: Colors.transparent,
                                            child: InkWell(
                                              splashColor:
                                                  Colors.lightBlue[100],
                                              onTap: () {},
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                            "${research.student?.getFullName()}",
                                                            style: const TextStyle(
                                                                fontSize: 18,
                                                                fontFamily:
                                                                    'OpenSans',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Color(
                                                                    0xff3A4856))),
                                                        Text("${index + 1}",
                                                            style: const TextStyle(
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    'OpenSans',
                                                                color: Color(
                                                                    0xff3A4856))),
                                                      ],
                                                    ),
                                                    Text(
                                                        "${research.student?.studentNumber} - ${research.student?.specialization} - ${research.getSupervisorCode()}",
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                'Helvetica',
                                                            color: Colors
                                                                .black54)),
                                                    const Divider(
                                                      thickness: 1,
                                                      indent: 5,
                                                      endIndent: 5,
                                                    ),
                                                    defenseSchedule(
                                                        snapshot, index),
                                                    const Divider(
                                                      thickness: 1,
                                                      indent: 5,
                                                      endIndent: 5,
                                                    ),
                                                    defenseExaminer(
                                                        snapshot, index),
                                                    (research.isSupervisor(userC
                                                                .getId()) &&
                                                            applicant
                                                                    ?.getExaminerCode() !=
                                                                "-")
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    10,
                                                                    0,
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
                                                                child:
                                                                    const Text(
                                                                  "Make a presence",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontFamily:
                                                                          'Helvetica',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                onPressed: () {
                                                                  setState(
                                                                      () {});
                                                                  presenceModal(
                                                                      context,
                                                                      applicant!,
                                                                      research);
                                                                },
                                                              ),
                                                            ),
                                                          )
                                                        : Container(),
                                                    defenseScore(
                                                        applicant, research)
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ));
                                  } else {
                                    return Container();
                                  }
                                });
                          });
                    }
                    ;
                  })),
        ]);
  }

  Padding defenseScore(EventApplicant? applicant, Research? research) {
    int? score;
    String? role;
    if (applicant!.isExaminer(userC.getId())) {
      score = applicant.getExaminerByUser(userC.getId())?.score?.mark;
      role = 'examiner';
    }
    if (research!.isSupervisor(userC.getId())) {
      score = research.getSupervisorScore(userC.getId());
      role = 'supervisor';
    }
    if (score == -1) {
      score = null;
    }
    return Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Your Mark ",
              style: TextStyle(
                  color: Color(0xff3A4856),
                  fontSize: 14,
                  fontFamily: 'OpenSans'),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8.0)),
              child: InkWell(
                child: Text(
                  // ${applicant.get getApplicantScore(applicant.id) ??
                  "${score ?? 'Unmarked'}",
                  style: const TextStyle(
                      color: Color.fromARGB(255, 37, 45, 54),
                      fontSize: 20,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  if (role == 'supervisor') {
                    print("execute submit supervisor");
                  } else if (role == 'examiner') {
                    DefenseExaminer examiner =
                        applicant.getExaminerByUser(userC.getId())!;
                    if (examiner.presence) {
                      inputExaminerMarkModal(examiner);
                      // eventC.setExaminerMark(examinerId, mark, defenseNotes)
                    } else {
                      if (!Get.isSnackbarOpen) {
                        Get.showSnackbar(const GetSnackBar(
                          message: "You must be presence before input mark",
                          duration: Duration(seconds: 2),
                          icon: Icon(
                            Icons.warning_rounded,
                            color: Colors.white,
                          ),
                        ));
                      }
                    }
                  } else {
                    return null;
                  }
                },
              ),
            ),
          ],
        ));
  }

  SizedBox defenseExaminer(AsyncSnapshot<dynamic> snapshot, int index) {
    EventApplicant? applicant = snapshot.data[index];
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            const Center(
              child: Text("Examiner",
                  style: TextStyle(
                      fontFamily: 'Helvetica', color: Colors.black54)),
            ),
            applicant?.getExaminerCode() == "-"
                ? const Text("This event is not scheduled yet.",
                    style: TextStyle(
                        fontFamily: 'Helvetica', color: Colors.black87))
                : ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: applicant?.examiner?.length,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 8),
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(8.0)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                (applicant?.examiner?[i].presence == true)
                                    ? const Icon(
                                        Icons.check_circle_rounded,
                                        color: Colors.greenAccent,
                                        size: 20,
                                      )
                                    : const Icon(
                                        Icons.do_disturb_alt_rounded,
                                        color: Colors.redAccent,
                                        size: 20,
                                      ),
                                Flexible(
                                  child: Text(
                                      " ${applicant?.examiner?[i].faculty?.getFullNameAndTitle()} ",
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'OpenSans',
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xff3A4856))),
                                ),
                              ],
                            )),
                      );
                    }),
          ],
        ),
      ),
    );
  }

  SizedBox defenseSchedule(AsyncSnapshot<dynamic> snapshot, int index) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Schedule",
                style:
                    TextStyle(fontFamily: 'Helvetica', color: Colors.black54)),
            snapshot.data[index].getExaminerCode() == "-"
                ? const Text("This event is not scheduled yet.",
                    style: TextStyle(
                        fontFamily: 'Helvetica', color: Colors.black87))
                : applicantSchedule(snapshot, index),
          ],
        ),
      ),
    );
  }

  SizedBox applicantSchedule(AsyncSnapshot<dynamic> snapshot, int index) {
    if (true) {
      return SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: const EdgeInsets.all(5),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
                child: Wrap(
                  direction: Axis.horizontal,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Wrap(
                      direction: Axis.horizontal,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 5,
                      children: [
                        const Icon(
                          Icons.date_range_rounded,
                          color: Colors.redAccent,
                        ),
                        Text("${snapshot.data[index].session.time}",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Helvetica',
                                color: Color(0xff3A4856))),
                      ],
                    ),
                    Wrap(
                      direction: Axis.horizontal,
                      spacing: 5,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const Icon(
                          Icons.link_rounded,
                          color: Colors.greenAccent,
                        ),
                        InkWell(
                          onTap: () {
                            Clipboard.setData(new ClipboardData(
                                text: snapshot.data[index].space.link));
                            Get.snackbar("Text copied!",
                                "Zoom Link has been copied to your clipboard",
                                snackPosition: SnackPosition.BOTTOM);
                          },
                          child: const Text("Meeting Link",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Helvetica',
                                  color: Color(0xff3A4856))),
                        ),
                      ],
                    ),
                    Wrap(
                      direction: Axis.horizontal,
                      spacing: 5,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const Icon(
                          Icons.video_call_rounded,
                          color: Colors.lightBlueAccent,
                        ),
                        InkWell(
                          onTap: () {
                            Clipboard.setData(ClipboardData(
                                text: snapshot.data[index].space.space));
                            Get.snackbar("Text copied!",
                                "Zoom ID has been copied to your clipboard",
                                snackPosition: SnackPosition.BOTTOM);
                          },
                          child: Text("${snapshot.data[index].space.space}",
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Helvetica',
                                  color: Color(0xff3A4856))),
                        ),
                      ],
                    ),
                    Wrap(
                      direction: Axis.horizontal,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 5,
                      children: [
                        const Icon(
                          Icons.lock_open_rounded,
                          color: Colors.lightBlueAccent,
                        ),
                        InkWell(
                          onTap: () {
                            Clipboard.setData(new ClipboardData(
                                text: snapshot.data[index].space.passcode));
                            Get.snackbar("Text copied!",
                                "Meeting password has been copied to your clipboard",
                                snackPosition: SnackPosition.BOTTOM);
                          },
                          child: Text("${snapshot.data[index].space.passcode}",
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Helvetica',
                                  color: Color(0xff3A4856))),
                        ),
                      ],
                    ),
                    const VerticalDivider(),
                  ],
                )),
          ],
        ),
      );
    } else if (snapshot.data[index].event.eventType == Type.finalDefense.id ||
        snapshot.data[index].event.eventType == Type.eeSeminar.id) {
      return SizedBox(
        width: double.infinity,
        child: ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemCount: snapshot.data[index].event.room.length,
            itemBuilder: (context, i) {
              return Container(
                  padding: const EdgeInsets.all(5),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
                  child: Wrap(
                    direction: Axis.horizontal,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Wrap(
                        direction: Axis.horizontal,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 5,
                        children: [
                          const Icon(
                            Icons.date_range_rounded,
                            color: Colors.redAccent,
                          ),
                          Text(
                              "${snapshot.data[index].event.room[i].session.time}",
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Helvetica',
                                  color: Color(0xff3A4856))),
                        ],
                      ),
                      Wrap(
                        direction: Axis.horizontal,
                        spacing: 5,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const Icon(
                            Icons.link_rounded,
                            color: Colors.greenAccent,
                          ),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(new ClipboardData(
                                  text: snapshot
                                      .data[index].event.room[i].space.link));
                              Get.snackbar("Text copied!",
                                  "Zoom Link has been copied to your clipboard",
                                  snackPosition: SnackPosition.BOTTOM);
                            },
                            child: const Text("Meeting Link",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'Helvetica',
                                    color: Color(0xff3A4856))),
                          ),
                        ],
                      ),
                      Wrap(
                        direction: Axis.horizontal,
                        spacing: 5,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const Icon(
                            Icons.video_call_rounded,
                            color: Colors.lightBlueAccent,
                          ),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(ClipboardData(
                                  text: snapshot
                                      .data[index].event.room[i].space.space));
                              Get.snackbar("Text copied!",
                                  "Zoom ID has been copied to your clipboard",
                                  snackPosition: SnackPosition.BOTTOM);
                            },
                            child: Text(
                                "${snapshot.data[index].event.room[i].space.space}",
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'Helvetica',
                                    color: Color(0xff3A4856))),
                          ),
                        ],
                      ),
                      Wrap(
                        direction: Axis.horizontal,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 5,
                        children: [
                          const Icon(
                            Icons.lock_open_rounded,
                            color: Colors.lightBlueAccent,
                          ),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(new ClipboardData(
                                  text: snapshot.data[index].event.room[i].space
                                      .passcode));
                              Get.snackbar("Text copied!",
                                  "Meeting password has been copied to your clipboard",
                                  snackPosition: SnackPosition.BOTTOM);
                            },
                            child: Text(
                                "${snapshot.data[index].event.room[i].space.passcode}",
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'Helvetica',
                                    color: Color(0xff3A4856))),
                          ),
                        ],
                      ),
                      const VerticalDivider(),
                    ],
                  ));
            }),
      );
    } else {
      return SizedBox();
    }
  }

  void inputExaminerMarkModal(DefenseExaminer examiner) {
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
                labelText: "Input defense's notes",
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
          eventC.setExaminerMark(examiner.id, int.parse(markController.text),
              notesController.text);
          setState(() {});
          Get.back();
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

  Future<dynamic> presenceModal(
      BuildContext context, EventApplicant applicant, Research research) {
    List<bool>? _isSelected = List<bool>.empty();
    _isSelected = applicant.getExaminerDefensePresence();
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          print("CHECK ${research.title}");
          if (research.isSupervisor(userC.getId())) {
            return StatefulBuilder(builder: (context, StateSetter modalState) {
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
                          const Text('Make a presence',
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
                              borderRadius: BorderRadius.circular(10)),
                          child: ClipPath(
                            clipper: ShapeBorderClipper(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                            child: Scrollbar(
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Column(
                                    children: [
                                      const Center(
                                        child: Text(
                                            "Tap on icon to change a presence state and hit submit",
                                            style: TextStyle(
                                                fontFamily: 'Helvetica',
                                                color: Colors.black54)),
                                      ),
                                      const Divider(
                                        thickness: 1,
                                        indent: 5,
                                        endIndent: 5,
                                      ),
                                      ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: applicant.examiner?.length,
                                          itemBuilder: (context, i) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 8),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0)),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      ToggleButtons(
                                                        children: [
                                                          (_isSelected![i] ==
                                                                  true)
                                                              ? const Icon(
                                                                  Icons
                                                                      .check_circle_rounded,
                                                                  color: Colors
                                                                      .greenAccent,
                                                                  size: 20,
                                                                )
                                                              : const Icon(
                                                                  Icons
                                                                      .do_disturb_alt_rounded,
                                                                  color: Colors
                                                                      .redAccent,
                                                                  size: 20,
                                                                )
                                                        ],
                                                        isSelected: [
                                                          _isSelected[i]
                                                        ],
                                                        onPressed: (_) {
                                                          modalState(() {
                                                            _isSelected![i] =
                                                                !_isSelected[i];
                                                          });
                                                        },
                                                        renderBorder: false,
                                                        selectedColor: Colors
                                                            .lightGreen[50],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(90),
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                            " ${applicant.examiner?[i].faculty?.getFullNameAndTitle()} ",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            softWrap: false,
                                                            style: const TextStyle(
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    'OpenSans',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: const Color(
                                                                    0xff3A4856))),
                                                      ),
                                                    ],
                                                  )),
                                            );
                                          }),
                                    ],
                                  )),
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
                          "SUBMIT",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          List<Examiner>? examiners = applicant.examiner;
                          print("PRESENCE SUMBITTED");
                          await eventC.setPresenceDefenseExaminer(
                              _isSelected!, examiners);
                          setState(() {});
                          modalState() {}
                          Get.back();
                        },
                      ),
                    ],
                  ),
                ),
              );
            });
          } else {
            return Container();
          }
        },
        shape: const RoundedRectangleBorder(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer);
  }

  Future refreshResearch() async {
    researchC.researchById(event.id ?? -1);
    // await Future.delayed(Duration(seconds: 2));
    setState(() {});
  }
}
