import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_app/assistants/request_assistant.dart';
import 'package:my_app/authentication/global.dart';
import 'package:my_app/models/delivery.dart';
import 'package:provider/provider.dart';

import '../infoHandler/app_info.dart';
import '../models/direction_details_info.dart';
import '../models/directions.dart';

class AssistantMethods {
  static Future<String> searchAddressForGeographicCoOrdinates(
      Position position, context) async {
    String apiUrl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$google_key";
    String humanReadableAddress = "";

    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);

    if (requestResponse != "Error Occurred, Failed. No Response.") {
      humanReadableAddress = requestResponse["results"][0]["formatted_address"];

      Directions userPickUpAddress = Directions();
      userPickUpAddress.locationLatitude = position.latitude;
      userPickUpAddress.locationLongitude = position.longitude;
      userPickUpAddress.locationName = humanReadableAddress;

      Provider.of<AppInfo>(context, listen: false)
          .updatePickUpLocationAddress(userPickUpAddress);
    }

    return humanReadableAddress;
  }

  static Future<DirectionDetailsInfo?>
      obtainOriginToDestinationDirectionDetails(
          LatLng origionPosition, LatLng destinationPosition) async {
    String urlOriginToDestinationDirectionDetails =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${origionPosition.latitude},${origionPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$google_key";

    var responseDirectionApi = await RequestAssistant.receiveRequest(
        urlOriginToDestinationDirectionDetails);

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

  static pauseLiveLocationUpdates() {
    streamSubscriptionPosition!.pause();
    Geofire.removeLocation(userId);
  }

  static resumeLiveLocationUpdates() {
    streamSubscriptionPosition!.resume();
    Geofire.setLocation(userId, courierCurrentPosition!.latitude,
        courierCurrentPosition!.longitude);
  }

  static void readTripsKeysForOnlineCourier(context) async {
    // get all orders of current corier
    List<Delivery> deliveries = [];
    var response;
    try {
      response = await dio.get(basicUri, queryParameters: {'id': userId});
    } catch (onError) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error: " + onError.toString());
    }
    var jsonList = response.data;
    var data = json.decode(jsonList);
    print(" the delivries are " + data.toString());
    var map = data.map<Delivery>((json) => Delivery.fromJson(json));
    deliveries = map.toList();

    int overAllTripsCounter = map.length;
    Provider.of<AppInfo>(context, listen: false)
        .updateOverAllTripsCounter(overAllTripsCounter);

    for (Delivery delivery in deliveries) {
      if (delivery.status == "arrived") {
        Provider.of<AppInfo>(context, listen: false)
            .updateOverAllTripsHistoryInformation(delivery);
      }
    }
  }
}
