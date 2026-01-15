import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../pages/home_page.dart';
import 'buat_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final namaController = TextEditingController();
  final passwordController = TextEditingController();

  String selectedKelas = '1A';
  bool loading = false;

  final List<String> daftarKelas = [
    '1A','1B','2A','2B','3A','3B',
    '4A','4B','5A','5B','6A','6B'
  ];

  @override
  void dispose() {
    namaController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    FocusScope.of(context).unfocus();

    if (namaController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama dan password wajib diisi")),
      );
      return;
    }

    setState(() => loading = true);

    final query = await FirebaseFirestore.instance
        .collection('users')
        .where('nama', isEqualTo: namaController.text.trim())
        .where('kelas', isEqualTo: selectedKelas)
        .limit(1)
        .get();

    if (!mounted) return;

    if (query.docs.isEmpty) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Akun tidak ditemukan")),
      );
      return;
    }

    final user = query.docs.first.data();

    if (user['password'] != passwordController.text) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password salah")),
      );
      return;
    }

    final role = user['role'] ?? 'siswa';

    setState(() => loading = false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(role: role),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Ramadhan")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                labelText: "Nama Siswa",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              initialValue: selectedKelas,
              decoration: const InputDecoration(
                labelText: "Kelas",
                border: OutlineInputBorder(),
              ),
              items: daftarKelas
                  .map((k) =>
                      DropdownMenuItem(value: k, child: Text(k)))
                  .toList(),
              onChanged: loading
                  ? null
                  : (v) => setState(() => selectedKelas = v!),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : login,
                child: loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text("LOGIN"),
              ),
            ),

            TextButton(
              onPressed: loading
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BuatPasswordPage(),
                        ),
                      );
                    },
              child: const Text("Belum punya password? Buat Password"),
            ),
          ],
        ),
      ),
    );
  }
}
