import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../pages/checklist_siswa_page.dart';
import '../pages/rekap_guru_page.dart';

class LoginSiswaPage extends StatelessWidget {
  const LoginSiswaPage({super.key});

  Future<void> login(
      BuildContext context, String email, String password) async {
    final user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
        email: email, password: password);

    final uid = user.user!.uid;

    // 🔎 AMBIL ROLE
    final snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    final role = snap['role'];
    final kelas = snap['kelas'];
    final nama = snap['nama'];

    // 🚦 ARAHKAN SESUAI ROLE
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Form login di sini'),
      ),
    );
  }
}
