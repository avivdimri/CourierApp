import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_app/Screens/editProfileScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../globalUtils/global.dart';
import '../../globalUtils/allDeliveriesInfo.dart';
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //name
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 50.0),
                  child: Text(
                    Provider.of<AllDeliveriesInfo>(context, listen: false)
                            .courierInfo
                            .first_name +
                        " " +
                        Provider.of<AllDeliveriesInfo>(context, listen: false)
                            .courierInfo
                            .last_name,
                    style: const TextStyle(
                      fontSize: 26.0,
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
                          builder: (context) => EditProfileScreen()),
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
              Provider.of<AllDeliveriesInfo>(context, listen: false)
                  .courierInfo
                  .company_id
                  .toString(),
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
            buildInfoCard(
                Provider.of<AllDeliveriesInfo>(context, listen: true)
                    .courierInfo
                    .phone_number,
                Icons.phone_android),
            buildInfoCard(
                Provider.of<AllDeliveriesInfo>(context, listen: true)
                    .courierInfo
                    .email,
                Icons.email),
            buildInfoCard(
                Provider.of<AllDeliveriesInfo>(context, listen: true)
                    .courierInfo
                    .VehicleType,
                Icons.car_repair),

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
        MaterialPageRoute(builder: ((context) => const EnterScreen())));
  }
}
