import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_app/Screens/Tabs/homeTab.dart';
import 'package:my_app/globalUtils/global.dart';
import 'package:my_app/models/delivery.dart';
import '../globalUtils/googleMapsTheme.dart';
import '../globalUtils/utils.dart';
import '../widgets/progressDialog.dart';

class TripScreen extends StatefulWidget {
  Delivery deliveryDetails;

  TripScreen({required this.deliveryDetails});

  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  GoogleMapController? newTripGoogleMapController;
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  String buttonTitle = "Arrived";
  Color buttonColor = Colors.green;
  String contactInfo = "";

  Set<Marker> setOfMarkers = Set<Marker>();
  Set<Circle> setOfCircle = Set<Circle>();
  Set<Polyline> setOfPolyline = Set<Polyline>();
  List<LatLng> polyLinePositionCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  double mapPadding = 0;
  BitmapDescriptor? iconMarker;
  var geoLocator = Geolocator();
  String deliveryStatus = "accepted";
  String durationOrgToDest = "";
  bool isRequestDetails = false;

  Future<void> drawPolyLineFromOriginToDestination(
      LatLng originLatLng, LatLng destinationLatLng) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressBox(
        message: "Please wait...",
      ),
    );

    var directionDetailsInfo =
        await Utils.obtainOriginToDestinationDirectionDetails(
            originLatLng, destinationLatLng);

    Navigator.pop(context);

    print(directionDetailsInfo!.e_points);

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResultList =
        pPoints.decodePolyline(directionDetailsInfo.e_points!);

    polyLinePositionCoordinates.clear();

    if (decodedPolyLinePointsResultList.isNotEmpty) {
      decodedPolyLinePointsResultList.forEach((PointLatLng pointLatLng) {
        polyLinePositionCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    setOfPolyline.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: Colors.purpleAccent,
        polylineId: const PolylineId("PolylineID"),
        jointType: JointType.round,
        points: polyLinePositionCoordinates,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      setOfPolyline.add(polyline);
    });

    LatLngBounds boundsLatLng;
    if (originLatLng.latitude > destinationLatLng.latitude &&
        originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng =
          LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);
    } else if (originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
        northeast: LatLng(destinationLatLng.latitude, originLatLng.longitude),
      );
    } else if (originLatLng.latitude > destinationLatLng.latitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
        northeast: LatLng(originLatLng.latitude, destinationLatLng.longitude),
      );
    } else {
      boundsLatLng =
          LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);
    }

    newTripGoogleMapController!
        .animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 65));

    Marker originMarker = Marker(
      markerId: const MarkerId("originID"),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    Marker destinationMarker = Marker(
      markerId: const MarkerId("destinationID"),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      setOfMarkers.add(originMarker);
      setOfMarkers.add(destinationMarker);
    });

    Circle originCircle = Circle(
      circleId: const CircleId("originID"),
      fillColor: Colors.green,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: originLatLng,
    );

    Circle destinationCircle = Circle(
      circleId: const CircleId("destinationID"),
      fillColor: Colors.red,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: destinationLatLng,
    );

    setState(() {
      setOfCircle.add(originCircle);
      setOfCircle.add(destinationCircle);
    });
  }

  createCourierIconMarker() {
    if (iconMarker == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: const Size(2, 2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "images/car.png")
          .then((value) {
        iconMarker = value;
      });
    }
  }

  void getCourierLocationAtRT() {
    LatLng oldLatLng = LatLng(0, 0);
    streamSubscriptionCourierLivePosition =
        Geolocator.getPositionStream().listen((Position position) {
      courierCurrentPosition = position;
      LatLng latLngOnline = LatLng(
          courierCurrentPosition!.latitude, courierCurrentPosition!.longitude);

      Marker marker = Marker(
        markerId: const MarkerId("AnimatedMarker"),
        position: latLngOnline,
        icon: iconMarker!,
        infoWindow: const InfoWindow(title: "This is your location"),
      );
      if (mounted) {
        setState(() {
          CameraPosition cameraPosition =
              CameraPosition(target: latLngOnline, zoom: 16);
          newTripGoogleMapController!
              .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
          setOfMarkers.removeWhere(
              (element) => element.markerId.value == "AnimatedMarker");
          setOfMarkers.add(marker);
        });
      }
      oldLatLng = latLngOnline;
      updateDurationTimeAtRT();
    });
  }

  updateDurationTimeAtRT() async {
    if (!isRequestDetails) {
      isRequestDetails = true;
      if (courierCurrentPosition == null) {
        return;
      }
      LatLng originLatLng = LatLng(
          courierCurrentPosition!.latitude, courierCurrentPosition!.longitude);
      LatLng destLatLng;
      if (deliveryStatus == "accepted") {
        destLatLng = LatLng(double.parse(widget.deliveryDetails.src.lat),
            double.parse(widget.deliveryDetails.src.long));
      } else {
        destLatLng = LatLng(double.parse(widget.deliveryDetails.dest.lat),
            double.parse(widget.deliveryDetails.dest.long));
      }
      var directionInfo = await Utils.obtainOriginToDestinationDirectionDetails(
          originLatLng, destLatLng);
      if (directionInfo != null) {
        if (mounted) {
          setState(() {
            durationOrgToDest = directionInfo.duration_text!;
          });
        }
      }
      isRequestDetails = false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    contactInfo = "   " +
        widget.deliveryDetails.srcContact.name +
        "   " +
        widget.deliveryDetails.srcContact.phone;
  }

  @override
  Widget build(BuildContext context) {
    createCourierIconMarker();
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapPadding),
            mapType: MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: _kGooglePlex,
            markers: setOfMarkers,
            circles: setOfCircle,
            polylines: setOfPolyline,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newTripGoogleMapController = controller;
              setState(() {
                mapPadding = 350;
              });

              blackThemeGoogleMap(newTripGoogleMapController);
              var courierCurrentLatLng = LatLng(
                  courierCurrentPosition!.latitude,
                  courierCurrentPosition!.longitude);

              var deliveryPickUpLatLng = LatLng(
                  double.parse(widget.deliveryDetails.src.lat),
                  double.parse(widget.deliveryDetails.src.long));

              drawPolyLineFromOriginToDestination(
                  courierCurrentLatLng, deliveryPickUpLatLng);
              getCourierLocationAtRT();
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white30,
                      blurRadius: 18,
                      spreadRadius: .5,
                      offset: Offset(0.6, 0.6),
                    )
                  ]),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: Column(
                  children: [
                    //duration
                    Text(
                      durationOrgToDest,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightGreenAccent,
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    const Divider(
                      thickness: 2,
                      height: 2,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      height: 8,
                    ),

                    //username icon
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(7.0),
                          child: Icon(
                            Icons.phone_android,
                            color: Colors.blue,
                          ),
                        ),
                        Text(
                          contactInfo,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    // usr pickup icon
                    Row(
                      children: [
                        Image.asset(
                          "images/origin.png",
                          width: 42,
                          height: 30,
                        ),
                        const SizedBox(
                          width: 14,
                        ),
                        Expanded(
                          child: Container(
                            child: Text(
                              widget.deliveryDetails.srcAddress,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                    //user Dropoff icon
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          "images/destination.png",
                          width: 42,
                          height: 30,
                        ),
                        const SizedBox(
                          width: 14,
                        ),
                        Expanded(
                          child: Container(
                            child: Text(
                              widget.deliveryDetails.destAddress,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),

                    const Divider(
                      thickness: 2,
                      height: 2,
                      color: Colors.grey,
                    ),

                    const SizedBox(
                      height: 10.0,
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        if (deliveryStatus == "accepted") {
                          contactInfo = "   " +
                              widget.deliveryDetails.destContact.name +
                              "   " +
                              widget.deliveryDetails.destContact.phone;
                          deliveryStatus = "arrived";
                          setState(() {
                            buttonTitle = "Start Trip";
                            buttonColor = Colors.blueAccent;
                          });

                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext b) => ProgressBox(
                                    message: "Loading...",
                                  ));

                          await drawPolyLineFromOriginToDestination(
                              LatLng(
                                  double.parse(widget.deliveryDetails.src.lat),
                                  double.parse(
                                      widget.deliveryDetails.src.long)),
                              LatLng(
                                  double.parse(widget.deliveryDetails.dest.lat),
                                  double.parse(
                                      widget.deliveryDetails.dest.long)));
                          Navigator.pop(context);
                        } else if (deliveryStatus == "arrived") {
                          deliveryStatus = "ontrip";
                          setState(() {
                            buttonTitle = "End Trip";
                            buttonColor = Colors.redAccent;
                          });

                          updateDeliveryStatus(
                              "collected", widget.deliveryDetails);
                        } else if (deliveryStatus == "ontrip") {
                          //update DB status order
                          updateDeliveryStatus(
                              "arrived", widget.deliveryDetails);
                          streamSubscriptionCourierLivePosition!.cancel();
                          Utils.resumeLiveLocationUpdates();
                          updateCourierStatus("idle");
                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: buttonColor,
                      ),
                      icon: const Icon(
                        Icons.directions_car,
                        color: Colors.white,
                        size: 25,
                      ),
                      label: Text(
                        buttonTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
