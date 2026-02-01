import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class JurnalPage extends StatefulWidget {
  const JurnalPage({super.key});

  @override
  State<JurnalPage> createState() => _JurnalPageState();
}

class _JurnalPageState extends State<JurnalPage> {
  bool puasa = false;
  bool tarawih = false;
  bool sholat = false;

  late String todayKey;
  bool editable = true;

  @override
  void initState() {
    super.initState();
    initData();
  }

  /// CEK APAKAH MASIH HARI INI
  bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  Future<void> initData() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    todayKey = DateFormat('yyyy-MM-dd').format(today);

    editable = isToday(today);

    puasa = prefs.getBool("puasa_$todayKey") ?? false;
    tarawih = prefs.getBool("tarawih_$todayKey") ?? false;
    sholat = prefs.getBool("sholat_$todayKey") ?? false;

    setState(() {});
  }

  Future<void> save() async {
    if (!editable) return;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool("puasa_$todayKey", puasa);
    await prefs.setBool("tarawih_$todayKey", tarawih);
    await prefs.setBool("sholat_$todayKey", sholat);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Jurnal tersimpan")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final todayText = DateFormat('dd MMM yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Jurnal Ibadah"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            todayText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          CheckboxListTile(
            title: const Text("Puasa"),
            value: puasa,
            onChanged: editable
                ? (v) => setState(() => puasa = v!)
                : null,
          ),

          CheckboxListTile(
            title: const Text("Tarawih"),
            value: tarawih,
            onChanged: editable
                ? (v) => setState(() => tarawih = v!)
                : null,
          ),

          CheckboxListTile(
            title: const Text("Sholat 5 Waktu"),
            value: sholat,
            onChanged: editable
                ? (v) => setState(() => sholat = v!)
                : null,
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: editable ? save : null,
            child: const Text("Simpan"),
          ),

          if (!editable)
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Text(
                "Hari yang sudah lewat tidak bisa diedit",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
              ),
            )
        ],
      ),
    );
  }
}
