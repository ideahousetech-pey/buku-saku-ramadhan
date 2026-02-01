class SunService {
  static double getSunProgress(DateTime sunrise, DateTime sunset) {
    final now = DateTime.now();
    final total = sunset.difference(sunrise).inMinutes;
    final current = now.difference(sunrise).inMinutes;
    return current / total;
  }
}
