import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class LocationService {
  static Future<Position> getPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("GPS tidak aktif");
    }

    LocationPermission permission =
        await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  /// Nama kota user
  static Future<String> getLocationName() async {
    final pos = await getPosition();

    final url =
        "https://nominatim.openstreetmap.org/reverse?lat=${pos.latitude}&lon=${pos.longitude}&format=json";

    final res = await http.get(Uri.parse(url));

    final data = jsonDecode(res.body);
    final address = data["address"];

    return address["city"] ??
        address["town"] ??
        address["county"] ??
        "Kota Tidak Diketahui";
  }

  /// Cari ID kota API Kemenag
  static Future<String> getCityId() async {
    final city = await getLocationName();

    final url = "https://api.myquran.com/v1/sholat/kota/semua";
    final res = await http.get(Uri.parse(url));

    final data = jsonDecode(res.body);

    for (var item in data) {
      if (item["lokasi"]
          .toString()
          .toLowerCase()
          .contains(city.toLowerCase())) {
        return item["id"];
      }
    }

    // fallback Jakarta
    return "1301";
  }
}
