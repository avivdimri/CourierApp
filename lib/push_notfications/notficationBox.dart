import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_app/Screens/tripScreen.dart';
import 'package:my_app/globalUtils/utils.dart';
import 'package:my_app/globalUtils/global.dart';
import 'package:my_app/models/delivery.dart';

import '../Screens/Tabs/homeTab.dart';

class NotificationBox extends StatefulWidget {
  Delivery deliveryDetails;
  NotificationBox({required this.deliveryDetails});

  @override
  State<NotificationBox> createState() => _NotificationBoxState();
}

class _NotificationBoxState extends State<NotificationBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.transparent,
      elevation: 2,
      child: Container(
        margin: const EdgeInsets.all(4),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(
            height: 14,
          ),
          Image.asset(
            "images/22kf_im3i_200729.jpg",
            width: 160,
          ),
          const SizedBox(
            height: 14,
          ),
          const Text(
            "New Delivery Request",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(
            height: 18.0,
          ),
          const Divider(
            height: 8,
            thickness: 3,
          ),
          //adrdesses
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                // source
                Row(
                  children: [
                    Image.asset(
                      "images/origin.png",
                      width: 30,
                      height: 30,
                    ),
                    const SizedBox(
                      width: 14,
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          widget.deliveryDetails.srcAddress,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 20.0,
                ),
                // dest
                Row(
                  children: [
                    Image.asset(
                      "images/destination.png",
                      width: 30,
                      height: 30,
                    ),
                    const SizedBox(
                      width: 14,
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          widget.deliveryDetails.destAddress,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          //buttons
          const Divider(
            height: 3,
            thickness: 3,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ),
                    onPressed: () {
                      audioPlayer.pause();
                      audioPlayer.stop();
                      audioPlayer = AssetsAudioPlayer();
                      Fluttertoast.showToast(
                          msg: "the delivery request has been declined");
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "DECLINE",
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    )),
                const SizedBox(
                  width: 25,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ),
                    onPressed: () {
                      audioPlayer.pause();
                      audioPlayer.stop();
                      audioPlayer = AssetsAudioPlayer();
                      acceptDeliverRequest(context);
                    },
                    child: const Text(
                      "ACCEPT",
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ))
              ],
            ),
          )
        ]),
      ),
    );
  }

  acceptDeliverRequest(BuildContext context) async {
    var result =
        await updateDeliveryStatus("on the way", widget.deliveryDetails);
    if (result == "ERROR") {
      Fluttertoast.showToast(msg: "sorry, too late! the delivery is ocupided ");
      return;
    }
    //add order to courier's history
    updateCourierStatus("busy");
    Navigator.pop(context);

    Utils.pauseLiveLocationUpdates();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                TripScreen(deliveryDetails: widget.deliveryDetails)));
  }
}
