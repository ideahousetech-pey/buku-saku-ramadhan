import 'dart:async';
import 'package:flutter/material.dart';
import '../services/location_service.dart';
import '../services/prayer_service.dart';
import '../pages/sholat_page.dart';
import '../pages/jurnal_page.dart';
import '../pages/login_siswa_page.dart';

class HomePage extends StatefulWidget {
  final String? siswa;

  const HomePage({super.key, this.siswa});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, DateTime>? _prayerTimes;
  String _location = "Memuat lokasi...";
  late Timer _timer;

  String _activePrayer = "";
  Duration _countdown = Duration.zero;

  @override
  void initState() {
    super.initState();
    _init();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateActivePrayer();
      if (mounted) setState(() {});
    });
  }

  Future<void> _init() async {
    final locationName = await LocationService.getLocationName();

    final pt = await PrayerService.getPrayerTimes(
      locationName,
      DateTime.now(),
    );

    if (!mounted) return;

    setState(() {
      _location = locationName;

      _prayerTimes = {
        "Subuh": pt.fajr,
        "Terbit": pt.sunrise,
        "Dzuhur": pt.dhuhr,
        "Ashar": pt.asr,
        "Maghrib": pt.maghrib,
        "Isya": pt.isha,
      };

      _updateActivePrayer();
    });
  }

  void _updateActivePrayer() {
    if (_prayerTimes == null) return;

    final now = DateTime.now();
    String current = "";
    DateTime? nextTime;

    for (final entry in _prayerTimes!.entries) {
      if (now.isAfter(entry.value)) {
        current = entry.key;
      } else {
        nextTime = entry.value;
      }
    }

    _activePrayer = current;

    if (nextTime != null) {
      _countdown = nextTime.difference(now);
    }
  }

  Widget _menuButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.green,
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(label,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerItem(String name, DateTime time) {
    bool active = name == _activePrayer;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: active ? Colors.green.shade100 : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                      active ? FontWeight.bold : FontWeight.normal)),
          Text(
            "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}",
            style: const TextStyle(fontSize: 16),
          )
        ],
      ),
    );
  }

  Widget _buildPrayerList() {
    if (_prayerTimes == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: _prayerTimes!.entries
          .map((e) => _buildPrayerItem(e.key, e.value))
          .toList(),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final siswa = widget.siswa;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Buku Saku Ramadhan"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green, Colors.teal],
                ),
              ),
              child: Column(
                children: [
                  if (siswa != null)
                    Text(
                      "Assalamualaikum $siswa",
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  const SizedBox(height: 4),
                  Text(_location,
                      style: const TextStyle(color: Colors.white)),
                  const SizedBox(height: 8),
                  Text(
                    "Countdown: "
                    "${_countdown.inMinutes.remainder(60).toString().padLeft(2, '0')}:"
                    "${_countdown.inSeconds.remainder(60).toString().padLeft(2, '0')}",
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildPrayerList(),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                _menuButton(
                    icon: Icons.access_time,
                    label: "Sholat",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SholatPage()),
                      );
                    }),
                _menuButton(
                    icon: Icons.menu_book,
                    label: "Jurnal",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              JurnalPage(siswa: siswa ?? "Siswa"),
                        ),
                      );
                    }),
                _menuButton(
                    icon: Icons.logout,
                    label: "Logout",
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const LoginSiswaPage()),
                      );
                    }),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
