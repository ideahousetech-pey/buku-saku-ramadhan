import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'auth/login_siswa_page.dart';
import 'services/notification_service.dart';
import 'utils/prayer_scheduler.dart';

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  late Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = _initialize();
  }

  Future<void> _initialize() async {
    if (!kIsWeb) {
      await Firebase.initializeApp();
      await NotificationService.init();
      await PrayerScheduler.scheduleToday('Jakarta');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                'Init error:\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return const LoginSiswaPage();
      },
    );
  }
}
