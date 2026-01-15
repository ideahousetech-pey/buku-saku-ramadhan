import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';

class KiblatPage extends StatefulWidget {
  const KiblatPage({super.key});

  @override
  State<KiblatPage> createState() => _KiblatPageState();
}

class _KiblatPageState extends State<KiblatPage> {
  double? _direction; // arah kompas
  double? _qiblaDirection; // arah kiblat

  @override
  void initState() {
    super.initState();
    _initLocation();
    FlutterCompass.events?.listen((event) {
      setState(() {
        _direction = event.heading;
      });
    });
  }

  Future<void> _initLocation() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition();
    _qiblaDirection = _calculateQibla(
      position.latitude,
      position.longitude,
    );

    setState(() {});
  }

  double _calculateQibla(double lat, double lng) {
    const kaabaLat = 21.4225;
    const kaabaLng = 39.8262;

    final latRad = _degToRad(lat);
    final lngRad = _degToRad(lng);
    final kaabaLatRad = _degToRad(kaabaLat);
    final kaabaLngRad = _degToRad(kaabaLng);

    final y = sin(kaabaLngRad - lngRad);
    final x = cos(latRad) * tan(kaabaLatRad) -
        sin(latRad) * cos(kaabaLngRad - lngRad);

    return (_radToDeg(atan2(y, x)) + 360) % 360;
  }

  double _degToRad(double deg) => deg * pi / 180;
  double _radToDeg(double rad) => rad * 180 / pi;

  @override
  Widget build(BuildContext context) {
    if (_direction == null || _qiblaDirection == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final angle = (_qiblaDirection! - _direction!) * (pi / 180);

    return Scaffold(
      appBar: AppBar(title: const Text("Arah Kiblat")),
      body: Center(
        child: Transform.rotate(
          angle: angle,
          child: Image.asset(
            'assets/images/compass.png',
            width: 220,
          ),
        ),
      ),
    );
  }
}
