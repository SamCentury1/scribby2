import 'dart:ui' as ui;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scribby_flutter_v2/functions/animation_utils.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/painters/stop_watch_painters.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/painters/tile_painters.dart';

class TutorialPainters {

  Canvas paintTutorialPainters(Canvas canvas, GamePlayState gamePlayState, ColorPalette palette) {
    paintTargetTile(canvas,gamePlayState,palette);
    paintTutorialCountdown(canvas,gamePlayState,palette);
    paintDottedLineIndicator(canvas,gamePlayState,palette);
    animateTutorialMessage(canvas,gamePlayState,palette);
    paintTutorialEndScreen(canvas,gamePlayState);
    displayStepMessage(canvas,gamePlayState,palette);

    // displayTutorialMessage(canvas,gamePlayState);
    
    return canvas;
  }


  Canvas paintTargetTile(Canvas canvas, GamePlayState gamePlayState, ColorPalette palette) {
    Size tileSize = gamePlayState.elementSizes["tileSize"];
    int currentTurn = gamePlayState.tutorialData["currentTurn"];
    List<Map<String,dynamic>> steps = gamePlayState.tutorialData["steps"];
    Map<String,dynamic> step = steps.firstWhere((e)=>e["step"]==currentTurn,orElse: ()=>{});
    if (step.isNotEmpty) {
      
      int? targetKey = step["focusTile"];
      String elementType=step["type"];
      String moveType=step["moveType"];
      String? targetOption=step["perk"];

      int textColorRed = (palette.text1.r*255).round();
      int textColorGreen = (palette.text1.g*255).round();
      int textColorBlue = (palette.text1.b*255).round();

      int highlightColorRed = (palette.highlightColor.r*255).round();
      int highlightColorGreen = (palette.highlightColor.g*255).round();
      int highlightColorBlue = (palette.highlightColor.b*255).round();      

    
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
          
          if (step["perk"]!=null) {
            Map<String,dynamic> focusPerk = gamePlayState.tileMenuOptions.firstWhere((e)=>e["item"]==step["perk"],orElse: ()=>{});
            
            if (focusPerk.isNotEmpty) {
              Offset perkCenter = focusPerk["center"];
              
              
              if (shouldGlow(gamePlayState)) {
                late double opacity = AnimationUtils().getHighlightEffectShadowOpacity(gamePlayState,targetKey!);
                Color textColor = ui.Color.fromRGBO(textColorRed, textColorGreen, textColorBlue, opacity);
                Color highlightColor = ui.Color.fromRGBO(highlightColorRed, highlightColorGreen, highlightColorBlue, opacity);
                if (focusPerk["open"]) {
                  TilePainters().drawTileShadow(canvas,textColor,highlightColor,tileSize*1.1,tileCenter);        
                } else {
                  TilePainters().drawTileShadow(canvas,textColor,highlightColor,tileSize*0.9,perkCenter); 
                }
              }            
            }

            // print(gamePlayState.tileMenuOptions);
          } else {
            if (shouldGlow(gamePlayState)) {
              late double opacity = AnimationUtils().getHighlightEffectShadowOpacity(gamePlayState,targetKey!);
              Color textColor = ui.Color.fromRGBO(textColorRed, textColorGreen, textColorBlue, opacity);
              Color highlightColor = ui.Color.fromRGBO(highlightColorRed, highlightColorGreen, highlightColorBlue, opacity);              
              TilePainters().drawTileShadow(canvas,textColor,highlightColor,tileSize*1.1,tileCenter);
            }
          }
          // if (targetTile["menuOpen"]) {

          //   if (targetOption != null) {
          //     List<Map<String,dynamic>> perkMenu = targetTile["menuData"]; 
          //     Map<String,dynamic> targetPerk = perkMenu.firstWhere((e)=>e["option"]==targetOption, orElse: ()=>{});
          //     Offset perkCenter =  targetPerk["center"];

          //     if (shouldGlow(gamePlayState)) {
          //       late double opacity = AnimationUtils().getHighlightEffectShadowOpacity(gamePlayState,targetKey!);
          //       TilePainters().drawTileShadow(canvas,ui.Color.fromRGBO(255, 255, 255, opacity),ui.Color.fromRGBO(227, 210, 253, opacity),tileSize*1.1,perkCenter);        
          //     }
          //   }
          // } else {

          // }
        } else {
          if (shouldGlow(gamePlayState)) {
            late double opacity = AnimationUtils().getHighlightEffectShadowOpacity(gamePlayState,targetKey!);
            Color textColor = ui.Color.fromRGBO(textColorRed, textColorGreen, textColorBlue, opacity);
            Color highlightColor = ui.Color.fromRGBO(highlightColorRed, highlightColorGreen, highlightColorBlue, opacity);            
            TilePainters().drawTileShadow(canvas,textColor,highlightColor,tileSize,tileCenter);        
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
            Color textColor = ui.Color.fromRGBO(textColorRed, textColorGreen, textColorBlue, opacity);
            Color highlightColor = ui.Color.fromRGBO(highlightColorRed, highlightColorGreen, highlightColorBlue, opacity);            
            TilePainters().drawTileShadow(canvas,textColor,highlightColor,tileSize*1.1,tileCenter);
          }
        }      
      }
    }     


    return canvas;
  }


  bool shouldGlow(GamePlayState gamePlayState) {
    late bool res = false;
    if (gamePlayState.highlightEffectTimer.isActive) {
      List<String> forbiddenAnimations = [];//["tile-freeze","tile-swap","tile-explode"];
      List<Map<String,dynamic>> noGlowAnimations = gamePlayState.animationData.where((e)=>forbiddenAnimations.contains(e["type"])).toList();
      if (noGlowAnimations.isEmpty) {
        res = true;
      }
    }
    return res;
  }

  Canvas paintDottedLineIndicator(Canvas canvas, GamePlayState gamePlayState, ColorPalette palette) {

    if (gamePlayState.isTutorial) {

      int currentStep = gamePlayState.tutorialData["currentTurn"];
      List<Map<String,dynamic>> tutorialSteps = gamePlayState.tutorialData["steps"];
      List<Map<String,dynamic>> dragSteps = tutorialSteps.where((e) => e["moveType"] == "drag").toList();

      for (int i = 0; i < dragSteps.length; i++) {
        Map<String,dynamic> dragStep = dragSteps[i];
        if (dragStep.isNotEmpty) {

          if (currentStep == dragStep["step"]) {
            final int reserveTileKey = dragStep["focusTile"];
            final int boardTileKey = dragStep["targetKey"];

            final Map<String,dynamic> reserveTile = gamePlayState.reserveTileData.firstWhere((e) => e["key"] == reserveTileKey, orElse: () => {});
            final Map<String,dynamic> boardTile = gamePlayState.tileData.firstWhere((e) => e["key"] == boardTileKey, orElse: () => {});

            if (reserveTile.isNotEmpty && boardTile.isNotEmpty) {

              final Offset reserveTileCenter = reserveTile["center"];
              final Offset boardTileCenter = boardTile["center"];

              final int stops = 30;
              final double dotSpacing = 1.0 / stops;

              final int red   = (palette.text1.r * 255).round();
              final int green = (palette.text1.g * 255).round();
              final int blue  = (palette.text1.b * 255).round();

              // Glow layers: each pass is wider and more transparent
              // Drawn first so they sit underneath the crisp dot
              const List<_GlowLayer> glowLayers = [
                _GlowLayer(strokeWidth: 18.0, opacityMultiplier: 0.10),
                _GlowLayer(strokeWidth: 12.0, opacityMultiplier: 0.18),
                _GlowLayer(strokeWidth:  7.0, opacityMultiplier: 0.28),
              ];

              for (int i = 5; i < stops - 2; i++) {
                if (i % 2 != 1) continue; // only odd segments, same as before

                double opacity = AnimationUtils().getHighlightEffectShadowOpacity(gamePlayState, i);

                double t1 = i * dotSpacing;
                double t2 = (i + 1) * dotSpacing;
                Offset p1 = Offset.lerp(reserveTileCenter, boardTileCenter, t1)!;
                Offset p2 = Offset.lerp(reserveTileCenter, boardTileCenter, t2)!;

                if (shouldGlow(gamePlayState)) {

                  // --- glow passes (back to front, widest first) ---
                  for (final layer in glowLayers) {
                    final Paint glowPaint = Paint()
                      // ..color = ui.Color.fromRGBO(red, green, blue, opacity * layer.opacityMultiplier)
                      ..color = ui.Color.fromRGBO(255, 0, 0, opacity * layer.opacityMultiplier)
                      ..strokeCap = StrokeCap.round
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = layer.strokeWidth
                      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);
                    canvas.drawLine(p1, p2, glowPaint);
                  }

                  // --- crisp dot on top ---
                  final Paint linePaint = Paint()
                    ..color = ui.Color.fromRGBO(red, green, blue, opacity)
                    ..strokeCap = StrokeCap.round
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 3.0;
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
class _GlowLayer {
  final double strokeWidth;
  final double opacityMultiplier;
  const _GlowLayer({required this.strokeWidth, required this.opacityMultiplier});
}

Canvas displayTutorialText(Canvas canvas,Size size, ColorPalette palette, double scalor, String content, Offset bonusCenter, double progress) {

  final double opacity = progress;

  final int red = (palette.text1.r * 255).round();
  final int green = (palette.text1.g * 255).round();
  final int blue = (palette.text1.b * 255).round();

  TextStyle textStyle = GoogleFonts.roboto(
    textStyle: TextStyle(
      color: ui.Color.fromRGBO(red, green, blue, opacity),
      fontSize: 26* scalor,
      shadows: [
        Shadow(color: ui.Color.fromRGBO(0, 0, 0, opacity),offset: Offset.zero,blurRadius: 10.0,)
      ]
    )
  );
  
  TextSpan textSpan = TextSpan(
    text: content,
    style: textStyle,
  );
  final textPainter = TextPainter(
    text: textSpan,
    textDirection: TextDirection.ltr,
    textAlign: TextAlign.center,
  );
  textPainter.layout(
    maxWidth: size.width * 0.8
  );

  final position = Offset(bonusCenter.dx - (textPainter.width/2), bonusCenter.dy - (textPainter.height/2));
  textPainter.paint(canvas, position);

  return canvas;    
}

Canvas displayStepMessage(Canvas canvas,GamePlayState gamePlayState,ColorPalette palette ) {
  if (gamePlayState.isTutorial) {

    Size size = gamePlayState.elementSizes['screenSize'];

    int turn = gamePlayState.tutorialData["currentTurn"];
    List<Map<String,dynamic>> steps = gamePlayState.tutorialData["steps"];
    Map<String,dynamic> step = steps.firstWhere((e)=>e["step"]==turn, orElse: ()=>{});

    Offset bonusCenter  = gamePlayState.elementPositions["bonusCenter"];

    String animationType = "tutorial-message-fade";
    List<Map<String,dynamic>> tutorialFadeAnimations = gamePlayState.animationData.where((e)=>e["type"]==animationType).toList();
    // print(step);

    if (step.isNotEmpty && tutorialFadeAnimations.isEmpty) {

      String content = step["message"];
      
      displayTutorialText(canvas,size,palette,gamePlayState.scalor,content,bonusCenter,1.0);

    }

  }
  return canvas;
}

Canvas animateTutorialMessage(Canvas canvas, GamePlayState gamePlayState, ColorPalette palette) {

  if (gamePlayState.isTutorial) {

    int turn = gamePlayState.tutorialData["currentTurn"];
    List<Map<String,dynamic>> steps = gamePlayState.tutorialData["steps"];

    Map<String,dynamic> step = steps.firstWhere((e)=>e["step"]==turn, orElse: ()=>{});
    Map<String,dynamic> previousStep = steps.firstWhere((e)=>e["step"]==turn-1, orElse: ()=>{});

    Offset currentContentCenter  = gamePlayState.elementPositions["bonusCenter"];

    // print(step);

    if (step.isNotEmpty) {

      Size size = gamePlayState.elementSizes['screenSize'];

      String content = step["message"];
      

      String animationType = "tutorial-message-fade";
      List<Map<String,dynamic>> tutorialFadeAnimations = gamePlayState.animationData.where((e)=>e["type"]==animationType).toList();

      for (int i=0; i<tutorialFadeAnimations.length; i++) {

        late Map<String,dynamic> tutorialFadeAnimation = tutorialFadeAnimations[i]; 
        late double animationProgress = tutorialFadeAnimation["progress"];

        late double updatedY = currentContentCenter.dy + (100.0 * (1.0 - animationProgress));
        late Offset updatedContentCenter = Offset(currentContentCenter.dx,updatedY);
        

        displayTutorialText(canvas,size,palette,gamePlayState.scalor,content,updatedContentCenter,animationProgress);

        if (previousStep.isNotEmpty) {

          late double previousY = currentContentCenter.dy - (100.0 * animationProgress); 
          late Offset updatedPreviousContentCenter = Offset(currentContentCenter.dx,previousY);         
          late double previousContentProgress = 1.0 - animationProgress;
          String previousContent = previousStep["message"];
          displayTutorialText(canvas,size,palette,gamePlayState.scalor,previousContent,updatedPreviousContentCenter,previousContentProgress);
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