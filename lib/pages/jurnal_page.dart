import 'package:flutter/material.dart';
import '../services/jurnal_service.dart';

class JurnalPage extends StatefulWidget {
  final String siswa;

  const JurnalPage({super.key, required this.siswa});

  @override
  State<JurnalPage> createState() => _JurnalPageState();
}

class _JurnalPageState extends State<JurnalPage> {
  bool puasa = false;
  bool tarawih = false;
  bool subuh = false;
  bool dzuhur = false;
  bool ashar = false;
  bool maghrib = false;
  bool isya = false;

  String get today =>
      DateTime.now().toIso8601String().substring(0, 10);

  @override
  void initState() {
    super.initState();

    final data =
        JurnalService.get(widget.siswa, today);

    if (data != null) {
      puasa = data['puasa'] ?? false;
      tarawih = data['tarawih'] ?? false;
      subuh = data['subuh'] ?? false;
      dzuhur = data['dzuhur'] ?? false;
      ashar = data['ashar'] ?? false;
      maghrib = data['maghrib'] ?? false;
      isya = data['isya'] ?? false;
    }
  }

  void save() {
    JurnalService.save(widget.siswa, today, {
      "puasa": puasa,
      "tarawih": tarawih,
      "subuh": subuh,
      "dzuhur": dzuhur,
      "ashar": ashar,
      "maghrib": maghrib,
      "isya": isya,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Jurnal tersimpan")),
    );
  }

  Widget item(String title, bool value,
      Function(bool?) onChanged) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Jurnal Ibadah")),
      body: ListView(
        children: [
          item("Puasa", puasa,
              (v) => setState(() => puasa = v!)),
          item("Tarawih", tarawih,
              (v) => setState(() => tarawih = v!)),
          item("Subuh", subuh,
              (v) => setState(() => subuh = v!)),
          item("Dzuhur", dzuhur,
              (v) => setState(() => dzuhur = v!)),
          item("Ashar", ashar,
              (v) => setState(() => ashar = v!)),
          item("Maghrib", maghrib,
              (v) => setState(() => maghrib = v!)),
          item("Isya", isya,
              (v) => setState(() => isya = v!)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: save,
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }
}
