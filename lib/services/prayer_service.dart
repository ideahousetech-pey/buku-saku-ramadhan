import 'package:adhan/adhan.dart';

class PrayerService {
  static PrayerTimes getPrayer(double lat, double lon) {
    final params = CalculationMethod.karachi.getParameters();
    final coords = Coordinates(lat, lon);
    final date = DateComponents.from(DateTime.now());
    return PrayerTimes(coords, date, params);
  }
}
