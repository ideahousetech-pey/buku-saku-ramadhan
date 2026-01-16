import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';

import 'auth/login_siswa_page.dart';
import 'services/notification_service.dart';
import 'utils/prayer_scheduler.dart';

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  bool _ready = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      if (!kIsWeb) {
        await Firebase.initializeApp();
        await NotificationService.init();
        await PrayerScheduler.scheduleToday('Jakarta');
      }
      setState(() => _ready = true);
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Text(
            'Terjadi kesalahan:\n$_error',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (!_ready) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return const LoginSiswaPage();
  }
}
