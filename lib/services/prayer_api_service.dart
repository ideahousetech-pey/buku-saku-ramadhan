import 'dart:convert';
import 'package:http/http.dart' as http;

class PrayerApiService {
  static Future<Map<String, String>> getTodaySchedule(
      String city) async {
    final date = DateTime.now();
    final url =
        'https://api.aladhan.com/v1/timingsByCity/${date.day}-${date.month}-${date.year}?city=$city&country=Indonesia&method=11';

    final res = await http.get(Uri.parse(url));
    final data = json.decode(res.body);

    final timings = data['data']['timings'];

    return {
      'Fajr': timings['Fajr'],
      'Dhuhr': timings['Dhuhr'],
      'Asr': timings['Asr'],
      'Maghrib': timings['Maghrib'],
      'Isha': timings['Isha'],
    };
  }
}
