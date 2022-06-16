import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/delivery.dart';
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
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: Text(
                    "User : " + delivery.srcContact.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                const Text(
                  "Pizza Hut", //widget.tripsHistory!.company_id,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),

            const SizedBox(
              height: 12,
            ),

            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                const Icon(
                  Icons.phone_android_rounded,
                  color: Colors.black,
                  size: 28,
                ),
                const SizedBox(
                  width: 20,
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
              height: 20,
            ),

            //icon + pickup
            Row(
              children: [
                Image.asset(
                  "images/origin.png",
                  height: 26,
                  width: 46,
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
                  width: 46,
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
                delivery.deadline != null
                    ? Text(
                        delivery.deadline!,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      )
                    : const Text(
                        "express",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
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
    await updateDeliveryStatus("on the way", delivery);
    await Utils.updateDeliveriesForOnlineCourier(context);
    callback();
    updateCourierStatus("busy");
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime dateTime = dateFormat.parse(delivery.deadline!);
    DateTime futureNotificationTime = DateTime.now().add(Duration(minutes: 1));
    //print("the diff is : " + futureNotificationTime.toString());
    //print("the diff is : " + dateTime.toString());
    if (futureNotificationTime.isBefore(dateTime)) {
      print("cancel future notification!!!!");
      LocalNotificationSystem.cancel(identityHashCode(delivery.id));
    }

    Utils.pauseLiveLocationUpdates();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TripScreen(deliveryDetails: delivery)));
  }
}
