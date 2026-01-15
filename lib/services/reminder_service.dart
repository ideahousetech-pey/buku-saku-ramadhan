import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class ReminderService {
  static final _notif = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _notif.initialize(
      const InitializationSettings(android: android),
    );
  }

  static Future<void> scheduleSahurImsak({
    required DateTime imsakTime,
  }) async {
    // 🔔 Sahur (30 menit sebelum imsak)
    await _notif.zonedSchedule(
      1001,
      "Waktu Sahur",
      "Segera sahur sebelum imsak",
      tz.TZDateTime.from(
        imsakTime.subtract(const Duration(minutes: 30)),
        tz.local,
      ),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'sahur_channel',
          'Sahur Reminder',
          importance: Importance.max,
          sound: RawResourceAndroidNotificationSound('adzan_fajr'),
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    // 🔔 Imsak
    await _notif.zonedSchedule(
      1002,
      "Waktu Imsak",
      "Tahan makan dan minum",
      tz.TZDateTime.from(imsakTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'imsak_channel',
          'Imsak Reminder',
          importance: Importance.max,
          sound: RawResourceAndroidNotificationSound('adzan'),
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
