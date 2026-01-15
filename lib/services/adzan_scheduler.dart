import 'notification_service.dart';
import 'prayer_service.dart';

class AdzanScheduler {
  final PrayerService _prayerService = PrayerService();

  Future<void> scheduleTodayAdzan() async {
    final prayerTimes = await _prayerService.getTodayPrayerTimes();

    for (final entry in prayerTimes.entries) {
      final sholatName = entry.key;
      final time = entry.value;

      await NotificationService.schedule(
        id: _notificationId(sholatName),
        title: 'Waktu $sholatName',
        body: 'Sudah masuk waktu sholat $sholatName',
        time: time,
        isFajr: sholatName.toLowerCase() == 'subuh',
      );
    }
  }

  int _notificationId(String sholatName) {
    switch (sholatName.toLowerCase()) {
      case 'subuh':
        return 1;
      case 'dzuhur':
        return 2;
      case 'ashar':
        return 3;
      case 'maghrib':
        return 4;
      case 'isya':
        return 5;
      default:
        return 99;
    }
  }
}
