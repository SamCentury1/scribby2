import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';
// import 'package:scribby_flutter_v2/settings/settings.dart';

class GradientBackground extends CustomPainter {
  final SettingsController settings;
  final ColorPalette palette;
  final List<Map<String,dynamic>> decorationData;
  const GradientBackground({
    required this.settings,
    required this.palette,
    required this.decorationData,
  });

  @override
  void paint(Canvas canvas, Size size) {
    
    // Paint backgroundPaint = Paint()
    // ..shader = ui.Gradient.linear(
    //   Offset.zero,
    //   Offset(size.width,size.height),
    //   [
    //     palette.bg1,
    //     palette.bg2
    //   ],
    // );
    // canvas.drawPaint(backgroundPaint);

    final Rect rect = Offset.zero & size;

    final Paint paint = Paint()
      ..shader = RadialGradient(
        colors: [palette.bg1, palette.bg2],
        center: Alignment.center, // You can also use Alignment.topLeft, etc.
        radius: 0.9,              // Relative to the shorter side of the rect
      ).createShader(rect);

    canvas.drawRect(rect, paint); // Or drawCircle, drawRRect, etc.


    // final Map<String,dynamic> deviceSizeInfo = settings.deviceSizeInfo.value as Map<String,dynamic>;
    // final double screenWidth = deviceSizeInfo["width"];
    // final double screenHeight = deviceSizeInfo["height"];

    Paint decorationSquarePaint = Paint();
    // Random random = Random();
    for (int i=0; i<decorationData.length; i++) {

      decorationSquarePaint.color = Color.fromRGBO(0, 0, 0, decorationData[i]["opacity"]);

      final double squareSize = decorationData[i]["size"];
      final double posX = decorationData[i]["dx"] * size.width;
      final double posY = decorationData[i]["dy"] * size.height;
      final Offset center = Offset(posX, posY);
      final double angle = decorationData[i]["angle"];



      Rect rect = Rect.fromCenter(center: center, width: squareSize, height: squareSize);
      RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(squareSize*0.15));


      // Save canvas state before rotating
      canvas.save();      

      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle);
      canvas.translate(-center.dx, -center.dy);      

      canvas.drawRRect(rrect, decorationSquarePaint);

      // Restore canvas
      canvas.restore();      
    }


  //   Offset tileCenter = Offset(size.width/4,size.height/4);
    
    
  //   Paint rrectPaint2 = Paint()
  //   ..color = const Color.fromARGB(255, 7, 78, 10);
    
  //   Rect rect2 = Rect.fromCenter(center: Offset(tileCenter.dx-20,tileCenter.dy+20), width: 200, height: 200);
  //   RRect rrect2 = RRect.fromRectAndRadius(rect2,Radius.circular(12.0));  
  //   canvas.save();
  //   canvas.translate(size.width/4, size.height/4);
  //   final matrix2 = Matrix4.identity()
  //     ..setEntry(2, 3, 0.001) // add perspective
  //     ..rotateY(pi / 12)
  //     ..rotateX(pi / 4);      // 30-degree tilt (front-back)
  //   canvas.transform(matrix2.storage);
  //   canvas.drawRRect(rrect2,rrectPaint2);
  //   // Restore canvas
  //   canvas.restore();          



    
  //   Paint rrectPaint = Paint()

  //   ..color = Colors.green;
  //   Rect rect1 = Rect.fromCenter(center: tileCenter, width: 200, height: 200);
  //   RRect rrect1 = RRect.fromRectAndRadius(rect1,Radius.circular(12.0));  
  //   canvas.save();
  //   canvas.translate(size.width/4, size.height/4);
  //   final matrix = Matrix4.identity()
  //     ..setEntry(2, 3, 0.001) // add perspective
  //     ..rotateY(pi / 12)
  //     ..rotateX(pi / 4);      // 30-degree tilt (front-back)
  //   canvas.transform(matrix.storage);
  //   canvas.drawRRect(rrect1,rrectPaint);


  //   // Draw the letter 'S' in the center of the tilted rectangle
  //   final textPainter = TextPainter(
  //     text: const TextSpan(
  //       text: 'S',
  //       style: TextStyle(
  //         fontSize: 108,
  //         fontWeight: FontWeight.bold,
  //         color: Color.fromARGB(255, 12, 12, 12),
  //       ),
  //     ),
  //     textAlign: TextAlign.center,
  //     textDirection: TextDirection.ltr,
  //   );
  //   textPainter.layout();

  //   final textOffset = Offset(tileCenter.dx-textPainter.width / 2, tileCenter.dy-textPainter.height / 2);
  //   textPainter.paint(canvas, textOffset);    

  //   canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}