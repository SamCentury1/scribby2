import 'dart:ui' as ui;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:scribby_flutter_v2/functions/animation_utils.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/painters/stop_watch_painters.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/painters/tile_painters.dart';

class TutorialPainters {

  Canvas paintTutorialPainters(Canvas canvas, GamePlayState gamePlayState, ColorPalette palette) {
    paintTargetTile(canvas,gamePlayState);
    paintTutorialCountdown(canvas,gamePlayState,palette);
    paintDottedLineIndicator(canvas,gamePlayState);
    animateTutorialMessage(canvas,gamePlayState);
    paintTutorialEndScreen(canvas,gamePlayState);
    displayStepMessage(canvas,gamePlayState);

    // displayTutorialMessage(canvas,gamePlayState);
    
    return canvas;
  }


  Canvas paintTargetTile(Canvas canvas, GamePlayState gamePlayState) {
    Size tileSize = gamePlayState.elementSizes["tileSize"];
    int currentTurn = gamePlayState.tutorialData["currentTurn"];
    List<Map<String,dynamic>> steps = gamePlayState.tutorialData["steps"];
    Map<String,dynamic> step = steps.firstWhere((e)=>e["step"]==currentTurn,orElse: ()=>{});
    if (step.isNotEmpty) {
      int? targetKey = step["focusTile"];
      String elementType=step["type"];
      String moveType=step["moveType"];
      String? targetOption=step["perk"];

    
      Map<String,dynamic> targetTile = {};
      
      targetTile = gamePlayState.reserveTileData.firstWhere((e)=>e["key"]==targetKey,orElse: ()=>{});
      if (targetTile.isEmpty) {
        targetTile = gamePlayState.tileData.firstWhere((e)=>e["key"]==targetKey,orElse: ()=>{});
      }

      if (targetTile.isNotEmpty) {
        Offset tileCenter = targetTile["center"];

        // print("TUTORIAL TESTING OPEN MENU STUFF ${targetTile["menuOpen"]}");
        // print("target tile => $targetTile");
        if (targetTile["type"]=="board") {
          if (targetTile["menuOpen"]) {

            if (targetOption != null) {
              List<Map<String,dynamic>> perkMenu = targetTile["menuData"]; 
              Map<String,dynamic> targetPerk = perkMenu.firstWhere((e)=>e["option"]==targetOption, orElse: ()=>{});
              Offset perkCenter =  targetPerk["center"];

              if (shouldGlow(gamePlayState)) {
                late double opacity = AnimationUtils().getHighlightEffectShadowOpacity(gamePlayState,targetKey!);
                TilePainters().drawTileShadow(canvas,ui.Color.fromRGBO(255, 255, 255, opacity),ui.Color.fromRGBO(227, 210, 253, opacity),tileSize*1.1,perkCenter);        
              }
            }
          } else {
            if (shouldGlow(gamePlayState)) {
              late double opacity = AnimationUtils().getHighlightEffectShadowOpacity(gamePlayState,targetKey!);
              TilePainters().drawTileShadow(canvas,ui.Color.fromRGBO(255, 255, 255, opacity),ui.Color.fromRGBO(227, 210, 253, opacity),tileSize*1.1,tileCenter);
            }
          }
        } else {
          if (shouldGlow(gamePlayState)) {
            late double opacity = AnimationUtils().getHighlightEffectShadowOpacity(gamePlayState,targetKey!);
            TilePainters().drawTileShadow(canvas,ui.Color.fromRGBO(255, 255, 255, opacity),ui.Color.fromRGBO(227, 210, 253, opacity),tileSize,tileCenter);        
          }
        }


      }

      if (moveType=="drag") {

        int dragTargetKey = step["targetKey"];
        Map<String,dynamic> dragTargetTile = {};

        // if (elementType=="reserve") {
          dragTargetTile = gamePlayState.reserveTileData.firstWhere((e)=>e["key"]==dragTargetKey,orElse: ()=>{});
        // } else {
        if (dragTargetTile.isEmpty) {
          dragTargetTile = gamePlayState.tileData.firstWhere((e)=>e["key"]==dragTargetKey,orElse: ()=>{});
        }
        // }
        if (dragTargetTile.isNotEmpty) {
          Offset tileCenter = dragTargetTile["center"];
          if (shouldGlow(gamePlayState)) {
            late double opacity = AnimationUtils().getHighlightEffectShadowOpacity(gamePlayState,dragTargetKey);
            TilePainters().drawTileShadow(canvas,ui.Color.fromRGBO(255, 255, 255, opacity),ui.Color.fromRGBO(227, 210, 253, opacity),tileSize*1.1,tileCenter);
          }
        }      
      }
    }     


    return canvas;
  }


  bool shouldGlow(GamePlayState gamePlayState) {
    late bool res = false;
    if (gamePlayState.highlightEffectTimer.isActive) {
      List<String> forbiddenAnimations = ["tile-freeze","tile-swap","tile-explode"];
      List<Map<String,dynamic>> noGlowAnimations = gamePlayState.animationData.where((e)=>forbiddenAnimations.contains(e["type"])).toList();
      if (noGlowAnimations.isEmpty) {
        res = true;
      }
    }
    return res;
  }

  Canvas paintDottedLineIndicator(Canvas canvas, GamePlayState gamePlayState) {

    if (gamePlayState.isTutorial) {

      int currentStep = gamePlayState.tutorialData["currentTurn"];
      List<Map<String,dynamic>> tutorialSteps = gamePlayState.tutorialData["steps"];
      Map<String,dynamic> dragStep = tutorialSteps.firstWhere((e)=>e["moveType"]=="drag",orElse: ()=>{}); // firstWhere((e)=> e["moveType"]=="drag", orElse: ()=>{} );
      if (dragStep.isNotEmpty) {
        if (currentStep == dragStep["step"]) {
          final int reserveTileKey = dragStep["focusTile"];
          final int boardTileKey = dragStep["targetKey"];

          final Map<String,dynamic> reserveTile = gamePlayState.reserveTileData.firstWhere((e)=>e["key"]==reserveTileKey, orElse: ()=>{});
          final Map<String,dynamic> boardTile = gamePlayState.tileData.firstWhere((e)=>e["key"]==boardTileKey, orElse: ()=>{});


          if (reserveTile.isNotEmpty && boardTile.isNotEmpty) {

         
            final Offset reserveTileCenter = reserveTile["center"];
            final Offset boardTileCenter = boardTile["center"];


            final int stops = 30;
            final double dotSpacing = 1.0 / stops;



            
            for (int i = 5; i < stops-2; i++) {

              double opacity = AnimationUtils().getHighlightEffectShadowOpacity(gamePlayState,i);

              Paint linePaint = Paint()
              ..color = ui.Color.fromRGBO(255, 255, 255, 1*opacity)
              ..strokeCap = StrokeCap.round
              ..style = PaintingStyle.stroke
              ..strokeWidth = 3.0;              
              double t1 = i * dotSpacing;
              double t2 = (i + 1) * dotSpacing;
              // Interpolate between start and end
              Offset p1 = Offset.lerp(reserveTileCenter, boardTileCenter, t1)!;
              Offset p2 = Offset.lerp(reserveTileCenter, boardTileCenter, t2)!;

              if (i % 2 == 1) {
                if (shouldGlow(gamePlayState)) {
                  canvas.drawLine(p1, p2, linePaint);
                }
              }
            }   
          }
        }
      }
    }

    return canvas;
  }
}


Canvas displayTutorialText(Canvas canvas,double scalor, String content, Offset bonusCenter, double progress) {

  final double opacity = progress;
  TextStyle textStyle = TextStyle(
    color: ui.Color.fromRGBO(247, 247, 247, opacity),
    fontSize: 22* scalor,
    shadows: [
      Shadow(color: ui.Color.fromRGBO(0, 0, 0, opacity),offset: Offset.zero,blurRadius: 10.0,)
    ]
  );
  TextSpan textSpan = TextSpan(
    text: content,
    style: textStyle,
  );
  final textPainter = TextPainter(
    text: textSpan,
    textDirection: TextDirection.ltr,
  );
  textPainter.layout(
    maxWidth: 200
  );

  final position = Offset(bonusCenter.dx - (textPainter.width/2), bonusCenter.dy - (textPainter.height/2));
  textPainter.paint(canvas, position);

  return canvas;    
}

Canvas displayStepMessage(Canvas canvas, GamePlayState gamePlayState) {
  if (gamePlayState.isTutorial) {

    int turn = gamePlayState.tutorialData["currentTurn"];
    List<Map<String,dynamic>> steps = gamePlayState.tutorialData["steps"];
    Map<String,dynamic> step = steps.firstWhere((e)=>e["step"]==turn, orElse: ()=>{});

    Offset bonusCenter  = gamePlayState.elementPositions["bonusCenter"];

    String animationType = "tutorial-message-fade";
    List<Map<String,dynamic>> tutorialFadeAnimations = gamePlayState.animationData.where((e)=>e["type"]==animationType).toList();
    // print(step);

    if (step.isNotEmpty && tutorialFadeAnimations.isEmpty) {

      String content = step["message"];

      displayTutorialText(canvas,gamePlayState.scalor,content,bonusCenter,1.0);

    }

  }
  return canvas;
}

Canvas animateTutorialMessage(Canvas canvas,GamePlayState gamePlayState) {

  if (gamePlayState.isTutorial) {

    int turn = gamePlayState.tutorialData["currentTurn"];
    List<Map<String,dynamic>> steps = gamePlayState.tutorialData["steps"];

    Map<String,dynamic> step = steps.firstWhere((e)=>e["step"]==turn, orElse: ()=>{});
    Map<String,dynamic> previousStep = steps.firstWhere((e)=>e["step"]==turn-1, orElse: ()=>{});

    Offset currentContentCenter  = gamePlayState.elementPositions["bonusCenter"];

    // print(step);

    if (step.isNotEmpty) {

      

      String content = step["message"];
      

      String animationType = "tutorial-message-fade";
      List<Map<String,dynamic>> tutorialFadeAnimations = gamePlayState.animationData.where((e)=>e["type"]==animationType).toList();

      for (int i=0; i<tutorialFadeAnimations.length; i++) {

        late Map<String,dynamic> tutorialFadeAnimation = tutorialFadeAnimations[i]; 
        late double animationProgress = tutorialFadeAnimation["progress"];

        late double updatedY = currentContentCenter.dy + (100.0 * (1.0 - animationProgress));
        late Offset updatedContentCenter = Offset(currentContentCenter.dx,updatedY);
        

        displayTutorialText(canvas,gamePlayState.scalor,content,updatedContentCenter,animationProgress);

        if (previousStep.isNotEmpty) {

          late double previousY = currentContentCenter.dy - (100.0 * animationProgress); 
          late Offset updatedPreviousContentCenter = Offset(currentContentCenter.dx,previousY);         
          late double previousContentProgress = 1.0 - animationProgress;
          String previousContent = previousStep["message"];
          displayTutorialText(canvas,gamePlayState.scalor,previousContent,updatedPreviousContentCenter,previousContentProgress);
        }

      }
    }
  }

  return canvas;
}

Canvas paintTutorialEndScreen(Canvas canvas, GamePlayState gamePlayState) {
  int turn = gamePlayState.tutorialData["currentTurn"];
  Size screenSize = gamePlayState.elementSizes["screenSize"];
  Offset screenCenter = gamePlayState.elementPositions["screenCenter"];
  List<Map<String,dynamic>> steps = gamePlayState.tutorialData["steps"];
  Map<String,dynamic> nextStep = steps.firstWhere((e)=>e["step"]==turn,orElse:()=>{});
  if (nextStep.isNotEmpty) {
    if (nextStep["moveType"]=="finish") {
      Rect rect = Rect.fromCenter(center: screenCenter, width: screenSize.width, height: screenSize.height);
      Paint paint = Paint()
      ..color = const ui.Color.fromARGB(164, 0, 0, 0);
      canvas.drawRect(rect, paint);
    }
  }
  return canvas;
}

Canvas paintTutorialCountdown(Canvas canvas, GamePlayState gamePlayState, ColorPalette palette) {
  StopWatchPainters().drawStopWatch(canvas, gamePlayState,palette);
  return canvas;
}