import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
import 'package:my_app/models/delivery.dart';

import '../Screens/Tabs/homeTab.dart';
import '../Screens/new_trip_screen.dart';
import '../assistants/assistant_methods.dart';

class MyDeliveriesWidget extends StatefulWidget {
  Delivery? delivery;

  MyDeliveriesWidget({this.delivery});

  @override
  State<MyDeliveriesWidget> createState() => _MyDeliveriesWidgetState();
}

class _MyDeliveriesWidgetState extends State<MyDeliveriesWidget> {
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
                    "User : " + widget.delivery!.src_contact.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  "comapny : Pizza Hut", //widget.tripsHistory!.company_id,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )
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
                  widget.delivery!.src_contact.phone,
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
                  width: 26,
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      widget.delivery!.src_address,
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
                      widget.delivery!.dest_address,
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
              children: [
                ElevatedButton(
                    onPressed: (() {
                      startTrip(context);
                    }),
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 1, 14, 61),
                    ),
                    child: const Text(
                      "Start Trip",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    )),
                const SizedBox(
                  width: 12,
                ),
              ],
            ),

            //trip time and date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(""),
                Text(
                  widget.delivery!.timing,
                  style: const TextStyle(
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
    updateCourierStatus("busy");

    AssistantMethods.pauseLiveLocationUpdates();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                NewTripScreen(deliveryDetails: widget.delivery)));
  }
}
