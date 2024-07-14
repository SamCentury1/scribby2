import 'package:flutter/material.dart';
import 'dart:math' as math;

class UnitedKingdomFlag extends CustomPainter {
    @override
    void paint(Canvas canvas, Size size) {

      final double w = size.width;
      final double h = size.height;
      final double xOrigin = w/2;
      final double yOrigin = h/2;
      Paint blueFill = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3.0
      ..style = PaintingStyle.fill;
      Paint redFill = Paint()
      ..color = Colors.red
      ..strokeWidth = 3.0
      ..style = PaintingStyle.fill;
      Paint whiteFill = Paint()
      ..color = Colors.white
      ..strokeWidth = 3.0
      ..style = PaintingStyle.fill; 

      Rect baseRect = Rect.fromLTWH(0, 0, w, h);
      
      Path whiteDiagPath1 = Path();
      whiteDiagPath1.moveTo(w*0.1, 0);
      whiteDiagPath1.lineTo(w,(h-(h*0.1)));
      whiteDiagPath1.lineTo(w, h);
      whiteDiagPath1.lineTo(w-(w*0.1), h);
      whiteDiagPath1.lineTo(0, h*0.1);
      whiteDiagPath1.lineTo(0,0);

      Path whiteDiagPath2 = Path();
      whiteDiagPath2.moveTo(w-(w*0.1),0);
      whiteDiagPath2.lineTo(w,0);
      whiteDiagPath2.lineTo(w,h*0.1);
      whiteDiagPath2.lineTo(w*0.1,h);
      whiteDiagPath2.lineTo(0,h);
      whiteDiagPath2.lineTo(0,h-(h*0.1));      


      Path redDiagPath1 = Path();
      redDiagPath1.moveTo(0, 0);
      redDiagPath1.lineTo(xOrigin, yOrigin);
      redDiagPath1.lineTo(xOrigin-(w*0.05), yOrigin);
      redDiagPath1.lineTo(0, h*0.05);

      Path redDiagPath2 = Path();
      redDiagPath2.moveTo(w, 0);
      redDiagPath2.lineTo(xOrigin, yOrigin);
      redDiagPath2.lineTo(xOrigin, yOrigin-(h*0.05));
      redDiagPath2.lineTo(w-(w*0.05),0); 

      Path redDiagPath3 = Path();
      redDiagPath3.moveTo(w, h);
      redDiagPath3.lineTo(xOrigin, yOrigin);
      redDiagPath3.lineTo(xOrigin+(w*0.05), yOrigin);
      redDiagPath3.lineTo(w, h-(h*0.05)); 

      Path redDiagPath4 = Path();
      redDiagPath4.moveTo(0, h);
      redDiagPath4.lineTo(xOrigin, yOrigin);
      redDiagPath4.lineTo(xOrigin, yOrigin+(h*0.05));
      redDiagPath4.lineTo(w*0.05, h);

      Rect whiteVerticalRect = Rect.fromLTWH(w*0.4, 0, w*0.2, h);
      Rect whiteHorizontalRect = Rect.fromLTWH(0, h*0.35, w, h*0.3);

      Rect redVerticalRect = Rect.fromLTWH(w*0.435, 0, w*0.15, h);
      Rect redHorizontalRect = Rect.fromLTWH(0, h*0.4, w, h*0.2);


      canvas.drawRect(baseRect, blueFill);
      canvas.drawPath(whiteDiagPath1, whiteFill);
      canvas.drawPath(whiteDiagPath2, whiteFill);

      canvas.drawPath(redDiagPath1, redFill);   
      canvas.drawPath(redDiagPath2, redFill);   
      canvas.drawPath(redDiagPath3, redFill);   
      canvas.drawPath(redDiagPath4, redFill);

      canvas.drawRect(whiteVerticalRect, whiteFill);
      canvas.drawRect(whiteHorizontalRect, whiteFill);
      canvas.drawRect(redVerticalRect, redFill);
      canvas.drawRect(redHorizontalRect, redFill);            
    }

    @override
    bool shouldRepaint(UnitedKingdomFlag oldDelegate) => false;
}


class SpanishFlag extends CustomPainter {
    @override
    void paint(Canvas canvas, Size size) {

      final double w = size.width;
      final double h = size.height;
      final double yOrigin = h/2;
      Paint blueFill = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3.0
      ..style = PaintingStyle.fill;
      Paint redFill = Paint()
      ..color = Colors.red
      ..strokeWidth = 3.0
      ..style = PaintingStyle.fill;
      Paint whiteFill = Paint()
      ..color = Colors.white
      ..strokeWidth = 3.0
      ..style = PaintingStyle.fill; 
      Paint yellowFill = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 3.0
      ..style = PaintingStyle.fill; 

      Rect redRect1 = Rect.fromLTWH(0, 0, w, h*0.25);
      Rect yellowRect = Rect.fromLTWH(0, h*0.25, w, h*0.5);
      Rect redRect2 = Rect.fromLTWH(0, h*0.75, w, h*0.25);

      Rect column1 = Rect.fromLTWH(w*0.20, yOrigin-(h*0.10), h*0.03, h*0.25);
      Rect column2 = Rect.fromLTWH((w*0.2+h*0.4)-h*0.035, yOrigin-(h*0.10), h*0.03, h*0.25);

      Rect colTop1 = Rect.fromLTWH(w*0.2, yOrigin-(h*0.12), h*0.03, h*0.02);
      Rect colTop2 = Rect.fromLTWH((w*0.2+h*0.4)-h*0.035, yOrigin-(h*0.12), h*0.03, h*0.02);

      Rect colBase1 = Rect.fromLTWH(w*0.2-h*0.02, yOrigin+(h*0.15), h*0.08, h*0.03);
      Rect colBase2 = Rect.fromLTWH((w*0.2-h*0.055+h*0.4), yOrigin+h*0.15, h*0.08, h*0.03);

      // Rect whiteRect1 = Rect.fromLTWH((w*0.2)+((h*0.4)/2), yOrigin-h*0.1, (h*0.25)/2, (h*0.25)/2);
      Rect redRect3 = Rect.fromLTWH((w*0.2)+(h*0.075), yOrigin-(h*0.1), h*0.25, h*0.25);

      canvas.drawRect(redRect1, redFill);
      canvas.drawRect(yellowRect, yellowFill);
      canvas.drawRect(redRect2, redFill);

      canvas.drawArc(
        Rect.fromCenter(center: Offset((w*0.2)+((h*0.4)/2), yOrigin-(h*0.1)), height: h*0.2, width: h*0.25), 
        math.pi, math.pi, false, redFill);

      canvas.drawArc(
        Rect.fromCenter(center: Offset((w*0.2)+((h*0.4)/2), yOrigin+h*0.15), height: h*0.05, width: h*0.25),
        math.pi*2, math.pi, false, redFill);

      canvas.drawRect(redRect3, redFill);
      canvas.drawRect(column1, whiteFill);
      canvas.drawRect(column2, whiteFill);
      canvas.drawRect(colBase1, blueFill);
      canvas.drawRect(colBase2, blueFill);
      canvas.drawRect(colTop1, redFill);
      canvas.drawRect(colTop2, redFill);

    }
    @override
    bool shouldRepaint(SpanishFlag oldDelegate) => false;      
}


class PortugueseFlag extends CustomPainter {
    @override
    void paint(Canvas canvas, Size size) {

      final double w = size.width;
      final double h = size.height;
      final double yOrigin = h/2;
      Paint blueFill = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3.0
      ..style = PaintingStyle.fill;
      Paint greenFill = Paint()
      ..color = Colors.green
      ..strokeWidth = 3.0
      ..style = PaintingStyle.fill;      
      Paint redFill = Paint()
      ..color = Colors.red
      ..strokeWidth = 3.0
      ..style = PaintingStyle.fill;
      Paint whiteFill = Paint()
      ..color = Colors.white
      ..strokeWidth = 3.0
      ..style = PaintingStyle.fill; 
      Paint yellowFill = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 3.0
      ..style = PaintingStyle.fill; 

      Rect greenRect = Rect.fromLTWH(0, 0, w/3, h);
      Rect redRect = Rect.fromLTWH(w/3, 0, (w/3)*2, h);

      Rect insideRedRect = Rect.fromLTWH(((w/3)-((h/4)/2)), yOrigin-h*0.15, h*0.25, h*0.26);
      Rect insideRedSemiCircle = Rect.fromCenter(
        center: Offset((w/3),yOrigin+h*0.10), height: h*0.15, width:h*0.25);

      Rect insideWhiteRect = Rect.fromLTWH(((w/3)-((h*0.18)/2)), yOrigin - h*0.12, h*0.18, h*0.23);
      Rect insideWhiteSemiCircle = Rect.fromCenter(
        center: Offset(w/3,yOrigin+h*0.1), 
        height: h*0.075, width: h*0.18, 
      );

      Rect blueRect1 = Rect.fromCenter(center: Offset(w/3, yOrigin-h*0.06), height: h*0.05, width: h*0.05,);
      Rect blueRect2 = Rect.fromCenter(center: Offset(w/3, yOrigin), height: h*0.05, width: h*0.05,);
      Rect blueRect3 = Rect.fromCenter(center: Offset(w/3, yOrigin+h*0.06), height: h*0.05, width: h*0.05,);
      Rect blueRect4 = Rect.fromCenter(center: Offset(w/3-(h*0.06), yOrigin), height: h*0.05, width: h*0.05,);
      Rect blueRect5 = Rect.fromCenter(center: Offset(w/3+(h*0.06), yOrigin), height: h*0.05, width: h*0.05,);

      canvas.drawRect(greenRect, greenFill);
      canvas.drawRect(redRect, redFill);
      canvas.drawCircle(Offset(w/3,h/2), h/4, yellowFill);
      canvas.drawRect(insideRedRect, redFill);
      canvas.drawArc(insideRedSemiCircle, math.pi*2, math.pi, false, redFill);
      canvas.drawRect(insideWhiteRect, whiteFill);
      canvas.drawArc(insideWhiteSemiCircle, math.pi*2, math.pi, false, whiteFill);
      canvas.drawRect(blueRect1, blueFill);
      canvas.drawRect(blueRect2, blueFill);
      canvas.drawRect(blueRect3, blueFill);
      canvas.drawRect(blueRect4, blueFill);
      canvas.drawRect(blueRect5, blueFill);
    }
    @override
    bool shouldRepaint(PortugueseFlag oldDelegate) => false;          
}


class GreekFlag extends CustomPainter {
    @override
    void paint(Canvas canvas, Size size) {

      final double w = size.width;
      final double h = size.height;
      Paint blueFill = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3.0
      ..style = PaintingStyle.fill;
      Paint whiteFill = Paint()
      ..color = Colors.white
      ..strokeWidth = 3.0
      ..style = PaintingStyle.fill; 


      Rect blueBase = Rect.fromLTWH(0, 0, w, h);
      Rect whiteStripe1 = Rect.fromLTWH(0, (h/9), w, h/9);
      Rect whiteStripe2 = Rect.fromLTWH(0, (h/9)*3, w, h/9);
      Rect whiteStripe3 = Rect.fromLTWH(0, (h/9)*5, w, h/9);
      Rect whiteStripe4 = Rect.fromLTWH(0, (h/9)*7, w, h/9);

      Rect blueRect = Rect.fromLTWH(0, 0, w*(10/27), ((h/9)*5));
      Rect crossStripe1 = Rect.fromLTWH(0,(h/9)*2, w*(10/27), (h/9));
      Rect crossStripe2 = Rect.fromLTWH(((w*(10/27))/2)-(h/9)/2, 0, h/9, ((h/9)*6));

      canvas.drawRect(blueBase, blueFill);
      canvas.drawRect(whiteStripe1, whiteFill);
      canvas.drawRect(whiteStripe2, whiteFill);
      canvas.drawRect(whiteStripe3, whiteFill);
      canvas.drawRect(whiteStripe4, whiteFill);
      canvas.drawRect(blueRect, blueFill);
      canvas.drawRect(crossStripe1, whiteFill);
      canvas.drawRect(crossStripe2, whiteFill);
    }
    @override
    bool shouldRepaint(GreekFlag oldDelegate) => false;          
}


class FrenchFlag extends CustomPainter {
    @override
    void paint(Canvas canvas, Size size) {

      final double w = size.width;
      final double h = size.height;

      Paint blueFill = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3.0
      ..style = PaintingStyle.fill; 
      Paint whiteFill = Paint()
      ..color = Colors.white
      ..strokeWidth = 3.0
      ..style = PaintingStyle.fill; 
      Paint redFill = Paint()
      ..color = Colors.red
      ..strokeWidth = 3.0
      ..style = PaintingStyle.fill;             

      Rect blueRect = Rect.fromLTWH(0, 0, w/3, h);
      Rect whiteRect = Rect.fromLTWH((w/3), 0, w/3, h);
      Rect redRect = Rect.fromLTWH((w/3)*2, 0, w/3, h);

      canvas.drawRect(blueRect, blueFill);
      canvas.drawRect(whiteRect, whiteFill);
      canvas.drawRect(redRect, redFill);

    }
    @override
    bool shouldRepaint(FrenchFlag oldDelegate) => false;          
}

class ItalianFlag extends CustomPainter {
    @override
    void paint(Canvas canvas, Size size) {

      final double w = size.width;
      final double h = size.height;

      Paint greenFill = Paint()
      ..color = Colors.green
      ..strokeWidth = 3.0
      ..style = PaintingStyle.fill; 
      Paint whiteFill = Paint()
      ..color = Colors.white
      ..strokeWidth = 3.0
      ..style = PaintingStyle.fill; 
      Paint redFill = Paint()
      ..color = Colors.red
      ..strokeWidth = 3.0
      ..style = PaintingStyle.fill;             

      Rect greenRect = Rect.fromLTWH(0, 0, w/3, h);
      Rect whiteRect = Rect.fromLTWH((w/3), 0, w/3, h);
      Rect redRect = Rect.fromLTWH((w/3)*2, 0, w/3, h);

      canvas.drawRect(greenRect, greenFill);
      canvas.drawRect(whiteRect, whiteFill);
      canvas.drawRect(redRect, redFill);

    }
    @override
    bool shouldRepaint(ItalianFlag oldDelegate) => false;          
}

class GermanFlag extends CustomPainter {
    @override
    void paint(Canvas canvas, Size size) {

      final double w = size.width;
      final double h = size.height;

      Paint blackFill = Paint()
      ..color = Colors.black
      ..strokeWidth = 3.0
      ..style = PaintingStyle.fill; 
      Paint redFill = Paint()
      ..color = Colors.red
      ..strokeWidth = 3.0
      ..style = PaintingStyle.fill; 
      Paint yellowFill = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 3.0
      ..style = PaintingStyle.fill;             



      Rect blackRect = Rect.fromLTWH(0, 0, w, (h/3));
      Rect redRect = Rect.fromLTWH(0, (h/3), w, (h/3));
      Rect yellowRect = Rect.fromLTWH(0, (h/3)*2, w, (h/3));


      canvas.drawRect(blackRect, blackFill);
      canvas.drawRect(redRect, redFill);
      canvas.drawRect(yellowRect, yellowFill);

    }
    @override
    bool shouldRepaint(GermanFlag oldDelegate) => false;          
}

class DutchFlag extends CustomPainter {
    @override
    void paint(Canvas canvas, Size size) {

      final double w = size.width;
      final double h = size.height;

      Paint blueFill = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3.0
      ..style = PaintingStyle.fill; 
      Paint whiteFill = Paint()
      ..color = Colors.white
      ..strokeWidth = 3.0
      ..style = PaintingStyle.fill; 
      Paint redFill = Paint()
      ..color = Colors.red
      ..strokeWidth = 3.0
      ..style = PaintingStyle.fill;   

      Rect redRect = Rect.fromLTWH(0, 0, w, (h/3));
      Rect whiteRect = Rect.fromLTWH(0, (h/3), w, (h/3));
      Rect blueRect = Rect.fromLTWH(0, (h/3)*2, w, (h/3));

      canvas.drawRect(redRect, redFill);
      canvas.drawRect(whiteRect, whiteFill);
      canvas.drawRect(blueRect, blueFill);

    }
    @override
    bool shouldRepaint(DutchFlag oldDelegate) => false;          
}