import 'dart:math';
import 'dart:ui' as ui;
// import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scribby_flutter_v2/functions/animation_utils.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/functions/styling_utils.dart';
import 'package:scribby_flutter_v2/functions/widget_utils.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';

class TilePainters {

  Map<String,dynamic> getPaintSet(String type, String body, Map<String,dynamic> decorationData) {
    late Map<String,dynamic> res = {}; 

    late Color color1 = Colors.transparent;
    late Color color2 = Colors.transparent;
    late Color textColor = Colors.transparent;
    late Color rightEdgeColor = Colors.transparent;
    late Color bottomEdgeColor = Colors.transparent;
    late Color insideDecorationColor = Colors.transparent;

    // if (body=="") {

    //   if (type=='random') {
    //     color1 = const ui.Color.fromARGB(255, 44, 60, 153);
    //     color2 = const ui.Color.fromARGB(255, 84, 182, 206);
    //     textColor = const ui.Color.fromARGB(187, 232, 230, 233);
    //     rightEdgeColor = ui.Color.fromARGB(237, 47, 41, 136);
    //     bottomEdgeColor = ui.Color.fromARGB(235, 139, 75, 223);
    //     insideDecorationColor = ui.Color.fromARGB(132, 216, 96, 204);
    //   }

    //   if (type=='board') {
    //     color1 = Color.fromARGB(255,156,224,255);
    //     color2 = ui.Color.fromARGB(239, 217, 255, 255);
    //     textColor = Colors.transparent;
    //     rightEdgeColor = ui.Color.fromARGB(239, 137, 241, 255);
    //     bottomEdgeColor = ui.Color.fromARGB(236, 16, 14, 126);
    //     insideDecorationColor = Colors.transparent;
    //   }   

    //   if (type=='reserve') {
    //     color1 = const ui.Color.fromARGB(255, 241, 231, 247);
    //     color2 = const ui.Color.fromARGB(255, 210, 255, 242);
    //     textColor = Colors.transparent;
    //     rightEdgeColor = ui.Color.fromARGB(238, 137, 139, 255);
    //     bottomEdgeColor = ui.Color.fromARGB(236, 78, 87, 1);
    //     insideDecorationColor = Colors.transparent;
    //   }

    //   if (type=='reserve') {
    //     color1 = const ui.Color.fromARGB(255, 241, 231, 247);
    //     color2 = const ui.Color.fromARGB(255, 210, 255, 242);
    //     textColor = Colors.transparent;
    //     rightEdgeColor = ui.Color.fromARGB(238, 137, 139, 255);
    //     bottomEdgeColor = ui.Color.fromARGB(236, 78, 87, 1);
    //     insideDecorationColor = Colors.transparent;
    //   }

    //   if (type=='dead') {
    //     color1 = const ui.Color.fromARGB(255, 83, 83, 83);
    //     color2 = const ui.Color.fromARGB(255, 36, 36, 36);
    //     textColor = const ui.Color.fromARGB(0, 0, 0, 0);
    //     rightEdgeColor = ui.Color.fromARGB(236, 138, 138, 138);
    //     bottomEdgeColor = ui.Color.fromARGB(235, 20, 20, 20);
    //     insideDecorationColor = ui.Color.fromARGB(0, 255, 186, 248);
    //   }            
    // } else {

    //   if (type=='random') {
    //     color1 = decorationData["faceColors"][0]; //const ui.Color.fromARGB(255, 90, 100, 247);
    //     color2 = decorationData["faceColors"][1]; //const ui.Color.fromARGB(255, 29, 27, 165);
    //     textColor = decorationData["bodyColor"]; //const ui.Color.fromARGB(187, 204, 214, 235);
    //     rightEdgeColor = Color.lerp(decorationData["baseColor"], Colors.white, 0.5)??decorationData["baseColor"];
    //     bottomEdgeColor = Color.lerp(decorationData["baseColor"], Colors.black, 0.4)??decorationData["baseColor"];
    //     insideDecorationColor = Color.lerp(decorationData["bodyColor"], Colors.transparent, 0.2)??decorationData["bodyColor"]; //ui.Color.fromARGB(132, 170, 235, 255);
    //   }      

    //   if (type=='reserve') {
    //     color1 = decorationData["faceColors"][0]; //const ui.Color.fromARGB(255, 9, 20, 83);
    //     color2 = decorationData["faceColors"][1]; //const ui.Color.fromARGB(255, 13, 49, 126);
    //     textColor = decorationData["bodyColor"]; //const ui.Color.fromARGB(188, 184, 191, 250);
    //     rightEdgeColor = Color.lerp(decorationData["baseColor"], Colors.white, 0.5)??decorationData["baseColor"];
    //     bottomEdgeColor = Color.lerp(decorationData["baseColor"], Colors.black, 0.4)??decorationData["baseColor"];
    //     insideDecorationColor = Color.lerp(decorationData["bodyColor"], Colors.transparent, 0.2)??decorationData["bodyColor"];  //ui.Color.fromARGB(132, 196, 243, 255);
    //   }

    //   if (type=='board') {
    //     color1 = decorationData["faceColors"][0]; //Colors.lightBlue;
    //     color2 = decorationData["faceColors"][1]; //Colors.indigo;
    //     textColor = decorationData["bodyColor"]; //const Color.fromARGB(190, 123, 191, 255);
    //     rightEdgeColor = Color.lerp(decorationData["baseColor"], Colors.white, 0.5)??decorationData["baseColor"];
    //     bottomEdgeColor = Color.lerp(decorationData["baseColor"], Colors.black, 0.4)??decorationData["baseColor"];
    //     insideDecorationColor = Color.lerp(decorationData["bodyColor"], Colors.transparent, 0.2)??decorationData["bodyColor"];  //ui.Color.fromARGB(132, 196, 220, 255);
    //   }

    //   if (type=='board-frozen') {
        
    //     color1 = const ui.Color.fromARGB(255, 165, 215, 238);
    //     color2 = const ui.Color.fromARGB(255, 227, 228, 235);
    //     textColor = const Color.fromARGB(190, 123, 191, 255);
    //     rightEdgeColor = ui.Color.fromARGB(239, 137, 241, 255);
    //     bottomEdgeColor = ui.Color.fromARGB(236, 50, 49, 143);
    //     insideDecorationColor = decorationData["bodyColor"]; //ui.Color.fromARGB(132, 196, 220, 255);
    //   }      
    // }  


    if (type=='board-empty') {
      color1 = Color.fromARGB(255,156,224,255);
      color2 = ui.Color.fromARGB(239, 217, 255, 255);
      textColor = Colors.transparent;
      rightEdgeColor = ui.Color.fromARGB(239, 137, 241, 255);
      bottomEdgeColor = ui.Color.fromARGB(236, 16, 14, 126);
      insideDecorationColor = Colors.transparent;
    }   

    if (type=='reserve-empty') {
      color1 = const ui.Color.fromARGB(255, 241, 231, 247);
      color2 = const ui.Color.fromARGB(255, 210, 255, 242);
      textColor = Colors.transparent;
      rightEdgeColor = ui.Color.fromARGB(238, 137, 139, 255);
      bottomEdgeColor = ui.Color.fromARGB(236, 78, 87, 1);
      insideDecorationColor = Colors.transparent;
    }

    if (type=='dead') {
      color1 = const ui.Color.fromARGB(255, 83, 83, 83);
      color2 = const ui.Color.fromARGB(255, 36, 36, 36);
      textColor = const ui.Color.fromARGB(0, 0, 0, 0);
      rightEdgeColor = ui.Color.fromARGB(236, 138, 138, 138);
      bottomEdgeColor = ui.Color.fromARGB(235, 20, 20, 20);
      insideDecorationColor = ui.Color.fromARGB(0, 255, 186, 248);
    }

    if (type=='random') {
      color1 = decorationData["faceColors"][0]; //const ui.Color.fromARGB(255, 90, 100, 247);
      color2 = decorationData["faceColors"][1]; //const ui.Color.fromARGB(255, 29, 27, 165);
      textColor = decorationData["bodyColor"]; //const ui.Color.fromARGB(187, 204, 214, 235);
      rightEdgeColor = Color.lerp(decorationData["baseColor"], Colors.white, 0.5)??decorationData["baseColor"];
      bottomEdgeColor = Color.lerp(decorationData["baseColor"], Colors.black, 0.4)??decorationData["baseColor"];
      insideDecorationColor = Color.lerp(decorationData["bodyColor"], Colors.transparent, 0.2)??decorationData["bodyColor"]; //ui.Color.fromARGB(132, 170, 235, 255);
    }      

    if (type=='reserve-full') {
      color1 = decorationData["faceColors"][0]; //const ui.Color.fromARGB(255, 9, 20, 83);
      color2 = decorationData["faceColors"][1]; //const ui.Color.fromARGB(255, 13, 49, 126);
      textColor = decorationData["bodyColor"]; //const ui.Color.fromARGB(188, 184, 191, 250);
      rightEdgeColor = Color.lerp(decorationData["baseColor"], Colors.white, 0.5)??decorationData["baseColor"];
      bottomEdgeColor = Color.lerp(decorationData["baseColor"], Colors.black, 0.4)??decorationData["baseColor"];
      insideDecorationColor = Color.lerp(decorationData["bodyColor"], Colors.transparent, 0.2)??decorationData["bodyColor"];  //ui.Color.fromARGB(132, 196, 243, 255);
    }

    if (type=='board-full') {
      color1 = decorationData["faceColors"][0]; //Colors.lightBlue;
      color2 = decorationData["faceColors"][1]; //Colors.indigo;
      textColor = decorationData["bodyColor"]; //const Color.fromARGB(190, 123, 191, 255);
      rightEdgeColor = Color.lerp(decorationData["baseColor"], Colors.white, 0.5)??decorationData["baseColor"];
      bottomEdgeColor = Color.lerp(decorationData["baseColor"], Colors.black, 0.4)??decorationData["baseColor"];
      insideDecorationColor = Color.lerp(decorationData["bodyColor"], Colors.transparent, 0.2)??decorationData["bodyColor"];  //ui.Color.fromARGB(132, 196, 220, 255);
    }

    if (type=='board-frozen') {
      color1 = const ui.Color.fromARGB(255, 165, 215, 238);
      color2 = const ui.Color.fromARGB(255, 227, 228, 235);
      textColor = const Color.fromARGB(190, 123, 191, 255);
      rightEdgeColor = ui.Color.fromARGB(239, 137, 241, 255);
      bottomEdgeColor = ui.Color.fromARGB(236, 50, 49, 143);
      insideDecorationColor = decorationData["bodyColor"]; //ui.Color.fromARGB(132, 196, 220, 255);
    }      
    res = {
      "faceColor1":color1,
      "faceColor2":color2,
      "textColor":textColor,
      "rightEdgeColor":rightEdgeColor,
      "bottomEdgeColor":bottomEdgeColor,
      "insideDecorationColor":insideDecorationColor,
    };
    return res;
  }

  Map<String,dynamic> getAnimatingTilePaints(String sourceType, String targetType, double progress, String body,Map<String,dynamic> decorationData) {
    Map<String,dynamic> sourcePaint = getPaintSet(sourceType,body,decorationData);
    Map<String,dynamic> targetPaint = getPaintSet(targetType,body,decorationData);

    Color sourceColor1 = sourcePaint["faceColor1"];
    Color sourceColor2 = sourcePaint["faceColor2"];
    Color sourceTextColor = sourcePaint["textColor"];
    Color sourceRightEdgeColor = sourcePaint["rightEdgeColor"];
    Color sourceBottomEdgeColor = sourcePaint["bottomEdgeColor"];
    Color sourceInsideDecorationColor = sourcePaint["insideDecorationColor"];

    Color targetColor1 = targetPaint["faceColor1"]; 
    Color targetColor2 = targetPaint["faceColor2"]; 
    Color targetTextColor = targetPaint["textColor"]; 
    Color targetRightEdgeColor = targetPaint["rightEdgeColor"];
    Color targetBottomEdgeColor = targetPaint["bottomEdgeColor"]; 
    Color targetInsideDecorationColor = targetPaint["insideDecorationColor"]; 

    Color color1 = Color.lerp(sourceColor1, targetColor1, progress)??targetColor1;
    Color color2 = Color.lerp(sourceColor2, targetColor2, progress)??targetColor2;
    Color textColor = Color.lerp(sourceTextColor, targetTextColor, progress)??targetTextColor;
    Color rightEdgeColor = Color.lerp(sourceRightEdgeColor, targetRightEdgeColor, progress)??targetRightEdgeColor;
    Color bottomEdgeColor = Color.lerp(sourceBottomEdgeColor, targetBottomEdgeColor, progress)??targetBottomEdgeColor;
    Color insideDecorationColor = Color.lerp(sourceInsideDecorationColor, targetInsideDecorationColor, progress)??targetInsideDecorationColor;

    Map<String,dynamic> res = {
      "faceColor1":color1,
      "faceColor2":color2,
      "textColor":textColor,
      "rightEdgeColor":rightEdgeColor,
      "bottomEdgeColor":bottomEdgeColor,
      "insideDecorationColor":insideDecorationColor,
    };
    return res;
  }  
  
  Canvas paintAnimatingTile(
    Canvas canvas, 
    Offset tileCenter, 
    GamePlayState gamePlayState, 
    String body, 
    Size tileSize, 
    double progress, 
    String source, 
    String target,
    Map<String,dynamic> decorationData,
    ColorPalette palette
    ) {
    late Map<String,dynamic> paints = {};

    paints = getAnimatingTilePaints(source,target,progress,body,decorationData);
    Color color1 = paints["faceColor1"];
    Color color2 = paints["faceColor2"];
    Color textColor = paints["textColor"];
    Color rightEdgeColor = paints["rightEdgeColor"];
    Color bottomEdgeColor = paints["bottomEdgeColor"];
    Color insideDecorationColor = paints["insideDecorationColor"];
    
    // final Size tileSize = gamePlayState.elementSizes["tileSize"];
    final double thicknessFactor = tileSize.width*0.05/2;
    final double radius = tileSize.width*0.15;
    final Offset tileFaceCenter = Offset(tileCenter.dx-thicknessFactor,tileCenter.dy-thicknessFactor);
    final Rect tileRect = Rect.fromCenter(center: tileFaceCenter, width: tileSize.width*0.9, height: tileSize.height*0.9);
    final RRect tileRRect = RRect.fromRectAndRadius(tileRect, Radius.circular(radius));

    final Offset tileBorderCenter = Offset(tileCenter.dx+thicknessFactor,tileCenter.dy+thicknessFactor);
    final Rect tileBorderRect = Rect.fromCenter(center: tileBorderCenter, width: tileSize.width*0.9, height: tileSize.height*0.9);
    final RRect tileBorderRRect = RRect.fromRectAndRadius(tileBorderRect, Radius.circular(radius));

    final Rect insideBorderDecorationRect = Rect.fromCenter(center: tileFaceCenter, width: tileSize.width*0.65, height: tileSize.height*0.65);
    final RRect insideBorderDecorationRRect = RRect.fromRectAndRadius(insideBorderDecorationRect, Radius.circular(tileSize.width*0.10));

    List<Offset> offsetDirection = StylingUtils().getGradientOffset(tileCenter, tileSize,decorationData["gradientOffset"]);
    final double dx1 = tileFaceCenter.dx+(tileSize.width*decorationData["offsetData"]["dx1"]);
    final double dx2 = tileFaceCenter.dx+(tileSize.width*decorationData["offsetData"]["dx2"]);

    final double dy1 = tileFaceCenter.dy+(tileSize.height*decorationData["offsetData"]["dy1"]);
    final double dy2 = tileFaceCenter.dy+(tileSize.height*decorationData["offsetData"]["dy2"]);

    final Offset offset1 = Offset(dx1,dy1);
    final Offset offset2 = Offset(dx2,dy2);    
    
    Paint insideDecorationPaint = Paint();
    Paint tilePaint = Paint();
    Paint rightEdgePaint = Paint();
    Paint bottomEdgePaint = Paint();

    rightEdgePaint.shader = ui.Gradient.linear(
      Offset(tileBorderCenter.dx-((tileSize.width*1.5)/2), tileBorderCenter.dy),
      Offset(tileBorderCenter.dx+((tileSize.width*1.5)/2), tileBorderCenter.dy),
      [Colors.transparent, rightEdgeColor],
      [0.4,0.9]
    );

    bottomEdgePaint.shader = ui.Gradient.linear(
      Offset(tileBorderCenter.dx, tileBorderCenter.dy-((tileSize.width*1.5)/2)),
      Offset(tileBorderCenter.dx, tileBorderCenter.dy+((tileSize.width*1.5)/2)),
      [Colors.transparent, bottomEdgeColor],
      [0.4,0.9]
    );

    tilePaint.shader = ui.Gradient.linear(
      // offsetDirection[0],
      // offsetDirection[1],
      //decorationData["tileFaceOffset1"]??offsetDirection[0],
      //decorationData["tileFaceOffset2"]??offsetDirection[1],
      offset1,offset2,
      [color1, color2],
    );

    insideDecorationPaint.style = PaintingStyle.stroke;
    insideDecorationPaint.strokeCap = StrokeCap.round;
    insideDecorationPaint.strokeWidth = tileSize.width*0.05;
    insideDecorationPaint.color = insideDecorationColor;
    // Color textColor = const Color.fromARGB(190, 123, 191, 255);

    canvas.drawRRect(tileBorderRRect, rightEdgePaint);
    canvas.drawRRect(tileBorderRRect, bottomEdgePaint);
    canvas.drawRRect(tileRRect, tilePaint);
    canvas.drawRRect(insideBorderDecorationRRect, insideDecorationPaint);
    WidgetUtils().displayTileText(canvas, body, textColor, tileFaceCenter,tileSize.width*0.4, palette);    

    return canvas;
  }



  Canvas drawTile2(Canvas canvas, Offset tileCenter, String body, Size tileSize, String type, Map<String,dynamic> decorationData, ColorPalette palette) {

//     print("""
// ------------------------------
//       DECORATION 
//       $decorationData
// ------------------------------
//     """);
    // final Size tileSize = gamePlayState.elementSizes["tileSize"];
    final double thicknessFactor = tileSize.width*0.05/2;
    final double radius = tileSize.width*0.15;
    final Offset tileFaceCenter = Offset(tileCenter.dx-thicknessFactor,tileCenter.dy-thicknessFactor);
    final Rect tileRect = Rect.fromCenter(center: tileFaceCenter, width: tileSize.width*0.9, height: tileSize.height*0.9);
    final RRect tileRRect = RRect.fromRectAndRadius(tileRect, Radius.circular(radius));

    final Offset tileBorderCenter = Offset(tileCenter.dx+thicknessFactor,tileCenter.dy+thicknessFactor);
    final Rect tileBorderRect = Rect.fromCenter(center: tileBorderCenter, width: tileSize.width*0.9, height: tileSize.height*0.9);
    final RRect tileBorderRRect = RRect.fromRectAndRadius(tileBorderRect, Radius.circular(radius));

    final Rect insideBorderDecorationRect = Rect.fromCenter(center: tileFaceCenter, width: tileSize.width*0.65, height: tileSize.height*0.65);
    final RRect insideBorderDecorationRRect = RRect.fromRectAndRadius(insideBorderDecorationRect, Radius.circular(tileSize.width*0.10));

    List<Offset> offsetDirection = StylingUtils().getGradientOffset(tileCenter, tileSize,decorationData["gradientOffset"]);

    final double dx1 = tileFaceCenter.dx+(tileSize.width*decorationData["offsetData"]["dx1"]);
    final double dx2 = tileFaceCenter.dx+(tileSize.width*decorationData["offsetData"]["dx2"]);

    final double dy1 = tileFaceCenter.dy+(tileSize.height*decorationData["offsetData"]["dy1"]);
    final double dy2 = tileFaceCenter.dy+(tileSize.height*decorationData["offsetData"]["dy2"]);

    final Offset offset1 = Offset(dx1,dy1);
    final Offset offset2 = Offset(dx2,dy2);

    List<Offset> rightEdgeOffsets = StylingUtils().getEdgeGradientOffsets(tileBorderCenter,tileSize,'right');
    List<Offset> bottomEdgeOffsets = StylingUtils().getEdgeGradientOffsets(tileBorderCenter,tileSize,'bottom');

    Map<String,dynamic> colors = getPaintSet(type,body,decorationData);

    Color color1 = colors["faceColor1"];
    Color color2 = colors["faceColor2"];
    Color textColor = colors["textColor"];
    Color rightEdgeColor = colors["rightEdgeColor"];
    Color bottomEdgeColor = colors["bottomEdgeColor"];
    Color insideDecorationColor = colors["insideDecorationColor"]; 
    
    Paint insideDecorationPaint = Paint();
    Paint tilePaint = Paint();
    Paint rightEdgePaint = Paint();
    Paint bottomEdgePaint = Paint();

    rightEdgePaint.shader = ui.Gradient.linear(
      rightEdgeOffsets[0],
      rightEdgeOffsets[1],
      [Colors.transparent, rightEdgeColor],
      [0.4,0.9]
    );

    bottomEdgePaint.shader = ui.Gradient.linear(
      bottomEdgeOffsets[0],
      bottomEdgeOffsets[1],
      [Colors.transparent, bottomEdgeColor],
      [0.4,0.9]
    );

    tilePaint.shader = ui.Gradient.linear(
      // offsetDirection[0],
      // offsetDirection[1],      
      // decorationData["tileFaceOffset1"]??offsetDirection[0], //offsetDirection[0], 
      // decorationData["tileFaceOffset2"]??offsetDirection[1], //offsetDirection[1],
      offset1,offset2, 
      [color1, color2],
    );

    insideDecorationPaint.style = PaintingStyle.stroke;
    insideDecorationPaint.strokeCap = StrokeCap.round;
    insideDecorationPaint.strokeWidth = tileSize.width*0.05;
    insideDecorationPaint.color = insideDecorationColor;

    canvas.drawRRect(tileBorderRRect, rightEdgePaint);
    canvas.drawRRect(tileBorderRRect, bottomEdgePaint);
    canvas.drawRRect(tileRRect, tilePaint);
    canvas.drawRRect(insideBorderDecorationRRect, insideDecorationPaint);

    WidgetUtils().displayTileText(canvas, body, textColor, tileFaceCenter,tileSize.width*0.4, palette);

    return canvas;
  }


  Canvas drawWordFoundAnimatingTile(
      Canvas canvas, 
      Offset tileCenter, 
      GamePlayState gamePlayState, 
      String body, 
      Size tileSize, 
      String type, 
      double opacity, 
      Map<String,dynamic> decorationData,
      ColorPalette palette,
    ) {
    final double thicknessFactor = tileSize.width*0.05/2;
    final double radius = tileSize.width*0.15;
    final Offset tileFaceCenter = Offset(tileCenter.dx-thicknessFactor,tileCenter.dy-thicknessFactor);
    final Rect tileRect = Rect.fromCenter(center: tileFaceCenter, width: tileSize.width*0.9, height: tileSize.height*0.9);
    final RRect tileRRect = RRect.fromRectAndRadius(tileRect, Radius.circular(radius));

    final Offset tileBorderCenter = Offset(tileCenter.dx+thicknessFactor,tileCenter.dy+thicknessFactor);
    final Rect tileBorderRect = Rect.fromCenter(center: tileBorderCenter, width: tileSize.width*0.9, height: tileSize.height*0.9);
    final RRect tileBorderRRect = RRect.fromRectAndRadius(tileBorderRect, Radius.circular(radius));

    final Rect insideBorderDecorationRect = Rect.fromCenter(center: tileFaceCenter, width: tileSize.width*0.7, height: tileSize.height*0.7);
    final RRect insideBorderDecorationRRect = RRect.fromRectAndRadius(insideBorderDecorationRect, Radius.circular(tileSize.width*0.10));

    List<Offset> offsetDirection = StylingUtils().getGradientOffset(tileCenter, tileSize,2);

    final double dx1 = tileFaceCenter.dx+(tileSize.width*decorationData["offsetData"]["dx1"]);
    final double dx2 = tileFaceCenter.dx+(tileSize.width*decorationData["offsetData"]["dx2"]);

    final double dy1 = tileFaceCenter.dy+(tileSize.height*decorationData["offsetData"]["dy1"]);
    final double dy2 = tileFaceCenter.dy+(tileSize.height*decorationData["offsetData"]["dy2"]);

    final Offset offset1 = Offset(dx1,dy1);
    final Offset offset2 = Offset(dx2,dy2);

    List<Offset> rightEdgeOffsets = StylingUtils().getEdgeGradientOffsets(tileBorderCenter,tileSize,'right');
    List<Offset> bottomEdgeOffsets = StylingUtils().getEdgeGradientOffsets(tileBorderCenter,tileSize,'bottom');

    Map<String,dynamic> colors = getPaintSet(type,body,decorationData);
    Color color1 = colors["faceColor1"].withOpacity(opacity);
    Color color2 = colors["faceColor2"].withOpacity(opacity);
    Color textColor = colors["textColor"].withOpacity(opacity);
    Color rightEdgeColor = colors["rightEdgeColor"].withOpacity(opacity);
    Color bottomEdgeColor = colors["bottomEdgeColor"].withOpacity(opacity);
    Color insideDecorationColor = colors["insideDecorationColor"].withOpacity(opacity); 
    
    Paint insideDecorationPaint = Paint();
    Paint tilePaint = Paint();
    Paint rightEdgePaint = Paint();
    Paint bottomEdgePaint = Paint();

    rightEdgePaint.shader = ui.Gradient.linear(
      rightEdgeOffsets[0],
      rightEdgeOffsets[1],
      [Colors.transparent, rightEdgeColor],
      [0.4,0.9]
    );

    bottomEdgePaint.shader = ui.Gradient.linear(
      bottomEdgeOffsets[0],
      bottomEdgeOffsets[1],
      [Colors.transparent, bottomEdgeColor],
      [0.4,0.9]
    );

    tilePaint.shader = ui.Gradient.linear(
      // offsetDirection[0], 
      // offsetDirection[1], 
      offset1,offset2,
      [color1, color2],
    );

    insideDecorationPaint.style = PaintingStyle.stroke;
    insideDecorationPaint.strokeCap = StrokeCap.round;
    insideDecorationPaint.strokeWidth = tileSize.width*0.05;

    insideDecorationPaint.color = insideDecorationColor;

    canvas.drawRRect(tileBorderRRect, rightEdgePaint);
    canvas.drawRRect(tileBorderRRect, bottomEdgePaint);
    canvas.drawRRect(tileRRect, tilePaint);
    // canvas.drawRRect(insideBorderDecorationRRect, insideDecorationPaint);
    AnimationUtils().displayAnimatingText(canvas, body, textColor, gamePlayState, tileFaceCenter,tileSize, palette);

    return canvas;    
  }


  // Canvas drawTileMenu(Canvas canvas, GamePlayState gamePlayState,) {

  //   // Map<String,dynamic>? openMenuTile = gamePlayState.openMenuTile;

  //   Map<String,dynamic> tileMenuAnimation = gamePlayState.animationData.firstWhere(
  //     (e)=>e["type"]=="tile-menu",
  //     orElse: ()=>{}
  //   );

  //   if (tileMenuAnimation.isNotEmpty) {

  //     // check if it's open or close
  //     double progress = tileMenuAnimation["progress"];


  //     Map<String,dynamic>? tileObject = tileMenuAnimation["animation"]["tile"];

  //     if (tileObject != null) {

  //       late double updatedProgress = progress;
  //       if (tileMenuAnimation["animation"]["open"]==false) {
  //         updatedProgress = (1.0-progress);
  //       }
  //       tileMenu(canvas,gamePlayState,tileObject,updatedProgress);


  //     }

  //   } else {

  //     Map<String,dynamic>? openMenuTile = gamePlayState.openMenuTile;
  //     if (openMenuTile != null ) {
  //       tileMenu(canvas,gamePlayState,openMenuTile,1.0);
  //     }
  //   }




  //   return canvas;
  // }

  // Canvas tileMenu(Canvas canvas, GamePlayState gamePlayState, Map<String,dynamic> openMenuTile, double progress) {
  //   Size tileSize = gamePlayState.elementSizes["tileSize"];

  //   Paint paint = Paint()
  //   ..color = ui.Color.fromRGBO(51, 51, 51, progress)
  //   ..style = PaintingStyle.fill;

  //   Paint optionPaint = Paint()
  //   ..color = ui.Color.fromRGBO(233, 233, 233, progress)
  //   ..style = PaintingStyle.stroke
  //   ..strokeWidth = tileSize.width*0.025
  //   ..strokeJoin = StrokeJoin.round;

  //   List<Map<String,dynamic>> menuData = openMenuTile["menuData"];

  //   Offset tileCenter = openMenuTile["center"];
  //   Path trianglePath = Path();
  //   trianglePath.moveTo(tileCenter.dx, (tileCenter.dy-tileSize.height/2) + (tileSize.width*0.1));
  //   trianglePath.lineTo(tileCenter.dx-(tileSize.width*0.2), (tileCenter.dy-(tileSize.height*1.2) + (tileSize.height*1.1)/2 ));
  //   trianglePath.lineTo(tileCenter.dx+(tileSize.width*0.2), (tileCenter.dy-(tileSize.height*1.2) + (tileSize.height*1.1)/2 ));
  //   canvas.drawPath(trianglePath, paint);  

  //   for (int i=0; i<menuData.length; i++) {
  //     Rect menuRect  = Rect.fromCenter(center: menuData[i]["center"], width: tileSize.width*1.1, height: tileSize.height*1.1);
  //     RRect menuRRect = RRect.fromRectAndRadius(menuRect, Radius.circular(tileSize.width*0.1));
  //     canvas.drawRRect(menuRRect, paint);
  //     Path optionPath = menuData[i]["path"];
  //     canvas.drawPath(optionPath, optionPaint);

  //     Offset position = menuData[i]["center"];
  //     String icon = menuData[i]["option"];
  //     drawOptionIcon(canvas,position,icon,tileSize,progress,color);
  //   }

  //   // for (int i=0; i<menuData.length;i++) {
  //   //   drawIconPrices(canvas,openMenuTile,menuData[i], tileSize,progress);
  //   // }
  //   return canvas;
  // }



  Canvas drawOptionIcon(Canvas canvas, Offset position, String icon, Size size,double progress, Color color) {
    // Offset position = optionData["center"];
    // String icon = optionData["option"];
    if (icon == "freeze") {
      // Color color = tileData["frozen"] ? Colors.blueAccent : Colors.white;
      drawSnowFlakeIcon(canvas, size, position,progress, color);
    } 
    
    if (icon == "swap") {
      drawSwapIcon(canvas, size, position,progress, color); 
    } 
    
    if (icon == "explode") {
      drawBombIcon(canvas, size, position,progress, color);
    }

    if (icon == "undo") {
      drawUndoIcon(canvas,size,position,progress,color);
    }
    return canvas;
  }

  // Canvas drawIconPrices(Canvas canvas,Map<String,dynamic>tileData, Map<String,dynamic> optionData, Size size,double progress) {
  //   Offset position = optionData["center"];
  //   Offset priceTagPosition = Offset(position.dx+size.width*0.3,position.dy-size.height*0.4);
  //   int price = optionData["cost"];

  //   late double fontSize = size.width*0.2;

  //   TextStyle textStyle = TextStyle(
  //     color: ui.Color.fromRGBO(0, 0, 0, progress), //const Color.fromARGB(190, 123, 191, 255),
  //     fontSize: fontSize,
  //     fontWeight: FontWeight.bold
  //   );
  //   TextSpan textSpan = TextSpan(
  //     text: price.toString(),
  //     style: textStyle,
  //   );
  //   final textPainter = TextPainter(
  //     text: textSpan,
  //     textDirection: TextDirection.ltr,
  //   );
  //   textPainter.layout();
  //   final textPosition = Offset(priceTagPosition.dx - (textPainter.width/2), priceTagPosition.dy - (textPainter.height/2));

  //   Paint paint = Paint()
  //   ..color = ui.Color.fromRGBO(253, 224, 59, progress);
  //   canvas.drawCircle(priceTagPosition, size.width*0.2, paint);


  //   Paint outlinePaint = Paint()
  //   ..color = ui.Color.fromRGBO(100, 65, 1, progress)
  //   ..style = PaintingStyle.stroke
  //   ..strokeWidth = size.width*0.03
  //   ..strokeCap = StrokeCap.round;
  //   canvas.drawCircle(priceTagPosition, size.width*0.2, outlinePaint);    

  //   textPainter.paint(canvas, textPosition);  
  //   return canvas;
  // }

  Canvas highlightTilesOpenForPerk(Canvas canvas, GamePlayState gamePlayState,) {

    Map<String,dynamic> openPerk = gamePlayState.tileMenuOptions.firstWhere((e)=>e["open"]==true,orElse: ()=>{});
    
    if (openPerk.isNotEmpty) {

      Size tileSize = gamePlayState.elementSizes["tileSize"];

      if (gamePlayState.isTutorial) {
        Map<String,dynamic> stepObject = Helpers().getTutorialStepObject(gamePlayState);
        for (int i=0; i<gamePlayState.tileData.length; i++) {
          if (gamePlayState.tileData[i]["key"]==stepObject["focusTile"]) {
            Offset targetCenter = gamePlayState.tileData[i]["center"];
            late double opacity = AnimationUtils().getHighlightEffectShadowOpacity(gamePlayState,gamePlayState.tileData[i]["key"]);
            // drawTileShadow(canvas,ui.Color.fromRGBO(255, 255, 255, opacity),ui.Color.fromRGBO(227, 210, 253, opacity),tileSize,targetCenter);            
          }
        }

      } else {
        for (int i=0; i<gamePlayState.tileData.length; i++) {
          Map<String,dynamic> tileObject = gamePlayState.tileData[i];
          
      
          if ( tileObject["body"]!="" || !tileObject["active"]) {
              Offset targetCenter = tileObject["center"];
            if (tileObject["swapping"]) {

            } else {
              late double opacity = AnimationUtils().getHighlightEffectShadowOpacity(gamePlayState,tileObject["key"]);
              drawTileShadow(canvas,ui.Color.fromRGBO(255, 255, 255, opacity),ui.Color.fromRGBO(227, 210, 253, opacity),tileSize,targetCenter);
            }
          }      
        }
      }

    }
    return canvas;
  }


  Canvas drawSwappingTileShadow(Canvas canvas, GamePlayState gamePlayState,) {

    Map<String,dynamic> swappingTile = gamePlayState.tileData.firstWhere((e)=>e["swapping"]==true, orElse: ()=>{});
    if (swappingTile.isNotEmpty) {
      Size tileSize = gamePlayState.elementSizes["tileSize"];
      Offset tileCenter = swappingTile["center"];

      drawTileShadow(canvas,Colors.white,Colors.white,tileSize,tileCenter);

      for (int i=0; i<gamePlayState.tileData.length; i++) {
        Map<String,dynamic> tileObject = gamePlayState.tileData[i];
        Map<String,dynamic> animatingObject = gamePlayState.animationData.firstWhere((e)=>e["key"]==tileObject["key"],orElse: ()=>{});
        
        bool isAnimating = animatingObject.isEmpty ? false : true;
        String body = tileObject["body"];
        bool frozen = tileObject["frozen"];
        bool swapping = tileObject["swapping"];
        

        if (!isAnimating && body!="" && !frozen && !swapping && !gamePlayState.isTutorial) {
          Offset targetCenter = tileObject["center"];

          late double opacity = AnimationUtils().getHighlightEffectShadowOpacity(gamePlayState,tileObject["key"]);
          drawTileShadow(canvas,ui.Color.fromRGBO(255, 255, 255, opacity),ui.Color.fromRGBO(227, 210, 253, opacity),tileSize,targetCenter);
        }
      }
    }

    return canvas;
  }

  Canvas drawTileShadow(Canvas canvas, Color color1, Color color2, Size tileSize, Offset tileCenter) {
      final double thicknessFactor = tileSize.width*0.05/2;
      final double radius = tileSize.width*0.15;
      final Offset tileFaceCenter = Offset(tileCenter.dx-thicknessFactor/2,tileCenter.dy-thicknessFactor/2);
      final Rect tileShadowRect = Rect.fromCenter(center: tileFaceCenter, width: tileSize.width, height: tileSize.height);
      final RRect tileShadowRRect = RRect.fromRectAndRadius(tileShadowRect, Radius.circular(radius));    

      Paint shadowPaintBlur = Paint()
      ..color = color1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = (tileSize.width*1.1)*0.5
      ..maskFilter = MaskFilter.blur(BlurStyle.outer, tileSize.width*0.03);

      Paint shadowPaint = Paint()
      ..color = color2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = (tileSize.width*1.1)*0.04;

      canvas.drawRRect(tileShadowRRect, shadowPaint);
      // canvas.drawRRect(tileShadowRRect, shadowPaintBlur);
      
      return canvas;
  }


  Canvas drawTileSwapAnimation(Canvas canvas, GamePlayState gamePlayState, ColorPalette palette) {
    List<Map<String,dynamic>> swapAnimations = gamePlayState.animationData.where((e)=>e["type"]=="tile-swap").toList();
    Size tileSize = gamePlayState.elementSizes["tileSize"];
    
    

    for (int i=0; i<swapAnimations.length; i++) {

      
      Map<String,dynamic> swapAnimation = swapAnimations[i];



      int sourceKey = swapAnimation["key"];
      int targetKey = swapAnimation["targetKey"];

      Map<String,dynamic> sourceTile = gamePlayState.tileData.firstWhere((e)=>e["key"]==sourceKey,orElse: ()=>{});
      Map<String,dynamic> targetTile = gamePlayState.tileData.firstWhere((e)=>e["key"]==targetKey,orElse: ()=>{});

      double progress = swapAnimation["progress"];

      if (sourceTile.isNotEmpty && targetTile.isNotEmpty) {
        print("EXECUTE THIS SHIT:drawTileSwapAnimation ");

        Offset sourceTileCenter = sourceTile["center"];
        Map<String,dynamic> sourceDecorationData = targetTile["decorationData"];
        Offset targetTileCenter = targetTile["center"];
        // Map<String,dynamic> targetDecorationData = targetTile["decorationData"];

        String body = targetTile["body"];
        String tileType = getTileType(sourceTile);

        double positionX = sourceTileCenter.dx + (targetTileCenter.dx-sourceTileCenter.dx)*progress;
        double positionY = sourceTileCenter.dy + (targetTileCenter.dy-sourceTileCenter.dy)*progress;

        Offset tilePosition = Offset(positionX,positionY);
        Size updatedSize = AnimationUtils().getSwappedTileSize(gamePlayState,swapAnimation);


        drawTile2(canvas, tilePosition, body, updatedSize, 'board-full',sourceDecorationData,palette);
      }
    }
    return canvas;
  }

  String getTileType(Map<String,dynamic> tileObject) {
    String res = "board";
    if (!tileObject["active"]) {
      res = "dead";
    }
    return res;
  }


  Canvas drawExplodingTile(Canvas canvas, GamePlayState gamePlayState, ColorPalette palette) {
    Map<String,dynamic> explodingAnimation = gamePlayState.animationData.firstWhere((e)=>e["type"]=="tile-explode",orElse: ()=>{});

    if (explodingAnimation.isNotEmpty) {

      int key = explodingAnimation["key"];

      Map<String,dynamic> tileObject = gamePlayState.tileData.firstWhere((e)=>e["key"]==key,orElse: ()=>{});

      if (tileObject.isNotEmpty) {

        double progress = explodingAnimation["progress"];
        Offset tileCenter = tileObject["center"];
        String tileType = explodingAnimation["tileType"]=="board"?"board-full":"dead";
        String tileBody = tileType == "board" ? "-" : "";
        Map<String,dynamic> decorationData = tileObject["decorationData"];

        for (int j=0; j<explodingAnimation["explosionData"].length;j++) {
          Map<String,dynamic> particleData = explodingAnimation["explosionData"][j];
          Map<String,dynamic> delayData = particleData["delay"];

          List<Map<String,dynamic>> opacityAnimationDetails = [
            {"source": 0.0, "target": 0.0, "duration": delayData["start"]},
            {"source": 0.0, "target": 1.0, "duration": delayData["rise"]},
            {"source": 1.0, "target": 1.0, "duration": delayData["middle"]},
            {"source": 1.0, "target": 0.0, "duration": delayData["decline"]},
            {"source": 0.0, "target": 0.0, "duration": delayData["end"]},
          ];      
          double opacityProgress = AnimationUtils().getAnimationTransition(progress,opacityAnimationDetails);            


          Color color = AnimationUtils().getParticleColor(particleData["color"],tileType,tileBody,decorationData);
          // print("r: ${color.r} | g: ${color.g} | b: ${color.b}");
          // Color updatedColor = Color.fromRGBO(color.r., color.g, color.b, opacityProgress);
          int red = (color.r * 255).round();
          int green = (color.g * 255).round();
          int blue = (color.b * 255).round();

          Color particleColor = Color.fromRGBO(red, green, blue, opacityProgress);
          
          Paint explosionPaint = Paint();
          explosionPaint.style = PaintingStyle.fill;
          explosionPaint.color = particleColor;

          final Offset particleCenter = particleData["center"];

          final double particleDistance = particleData["distance"] * progress;
          final Offset particlePosition = AnimationUtils().getParticlePoint(particleData["angle"], particleCenter, particleDistance);
          Path particleShape = AnimationUtils().getParticleShapePath(particlePosition,particleData["shape"]);
          
          canvas.drawPath(particleShape,explosionPaint);
        }


        Size tileSize = gamePlayState.elementSizes["tileSize"];

        // List<Map<String,dynamic>> updatedSizeFactorSequence = [
        //   {"source": 0.0, "target": 0.0, "duration": 0.70},
        //   {"source": 0.0, "target": 1.0, "duration": 0.30},
        // ];      
        // double updatedSizeFactor = AnimationUtils().getAnimationTransition(progress,updatedSizeFactorSequence); 
        final double updatedProgress = progress <= 0.5 ? 0.0 : (progress-0.5)*2;
        double updatedSizeFactor = 1.0*updatedProgress;
        Size updatedSize = Size(tileSize.width*updatedSizeFactor,tileSize.height*updatedSizeFactor);
        // paintAnimatingTile(canvas, tileCenter, gamePlayState, "", updatedSize,progress,"", "board-",decorationData);
        drawTile2(canvas, tileCenter, "", updatedSize, 'board-empty', decorationData, palette);  
      }


    }

    return canvas;
  }


  Canvas drawSnowFlakeIcon(Canvas canvas, Size size, Offset position,double progress, Color color) {

    final double red = color.r;
    final double green = color.g;
    final double blue = color.b;
    final Color updatedColor = Color.fromARGB((255*progress).floor(),(255*red).floor(),(255*green).floor(),(255*blue).floor());

    Paint iconPaint = Paint()
    ..color = updatedColor //ui.Color.fromRGBO(233, 233, 233, progress)
    ..style = PaintingStyle.stroke
    ..strokeWidth = size.width*0.04
    ..strokeCap = StrokeCap.round;

    final double branchLength = size.width*0.15;
    final double tridentLength = size.width*0.11;

    // Offset center = Offset(size.width/2,size.height/2);
    Path iconPath = Path();
    iconPath.moveTo(position.dx, position.dy);

    final int numSides = 6;
    final double angleIncrement = 360.0/numSides;

    for (int i=0; i<numSides; i++) {
      final double angle = (i * angleIncrement);
      // final double angleRadians = angle * (pi/180);
      final Offset branchEnd = Helpers().getCoordinatesFromDistanceAndAngle(position, angle, branchLength);

      iconPath.moveTo(position.dx, position.dy);
      iconPath.lineTo(branchEnd.dx, branchEnd.dy);

      final double tridentAngle = 90.0/2;

      for (int j=0; j<3; j++) {
        final double branchTridentAngle = -tridentAngle +(j*tridentAngle);
        // final double branchTridentAngleRadians = (angle+branchTridentAngle)*(pi/180.0);
        final double branchTridentAngleRadians = (angle+branchTridentAngle);
                
        final Offset branchTridentEnd = Helpers().getCoordinatesFromDistanceAndAngle(branchEnd, branchTridentAngleRadians, tridentLength);
        iconPath.moveTo(branchEnd.dx, branchEnd.dy);
        iconPath.lineTo(branchTridentEnd.dx, branchTridentEnd.dy);
      }
    }
    canvas.drawPath(iconPath,iconPaint);
    return canvas;
  }


  Canvas drawBombIcon(Canvas canvas, Size size, Offset position,double progress, Color color) {

    final double red = color.r;
    final double green = color.g;
    final double blue = color.b;
    final Color updatedColor = Color.fromARGB((255*progress).floor(),(255*red).floor(),(255*green).floor(),(255*blue).floor());

    Paint iconPaint = Paint()
    ..color = updatedColor //ui.Color.fromRGBO(233, 233, 233, progress)
    ..style = PaintingStyle.fill;

    Offset bombCenter = Offset(position.dx-size.width*0.14,position.dy+size.height*0.08);

    final double bombRadius = size.width*0.20;
    canvas.drawCircle(bombCenter, bombRadius, iconPaint);


    // square part at the top right of the bomb
    final double bombCollar1AngleRadians = 180.0;
    // final double bombCollar1Angle = bombCollar1AngleRadians * (pi/180.0);
    final Offset bombCollarPoint1 = Helpers().getCoordinatesFromDistanceAndAngle(bombCenter, bombCollar1AngleRadians, bombRadius);

    final double bombCollar2AngleRadians = 120.0;
    // final double bombCollar2Angle = bombCollar2AngleRadians * (pi/120.0);
    final Offset bombCollarPoint2 = Helpers().getCoordinatesFromDistanceAndAngle(bombCenter, bombCollar2AngleRadians, bombRadius);

    final double bombCollarAngleRadians = 150.0;
    // final double bombCollarAngle = bombCollarAngleRadians * (pi/180.0);
    final Offset bombCollarPoint3 = Helpers().getCoordinatesFromDistanceAndAngle(bombCollarPoint1, bombCollarAngleRadians, size.width*0.1);
    final Offset bombCollarPoint4 = Helpers().getCoordinatesFromDistanceAndAngle(bombCollarPoint2, bombCollarAngleRadians, size.width*0.1);

    Path bombCollarPath = Path();
    bombCollarPath.moveTo(bombCollarPoint1.dx, bombCollarPoint1.dy);
    bombCollarPath.lineTo(bombCollarPoint3.dx, bombCollarPoint3.dy);
    bombCollarPath.lineTo(bombCollarPoint4.dx, bombCollarPoint4.dy);
    bombCollarPath.lineTo(bombCollarPoint2.dx, bombCollarPoint2.dy);

    canvas.drawPath(bombCollarPath,iconPaint);

    final double collarDifferenceX = (bombCollarPoint4.dx-bombCollarPoint3.dx);
    final double collarDifferenceY = (bombCollarPoint4.dy-bombCollarPoint3.dy);

    Paint stringPaint = Paint()
    ..color = updatedColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = size.width*0.03
    ..strokeCap = StrokeCap.round;

    double stringBaseX = bombCollarPoint3.dx + (collarDifferenceX/2);
    double stringBaseY = bombCollarPoint3.dy + (collarDifferenceY/2);

    Path stringPath = Path();
    stringPath.moveTo(stringBaseX, stringBaseY);
    stringPath.quadraticBezierTo(
      stringBaseX+size.width*0.08, stringBaseY-size.width*0.15,
      stringBaseX+size.width*0.12, stringBaseY
    );
    stringPath.quadraticBezierTo(
      stringBaseX+size.width*0.19, stringBaseY+size.width*0.15,
      stringBaseX+size.width*0.28, stringBaseY+size.width*0.10
    );

    canvas.drawPath(stringPath, stringPaint);

    Offset sparkCenter = Offset(stringBaseX+size.width*0.28, stringBaseY+size.width*0.12);
    Path sparkPath = Path();
    
    final int numSparks = 6;
    for (int i=0; i<numSparks; i++) {
      final double angle = (360.0/numSparks)*i;
      // final double angleRadians = angle*(pi/180.0);
      final Offset sparkEnd = Helpers().getCoordinatesFromDistanceAndAngle(sparkCenter, angle, size.width*0.06);
      sparkPath.moveTo(sparkCenter.dx, sparkCenter.dy);
      sparkPath.lineTo(sparkEnd.dx, sparkEnd.dy);
    }
    canvas.drawPath(sparkPath, stringPaint);

    return canvas;
  }


  Canvas drawSwapIcon(Canvas canvas, Size size, Offset position,double progress, Color color) {

    final double red = color.r;
    final double green = color.g;
    final double blue = color.b;
    final Color updatedColor = Color.fromARGB((255*progress).floor(),(255*red).floor(),(255*green).floor(),(255*blue).floor());

    Paint iconPaint = Paint()
    ..color = updatedColor //ui.Color.fromRGBO(233, 233, 233, progress)
    ..style = PaintingStyle.stroke
    ..strokeWidth = size.width*0.06
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

    Offset topArrowStart = Offset(position.dx+size.width*0.22, position.dy);
    Path topArrowPath = Path();
    topArrowPath.moveTo(topArrowStart.dx, topArrowStart.dy);
    topArrowPath.lineTo(topArrowStart.dx, topArrowStart.dy-size.height*0.2);
    topArrowPath.lineTo(topArrowStart.dx-size.width*0.3, topArrowStart.dy-size.height*0.2);
    canvas.drawPath(topArrowPath, iconPaint);

    Offset topArrowHead = Offset(topArrowStart.dx-size.width*0.45,topArrowStart.dy-size.height*0.2);
    Path topArrowHeadPath = Path();
    topArrowHeadPath.moveTo(topArrowHead.dx+size.width*0.2, topArrowHead.dy-size.height*0.1);
    topArrowHeadPath.lineTo(topArrowHead.dx, topArrowHead.dy);
    topArrowHeadPath.lineTo(topArrowHead.dx+size.width*0.2, topArrowHead.dy+size.height*0.1);
    canvas.drawPath(topArrowHeadPath, iconPaint);


    Offset bottomArrowStart = Offset(position.dx-size.width*0.22, position.dy);
    Path bottomArrowPath = Path();
    bottomArrowPath.moveTo(bottomArrowStart.dx, bottomArrowStart.dy);
    bottomArrowPath.lineTo(bottomArrowStart.dx, bottomArrowStart.dy+size.height*0.2);
    bottomArrowPath.lineTo(bottomArrowStart.dx+size.width*0.3, bottomArrowStart.dy+size.height*0.2);
    canvas.drawPath(bottomArrowPath, iconPaint);

    Offset bottomArrowHead = Offset(bottomArrowStart.dx+size.width*0.45,bottomArrowStart.dy+size.height*0.2);
    Path bottomArrowHeadPath = Path();
    bottomArrowHeadPath.moveTo(bottomArrowHead.dx-size.width*0.2, bottomArrowHead.dy-size.height*0.1); 
    bottomArrowHeadPath.lineTo(bottomArrowHead.dx, bottomArrowHead.dy,);
    bottomArrowHeadPath.lineTo(bottomArrowHead.dx-size.width*0.2, bottomArrowHead.dy+size.height*0.1);
    canvas.drawPath(bottomArrowHeadPath, iconPaint);

    return canvas;
  }

  Canvas drawUndoIcon(Canvas canvas, Size size, Offset position,double progress, Color color) {

    final double red = color.r;
    final double green = color.g;
    final double blue = color.b;
    final Color updatedColor = Color.fromARGB((255*progress).floor(),(255*red).floor(),(255*green).floor(),(255*blue).floor());

    Paint iconPaint = Paint()
    ..color = updatedColor //ui.Color.fromRGBO(233, 233, 233, progress)
    ..style = PaintingStyle.stroke
    ..strokeWidth = size.width*0.06
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

    Path undoPath = Path();
    undoPath.moveTo(position.dx+size.width*0.2, position.dy+size.height*0.3);  
    undoPath.arcToPoint(
      Offset(position.dx-size.width*0.2 ,position.dy+size.height*0.2),
      radius: Radius.circular(size.width*0.25),
      clockwise: false,
      largeArc: true,
    );
    undoPath.relativeLineTo(-size.width*0.15, -size.height*0.15);
    undoPath.relativeLineTo(size.width*0.15, size.height*0.15);
    undoPath.relativeLineTo(size.width*0.15, -size.height*0.15);

    canvas.drawPath(undoPath, iconPaint);

    return canvas;
  }
}

