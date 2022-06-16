import 'package:flutter/material.dart';
import 'package:my_app/widgets/feedWidget.dart';
import 'package:provider/provider.dart';

import '../../globalUtils/utils.dart';
import '../../globalUtils/allDeliveriesInfo.dart';
import '../../models/delivery.dart';

class FeedTab extends StatefulWidget {
  @override
  State<FeedTab> createState() => _FeedTabState();
}

class _FeedTabState extends State<FeedTab> {
  @override
  void initState() {
    super.initState();
    Utils.updateDeliveriesForOnlineCourier(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 1, 14, 61),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 14, 61),
        title: const Text("Deliveries feed"),
        automaticallyImplyLeading: false,
      ),
      body: Provider.of<AllDeliveriesInfo>(context, listen: false)
              .feedDeliveries
              .isNotEmpty
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
                      FeedWidget(
                          delivery: Provider.of<AllDeliveriesInfo>(context,
                                  listen: false)
                              .feedDeliveries[i],
                          callback: () async {
                            setState(() {});
                          }),
                    ]),
                  );
                },
                itemCount:
                    Provider.of<AllDeliveriesInfo>(context, listen: false)
                        .feedDeliveries
                        .length,
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
