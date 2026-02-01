import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<Position> getPosition() async {
    bool enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      await Geolocator.openLocationSettings();
    }

    LocationPermission permission =
        await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission =
          await Geolocator.requestPermission();
    }

    return await Geolocator.getCurrentPosition();
  }

  /// sementara: mapping default Jakarta
  static Future<String> getCityId() async {
    await getPosition();
    return "1301";
  }

  /// nama lokasi untuk header UI
  static Future<String> getLocationName() async {
    final pos = await getPosition();

    return "Lat ${pos.latitude.toStringAsFixed(2)}, "
        "Lon ${pos.longitude.toStringAsFixed(2)}";
  }
}
