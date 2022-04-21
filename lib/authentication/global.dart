import 'dart:async';

import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';

bool isLoggedIn = false;
String name = '';
String userId = '';
void printstate(String func) {
  print("the func is: " +
      func +
      " ,the parmater status is:  isLoggedIn = " +
      isLoggedIn.toString() +
      ", name is = " +
      name +
      ", userId is = " +
      userId);
}

var dio = Dio();
String google_key = 'AIzaSyCqcNNmxm-9YBysFypGjn8BUwdM3TUUegw';
//UserModel? userModelCurrentInfo;
StreamSubscription<Position>? streamSubscriptionPosition;
String basicUri = '';
