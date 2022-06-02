import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_app/Screens/Tabs/editProfilePage.dart';
import 'package:my_app/models/courier.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../assistants/global.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //name
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 60.0),
                  child: Text(
                    courierInfo!.first_name + " " + courierInfo!.last_name,
                    style: const TextStyle(
                      fontSize: 50.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => EditProfilePage()),
                    );
                    //SystemNavigator.pop();
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.white, elevation: 0),
                  child: buildEditIcon(Color.fromARGB(255, 4, 46, 119)),
                ),
                // buildEditIcon(Color.fromARGB(255, 4, 46, 119)),
              ],
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
            buildInfoCard(courierInfo!.phone_number, Icons.phone_android),
            buildInfoCard(courierInfo!.email, Icons.email),
            buildInfoCard(courierInfo!.VehicleType, Icons.car_repair),

            const SizedBox(
              height: 32,
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

  Widget buildInfoCard(String textInfo, IconData iconData) {
    return Card(
      color: Colors.white54,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      child: ListTile(
        leading: Icon(
          iconData,
          color: Colors.black,
        ),
        title: Text(
          textInfo,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 5,
          child: const Icon(
            Icons.edit,
            color: Colors.white,
            size: 20,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );

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

  /*Future<void> getCourierInfo() async {
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
  }*/
}
