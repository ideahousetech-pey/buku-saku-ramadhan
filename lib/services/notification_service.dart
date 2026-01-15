import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

class NotificationService {
  static final _notif = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tzdata.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: android);

    await _notif.initialize(initSettings);
  }

  static Future<void> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime time,
    required bool isFajr,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'adzan_channel',
      'Adzan',
      channelDescription: 'Notifikasi waktu sholat',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound(
        isFajr ? 'adzan_fajr' : 'adzan',
      ),
    );

    await _notif.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(time, tz.local),
      NotificationDetails(android: androidDetails),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}