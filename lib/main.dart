import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'auth/login_siswa_page.dart';
import 'services/notification_service.dart';
import 'utils/prayer_scheduler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 🔥 Firebase hanya di Android / iOS
  if (!kIsWeb) {
    await Firebase.initializeApp();
    await NotificationService.init();
    await PrayerScheduler.scheduleToday('Jakarta');
  }

  runApp(const MyApp());
}

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
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1B5E20),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: const CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
      ),
      home: const LoginSiswaPage(),
    );
  }
}