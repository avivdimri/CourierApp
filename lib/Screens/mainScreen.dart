import 'package:flutter/material.dart';
import 'package:my_app/Screens/feedScreen.dart';
import 'package:my_app/Screens/myDeliveriesScreen.dart';
import 'package:my_app/Screens/trips_history_screen.dart';
import 'package:my_app/models/trips_history_model.dart';
import 'Tabs/ AllDeliveries.dart';
import 'Tabs/homeTab.dart';
import 'Tabs/myDeliveriesTab.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          HomeTabPage(),
          //MyDeliveriesTabPage(),
          //AllDeliveries(),
          MyDeliveriesScreen(),
          FeedScreen(),
          TripsHistoryScreen(),
          // RatingsTabPage(),

          ProfileTabPage(),
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
