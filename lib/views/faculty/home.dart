import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:arsys/network/network.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class FacultyHome extends StatefulWidget {
  @override
  _FacultyHomeState createState() => _FacultyHomeState();
}

class _FacultyHomeState extends State<FacultyHome> {
  String? name;
  String? role;
  @override
  void initState() {
    _loadUserData();
    super.initState();
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user;
    user = jsonDecode(localStorage.getString('user')!) ?? "";
    var roles = localStorage.getString('roles');

    if (user != null) {
      setState(() {
        name = user['name'];
        role = roles;
      });
    }
  }

  int _selectedNavbar = 0;
  void _changeSelectedNavBar(int index) {
    setState(() {
      _selectedNavbar = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('FacultyHome'),
        backgroundColor: Colors.lightBlue,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: () {
              // logout();
            },
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                children: [
                  Text('Hello, ', style: TextStyle(fontSize: 20)),
                  Text(
                    name ?? "",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text('  Roles: ' + (role ?? ""))
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Colors.lightBlue,
        items: [
          TabItem(icon: Icons.home, title: 'FacultyHome'),
          TabItem(icon: Icons.supervised_user_circle, title: 'Supervise'),
          TabItem(icon: Icons.event, title: 'Event'),
          TabItem(icon: Icons.article, title: 'Review'),
          TabItem(icon: Icons.schedule, title: 'Lecture'),
        ],
        initialActiveIndex: _selectedNavbar,
        onTap: _changeSelectedNavBar,
      ),
    );
  }
}
