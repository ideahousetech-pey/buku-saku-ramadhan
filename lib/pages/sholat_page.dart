import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/location_service.dart';
import '../services/prayer_service.dart';
import 'jadwal_page.dart';
import '../widgets/sun_arc_widget.dart';
import '../services/notification_service.dart';


class SholatPage extends StatefulWidget {
  const SholatPage({super.key});

  @override
  State<SholatPage> createState() => _SholatPageState();
}

class _SholatPageState extends State<SholatPage> {
  String lokasi = "Mencari lokasi...";
  String kota = "";
  Map<String, bool> notif = {};
  Map<String, DateTime> times = {};
  DateTime? fajrTime;
  DateTime? maghribTime;


  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final pos = await LocationService.getLocation();
    final prayer = PrayerService.getPrayer(pos.latitude, pos.longitude);
    fajrTime = prayer.fajr;
    maghribTime = prayer.maghrib;


    times = {
      "Subuh": prayer.fajr,
      "Terbit": prayer.sunrise,
      "Dzuhur": prayer.dhuhr,
      "Ashar": prayer.asr,
      "Maghrib": prayer.maghrib,
      "Isya": prayer.isha,
    };

    for (var e in times.entries) {
      final isSubuh = e.key == "Subuh";
      NotificationService.scheduleAdzan(
        e.key,
        e.value,
        isSubuh,
      );
    }

    List<Placemark> placemarks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);

    final p = placemarks.first;

    lokasi = p.subAdministrativeArea ?? "";
    kota = p.locality ?? "";

    await loadNotif();
    setState(() {});
  }

  Future<void> loadNotif() async {
    final prefs = await SharedPreferences.getInstance();
    for (var key in times.keys) {
      notif[key] = prefs.getBool(key) ?? true;
    }
  }

  Future<void> saveNotif(String key, bool val) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, val);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final hijri = HijriCalendar.now();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(lokasi, style: const TextStyle(fontSize: 18)),
            Text("Kemenag $kota",
                style: const TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const JadwalPage()));
            },
          )
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 12),

          if (fajrTime != null && maghribTime != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.green,
              ),
              child: SunArcWidget(
                fajr: fajrTime!,
                maghrib: maghribTime!,
              ),
            ),

          Center(
            child: Text(
              "${DateFormat('dd MMM yyyy').format(now)} / "
              "${hijri.hDay} ${hijri.longMonthName} ${hijri.hYear}",
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 12),

          ...times.entries.map((e) {
            final isActive = now.isAfter(e.value) &&
                now.difference(e.value).inHours < 2;

            return Container(
              color: isActive ? Colors.green.withValues(alpha: 0.15) : null,
              child: ListTile(
                title: Text(e.key,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(DateFormat('HH:mm').format(e.value)),
                    Switch(
                      value: notif[e.key] ?? true,
                      onChanged: (v) {
                        setState(() => notif[e.key] = v);
                        saveNotif(e.key, v);
                      },
                    )
                  ],
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}
