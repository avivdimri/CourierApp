import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/courier.dart';

bool isLoggedIn = false;
String statusText = "Start Shift";
bool? isCourierActive;
bool activeAfterKill = false;
String name = '';
String userId = '';
late final SharedPreferences prefs;
Color buttonColor = Colors.green;

var dio = Dio();
String googleKey = 'AIzaSyCqcNNmxm-9YBysFypGjn8BUwdM3TUUegw';
StreamSubscription<Position>? streamSubscriptionPosition;
StreamSubscription<Position>? streamSubscriptionCourierLivePosition;
String basicUri = '';
AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
Position? courierCurrentPosition;
FirebaseDatabase database = FirebaseDatabase.instance;
Courier courierInfo = Courier(
  firstName: "",
  lastName: "",
  email: "",
  password: "",
  phoneNumber: "",
  vehicleType: "",
);
