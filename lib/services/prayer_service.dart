import 'package:adhan/adhan.dart';

class PrayerService {
  static PrayerTimes getTimes(double lat, double lon) {
    final params = CalculationMethod.muslim_world_league.getParameters();
    final coord = Coordinates(lat, lon);
    final date = DateComponents.from(DateTime.now());
    return PrayerTimes(coord, date, params);
  }
}
