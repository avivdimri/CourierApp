import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_app/assistants/request_assistant.dart';
import 'package:my_app/authentication/global.dart';
import 'package:provider/provider.dart';

import '../infoHandler/app_info.dart';
import '../models/direction_details_info.dart';
import '../models/directions.dart';
import '../models/user_model.dart';

class AssistantMethods {
  static Future<String> searchAddressForGeographicCoOrdinates(
      Position position, context) async {
    String apiUrl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$google_key";
    String humanReadableAddress = "";

    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);

    if (requestResponse != "Error Occurred, Failed. No Response.") {
      print("step 1!!!!!1");
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

  // static void readCurrentOnlineUserInfo() async {
  //   currentFirebaseUser = fAuth.currentUser;

  //   DatabaseReference userRef = FirebaseDatabase.instance
  //       .ref()
  //       .child("users")
  //       .child(currentFirebaseUser!.uid);

  //   userRef.once().then((snap) {
  //     if (snap.snapshot.value != null) {
  //       userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);
  //     }
  //   });
  // }

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
}
