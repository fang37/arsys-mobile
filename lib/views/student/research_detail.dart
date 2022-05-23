import 'dart:convert';
import 'dart:io';
import 'package:arsys/controllers/event_controller.dart';
import 'package:arsys/controllers/profile_controller.dart';
import 'package:arsys/controllers/research_controller.dart';
import 'package:arsys/views/appbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:arsys/network/api.dart';
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
  final data = Get.arguments;
  ScrollController scrollC = new ScrollController();
  @override
  void initState() {
    // profileC.profileUser();
    // researchC.eventUser();
    // eventC.eventsUser();
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
      backgroundColor: Color(0xFFF0F9FE),
      appBar: SecondAppBarBuilder("Research"),
      body: Platform.isIOS
          ? Container()
          : SafeArea(
              child: Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: RichText(
                        text: TextSpan(
                            style: TextStyle(
                                fontSize: 21,
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[800]),
                            children: <TextSpan>[
                              TextSpan(text: "\"${data.title}\""),
                              TextSpan(
                                  text: " Abstract",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.lightBlueAccent),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return StatefulBuilder(builder:
                                                (context,
                                                    StateSetter modalstate) {
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                    bottom:
                                                        MediaQuery.of(context)
                                                            .viewInsets
                                                            .bottom),
                                                child: Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      20, 20, 20, 30),
                                                  color: Colors.white,
                                                  child: ListView(
                                                    shrinkWrap: true,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            'Abstract',
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xff3A4856),
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    'OpenSans',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          IconButton(
                                                            onPressed: () {
                                                              if (Get.isBottomSheetOpen !=
                                                                  null) {
                                                                Get.back();
                                                              }
                                                            },
                                                            icon: Icon(Icons
                                                                .close_rounded),
                                                            color: Colors
                                                                .lightBlueAccent,
                                                          )
                                                        ],
                                                      ),
                                                      Flexible(
                                                        flex: 1,
                                                        child: Container(
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  8, 3, 8, 10),
                                                          child: Card(
                                                            elevation: 4,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Scrollbar(
                                                                isAlwaysShown:
                                                                    true,
                                                                child:
                                                                    SingleChildScrollView(
                                                                  physics:
                                                                      BouncingScrollPhysics(),
                                                                  child:
                                                                      SelectableText(
                                                                    data.abstract,
                                                                    style: TextStyle(
                                                                        color: Color(
                                                                            0xff3A4856),
                                                                        fontSize:
                                                                            16,
                                                                        fontFamily:
                                                                            'OpenSans'),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                            primary: Colors
                                                                .lightBlueAccent,
                                                            elevation: 0,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15))),
                                                        child: Text(
                                                          "OK",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'Helvetica'),
                                                        ),
                                                        onPressed: () {
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
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20),
                                            ),
                                          ),
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer);
                                    }),
                            ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Approval of Defense/Seminar',
                        style: TextStyle(
                            color: Color(0xff3A4856),
                            fontSize: 16,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(maxHeight: 150),
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
                                  physics: BouncingScrollPhysics(),
                                  controller: scrollC,
                                  // reverse: true,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: data.defense_approval.length,
                                  itemBuilder: (context, index) {
                                    print(data.defense_approval.length);
                                    if (data.defense_approval.length == 0) {
                                      print('no data approval');
                                      return Expanded(
                                          child: Center(
                                        child: Text("No Approvement"),
                                      ));
                                    } else {
                                      if (index ==
                                          data.defense_approval.length) {
                                        scrollC.jumpTo(
                                            scrollC.position.maxScrollExtent);
                                      }
                                      return SizedBox(
                                        child: TimelineTile(
                                          indicatorStyle: IndicatorStyle(
                                              width: 25,
                                              color: researchC.timelineColor(
                                                data.defense_approval[index]
                                                    ['decision'],
                                              )),
                                          axis: TimelineAxis.vertical,
                                          beforeLineStyle: LineStyle(
                                              color: Colors.greenAccent),
                                          afterLineStyle: LineStyle(
                                              color: Colors.greenAccent),
                                          isFirst: (index == 0) ? true : false,
                                          isLast: (index ==
                                                  data.defense_approval.length -
                                                      1)
                                              ? true
                                              : false,
                                          endChild: Container(
                                            margin: EdgeInsets.all(8),
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
                                                      data.defense_approval[
                                                                  index]
                                                              ['defense_model']
                                                          ['description'],
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff3A4856),
                                                          fontSize: 16,
                                                          fontFamily:
                                                              'OpenSans',
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),

                                                    Text(
                                                      "${data.defense_approval[index]['faculty']['code']} ${(data.defense_approval[index]['approver_role'] == 3) ? " (Head of Program Approval)" : ""}",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff3A4856),
                                                          fontSize: 16,
                                                          fontFamily:
                                                              'OpenSans'),
                                                    ),
                                                    Text(
                                                      data.defense_approval[
                                                              index]
                                                          ['approval_date'],
                                                      style: TextStyle(
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
                                                    //     data.defense_approval[index]
                                                    //         ['decision']),
                                                    //     Padding(
                                                    //       padding:
                                                    //           const EdgeInsets.only(left: 5),
                                                    //       child: Text(data
                                                    //               .defense_approval[index]
                                                    //           ['defense_model']['description']),
                                                    //     ),
                                                    //     Text(' | '),
                                                    //     Text(data.defense_approval[index]
                                                    //         ['faculty']['code']),
                                                    // Text(
                                                    //   (data.defense_approval[index]
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
                                                researchC.approvalIcon(
                                                    data.defense_approval[index]
                                                        ['decision'])
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Progress of Supervision',
                        style: TextStyle(
                            color: Color(0xff3A4856),
                            fontSize: 16,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    FutureBuilder<dynamic>(
                        initialData: data,
                        // future: data,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (!(snapshot.hasData)) {
                            return Expanded(
                                child: Center(
                                    child: Text('No Research Selected')));
                          } else {
                            // print(snapshot.data[0].event_name);
                            // print(snapshot.data.length);
                            return Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: snapshot.data.supervisor.length,
                                  itemBuilder: (context, index) {
                                    if (snapshot.data.supervisor.length == 0) {
                                      return Container(
                                        child: Center(
                                          child: Text("No Supervisor"),
                                        ),
                                      );
                                    } else
                                      return Expanded(
                                        flex: 1,
                                        child: Card(
                                          elevation: 4.0,
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: ClipPath(
                                            clipper: ShapeBorderClipper(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0))),
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      10, 8, 10, 8),
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                        colors: [
                                                          Colors
                                                              .lightBlueAccent,
                                                          Color(0xFF0277E3)
                                                        ],
                                                        begin:
                                                            Alignment.topLeft,
                                                        end: Alignment
                                                            .bottomRight),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                          snapshot.data.supervisor[
                                                                      index]
                                                                  ['faculty']
                                                              ['code'],
                                                          // ['faculty']['code'],
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontFamily:
                                                                  'OpenSans',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .white)),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 5),
                                                          child: researchC
                                                              .bypassIcon(snapshot
                                                                          .data
                                                                          .supervisor[
                                                                      index]
                                                                  ['bypass'])),
                                                      Text(
                                                          (snapshot.data.supervisor[
                                                                          index]
                                                                      [
                                                                      'bypass'] ==
                                                                  1)
                                                              ? " (bypass)"
                                                              : "",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  "OpenSans",
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic)),
                                                    ],
                                                  ),
                                                ),
                                                SingleChildScrollView(
                                                  child: Scrollbar(
                                                    isAlwaysShown: true,
                                                    child: ListView.builder(
                                                        physics:
                                                            BouncingScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemCount: snapshot.data
                                                            .supervise.length,
                                                        itemBuilder:
                                                            (context, idx) {
                                                          if (snapshot.data
                                                                          .supervisor[
                                                                      index][
                                                                  'supervisor_id'] ==
                                                              snapshot.data
                                                                      .supervise[idx]
                                                                  [
                                                                  'supervisor_id']) {
                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: InkWell(
                                                                onTap: () {
                                                                  showModalBottomSheet(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return StatefulBuilder(builder:
                                                                            (context,
                                                                                StateSetter modalstate) {
                                                                          return Padding(
                                                                            padding:
                                                                                EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                                            child:
                                                                                Container(
                                                                              padding: EdgeInsets.fromLTRB(20, 20, 20, 30),
                                                                              color: Colors.white,
                                                                              child: ListView(
                                                                                shrinkWrap: true,
                                                                                children: [
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Text(
                                                                                        'Supervise',
                                                                                        style: TextStyle(color: Color(0xff3A4856), fontSize: 16, fontFamily: 'OpenSans', fontWeight: FontWeight.bold),
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
                                                                                  Expanded(
                                                                                    flex: 1,
                                                                                    child: Container(
                                                                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                                                                      child: Container(
                                                                                        width: double.infinity,
                                                                                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                                                                        decoration: BoxDecoration(
                                                                                            gradient: LinearGradient(colors: [
                                                                                              Colors.lightBlueAccent,
                                                                                              Color(0xFF0277E3)
                                                                                            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                                                                                            borderRadius: BorderRadius.all(Radius.circular(15))),
                                                                                        child: Center(
                                                                                          child: SelectableText(
                                                                                            "${snapshot.data.supervise[idx]['faculty']['front_title']} ${snapshot.data.supervise[idx]['faculty']['first_name']} ${snapshot.data.supervise[idx]['faculty']['last_name']} ${snapshot.data.supervise[idx]['faculty']['rear_title']}",
                                                                                            style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'OpenSans', fontWeight: FontWeight.w600),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Container(
                                                                                    margin: EdgeInsetsDirectional.only(bottom: 10),
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Row(
                                                                                          children: [
                                                                                            Text(
                                                                                              "Date : ",
                                                                                              style: TextStyle(color: Color(0xff3A4856), fontSize: 16, fontFamily: 'OpenSans', fontWeight: FontWeight.bold),
                                                                                            ),
                                                                                            Text(
                                                                                              "(${(snapshot.data.supervise[idx]['created_at']).substring(0, 10)})",
                                                                                              style: TextStyle(color: Color(0xff3A4856), fontSize: 16, fontFamily: 'OpenSans'),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        Row(
                                                                                          children: [
                                                                                            Text(
                                                                                              "Status : ",
                                                                                              style: TextStyle(color: Color(0xff3A4856), fontSize: 16, fontFamily: 'OpenSans', fontWeight: FontWeight.bold),
                                                                                            ),
                                                                                            (snapshot.data.supervise[idx]['status'] != null)
                                                                                                ? Icon(Icons.check_circle_rounded, color: Colors.greenAccent)
                                                                                                : Icon(
                                                                                                    Icons.timelapse_rounded,
                                                                                                    color: Colors.grey,
                                                                                                  ),
                                                                                            (snapshot.data.supervise[idx]['approval_date'] != null)
                                                                                                ? Text(
                                                                                                    snapshot.data.supervise[idx]['approval_date'],
                                                                                                    style: TextStyle(color: Color(0xff3A4856), fontSize: 16, fontFamily: 'OpenSans'),
                                                                                                  )
                                                                                                : Text("")
                                                                                          ],
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    "Topic :",
                                                                                    style: TextStyle(color: Color(0xff3A4856), fontSize: 16, fontFamily: 'OpenSans', fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                  Flexible(
                                                                                    flex: 1,
                                                                                    child: Container(
                                                                                      margin: EdgeInsets.fromLTRB(8, 3, 8, 10),
                                                                                      child: Card(
                                                                                        elevation: 2,
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                          child: Scrollbar(
                                                                                            isAlwaysShown: true,
                                                                                            child: SingleChildScrollView(
                                                                                              physics: BouncingScrollPhysics(),
                                                                                              child: SelectableText(
                                                                                                snapshot.data.supervise[idx]['topic'],
                                                                                                style: TextStyle(color: Color(0xff3A4856), fontSize: 16, fontFamily: 'OpenSans'),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    "Message :",
                                                                                    style: TextStyle(color: Color(0xff3A4856), fontSize: 16, fontFamily: 'OpenSans', fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                  Flexible(
                                                                                    flex: 1,
                                                                                    child: Container(
                                                                                      margin: EdgeInsets.fromLTRB(8, 3, 8, 10),
                                                                                      child: Card(
                                                                                        elevation: 2,
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                          child: Scrollbar(
                                                                                            isAlwaysShown: true,
                                                                                            child: SingleChildScrollView(
                                                                                              physics: BouncingScrollPhysics(),
                                                                                              child: SelectableText(
                                                                                                snapshot.data.supervise[idx]['message'],
                                                                                                style: TextStyle(color: Color(0xff3A4856), fontSize: 16, fontFamily: 'OpenSans'),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  ElevatedButton(
                                                                                    style: ElevatedButton.styleFrom(primary: Colors.lightBlueAccent, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                                                                                    child: Text(
                                                                                      "OK",
                                                                                      style: TextStyle(color: Colors.white, fontFamily: 'Helvetica'),
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
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.vertical(
                                                                          top: Radius.circular(
                                                                              20),
                                                                        ),
                                                                      ),
                                                                      clipBehavior:
                                                                          Clip.antiAliasWithSaveLayer);
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    (snapshot.data.supervise[idx]['status'] !=
                                                                            null)
                                                                        ? Icon(
                                                                            Icons
                                                                                .check_circle_rounded,
                                                                            color:
                                                                                Colors.greenAccent)
                                                                        : Icon(
                                                                            Icons.timelapse_rounded,
                                                                            color:
                                                                                Colors.grey,
                                                                          ),
                                                                    Expanded(
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets.fromLTRB(
                                                                            8,
                                                                            2,
                                                                            2,
                                                                            2),
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(snapshot.data.supervise[idx]['topic'],
                                                                                style: TextStyle(fontSize: 18, color: Colors.grey[900])),
                                                                            Text(
                                                                              "(${(snapshot.data.supervise[idx]['created_at']).substring(0, 10)})",
                                                                              style: TextStyle(color: Colors.black54),
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
                                                          return Expanded(
                                                              child:
                                                                  Container());
                                                        }),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                  }),
                            );
                          }
                        }),
                    // Expanded(
                    //     flex: 2, child: Container(color: Colors.lightBlue))
                    // BUAT SCROLLABLE APP NYA
                  ],
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

  Future refreshResearch() async {
    researchC.research.clear();
    researchC.researchUser();
    // eventC.event.clear();
    // eventC.eventUser();
    // eventC.events.clear();
    // eventC.eventsUser();
    await Future.delayed(Duration(seconds: 2));
    // setState(() {});
  }
}
