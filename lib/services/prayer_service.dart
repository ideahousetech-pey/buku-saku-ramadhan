import 'dart:convert';
import 'package:http/http.dart' as http;

class PrayerTimes {
  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;

  PrayerTimes({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  List<Map<String, dynamic>> asList() => [
        {"name": "Subuh", "time": fajr},
        {"name": "Terbit", "time": sunrise},
        {"name": "Dzuhur", "time": dhuhr},
        {"name": "Ashar", "time": asr},
        {"name": "Maghrib", "time": maghrib},
        {"name": "Isya", "time": isha},
      ];
}

class PrayerService {
  static Future<PrayerTimes> getPrayerTimes(
      String cityId, DateTime date) async {
    final url =
        "https://api.myquran.com/v1/sholat/jadwal/$cityId/${date.year}/${date.month}/${date.day}";

    final res = await http.get(Uri.parse(url));
    final data = jsonDecode(res.body);

    final jadwal = data['data']['jadwal'];

    DateTime parse(String t) {
      final parts = t.split(':');
      return DateTime(
        date.year,
        date.month,
        date.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );
    }

    return PrayerTimes(
      fajr: parse(jadwal['subuh']),
      sunrise: parse(jadwal['terbit']),
      dhuhr: parse(jadwal['dzuhur']),
      asr: parse(jadwal['ashar']),
      maghrib: parse(jadwal['maghrib']),
      isha: parse(jadwal['isya']),
    );
  }

  static Map<String, dynamic> getCurrentPrayer(
      PrayerTimes times, DateTime now) {
    final list = times.asList();

    for (int i = list.length - 1; i >= 0; i--) {
      if (now.isAfter(list[i]['time'])) {
        return list[i];
      }
    }
    return list.first;
  }

  static Map<String, dynamic> getNextPrayer(
      PrayerTimes times, DateTime now) {
    final list = times.asList();

    for (final p in list) {
      if (p['time'].isAfter(now)) return p;
    }

    return list.first;
  }
}
