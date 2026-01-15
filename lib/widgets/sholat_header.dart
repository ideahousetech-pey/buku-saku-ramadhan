import 'package:flutter/material.dart';
import '../services/sholat_service.dart';

class SholatHeader extends StatefulWidget {
  const SholatHeader({super.key});

  @override
  State<SholatHeader> createState() => _SholatHeaderState();
}

class _SholatHeaderState extends State<SholatHeader> {
  Map<String, String>? times;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final result = await SholatService.getJadwalSholat(
      city: 'Jakarta',
      country: 'Indonesia',
    );

    if (!mounted) return;

    setState(() {
      times = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (times == null) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: CircularProgressIndicator(color: Colors.green),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green, Colors.greenAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Imsak & Jadwal Sholat Hari Ini",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),

          const SizedBox(height: 12),

          // ⏰ IMSAK (DITONJOLKAN)
          Row(
            children: [
              const Icon(Icons.alarm, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                "Imsak ${times!['Imsak']}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 🕌 SHOLAT LAINNYA
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _item("Subuh", times!['Subuh']!),
              _item("Dzuhur", times!['Dzuhur']!),
              _item("Ashar", times!['Ashar']!),
              _item("Maghrib", times!['Maghrib']!),
              _item("Isya", times!['Isya']!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _item(String label, String time) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 4),
        Text(
          time,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
