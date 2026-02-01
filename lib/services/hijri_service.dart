import 'dart:convert';
import 'package:http/http.dart' as http;

class HijriService {
  static Future<String> getHijriToday() async {
    final now = DateTime.now();

    final url =
        "https://api.aladhan.com/v1/gToH?date=${now.day}-${now.month}-${now.year}";

    final res = await http.get(Uri.parse(url));
    final data = jsonDecode(res.body);

    final h = data["data"]["hijri"];

    return "${h["day"]} ${h["month"]["en"]} ${h["year"]} H";
  }
}
