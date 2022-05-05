import 'package:flutter/material.dart';
import 'package:my_app/Screens/Tabs/deliveryMap.dart';

import '../../models/delivery.dart';
import ' AllDeliveries.dart';

class DetailDeliveryView extends StatelessWidget {
  final Delivery delivery;

  DetailDeliveryView({Key? key, required this.delivery}) : super(key: key);

  List<String> getDetails() {
    List<String> details = [
      "id: " + delivery.id,
      "src contact: " + delivery.src_contact,
      "status: " + delivery.status,
      "timing: " + delivery.timing,
      "company id: " + delivery.company_id.toString(),
      "source lat: " + delivery.src.lat,
      "source long: " + delivery.src.long,
      "dest lat: " + delivery.dest.lat,
      "dest long: " + delivery.dest.long
    ];
    return details;
  }

  TextStyle kStyle = const TextStyle(
    color: Colors.blue,
    fontWeight: FontWeight.w900,
  );

  @override
  Widget build(BuildContext context) {
    List<String> details = getDetails();
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text(delivery.status + " details")),
      body: Container(
        padding: EdgeInsets.all(10),
        child: GridView(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
          children: <Widget>[
            ListView.builder(
                itemCount: details.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return Text(details[index], style: kStyle);
                }),
            GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => DeliveryMap(),
                    ),
                  );
                },
                child: MapCard(title: 'Show on Map')),
          ],
        ),
      ),
    );

    // body: ListView.builder(
    //     itemCount: details.length,
    //     itemBuilder: (BuildContext ctxt, int index) {
    //       return Text(details[index], style: kStyle);
    //     }));
  }
}

class MapCard extends StatelessWidget {
  final String title;
  const MapCard({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Center(
          child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      )),
    );
  }
}
