import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class LocalNotificationSystem {
  static final notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future _notificationDetails() async {
    const styleInformation = BigPictureStyleInformation(
      DrawableResourceAndroidBitmap("reminder"),
    );
    //FilePathAndroidBitmap('images/35303782.jpg'));
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'channel description',
        importance: Importance.max,
        styleInformation: styleInformation,
      ),
    );
  }

  static Future init() async {
    final details = await notifications.getNotificationAppLaunchDetails();

    const android = AndroidInitializationSettings('@/mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    if ((details != null) && (details.didNotificationLaunchApp)) {
      onNotifications.add(details.payload);
    }
    await notifications.initialize(settings,
        onSelectNotification: (deliveryId) async {
      onNotifications.add(deliveryId);
    });
    tz.initializeTimeZones();
    final locationName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(locationName));
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? deliveryId,
  }) async {
    notifications.show(id, title, body, await _notificationDetails(),
        payload: deliveryId);
  }

  static Future showScheduledNotification({
    int id = 0,
    String? title,
    String? body,
    String? deliveryId,
    required DateTime scheduledDate,
  }) async {
    notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      await _notificationDetails(),
      payload: deliveryId,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static void cancel(int id) {
    notifications.cancel(id);
  }

  static void cancelAll() {
    notifications.cancelAll();
  }
}
