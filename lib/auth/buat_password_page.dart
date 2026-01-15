import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BuatPasswordPage extends StatefulWidget {
  const BuatPasswordPage({super.key});

  @override
  State<BuatPasswordPage> createState() => _BuatPasswordPageState();
}

class _BuatPasswordPageState extends State<BuatPasswordPage> {
  final namaController = TextEditingController();
  final passController = TextEditingController();
  final ulangiController = TextEditingController();

  String selectedKelas = '1A';

  final List<String> daftarKelas = [
    '1A', '1B', '2A', '2B', '3A', '3B', '4A', '4B', '5A', '5B', '6A', '6B'
  ];

  Future<void> buatPassword() async {
    if (passController.text != ulangiController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password tidak sama")),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('users').add({
      'nama': namaController.text.trim(),
      'kelas': selectedKelas,
      'password': passController.text,
      'role': 'siswa',
      'created_at': Timestamp.now(),
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Password berhasil dibuat")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Buat Password")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: namaController,
              decoration: const InputDecoration(labelText: "Nama Siswa"),
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField(
              value: selectedKelas,
              items: daftarKelas
                  .map((k) =>
                      DropdownMenuItem(value: k, child: Text(k)))
                  .toList(),
              onChanged: (v) => selectedKelas = v!,
              decoration: const InputDecoration(labelText: "Kelas"),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: passController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: ulangiController,
              obscureText: true,
              decoration:
                  const InputDecoration(labelText: "Ulangi Password"),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: buatPassword,
              child: const Text("BUAT PASSWORD"),
            ),
          ],
        ),
      ),
    );
  }
}
