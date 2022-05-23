import 'package:arsys/views/onboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../authentication/authentication_manager.dart';

class SplashView extends StatelessWidget {
  final AuthenticationManager _authmanager = Get.put(AuthenticationManager());

  Future<void> initializeSettings() async {
    _authmanager.checkLoginStatus();

    //Simulate other services for 3 seconds
    await Future.delayed(Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeSettings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return waitingView();
        } else {
          if (snapshot.hasError)
            return errorView(snapshot);
          else
            return OnBoard();
        }
      },
    );
  }

  Scaffold errorView(AsyncSnapshot<Object?> snapshot) {
    return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
  }

  Container waitingView() {
    return Container(
      decoration: BoxDecoration(
          image: const DecorationImage(
              image: AssetImage("assets/arches.png"),
              scale: 1.5,
              fit: BoxFit.none,
              repeat: ImageRepeat.repeat),
          gradient: LinearGradient(
              colors: [Colors.lightBlue, Colors.lightBlueAccent[100]!],
              begin: FractionalOffset.bottomLeft,
              end: FractionalOffset.topRight)),
      child: Scaffold(
          backgroundColor: Color.fromARGB(0, 39, 35, 35),
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Ar",
                      style: TextStyle(
                        fontFamily: "Helvetica",
                        fontWeight: FontWeight.bold,
                        fontSize: 80,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                    Text(
                      "Sys",
                      style: TextStyle(
                        fontFamily: "Helvetica",
                        fontSize: 80,
                        fontStyle: FontStyle.italic,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ],
                ),
                const Text(
                  "Advanced Research Support System",
                  style: TextStyle(
                    fontFamily: "Helvetica",
                    fontSize: 20,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
