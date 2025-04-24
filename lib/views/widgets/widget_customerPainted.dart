import 'package:flutter/material.dart';
import 'dart:math';

class WidgetCustomerpainted extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final radius = 10.0; // bán kính nhỏ
    final center = Offset(radius, size.height / 2); // hơi lùi vào một chút
    final rect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawArc(
      rect,
      -pi / 2,
      pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
