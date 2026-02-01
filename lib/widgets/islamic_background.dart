import 'package:flutter/material.dart';

class IslamicBackground extends StatelessWidget {
  final Widget child;

  const IslamicBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0D47A1),
                Color(0xFF1565C0),
                Color(0xFF42A5F5),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        // bulan sabit
        const Positioned(
          top: 80,
          right: 40,
          child: Icon(Icons.nightlight_round,
              color: Colors.white24, size: 90),
        ),

        // siluet masjid
        const Positioned(
          bottom: -10,
          left: 0,
          right: 0,
          child: Icon(Icons.mosque,
              size: 220, color: Colors.white12),
        ),

        child,
      ],
    );
  }
}
