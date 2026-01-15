import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

import '../services/sholat_service.dart';

class PrayerScheduler {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// WAJIB dipanggil sekali di awal app
  static Future<void> initTimezone() async {
    tzdata.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
  }

  static Future<void> scheduleToday(String city) async {
    await initTimezone();

    final times = await SholatService.getJadwalSholat(
      city: city,
      country: 'Indonesia',
    );

    await _schedule(
      id: 200,
      title: "Imsak",
      body: "Waktu imsak telah tiba",
      time: times['Imsak']!,
      sound: 'adzan_fajr',
    );

    await _schedule(
      id: 201,
      title: "Subuh",
      body: "Waktu sholat Subuh",
      time: times['Subuh']!,
      sound: 'adzan_fajr',
    );
  }

  static Future<void> _schedule({
    required int id,
    required String title,
    required String body,
    required String time,
    required String sound,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    final parts = time.split(':');

    final scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );

    if (scheduledTime.isBefore(now)) return;

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'sholat_channel',
          'Sholat Notification',
          channelDescription: 'Notifikasi waktu sholat',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
