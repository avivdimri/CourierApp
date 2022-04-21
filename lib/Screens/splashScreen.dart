import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_app/Screens/mainScreen.dart';
import 'package:my_app/authentication/loginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../authentication/global.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  startTimer() {
    Timer(const Duration(seconds: 2), () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? username = prefs.getString('username');
      final String? id = prefs.getString('userId');
      if (username != null && id != null) {
        setState(() {
          isLoggedIn = true;
          name = username;
          userId = id;
        });
      }
      if (Platform.isAndroid) {
        basicUri = "http://10.0.2.2:3000/";
      } else if (Platform.isIOS) {
        basicUri = "http://localhost:3000/";
      }
      printstate("splash screen");
      if (!isLoggedIn) {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const LoginScreen()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const MainScreen()));
      }

      //send user to home screen
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.black,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("images/35303782.jpg"),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Courier app",
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            )
          ],
        )),
      ),
    );
  }
}
