import 'dart:convert';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_app/Screens/Tabs/homeTab.dart';
import 'package:my_app/push_notfications/localNotificationSystem.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../globalUtils/utils.dart';
import '../globalUtils/global.dart';
import '../models/delivery.dart';
import 'notficationBox.dart';
import 'package:intl/intl.dart';

class PushNotficationsSystem {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future initCloudMessaging(BuildContext context) async {
    // terminated
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        readOrderRequestInfo(remoteMessage.data["deliveryId"],
            remoteMessage.data["reminder"], context);
      }
    });

    // foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
      readOrderRequestInfo(remoteMessage!.data["deliveryId"],
          remoteMessage.data["reminder"], context);
    });
    // background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      readOrderRequestInfo(remoteMessage!.data["deliveryId"],
          remoteMessage.data["reminder"], context);
    });
  }

  readOrderRequestInfo(
      String orderId, String reminder, BuildContext context) async {
    var response;
    try {
      response = await dio.get(basicUri + 'get_order/$orderId');
    } catch (onError) {
      Fluttertoast.showToast(msg: "Error: " + onError.toString());
    }
    if (response != null) {
      audioPlayer.open(Audio("music/mixkit-positive-notification-951.mp3"));
      audioPlayer.play();
      var jsonList = response.data;
      var data = json.decode(jsonList);

      Delivery delivery = Delivery.fromJson(data);
      showDialog(
          context: context,
          builder: (BuildContext context) => NotificationBox(
                deliveryDetails: delivery,
              ));
    }
  }

  Future generateToken() async {
    String? token = await messaging.getToken();
    addCourierToken(token!);
    messaging.subscribeToTopic("allCouriers");
  }

  void addCourierToken(String token) async {
    var json = jsonEncode(<String, String>{
      'token': token,
    });
    var response;

    try {
      response = await dio.put(
        basicUri + 'courier_token/$userId',
        data: json,
      );
    } catch (onError) {
      Fluttertoast.showToast(msg: "Error: " + onError.toString());
    }
    if (response != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
    }
  }
}
