import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:scribby_flutter_v2/functions/animation_utils.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/functions/styling_utils.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';

class BonusPainters {

  Canvas drawBonusArea(Canvas canvas, GamePlayState gamePlayState) {
    // Size bonusArea = gamePlayState.elementSizes["bonusAreaSize"];
    // Offset bonusCenter = gamePlayState.elementPositions["bonusCenter"];

    // // Rect rect = Rect.fromCenter(center: bonusCenter, width: bonusArea.width, height: bonusArea.height);

    // Paint paint = Paint()
    // ..color = const Color.fromARGB(50, 255, 255, 255);

    // canvas.drawRect(rect, paint);


    drawBonusElements(canvas,gamePlayState);

    drawLevelUp(canvas,gamePlayState);
    
    return canvas;
  }

  Canvas drawBonusElements(Canvas canvas, GamePlayState gamePlayState) {


    double bonusElementSize = 32.0 * gamePlayState.scalor; //tileSize.width*0.6;
    Offset scoreboardCenter = gamePlayState.elementPositions["scoreboardCenter"];
    Offset bonusAreaCenter = gamePlayState.elementPositions["bonusCenter"];

    Size scoreboardArea = gamePlayState.elementSizes["scoreboardAreaSize"];


    double bonusY = bonusAreaCenter.dy;

    List<Map<String,dynamic>> bonusAnimations = gamePlayState.animationData.where((e)=>e["type"]=="bonus").toList();

    Color red = Colors.red;
    Color yellow = Colors.yellow;

    final double gapTime = 0.70;

    for (int i=0; i<bonusAnimations.length;i++) {
      late double startGap = 0.1; // double.parse((gapTime/bonusAnimations.length).toStringAsFixed(2)) * i;
      late double endGap = 0.55; // ((gapTime)-startGap);
      late double displayTime = 0.35; // 0.3;

      final double progress = bonusAnimations[i]["progress"];
      List<Map<String,dynamic>> positionYSequence = [
        {"source": 0.0, "target": 0.0, "duration": startGap},
        {"source": 0.0, "target": 1.0, "duration": displayTime},
        {"source": 1.0, "target": 2.0, "duration": endGap},
      ];
      
      double positionYFactor = AnimationUtils().getAnimationTransition(progress,positionYSequence);
      late double positionY = bonusY - ((60*gamePlayState.scalor) * positionYFactor) ;   


      List<Map<String,dynamic>> colorSequence = [
        {"source": Colors.transparent, "target": Colors.transparent, "duration": startGap},
        {"source": Colors.transparent, "target": yellow, "duration": 0.05},
        {"source": yellow, "target": red, "duration": 0.05},
        {"source": red, "target": yellow, "duration": 0.05},
        {"source": yellow, "target": red, "duration": 0.05},
        {"source": red, "target": yellow, "duration": 0.05},
        {"source": yellow, "target": red, "duration": 0.05},
        {"source": red, "target": yellow, "duration": 0.05},
        {"source": yellow, "target": red, "duration": 0.05},    
        {"source": red, "target": yellow, "duration": 0.05},
        {"source": yellow, "target": Colors.transparent, "duration": 0.05},                
        {"source": Colors.transparent, "target": Colors.transparent, "duration": endGap},
      ];

      Color colorRes = StylingUtils().getColorLerp(colorSequence,progress);      
 
      // double topYValue = topY + (i*bonusElementSize);
      Map<String,dynamic> bonusAnimation = bonusAnimations[i];
      TextStyle textStyle = TextStyle(
        color: colorRes, //Color.fromRGBO(255, 255, 255, opacityProgress),
        fontSize:  26 * gamePlayState.scalor // tileSize.width*0.3,
      );
      TextSpan textSpan = TextSpan(
        text: "${bonusAnimation["animation"]["body"]}x",
        style: textStyle,
      );

      final TextPainter textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.rtl,
      );
      textPainter.layout();

      Size iconSize = Size(bonusElementSize*0.6,bonusElementSize*0.6);
      String bonusType = bonusAnimation["animation"]["bonus"];

      // late double bonusX = scoreboardCenter.dx - ((scoreboardArea.width*0.95)/2) + ((60*gamePlayState.scalor) * gamePlayState.scalor) +iconSize.width + (i*(bonusElementSize+(28*gamePlayState.scalor)));
      late double bonusX =  AnimationUtils().getBonusXValue(gamePlayState,bonusType);

      double textX = (bonusX+(bonusElementSize/2)) - (textPainter.width/2);
      double textY = (positionY+(bonusElementSize/2)) - (textPainter.height/2);

      Offset textCenter = Offset(textX, textY);



      Offset iconCenter = Offset(textCenter.dx - iconSize.width*0.8, textCenter.dy+iconSize.height/2);

      drawIcon(canvas,iconSize,iconCenter,colorRes,bonusAnimation["animation"]["bonus"],);

      textPainter.paint(canvas, textCenter);



    }

    return canvas;
  }



  Canvas drawCrossWordIcon(Canvas canvas, Size iconSize, Offset position, Color color) {

    double inc(int val) {
      double res = (iconSize.width/100) * val;
      return res;
    }    

    double boxWidth = iconSize.width/4;

    double leftX = position.dx-(iconSize.width/2);
    double topY = position.dy-(iconSize.width/2);

    Paint paint = Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = inc(4);

    List<List<int>> locations = [[1,0],[0,1],[1,1],[2,1],[3,1],[1,2],[1,3]];
    for (int i=0; i<locations.length; i++) {
      List<int> details = locations[i];
      // Offset offset = Offset(leftX+(boxWidth/2)*details[0], topY+(boxWidth/2)*details[1]);
      // Rect rect = Rect.fromCenter(center: offset, width: boxWidth, height: boxWidth);
      double dx = leftX + (details[0] * boxWidth);
      double dy = topY + details[1] * boxWidth;
      Rect rect = Rect.fromLTWH(dx, dy, boxWidth, boxWidth);
      canvas.drawRect(rect, paint);
    }
    return canvas;
  }

  Canvas drawMultiWordIcon(Canvas canvas,Size iconSize, Offset position, Color color) {
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
    
    Paint handlePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeWidth = inc(4)
      ..strokeCap = StrokeCap.round;  

    Path handlePath = Path();
    handlePath.moveTo( locationX(25), locationY(60));
    handlePath.lineTo( locationX(7), locationY(78));
    handlePath.quadraticBezierTo(
      locationX(5), locationY(80),
      locationX(7), locationY(82)
    );
    handlePath.lineTo( locationX(13), locationY(88));
    handlePath.quadraticBezierTo(
      locationX(15), locationY(90),
      locationX(17), locationY(88)
    );
    
    handlePath.lineTo( locationX(35), locationY(70));
    handlePath.quadraticBezierTo(
      locationX(29), locationY(66),
      locationX(25), locationY(60)
    );
    handlePath.close();
    canvas.drawPath(handlePath,handlePaint);
    
    Paint ringPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = inc(4)
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(Offset(locationX(55),locationY(40)),inc(30),ringPaint);
    canvas.drawCircle(Offset(locationX(55),locationY(40)),inc(32),ringPaint);
    canvas.drawCircle(Offset(locationX(55),locationY(40)),inc(34),ringPaint);
    canvas.drawCircle(Offset(locationX(55),locationY(40)),inc(36),ringPaint);
    
    canvas.drawLine(Offset(locationX(35), locationY(30)), Offset(locationX(65), locationY(30)), ringPaint);
    canvas.drawLine(Offset(locationX(35), locationY(40)), Offset(locationX(75), locationY(40)), ringPaint);
    canvas.drawLine(Offset(locationX(35), locationY(50)), Offset(locationX(75), locationY(50)), ringPaint);
    return canvas;
  }

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
    // final double inc = iconSize.width*0.1;   
    Paint flamePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeWidth = inc(1)
      ..strokeCap = StrokeCap.round;  
  
    Path flamePath = Path();

      // {"type": "start", "data": [ 5.5,  0.5]},
    flamePath.moveTo(locationX(55),locationY(5));
      // {"type": "line",  "data": [ 2.0,  6.2]},
    flamePath.lineTo(locationX(20), locationY(62));
      // {"type": "line",  "data": [ 5.0,  6.0]},
    flamePath.lineTo(locationX(55), locationY(60));
      // {"type": "line",  "data": [ 4.5,  9.5]},
    flamePath.lineTo(locationX(45), locationY(95));
      // {"type": "line",  "data": [ 8.0,  3.8]},
    flamePath.lineTo(locationX(80), locationY(38));
      // {"type": "line",  "data": [ 5.0,  4.0]},
    flamePath.lineTo(locationX(50), locationY(40));
      // {"type": "end",   "data": []},
    flamePath.close();


    canvas.drawPath(flamePath, flamePaint);
    
    return canvas;    
  }

  Canvas drawIcon(Canvas canvas, Size iconSize, Offset position, Color color,String icon, ) {
    if (icon == "streak") {
      drawStreakIcon(canvas, iconSize, position, color);
    }

    if (icon == "cross") {
      drawCrossWordIcon(canvas, iconSize, position, color);
    }

    if (icon == "words") {
      drawMultiWordIcon(canvas, iconSize, position, color);
    }
    return canvas;
  }


  Canvas drawLevelUp(Canvas canvas, GamePlayState gamePlayState) {
    Map<String,dynamic> levelUpAnimation = gamePlayState.animationData.firstWhere((e)=>e["type"]=="level-up",orElse: ()=>{});
    if (levelUpAnimation.isNotEmpty) {
      Offset position = gamePlayState.elementPositions["bonusCenter"];
      int body = levelUpAnimation["body"];
      double progress = levelUpAnimation["progress"];
      
      // elevation animation details TODO: UPDATE TO DYNAMIC VALUE
      List<Map<String,dynamic>> elevationAnimationDetails = [
        {"source": 50.0* gamePlayState.scalor, "target": 0.0, "duration": 0.15},
        {"source": 0.0, "target": 0.0, "duration": 0.60},
        {"source": 0.0, "target": 0.0* gamePlayState.scalor, "duration": 0.25},
      ];
      double getElevationProgress = AnimationUtils().getAnimationTransition(progress,elevationAnimationDetails);
      double updatedY = position.dy  + getElevationProgress;
      Offset updatedPosition = Offset(position.dx, updatedY);

      // opacity animation details TODO: UPDATE TO DYNAMIC VALUE
      List<Map<String,dynamic>> opacityAnimationDetails = [
        {"source": 0.0, "target": 1.0, "duration": 0.15},
        {"source": 1.0, "target": 1.0, "duration": 0.60},
        {"source": 1.0, "target": 0.0, "duration": 0.25},
      ];      
      double getOpacityProgress = AnimationUtils().getAnimationTransition(progress,opacityAnimationDetails);

      List<Map<String,dynamic>> fontSizeAnimationDetails = [
        {"source": 0.0, "target": 1.0, "duration": 0.15},
        {"source": 1.0, "target": 1.0, "duration": 0.60},
        {"source": 1.0, "target": 1.0, "duration": 0.25},
      ];      
      double getFontSizeProgress = AnimationUtils().getAnimationTransition(progress,fontSizeAnimationDetails);      

      late double fontSize = 36 * gamePlayState.scalor *getFontSizeProgress; // TODO: UPDATE TO DYNAMIC VALUE

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