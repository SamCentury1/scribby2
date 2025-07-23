import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';

class StylingUtils {


  double getTileSize(Size playAreaSize, int numRows, int numCols) {
    late double res = 0.0;
    final double minTileSize = 10;
    final double maxTileSize = 80;
    final double safetyPadding = 30.0;

    late int maxAxisCount = max(numRows,numCols);
    late double updatedPlayAreaWidth = 0.0;
    if (playAreaSize.width-(2*safetyPadding) > playAreaSize.width*0.95) {
      updatedPlayAreaWidth = playAreaSize.width*0.95;
    } else {
      updatedPlayAreaWidth = playAreaSize.width - (2*safetyPadding);
    }

    late double optimalSize = double.parse( ((updatedPlayAreaWidth)/maxAxisCount) .toStringAsFixed(2));
  
    if (optimalSize < minTileSize) {
      res = minTileSize;
    } else if (optimalSize > maxTileSize) {
      res = maxTileSize;
    } else {
      res = optimalSize;
    }
    return res;
  }

  double getReserveTileSize(Size playAreaSize, int numCols) {
    late double res = 0.0;
    late double minTileSize = 10.0;
    late double maxTileSize = 60.0;
    late double reserveTileAreaWidth = playAreaSize.width*0.7;
    late double reserveTileSize = reserveTileAreaWidth/numCols;
    res = min(maxTileSize, reserveTileSize);
    return res;
  }

  List<Color> getTileFaceColors(Color baseColor) {
    List<Color> res = [];
    final Color color1 = baseColor;
    final Color color2 = Color.lerp(baseColor, Colors.black, 0.3)??color1;
    res = [color1,color2];
    return res;
  } 
  Map<String,dynamic> getTileFaceOffsets(Random random,) {
    late String baseAxis = random.nextInt(10) > 5 ? 'x' : 'y';

    final double freeAxis1 = (random.nextInt(100)-50) / 100;
    final double freeAxis2 = (random.nextInt(100)-50) / 100;

    late List<double> fixedAnchors = [-0.5,0.5];
    fixedAnchors.shuffle();

    late double dx1 = 0.0;
    late double dy1 = 0.0;

    late double dx2 = 0.0;
    late double dy2 = 0.0;

    if (baseAxis == 'x') {
      dx1 = fixedAnchors[0];
      dx2 = fixedAnchors[1];
      dy1 = freeAxis1;
      dy2 = freeAxis2;
    } else {
      dx1 = freeAxis1;
      dx2 = freeAxis2;
      dy1 = fixedAnchors[0];
      dy2 = fixedAnchors[1];    
    }

    final Map<String,dynamic> items = {"dx1":dx1, "dy1":dy1, "dx2":dx2, "dy2":dy2}; 
    return items;
  }

  Map<String,dynamic> generateNewTileStyle(GamePlayState gamePlayState, Random random) {
    Color previousColor = gamePlayState.tileDecorationData["previousColor"]; 
    Color newColor = gamePlayState.tileDecorationData["nextColor"]; 
    int interval = gamePlayState.tileDecorationData["interval"];
    // Size tileSize = gamePlayState.elementSizes["tileSize"];
    Color baseColor = Color.lerp(previousColor, newColor, (interval/50))??newColor;

    Map<String,dynamic> tileFaceOffsets = getTileFaceOffsets(random,);
    List<Color> faceColors = getTileFaceColors(baseColor);

    Map<String,dynamic> res = {
      // "tileFaceOffset1":tileFaceOffsets["offset1"],
      // "tileFaceOffset2":tileFaceOffsets["offset2"],
      "offsetData":tileFaceOffsets,
      "baseColor": baseColor,
      "bodyColor": Color.lerp(baseColor, Colors.white, 0.6)??baseColor,
      "edgeColors": [baseColor,Color.lerp(baseColor, Colors.black, 0.7)??Colors.black,],
      "faceColors":faceColors
    };
    return res;
  }
  
    

  List<Offset> getEdgeGradientOffsets(Offset tileBorderCenter, Size tileSize, String side) {
    late List<Offset> res = [];
    if (side=='right') {
      res = [
        Offset(tileBorderCenter.dx-((tileSize.width*1.5)/2), tileBorderCenter.dy),
        Offset(tileBorderCenter.dx+((tileSize.width*1.5)/2), tileBorderCenter.dy),    
      ];    
    } else if (side=='bottom') {
      res = [
          Offset(tileBorderCenter.dx, tileBorderCenter.dy-((tileSize.width*1.5)/2)),
          Offset(tileBorderCenter.dx, tileBorderCenter.dy+((tileSize.width*1.5)/2)), 
      ];
    }
    return res;
  }        

  List<Offset> getGradientOffset(Offset tileCenter, Size tileSize, int gradientIndex) {
    late Offset topLeft = Offset(tileCenter.dx-(tileSize.width/2),tileCenter.dy-(tileSize.height/2));
    late Offset topRight = Offset(tileCenter.dx+(tileSize.width/2),tileCenter.dy-(tileSize.height/2));
    late Offset bottomLeft = Offset(tileCenter.dx-(tileSize.width/2),tileCenter.dy+(tileSize.height/2));
    late Offset bottomRight = Offset(tileCenter.dx+(tileSize.width/2),tileCenter.dy+(tileSize.height/2));
    final List<List<Offset>> offsets = [
      [topLeft,bottomRight],
      [bottomRight,topLeft],
      [bottomLeft,topRight],
      [topRight,bottomLeft],
    ];
    return offsets[gradientIndex];
  }


  int convertLerpToHexCode(String code1, String code2, double tValue) {
    Color color1 = Color(int.parse(code1.replaceFirst('#', '0xFF')));
    Color color2 = Color(int.parse(code2.replaceFirst('#', '0xFF')));

    Color resultColor = Color.lerp(color1, color2, tValue) ?? color1;
    String prefix = "0xFF"; 
    String val = resultColor.value.toRadixString(16);
    String resultAsHex = "$prefix$val".toUpperCase();
    int result = int.parse(resultAsHex);
    return result; 

    // return result;
  }



  Color getColorLerp(List<Map<String,dynamic>> data, double progress) {
    double runningWeight = 0.0;
    Color res = Colors.transparent;

    for (int i=0; i<data.length;i++) {
      double duration = data[i]["duration"];
      data[i]["start"] = runningWeight;
      data[i]["end"] = runningWeight + duration;
      runningWeight = runningWeight + duration;
    }


    Map<String,dynamic> sequence = data.firstWhere((e)=>e["start"]<=progress && e["end"]>=progress,orElse: ()=>{});
    if (sequence.isNotEmpty) {
      Color sourceColor = sequence["source"];
      Color targetColor = sequence["target"];  
      double start = sequence["start"];
      double duration = sequence["duration"];
      double t = (progress-start)/duration;
      res = Color.lerp(sourceColor, targetColor, t)??Colors.transparent;
    }
    return res;
  }

  Path getBadgePath(List<Map<String,dynamic>> points, final double inc) {
    Path elementPath = Path();
    for (Map<String,dynamic> curve in points) {
      if (curve["type"] == "start") {
        elementPath.moveTo(curve["data"][0]*inc, curve["data"][1]*inc);
      }
      if (curve["type"] == "curve") {
        elementPath.quadraticBezierTo(
          curve["data"][0][0]*inc, curve["data"][0][1]*inc,
          curve["data"][1][0]*inc, curve["data"][1][1]*inc,
        );
      }
      if (curve["type"]=="line") {
        elementPath.lineTo(curve["data"][0]*inc,curve["data"][1]*inc);
      }
      if (curve["type"] == "end") {
        elementPath.close();
      }      
    }
    return elementPath;
    
  }    

}