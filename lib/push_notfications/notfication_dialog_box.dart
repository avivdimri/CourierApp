import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/Screens/new_trip_screen.dart';
import 'package:my_app/authentication/global.dart';
import 'package:my_app/models/delivery.dart';

import '../Screens/Tabs/homeTab.dart';

class NotificationDialogBox extends StatefulWidget {
  Delivery? deliveryDetails;
  NotificationDialogBox({this.deliveryDetails});

  @override
  State<NotificationDialogBox> createState() => _NotificationDialogBoxState();
}

class _NotificationDialogBoxState extends State<NotificationDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.transparent,
      elevation: 2,
      child: Container(
        margin: const EdgeInsets.all(8),
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
              fontSize: 22,
            ),
          ),
          const SizedBox(
            height: 12.0,
          ),
          const Divider(
            height: 3,
            thickness: 3,
          ),
          //adrdesses
          Padding(
            padding: const EdgeInsets.all(20.0),
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
                          widget.deliveryDetails!.src.lat,
                          style: const TextStyle(
                            fontSize: 16,
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
                          widget.deliveryDetails!.dest.lat,
                          style: const TextStyle(
                            fontSize: 16,
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
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Decline".toUpperCase(),
                      style: const TextStyle(
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
                    child: Text(
                      "Accept".toUpperCase(),
                      style: const TextStyle(
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

  acceptDeliverRequest(BuildContext context) {
    //change deliver status in server
    // assing order id to courier documents
    updateCorierStatus("busy");

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                NewTripScreen(deliveryDetails: widget.deliveryDetails)));
  }
}
