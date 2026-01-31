import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';

class SunArcWidget extends StatefulWidget {
  final DateTime fajr;
  final DateTime maghrib;

  const SunArcWidget({
    super.key,
    required this.fajr,
    required this.maghrib,
  });

  @override
  State<SunArcWidget> createState() => _SunArcWidgetState();
}

class _SunArcWidgetState extends State<SunArcWidget> {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  double get progress {
    final now = DateTime.now();
    if (now.isBefore(widget.fajr)) return 0;
    if (now.isAfter(widget.maghrib)) return 1;

    final total = widget.maghrib.difference(widget.fajr).inSeconds;
    final passed = now.difference(widget.fajr).inSeconds;
    return passed / total;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: CustomPaint(
        painter: _SunPainter(progress),
        child: Container(),
      ),
    );
  }
}

class _SunPainter extends CustomPainter {
  final double progress;
  _SunPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paintArc = Paint()
      ..color = Colors.white70
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final rect = Rect.fromLTWH(20, 20, size.width - 40, size.height - 40);
    canvas.drawArc(rect, pi, pi, false, paintArc);

    final angle = pi + (pi * progress);
    final centerX = rect.center.dx + cos(angle) * rect.width / 2;
    final centerY = rect.center.dy + sin(angle) * rect.height / 2;

    final sunPaint = Paint()..color = Colors.yellow;
    canvas.drawCircle(Offset(centerX, centerY), 8, sunPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
