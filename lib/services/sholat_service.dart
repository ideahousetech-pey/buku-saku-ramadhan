import 'dart:convert';
import 'package:http/http.dart' as http;

class SholatService {
  static Future<Map<String, String>> getJadwalSholat({
    required String city,
    required String country,
  }) async {
    final url = Uri.parse(
      'https://api.aladhan.com/v1/timingsByCity?city=$city&country=$country&method=11',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final timings = data['data']['timings'];

      return {
        'Subuh': timings['Fajr'],
        'Dzuhur': timings['Dhuhr'],
        'Ashar': timings['Asr'],
        'Maghrib': timings['Maghrib'],
        'Isya': timings['Isha'],
      };
    } else {
      throw Exception('Gagal mengambil jadwal sholat');
    }
  }
}
