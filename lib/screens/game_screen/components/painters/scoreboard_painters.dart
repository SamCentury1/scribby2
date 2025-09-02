import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:scribby_flutter_v2/functions/animation_utils.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/functions/styling_utils.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/painters/tile_painters.dart';

class ScoreboardPainters {


  Canvas drawScoreboardArea(Canvas canvas, GamePlayState gamePlayState, ColorPalette palette) {

    Size scoreboardSize = gamePlayState.elementSizes["scoreboardAreaSize"];
    Offset scoreboardCenter = gamePlayState.elementPositions["scoreboardCenter"];
    // Offset screenCenter = gamePlayState.elementPositions["screenCenter"];
    // Offset effectiveCenter = gamePlayState.elementPositions["effectiveCenter"];
    
    // double scoreboardCenterY = effectiveCenter.dy - gamePlayState.elementSizes["effectiveSize"].height*0.5 + (scoreboardSize.height/2);
    
    // Offset effectiveScoreboardCenter = Offset(scoreboardCenter.dx, scoreboardCenterY);

    // Rect scoreboardSectionRect = Rect.fromCenter(center: effectiveScoreboardCenter, width: scoreboardSize.width, height: scoreboardSize.height);
    // Paint scoreboardSectionPaint = Paint()
    // ..color = const Color.fromARGB(255, 200, 238, 200);
    // canvas.drawRect(scoreboardSectionRect,scoreboardSectionPaint);

    
    late int score = Helpers().calculateScore(gamePlayState);
    // if (gamePlayState.scoreSummary.isNotEmpty) {
    //   late int val = 0;
    //   for (int i=0;i<gamePlayState.scoreSummary.length;i++) {
    //     val = val + gamePlayState.scoreSummary[i]["score"] as int;
    //   }
    //   score = val;
    // }
    // // String body = score.toString();



    drawScoreboard(canvas,scoreboardCenter,gamePlayState,score,scoreboardSize, palette);

    drawPlusNPointsAnimations(canvas,gamePlayState,scoreboardCenter,palette);
    // drawPointsArea(canvas, gamePlayState,body);

    return canvas;
  }



  Canvas drawScoreboard(Canvas canvas, Offset center, GamePlayState gamePlayState, int body, Size scoreboardSize,ColorPalette palette ) {

    // Paint scoreboardPaint = Paint()
    // ..color = const Color.fromARGB(52, 255, 255, 255);

    final double width = scoreboardSize.width;
    final double height = scoreboardSize.height;
    final double radius = scoreboardSize.width*0.05;
    final Rect scoreboardRect = Rect.fromCenter(center: center, width: width, height: height);
    final RRect scoreboardRRect = RRect.fromRectAndRadius(scoreboardRect, Radius.circular(radius));
    // TODO: MATCH TAP TILE ID FROM THE TURN TO THE ID TAPPED
    

    late int? actualTurn = null;
    if (gamePlayState.scoreSummary.isNotEmpty) {
      Map<String,dynamic> lastTurn = gamePlayState.scoreSummary.last;
      actualTurn = lastTurn["turn"];
    }


    Map<String,dynamic> scoreCountAnimation = gamePlayState.animationData.firstWhere((e)=>e["type"]=="score-count",orElse: ()=>{});
    Map<String,dynamic> scoreHighlightAnimation = gamePlayState.animationData.firstWhere((e)=>e["type"]=="score-highlight",orElse: ()=>{});

    // The score will update before the animation starts playing.
    // to prevent the new score to display before the animation starts counting
    // we need to first detect if a tap-up is linked to a found word.

    // look for a key who has two animations playing: tile-tap-up and pre-word-found
    List<int> multiAnimationKeys = getTapUpAndPreWordFoundKey(gamePlayState);
    Map<String,dynamic> lastScoredTurn = getLastTurnWithScore(gamePlayState);


    // if the scoreboard animation IS playing
    if (scoreHighlightAnimation.isNotEmpty) {
      
      
      // List<double> wave = scoreHighlightAnimation["animation"]["wave"];
      // print(colorWave);
      // int progressIndex = (scoreHighlightAnimation["progress"]*(wave.length-1)).round();
      // double waveFactor = wave[progressIndex] + 0.5; 
      final double progress = scoreHighlightAnimation["progress"];
      

      drawScoreHighlightAnimation(canvas,gamePlayState,center, body,progress, palette);

    }      
    
    // if the scoreboard animation IS playing
    else if (scoreCountAnimation.isNotEmpty) {
      
      int newBody = scoreCountAnimation["body"];
      int duration = scoreCountAnimation["duration"];
      double progress = scoreCountAnimation["progress"];
      // List<double> colorWave = scoreCountAnimation["animation"]["colorWave"];
      // print(colorWave);
      // int progressIndex = (scoreCountAnimation["progress"]*(colorWave.length-1)).round();
      // double val = colorWave.isNotEmpty ? colorWave[progressIndex] : 0.0; // TODO: CHANGE BACK
      // int hexCode = Helpers().convertLerpToHexCode("#FFA500", "#FFFF00",val);
      List<Map<String,dynamic>> colorSequence = AnimationUtils().getScoreboardOscillatingColorSequence(duration);
      // print(colorSequence);

      // int hexCode = progressIndex.isEven ? 0xFFFFA500 : 0xFFFFFF00;
      Color colorRes = StylingUtils().getColorLerp(colorSequence,progress);
      

      drawScoreCountAnimation(canvas,gamePlayState,center,newBody,colorRes);
      // }
    } 

    // if the scoreboard animation is NOT playing
    else {
      // find last turn where a point was scored 
      int? lastTurnKey  = lastScoredTurn.isEmpty ? null : lastScoredTurn["tileTapped"]["key"];
      // print("multiAnimationKeys ${multiAnimationKeys}|| lastTurnTileTapped: ${lastTurnKey}} ");
      if (multiAnimationKeys.isNotEmpty) {

        if (multiAnimationKeys.contains(lastTurnKey)) {
          int lastTurn = lastScoredTurn["turn"];
          int previousScore = Helpers().getPreviousScore(gamePlayState,lastTurn);
          drawPointsArea(canvas, gamePlayState,center,previousScore,palette);

        } else {

        }

      } else {
          drawPointsArea(canvas, gamePlayState,center, body,palette);
      }
    }    
    return canvas;
  }


  Canvas drawPointsArea(Canvas canvas, GamePlayState gamePlayState, Offset center, int body, ColorPalette palette) {


    Size scoreboardSize = gamePlayState.elementSizes["scoreboardAreaSize"];
    // Offset scoreboardCenter = gamePlayState.elementPositions["scoreboardCenter"];

    Paint pointsAreaPaint = Paint()
    ..color = palette.gameplayText1
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3.0 * gamePlayState.scalor
    ..strokeCap = StrokeCap.round;

    TextStyle textStyle = TextStyle(
      color:  palette.gameplayText1, //const Color.fromARGB(224, 176, 230, 255),
      fontSize: 22 * gamePlayState.scalor  // tileSize.width*0.4, 

    );
    TextSpan textSpan = TextSpan(
      text: body.toString(),
      style: textStyle,
    );

    final TextPainter textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();


    drawScoreboardElements(canvas,center,scoreboardSize,textPainter,pointsAreaPaint,gamePlayState.scalor);

    return canvas;
  }


  Canvas drawScoreCountAnimation(Canvas canvas, GamePlayState gamePlayState, Offset center, int body, Color color) {

    Size scoreboardSize = gamePlayState.elementSizes["scoreboardAreaSize"];
    // Offset scoreboardCenter = gamePlayState.elementPositions["scoreboardCenter"];

    Paint pointsAreaPaint = Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3.0 * gamePlayState.scalor
    ..strokeCap = StrokeCap.round;

    TextStyle textStyle = TextStyle(
      color: color,
      fontSize: 22 * gamePlayState.scalor //tileSize.width*0.4,
    );
    TextSpan textSpan = TextSpan(
      text: body.toString(),
      style: textStyle,
    );
 
    final TextPainter textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    drawScoreboardElements(canvas,center,scoreboardSize,textPainter,pointsAreaPaint,gamePlayState.scalor); 

    return canvas;
  }





  // List<Map<String,dynamic>> getScoreboardOscillatingColorSequence(int duration) {

  //   // 3 waves per second max. one wave every 300ms
  //   int waves = (duration/300).floor();

  //   Color yellow = const Color.fromARGB(255, 240, 227, 118);
  //   Color red = const Color.fromARGB(255, 253, 154, 147);

    
  //   double waveDuration = double.parse((1.0/(waves*2)).toStringAsFixed(2));
  //   double total = 0.0; 

  //   double total2 = (waveDuration *2) * waves;
  //   double gap = 1.0-(total2);

  //   List<Map<String,dynamic>> colorSequence = [];

  //   if (gap>0 ) {
  //     colorSequence = [
  //       {"source": yellow, "target": red, "duration": gap/2},
  //       {"source": red, "target": yellow, "duration": gap/2}
  //     ];
  //   }

  //   for (int i=0;i<waves;i++) {
  //     colorSequence.add({"source": yellow, "target": red, "duration": waveDuration});
  //     total = total+(waveDuration);
  //     colorSequence.add({"source": red, "target": yellow, "duration": waveDuration});
  //     total = total+(waveDuration);
  //   }

  //   return colorSequence;
  // }


  Canvas drawScoreHighlightAnimation(Canvas canvas, GamePlayState gamePlayState, Offset center, int body, double progress, ColorPalette palette) {

    Size scoreboardSize = gamePlayState.elementSizes["scoreboardAreaSize"];
    // Offset scoreboardCenter = gamePlayState.elementPositions["scoreboardCenter"];


    final double scoreboardHighlightProgress = AnimationUtils().getAcceleratedProgress(progress,1.0);

    Color colorRes = Colors.transparent;
    Color yellow = palette.scoreboardAnimationBorder1; // const Color.fromARGB(255, 240, 227, 118);
    Color red = palette.scoreboardAnimationBorder2; //const Color.fromARGB(255, 253, 154, 147);
    Color baseColor = palette.gameplayText1;const Color.fromARGB(153, 241, 241, 241);

    List<Map<String,dynamic>> colorSequence = [
      {"source": baseColor, "target": red, "duration": 0.15},
      {"source": red, "target": yellow, "duration": 0.15},
      {"source": yellow, "target": red, "duration": 0.2},
      {"source": red, "target": yellow, "duration": 0.2},
      {"source": yellow, "target": red, "duration": 0.15},
      {"source": red, "target": baseColor, "duration": 0.15},
    ];

    colorRes = StylingUtils().getColorLerp(colorSequence,progress);

    Paint pointsAreaPaint = Paint()
    ..color = colorRes
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3.0 * gamePlayState.scalor
    ..strokeCap = StrokeCap.round;


    Paint scoreboardHighlightPaint = Paint()
    ..color = baseColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3.0 * gamePlayState.scalor * (1.0-scoreboardHighlightProgress)
    ..strokeCap = StrokeCap.round;    
    

    TextStyle textStyle = TextStyle(
      color: colorRes,
      fontSize: 22 * gamePlayState.scalor // tileSize.width*0.4,
    );
    TextSpan textSpan = TextSpan(
      text: body.toString(),
      style: textStyle,
    );

    final TextPainter textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final double scoreboardRightEdgeX = center.dx + ((scoreboardSize.width/2) *0.95);
    // double textContainerRightEdgeX = center.dx + ((scoreboardSize.width/2) *0.90);
    double textContainerRightEdgeX = scoreboardRightEdgeX-10; 
    double textContainerLeftEdgeX = textContainerRightEdgeX-(textPainter.width*1.5);
    double textContainerCenterY = (center.dy-scoreboardSize.height/2)+((textPainter.height*1.5)/2);
    double textContainerCenterX = textContainerLeftEdgeX + ((textContainerRightEdgeX-textContainerLeftEdgeX)/2);
    Offset textContainerCenter = Offset(textContainerCenterX,textContainerCenterY);
    Offset textCenter = Offset(textContainerCenter.dx - (textPainter.width/2)+((textPainter.height*0.5)/2), textContainerCenterY - (textPainter.height/2));
    
    final double coinWidth = textPainter.height; //50.0;
    final double scoreboardWidth = (textPainter.width*1.5)+(coinWidth*1.5);
    
    final double scoreboardLeftEdgeX = scoreboardRightEdgeX-scoreboardWidth;
    final Offset coinCenter = Offset((scoreboardLeftEdgeX+((coinWidth*1.5)/2)) ,textContainerCenter.dy);


    final double scoreboardTopEdgeY = textContainerCenter.dy-((textPainter.height*1.5)/2);
    final double scoreboardBottomEdgeY = textContainerCenter.dy+((textPainter.height*1.5)/2);

    Offset scoreAreaCenter = Offset(scoreboardLeftEdgeX + scoreboardWidth/2.0,textContainerCenterY);
    final double scoreboardHighlightWidth = scoreboardWidth + (scoreboardWidth*0.2)*scoreboardHighlightProgress;
    final double scoreboardHighlightHeight = (textPainter.height*1.5) + ((textPainter.height*1.5*0.6)*scoreboardHighlightProgress);
    final Rect scoreAreaHighlightRect = Rect.fromCenter(center: scoreAreaCenter, width: scoreboardHighlightWidth, height: scoreboardHighlightHeight);
    final RRect scoreAreaHighlightRRect = RRect.fromRectAndRadius(scoreAreaHighlightRect, Radius.circular(8.0 * gamePlayState.scalor));
    canvas.drawRRect(scoreAreaHighlightRRect,scoreboardHighlightPaint);

    final Rect scoreboardRect = Rect.fromLTRB(scoreboardLeftEdgeX, scoreboardTopEdgeY, scoreboardRightEdgeX, scoreboardBottomEdgeY);
    final RRect scoreboardRRect = RRect.fromRectAndRadius(scoreboardRect,Radius.circular(8.0 * gamePlayState.scalor));
    
    
    drawPointsIcon(canvas,Size(coinWidth,coinWidth),coinCenter,);

    canvas.drawRRect(scoreboardRRect, pointsAreaPaint);
    textPainter.paint(canvas, textCenter);
    
    // drawScoreboardElements(canvas,scoreboardCenter,scoreboardSize,textPainter,pointsAreaPaint);

    return canvas;
  }

  Canvas drawScoreboardElements(Canvas canvas, Offset scoreboardCenter, Size scoreboardSize, TextPainter textPainter, Paint pointsAreaPaint, double scalor) {
    
    double updatedCenterY = (scoreboardCenter.dy-scoreboardSize.height/2)+((textPainter.height*1.5)/2);

    final double scoreboardRightEdgeX = scoreboardCenter.dx + ((scoreboardSize.width/2) *0.95);

    // double textContainerRightEdgeX = scoreboardCenter.dx + ((scoreboardSize.width/2) *0.90);
    double textContainerRightEdgeX = scoreboardRightEdgeX-10;
    double textContainerLeftEdgeX = textContainerRightEdgeX-(textPainter.width*1.5);
    double textContainerCenterX = textContainerLeftEdgeX + ((textContainerRightEdgeX-textContainerLeftEdgeX)/2);
    Offset textContainerCenter = Offset(textContainerCenterX,updatedCenterY);

    Offset textCenter = Offset((textContainerCenter.dx - (textPainter.width/2))+((textPainter.height*0.5)/2), textContainerCenter.dy - (textPainter.height/2));
    
    final double coinWidth = textPainter.height; //50.0;
    
    final double scoreboardWidth = (textPainter.width*1.5)+(coinWidth*1.5);
    

    final double scoreboardLeftEdgeX = scoreboardRightEdgeX-scoreboardWidth;

    final double scoreboardTopEdgeY = textContainerCenter.dy-((textPainter.height*1.5)/2);
    final double scoreboardBottomEdgeY = textContainerCenter.dy+((textPainter.height*1.5)/2);


    final Rect scoreboardRect = Rect.fromLTRB(scoreboardLeftEdgeX, scoreboardTopEdgeY, scoreboardRightEdgeX, scoreboardBottomEdgeY);
    final RRect scoreboardRRect = RRect.fromRectAndRadius(scoreboardRect,Radius.circular(8.0 * scalor));

    final Offset coinCenter = Offset((scoreboardLeftEdgeX+((coinWidth*1.5)/2)) ,textContainerCenter.dy);
    drawPointsIcon(canvas,Size(coinWidth,coinWidth),coinCenter,);
    canvas.drawRRect(scoreboardRRect, pointsAreaPaint);
    textPainter.paint(canvas, textCenter);     

    return canvas;    
  }


  List<int> getTapUpAndPreWordFoundKey(GamePlayState gamePlayState) {
    List<int> res = [];
    for (int i=0; i<gamePlayState.tileData.length; i++) {
      int key = gamePlayState.tileData[i]["key"];
      List<Map<String,dynamic>> multiAnimationKeys = gamePlayState.animationData.where((e)=>e["key"]==key).toList();
      if (multiAnimationKeys.length>1) {
        res.add(key);
      }
    }
    return res;
  }

  Map<String,dynamic> getLastTurnWithScore(GamePlayState gamePlayState) {
    Map<String,dynamic> lastScoreTurn = gamePlayState.scoreSummary.reversed.firstWhere((e)=>e["score"]>0,orElse:()=>{});
    return lastScoreTurn;
  }


  Canvas drawPlusNPointsAnimations(Canvas canvas, GamePlayState gamePlayState,Offset center, ColorPalette palette) {

    // List<Map<String,dynamic>> scorePointsAnimations = gamePlayState.animationData.where((e)=>e["type"]=="score-points").toList();
    Map<String,dynamic> scorePointsAnimation = gamePlayState.animationData.firstWhere((e)=>e["type"]=="score-points",orElse: ()=>{});
    if (scorePointsAnimation.isNotEmpty) {

      List<Map<String,dynamic>> scoreObjects = scorePointsAnimation["animation"];
      double progress = scorePointsAnimation["progress"];

      for (int i=0; i<scoreObjects.length; i++) {
        Map<String,dynamic> animationObject = scoreObjects[i];
        
        int points = animationObject["body"];
        double xOffset = animationObject["xOffset"];
        String body = "+$points";

        drawPlusNPointsAnimation(canvas,palette, gamePlayState,center,body,progress,xOffset, i, scoreObjects.length);
      }
    }


    return canvas;
  }

  Canvas drawPlusNPointsAnimation(Canvas canvas, ColorPalette palette, GamePlayState gamePlayState, Offset center, String body, double progress, double xOffset, int index, int countAnimations) {

    Size scoreboardSize = gamePlayState.elementSizes["scoreboardAreaSize"];
    // Offset scoreboardCenter = gamePlayState.elementPositions["scoreboardCenter"];
    Map<String,dynamic> animationDurations = gamePlayState.animationLengths.firstWhere((e)=>e["type"]=="score-points",orElse: ()=>{});
    int animationDuration = (animationDurations["stops"]*animationDurations["interval"]*countAnimations);

    // double opacityProgress = getPlusNPointsOpacity(progress);

    double adjustedProgress = AnimationUtils().getAdjustedProgress(index,countAnimations,progress,animationDuration);
    Color textColor = AnimationUtils().getPlusNPointsColor(adjustedProgress, palette);

    TextStyle textStyle = TextStyle(
      color: textColor, //Color.fromRGBO(255, 255, 255, opacityProgress),
      fontSize: 22 * gamePlayState.scalor //tileSize.width*0.4,
    );
    TextSpan textSpan = TextSpan(
      text: body.toString(),
      style: textStyle,
    );

    final TextPainter textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.rtl,
    );
    textPainter.layout();

    
    double positionX = (center.dx + (scoreboardSize.width*0.95)/4) + xOffset;
    double positionY = center.dy + scoreboardSize.height - (scoreboardSize.height*adjustedProgress);
    // final Offset position = Offset(positionX, positionY);

    double textPositionX = positionX - (textPainter.width/2);
    double textPositionY = positionY - (textPainter.height/2);
    final Offset textPosition = Offset(textPositionX, textPositionY);


    // canvas.drawRRect(plusNPointsRRect, plusNPointsContainerPaint);
    textPainter.paint(canvas, textPosition);  

    return canvas;
  }



  // Canvas drawPointsIcon(Canvas canvas, Offset position, double radius) {
    
  //   Color faceColor =const Color.fromARGB(255, 255, 223, 43);
  //   Color borderColor = const Color.fromARGB(204, 255, 188, 43);
  //   Color textColor = const Color.fromARGB(246, 172, 120, 8);

  //   Paint innerPaint = Paint()
  //   ..color = faceColor;

  //   Paint outerPaint = Paint()
  //   ..color = borderColor;

  //   TextStyle textStyle = TextStyle(
  //     color: textColor, //Color.fromRGBO(255, 255, 255, opacityProgress),
  //     fontSize: radius*1.2,
  //   );
  //   TextSpan textSpan = TextSpan(
  //     text: "\$",
  //     style: textStyle,
  //   );

  //   final TextPainter textPainter = TextPainter(
  //     text: textSpan,
  //     textDirection: TextDirection.rtl,
  //   );
  //   textPainter.layout();
  //   Offset textCenter = Offset(position.dx - (textPainter.width/2), position.dy - (textPainter.height/2));

  //   Offset pos2 = Offset(position.dx-2.0,position.dy);    

  //   canvas.drawCircle(pos2, radius, outerPaint);
  //   canvas.drawCircle(position, radius*0.9, innerPaint);
  //   textPainter.paint(canvas, textCenter);

  //   return canvas;
  // }

Canvas drawPointsIcon(Canvas canvas, Size size, Offset position) {
    
//     Offset center = Offset(size.width / 2, size.height / 2);
    
      final double ring1Radius = size.width*0.5*0.9;
      final double ring2Radius = size.width*0.5*0.7;
      final double cornerRadius = size.width*0.01;
      
      final int points = 5;

    Color faceColor =const Color.fromARGB(255, 255, 222, 75);
    Color borderColor = const Color.fromARGB(255, 216, 151, 11);
    // Color textColor = const Color.fromARGB(246, 172, 120, 8);      

      Paint paint1 = Paint()
        ..color = borderColor
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      
      Paint paint2 = Paint()
        ..color = faceColor; 
      
      canvas.drawCircle(position, ring1Radius, paint1);
      canvas.drawCircle(position, ring2Radius, paint2);
      
      
      final path = Path();
      final outerRadius = min(size.width, size.height) * 0.3;
      final innerRadius = outerRadius / 2.0;

      final angle = pi / points;
      final List<Offset> pointList = [];

      for (int i = 0; i < points * 2; i++) {
        final isOuter = i % 2 == 0;
        final r = isOuter ? outerRadius : innerRadius;
        final a = i * angle - pi / 2;
        pointList.add(Offset(
          position.dx + r * cos(a),
          position.dy + r * sin(a),
        ));
      }

      for (int i = 0; i < pointList.length; i++) {
        final current = pointList[i];
        final next = pointList[(i + 1) % pointList.length];
        final prev = pointList[(i - 1 + pointList.length) % pointList.length];

        final from = Offset.lerp(current, prev, cornerRadius / (current - prev).distance)!;
        final to = Offset.lerp(current, next, cornerRadius / (current - next).distance)!;

        if (i == 0) {
          path.moveTo(from.dx, from.dy);
        } else {
          path.quadraticBezierTo(current.dx, current.dy, from.dx, from.dy);
        }

        path.lineTo(to.dx, to.dy);
      }


      path.close();
      canvas.drawPath(path, paint1);
      return canvas;
  }  

  // double getPlusNPointsOpacity(double progress) {
  //   double res = progress * 2;
  //   if (progress >= 0.5 ) {
  //     res = (1-progress) * 2;
  //   }
  //   return res;
  // }

  // double getAcceleratedProgress(double progress, double accelerator,) {
  //   double res = progress*accelerator;
  //   double limit = 1.0/accelerator;

  //   if (progress < limit) {
  //     res = progress*accelerator;
  //   } else {
  //     res = 0.0;
  //   }
  //   return res;
  // }

  // Color getPlusNPointsColor(double progress, ColorPalette palette) {
  //   Color res = Colors.transparent;
  //   Color baseColor = palette.text1; // Colors.white;
  //   Color yellow = palette.scoreboardAnimationBorder1; //const Color.fromARGB(255, 240, 227, 118);
  //   Color red = palette.scoreboardAnimationBorder2; //const Color.fromARGB(255, 253, 154, 147);

  //   List<Map<String,dynamic>> data = [
  //     {"source": Colors.transparent, "target": baseColor, "duration": 0.15},
  //     {"source": baseColor, "target": yellow, "duration": 0.15},
  //     {"source": yellow, "target": red, "duration": 0.2},
  //     {"source": red, "target": yellow, "duration": 0.2},
  //     {"source": yellow, "target": baseColor, "duration": 0.15},
  //     {"source": baseColor, "target": Colors.transparent, "duration": 0.15},
  //   ];

  //   res = StylingUtils().getColorLerp(data,progress);
  //   return res;
  // }


  // double getAdjustedProgress(int index, int countAnimations, double progress, int durationMs) {
  //   double res = 0.0;
  //   double animDuration = durationMs/countAnimations; //double.parse((durationMs/countAnimations).toStringAsFixed(2));
  //   double durationAdjustment = (animDuration + (countAnimations-1) * (animDuration/2))/durationMs;
  //   double adjustedTotalDuration = durationMs * durationAdjustment; //double.parse((durationMs * durationAdjustment).toStringAsFixed(2));
  //   double adjustedAllocation = animDuration/adjustedTotalDuration; //double.parse((animDuration/adjustedTotalDuration).toStringAsFixed(2));
  //   // double startRatio = ((index * animDuration)/adjustedTotalDuration);
  //   // double startAllocation = (startRatio) - ( startRatio*adjustedAllocation );
  //   double startAllocation = index * (adjustedAllocation/2);
  //   double endAllocation = startAllocation + adjustedAllocation;



  //   if (progress >= startAllocation && progress < endAllocation) {
  //     res = double.parse(((progress-startAllocation)/adjustedAllocation).toStringAsFixed(2));
  //   } else if (progress >= endAllocation) {
  //     res = 1.0;
  //   }    

  //   return res;
  // }







}