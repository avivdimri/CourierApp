import 'dart:convert';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:my_app/models/delivery.dart';
import 'package:provider/provider.dart';

import '../globalUtils/global.dart';
import '../models/courier.dart';
import 'allDeliveriesInfo.dart';
import '../models/directionDetailsInfo.dart';

import 'package:http/http.dart' as http;

class Utils {
  static Future<DirectionDetailsInfo?>
      obtainOriginToDestinationDirectionDetails(
          LatLng origionPosition, LatLng destinationPosition) async {
    String urlOriginToDestinationDirectionDetails =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${origionPosition.latitude},${origionPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$googleKey";

    var responseDirectionApi =
        await receiveRequest(urlOriginToDestinationDirectionDetails);

    if (responseDirectionApi == "Error Occurred, Failed. No Response.") {
      return null;
    }

    DirectionDetailsInfo directionDetailsInfo = DirectionDetailsInfo();
    directionDetailsInfo.e_points =
        responseDirectionApi["routes"][0]["overview_polyline"]["points"];

    directionDetailsInfo.distance_text =
        responseDirectionApi["routes"][0]["legs"][0]["distance"]["text"];
    directionDetailsInfo.distance_value =
        responseDirectionApi["routes"][0]["legs"][0]["distance"]["value"];

    directionDetailsInfo.duration_text =
        responseDirectionApi["routes"][0]["legs"][0]["duration"]["text"];
    directionDetailsInfo.duration_value =
        responseDirectionApi["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetailsInfo;
  }

  static pauseLiveLocationUpdates() async {
    streamSubscriptionPosition!.pause();
    await Geofire.removeLocation(userId);
  }

  static resumeLiveLocationUpdates() {
    streamSubscriptionPosition!.resume();
    Geofire.setLocation(userId, courierCurrentPosition!.latitude,
        courierCurrentPosition!.longitude);
  }

  static Future<void> updateDeliveriesForOnlineCourier(context) async {
    List<Delivery> deliveries = [];
    var response;
    try {
      response = await dio
          .get(basicUri + 'getAllDeliveries', queryParameters: {'id': userId});
    } catch (onError) {
      Fluttertoast.showToast(msg: "Error: " + onError.toString());
    }
    if (response != null) {
      var jsonList = response.data;
      var data = json.decode(jsonList);
      var map = data.map<Delivery>((json) => Delivery.fromJson(json));
      deliveries = map.toList();
      await Provider.of<AllDeliveriesInfo>(context, listen: false)
          .clearDeliveriesLists();
      for (Delivery delivery in deliveries) {
        if ((delivery.status == "arrived") && (delivery.courierId == userId)) {
          Provider.of<AllDeliveriesInfo>(context, listen: false)
              .updateHistoryDeliveriesList(delivery);
        } else if (delivery.status == "pending" &&
            !delivery.express &&
            delivery.vehicleTypes!.contains(courierInfo.vehicleType)) {
          Provider.of<AllDeliveriesInfo>(context, listen: false)
              .updateFeedDeliveriesList(delivery);
        } else if ((delivery.status == "assigned") &&
            (delivery.courierId == userId)) {
          Provider.of<AllDeliveriesInfo>(context, listen: false)
              .updateMyDeliveriesList(delivery);
        }
      }
    }
  }

  static Future<void> updateDeliveriesForOnlineCourier1(provider) async {
    // get all orders of current corier

    List<Delivery> deliveries = [];
    var response;
    try {
      response = await dio
          .get(basicUri + 'getAllDeliveries', queryParameters: {'id': userId});
    } catch (onError) {
      Fluttertoast.showToast(msg: "Error: " + onError.toString());
    }
    if (response != null) {
      var jsonList = response.data;
      var data = json.decode(jsonList);
      var map = data.map<Delivery>((json) => Delivery.fromJson(json));
      deliveries = map.toList();
      await provider.clearDeliveriesLists();
      for (Delivery delivery in deliveries) {
        if ((delivery.status == "arrived") && (delivery.courierId == userId)) {
          provider.updateHistoryDeliveriesList(delivery);
        } else if (delivery.status == "pending" &&
            !delivery.express &&
            delivery.vehicleTypes!.contains(courierInfo.vehicleType)) {
          provider.updateFeedDeliveriesList(delivery);
        } else if ((delivery.status == "assigned") &&
            (delivery.courierId == userId)) {
          provider.updateMyDeliveriesList(delivery);
        }
      }
    }
  }

  static Future<dynamic> receiveRequest(String url) async {
    http.Response httpResponse = await http.get(Uri.parse(url));
    try {
      if (httpResponse.statusCode == 200) //successful
      {
        String responseData = httpResponse.body; //json

        var decodeResponseData = jsonDecode(responseData);
        return decodeResponseData;
      } else {
        return "Error Occurred, Failed. No Response.";
      }
    } catch (exp) {
      return "Error Occurred, Failed. No Response.";
    }
  }

  static Future<void> getCourierInfo(context) async {
    var response;
    try {
      response = await dio.get(basicUri + 'get_courier/$userId');
    } catch (onError) {
      Fluttertoast.showToast(msg: "Error: " + onError.toString());
    }
    if (response != null) {
      var jsonList = response.data;
      var data = json.decode(jsonList);

      courierInfo = Courier.fromJson(data);
    }
  }
}
