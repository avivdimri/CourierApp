import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
import 'package:my_app/models/delivery.dart';

class HistoryWidget extends StatefulWidget {
  Delivery? tripsHistory;

  HistoryWidget({this.tripsHistory});

  @override
  State<HistoryWidget> createState() => _HistoryWidgetState();
}

class _HistoryWidgetState extends State<HistoryWidget> {
  /*String formatDateAndTime(String dateTimeFromDB) {
    DateTime dateTime = DateTime.parse(dateTimeFromDB);

    // Dec 10                            //2022                         //1:12 pm
    String formattedDatetime =
        "${DateFormat.MMMd().format(dateTime)}, ${DateFormat.y().format(dateTime)} - ${DateFormat.jm().format(dateTime)}";

    return formattedDatetime;
  }*/

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 6.0),
                    child: Text(
                      "User : " + widget.tripsHistory!.src_contact.name,
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
                    "Pizza Hut", //widget.tripsHistory!.company_id,
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
                    widget.tripsHistory!.src_contact.phone,
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
                        widget.tripsHistory!.src_address,
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
                        widget.tripsHistory!.dest_address,
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

              //trip time and date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(""),
                  widget.tripsHistory!.deadline != null
                      ? Text(
                          widget.tripsHistory!.deadline!,
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
      ),
    );
  }
}
