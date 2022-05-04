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

import '../../assistants/assistant_methods.dart';
import '../../authentication/global.dart';

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
  Position? courierCurrentPosition;
  var geoLocator = Geolocator();
  LocationPermission? _locationPermission;

  Color buttonColor = Colors.grey;

  checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();
    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  locateDriverPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    courierCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(
        courierCurrentPosition!.latitude, courierCurrentPosition!.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14);

    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress =
        await AssistantMethods.searchAddressForGeographicCoOrdinates(
            courierCurrentPosition!, context);
    print("this is your address = " + humanReadableAddress);
  }

  @override
  void initState() {
    super.initState();

    checkIfLocationPermissionAllowed();
  }

  void blackThemeGoogleMap() {
    newGoogleMapController!.setMapStyle('''
                      [
                        {
                          "elementType": "geometry",
                          "stylers": [
                            {
                              "color": "#242f3e"
                            }
                          ]
                        },
                        {
                          "elementType": "labels.text.fill",
                          "stylers": [
                            {
                              "color": "#746855"
                            }
                          ]
                        },
                        {
                          "elementType": "labels.text.stroke",
                          "stylers": [
                            {
                              "color": "#242f3e"
                            }
                          ]
                        },
                        {
                          "featureType": "administrative.locality",
                          "elementType": "labels.text.fill",
                          "stylers": [
                            {
                              "color": "#d59563"
                            }
                          ]
                        },
                        {
                          "featureType": "poi",
                          "elementType": "labels.text.fill",
                          "stylers": [
                            {
                              "color": "#d59563"
                            }
                          ]
                        },
                        {
                          "featureType": "poi.park",
                          "elementType": "geometry",
                          "stylers": [
                            {
                              "color": "#263c3f"
                            }
                          ]
                        },
                        {
                          "featureType": "poi.park",
                          "elementType": "labels.text.fill",
                          "stylers": [
                            {
                              "color": "#6b9a76"
                            }
                          ]
                        },
                        {
                          "featureType": "road",
                          "elementType": "geometry",
                          "stylers": [
                            {
                              "color": "#38414e"
                            }
                          ]
                        },
                        {
                          "featureType": "road",
                          "elementType": "geometry.stroke",
                          "stylers": [
                            {
                              "color": "#212a37"
                            }
                          ]
                        },
                        {
                          "featureType": "road",
                          "elementType": "labels.text.fill",
                          "stylers": [
                            {
                              "color": "#9ca5b3"
                            }
                          ]
                        },
                        {
                          "featureType": "road.highway",
                          "elementType": "geometry",
                          "stylers": [
                            {
                              "color": "#746855"
                            }
                          ]
                        },
                        {
                          "featureType": "road.highway",
                          "elementType": "geometry.stroke",
                          "stylers": [
                            {
                              "color": "#1f2835"
                            }
                          ]
                        },
                        {
                          "featureType": "road.highway",
                          "elementType": "labels.text.fill",
                          "stylers": [
                            {
                              "color": "#f3d19c"
                            }
                          ]
                        },
                        {
                          "featureType": "transit",
                          "elementType": "geometry",
                          "stylers": [
                            {
                              "color": "#2f3948"
                            }
                          ]
                        },
                        {
                          "featureType": "transit.station",
                          "elementType": "labels.text.fill",
                          "stylers": [
                            {
                              "color": "#d59563"
                            }
                          ]
                        },
                        {
                          "featureType": "water",
                          "elementType": "geometry",
                          "stylers": [
                            {
                              "color": "#17263c"
                            }
                          ]
                        },
                        {
                          "featureType": "water",
                          "elementType": "labels.text.fill",
                          "stylers": [
                            {
                              "color": "#515c6d"
                            }
                          ]
                        },
                        {
                          "featureType": "water",
                          "elementType": "labels.text.stroke",
                          "stylers": [
                            {
                              "color": "#17263c"
                            }
                          ]
                        }
                      ]
                  ''');
  }

  @override
  Widget build(BuildContext context) {
    print("aviv is the king!!");
    print("the status is : " + statusText.toString());
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
            blackThemeGoogleMap();
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
                  //updateCourierLocationAtRT();
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

  updateCorierStatus(String status) async {
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

  courierIsOnline() async {
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    courierCurrentPosition = pos;
    Geofire.initialize("activeCouriers");
    print("create new db");
    Geofire.setLocation(userId, courierCurrentPosition!.latitude,
        courierCurrentPosition!.longitude);
    //update the stauts of the courier
    updateCorierStatus("idle");
  }

  courierIsOffline() async {
    Geofire.removeLocation(userId);
    updateCorierStatus("offline");
    Future.delayed(const Duration(milliseconds: 2000), () async {
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
    });
  }

  updateCourierLocationAtRT() {
    print("update location");
    streamSubscriptionPosition =
        Geolocator.getPositionStream().listen((Position position) {
      courierCurrentPosition = position;
      if (isCourierActive) {
        Geofire.setLocation(userId, courierCurrentPosition!.latitude,
            courierCurrentPosition!.longitude);
      }
      LatLng latLng = LatLng(
          courierCurrentPosition!.latitude, courierCurrentPosition!.longitude);
      newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }
}
