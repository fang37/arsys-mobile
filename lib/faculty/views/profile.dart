import 'dart:convert';
import 'dart:io';
import 'package:arsys/authentication/authentication_manager.dart';
import 'package:arsys/controllers/user_controller.dart';
import 'package:arsys/views/appbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:arsys/network/network.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:timeline_tile/timeline_tile.dart';

class FacultyProfile extends StatefulWidget {
  @override
  _FacultyProfileState createState() => _FacultyProfileState();
}

class _FacultyProfileState extends State<FacultyProfile> {
  final profileC = Get.find<UserController>();
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
        Get.toNamed('/faculty-home');
      }
      // if (_selectedNavbar == 1) () => Get.back();
      if (_selectedNavbar == 1) {
        Get.toNamed('/faculty-supervision');
      }
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
                      decoration: const BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                              bottom: const Radius.circular(20)),
                          gradient: const LinearGradient(
                              colors: [
                                Colors.lightBlueAccent,
                                const Color(0xFF0277E3)
                              ],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight)),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(15, 30, 15, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.menu_rounded),
                                color: Colors.white,
                              ),
                              const Text("Profile",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontFamily: "Helvetica",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              IconButton(
                                icon: const Icon(Icons.logout_rounded),
                                color: Colors.white,
                                onPressed: () {
                                  Get.defaultDialog(
                                      contentPadding: const EdgeInsets.all(15),
                                      title: 'Confirmation',
                                      titleStyle: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff3A4856)),
                                      titlePadding:
                                          const EdgeInsets.only(top: 15),
                                      content: const Text(
                                        'Are you sure want to sign out?',
                                        style: const TextStyle(
                                            color: const Color(0xff3A4856)),
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
                                  padding: const EdgeInsets.all(20),
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
                                        const SizedBox(
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
                                          decoration: const BoxDecoration(
                                              border: const Border(
                                                  bottom: BorderSide(
                                                      width: 1,
                                                      color: Colors.blueGrey))),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8),
                                            child: SizedBox(
                                              height: 20,
                                              width: double.infinity,
                                              child: SingleChildScrollView(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                child: SelectableText(
                                                  profileC.user
                                                      .getProfileName(),
                                                  style: const TextStyle(
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
                                        const SizedBox(
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
                                          decoration: const BoxDecoration(
                                              border: const Border(
                                                  bottom: BorderSide(
                                                      width: 1,
                                                      color: Colors.blueGrey))),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8),
                                            child: SizedBox(
                                              height: 20,
                                              width: double.infinity,
                                              child: SingleChildScrollView(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                child: SelectableText(
                                                  "${profileC.user.nip}",
                                                  style: const TextStyle(
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
                                        const SizedBox(
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
                                          decoration: const BoxDecoration(
                                              border: Border(
                                                  bottom: const BorderSide(
                                                      width: 1,
                                                      color: Colors.blueGrey))),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8),
                                            child: SizedBox(
                                              height: 20,
                                              width: double.infinity,
                                              child: SingleChildScrollView(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                child: SelectableText(
                                                  profileC.user.getRoleName(),
                                                  style: const TextStyle(
                                                      color: const Color(
                                                          0xff3A4856),
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
                                        const SizedBox(
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
                                          decoration: const BoxDecoration(
                                              border: const Border(
                                                  bottom: BorderSide(
                                                      width: 1,
                                                      color: Colors.blueGrey))),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8),
                                            child: SizedBox(
                                              height: 20,
                                              width: double.infinity,
                                              child: SingleChildScrollView(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                child: SelectableText(
                                                  "${profileC.user.specialization}",
                                                  style: const TextStyle(
                                                      color: const Color(
                                                          0xff3A4856),
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
                                        const SizedBox(
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
                                          decoration: const BoxDecoration(
                                              border: const Border(
                                                  bottom: BorderSide(
                                                      width: 1,
                                                      color: Colors.blueGrey))),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8),
                                            child: SizedBox(
                                              height: 20,
                                              width: double.infinity,
                                              child: SingleChildScrollView(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                child: SelectableText(
                                                  "${profileC.user.email}",
                                                  style: const TextStyle(
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
                                        const SizedBox(
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
                                          decoration: const BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      width: 1,
                                                      color: Colors.blueGrey))),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8),
                                            child: SizedBox(
                                              height: 20,
                                              width: double.infinity,
                                              child: SingleChildScrollView(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                child: SelectableText(
                                                  "${profileC.user.phone}",
                                                  style: const TextStyle(
                                                      color: const Color(
                                                          0xff3A4856),
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
                                      const Icon(
                                        Icons.account_circle_rounded,
                                        color: const Color(0xff3A4856),
                                        size: 150,
                                      ),
                                      FutureBuilder(
                                        future: profileC.getProfile(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                              child: CircularProgressIndicator(
                                                color: Color(0xff3A4856),
                                              ),
                                            );
                                          } else if (snapshot.hasData) {
                                            return Column(
                                              children: [
                                                Text(
                                                  profileC.user.code ?? "",
                                                  style: const TextStyle(
                                                      height: 0.97,
                                                      fontSize: 30,
                                                      fontFamily: 'OpenSans',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xff3A4856)),
                                                ),
                                              ],
                                            );
                                          }
                                          return const Text("");
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

  Future refreshResearch() async {
    profileC.profileClear();
    profileC.getProfile();
    await Future.delayed(const Duration(seconds: 2));
    // setState(() {});
  }
}
