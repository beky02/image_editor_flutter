import 'package:flutter/material.dart';

class OvalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    Offset center = Offset(size.width / 2, size.height / 2);

    double radiusX = size.width / 2;
    double radiusY = size.height / 2;

    canvas.drawOval(Rect.fromCenter(center: center, width: radiusX, height: radiusY), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
