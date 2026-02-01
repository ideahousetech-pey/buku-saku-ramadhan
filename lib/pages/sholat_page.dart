import 'dart:async';
import 'package:flutter/material.dart';

import '../services/prayer_service.dart';
import '../services/location_service.dart';
import '../widgets/sun_arc_widget.dart';

class SholatPage extends StatefulWidget {
  const SholatPage({super.key});

  @override
  State<SholatPage> createState() => _SholatPageState();
}

class _SholatPageState extends State<SholatPage> {
  PrayerTimes? times;
  Timer? timer;
  DateTime now = DateTime.now();
  int index = 0;

  @override
  void initState() {
    super.initState();
    loadTimes();

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() => now = DateTime.now()),
    );
  }

  Future<void> loadTimes() async {
    final city = await LocationService.getCityId();
    final t =
        await PrayerService.getPrayerTimes(city, now);

    setState(() => times = t);
  }

  String countdown(DateTime next) {
    final diff = next.difference(now);
    return "${diff.inHours.remainder(24).toString().padLeft(2, '0')}:"
        "${diff.inMinutes.remainder(60).toString().padLeft(2, '0')}:"
        "${diff.inSeconds.remainder(60).toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    if (times == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final list = times!.asList();
    final current =
        PrayerService.getCurrentPrayer(times!, now);

    final next =
        PrayerService.getNextPrayer(times!, now);

    final sunrise = times!.sunrise;
    final maghrib = times!.maghrib;

    double progress = 0;
    if (now.isAfter(sunrise) &&
        now.isBefore(maghrib)) {
      progress = now
              .difference(sunrise)
              .inMinutes /
          maghrib
              .difference(sunrise)
              .inMinutes;
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Sholat")),
      body: Column(
        children: [
          SunArcWidget(progress: progress),

          Text(
            "${current['name']} sekarang",
            style: const TextStyle(fontSize: 20),
          ),

          Text(
            countdown(next['time']),
            style: const TextStyle(fontSize: 26),
          ),

          Expanded(
            child: PageView.builder(
              itemCount: list.length,
              onPageChanged: (i) =>
                  setState(() => index = i),
              itemBuilder: (_, i) {
                final p = list[i];

                final active =
                    p['name'] == current['name'];

                return Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: active
                          ? Colors.green.shade200
                          : Colors.white,
                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize:
                          MainAxisSize.min,
                      children: [
                        Text(
                          p['name'],
                          style:
                              const TextStyle(
                                  fontSize: 28),
                        ),
                        Text(
                          p['time']
                              .toString()
                              .substring(11, 16),
                          style:
                              const TextStyle(
                                  fontSize: 36),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
