import 'package:flutter/material.dart';
import '../widgets/header_widget.dart';
import '../widgets/prayer_card_widget.dart';
import '../services/location_service.dart';
import '../services/prayer_service.dart';
import 'login_guru_page.dart';
import 'login_siswa_page.dart';
import 'kiblat_page.dart';
import 'jadwal_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<PrayerCard> cards = [];

  @override
  void initState() {
    super.initState();
    loadPrayer();
  }

  void loadPrayer() async {
    final pos = await LocationService.getLocation();
    final prayer = PrayerService.getPrayer(pos.latitude, pos.longitude);

    setState(() {
      cards = [
        PrayerCard(name: "Subuh", time: prayer.fajr),
        PrayerCard(name: "Dzuhur", time: prayer.dhuhr),
        PrayerCard(name: "Ashar", time: prayer.asr),
        PrayerCard(name: "Maghrib", time: prayer.maghrib),
        PrayerCard(name: "Isya", time: prayer.isha),
      ];
    });
  }

  Widget menu(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: const Offset(0, 4))
              ],
            ),
            child: Icon(icon, color: Colors.green, size: 32),
          ),
          const SizedBox(height: 8),
          Text(title,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderWidget(
            onLoginGuru: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const LoginGuruPage())),
          ),
          SizedBox(height: 220, child: PageView(children: cards)),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              menu("Sholat", Icons.access_time, () {}),
              menu("Kiblat", Icons.explore,
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const KiblatPage()))),
              menu("Jadwal", Icons.calendar_month,
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const JadwalPage()))),
              menu("Login", Icons.person,
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const LoginSiswaPage()))),
            ],
          )
        ],
      ),
    );
  }
}
