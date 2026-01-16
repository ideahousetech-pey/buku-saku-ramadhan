import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../pages/checklist_siswa_page.dart';
import '../pages/rekap_guru_page.dart';

class LoginSiswaPage extends StatefulWidget {
  const LoginSiswaPage({super.key});

  @override
  State<LoginSiswaPage> createState() => _LoginSiswaPageState();
}

class _LoginSiswaPageState extends State<LoginSiswaPage> {
  final _namaController = TextEditingController();
  final _passwordController = TextEditingController();
  String _kelas = '1';

  bool _loading = false;

  Future<void> _login() async {
    setState(() => _loading = true);

    try {
      final credential =
          await FirebaseAuth.instance.signInAnonymously();

      final user = credential.user;
      if (user == null) {
        throw Exception('User tidak valid');
      }

      final uid = user.uid;

      final doc = FirebaseFirestore.instance
          .collection('users')
          .doc(uid);

      final snap = await doc.get();

      /// 🔥 JIKA USER BELUM ADA → BUATKAN
      if (!snap.exists) {
        await doc.set({
          'nama': _namaController.text,
          'kelas': _kelas,
          'role': 'siswa',
        });
      }

      final data = (await doc.get()).data();
      if (data == null) {
        throw Exception('Data user kosong');
      }

      final role = data['role'] ?? 'siswa';
      final kelas = data['kelas'] ?? '';
      final nama = data['nama'] ?? '';

      if (!mounted) return;

      if (role == 'guru') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => RekapGuruPage(kelas: kelas),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ChecklistSiswaPage(
              siswaId: uid,
              nama: nama,
              kelas: kelas,
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Siswa')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: 'Nama Siswa',
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _kelas,
              items: List.generate(
                6,
                (i) => DropdownMenuItem(
                  value: '${i + 1}',
                  child: Text('Kelas ${i + 1}'),
                ),
              ),
              onChanged: (v) => setState(() => _kelas = v!),
              decoration:
                  const InputDecoration(labelText: 'Kelas'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration:
                  const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 24),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: const Text('Masuk'),
                  ),
          ],
        ),
      ),
    );
  }
}
