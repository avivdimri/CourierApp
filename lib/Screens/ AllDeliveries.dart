import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:my_app/Screens/detailsDeliveryPage.dart';
import 'package:my_app/authentication/global.dart';

import '../models/delivery.dart';

class AllDeliveries extends StatefulWidget {
  @override
  State<AllDeliveries> createState() => _AllDeliveriesState();
}

class _AllDeliveriesState extends State<AllDeliveries> {
  late List<Delivery> deliveries = [];
  late List<Delivery> filteredDeliveries = [];
  bool isSearching = false;
  getDeliveries() async {
    var response = await Dio().get(basicUri, queryParameters: {'id': userId});
    var jsonList = response.data;
    var data = json.decode(jsonList);
    var map = data.map<Delivery>((json) => Delivery.fromJson(json));
    return map.toList();
  }

  @override
  void initState() {
    getDeliveries().then((data) {
      setState(() {
        deliveries = filteredDeliveries = data;
      });
    });

    super.initState();
  }

  void _filterDeliveries(value) {
    setState(() {
      filteredDeliveries = deliveries
          .where((delivery) =>
              delivery.src_contact.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: !isSearching
              ? const Text('All Deliveries')
              : TextField(
                  onChanged: (value) {
                    _filterDeliveries(value);
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      hintText: "Search delivery here",
                      hintStyle: TextStyle(color: Colors.white)),
                ),
          actions: <Widget>[
            isSearching
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        this.isSearching = false;
                        filteredDeliveries = deliveries;
                      });
                    },
                    icon: const Icon(Icons.cancel),
                  )
                : IconButton(
                    onPressed: () {
                      setState(() {
                        this.isSearching = true;
                      });
                    },
                    icon: const Icon(Icons.search),
                  )
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: filteredDeliveries.length > 0
              ? ListView.builder(
                  itemCount: filteredDeliveries.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      // onTap: () {
                      //   Navigator.of(context).push(
                      //     MaterialPageRoute(
                      //         builder: (context) => DetailDeliveryView(
                      //             delivery: snapshot.data![index])),
                      //   );
                      // },
                      child: Card(
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 8),
                          child: Column(children: <Widget>[
                            Text(
                              "src lat: " + filteredDeliveries[index].src.lat,
                              style: const TextStyle(fontSize: 18),
                            ),
                            Text(
                              "src long: " + filteredDeliveries[index].src.long,
                              style: const TextStyle(fontSize: 18),
                            ),
                            Text(
                              "timing: " + filteredDeliveries[index].timing,
                              style: const TextStyle(fontSize: 18),
                            ),
                            RaisedButton(
                              child: Text("Description"),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => DetailDeliveryView(
                                          delivery: filteredDeliveries[index])),
                                );
                              },
                            )
                          ]),
                        ),
                      ),
                    );
                  })
              : Center(child: CircularProgressIndicator()),
          // child: FutureBuilder<List<Delivery>>(
          //   future: deliveries,
          //   builder: (BuildContext context,
          //       AsyncSnapshot<List<Delivery>> snapshot) {
          //     if (snapshot.hasData) {
          //       print(snapshot.data!.length);
          //       return ListView.builder(
          //           itemCount: snapshot.data!.length,
          //           itemBuilder: (BuildContext context, int index) {
          //             return GestureDetector(
          //               // onTap: () {
          //               //   Navigator.of(context).push(
          //               //     MaterialPageRoute(
          //               //         builder: (context) => DetailDeliveryView(
          //               //             delivery: snapshot.data![index])),
          //               //   );
          //               // },
          //               child: Card(
          //                 elevation: 10,
          //                 child: Padding(
          //                   padding: const EdgeInsets.symmetric(
          //                       vertical: 10, horizontal: 8),
          //                   child: Column(children: <Widget>[
          //                     Text(
          //                       "src lat: " + snapshot.data![index].src.lat,
          //                       style: const TextStyle(fontSize: 18),
          //                     ),
          //                     Text(
          //                       "src long: " + snapshot.data![index].src.long,
          //                       style: const TextStyle(fontSize: 18),
          //                     ),
          //                     Text(
          //                       "timing: " + snapshot.data![index].timing,
          //                       style: const TextStyle(fontSize: 18),
          //                     ),
          //                     RaisedButton(
          //                       child: Text("Description"),
          //                       onPressed: () {
          //                         Navigator.of(context).push(
          //                           MaterialPageRoute(
          //                               builder: (context) =>
          //                                   DetailDeliveryView(
          //                                       delivery:
          //                                           snapshot.data![index])),
          //                         );
          //                       },
          //                     )
          //                   ]),
          //                 ),
          //               ),
          //             );
          //           });
          //     }
          //     return Text('error in connection');
          //   },

          // )
        ));
  }
}
