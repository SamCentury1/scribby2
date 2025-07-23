import 'dart:ui' as ui; 
import 'dart:ui'; 

import 'package:flutter/material.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';

class StopWatchPainters {


  Canvas drawStopWatch(Canvas canvas, GamePlayState gamePlayState, ColorPalette palette) {

    late bool shouldShowStopWatch = Helpers().shouldShowCountdown(gamePlayState);

    if (shouldShowStopWatch) {      
      Map<String,dynamic> restartTimerAnimation = gamePlayState.animationData.firstWhere(
        (e) => e["type"]=="stopwatch-rewind",
        orElse: () => {} 
      );

      Size elementSize = gamePlayState.elementSizes["tileSize"]*1.125;
      final double boardWidth = gamePlayState.elementSizes["tileSize"].width * gamePlayState.gameParameters["rows"]; // Helpers().getNumAxis(gamePlayState.tileData)[0];
      final double locationX =  ((gamePlayState.elementSizes["screenSize"].width-boardWidth)/2) + (elementSize.width/2) +(elementSize.width/4);
      final double locationY = gamePlayState.elementPositions["randomLettersCenter"].dy;
      final Offset location = Offset(locationX, locationY);

      // get the progress of the ring
      late double progress = 0.0;
      late double sizeFactorValue = 0.0;
      late double progressAngle = 0.0;

      if (gamePlayState.stopWatchLimit != 0) {
        progress = gamePlayState.stopWatchDuration.inMilliseconds/gamePlayState.stopWatchLimit;
        progressAngle = 360.0 * (1-(progress));

        int frequency = (gamePlayState.stopWatchLimit/1000).round();
        int fps = 60;
        int totalPoints = fps * frequency;
        double waveValue = Helpers().getWaveValue(totalPoints, progress, 0.5, (frequency*1.0), -2.0, 1.0);
        sizeFactorValue = double.parse((waveValue + 0.5).toStringAsFixed(4));


        if (restartTimerAnimation.isNotEmpty) {
          double restartAnimationProgress = restartTimerAnimation["progress"];
          progressAngle = (360.0 * (1-(progress))) * (1-restartAnimationProgress);
        }      

        // if (tileDropAnimation.isNotEmpty) {
        //   double tileDropAnimationProgress = tileDropAnimation["progress"];
        //   progressAngle = (360.0 * (1-(progress))) * (1-tileDropAnimationProgress);
        // }      


      }

      

      // initialize the base for the rings
      double ringWidth = elementSize.width;
      double ringHeight = elementSize.height;    
      Rect ringRect = Rect.fromCenter(center: location, width: ringWidth, height: ringHeight);
      // get the angles for the ring base;
      final double baseStartAngle = Helpers().toRadians(270.0);
      final double baseStartSweep = Helpers().toRadians(360.0);

      // draw the shadow behind the base;
      Paint ringBaseShadowPaint = Paint()
      ..color = const ui.Color.fromARGB(255, 255, 129, 129)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = elementSize.width*0.1 
      ..maskFilter = MaskFilter.blur(BlurStyle.outer, 12.0*(sizeFactorValue));
      
      Path arcPath = Path();
      arcPath.moveTo(location.dx, location.dy-(elementSize.width/2));
      arcPath.addArc(ringRect, baseStartAngle, baseStartSweep);
      if (gamePlayState.stopWatchDuration.inMilliseconds < 3000) {
        canvas.drawPath(arcPath, ringBaseShadowPaint);    
      }    
      

      // get the paint of the ring background
      Paint ringBasePaint = Paint()
      ..color = palette.widgetParticulars1 //const Color.fromARGB(255, 8, 10, 126)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = elementSize.width*0.1;
      
      // draw the ring base
      canvas.drawArc(ringRect, baseStartAngle, baseStartSweep, false, ringBasePaint);


      // get the paint of the timer progress
      Offset offset1 = Offset(location.dx-elementSize.width,location.dy-elementSize.height);
      Offset offset2 = Offset(location.dx+elementSize.width,location.dy+elementSize.height);
      Paint ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = elementSize.width*0.08
      ..shader = ui.Gradient.linear(
        offset1,
        offset2,
        [
          palette.widgetParticulars2,
          Color.lerp(palette.widgetParticulars2, Colors.white, 0.5)??palette.widgetParticulars2
          // const ui.Color.fromARGB(255, 205, 231, 255),
          // const ui.Color.fromARGB(255, 119, 125, 179)
        ],
      );    

      // get the angle of the timer progress;
      final double progressStartAngle = Helpers().toRadians(270.0);
      final double progressSweepAngle = Helpers().toRadians(progressAngle);// 135 degrees;
      // paint the ring progress
      canvas.drawArc(ringRect, progressStartAngle, progressSweepAngle, false, ringPaint);


      TextStyle textStyle = TextStyle(
        color: palette.text1, //ui.Color.fromARGB(255, 231, 234, 236), //const Color.fromARGB(190, 123, 191, 255),
        fontSize: (elementSize.width*0.6) * (sizeFactorValue),
        shadows: <Shadow>[
          Shadow(color: const ui.Color.fromARGB(255, 255, 242, 242), offset: Offset.zero, blurRadius: 10.0*(sizeFactorValue)),
          Shadow(color: const ui.Color.fromARGB(255, 255, 180, 180), offset: Offset.zero, blurRadius: 15.0*(sizeFactorValue))
        ]
      );
      TextSpan textSpan = TextSpan(
        text: (gamePlayState.stopWatchDuration.inSeconds+1).toString(),
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      final position = Offset(location.dx - (textPainter.width/2), location.dy - (textPainter.height/2));

      if (gamePlayState.stopWatchDuration.inMilliseconds < 3000) {
        textPainter.paint(canvas, position);    
      }
      return canvas;
    }
    return canvas;
  }
}
