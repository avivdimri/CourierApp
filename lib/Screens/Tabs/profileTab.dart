import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_app/Screens/Tabs/homeTab.dart';
import 'package:my_app/Screens/editProfileScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../globalUtils/global.dart';
import '../../globalUtils/allDeliveriesInfo.dart';
import '../../globalUtils/utils.dart';
import '../enterScreen.dart';

class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({Key? key}) : super(key: key);

  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 141, 171, 200),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //name
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 38.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person,
                        color: Colors.black,
                        size: 28,
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Text(
                        courierInfo.firstName + " " + courierInfo.lastName,
                        style: const TextStyle(
                          fontSize: 26.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => EditProfileScreen(
                                callback: () async {
                                  setState(() {});
                                },
                              )),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.transparent, elevation: 0),
                  child: buildEditIcon(
                    Color.fromARGB(255, 4, 46, 119),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              courierInfo.companyNames.join(", "),
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.black45,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 40,
              width: 200,
              child: Divider(
                color: Colors.white,
                height: 2,
                thickness: 2,
              ),
            ),
            //phone
            buildInfoCard(courierInfo.phoneNumber, Icons.phone_android),
            buildInfoCard(courierInfo.email, Icons.email),
            buildInfoCard(courierInfo.vehicleType, Icons.car_repair),

            const SizedBox(
              height: 50,
            ),

            ElevatedButton(
              onPressed: () {
                logout();
              },
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 4, 46, 119),
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
      color: Colors.white,
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
    if (isCourierActive!) {
      FirebaseDatabase.instance.ref().child("indexes").child(userId).remove();
      await Geofire.removeLocation(userId);
      updateCourierStatus("offline");
    }

    prefs.setString('username', null);
    prefs.setString('userId', null);
    prefs.setString('isActive', null);
    setState(() {
      name = '';
      isLoggedIn = false;
      userId = '';
      statusText = "Start Shift";
      isCourierActive = false;
    });

    Fluttertoast.showToast(
        msg: "Sign out successfully.", timeInSecForIosWeb: 2);
    Navigator.push(context,
        MaterialPageRoute(builder: ((context) => const EnterScreen())));
  }
}
