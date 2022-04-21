import 'package:flutter/material.dart';

class MyDeliveriesTabPage extends StatefulWidget {
  const MyDeliveriesTabPage({Key? key}) : super(key: key);

  @override
  State<MyDeliveriesTabPage> createState() => _MyDeliveriesTabPageState();
}

class _MyDeliveriesTabPageState extends State<MyDeliveriesTabPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("my deliveries"),
    );
  }
}
