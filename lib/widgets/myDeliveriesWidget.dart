import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/delivery.dart';
import 'package:my_app/widgets/progressDialog.dart';
import '../Screens/Tabs/homeTab.dart';
import '../Screens/tripScreen.dart';
import '../globalUtils/utils.dart';
import '../globalUtils/global.dart';
import '../push_notfications/localNotificationSystem.dart';

class MyDeliveriesWidget extends StatelessWidget {
  Delivery delivery;
  int id;
  final VoidCallback callback;

  MyDeliveriesWidget(
      {required this.delivery, required this.id, required this.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                  delivery.srcContact.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 8,
            ),

            Row(
              children: [
                const Icon(
                  Icons.phone_android_rounded,
                  color: Colors.black,
                  size: 28,
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  delivery.srcContact.phone,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 12,
            ),

            //icon + pickup
            Row(
              children: [
                Image.asset(
                  "images/origin.png",
                  height: 26,
                  width: 26,
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      delivery.srcAddress,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 14,
            ),

            //icon + dropOff
            Row(
              children: [
                Image.asset(
                  "images/destination.png",
                  height: 24,
                  width: 24,
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      delivery.destAddress,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 14,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    onPressed: (() {
                      startTrip(context);
                    }),
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(255, 1, 14, 61),
                    ),
                    child: const Text(
                      "Start Trip",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    )),
                const SizedBox(
                  width: 38,
                ),
                Text(
                  "ID: " + id.toString(), //widget.tripsHistory!.company_id,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),

            //trip time and date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(""),
                Text(
                  delivery.deadline!,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                Text(
                  delivery.companyName!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),

            const SizedBox(
              height: 2,
            ),
          ],
        ),
      ),
    );
  }

  startTrip(BuildContext context) async {
    if (!isCourierActive!) {
      Fluttertoast.showToast(
          msg: "Please strart your shift in the Home tab before starting trip");
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressBox(
        message: "processing, please wait...",
      ),
    );
    await updateDeliveryStatus("on the way", delivery);
    await Utils.updateDeliveriesForOnlineCourier(context);
    callback();
    updateCourierStatus("busy");
    Navigator.pop(context);
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime dateTime = dateFormat.parse(delivery.deadline!);
    DateTime futureNotificationTime = DateTime.now().add(Duration(hours: 1));
    if (futureNotificationTime.isBefore(dateTime)) {
      //print("cancel future notification!!!!");
      LocalNotificationSystem.cancel(identityHashCode(delivery.id));
    }

    Utils.pauseLiveLocationUpdates();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TripScreen(deliveryDetails: delivery)));
  }
}
