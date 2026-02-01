import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/location_service.dart';
import '../services/prayer_service.dart';
import '../services/auth_service.dart';
import '../services/hijri_service.dart';
import '../widgets/islamic_background.dart';

import 'login_siswa_page.dart';
import 'sholat_page.dart';
import 'kiblat_page.dart';
import 'jadwal_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? _timer;

  DateTime now = DateTime.now();

  String city = "Memuat lokasi...";
  String hijriDate = "...";

  PrayerTimes? prayer;

  String activePrayer = "-";
  String countdown = "--:--:--";

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadData();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => now = DateTime.now());
      _updateCountdown();
    });
  }

  Future<void> _loadData() async {
    try {
      final cityName = await LocationService.getLocationName();
      final cityId = await LocationService.getCityId();

      final p =
          await PrayerService.getPrayerTimes(cityId, DateTime.now());

      final hijri = await HijriService.getHijriToday();

      setState(() {
        city = cityName;
        prayer = p;
        hijriDate = hijri;
      });

      _updateCountdown();
    } catch (_) {
      setState(() => city = "Lokasi tidak tersedia");
    }
  }

  void _updateCountdown() {
    if (prayer == null) return;

    final times = {
      "Subuh": prayer!.fajr,
      "Dzuhur": prayer!.dhuhr,
      "Ashar": prayer!.asr,
      "Maghrib": prayer!.maghrib,
      "Isya": prayer!.isha,
    };

    DateTime? next;
    String name = "";

    for (var entry in times.entries) {
      if (entry.value.isAfter(now)) {
        next = entry.value;
        name = entry.key;
        break;
      }
    }

    next ??= prayer!.fajr.add(const Duration(days: 1));
    name = "Subuh";

    final diff = next.difference(now);

    setState(() {
      activePrayer = name;
      countdown =
          "${diff.inHours.toString().padLeft(2, '0')}:"
          "${(diff.inMinutes % 60).toString().padLeft(2, '0')}:"
          "${(diff.inSeconds % 60).toString().padLeft(2, '0')}";
    });
  }

  String masehi() =>
      DateFormat("EEE, dd MMM yyyy", "id_ID").format(now);

  Widget menu(String title, IconData icon, VoidCallback onTap) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            radius: 32,
            backgroundColor: Colors.green,
            child: Icon(icon, color: Colors.white, size: 28),
          ),
        ),
        const SizedBox(height: 8),
        Text(title),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final logged = AuthService.isLoggedIn;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Buku Saku Ramadhan"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: IslamicBackground(
        child: Column(
          children: [
            /// HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green, Colors.teal],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(masehi(),
                      style: const TextStyle(color: Colors.white)),
                  Text(hijriDate,
                      style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 8),
                  Text(city,
                      style: const TextStyle(color: Colors.white)),
                ],
              ),
            ),

            /// CARD SHOLAT
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(120),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(activePrayer,
                      style: const TextStyle(
                          fontSize: 26, color: Colors.white)),
                  const SizedBox(height: 10),
                  Text(countdown,
                      style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// MENU
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                menu("Sholat", Icons.access_time, () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const SholatPage()));
                }),
                menu("Kiblat", Icons.explore, () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const KiblatPage()));
                }),
                menu("Jadwal", Icons.calendar_month, () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const JadwalPage()));
                }),
                menu(logged ? "Logout" : "Login", Icons.person, () {
                  if (logged) {
                    AuthService.logout();
                    setState(() {});
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const LoginSiswaPage()))
                        .then((_) => setState(() {}));
                  }
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
