import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../pages/checklist_siswa_page.dart';
import '../pages/rekap_guru_page.dart';

class LoginSiswaPage extends StatelessWidget {
  const LoginSiswaPage({super.key});

  Future<void> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login hanya tersedia di Android'),
        ),
      );
      return;
    }

    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      final snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (!snap.exists) {
        throw Exception('Data user tidak ditemukan');
      }

      final data = snap.data()!;
      final role = data['role'] ?? 'siswa';
      final kelas = data['kelas'] ?? '';
      final nama = data['nama'] ?? '';

      if (!context.mounted) return;

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
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login gagal: ${e.toString()}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // 🔴 Contoh testing
            login(context, 'test@email.com', 'password123');
          },
          child: const Text('Login (TEST)'),
        ),
      ),
    );
  }
}