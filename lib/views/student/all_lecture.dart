import 'dart:convert';
import 'dart:io';
import 'package:arsys/controllers/event_controller.dart';
import 'package:arsys/controllers/lecture_controller.dart';
import 'package:arsys/controllers/research_controller.dart';
import 'package:arsys/controllers/profile_controller.dart';
import 'package:arsys/views/appbar.dart';
import 'package:flutter/material.dart';
import 'package:arsys/network/api.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class AllLecture extends StatefulWidget {
  @override
  _AllLectureState createState() => _AllLectureState();
}

class _AllLectureState extends State<AllLecture> {
  final lectureC = Get.find<LectureController>();
  TextEditingController searchController = TextEditingController();

  String? semester = '';
  String? day = '';
  int? prodi = 0;

  var prodi_name = {
    0: "Program",
    1: "PTE",
    2: "TE",
    3: "PTOIR",
  };

  @override
  void initState() {
    lectureC.allLecture();
    super.initState();
  }

  int _selectedNavbar = 3;
  void _changeSelectedNavBar(int index) {
    setState(() {
      _selectedNavbar = index;
      if (_selectedNavbar == 0) {
        Get.toNamed('/student-home');
      }
      if (_selectedNavbar == 1) {
        Get.toNamed('/student-research');
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
      appBar: SecondAppBarBuilder("All Lectures"),
      body: Platform.isIOS
          ? Container()
          : RefreshIndicator(
              displacement: 40,
              edgeOffset: 10,
              onRefresh: refreshResearch,
              child: SafeArea(
                child: Container(
                  padding: EdgeInsets.fromLTRB(15, 10, 5, 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            Flexible(
                              child: Container(
                                margin: EdgeInsets.fromLTRB(8, 0, 0, 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(50),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 2,
                                        spreadRadius: 1,
                                        offset: Offset.fromDirection(1)),
                                  ],
                                ),
                                child: TextField(
                                  cursorHeight: 20,
                                  style: TextStyle(height: 0.8),
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  controller: searchController,
                                  decoration: InputDecoration(
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      labelText: "Search Lecture Name or Code",
                                      prefixIcon: Icon(Icons.search),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            FocusScope.of(context).unfocus();
                                            searchController.clear();
                                          });
                                        },
                                        icon: Icon(Icons.clear),
                                      ),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50))),
                                      filled: true,
                                      fillColor: Colors.white),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 8),
                              color: Colors.transparent,
                              child: FittedBox(
                                child: IconButton(
                                    onPressed: () {
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
                                                  height: 100,
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
                                                            'Filter',
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xff3A4856),
                                                                fontSize: 20,
                                                                fontFamily:
                                                                    'OpenSans',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          IconButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                day = '';
                                                                if (Get.isBottomSheetOpen !=
                                                                    null) {
                                                                  Get.back();
                                                                }
                                                              });
                                                            },
                                                            icon: Icon(Icons
                                                                .refresh_rounded),
                                                            color: Colors
                                                                .lightBlueAccent,
                                                          )
                                                        ],
                                                      ),
                                                      Text(
                                                        'Day',
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
                                                          "Set",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'Helvetica'),
                                                        ),
                                                        onPressed: () {
                                                          if (Get.isBottomSheetOpen !=
                                                              null) {
                                                            setState(() {
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
                                          });
                                    },
                                    icon: Icon(
                                      Icons.menu_rounded,
                                      size: 30,
                                      color: Colors.grey,
                                    )),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 30,
                        margin:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      side: BorderSide(
                                          color: (prodi == 0)
                                              ? Colors.grey
                                              : Colors.lightBlueAccent),
                                      primary: (prodi == 0)
                                          ? Colors.white
                                          : Colors.lightBlue[50],
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15))),
                                  child: Text(
                                    (prodi == 0)
                                        ? 'Prodi'
                                        : "${prodi_name[prodi]}",
                                    style: TextStyle(
                                        color: (prodi == 0)
                                            ? Colors.grey
                                            : Colors.lightBlue,
                                        fontFamily: 'Helvetica'),
                                  ),
                                  onPressed: () {
                                    prodiBottomModal(context);
                                  },
                                ),
                                VerticalDivider(
                                    color: Colors.transparent, width: 5),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      side: BorderSide(
                                          color: (semester == '')
                                              ? Colors.grey
                                              : Colors.lightBlueAccent),
                                      primary: (semester == '')
                                          ? Colors.white
                                          : Colors.lightBlue[50],
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15))),
                                  child: Text(
                                    (semester == '')
                                        ? 'Semester'
                                        : "Semester ${semester}",
                                    style: TextStyle(
                                        color: (semester == '')
                                            ? Colors.grey
                                            : Colors.lightBlue,
                                        fontFamily: 'Helvetica'),
                                  ),
                                  onPressed: () {
                                    semesterBottomModal(context);
                                  },
                                ),
                                VerticalDivider(
                                    color: Colors.transparent, width: 5),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      side: BorderSide(
                                          color: (day == '')
                                              ? Colors.grey
                                              : Colors.lightBlueAccent),
                                      primary: (day == '')
                                          ? Colors.white
                                          : Colors.lightBlue[50],
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15))),
                                  child: Text(
                                    (day == '')
                                        ? 'Day'
                                        : "${day!.toUpperCase()}",
                                    style: TextStyle(
                                        color: (day == '')
                                            ? Colors.grey
                                            : Colors.lightBlue,
                                        fontFamily: 'Helvetica'),
                                  ),
                                  onPressed: () {
                                    dayBottomModal(context);
                                  },
                                ),
                              ],
                            ),
                            TextButton(
                                onPressed: () {
                                  if (prodi != 0 ||
                                      semester != "" ||
                                      day != "") {
                                    setState(() {
                                      prodi = 0;
                                      semester = "";
                                      day = "";
                                    });
                                  }
                                },
                                child: Text(
                                  'Clear',
                                  style:
                                      TextStyle(color: Colors.redAccent[100]),
                                ))
                          ],
                        ),
                      ),
                      Expanded(
                        child: FutureBuilder<dynamic>(
                            future: lectureC.allLecture(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.data.length == 0) {
                                return Expanded(
                                    child: Center(child: Text('No Lecture')));
                              } else {
                                // print(snapshot.data[0].event_name);
                                // print(snapshot.data.length);
                                return ClipPath(
                                  clipper: ShapeBorderClipper(
                                      shape: RoundedRectangleBorder(
                                          // borderRadius:
                                          // BorderRadius.circular(10.0)
                                          )),
                                  child: Scrollbar(
                                    child: ListView.builder(
                                        physics: BouncingScrollPhysics(),
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (context, index) {
                                          if (searchController.text.isEmpty) {
                                            if (snapshot.data[index].semester
                                                    .contains(semester) &&
                                                snapshot.data[index].daytime
                                                    .toLowerCase()
                                                    .contains(day) &&
                                                (snapshot.data[index]
                                                            .program_id ==
                                                        prodi ||
                                                    prodi == 0)) {
                                              return ListElement(
                                                  snapshot, index);
                                            }
                                            return Container();
                                          } else if (snapshot.data[index].name
                                                  .toLowerCase()
                                                  .contains(
                                                      searchController.text) ||
                                              snapshot.data[index].code
                                                  .toLowerCase()
                                                  .contains(
                                                      searchController.text)) {
                                            if (snapshot.data[index].semester
                                                    .contains(semester) &&
                                                snapshot.data[index].daytime
                                                    .toLowerCase()
                                                    .contains(day) &&
                                                (snapshot.data[index]
                                                            .program_id ==
                                                        prodi ||
                                                    prodi == 0)) {
                                              return ListElement(
                                                  snapshot, index);
                                            }
                                            return Container();
                                          }
                                          return Container();
                                        }),
                                  ),
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

  Future<dynamic> prodiBottomModal(BuildContext context) {
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
                          'Filter',
                          style: TextStyle(
                              color: Color(0xff3A4856),
                              fontSize: 20,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              prodi = 0;
                              if (Get.isBottomSheetOpen != null) {
                                Get.back();
                              }
                            });
                          },
                          icon: Icon(Icons.refresh_rounded),
                          color: Colors.lightBlueAccent,
                        )
                      ],
                    ),
                    Text(
                      'Prodi',
                      style: TextStyle(
                          color: Color(0xff3A4856),
                          fontSize: 16,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        prodiRadioBuilder(0, 'All', modalstate),
                        prodiRadioBuilder(1, 'PTE', modalstate),
                        prodiRadioBuilder(2, 'TE', modalstate),
                        prodiRadioBuilder(3, 'PTOIR', modalstate),
                      ],
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

  Column prodiRadioBuilder(int val, String desc, var modalstate) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: (MediaQuery.of(context).size.width * 0.9) / 9,
          child: Radio(
              activeColor: Colors.lightBlueAccent,
              value: val,
              groupValue: prodi,
              onChanged: (value) {
                modalstate(() {
                  prodi = value as int?;
                  if (Get.isBottomSheetOpen != null) {
                    setState(() {
                      Get.back();
                    });
                  }
                });
              }),
        ),
        Text(
          desc,
          style: TextStyle(
            color: Color(0xff3A4856),
            fontSize: 20,
            fontFamily: 'OpenSans',
          ),
        ),
      ],
    );
  }

  Future<dynamic> semesterBottomModal(BuildContext context) {
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
                          'Filter',
                          style: TextStyle(
                              color: Color(0xff3A4856),
                              fontSize: 20,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              semester = '';
                              if (Get.isBottomSheetOpen != null) {
                                Get.back();
                              }
                            });
                          },
                          icon: Icon(Icons.refresh_rounded),
                          color: Colors.lightBlueAccent,
                        )
                      ],
                    ),
                    Text(
                      'Semester',
                      style: TextStyle(
                          color: Color(0xff3A4856),
                          fontSize: 16,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        semesterRadioBuilder('', 'All', modalstate),
                        semesterRadioBuilder('1', '1', modalstate),
                        semesterRadioBuilder('2', '2', modalstate),
                        semesterRadioBuilder('3', '3', modalstate),
                        semesterRadioBuilder('4', '4', modalstate),
                        semesterRadioBuilder('5', '5', modalstate),
                        semesterRadioBuilder('6', '6', modalstate),
                        semesterRadioBuilder('7', '7', modalstate),
                        semesterRadioBuilder('8', '8', modalstate),
                      ],
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

  Column semesterRadioBuilder(String val, String desc, var modalstate) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: (MediaQuery.of(context).size.width * 0.9) / 9,
          child: Radio(
              activeColor: Colors.lightBlueAccent,
              value: val,
              groupValue: semester,
              onChanged: (value) {
                modalstate(() {
                  semester = value as String?;
                  if (Get.isBottomSheetOpen != null) {
                    setState(() {
                      Get.back();
                    });
                  }
                });
              }),
        ),
        Text(
          desc,
          style: TextStyle(
            color: Color(0xff3A4856),
            fontSize: 20,
            fontFamily: 'OpenSans',
          ),
        ),
      ],
    );
  }

  Future<dynamic> dayBottomModal(BuildContext context) {
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
                          'Filter',
                          style: TextStyle(
                              color: Color(0xff3A4856),
                              fontSize: 20,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              day = '';
                              if (Get.isBottomSheetOpen != null) {
                                Get.back();
                              }
                            });
                          },
                          icon: Icon(Icons.refresh_rounded),
                          color: Colors.lightBlueAccent,
                        )
                      ],
                    ),
                    Text(
                      'Day',
                      style: TextStyle(
                          color: Color(0xff3A4856),
                          fontSize: 16,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.bold),
                    ),
                    Wrap(
                      children: [
                        dayRadioBuilder('', 'All', modalstate),
                        dayRadioBuilder('monday', 'Monday', modalstate),
                        dayRadioBuilder('tuesday', 'Tuesday', modalstate),
                        dayRadioBuilder('wednesday', 'Wednesday', modalstate),
                        dayRadioBuilder('thursday', 'Thursday', modalstate),
                        dayRadioBuilder('friday', 'Friday', modalstate),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.lightBlueAccent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      child: Text(
                        "Set",
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'Helvetica'),
                      ),
                      onPressed: () {
                        if (Get.isBottomSheetOpen != null) {
                          setState(() {
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer);
  }

  Widget dayRadioBuilder(String val, String desc, var modalstate) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            side: BorderSide(
                color: (day != val) ? Colors.grey : Colors.lightBlueAccent),
            primary: (day != val) ? Colors.white : Colors.lightBlue[50],
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        child: Text(
          desc,
          style: TextStyle(
              color: (day != val) ? Colors.grey : Colors.lightBlue,
              fontFamily: 'Helvetica'),
        ),
        onPressed: () {
          modalstate(() {
            day = val;
          });
        },
      ),
    );
  }

  Expanded ListElement(AsyncSnapshot<dynamic> snapshot, int index) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Card(
          margin: EdgeInsets.only(left: 5, right: 5),
          elevation: 2.0,
          color: Colors.white,
          // lectureC.cardColorBuilder(
          //     snapshot.data[index]
          //         .milestone['milestone']),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ClipPath(
            clipper: ShapeBorderClipper(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0))),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: Colors.lightBlue[100],
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "${snapshot.data[index].name} (${snapshot.data[index].code})",
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w700,
                              color: Color(0xff3A4856))),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "${snapshot.data[index].team_name}",
                              style: TextStyle(
                                  fontFamily: 'Helvetica',
                                  color: Colors.black54),
                            ),
                            Text(
                              "|",
                              style: TextStyle(
                                  fontFamily: 'Helvetica',
                                  color: Colors.black54),
                            ),
                            Text(
                              "${snapshot.data[index].credit} SKS",
                              style: TextStyle(
                                  fontFamily: 'Helvetica',
                                  color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.blueGrey[50],
                            borderRadius: BorderRadius.circular(15.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                      color: Colors.red[50],
                                      borderRadius:
                                          BorderRadius.circular(15.0)),
                                  child: Icon(
                                    Icons.timelapse_rounded,
                                    color: Colors.redAccent[100],
                                    size: 20,
                                  ),
                                ),
                                Text(" ${snapshot.data[index].daytime}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Helvetica',
                                        color: Color(0xff3A4856))),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                      color: Colors.blue[50],
                                      borderRadius:
                                          BorderRadius.circular(15.0)),
                                  child: Icon(
                                    Icons.meeting_room_rounded,
                                    color: Colors.lightBlueAccent,
                                    size: 20,
                                  ),
                                ),
                                Text(" ${snapshot.data[index].room}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Helvetica',
                                        color: Color(0xff3A4856))),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future refreshResearch() async {
    lectureC.lecture.clear();
    lectureC.lectureUser();
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
