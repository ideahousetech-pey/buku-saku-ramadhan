import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/kelas_data.dart';
import 'buat_password_page.dart';
import 'home_page.dart';

class LoginSiswaPage extends StatefulWidget {
  const LoginSiswaPage({super.key});

  @override
  State<LoginSiswaPage> createState() => _LoginSiswaPageState();
}

class _LoginSiswaPageState extends State<LoginSiswaPage> {
  final namaC = TextEditingController();
  final passC = TextEditingController();
  String kelas = "1A";

  Future<void> login() async {
    final prefs = await SharedPreferences.getInstance();
    final key = "${namaC.text}_$kelas";
    final savedPass = prefs.getString(key);

    if (savedPass == passC.text) {
      prefs.setString("login_user", namaC.text);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Password salah")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 80),
          const Text("Login Siswa",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),

          TextField(controller: namaC, decoration: const InputDecoration(labelText: "Nama Siswa")),

          DropdownButtonFormField(
            value: kelas,
            items: KelasData.list
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => setState(() => kelas = v!),
          ),

          TextField(
            controller: passC,
            obscureText: true,
            decoration: const InputDecoration(labelText: "Password"),
          ),

          const SizedBox(height: 20),
          ElevatedButton(onPressed: login, child: const Text("Login")),

          TextButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BuatPasswordPage())),
            child: const Text("Buat Password"),
          )
        ],
      ),
    );
  }
}
