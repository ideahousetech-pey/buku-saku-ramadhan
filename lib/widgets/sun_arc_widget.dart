import 'dart:math';
import 'package:flutter/material.dart';

class SunArcWidget extends StatelessWidget {
  final double progress; // 0 - 1 posisi matahari

  const SunArcWidget({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: CustomPaint(
        painter: _SunArcPainter(progress),
      ),
    );
  }
}

class _SunArcPainter extends CustomPainter {
  final double progress;

  _SunArcPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paintArc = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);

    // busur matahari
    canvas.drawArc(
      rect,
      pi,
      pi,
      false,
      paintArc,
    );

    // posisi matahari
    final angle = pi + pi * progress;

    final x = size.width / 2 +
        (size.width / 2) * cos(angle);

    final y = size.height -
        (size.height) * sin(angle);

    final sunPaint = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(x, y), 10, sunPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
