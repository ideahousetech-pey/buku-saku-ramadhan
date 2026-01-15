import 'dart:convert';
import 'package:http/http.dart' as http;

class RamadhanService {
  static Future<bool> isRamadhan() async {
    final now = DateTime.now();

    final url = Uri.parse(
      'https://api.aladhan.com/v1/gToH?date=${now.day}-${now.month}-${now.year}',
    );

    final res = await http.get(url);
    final json = jsonDecode(res.body);

    final hijriMonth =
        json['data']['hijri']['month']['en']; // Ramadan

    return hijriMonth.toLowerCase() == 'ramadan';
  }

  static Future<int> hijriDay() async {
    final now = DateTime.now();
    final url = Uri.parse(
      'https://api.aladhan.com/v1/gToH?date=${now.day}-${now.month}-${now.year}',
    );
    final res = await http.get(url);
    final json = jsonDecode(res.body);

    return int.parse(json['data']['hijri']['day']);
  }
}
