import 'package:flutter/material.dart';

class Chart extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.blue[100];
    canvas.drawRect(Rect.fromLTWH(4, 4, size.width - 8, size.height - 8), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}