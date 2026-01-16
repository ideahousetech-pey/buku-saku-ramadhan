import 'package:flutter/material.dart';
import 'auth/login_siswa_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Buku Saku Ramadhan',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xFFF5F7F6),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B5E20),
        ),
      ),
      home: const LoginSiswaPage(),
    );
  }
}
