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
      backgroundColor: Color.fromARGB(255, 141, 171, 200),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 141, 171, 200),
        title: const Center(child: Text("Trips History")),
        automaticallyImplyLeading: false,
      ),
      body: Provider.of<AllDeliveriesInfo>(context, listen: false)
              .historyDeliveries
              .isNotEmpty
          ? ListView.separated(
              separatorBuilder: (context, i) => const Divider(
                color: Colors.transparent,
                thickness: 2,
                height: 2,
              ),
              itemBuilder: (context, i) {
                return Card(
                  elevation: 20,
                  color: Colors.transparent,
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
          : const Center(
              heightFactor: 8,
              child: Text(
                "No delivries in History",
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
