import 'dart:convert';
import 'dart:io';
import 'package:arsys/authentication/authentication_manager.dart';
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

class StudentProfile extends StatefulWidget {
  @override
  _StudentProfileState createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  final profileC = Get.find<ProfileController>();
  AuthenticationManager _authManager = Get.find();

  @override
  void initState() {
    // profileC.profileUser();
    // researchC.eventUser();
    // eventC.eventsUser();
    super.initState();
  }

  int _selectedNavbar = 0;
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
      // appBar: SecondAppBarBuilder("Profile"),
      body: Platform.isIOS
          ? Container()
          : SafeArea(
              top: false,
              child: Container(
                // padding: EdgeInsets.all(15),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(20)),
                          gradient: LinearGradient(
                              colors: [
                                Colors.lightBlueAccent,
                                Color(0xFF0277E3)
                              ],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight)),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(15, 30, 15, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.menu_rounded),
                                color: Colors.white,
                              ),
                              Text("Profile",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: "Helvetica",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              IconButton(
                                icon: Icon(Icons.logout_rounded),
                                color: Colors.white,
                                onPressed: () {
                                  Get.defaultDialog(
                                      contentPadding: EdgeInsets.all(15),
                                      title: 'Confirmation',
                                      titleStyle: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff3A4856)),
                                      titlePadding: EdgeInsets.only(top: 15),
                                      content: Text(
                                        'Are you sure want to sign out?',
                                        style:
                                            TextStyle(color: Color(0xff3A4856)),
                                      ),
                                      textCancel: 'Cancel',
                                      textConfirm: 'Yes',
                                      confirmTextColor: Colors.white,
                                      radius: 15,
                                      onConfirm: () {
                                        _authManager.logout();
                                        Get.back();
                                      });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.15,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Card(
                          elevation: 4.0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Stack(
                            alignment: Alignment.center,
                            clipBehavior: Clip.none,
                            children: [
                              ClipPath(
                                clipper: ShapeBorderClipper(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0))),
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  // height: 600,
                                  width: double.infinity,
                                  child: Container(
                                    // color: Colors.lime,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 120,
                                        ),
                                        Text(
                                          "Name :",
                                          style: TextStyle(
                                              color: Colors.blueGrey[300],
                                              fontSize: 16,
                                              fontFamily: 'OpenSans',
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      width: 1,
                                                      color: Colors.blueGrey))),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8),
                                            child: SizedBox(
                                              height: 20,
                                              width: double.infinity,
                                              child: SingleChildScrollView(
                                                physics:
                                                    BouncingScrollPhysics(),
                                                child: SelectableText(
                                                  "${profileC.profile.first_name} ${profileC.profile.last_name}" ??
                                                      "",
                                                  style: TextStyle(
                                                      color: Color(0xff3A4856),
                                                      fontSize: 20,
                                                      fontFamily: 'Helvetica',
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  cursorColor:
                                                      Colors.lightBlueAccent,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          "NIM :",
                                          style: TextStyle(
                                              color: Colors.blueGrey[300],
                                              fontSize: 16,
                                              fontFamily: 'OpenSans',
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      width: 1,
                                                      color: Colors.blueGrey))),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8),
                                            child: SizedBox(
                                              height: 20,
                                              width: double.infinity,
                                              child: SingleChildScrollView(
                                                physics:
                                                    BouncingScrollPhysics(),
                                                child: SelectableText(
                                                  "${profileC.profile.student_number}" ??
                                                      "",
                                                  style: TextStyle(
                                                      color: Color(0xff3A4856),
                                                      fontSize: 20,
                                                      fontFamily: 'Helvetica',
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  cursorColor:
                                                      Colors.lightBlueAccent,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          "Role :",
                                          style: TextStyle(
                                              color: Colors.blueGrey[300],
                                              fontSize: 16,
                                              fontFamily: 'OpenSans',
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      width: 1,
                                                      color: Colors.blueGrey))),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8),
                                            child: SizedBox(
                                              height: 20,
                                              width: double.infinity,
                                              child: SingleChildScrollView(
                                                physics:
                                                    BouncingScrollPhysics(),
                                                child: SelectableText(
                                                  "${profileC.profile.role}" ??
                                                      "",
                                                  style: TextStyle(
                                                      color: Color(0xff3A4856),
                                                      fontSize: 20,
                                                      fontFamily: 'Helvetica',
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  cursorColor:
                                                      Colors.lightBlueAccent,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          "Specialization :",
                                          style: TextStyle(
                                              color: Colors.blueGrey[300],
                                              fontSize: 16,
                                              fontFamily: 'OpenSans',
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      width: 1,
                                                      color: Colors.blueGrey))),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8),
                                            child: SizedBox(
                                              height: 20,
                                              width: double.infinity,
                                              child: SingleChildScrollView(
                                                physics:
                                                    BouncingScrollPhysics(),
                                                child: SelectableText(
                                                  "${profileC.profile.specialization}" ??
                                                      "",
                                                  style: TextStyle(
                                                      color: Color(0xff3A4856),
                                                      fontSize: 20,
                                                      fontFamily: 'Helvetica',
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  cursorColor:
                                                      Colors.lightBlueAccent,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          "Supervisor :",
                                          style: TextStyle(
                                              color: Colors.blueGrey[300],
                                              fontSize: 16,
                                              fontFamily: 'OpenSans',
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      width: 1,
                                                      color: Colors.blueGrey))),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8),
                                            child: InkWell(
                                              onTap: () {
                                                print("TAPPED");
                                                showModalBottomSheet(
                                                    context: context,
                                                    builder: (context) {
                                                      return StatefulBuilder(
                                                          builder: (context,
                                                              StateSetter
                                                                  modalstate) {
                                                        return Padding(
                                                          padding: EdgeInsets.only(
                                                              bottom: MediaQuery
                                                                      .of(context)
                                                                  .viewInsets
                                                                  .bottom),
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .fromLTRB(20,
                                                                    20, 20, 30),
                                                            color: Colors.white,
                                                          ),
                                                        );
                                                      });
                                                    });
                                              },
                                              child: SizedBox(
                                                height: 20,
                                                width: double.infinity,
                                                child: SingleChildScrollView(
                                                  physics:
                                                      BouncingScrollPhysics(),
                                                  child: SelectableText(
                                                    "${profileC.profile.supervisor['front_title']} ${profileC.profile.supervisor['first_name']} ${profileC.profile.supervisor['last_name']} ${profileC.profile.supervisor['rear_title']}" ??
                                                        "",
                                                    style: TextStyle(
                                                        color: Colors.lightBlue,
                                                        fontSize: 20,
                                                        fontFamily: 'Helvetica',
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    cursorColor:
                                                        Colors.lightBlueAccent,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          "Email :",
                                          style: TextStyle(
                                              color: Colors.blueGrey[300],
                                              fontSize: 16,
                                              fontFamily: 'OpenSans',
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      width: 1,
                                                      color: Colors.blueGrey))),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8),
                                            child: SizedBox(
                                              height: 20,
                                              width: double.infinity,
                                              child: SingleChildScrollView(
                                                physics:
                                                    BouncingScrollPhysics(),
                                                child: SelectableText(
                                                  "${profileC.profile.email}" ??
                                                      "",
                                                  style: TextStyle(
                                                      color: Color(0xff3A4856),
                                                      fontSize: 20,
                                                      fontFamily: 'Helvetica',
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  cursorColor:
                                                      Colors.lightBlueAccent,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          "Phone :",
                                          style: TextStyle(
                                              color: Colors.blueGrey[300],
                                              fontSize: 16,
                                              fontFamily: 'OpenSans',
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      width: 1,
                                                      color: Colors.blueGrey))),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8),
                                            child: SizedBox(
                                              height: 20,
                                              width: double.infinity,
                                              child: SingleChildScrollView(
                                                physics:
                                                    BouncingScrollPhysics(),
                                                child: SelectableText(
                                                  "${profileC.profile.phone}" ??
                                                      "",
                                                  style: TextStyle(
                                                      color: Color(0xff3A4856),
                                                      fontSize: 20,
                                                      fontFamily: 'Helvetica',
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  cursorColor:
                                                      Colors.lightBlueAccent,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                  top: -75,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.account_circle_rounded,
                                        color: Color(0xff3A4856),
                                        size: 150,
                                      ),
                                      FutureBuilder(
                                        future: profileC.profileUser(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                              child: CircularProgressIndicator(
                                                color: Color(0xff3A4856),
                                              ),
                                            );
                                          } else if (snapshot.hasData)
                                            return Column(
                                              children: [
                                                Text(
                                                  profileC.profile.first_name ??
                                                      "",
                                                  style: TextStyle(
                                                      height: 0.97,
                                                      fontSize: 30,
                                                      fontFamily: 'OpenSans',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xff3A4856)),
                                                ),
                                              ],
                                            );
                                          return Text("");
                                        },
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
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
    profileC.profileClear();
    profileC.profileUser();
    await Future.delayed(Duration(seconds: 2));
    // setState(() {});
  }
}
