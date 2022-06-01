import 'package:flutter/cupertino.dart';
import 'package:my_app/models/delivery.dart';

import '../models/directions.dart';

class AppInfo extends ChangeNotifier {
  Directions? userPickUpLocation, userDropOffLocation;
  int countTotalTrips = 0;
  List<Delivery> allTripsHistoryInformationList = [];
  List<String> allOrderIds = [];

  void updatePickUpLocationAddress(Directions userPickUpAddress) {
    userPickUpLocation = userPickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Directions dropOffAddress) {
    userDropOffLocation = dropOffAddress;
    notifyListeners();
  }

  updateOverAllTripsCounter(int overAllTripsCounter) {
    countTotalTrips = overAllTripsCounter;
    notifyListeners();
  }

  updateOverAllTripsHistoryInformation(Delivery delivery) {
    if (!allOrderIds.contains(delivery.id)) {
      allOrderIds.add(delivery.id);
      allTripsHistoryInformationList.add(delivery);
      notifyListeners();
    }
  }
}
