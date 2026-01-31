import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<Position> getLocation() async {
    bool enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) throw Exception("GPS OFF");

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception("Permission Denied");
    }

    return await Geolocator.getCurrentPosition();
  }
}
