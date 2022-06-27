import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_app/widgets/feedWidget.dart';
import 'package:provider/provider.dart';

import '../../globalUtils/global.dart';
import '../../globalUtils/utils.dart';
import '../../globalUtils/allDeliveriesInfo.dart';
import '../../models/delivery.dart';

class FeedTab extends StatefulWidget {
  @override
  State<FeedTab> createState() => _FeedTabState();
}

class _FeedTabState extends State<FeedTab> {
  bool isSearching = false;
  late List<Delivery> filteredDeliveries = [];
  @override
  void initState() {
    super.initState();
    _provider = Provider.of<AllDeliveriesInfo>(context, listen: false);
    Utils.updateDeliveriesForOnlineCourier1(_provider);
    filteredDeliveries = _provider.feedDeliveries;
  }

  void _filterDeliveries(value) {
    setState(() {
      filteredDeliveries = Provider.of<AllDeliveriesInfo>(context,
              listen: false)
          .feedDeliveries
          .where((delivery) =>
              delivery.srcAddress.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  var _provider;
  @override
  void didChangeDependencies() {
    _provider = Provider.of<AllDeliveriesInfo>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 141, 171, 200),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 141, 171, 200),
        title: !isSearching
            ? const Center(child: Text('My Feed'))
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
                      filteredDeliveries = _provider.feedDeliveries;
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
                      FeedWidget(
                          delivery: filteredDeliveries[i],
                          callback: () async {
                            await Utils.updateDeliveriesForOnlineCourier1(
                                _provider);
                            if (mounted) {
                              setState(() {
                                filteredDeliveries = _provider.feedDeliveries;
                              });
                            }
                          },
                          provider: _provider),
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
                "No delivries in feed",
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
