import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';

class KalenderHijriahBulananPage extends StatelessWidget {
  const KalenderHijriahBulananPage({super.key});

  @override
  Widget build(BuildContext context) {
    final hijriNow = HijriCalendar.now();

    final int hijriYear = hijriNow.hYear;
    final int hijriMonth = hijriNow.hMonth;
    final int daysInMonth = hijriNow.lengthOfMonth;

    // ✅ AMAN: hitung weekday pakai DateTime (BUKAN hijri.weekDay)
    final DateTime today = DateTime.now();
    final DateTime firstDayOfMonth =
        DateTime(today.year, today.month, 1);

    // DateTime.weekday: Senin = 1, Minggu = 7
    final int weekdayOffset = firstDayOfMonth.weekday - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Kalender Hijriah ${hijriNow.longMonthName} $hijriYear",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: daysInMonth + weekdayOffset,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
          ),
          itemBuilder: (context, index) {
            if (index < weekdayOffset) {
              return const SizedBox();
            }

            final int day = index - weekdayOffset + 1;

            return Card(
              elevation: 2,
              child: Center(
                child: Text(
                  "$day",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
