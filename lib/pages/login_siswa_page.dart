import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_page.dart';

class LoginSiswaPage extends StatefulWidget {
  const LoginSiswaPage({super.key});

  @override
  State<LoginSiswaPage> createState() => _LoginSiswaPageState();
}

class _LoginSiswaPageState extends State<LoginSiswaPage> {
  final namaCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  String kelas = "1A";

  Future<void> login() async {
    final ok = await AuthService.login(
      namaCtrl.text,
      kelas,
      passCtrl.text,
    );

    if (!mounted) return;

    if (ok) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
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
              controller: namaCtrl,
              decoration: const InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: passCtrl,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: const Text("Login")),
          ],
        ),
      ),
    );
  }
}
