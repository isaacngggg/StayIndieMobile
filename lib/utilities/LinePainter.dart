import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';

class LinePainter extends CustomPainter {
  final double height;

  LinePainter({required this.height});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = kPrimaryColour40
      ..strokeWidth = 1;

    canvas.drawLine(Offset(0, 0), Offset(0, height), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
