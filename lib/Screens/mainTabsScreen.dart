import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_app/Screens/Tabs/feedTab.dart';
import 'package:my_app/Screens/Tabs/myDeliveriesTabs.dart';
import 'package:my_app/Screens/Tabs/historyTab.dart';
import 'package:my_app/models/delivery.dart';
import 'package:my_app/push_notfications/localNotificationSystem.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../globalUtils/utils.dart';
import '../globalUtils/global.dart';
import '../globalUtils/allDeliveriesInfo.dart';
import '../models/courier.dart';
import '../push_notfications/pushNotficationsSystem.dart';
import '../push_notfications/reminderBox.dart';
import 'Tabs/homeTab.dart';
import 'Tabs/profileTab.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  int selecgedIndex = 0;
  onItemClicked(int index) {
    setState(() {
      selecgedIndex = index;
      tabController!.index = selecgedIndex;
    });
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);
    PushNotficationsSystem pushNotficationsSystem = PushNotficationsSystem();
    pushNotficationsSystem.initCloudMessaging(context);
    LocalNotificationSystem.init();
    listenNotifications();
    pushNotficationsSystem.generateToken();
    Utils.updateDeliveriesForOnlineCourier(context);
    getCourierInfo();
  }

  void listenNotifications() => LocalNotificationSystem.onNotifications.stream
          .listen((String? deliveryId) {
        if (deliveryId != null) {
          int id = Provider.of<AllDeliveriesInfo>(context, listen: false)
              .myDeliveryIds
              .indexOf(deliveryId);

          Delivery delivery =
              Provider.of<AllDeliveriesInfo>(context, listen: false)
                  .myDeliveries[id];
          showDialog(
              context: context,
              builder: (BuildContext context) => ReminderBox(
                    deliveryDetails: delivery,
                    id: id + 1,
                  ));
        }
      });
  Future<void> getCourierInfo() async {
    var response;
    try {
      response = await dio.get(basicUri + 'get_courier/$userId');
    } catch (onError) {
      print("error !!!! getCourierInfo function  ");
      Fluttertoast.showToast(msg: "Error: " + onError.toString());
      // Navigator.pop(context);
    }
    if (response != null) {
      var jsonList = response.data;
      var data = json.decode(jsonList);
      Provider.of<AllDeliveriesInfo>(context, listen: false)
          .updateCourierInfo(Courier.fromJson(data));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          const HomeTabPage(),
          MyDeliveriesTabs(),
          FeedTab(),
          HistoryTab(),
          const ProfileTabPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.my_library_books),
            label: "My Delivries",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trip_origin),
            label: "Feed",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "History",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Account",
          ),
        ],
        unselectedItemColor: Colors.white54,
        selectedItemColor: Colors.white,
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontSize: 14),
        showSelectedLabels: true,
        currentIndex: selecgedIndex,
        onTap: onItemClicked,
      ),
    );
  }
}
