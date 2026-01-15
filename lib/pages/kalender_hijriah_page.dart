import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import '../utils/ramadhan_events.dart';

class KalenderHijriahPage extends StatelessWidget {
  const KalenderHijriahPage({super.key});

  @override
  Widget build(BuildContext context) {
    final hijri = HijriCalendar.now();

    final todayEvents = ramadhanEvents.where((e) =>
        e.hijriDay == hijri.hDay &&
        e.hijriMonth == hijri.hMonth);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kalender Hijriah"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🌙 TANGGAL HIJRIAH
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_month),
                title: Text(
                  "${hijri.hDay} ${hijri.longMonthName} ${hijri.hYear} H",
                  style: const TextStyle(fontSize: 18),
                ),
                subtitle: Text(
                  "Tanggal hari ini",
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ⭐ EVENT RAMADHAN
            const Text(
              "Event Ramadhan",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            if (todayEvents.isEmpty)
              const Text("Tidak ada event hari ini"),
            ...todayEvents.map((e) => Card(
                  color: Colors.green.shade50,
                  child: ListTile(
                    leading: const Icon(Icons.star, color: Colors.green),
                    title: Text(e.title),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
