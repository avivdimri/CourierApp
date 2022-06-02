import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:h3_flutter/h3_flutter.dart';
import 'package:my_app/assistants/assistant_methods.dart';
import 'package:my_app/models/delivery.dart';
import 'package:my_app/push_notfications/push_notfications_syystem.dart';
import '../../assistants/black_theme.dart';
import '../../assistants/global.dart';
import '../../models/courier.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({Key? key}) : super(key: key);

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  GoogleMapController? newGoogleMapController;
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  var geoLocator = Geolocator();
  LocationPermission? _locationPermission;

  Color buttonColor = Colors.grey;

  checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();
    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  void locateDriverPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    courierCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(
        courierCurrentPosition!.latitude, courierCurrentPosition!.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14);

    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    //String humanReadableAddress =
    //  await AssistantMethods.searchAddressForGeographicCoOrdinates(
    //    courierCurrentPosition!, context);
    //print("this is your address = " + humanReadableAddress);
  }

  readCurrentCourierInfo() async {
    PushNotficationsSystem pushNotficationsSystem = PushNotficationsSystem();
    pushNotficationsSystem.initCloudMessaging(context);
    pushNotficationsSystem.generateToken();
    AssistantMethods.readTripsKeysForOnlineCourier(context);
    getCourierInfo();
  }

  @override
  void initState() {
    super.initState();

    checkIfLocationPermissionAllowed();
    readCurrentCourierInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          myLocationEnabled: true,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controllerGoogleMap.complete(controller);
            newGoogleMapController = controller;

            //black theme
            blackThemeGoogleMap(newGoogleMapController);
            locateDriverPosition();
          },
        ),
        statusText != "Online"
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                color: Colors.black87,
              )
            : Container(),
        Positioned(
          top: statusText != "Online"
              ? MediaQuery.of(context).size.height * 0.4
              : 25,
          left: 0,
          right: 0,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              onPressed: () {
                if (!isCourierActive) {
                  courierIsOnline();
                  updateCourierLocationAtRT();
                  setState(() {
                    statusText = "Online";
                    isCourierActive = true;
                    buttonColor = Colors.transparent;
                  });
                  Fluttertoast.showToast(msg: "you are online now");
                } else {
                  courierIsOffline();
                  setState(() {
                    statusText = "Offline";
                    isCourierActive = false;
                    buttonColor = Colors.grey;
                  });
                  Fluttertoast.showToast(msg: "you are offline now");
                }
              },
              style: ElevatedButton.styleFrom(
                primary: buttonColor,
                padding: const EdgeInsets.symmetric(horizontal: 38),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
              ),
              child: statusText != "Online"
                  ? Text(
                      statusText,
                      style: const TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.phonelink_ring,
                      color: Colors.white,
                      size: 26,
                    ),
            ),
          ]),
        )
      ],
    );
  }

  void courierIsOnline() async {
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    courierCurrentPosition = pos;
    Geofire.initialize("activeCouriers");
    DatabaseReference indexRef =
        FirebaseDatabase.instance.ref().child("indexes");
    GeoCoord geoCoord = GeoCoord(
        lon: courierCurrentPosition!.longitude,
        lat: courierCurrentPosition!.latitude);
    //var index = coordToIndex(courierCurrentPosition!.longitude,
    // courierCurrentPosition!.latitude);
    var index = h3.geoToH3(geoCoord, 7);
    indexRef.child(userId).set(index.toRadixString(16));
    indexRef.child(userId).set(index);
    Geofire.setLocation(userId, courierCurrentPosition!.latitude,
        courierCurrentPosition!.longitude);
    //update the stauts of the courier

    updateCourierStatus("idle");
  }

  void courierIsOffline() async {
    FirebaseDatabase.instance.ref().child("indexes").remove();
    Geofire.removeLocation(userId);
    updateCourierStatus("offline");
    Future.delayed(const Duration(milliseconds: 2000), () async {
      SystemNavigator.pop();
    });
  }

  void updateCourierLocationAtRT() {
    streamSubscriptionPosition =
        Geolocator.getPositionStream().listen((Position position) {
      courierCurrentPosition = position;
      if (isCourierActive) {
        Geofire.setLocation(userId, courierCurrentPosition!.latitude,
            courierCurrentPosition!.longitude);
        DatabaseReference indexRef =
            FirebaseDatabase.instance.ref().child("indexes");
        GeoCoord geoCoord = GeoCoord(
            lon: courierCurrentPosition!.longitude,
            lat: courierCurrentPosition!.latitude);
        //var index = coordToIndex(courierCurrentPosition!.longitude,
        // courierCurrentPosition!.latitude);
        var index = h3.geoToH3(geoCoord, 7);
        indexRef.child(userId).set(index.toRadixString(16));
      }
      LatLng latLng = LatLng(
          courierCurrentPosition!.latitude, courierCurrentPosition!.longitude);
      newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  /*coordToIndex(longitude, latitude) {
    print("the latlong is" + longitude.toString() + " " + latitude.toString());
    GeoCoord geoCoord = GeoCoord(lon: longitude, lat: latitude);
    return h3.geoToH3(geoCoord, 7);
  }*/

  Future<void> getCourierInfo() async {
    try {
      var response = await dio.get(basicUri + 'get_courier/$userId');
      var jsonList = response.data;
      var data = json.decode(jsonList);
      setState(() {
        courierInfo = Courier.fromJson(data);
      });
    } catch (onError) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error: " + onError.toString());
    }
  }
}

void updateCourierStatus(String status) async {
  var json = jsonEncode(<String, String>{
    'status': status,
  });
  try {
    Response response = await dio.put(
      basicUri + 'courier_status/$userId',
      data: json,
    );

    print('User updated: ${response.data}');
  } catch (e) {
    print('Error updating user: $e');
  }
}

void updateDeliveryStatus(String status, Delivery delivery) async {
  var deliveryId = delivery.id;
  var json = jsonEncode(<String, String>{
    'status': status,
    'courier_id': userId,
  });
  try {
    Response response = await dio.put(
      basicUri + 'delivery_status/$deliveryId',
      data: json,
    );
    print('User updated: ${response.data}');
  } catch (e) {
    print('Error updating user: $e');
  }
}
