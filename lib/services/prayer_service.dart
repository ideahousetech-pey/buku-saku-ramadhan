import 'dart:convert';
import 'package:http/http.dart' as http;

class PrayerService {
  /// HARUS return 'Map<String, DateTime>'
  Future<Map<String, DateTime>> getTodayPrayerTimes() async {
    // GANTI INI dengan logic jadwal sholat kamu yang sudah ada
    return {
      'Subuh': DateTime.now().add(const Duration(minutes: 1)),
      'Dzuhur': DateTime.now().add(const Duration(minutes: 2)),
      'Ashar': DateTime.now().add(const Duration(minutes: 3)),
      'Maghrib': DateTime.now().add(const Duration(minutes: 4)),
      'Isya': DateTime.now().add(const Duration(minutes: 5)),
    };
  }

  static Future<Map<String, String>> getJadwalSholat({
    required String city,
    required String country,
  }) async {
    final url =
        'https://api.aladhan.com/v1/timingsByCity?city=$city&country=$country&method=11';

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    final timings = data['data']['timings'];

    return {
      'Imsak': timings['Imsak'],
      'Subuh': timings['Fajr'],
      'Dzuhur': timings['Dhuhr'],
      'Ashar': timings['Asr'],
      'Maghrib': timings['Maghrib'],
      'Isya': timings['Isha'],
    };
  }
}
