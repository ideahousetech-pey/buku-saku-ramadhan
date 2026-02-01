import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/kelas_data.dart';

class BuatPasswordPage extends StatefulWidget {
  const BuatPasswordPage({super.key});

  @override
  State<BuatPasswordPage> createState() => _BuatPasswordPageState();
}

class _BuatPasswordPageState extends State<BuatPasswordPage> {
  final namaC = TextEditingController();
  final pass1 = TextEditingController();
  final pass2 = TextEditingController();
  String kelas = "1A";

  Future<void> save() async {
    if (pass1.text != pass2.text) return;

    final prefs = await SharedPreferences.getInstance();
    final key = "${namaC.text}_$kelas";
    prefs.setString(key, pass1.text);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 80),
          const Text("Buat Password",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),

          TextField(controller: namaC, decoration: const InputDecoration(labelText: "Nama")),

          DropdownButtonFormField(
            value: kelas,
            items: KelasData.list
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => setState(() => kelas = v!),
          ),

          TextField(controller: pass1, obscureText: true, decoration: const InputDecoration(labelText: "Password")),
          TextField(controller: pass2, obscureText: true, decoration: const InputDecoration(labelText: "Ulangi Password")),

          const SizedBox(height: 20),
          ElevatedButton(onPressed: save, child: const Text("Buat Password")),
        ],
      ),
    );
  }
}
