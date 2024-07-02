import 'package:flutter/material.dart';

class MakeCircle extends CustomPainter {
  final double radius;
  final double animationValue;

  MakeCircle({required this.radius, required this.animationValue});
  double convertRadiusToSigma(double radius) {
    return radius * 0.57735 + 0.5;
  }    
  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width / 2;
    Offset center = Offset(size.width / 2, size.height / 2);
    double shadowBlurRadius = 10;
    Paint shadowPaint = Paint()
      ..color = Colors.red.withOpacity(0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10*animationValue
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, convertRadiusToSigma(shadowBlurRadius));
    canvas.drawCircle(center, radius, shadowPaint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is MakeCircle) {
      return oldDelegate.animationValue != animationValue;
    }
    return true;
  }
}