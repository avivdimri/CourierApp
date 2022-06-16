import 'package:flutter/material.dart';
import 'package:my_app/Screens/Tabs/feedTab.dart';
import 'package:my_app/models/delivery.dart';
import 'package:my_app/push_notfications/pushNotficationsSystem.dart';
import 'package:provider/provider.dart';
import '../globalUtils/AllDeliveriesInfo.dart';
import '../globalUtils/utils.dart';

class FeedWidget extends StatelessWidget {
  final Delivery delivery;
  final VoidCallback callback;

  FeedWidget({required this.delivery, required this.callback});

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
                        await PushNotficationsSystem.createFutureNotfication(
                            delivery, context);
                        callback();
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
