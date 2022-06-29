// TODO Approval
// Supervision
// Review
// Upload

import 'dart:convert';
import 'dart:io';
import 'package:arsys/student/controllers/event_controller.dart';
import 'package:arsys/student/controllers/research_controller.dart';
import 'package:arsys/student/models/event_applicant.dart';
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

class StudentResearchEventReport extends StatefulWidget {
  @override
  _StudentResearchEventReportState createState() =>
      _StudentResearchEventReportState();
}

class _StudentResearchEventReportState
    extends State<StudentResearchEventReport> {
  final researchC = Get.find<ResearchController>();
  final eventC = Get.find<EventController>();
  final int researchId = Get.arguments;
  EventApplicant? eventApplicant;
  var research;
  ScrollController scrollC = new ScrollController();
  TextEditingController textAreaController = TextEditingController();
  String? _selected = "Choose event";
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
      appBar: SecondAppBarBuilder("Event Reports"),
      body: Platform.isIOS
          ? Container()
          : SafeArea(
              child: Padding(
              padding: const EdgeInsets.all(15),
              child: FutureBuilder<dynamic>(
                  future: researchC.researchById(researchId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      research = researchC.research;
                      return SingleChildScrollView(
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                          text: research.title,
                                          style: const TextStyle(
                                              fontSize: 20,
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
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FutureBuilder<dynamic>(
                                    future:
                                        eventC.getEventApplicant(researchId),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else if (!snapshot.hasData) {
                                        return const Expanded(
                                            child: Center(
                                                child: Text(
                                                    'No Event Applicant')));
                                      } else {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                DropdownButtonHideUnderline(
                                                  child: DropdownButton<
                                                          EventApplicant>(
                                                      hint: Text("$_selected"),
                                                      items: eventC
                                                          .eventApplicants.value
                                                          .map<
                                                              DropdownMenuItem<
                                                                  EventApplicant>>((item) =>
                                                              DropdownMenuItem<
                                                                      EventApplicant>(
                                                                  value: item,
                                                                  child: Text(
                                                                      "${item.event?.eventName}")))
                                                          .toList(),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          eventApplicant =
                                                              value;
                                                          _selected = value
                                                              ?.event
                                                              ?.eventName;
                                                        });
                                                        print(value);
                                                      }),
                                                ),
                                                Wrap(
                                                  direction: Axis.horizontal,
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.center,
                                                  spacing: 8,
                                                  children: [
                                                    const Icon(
                                                      Icons.date_range_rounded,
                                                      color: Colors.redAccent,
                                                    ),
                                                    Text(
                                                        eventApplicant?.event!
                                                                .getDateInFormat(
                                                                    date: eventApplicant!
                                                                        .event
                                                                        ?.eventDate,
                                                                    format:
                                                                        "dd MMM yyyy") ??
                                                            "",
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontFamily:
                                                                'Helvetica',
                                                            color: Color(
                                                                0xff3A4856))),
                                                  ],
                                                )
                                              ],
                                            ),
                                            eventApplicant == null
                                                ? Container()
                                                : Container(
                                                    padding: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15))),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const Text(
                                                                "Supervisor",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Helvetica',
                                                                    color: Colors
                                                                        .black54),
                                                              ),
                                                              Container(
                                                                  margin:
                                                                      EdgeInsets.only(
                                                                          top:
                                                                              8),
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              8),
                                                                  decoration: BoxDecoration(
                                                                      color:
                                                                          Colors.blueGrey[
                                                                              50],
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15.0)),
                                                                  child: Text(
                                                                      " ${research.getSupervisorCode()}",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontFamily:
                                                                              'Helvetica',
                                                                          color:
                                                                              Color(0xff3A4856)))),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 5),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              const Text(
                                                                "Examiner",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Helvetica',
                                                                    color: Colors
                                                                        .black54),
                                                              ),
                                                              Container(
                                                                  margin:
                                                                      EdgeInsets.only(
                                                                          top:
                                                                              8),
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              8),
                                                                  decoration: BoxDecoration(
                                                                      color:
                                                                          Colors.blueGrey[
                                                                              50],
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15.0)),
                                                                  child: Text(
                                                                      " ${eventApplicant?.getExaminerCode()}",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontFamily:
                                                                              'Helvetica',
                                                                          color:
                                                                              Color(0xff3A4856)))),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                          ],
                                        );
                                      }
                                      ;
                                    }),
                              ),
                              Flexible(
                                  child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    TextField(
                                      controller: textAreaController,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 4,
                                      decoration: const InputDecoration(
                                        labelText: "Enter Resume",
                                        labelStyle:
                                            TextStyle(color: Colors.black54),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15))),
                                        filled: true,
                                        fillColor: Colors.white,
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Colors.lightBlueAccent),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15))),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary:
                                                Colors.lightBlueAccent.shade700,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15))),
                                        child: const Text(
                                          "Submit report",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Helvetica',
                                              fontWeight: FontWeight.bold),
                                        ),
                                        onPressed: () {
                                          if (eventApplicant == null) {
                                            Get.snackbar("Uncompleted form",
                                                "Please choose event to be reported");
                                          } else if (textAreaController.text ==
                                              "") {
                                            Get.snackbar("Uncompleted form",
                                                "Please fill the resume");
                                          } else {
                                            Get.defaultDialog(
                                                contentPadding:
                                                    EdgeInsets.all(15),
                                                title: 'Confirmation',
                                                titleStyle: TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff3A4856)),
                                                titlePadding:
                                                    EdgeInsets.only(top: 15),
                                                content: Text(
                                                  "Are you sure want to submit report?",
                                                  style: TextStyle(
                                                      color: Color(0xff3A4856)),
                                                ),
                                                textCancel: 'Cancel',
                                                textConfirm: 'Yes',
                                                confirmTextColor: Colors.white,
                                                radius: 15,
                                                onConfirm: () {
                                                  researchC.submitDefenseReport(
                                                      research,
                                                      eventApplicant!.id,
                                                      textAreaController.text,
                                                      eventApplicant!.event!
                                                          .getDateInFormat(
                                                              date:
                                                                  eventApplicant
                                                                      ?.event!
                                                                      .eventDate,
                                                              format:
                                                                  "yyyy-MM-dd HH:mm:ss"));
                                                  // TODO: fitur update report defense
                                                  Get.back();
                                                  Get.back(
                                                      result: ({
                                                    'title':
                                                        'Report of defense',
                                                    'message':
                                                        'Your report defense has been submit successfully'
                                                  }));
                                                });
                                          }
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ))
                            ]),
                      );
                    }
                  }),
            )),
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

  Future refreshResearch() async {
    researchC.researchById(researchId);
    // await Future.delayed(Duration(seconds: 2));
    setState(() {});
  }
}
