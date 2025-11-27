import 'package:flutter/material.dart';

class CirclePatternPainterWidget extends CustomPainter {
  final Color color;

  CirclePatternPainterWidget(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.2), 40, paint);
    canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.7), 30, paint);
    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.8), 25, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
