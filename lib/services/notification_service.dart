import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:audioplayers/audioplayers.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notif =
      FlutterLocalNotificationsPlugin();

  static final AudioPlayer _player = AudioPlayer();

  static Future<void> init() async {
    tz.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    await _notif.initialize(settings,
        onDidReceiveNotificationResponse: (resp) async {
      final payload = resp.payload;
      if (payload == 'subuh') {
        _player.play(AssetSource('audio/adzan_fajr.mp3'));
      } else {
        _player.play(AssetSource('audio/adzan.mp3'));
      }
    });
  }

  static Future<void> scheduleAdzan(
      String title, DateTime time, bool isSubuh) async {
    await _notif.zonedSchedule(
      time.hashCode,
      'Waktu Sholat $title',
      'Saatnya sholat $title',
      tz.TZDateTime.from(time, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'adzan_channel',
          'Adzan',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: isSubuh ? 'subuh' : 'normal',
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
