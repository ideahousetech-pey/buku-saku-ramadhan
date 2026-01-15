import 'package:flutter/material.dart';

// WIDGET
import '../widgets/sholat_header.dart';
import '../widgets/menu_bulat.dart';

// PAGES
import '../pages/sholat_page.dart';
import '../pages/kiblat_page.dart';
import '../pages/kalender_page.dart';
import '../ramadhan/checklist_page.dart';
import '../ramadhan/recap_guru_page.dart';
import '../pages/kiblat_page.dart';
import '../pages/kalender_hijriah_page.dart';
import '../pages/kalender_hijriah_bulanan_page.dart';

// SERVICE
import '../services/prayer_service.dart';

class HomePage extends StatelessWidget {
  final String role; // "siswa" atau "guru"
  const HomePage({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Ramadhan App"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ================= HEADER SHOLAT =================
            const SholatHeader(),

            const SizedBox(height: 20),

            // ================= MENU BULAT =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  // 🕌 SHOLAT
                  MenuBulat(
                    title: "Sholat",
                    icon: Icons.access_time,
                    onTap: () async {
                      final times =
                          await PrayerService.getJadwalSholat(
                        city: "Jakarta",
                        country: "Indonesia",
                      );

                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                SholatPage(times: times),
                          ),
                        );
                      }
                    },
                  ),

                  // 🧭 KIBLAT
                  MenuBulat(
                    title: "Kiblat",
                    icon: Icons.explore,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const KiblatPage(),
                        ),
                      );
                    },
                  ),

                  // 📅 JADWAL RAMADHAN
                  MenuBulat(
                    title: "Jadwal",
                    icon: Icons.calendar_month,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text("Jadwal Ramadhan akan ditampilkan"),
                        ),
                      );
                    },
                  ),

                  // 🌙 KALENDER HIJRIAH
                  MenuBulat(
                    title: "Kalender",
                    icon: Icons.event,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const KalenderHijriahPage(),
                        ),
                      );
                    },
                  ),

                  // KALENDER HIJRIAH BULANAN
                  MenuBulat(
                    title: "Kalender",
                    icon: Icons.event,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const KalenderHijriahBulananPage(),
                        ),
                      );
                    },
                  ),

                ],
              ),
            ),

            const SizedBox(height: 24),

            // ================= MENU SISWA =================
            if (role == "siswa")
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check_circle),
                  label: const Text("Checklist Ramadhan"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ChecklistPage(),
                      ),
                    );
                  },
                ),
              ),

            // ================= MENU GURU =================
            if (role == "guru")
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.bar_chart),
                  label: const Text("Rekap Ibadah Siswa"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RecapGuruPage(),
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
