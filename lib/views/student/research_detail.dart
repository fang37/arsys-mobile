import 'dart:convert';
import 'dart:io';
import 'package:arsys/controllers/event_controller.dart';
import 'package:arsys/controllers/profile_controller.dart';
import 'package:arsys/controllers/research_controller.dart';
import 'package:arsys/views/appbar.dart';
import 'package:flutter/material.dart';
import 'package:arsys/views/user/login.dart';
import 'package:arsys/network/api.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class StudentResearchDetail extends StatefulWidget {
  @override
  _StudentResearchDetailState createState() => _StudentResearchDetailState();
}

class _StudentResearchDetailState extends State<StudentResearchDetail> {
  final researchC = Get.find<ResearchController>();
  final data = Get.arguments;
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
      if (_selectedNavbar == 3) () => Get.toNamed('/student-event');
      if (_selectedNavbar == 4) () => Get.toNamed('/student-event');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBarBuilder(),
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
                      padding: EdgeInsets.fromLTRB(8, 0, 8, 5),
                      child: Text(
                        "\"${data.title}\"",
                        style: TextStyle(
                            fontSize: 21,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[800]),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Approval of Defense/Seminar',
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontFamily: 'Helvetica',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: data.defense_approval.length,
                              itemBuilder: (context, index) {
                                print(data.defense_approval.length);
                                if (data.defense_approval.length == 0) {
                                  print('no data approval');
                                  return Expanded(
                                      child: Center(
                                    child: Text("No Approvement"),
                                  ));
                                } else
                                  return Expanded(
                                      child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 5, 5, 5),
                                    child: Row(
                                      children: [
                                        researchC.approvalIcon(
                                            data.defense_approval[index]
                                                ['decision']),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: Text(data
                                                  .defense_approval[index]
                                              ['defense_model']['description']),
                                        ),
                                        Text(' | '),
                                        Text(data.defense_approval[index]
                                            ['faculty']['code']),
                                        Text(
                                          (data.defense_approval[index]
                                                      ['approver_role'] ==
                                                  3)
                                              ? " (Head of Program Approval)"
                                              : "",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ));
                              })
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Progress of Supervision',
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontFamily: 'Helvetica',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: FutureBuilder<dynamic>(
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
                              return Card(
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
                                    isAlwaysShown: true,
                                    child: ListView.builder(
                                        // shrinkWrap: true,
                                        // physics:
                                        //     NeverScrollableScrollPhysics(),
                                        itemCount:
                                            snapshot.data.supervisor.length,
                                        itemBuilder: (context, index) {
                                          if (snapshot.data.supervisor.length ==
                                              0) {
                                            return Container(
                                              child: Center(
                                                child: Text("No Supervisor"),
                                              ),
                                            );
                                          } else
                                            return Column(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      8, 5, 8, 5),
                                                  color: Colors.blue[50],
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
                                                                  .grey[800])),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 5),
                                                        child: researchC
                                                            .bypassIcon(snapshot
                                                                    .data
                                                                    .supervisor[
                                                                index]['bypass']),
                                                      ),
                                                      Text(
                                                        (snapshot.data.supervisor[
                                                                        index][
                                                                    'bypass'] ==
                                                                1)
                                                            ? " (bypass)"
                                                            : "",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "OpenSans",
                                                            fontStyle: FontStyle
                                                                .italic),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  physics:
                                                      ClampingScrollPhysics(),
                                                  child: Scrollbar(
                                                    isAlwaysShown: true,
                                                    child: Column(
                                                      children: [
                                                        ListView.builder(
                                                            physics:
                                                                ClampingScrollPhysics(),
                                                            shrinkWrap: true,
                                                            itemCount: snapshot
                                                                .data
                                                                .supervise
                                                                .length,
                                                            itemBuilder:
                                                                (context, idx) {
                                                              if (snapshot.data
                                                                              .supervisor[
                                                                          index]
                                                                      [
                                                                      'supervisor_id'] ==
                                                                  snapshot.data
                                                                          .supervise[idx]
                                                                      [
                                                                      'supervisor_id']) {
                                                                return Expanded(
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child: Row(
                                                                      children: [
                                                                        (snapshot.data.supervise[idx]['status'] !=
                                                                                null)
                                                                            ? Icon(Icons.check_circle_rounded,
                                                                                color: Colors.lightGreenAccent)
                                                                            : Icon(
                                                                                Icons.timelapse_rounded,
                                                                                color: Colors.grey,
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
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(snapshot.data.supervise[idx]['topic'], style: TextStyle(fontSize: 18, color: Colors.grey[900])),
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
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            );
                                        }),
                                  ),
                                ),
                              );
                            }
                          }),
                    ),
                    // Expanded(
                    //     flex: 2, child: Container(color: Colors.lightBlue))
                    // BUAT SCROLLABLE APP NYA
                  ],
                ),
              ),
            ),
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Colors.lightBlue,
        items: [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.supervised_user_circle, title: 'Research'),
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
