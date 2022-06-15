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
        print("terminated!!!!");
        readOrderRequestInfo(remoteMessage.data["deliveryId"],
            remoteMessage.data["reminder"], context);
      }
    });

    // foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
      print("foreground!!!!");
      readOrderRequestInfo(remoteMessage!.data["deliveryId"],
          remoteMessage.data["reminder"], context);
    });
    // background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      print("background!!!!");
      readOrderRequestInfo(remoteMessage!.data["deliveryId"],
          remoteMessage.data["reminder"], context);
    });
  }

  static createFutureNotfication(
      Delivery delivery, BuildContext context) async {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime dateTime = dateFormat.parse(delivery.deadline!);
    DateTime now = DateTime.now().add(const Duration(hours: 1));
    if (dateTime.isBefore(now)) {
      Fluttertoast.showToast(
          msg:
              "Error: the dead line passed please contact with the your company");
      return;
    }
    //dateTime = DateTime.now().add(const Duration(seconds: 80));
    await updateDeliveryStatus("assigned", delivery);
    await Utils.updateDeliveriesForOnlineCourier(context);

    LocalNotificationSystem.showScheduledNotification(
        id: identityHashCode(delivery.id),
        title: "Reminder",
        body: "It's time to go out",
        deliveryId: delivery.id,
        scheduledDate: dateTime);
  }

  readOrderRequestInfo(
      String orderId, String reminder, BuildContext context) async {
    var response;
    try {
      response = await dio.get(basicUri + 'get_order/$orderId');
    } catch (onError) {
      print("error !!!! readOrderRequestInfo function  ");
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
    print("FCM registraion token: " + token!);
    addCourierToken(token);
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
      print('Error "add couroer token function" updating user: ' +
          onError.toString());
    }
    if (response != null) {
      print('User updated: ${response.data}');
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
    }
  }
}
