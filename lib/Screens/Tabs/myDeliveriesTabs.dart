import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_app/widgets/myDeliveriesWidget.dart';
import 'package:provider/provider.dart';
import '../../globalUtils/global.dart';
import '../../globalUtils/utils.dart';
import '../../globalUtils/allDeliveriesInfo.dart';
import '../../models/delivery.dart';

class MyDeliveriesTabs extends StatefulWidget {
  @override
  State<MyDeliveriesTabs> createState() => _MyDeliveriesTabsState();
}

class _MyDeliveriesTabsState extends State<MyDeliveriesTabs> {
  bool isSearching = false;
  late List<Delivery> filteredDeliveries = [];
  @override
  void initState() {
    super.initState();

    _provider = Provider.of<AllDeliveriesInfo>(context, listen: false);
    Utils.updateDeliveriesForOnlineCourier1(_provider);
    filteredDeliveries = _provider.myDeliveries;
  }

  var _provider;
  @override
  void didChangeDependencies() {
    _provider = Provider.of<AllDeliveriesInfo>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    //_provider.clearDeliveriesLists();
    super.dispose();
  }

  void _filterDeliveries(value) {
    setState(() {
      filteredDeliveries =
          Provider.of<AllDeliveriesInfo>(context, listen: false)
              .myDeliveries
              .where((delivery) => delivery.srcContact.name
                  .toLowerCase()
                  .contains(value.toLowerCase()))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 141, 171, 200),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 141, 171, 200),
        title: !isSearching
            ? const Center(child: Text('My Deliveries'))
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
                    hintText: "Search delivery ",
                    hintStyle: TextStyle(color: Colors.white)),
              ),
        actions: <Widget>[
          isSearching
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isSearching = false;
                      filteredDeliveries = _provider.myDeliveries;
                    });
                  },
                  icon: const Icon(Icons.cancel),
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      isSearching = true;
                    });
                  },
                  icon: const Icon(Icons.search),
                )
        ],
        automaticallyImplyLeading: false,
      ),
      body: filteredDeliveries.isNotEmpty
          ? RefreshIndicator(
              onRefresh: () async {
                await Utils.updateDeliveriesForOnlineCourier1(_provider);
                setState(() {});
              },
              child: ListView.separated(
                separatorBuilder: (context, i) => const Divider(
                  color: Colors.grey,
                  thickness: 2,
                  height: 2,
                ),
                itemBuilder: (context, i) {
                  return Card(
                    elevation: 20,
                    color: Colors.transparent,
                    child: Column(children: [
                      MyDeliveriesWidget(
                          delivery: filteredDeliveries[i],
                          id: i + 1,
                          callback: () async {
                            setState(() {
                              filteredDeliveries = _provider.myDeliveries;
                            });
                          }),
                    ]),
                  );
                },
                itemCount: filteredDeliveries.length,
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
              ),
            )
          : const Center(
              heightFactor: 8,
              child: Text(
                "You don't have deliveries",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }
}
