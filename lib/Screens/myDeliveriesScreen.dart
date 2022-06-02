import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_app/Screens/new_trip_screen.dart';
import 'package:my_app/widgets/feedWidget.dart';
import 'package:my_app/widgets/myDeliveriesWidget.dart';
import 'package:provider/provider.dart';

import '../assistants/assistant_methods.dart';
import '../assistants/global.dart';
import '../infoHandler/app_info.dart';
import '../models/delivery.dart';
import '../widgets/historyWidget.dart';
import 'Tabs/homeTab.dart';

class MyDeliveriesScreen extends StatefulWidget {
  @override
  State<MyDeliveriesScreen> createState() => _MyDeliveriesScreenState();
}

class _MyDeliveriesScreenState extends State<MyDeliveriesScreen> {
  List<Delivery> deliveries = [];
  getDeliveries() async {
    try {
      var response = await dio.get(basicUri, queryParameters: {'id': userId});
      var jsonList = response.data;
      var data = json.decode(jsonList);
      var map = data.map<Delivery>((json) => Delivery.fromJson(json));
      return map.toList();
    } catch (onError) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error: " + onError.toString());
    }
  }

  @override
  void initState() {
    getDeliveries().then((data) {
      setState(() {
        deliveries = data;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 1, 14, 61),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 1, 14, 61),
        title: const Text("My Deliveries"),
        automaticallyImplyLeading: false,
      ),
      body: deliveries.isNotEmpty
          ? ListView.separated(
              separatorBuilder: (context, i) => const Divider(
                color: Colors.grey,
                thickness: 2,
                height: 2,
              ),
              itemBuilder: (context, i) {
                return Card(
                  color: Colors.white54,
                  child: Column(children: [
                    MyDeliveriesWidget(
                      delivery: deliveries[i],
                    ),
                  ]),
                );
              },
              itemCount: deliveries.length,
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
            )
          : const Text(
              "No delivries in feed",
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
