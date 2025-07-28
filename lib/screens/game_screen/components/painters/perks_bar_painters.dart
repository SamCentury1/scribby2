import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/painters/tile_painters.dart';

class PerksBarPainters {

  Canvas drawPerksArea(Canvas canvas, GamePlayState gamePlayState, ColorPalette palette) {
    drawPerksBarBackground(canvas, gamePlayState, palette);
    drawPerksIcons(canvas,gamePlayState,palette);
    return canvas;
  }


  Canvas drawPerksBarBackground(Canvas canvas, GamePlayState gamePlayState, ColorPalette palette ) {
    
    Offset perksCenter = gamePlayState.elementPositions["perksCenter"];
    Size perksAreaSize = gamePlayState.elementSizes["perksAreaSize"];

    Rect perksAreaRect = Rect.fromCenter(center: perksCenter, width: perksAreaSize.width*0.8, height: perksAreaSize.height);
    RRect perksAreaRRect = RRect.fromRectAndRadius(perksAreaRect, Radius.circular(22.0));

    Paint perksAreaBg = Paint();
    perksAreaBg.color = const Color.fromARGB(103, 255, 255, 255);

    canvas.drawRRect(perksAreaRRect, perksAreaBg);
    
    return canvas;
  }



  Canvas drawPerksIcons(Canvas canvas, GamePlayState gamePlayState, ColorPalette palette) {
    
    Size perkAreaSize = gamePlayState.elementSizes["perksAreaSize"];
    
    
    Paint perkPaint = Paint();
    perkPaint.color = Colors.white;
    

    for (int i=0; i<gamePlayState.tileMenuOptions.length; i++) {
      late Size perkSize = Size(perkAreaSize.height*0.9,perkAreaSize.height*0.9);
      
      Offset perkCenter = gamePlayState.tileMenuOptions[i]["center"];
      String iconType = gamePlayState.tileMenuOptions[i]["item"];
      bool isSelected = gamePlayState.tileMenuOptions[i]["selected"];
      bool isOpen = gamePlayState.tileMenuOptions[i]["open"];
      int count = gamePlayState.tileMenuOptions[i]["count"];
      // Rect perkRect = Rect.fromCenter(center: perkCenter, width: perkSize, height: perkSize);

      // canvas.drawRect(perkRect, perkPaint);
      if (isSelected || isOpen) {
        perkSize = Size(perkAreaSize.height*1.1,perkAreaSize.height*1.1,);
      } 

      double itemDiameter = perkSize.width*0.75;//tileSize.width*0.6;

      Map<String,dynamic> perkAnimation = gamePlayState.animationData.firstWhere((e)=>e["key"]==iconType,orElse: ()=>{});

      late double opacity = 1.0;
      late Color unselectedColor = Colors.white;
      late Color selectedColor = const Color.fromARGB(255, 4, 17, 133);

      late Color perkColor = unselectedColor;
      if (isSelected || isOpen) {
        perkColor = selectedColor;
      }

      TilePainters().drawOptionIcon(canvas,perkCenter,iconType,perkSize,1.0,perkColor);

      

      TextStyle textStyle = TextStyle(
        color: perkColor ,
        fontSize: itemDiameter*0.5 * gamePlayState.scalor ,
        shadows: perkAnimation.isNotEmpty ? [
          Shadow(color: Colors.white,offset: Offset.zero, blurRadius: 22.0 * opacity,)
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


}