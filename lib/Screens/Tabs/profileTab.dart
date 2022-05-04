import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../authentication/global.dart';
import '../splashScreen.dart';

class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({Key? key}) : super(key: key);

  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {
  Future<Null> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', null);
    prefs.setString('userId', null);

    setState(() {
      name = '';
      isLoggedIn = false;
      userId = '';
      statusText = "Offline";
      isCourierActive = false;
    });
    Fluttertoast.showToast(
        msg: "Sign out successfully.", timeInSecForIosWeb: 2);
    Navigator.push(context,
        MaterialPageRoute(builder: ((context) => const MySplashScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: Text("Sign out"),
        onPressed: () {
          logout();
        },
      ),
    );
  }
}
