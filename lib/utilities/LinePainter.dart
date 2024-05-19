import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';

class LinePainter extends CustomPainter {
  final double height;
  final color;

  LinePainter({required this.height, this.color = kPrimaryColour90});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    canvas.drawLine(Offset(0, 0), Offset(0, height), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class LinePainterHoriztonal extends CustomPainter {
  final double width;
  final Color colour;

  LinePainterHoriztonal({required this.width, this.colour = kPrimaryColour90});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = colour
      ..strokeWidth = 2;

    canvas.drawLine(Offset(-width, 0), Offset(width, 0), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
