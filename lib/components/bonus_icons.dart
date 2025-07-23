import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:scribby_flutter_v2/functions/animation_utils.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/painters/bonus_painters.dart';

class BonusIcons {
  Canvas drawStreakIcon(Canvas canvas, Size iconSize, Offset position, Color color) {
    double inc(int val) {
      double res = (iconSize.width/100) * val;
      return res;
    }    
    double locationX(int val) {
      double res = position.dx + inc(val) - (iconSize.width/2);
      return res;
    }
    
    double locationY(int val) {
      double res = position.dy + inc(val) - (iconSize.height/2);
      return res;
    }  
    
    Paint flamePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeWidth = inc(1)
      ..strokeCap = StrokeCap.round;  
  
    Path flamePath = Path();
    flamePath.moveTo(locationX(30),locationY(10));

    flamePath.quadraticBezierTo(
      locationX(35),locationY(20),
      locationX(20),locationY(45)   
    );  
    
    flamePath.quadraticBezierTo(
      locationX(-15),locationY(98),
      locationX(50),locationY(98)   
    );
    
    flamePath.quadraticBezierTo(
      locationX(115),locationY(98),
      locationX(70),locationY(40)   
    );
    
    flamePath.quadraticBezierTo(
      locationX(65),locationY(30),
      locationX(70),locationY(20)   
    ); 
    
    flamePath.quadraticBezierTo(
      locationX(50),locationY(40),
      locationX(50),locationY(50)   
    );
    
    flamePath.quadraticBezierTo(
      locationX(50),locationY(30),
      locationX(30),locationY(10)   
    );  
    canvas.drawPath(flamePath, flamePaint);
    Path flamePath2 = Path();
    flamePath2.moveTo(locationX(50),locationY(02));
    
    flamePath2.quadraticBezierTo(
      locationX(0),locationY(90),
      locationX(50),locationY(95)   
    );
    
    flamePath2.quadraticBezierTo(
      locationX(80),locationY(90),
      locationX(50),locationY(02)  
    );    
    
    canvas.drawPath(flamePath2, flamePaint);
    
    return canvas;    
  }


  Canvas drawLevelUp(Canvas canvas, GamePlayState gamePlayState) {
    Map<String,dynamic> levelUpAnimation = gamePlayState.animationData.firstWhere((e)=>e["type"]=="level-up",orElse: ()=>{});
    if (levelUpAnimation.isNotEmpty) {
      Offset position = gamePlayState.elementPositions["bonusCenter"];
      int body = levelUpAnimation["body"];
      double progress = levelUpAnimation["progress"];
      
      // elevation animation details
      List<Map<String,dynamic>> elevationAnimationDetails = [
        {"source": 50.0 * gamePlayState.scalor, "target": 0.0, "duration": 0.15},
        {"source": 0.0, "target": 0.0, "duration": 0.60},
        {"source": 0.0, "target":-100.0 * gamePlayState.scalor, "duration": 0.25},
      ];
      double getElevationProgress = AnimationUtils().getAnimationTransition(progress,elevationAnimationDetails);
      double updatedY = position.dy  + getElevationProgress;
      Offset updatedPosition = Offset(position.dx, updatedY);

      // opacity animation details
      List<Map<String,dynamic>> opacityAnimationDetails = [
        {"source": 0.0, "target": 1.0, "duration": 0.15},
        {"source": 1.0, "target": 1.0, "duration": 0.60},
        {"source": 1.0, "target": 0.0, "duration": 0.25},
      ];      
      double getOpacityProgress = AnimationUtils().getAnimationTransition(progress,opacityAnimationDetails);

      late double fontSize = 36 * gamePlayState.scalor; 

      TextStyle textStyle = TextStyle(
        color: Color.fromRGBO(255, 255, 255, getOpacityProgress), //const Color.fromARGB(190, 123, 191, 255),
        fontSize: fontSize,
      );
      TextSpan textSpan = TextSpan(
        text: "Level ${body.toString()}",
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      final textPosition = Offset(updatedPosition.dx - (textPainter.width/2), updatedPosition.dy - (textPainter.height/2));
      textPainter.paint(canvas, textPosition);


      // Rect rect = Rect.fromCenter(center: updatedPosition, width: 200, height: 50);
      // canvas.drawRect(rect, paint);
    }
    return canvas;
  }

}

class BonusIconPaitner extends CustomPainter{
  final String bonusType;
  final double scalor;
  const BonusIconPaitner({
    required this.bonusType,
    required this.scalor,
  });
  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width/2, size.height/2);
    final double side = size.width*0.7;
    // final double side = 15*scalor;
    if (bonusType=="streak") {
      BonusPainters().drawStreakIcon(canvas, Size(side,side), center, Colors.white);
    } else if (bonusType=="cross") {
      BonusPainters().drawCrossWordIcon(canvas, Size(side,side), center, Colors.white);
    } else if (bonusType=="words") {
      BonusPainters().drawMultiWordIcon(canvas, Size(side,side), center, Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}