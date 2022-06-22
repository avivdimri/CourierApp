import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:h3_flutter/h3_flutter.dart';
import 'package:my_app/globalUtils/utils.dart';
import 'package:my_app/models/delivery.dart';
import 'package:my_app/push_notfications/pushNotficationsSystem.dart';
import 'package:provider/provider.dart';
import '../../globalUtils/global.dart';
import '../../globalUtils/allDeliveriesInfo.dart';
import '../../globalUtils/googleMapsTheme.dart';
import '../../models/courier.dart';
import 'package:http/http.dart' as http;

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
    if (mounted) {
      newGoogleMapController!
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    }
  }

  @override
  void initState() {
    super.initState();
    if (streamSubscriptionPosition == null && activeAfterKill) {
      courierIsOnline();
      updateCourierLocationAtRT();
    }
    checkIfLocationPermissionAllowed();
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
                if (!isCourierActive!) {
                  courierIsOnline();
                  setState(() {
                    statusText = "Online";
                    isCourierActive = true;
                    prefs.setString('isActive', "true");
                    buttonColor = Colors.transparent;
                  });
                  updateCourierLocationAtRT();
                  Fluttertoast.showToast(msg: "you are online now");
                } else {
                  courierIsOffline();
                  setState(() {
                    statusText = "Offline";
                    isCourierActive = false;
                    prefs.setString('isActive', "false");
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
    var index = h3.geoToH3(geoCoord, 7);
    indexRef.child(userId).set(index.toRadixString(16));

    if (mounted) {
      Geofire.setLocation(userId, courierCurrentPosition!.latitude,
          courierCurrentPosition!.longitude);
    }

    //update the stauts of the courier

    updateCourierStatus("idle");
  }

  void courierIsOffline() async {
    FirebaseDatabase.instance.ref().child("indexes").child(userId).remove();
    await Geofire.removeLocation(userId);
    updateCourierStatus("offline");
    /*Future.delayed(const Duration(milliseconds: 2000), () async {
      SystemNavigator.pop();
    });*/
  }

  void updateCourierLocationAtRT() {
    streamSubscriptionPosition =
        Geolocator.getPositionStream().listen((Position position) {
      courierCurrentPosition = position;
      if (isCourierActive!) {
        Geofire.setLocation(userId, courierCurrentPosition!.latitude,
            courierCurrentPosition!.longitude);
        DatabaseReference indexRef =
            FirebaseDatabase.instance.ref().child("indexes");
        GeoCoord geoCoord = GeoCoord(
            lon: courierCurrentPosition!.longitude,
            lat: courierCurrentPosition!.latitude);
        var index = h3.geoToH3(geoCoord, 7);
        indexRef.child(userId).set(index.toRadixString(16));
      }

      LatLng latLng = LatLng(
          courierCurrentPosition!.latitude, courierCurrentPosition!.longitude);
      if (mounted && newGoogleMapController != null) {
        newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));
      }
    });
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

    //print('User updated: ${response.data}');
  } catch (onerror) {
    Fluttertoast.showToast(
        msg: 'Error updateCourierStatus function updating user: ' +
            onerror.toString());
  }
}

Future<String> updateDeliveryStatus(String status, Delivery delivery) async {
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
    return response.data;
  } catch (e) {
    Fluttertoast.showToast(
        msg: 'Error updateDeliveryStatus function  updating user: $e');
    return "failed";
  }
}
