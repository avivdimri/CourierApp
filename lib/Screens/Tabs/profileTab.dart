import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_app/models/courier.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../authentication/global.dart';
import '../../widgets/info_design_ui.dart';
import '../splashScreen.dart';

class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({Key? key}) : super(key: key);

  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {
  @override
  void initState() {
    super.initState();
    //getCourierInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //name
            Text(
              courierInfo!.first_name + " " + courierInfo!.last_name,
              style: const TextStyle(
                fontSize: 50.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              courierInfo!.company_id.toString(),
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 20,
              width: 200,
              child: Divider(
                color: Colors.white,
                height: 2,
                thickness: 2,
              ),
            ),

            const SizedBox(
              height: 38.0,
            ),

            //phone
            InfoDesignUIWidget(
              textInfo: courierInfo!.phone_number,
              iconData: Icons.phone_iphone,
            ),

            //email
            InfoDesignUIWidget(
              textInfo: courierInfo!.email,
              iconData: Icons.email,
            ),

            InfoDesignUIWidget(
              textInfo: courierInfo!.VehicleType,
              iconData: Icons.car_repair,
            ),

            const SizedBox(
              height: 20,
            ),

            ElevatedButton(
              onPressed: () {
                logout();
                //SystemNavigator.pop();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.redAccent,
              ),
              child: const Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

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

  Future<void> getCourierInfo() async {
    try {
      var response = await dio.get(basicUri + 'get_courier/$userId');
      var jsonList = response.data;
      var data = json.decode(jsonList);
      setState(() {
        courierInfo = Courier.fromJson(data);
      });
    } catch (onError) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error: " + onError.toString());
    }
  }
}
