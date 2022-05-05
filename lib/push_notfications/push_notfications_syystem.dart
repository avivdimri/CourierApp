import 'dart:convert';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../authentication/global.dart';
import '../models/delivery.dart';
import 'notfication_dialog_box.dart';

class PushNotficationsSystem {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  Future initCloudMessaging(BuildContext context) async {
    // terminated
    print(" in the function");
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        print("TThis is order id: " + remoteMessage.data["order_id"]);
        readOrderRequestInfo(remoteMessage.data["order_id"], context);
      }
    });

    // foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
      print("TThis is order id: " + remoteMessage!.data["order_id"]);
      readOrderRequestInfo(remoteMessage.data["order_id"], context);
    });
    // background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      print("TThis is order id: " + remoteMessage!.data["order_id"]);
      readOrderRequestInfo(remoteMessage.data["order_id"], context);
    });
  }

  readOrderRequestInfo(String orderId, BuildContext context) async {
    var response;
    try {
      response = await Dio().get(basicUri + 'get_order/$orderId');
    } catch (onError) {
      Fluttertoast.showToast(msg: "Error: " + onError.toString());
    }
    if (response != null) {
      audioPlayer.open(Audio("music/mixkit-positive-notification-951.mp3"));
      audioPlayer.play();
      var jsonList = response.data;
      print("11111111: " + jsonList);
      var data = json.decode(jsonList);
      Delivery delivery = Delivery.fromJson(data);
      print("delivery details is " + delivery.toString());

      showDialog(
          context: context,
          builder: (BuildContext context) =>
              NotificationDialogBox(deliveryDetails: delivery));
    }
    // double srcLat = double.parse(data["src"]["lat"]);
    // double srcLong = double.parse(data["src"]["long"]);

    // double desLat = double.parse(data["destination"]["lat"]);
    // double desLong = double.parse(data["destination"]["long"]);

    // String userName = data["src_contact"];

    // print(" src location is :" + srcLat.toString() + " " + srcLong.toString());
  }

  Future generateToken() async {
    String? token = await messaging.getToken();
    print("FCM registraion token: " + token!);
    addCourierToken(token);
    messaging.subscribeToTopic("allCouriers");
  }

  void addCourierToken(String token) async {
    var json = jsonEncode(<String, String>{
      'token': token,
    });
    try {
      Response response = await dio.put(
        basicUri + 'courier_token/$userId',
        data: json,
      );

      print('User updated: ${response.data}');
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
    } catch (e) {
      print('Error updating user: $e');
    }
  }
}
