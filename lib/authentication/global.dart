import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';

bool isLoggedIn = false;
String statusText = "Offline";
bool isCourierActive = false;
String name = '';
String userId = '';

var dio = Dio();
String google_key = 'AIzaSyCqcNNmxm-9YBysFypGjn8BUwdM3TUUegw';
StreamSubscription<Position>? streamSubscriptionPosition;
String basicUri = '';
AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
