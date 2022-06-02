import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_app/widgets/feedWidget.dart';
import 'package:provider/provider.dart';

import '../assistants/assistant_methods.dart';
import '../assistants/global.dart';
import '../infoHandler/app_info.dart';
import '../models/delivery.dart';
import '../widgets/historyWidget.dart';

class FeedScreen extends StatefulWidget {
  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
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
        title: const Text("Deliveries feed"),
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
                    FeedWidget(
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
