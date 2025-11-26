import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:scribby_flutter_v2/functions/animation_utils.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/painters/tile_painters.dart';

class PerksBarPainters {

  Canvas drawPerksArea(Canvas canvas, GamePlayState gamePlayState, ColorPalette palette) {
    drawPerksBarBackground(canvas, gamePlayState, palette);

    drawPerksIcons(canvas,gamePlayState,palette);


    drawAddPerkAnimation(canvas,gamePlayState,palette);
    return canvas;
  }


  Canvas drawPerksBarBackground(Canvas canvas, GamePlayState gamePlayState, ColorPalette palette ) {
    
    Offset perksCenter = gamePlayState.elementPositions["perksCenter"];
    Size perksAreaSize = gamePlayState.elementSizes["perksAreaSize"];

    Rect perksAreaRect = Rect.fromCenter(center: perksCenter, width: perksAreaSize.width*0.8, height: perksAreaSize.height*1.1);
    RRect perksAreaRRect = RRect.fromRectAndRadius(perksAreaRect, Radius.circular(12.0));

    Paint perksAreaBg = Paint();
    perksAreaBg.color = palette.perkBarBackgroundColor; //const Color.fromARGB(103, 245, 8, 8);

    canvas.drawRRect(perksAreaRRect, perksAreaBg);
    
    return canvas;
  }



  Canvas drawPerksIcons(Canvas canvas, GamePlayState gamePlayState, ColorPalette palette) {
    
    Size perkAreaSize = gamePlayState.elementSizes["perksAreaSize"];
    
    
    // Paint perkPaint = Paint();
    // perkPaint.color = Colors.white;
    

    for (int i=0; i<gamePlayState.tileMenuOptions.length; i++) {
      late Size perkSize = Size(perkAreaSize.height*0.85,perkAreaSize.height*0.85);
      
      Offset perkCenter = gamePlayState.tileMenuOptions[i]["center"];
      String iconType = gamePlayState.tileMenuOptions[i]["item"];
      bool isSelected = gamePlayState.tileMenuOptions[i]["selected"];
      bool isOpen = gamePlayState.tileMenuOptions[i]["open"];
      int count = gamePlayState.tileMenuOptions[i]["count"];
      // Rect perkRect = Rect.fromCenter(center: perkCenter, width: perkSize, height: perkSize);

      // canvas.drawRect(perkRect, perkPaint);
      // if (isOpen) {
      //   perkSize = Size(perkAreaSize.height*1.1,perkAreaSize.height*1.1,);
      // } 

      double itemDiameter = perkSize.width*0.75;//tileSize.width*0.6;

      Map<String,dynamic> addPerkAnimation = gamePlayState.animationData.firstWhere((e)=>e["key"]==iconType,orElse: ()=>{});

      late double opacity = 1.0;
      late Color unselectedColor = palette.perkUnselectedColor;
      late Color selectedColor = palette.perkSelectedColor;

      late Color perkColor = unselectedColor;
      // if (isSelected || isOpen) {
      //   perkColor = selectedColor;
      // }

      List<Map<String,dynamic>> selectPerkAnimations = gamePlayState.animationData.where( (e) => e["type"]=='select-perk' && e["key"]=="${iconType}_select" ).toList();
      if (selectPerkAnimations.isNotEmpty) {
        for (int i=0; i<selectPerkAnimations.length; i++) {
          // canvas.drawRect(Rect.fromCenter(center: perkCenter, width: perkSize.width, height: perkSize.height), perkPaint);
          late double progress = selectPerkAnimations[i]["progress"];
          if (!selectPerkAnimations[i]["select"]) {
            progress = 1.0-selectPerkAnimations[i]["progress"];
          } 
          final double updatedSizeValue = (perkAreaSize.height*0.85) + (perkAreaSize.height*0.85*0.3*progress);
          final Size updatedSize = Size(updatedSizeValue,updatedSizeValue);
          itemDiameter = updatedSize.width*0.75;
          perkColor = Color.lerp(unselectedColor, selectedColor, progress)??selectedColor;  
          TilePainters().drawOptionIcon(canvas,perkCenter,iconType,updatedSize,1.0,perkColor);
        }
      } else {
        if (isOpen || isSelected) {
          perkSize = Size(perkAreaSize.height*0.85*1.3,perkAreaSize.height*0.85*1.3);
          perkColor = selectedColor;
          itemDiameter = perkSize.width*0.75;

        }
        TilePainters().drawOptionIcon(canvas,perkCenter,iconType,perkSize,1.0,perkColor);
      }   


      

      TextStyle textStyle = TextStyle(
        color: perkColor ,
        fontSize: itemDiameter*0.5 * gamePlayState.scalor ,
        shadows: addPerkAnimation.isNotEmpty ? [
          Shadow(color: palette.perkShadowColor,offset: Offset.zero, blurRadius: 22.0 * opacity,)
        ] : []
      );
      TextSpan textSpan = TextSpan(
        text: count.toString(),
        style: textStyle,
      );
  
      final TextPainter textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      Offset textPosition = Offset(perkCenter.dx + itemDiameter*0.4, perkCenter.dy + itemDiameter*0.2);
      textPainter.paint(canvas, textPosition);            
    }
    return canvas;
  }


  Canvas drawAddPerkAnimation(Canvas canvas, GamePlayState gamePlayState, ColorPalette palette) {

    // List<Map<String,dynamic>> scorePointsAnimations = gamePlayState.animationData.where((e)=>e["type"]=="score-points").toList();
    Map<String,dynamic> scorePointsAnimation = gamePlayState.animationData.firstWhere((e)=>e["type"]=="add-perks",orElse: ()=>{});
    if (scorePointsAnimation.isNotEmpty) {
      String perkType = scorePointsAnimation["perk"];
      Map<String,dynamic> perkObject = gamePlayState.tileMenuOptions.firstWhere((e)=>e["item"]==perkType,orElse: ()=>{});
      Offset perkCenter = perkObject["center"];

      List<Map<String,dynamic>> scoreObjects = scorePointsAnimation["animation"];
      double progress = scorePointsAnimation["progress"];

      for (int i=0; i<scoreObjects.length; i++) {
        Map<String,dynamic> animationObject = scoreObjects[i];
        
        int points = animationObject["body"];
        double xOffset = animationObject["xOffset"];
        String body = "+$points";

        drawPlusOnePerkAnimation(canvas,palette, gamePlayState,perkCenter,body,progress,xOffset, i, scoreObjects.length);
      }
    }
    return canvas;
  }  

  Canvas drawPlusOnePerkAnimation(Canvas canvas, ColorPalette palette, GamePlayState gamePlayState, Offset center, String body, double progress, double xOffset, int index, int countAnimations) {


    // Size scoreboardSize = gamePlayState.elementSizes["scoreboardAreaSize"];
    // Offset scoreboardCenter = gamePlayState.elementPositions["scoreboardCenter"];
    Map<String,dynamic> animationDurations = gamePlayState.animationLengths.firstWhere((e)=>e["type"]=="add-perks",orElse: ()=>{});
    int animationDuration = (animationDurations["stops"]*animationDurations["interval"]*countAnimations);

    // double opacityProgress = getPlusNPointsOpacity(progress);

    double adjustedProgress = AnimationUtils().getAdjustedProgress(index,countAnimations,progress,animationDuration);
    // Color textColor = getPlusNPointsColor(adjustedProgress, palette);
    Color textColor = AnimationUtils().getPlusNPerksColor(adjustedProgress, palette);

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

    
    double positionX = (center.dx + (40)/4) + xOffset;
    double positionY = center.dy + 40 - (40*adjustedProgress);
    // final Offset position = Offset(positionX, positionY);

    double textPositionX = positionX - (textPainter.width/2);
    double textPositionY = positionY - (textPainter.height/2);
    final Offset textPosition = Offset(textPositionX, textPositionY);


    // canvas.drawRRect(plusNPointsRRect, plusNPointsContainerPaint);
    textPainter.paint(canvas, textPosition);  

    return canvas;
  }  


}