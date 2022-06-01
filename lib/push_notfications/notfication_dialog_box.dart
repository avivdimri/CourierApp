import 'dart:convert';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_app/Screens/new_trip_screen.dart';
import 'package:my_app/assistants/assistant_methods.dart';
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
            "images/22kf_im3i_200729.png",
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
                          widget.deliveryDetails!.src_address,
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
                          widget.deliveryDetails!.dest_address,
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
                      Fluttertoast.showToast(
                          msg: "the delivery request has been declined");
                      //send decline to the notfication
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeTabPage()));
                      /*Future.delayed(const Duration(milliseconds: 2000), () {
                        SystemNavigator.pop();
                      });*/
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

  acceptDeliverRequest(BuildContext context) async {
    //change deliver status in server
    updateDeliveryStatus("assigned", widget.deliveryDetails!);
    //add order to courier's history
    updateCourierStatus("busy");

    AssistantMethods.pauseLiveLocationUpdates();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                NewTripScreen(deliveryDetails: widget.deliveryDetails)));
  }
}
