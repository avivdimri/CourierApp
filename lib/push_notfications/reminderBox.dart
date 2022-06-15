import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:my_app/globalUtils/global.dart';
import 'package:my_app/models/delivery.dart';

class ReminderBox extends StatefulWidget {
  Delivery? deliveryDetails;
  int? id;

  ReminderBox({this.deliveryDetails, this.id});

  @override
  State<ReminderBox> createState() => _ReminderBoxState();
}

class _ReminderBoxState extends State<ReminderBox> {
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
          const Icon(
            Icons.info_outlined,
            color: Colors.black,
            size: 28,
          ),
          Image.asset(
            "images/reminder.jpeg",
            width: 160,
          ),
          const SizedBox(
            height: 14,
          ),
          const Text(
            "It's time to go out",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(
            height: 12.0,
          ),
          Row(
            children: [
              const SizedBox(
                width: 48,
              ),
              Text(
                "ORDER ID : " + widget.id.toString(),
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12.0,
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
                      primary: Colors.blue,
                    ),
                    onPressed: () {
                      audioPlayer.pause();
                      audioPlayer.stop();
                      audioPlayer = AssetsAudioPlayer();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "THANKS",
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                    )),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
