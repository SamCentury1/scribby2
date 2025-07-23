
import 'package:flutter/material.dart';
import 'package:scribby_flutter_v2/components/gem_painter_1.dart';

class NavigationPainters {

  Canvas drawPerkIcon(Canvas canvas, Size size, String perk) {

    
    if (perk == "ad") {
      drawAdIcon(canvas,size);
    } else if (perk == "sapphire") {
      GemPainter().drawGemPainter(canvas,size, const Color.fromARGB(255, 28, 26, 167));
    } else if (perk == "ruby") {
      GemPainter().drawGemPainter(canvas,size, const Color.fromARGB(255, 168, 49, 39));
    } else if (perk == "jade") {
      GemPainter().drawGemPainter(canvas,size, const Color.fromARGB(255, 40, 145, 26));

    }
    return canvas;
  }

  Canvas drawAdIcon(Canvas canvas, Size size) {

    Offset center = Offset(size.width/2,size.height/2);

    Paint paint = Paint()
    ..color = const Color.fromARGB(255, 46, 45, 45)
    ..strokeJoin = StrokeJoin.round;

    Rect rect = Rect.fromCenter(center: Offset(center.dx,center.dy+size.width*0.1), width: size.width*0.7, height: size.height*0.5);
    RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(size.width*0.06));
    canvas.drawRRect(rrect, paint);

    Offset pathStart = Offset(center.dx-(size.width*0.7/2), (center.dy-size.height*0.5/2)+(size.width*0.1)); 
    Path path = Path();
    path.moveTo(pathStart.dx,pathStart.dy);
    path.relativeLineTo(-size.width*0.05, -size.height*0.1);
    path.relativeLineTo(size.width*0.70, -size.height*0.2);
    path.relativeLineTo(size.width*0.05, size.height*0.1);
    path.close();

    canvas.drawPath(path, paint);

    // triangle piece
    Offset triangleCenter = Offset(center.dx,center.dy-size.width*0.20);
    Path trianglePath = Path();
    trianglePath.moveTo(triangleCenter.dx-size.width*0.15, triangleCenter.dy);
    trianglePath.relativeLineTo(0.0, size.width*0.2);
    trianglePath.relativeLineTo(size.width*0.3, size.width*0.1);
    trianglePath.relativeLineTo(-size.width*0.3, size.width*0.1);
    trianglePath.close();

    Paint trainglePaint = Paint()
    ..color = Colors.white
    ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(trianglePath, trainglePaint);



    // canvas.drawCircle(position, 10.0, paint);

    return canvas;
  }

}

class PerkIcons extends CustomPainter {
  final String perk; 
  PerkIcons({
    required this.perk
  });
   
  @override  
  void paint(Canvas canvas, Size size) {

    NavigationPainters().drawPerkIcon(canvas,size,perk);

    
  }
  @override
  bool shouldRepaint(PerkIcons oldDelegate) => false;
}
