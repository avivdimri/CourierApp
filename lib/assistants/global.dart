import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_app/models/courier.dart';

bool isLoggedIn = false;
String statusText = "Offline";
bool isCourierActive = false;
String name = '';
String userId = '';

var dio = Dio();
String google_key = 'AIzaSyCqcNNmxm-9YBysFypGjn8BUwdM3TUUegw';
StreamSubscription<Position>? streamSubscriptionPosition;
StreamSubscription<Position>? streamSubscriptionCourierLivePosition;
String basicUri = '';
Courier? courierInfo = Courier(
    first_name: "",
    last_name: "",
    email: "",
    password: "",
    phone_number: "",
    VehicleType: "",
    company_id: []);
AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
Position? courierCurrentPosition;
FirebaseDatabase database = FirebaseDatabase.instance;
