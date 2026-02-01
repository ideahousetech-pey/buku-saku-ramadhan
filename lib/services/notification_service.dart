import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _notif = FlutterLocalNotificationsPlugin();

  static Future init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _notif.initialize(settings);
  }

  static Future show(String title, String body) async {
    const android = AndroidNotificationDetails(
      'adzan',
      'Adzan',
      importance: Importance.max,
    );
    await _notif.show(0, title, body, const NotificationDetails(android: android));
  }
}
