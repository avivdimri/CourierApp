import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../globalUtils/allDeliveriesInfo.dart';
import '../../globalUtils/global.dart';
import '../../globalUtils/utils.dart';
import '../../models/delivery.dart';
import '../../widgets/historyWidget.dart';

class HistoryTab extends StatefulWidget {
  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  @override
  void initState() {
    super.initState();
    _provider = Provider.of<AllDeliveriesInfo>(context, listen: false);
    Utils.updateDeliveriesForOnlineCourier1(_provider);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 1, 14, 61),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 1, 14, 61),
        title: const Text("Trips History"),
        automaticallyImplyLeading: false,
      ),
      body: Provider.of<AllDeliveriesInfo>(context, listen: false)
              .historyDeliveries
              .isNotEmpty
          ? ListView.separated(
              separatorBuilder: (context, i) => const Divider(
                color: Colors.grey,
                thickness: 2,
                height: 2,
              ),
              itemBuilder: (context, i) {
                return Card(
                  color: Colors.white54,
                  child: HistoryWidget(
                    tripsHistory:
                        Provider.of<AllDeliveriesInfo>(context, listen: false)
                            .historyDeliveries[i],
                  ),
                );
              },
              itemCount: Provider.of<AllDeliveriesInfo>(context, listen: false)
                  .historyDeliveries
                  .length,
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
            )
          : const Text(
              "No delivries in History",
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
