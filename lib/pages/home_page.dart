import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_siswa_page.dart';
import 'sholat_page.dart';
import 'jurnal_page.dart';
import 'kiblat_page.dart';
import 'jadwal_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "";

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString("login_user") ?? "";
    });
  }

  /// MENU WIDGET
  Widget menu(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.green.shade400,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12))
        ],
      ),
    );
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("login_user");
    setState(() {
      userName = "";
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const LoginSiswaPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: userName.isNotEmpty
            ? Text("Assalamualaikum, $userName")
            : const Text("Home"),
        actions: [
          if (userName.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: logout,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 12),

            /// GRID MENU
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [

                  menu(
                    "Sholat",
                    Icons.access_time,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SholatPage()),
                    ),
                  ),

                  menu(
                    "Kiblat",
                    Icons.explore,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const KiblatPage()),
                    ),
                  ),

                  menu(
                    "Jadwal",
                    Icons.calendar_month,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const JadwalPage()),
                    ),
                  ),

                  menu(
                    "Jurnal",
                    Icons.book,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const JurnalPage()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
