import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:my_app/Screens/Tabs/feedTab.dart';
import 'package:my_app/models/delivery.dart';
import 'package:my_app/push_notfications/pushNotficationsSystem.dart';
import 'package:my_app/widgets/progressDialog.dart';
import 'package:provider/provider.dart';
import '../Screens/Tabs/homeTab.dart';
import '../globalUtils/AllDeliveriesInfo.dart';
import '../globalUtils/utils.dart';
import '../push_notfications/localNotificationSystem.dart';

class FeedWidget extends StatelessWidget {
  final Delivery delivery;
  final Function callback;
  var provider;
  FeedWidget(
      {required this.delivery, required this.callback, required this.provider});

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
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  const SizedBox(
                    width: 200,
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
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        createFutureNotfication(context);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 1, 14, 61),
                      ),
                      child: const Text(
                        "Take delivery",
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
                  delivery.express
                      ? const Text("express",
                          style: TextStyle(
                            color: Colors.grey,
                          ))
                      : Text(
                          delivery.deadline!,
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                  const Text(
                    "Pizza Hut",
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
      ),
    );
  }

  createFutureNotfication(context) async {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime dateTime =
        dateFormat.parse(delivery.deadline!).subtract(const Duration(hours: 1));
    DateTime now = DateTime.now();
    if (dateTime.isBefore(now)) {
      Fluttertoast.showToast(
          msg:
              "Error: the dead line passed please contact with the your company");
      return;
    }
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return ProgressBox(
            message: "processing, please wait...",
          );
        });
    //dateTime = DateTime.now().add(const Duration(seconds: 80));
    await updateDeliveryStatus("assigned", delivery);
    await callback();
    Navigator.pop(context);
    LocalNotificationSystem.showScheduledNotification(
        id: identityHashCode(delivery.id),
        title: "Reminder",
        body: "It's time to go out",
        deliveryId: delivery.id,
        scheduledDate: dateTime);
  }
}
