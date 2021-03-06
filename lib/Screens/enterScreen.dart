import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_app/Screens/mainTabsScreen.dart';
import 'package:my_app/authentication/loginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../globalUtils/global.dart';

class EnterScreen extends StatefulWidget {
  const EnterScreen({Key? key}) : super(key: key);

  @override
  State<EnterScreen> createState() => _EnterScreenState();
}

class _EnterScreenState extends State<EnterScreen> {
  startTimer() {
    Timer(const Duration(seconds: 2), () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? username = prefs.getString('username');
      final String? id = prefs.getString('userId');
      final String? isActive = prefs.getString('isActive');
      if (username != null && id != null && isActive != null) {
        setState(() {
          isCourierActive = (isActive == "false") ? false : true;
          statusText = (isActive == "false") ? "Start Shift" : "Online";
          isLoggedIn = true;
          name = username;
          userId = id;
        });
      }
      if (Platform.isAndroid) {
        basicUri = "https://deliverysystemmanagement.herokuapp.com/";
      } else if (Platform.isIOS) {
        basicUri = "https://deliverysystemmanagement.herokuapp.com/";
      }

      if (!isLoggedIn) {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const LoginScreen()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const MainScreen()));
      }
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
        color: Color.fromARGB(246, 255, 255, 255),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("images/logo.jpg"),
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
