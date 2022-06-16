import 'package:flutter/material.dart';
import 'package:my_app/widgets/myDeliveriesWidget.dart';
import 'package:provider/provider.dart';
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
    Utils.updateDeliveriesForOnlineCourier(context);
    filteredDeliveries =
        Provider.of<AllDeliveriesInfo>(context, listen: false).myDeliveries;
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
      backgroundColor: Color.fromARGB(255, 1, 14, 61),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 1, 14, 61),
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
                      isSearching = false;
                      filteredDeliveries =
                          Provider.of<AllDeliveriesInfo>(context, listen: false)
                              .myDeliveries;
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
                    color: Colors.white54,
                    child: Column(children: [
                      MyDeliveriesWidget(
                          delivery: filteredDeliveries[i],
                          id: i + 1,
                          callback: () async {
                            setState(() {
                              filteredDeliveries =
                                  Provider.of<AllDeliveriesInfo>(context,
                                          listen: false)
                                      .myDeliveries;
                            });
                          }),
                    ]),
                  );
                },
                itemCount: filteredDeliveries
                    .length, //Provider.of<AppInfo>(context, listen: false)
                //.myDeliveries
                //.length,
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
              ),
            )
          : const Text(
              "No delivries in feed",
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
