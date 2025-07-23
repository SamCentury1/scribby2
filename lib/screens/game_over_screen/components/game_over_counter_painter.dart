import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/components/loading_image.dart';
import 'package:scribby_flutter_v2/functions/animation_utils.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/functions/styling_utils.dart';
import 'package:scribby_flutter_v2/providers/ad_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';



class GameOverCounter extends StatefulWidget {
  final SettingsController settings; 
  const GameOverCounter({super.key,required this.settings});

  @override
  State<GameOverCounter> createState() => _GameOverCounterState();
}

class _GameOverCounterState extends State<GameOverCounter> {



  @override
  Widget build(BuildContext context) {
    return Consumer<AdState>(
      builder: (context,adState,child) {
        if (adState.isInterstitialAdLoading) {
          return Center(child: CircularProgressIndicator(),);

        } else {
          return Consumer<GamePlayState>(
            builder: (context,gamePlayState,child) {

              final double scalor = Helpers().getScalor(widget.settings);


              late Map<String,dynamic> scoreboardAnimationObject = gamePlayState.animationData.firstWhere(
                (e)=>e["key"]=="game-over-count",
                orElse: () => {}
              );
              late int scoreBody = 0;
              late double progress = 0.0;
              late int animationDuration = 0;
              late double highlightAnimationProgress1 = 0.0;
              late double highlightAnimationProgress2 = 0.0;                   

              if (scoreboardAnimationObject.isNotEmpty) {

                scoreBody = scoreboardAnimationObject["scoreBody"];
                progress = scoreboardAnimationObject["progress"];
                animationDuration = scoreboardAnimationObject["duration"];
                highlightAnimationProgress1 = scoreboardAnimationObject["highlight1"];
                highlightAnimationProgress2 = scoreboardAnimationObject["highlight2"];

              } else {
                progress = 1.0;
              }
         
              return Center(
                child: Container(
                  child: CustomPaint(
                    painter: GameOverCounterPainter(
                      gamePlayState: gamePlayState, 
                      // settingsState: settingsState
                      body:scoreBody.toString(),
                      progress: progress,
                      duration: animationDuration,
                      highlightProgress1: highlightAnimationProgress1,
                      highlightProgress2: highlightAnimationProgress2,
                      scalor: scalor
                    ),
                  ),
                ),
              );
            }
          );
        }
      }
    );
  }
}

class GameOverCounterPainter extends CustomPainter {
  final GamePlayState gamePlayState;
  // final SettingsState settingsState;
  final String body;
  final double progress;
  final int duration;
  final double highlightProgress1;
  final double highlightProgress2;
  final double scalor;

  const GameOverCounterPainter({
    required this.gamePlayState,
    // required this.settingsState,
    required this.body,
    required this.progress,
    required this.duration,
    required this.highlightProgress1,
    required this.highlightProgress2,
    required this.scalor,
  });

  @override
  void paint(Canvas canvas, Size size) {


    // print("progress: $progress || duration: $duration");

    // Size tileSize = gamePlayState.elementSizes["tileSize"];

      List<Map<String,dynamic>> colorSequence = AnimationUtils().getScoreboardOscillatingColorSequence(duration);
      // print(colorSequence);

      // int hexCode = progressIndex.isEven ? 0xFFFFA500 : 0xFFFFFF00;
      Color colorRes = StylingUtils().getColorLerp(colorSequence,progress);    

    Paint containerPaint = Paint()
    ..color = progress < 1.0 ? colorRes : Color.fromARGB(166, 230, 230, 230)
    ..style = PaintingStyle.stroke
    ..strokeJoin = StrokeJoin.round
    ..strokeWidth = 6*scalor;

    Offset center = Offset(size.width/2,size.height/2);

    // Digits
    TextStyle textStyle = GoogleFonts.tektur(
        color: progress < 1.0 ? colorRes : Color.fromARGB(166, 230, 230, 230),
        fontSize: 66*scalor,
        fontWeight: FontWeight.w400,
    );
    TextSpan textSpan = TextSpan(
      text: body,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final position = Offset(center.dx - (textPainter.width/2), center.dy - (textPainter.height/2)-(10*scalor));
    textPainter.paint(canvas, position);







    // "Score"
    TextStyle labelTextStyle = GoogleFonts.tektur(
        color: Color.fromARGB(255, 220, 220, 223),
        fontSize: 24*scalor,
        fontWeight: FontWeight.w400,
    );
    TextSpan labelTextSpan = TextSpan(
      text: "Score",
      style: labelTextStyle,
    );
    final labelTextPainter = TextPainter(
      text: labelTextSpan,
      textDirection: TextDirection.ltr,
    );
    labelTextPainter.layout();
    final labelPosition = Offset(center.dx - (labelTextPainter.width/2), center.dy - (labelTextPainter.height/2) - textPainter.height*0.65);
    labelTextPainter.paint(canvas, labelPosition);

    Path containerPath = getContainerPath(center,labelTextPainter, textPainter, 0.0);
    Path highlight1Path = getContainerPath(center,labelTextPainter, textPainter, highlightProgress1);
    Path highlight2Path = getContainerPath(center,labelTextPainter, textPainter, highlightProgress2);


    canvas.drawPath(containerPath, containerPaint);

    Paint hightlightPaint1 = Paint()
    ..color = Color.fromRGBO(230, 230, 230, 0.651 * (1-highlightProgress1))
    ..style = PaintingStyle.stroke
    ..strokeJoin = StrokeJoin.round
    ..strokeWidth = 12*scalor*(1-highlightProgress1);    

    if (highlightProgress1 < 1.0 && highlightProgress1 > 0.0) {
      canvas.drawPath(highlight1Path, hightlightPaint1);
    }

    Paint hightlightPaint2 = Paint()
    ..color = Color.fromRGBO(230, 230, 230, 0.651 * (1-highlightProgress2))
    ..style = PaintingStyle.stroke
    ..strokeJoin = StrokeJoin.round
    ..strokeWidth = 12*scalor*(1-highlightProgress2);       
    if (highlightProgress2 < 1.0 && highlightProgress2 > 0.0) {
      canvas.drawPath(highlight2Path, hightlightPaint2);
    }

  }

  @override
  bool shouldRepaint(covariant GameOverCounterPainter oldDelegate) => true;
}


double getContainerLeftX(Offset center, TextPainter labelPainter, TextPainter scorePainter) {
  double res = 0.0;
  double labelLeft = center.dx - labelPainter.width/2 - (labelPainter.width*0.15);
  double containerLeftX = center.dx - scorePainter.width/2 - (scorePainter.width*0.2);
  // double smallerX = min(labelLeft,containerLeftX); 
  // res = 
  if ((labelLeft - labelPainter.width*0.15) < containerLeftX) {
    res = labelLeft - labelPainter.width*0.15;
  } else {
    res = containerLeftX;
  }
  return res;
}
double getContainerRightX(Offset center, TextPainter labelPainter, TextPainter scorePainter) {
  double res = 0.0;
  double labelRight = center.dx + labelPainter.width/2 + (labelPainter.width*0.15);
  double containerRightX = center.dx + scorePainter.width/2 + (scorePainter.width*0.2);
  // double biggerX = max(labelRight,containerRightX); 
  // res = 
  if ((labelRight + labelPainter.width*0.15) > containerRightX) {
    res = labelRight + labelPainter.width*0.15;
  } else {
    res = containerRightX;
  }
  return res;
}


Path getContainerPath(Offset center, TextPainter labelPainter, TextPainter scorePainter, double progress) {
  // double prog = 1.0;
  double containerTopY = center.dy - (labelPainter.height/2) - scorePainter.height*0.45  - (30 * progress );
  double containerBottomY = center.dy + (labelPainter.height/2) + scorePainter.height*0.25 + (30 * progress );

  double containerLeftX = getContainerLeftX(center,labelPainter,scorePainter) - 30 * progress;
  double containerRightX = getContainerRightX(center,labelPainter,scorePainter) + 30 * progress;

  double step = labelPainter.width*0.08;

  // 1
  Offset labelLeftOffset = Offset(center.dx - labelPainter.width/2 - (labelPainter.width*0.15) , containerTopY);

  // 2
  Offset containerTopLeftCorner = Offset(containerLeftX,containerTopY);

  // 3 
  Offset containerBottomLeftCorner = Offset(containerLeftX,containerBottomY);

  // 4
  Offset containerBottomRightCorner = Offset(containerRightX,containerBottomY);

  // 5
  Offset containerTopRightCorner = Offset(containerRightX,containerTopY);

  // 6
  Offset labelRightOffset = Offset(center.dx + labelPainter.width/2 + (labelPainter.width*0.15) , containerTopY);

  Path res = Path();
  res.moveTo(labelLeftOffset.dx, labelLeftOffset.dy);
  res.lineTo(containerTopLeftCorner.dx+step, containerTopLeftCorner.dy);
  res.quadraticBezierTo(
    containerTopLeftCorner.dx, containerTopLeftCorner.dy, 
    containerTopLeftCorner.dx, containerTopLeftCorner.dy+step,
  );

  res.lineTo(containerBottomLeftCorner.dx, containerBottomLeftCorner.dy-step);
  res.quadraticBezierTo(
    containerBottomLeftCorner.dx, containerBottomLeftCorner.dy, 
    containerBottomLeftCorner.dx + step, containerBottomLeftCorner.dy
  );

  res.lineTo(containerBottomRightCorner.dx-step, containerBottomRightCorner.dy);

  res.quadraticBezierTo(
    containerBottomRightCorner.dx, containerBottomRightCorner.dy,
    containerBottomRightCorner.dx, containerBottomRightCorner.dy-step
  );

  res.lineTo(containerTopRightCorner.dx, containerTopRightCorner.dy+step);

  res.quadraticBezierTo(
    containerTopRightCorner.dx, containerTopRightCorner.dy,
    containerTopRightCorner.dx-step, containerTopRightCorner.dy
  );
  
  res.lineTo(labelRightOffset.dx, labelRightOffset.dy);

  
  return res;
}