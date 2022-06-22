import 'package:flutter/cupertino.dart';
import 'package:my_app/models/delivery.dart';

import '../models/courier.dart';

class AllDeliveriesInfo extends ChangeNotifier {
  List<Delivery> historyDeliveries = [];
  List<Delivery> feedDeliveries = [];
  List<Delivery> myDeliveries = [];

  List<String> historyDeliveryIds = [];
  List<String> feedDeliveryIds = [];
  List<String> myDeliveryIds = [];

  updateHistoryDeliveriesList(Delivery delivery) {
    if (!historyDeliveryIds.contains(delivery.id)) {
      historyDeliveryIds.add(delivery.id);
      historyDeliveries.add(delivery);
      notifyListeners();
    }
  }

  clearDeliveriesLists() {
    historyDeliveries = [];
    feedDeliveries = [];
    myDeliveries = [];
    historyDeliveryIds = [];
    feedDeliveryIds = [];
    myDeliveryIds = [];
    notifyListeners();
  }

  updateFeedDeliveriesList(Delivery delivery) {
    if (!feedDeliveryIds.contains(delivery.id)) {
      feedDeliveryIds.add(delivery.id);
      feedDeliveries.add(delivery);
      notifyListeners();
    }
  }

  updateMyDeliveriesList(Delivery delivery) {
    if (!myDeliveryIds.contains(delivery.id)) {
      myDeliveryIds.add(delivery.id);
      myDeliveries.add(delivery);
      notifyListeners();
    }
  }
}
