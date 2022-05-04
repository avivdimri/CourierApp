import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import '../authentication/global.dart';

// class PushNotficationsSystem {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//   Future initCloudMessaging() async {
//     // terminated
//     FirebaseMessaging.instance
//         .getInitialMessage()
//         .then((RemoteMessage? remoteMessage) {
//       if (remoteMessage != null) {}
//     });

//     // foreground
//     FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {});
//     // background
//     FirebaseMessaging.onMessageOpenedApp
//         .listen((RemoteMessage? remoteMessage) {});
//   }

//   Future<String> generateToken() async {
//     String? token = await messaging.getToken();
//   }

//   void addCourierToken(String token) async {
//     var json = jsonEncode(<String, String>{
//       'token': token,
//     });
//     try {
//       Response response = await dio.put(
//         basicUri + 'courier_token/$userId',
//         data: json,
//       );

//       print('User updated: ${response.data}');
//       final SharedPreferences prefs = await SharedPreferences.getInstance();
//       prefs.setString('token', token);
//     } catch (e) {
//       print('Error updating user: $e');
//     }
//   }
// }
