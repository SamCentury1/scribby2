import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/functions/styling_utils.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/painters/tile_painters.dart';

class AnimationUtils {


  List<Map<String,dynamic>> getParticleData(Offset origin, Size tileSize) {
    
    Random random = Random();
    double randomDouble(double min, double max) {
      return (random.nextDouble() * (max - min) + min);
    }
  
    List<Map<String,dynamic>> res = [];
    for (int i=0; i < 100; i++) { 
      final double randomAngle = random.nextInt(359)*1.0;
      final double originDistance = randomDouble(0.0, tileSize.width/2);
      final Offset center = getParticlePoint(randomAngle,origin,originDistance);
      final double startDelay = randomDouble(0.0, 0.1);
      final double rise = randomDouble(0.1, 0.3);
      final double decline = randomDouble(0.1, 0.3);
      final double endDelay = randomDouble(0.0, 0.3);
      final double duration = 1.0 - (startDelay+endDelay+rise+decline);
      final double distance = random.nextInt(70) + 10;
      final double color = (random.nextInt(100)) / 100;
      // final double size = (random.nextInt(tileSize.width*0.02)+10)/10;
      final double size = randomDouble(tileSize.width*0.001, tileSize.width*0.005);
      final int points = 4;//random.nextInt(3)+2;
      final double angleBase = 360 / points;
      final List<Map<String,dynamic>> shapeData = [];

      for (int i=0;i<points;i++) {
        
        late double variation = 0.0;
        if (i == 0) {
          variation = random.nextDouble() * 20;
        } else if (i==points) {
          variation = random.nextDouble() * 20;
        } else {
          variation = randomDouble(-20,20);
        }
        final double angle = (i*angleBase) + num.parse(variation.toStringAsFixed(2));
        final double distance = (random.nextInt(40)+10)/10;
        shapeData.add({"angle":angle, "distance": distance});
      }

      res.add({
        "center": center,
        "angle":randomAngle, 
        "delay":{"start":startDelay,"rise":rise , "middle":duration, "decline":decline , "end":endDelay}, 
        "distance": distance, 
        "color":color,
        "size": size,
        "shape": shapeData
      });
    }
    return res;
  }

  List<Map<String,dynamic>> getFireworksData(Offset origin, Size tileSize) {
    Random random = Random();
    double randomDouble(double min, double max) {
      return (random.nextDouble() * (max - min) + min);
    }
    List<Map<String,dynamic>> res = [];
    for (int i=0; i < 100; i++) { 
      final double randomAngle = random.nextInt(359)*1.0;
      final double originDistance = randomDouble(0.0, tileSize.width/2);
      final Offset center = getParticlePoint(randomAngle,origin,originDistance);
      final double startDelay = randomDouble(0.0, 0.1);
      final double rise = randomDouble(0.1, 0.3);
      final double decline = randomDouble(0.1, 0.3);
      final double endDelay = randomDouble(0.0, 0.3);
      final double duration = 1.0 - (startDelay+endDelay+rise+decline);
      final double distance = random.nextInt(70) + 10;
      final double color = (random.nextInt(100)) / 100;
      // final double size = (random.nextInt(tileSize.width*0.02)+10)/10;
      final double size = randomDouble(tileSize.width*0.001, tileSize.width*0.005);

      res.add({
        "center": center,
        "angle":randomAngle, 
        "delay":{"start":startDelay,"rise":rise , "middle":duration, "decline":decline , "end":endDelay}, 
        "distance": distance, 
        "color":color,
        "size": size,
      });
    }
    return res;
  }


  TextPainter displayAnimatingText(Canvas canvas, String body, Color color, GamePlayState gamePlayState, Offset location, Size tileSize, ColorPalette palette) {
    final double minTileSize = gamePlayState.minimumTileSize;
    final double minFontSize = gamePlayState.minimumFontSize;

    double fontSize = double.parse(((minFontSize / minTileSize) * tileSize.width).toStringAsFixed(2));

    TextStyle textStyle = palette.tileFont(
      textStyle: TextStyle(
        color: color,
        fontSize: fontSize,
      ),
    );

    TextSpan textSpan = TextSpan(
      text: body,
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: ui.TextDirection.ltr,
    );

    textPainter.layout();
    final position = Offset(location.dx - (textPainter.width / 2), location.dy - (textPainter.height / 2));
    textPainter.paint(canvas, position);

    return textPainter;
  }  


  Color getParticleColor(double index, String type, String body, Map<String,dynamic> decorationData, ColorPalette palette) {
    // String body = type == "board" ? "-" : "";
    Map<String,dynamic> tilePaint = TilePainters().getPaintSet(type,body,decorationData,palette);
    Color res = Colors.transparent;

    if (index>=0.0 && index < 0.40) {
      res = tilePaint["faceColor1"];
    } else if (index>=0.40 && index < 0.80) {
      res = tilePaint["faceColor2"];
    } else if (index>=0.80 && index < 0.90) {
      res = tilePaint["textColor"];
    } else if (index>=0.90 && index < 0.93) {
      res = tilePaint["rightEdgeColor"];
    } else if (index>=0.93 && index < 0.96) {
      res = tilePaint["bottomEdgeColor"];
    } else if (index>=0.96 && index < 1.00) {
      res = tilePaint["insideDecorationColor"];
    }
    return res;
  }

  Color getFireworksColor(double index, Color baseColor) {
    Color res = Colors.transparent;
    res = Color.lerp(baseColor, Colors.white, index)??baseColor;
    return res;
  }

  List<Map<String,dynamic>> generateFireworksData(Size screenSize) {
    Random random = Random();

    // final int numExplosions = random.nextInt(10)+10;

    final int numCols = 3;
    final int numRows = random.nextInt(3)+5;

    final int numExplosions = numCols*numRows;
    List<int> orders = List.generate(numExplosions, (v)=>v+1);
    // orders.shuffle();

    // int count = 0;
    List<Map<String,dynamic>> res = [];
    for (int col=1; col<(numCols+1); col++) {
      for (int row=1; row<(numRows+1); row++) {

        int idx = random.nextInt(orders.length);
        orders.removeAt(idx);

        double sectionCenterX = ((screenSize.width/3)/2)*(col) ;
        double sectionCenterY = ((screenSize.height/3)/2)*(row);

        double dx = sectionCenterX + random.nextDouble() * (screenSize.width/3) - ((screenSize.width/3)/2);
        double dy = sectionCenterY + random.nextDouble() * (screenSize.height/3) - ((screenSize.height/3)/2);

        Offset fireworksCenter = Offset(dx, dy);
        List<Map<String,dynamic>> explosionData = getFireworksData(fireworksCenter,Size(200,200));

        final double startDelay = 0.3 + (idx/numExplosions)*0.4;
        final double main = 0.2;
        final double endDelay = 1.0-(startDelay+main);

        List<Map<String,dynamic>> fireworksProgressAnimationDetails = [
          {"source": 0.0, "target": 0.0, "duration": startDelay},
          {"source": 0.0, "target": 1.0, "duration": main},
          {"source": 1.0, "target": 1.0, "duration": endDelay},
        ];

        res.add({"explosionData":explosionData,"progressDetails":fireworksProgressAnimationDetails});      
      }    
    }
    return res;
  }

  Offset getParticlePoint(double angle, Offset? point, double distance) {
    late double angleThetaRadians = angle * pi / 180;
    double a = distance * sin(angleThetaRadians);
    double b = distance * cos(angleThetaRadians);

    late double targetPointX = point!.dx + b;
    late double targetPointY = point!.dy + a;
    return Offset(targetPointX, targetPointY);
  }  

  Path getParticleShapePath(Offset origin, List<Map<String,dynamic>> shapeData) {
    Path path = Path();
    Offset firstPoint = getParticlePoint(shapeData[0]["angle"], origin, shapeData[0]["distance"]);
    path.moveTo(firstPoint.dx, firstPoint.dy);
    for (int i=1; i<shapeData.length; i++) {
      Offset point = getParticlePoint(shapeData[i]["angle"], origin, shapeData[i]["distance"]);
      path.lineTo(point.dx, point.dy);
    }
    return path;
  }

  Map<String, dynamic> getTileDropSourceData(GamePlayState gamePlayState) {
    Map<String, dynamic> res = {};
    List<Map<String, dynamic>> tapUpAnimations = gamePlayState.animationData.where((e) => e["type"] == "tap-up").toList();
    final Size tileSize = gamePlayState.elementSizes["tileSize"];
    final double randomLetterCenterY = gamePlayState.elementPositions["randomLettersCenter"].dy;
    final double randomLetter1CenterX = gamePlayState.elementPositions["randomLettersCenter"].dx;
    final Offset randomLetter1Center = Offset(randomLetter1CenterX, randomLetterCenterY);
    final double boardWidth = tileSize.width * gamePlayState.gameParameters["rows"];// Helpers().getNumAxis(gamePlayState.tileData)[0];
    final double randomLetter2CenterX = ((gamePlayState.elementSizes["screenSize"].width - boardWidth) / 2) + (boardWidth / 2) + (boardWidth / 2) / 2;

    if (tapUpAnimations.isNotEmpty) {
      if (tapUpAnimations.length >= 2) {
        Map<String, dynamic> previousAnimationObject = tapUpAnimations[tapUpAnimations.length - 1];
        double progress = previousAnimationObject["progress"];
        final double dx2 = randomLetter2CenterX + ((randomLetter1CenterX - randomLetter2CenterX) * progress);
        final Offset animatedCenter2 = Offset(dx2, randomLetterCenterY);
        final double animatedWidth2 = tileSize.width * 1.5 * progress;
        final Size animatedSize2 = Size(animatedWidth2, animatedWidth2);
        res = {"location": animatedCenter2, "size": animatedSize2};
      } else {
        Map<String, dynamic> previousAnimationObject = tapUpAnimations.last;
        double progress = previousAnimationObject["progress"];
        final double dx1 = randomLetter2CenterX + ((randomLetter1CenterX - randomLetter2CenterX) * progress);
        final Offset animatedCenter1 = Offset(dx1, randomLetterCenterY);
        final double animatedWidth1 = tileSize.width + (((tileSize.width * 1.5) - tileSize.width) * progress);
        final Size animatedSize1 = Size(animatedWidth1, animatedWidth1);
        res = {"location": animatedCenter1, "size": animatedSize1};
      }
    } else {
      res = {"location": randomLetter1Center, "size": tileSize * 1.5};
    }

    // print("Resulting Source Data: $res");
    return res;
  }  


  double getBonusXValue(GamePlayState gamePlayState,String bonusType) {
    Size scoreboardArea = gamePlayState.elementSizes["scoreboardAreaSize"];
    Offset scoreboardCenter = gamePlayState.elementPositions["scoreboardCenter"];
    double bonusElementSize = 32.0 * gamePlayState.scalor; //tileSize.width*0.6;
    Size iconSize = Size(bonusElementSize*0.6,bonusElementSize*0.6);

    late int i = 0;
    late double sbHalf = ((scoreboardArea.width*0.95)/2);
    late Offset sbCenter = scoreboardCenter;
    late double scaledIcon = ((60*gamePlayState.scalor) * gamePlayState.scalor);
    if (bonusType=="streak") {
      i=0;
    } else if (bonusType=="words") {
      i=2;
    } else if (bonusType=="cross") {
      i=1;
    } else {
      i=-1;
    }
    late double bonusX = sbCenter.dx - sbHalf + scaledIcon + iconSize.width + (i*(bonusElementSize+(28*gamePlayState.scalor)));
    return bonusX;
  }


  // When a word is found an animation plays in three parts
  // 1. tiles are highlighted and highlighted with changing colors
  // 2. tile size oscillates for two cycles
  // 3. tiles converge to the center of their respective group
  // 4. explosion 
  // 5. a value of the points hovers there 
  List<Map<String,dynamic>> generateWordFoundAnimationData(GamePlayState gamePlayState, ColorPalette palette, int turn,int stops) {

    final double delayGap = 0.05;
    final double highlightSection = 0.00;
    final double oscillatingSection = 0.50;
    final double convergeSection = 0.10;
    final double hiddenSection = 0.25;
    final double endSection = 0.10;

    List<Map<String,dynamic>> animationParameters = [];

    Map<String,dynamic> turnData = gamePlayState.scoreSummary.firstWhere((e)=>e["turn"]==turn,orElse:()=>{});
    if (turnData.isNotEmpty) {

      Size tileSize = gamePlayState.elementSizes["tileSize"];
      List<Map<String,dynamic>> ids = turnData["ids"];

      
      for (int i=0; i<ids.length; i++) {

        final int key = ids[i]["id"];

        final Offset explosionCenter = Offset(gamePlayState.elementSizes["screenSize"].width*0.8,0.0);

        final double startDelaySection = double.parse(((i/ids.length)*delayGap).toStringAsFixed(4));
        final double endDelaySection = double.parse((((ids.length-i)/ids.length)*delayGap).toStringAsFixed(4));

        final int startDelaySectionStops = (stops*startDelaySection).round();
        final int highlightSectionStops = (stops*highlightSection).round();
        final int oscillatingSectionStops = (stops*oscillatingSection).round();
        final int convergeSectionStops = (stops*convergeSection).round();
        final int hiddenSectionStops = (stops*hiddenSection).round();
        final int endSectionStops = (stops*endSection).round();
        final int endDelaySectionStops = (stops*endDelaySection).round();
        final int totalStops = startDelaySectionStops+highlightSectionStops+oscillatingSectionStops+convergeSectionStops+hiddenSectionStops+endSectionStops+endDelaySectionStops;
        
        Map<String,dynamic> animationSections = {
          "startDelaySection":startDelaySection,
          "highlightSection":highlightSection,
          "oscillatingSection":oscillatingSection,
          "convergeSection":convergeSection,
          "hiddenSection":hiddenSection,
          "endSection":endSection,
          "endDelaySection":endDelaySection,
        };

        Map<String,dynamic> tileObject = gamePlayState.tileData.firstWhere((e)=>e["key"]==key,orElse: ()=>{});
        List<double> sizeValues = [];
        List<Offset> coords = [];
        List<int> colors = [];
        List<double> opacity = [];

        List<double> waveYData = Helpers().generateWave(numPoints: oscillatingSectionStops, amplitude: 0.15, frequency: 2.0, phaseShift: 0.0,dampingFactor: 1.0);
        List<double> oscillatingColorData = Helpers().generateWave(numPoints: totalStops, amplitude: 0.5, frequency: 5.0, phaseShift: 0.0, dampingFactor: 1.0);

        // Color color1 = 
        var color1 = '#${palette.gameplayWordFound1.value.toRadixString(16)}';
        var color2 = '#${palette.gameplayWordFound2.value.toRadixString(16)}';
        var tileFace1 = '#${palette.gameplayEmptyTileFill1.value.toRadixString(16)}';
        var tileFace2 = '#${palette.gameplayEmptyTileFill2.value.toRadixString(16)}';

        if (tileObject.isNotEmpty) {

          for (int j=0; j<startDelaySectionStops; j++) {
            sizeValues.add(tileSize.width);
            coords.add(tileObject["center"]);

            double val = oscillatingColorData[j]+0.5;
            int hexCode = StylingUtils().convertLerpToHexCode(color1, color2,val);
            colors.add(hexCode);  
            opacity.add(1.0);        
          }

          for (int j=0; j<highlightSectionStops; j++) {
            sizeValues.add(tileSize.width);
            coords.add(tileObject["center"]);

            double val = oscillatingColorData[j]+0.5;
            int hexCode = StylingUtils().convertLerpToHexCode(color1, color2,val);
            colors.add(hexCode);  
            opacity.add(1.0);            
          }

          for (int j=0; j<oscillatingSectionStops; j++) {
            double sizeFactor = tileSize.width* (1.0+waveYData[j]);
            sizeValues.add(sizeFactor);
            coords.add(tileObject["center"]);

            double val = oscillatingColorData[j]+0.5;
            int hexCode = StylingUtils().convertLerpToHexCode(color1, color2,val);
            colors.add(hexCode);
            opacity.add(1.0);        
          }

          for (int j=0; j<convergeSectionStops; j++) {
            double inc = (j/convergeSectionStops);
            double sizeFactor = tileSize.width*(1.0-inc);
            sizeValues.add(sizeFactor);

            double dx = tileObject["center"].dx - (tileObject["center"].dx - explosionCenter.dx)*inc;
            double dy = tileObject["center"].dy - (tileObject["center"].dy - explosionCenter.dy)*inc;

            Offset center = Offset(dx,dy);
            coords.add(center);

            double val = oscillatingColorData[j]+0.5;
            int hexCode = StylingUtils().convertLerpToHexCode(color1, color2,val);
            colors.add(hexCode);
            opacity.add(1.0);
          }

          for (int j=0; j<hiddenSectionStops; j++) {
            sizeValues.add(0.0);
            coords.add(tileObject["center"]);

            double val = oscillatingColorData[j]+0.5;
            int hexCode = StylingUtils().convertLerpToHexCode("#00FFFFFF", "#00FFFFFF",val);
            colors.add(hexCode);
            opacity.add(0.0);              
          }

          for (int j=0; j<endSectionStops; j++) {
            // double inc = (j/convergeSectionStops);
            // double sizeFactor = tileSize.width*(inc);
            // sizeValues.add(sizeFactor);
            sizeValues.add(tileSize.width);
            coords.add(tileObject["center"]);

            int hexCode = StylingUtils().convertLerpToHexCode(tileFace1, tileFace2,0.5);
            colors.add(hexCode);

            double inc = (j/convergeSectionStops);
            double opacityFactor = 1.0*(inc);
            opacity.add(opacityFactor);
          }

          for (int j=0; j<endDelaySectionStops; j++) {
            sizeValues.add(tileSize.width);
            coords.add(tileObject["center"]);  


            int hexCode = StylingUtils().convertLerpToHexCode(tileFace1, tileFace2,0.5);
            colors.add(hexCode);  
            opacity.add(1.0);                
          }

        }

        animationParameters.add({
          "key":key, 
          "sizeData": sizeValues, 
          "coords":coords, 
          "opacity": opacity,
          "color": colors, 
          // "explosionData":explosionData, 
          "sections": animationSections
        });
      }
    }
    return animationParameters;
  }


  List<Map<String,dynamic>> getScoreboardOscillatingColorSequence(int duration) {

    // 3 waves per second max. one wave every 300ms
    int waves = (duration/300).floor();

    Color yellow = const Color.fromARGB(255, 240, 227, 118);
    Color red = const Color.fromARGB(255, 253, 154, 147);

    
    double waveDuration = double.parse((1.0/(waves*2)).toStringAsFixed(2));
    double total = 0.0; 

    double total2 = (waveDuration *2) * waves;
    double gap = 1.0-(total2);

    List<Map<String,dynamic>> colorSequence = [];

    if (gap>0 ) {
      colorSequence = [
        {"source": yellow, "target": red, "duration": gap/2},
        {"source": red, "target": yellow, "duration": gap/2}
      ];
    }

    for (int i=0;i<waves;i++) {
      colorSequence.add({"source": yellow, "target": red, "duration": waveDuration});
      total = total+(waveDuration);
      colorSequence.add({"source": red, "target": yellow, "duration": waveDuration});
      total = total+(waveDuration);
    }

    return colorSequence;
  }


  double getAnimationTransition(double progress, List<Map<String,dynamic>> animationDetails) {
    double runningWeight = 0.0;
    for (int i=0; i<animationDetails.length;i++) {
      double duration = animationDetails[i]["duration"];
      animationDetails[i]["start"] = runningWeight;
      animationDetails[i]["end"] = runningWeight + duration;
      runningWeight = runningWeight + duration;
    }
    double res = 0.0;

    Map<String,dynamic> sequence = animationDetails.firstWhere((e)=>e["start"]<=progress && e["end"]>progress,orElse: ()=>{});
    if (sequence.isNotEmpty) {
      double source = sequence["source"];
      double target = sequence["target"];  
      double start = sequence["start"];
      double duration = sequence["duration"];
      double t = (progress-start)/duration;
      res = source + (target-source)*t;
    }
    return res;
  }

  Map<String,dynamic> getScoreCountAnimationDuration(int score, int minDuration, int maxDuration) {

    int minDurationMs = minDuration;//750;
    int maxDurationMs = maxDuration;//5500;
    const int minInterval = 20;

    late int interval = 50;
    late int increment = 1;

    late int target = score;
    
    int standardDuration = score * interval;
    // if the duration is less than the minimum duration - adjust interval to make it bigger
    if (standardDuration < minDurationMs) {
      interval = (minDurationMs/score).floor();
    }
    // if the duration is more than the maximum duration - adjust interval to make it smaller
    else if (standardDuration > maxDurationMs) {
      int potentialInterval = (maxDurationMs/score).floor();
      // if the interval is smaller than the minimum interval - adjust the increment to make it bigger
      if (potentialInterval < minInterval) {
        interval = minInterval;
        increment = (score/(maxDurationMs/interval).floor()).ceil();
        target =  (score/increment).floor();
      } else {
        interval = potentialInterval;
      }
    }
    
    int duration = target * interval;

    Map<String,dynamic> res = {
      "target": target,
      "interval": interval,
      "duration": duration,
      "increment": increment,
    };
    return res;
  }


  Size getSwappedTileSize(GamePlayState gamePlayState, Map<String,dynamic> animationObject) {
    Size tileSize = gamePlayState.elementSizes["tileSize"];
    double progress = animationObject["progress"];

    List<Map<String,dynamic>> elevationAnimationDetails = [
      {"source": 1.0, "target": 0.0, "duration": 0.15},
      {"source": 0.0, "target": 0.0, "duration": 0.70},
      {"source": 0.0, "target": 1.0, "duration": 0.15},
    ];
    double sizeFactor = getAnimationTransition(progress,elevationAnimationDetails);
    if (progress>=1.0) {
      sizeFactor = 1.0;
    }        
    double sizeValue = tileSize.width*sizeFactor;
    Size actualSize = Size(sizeValue,sizeValue);
    return actualSize;
  }


  List<Map<String,dynamic>> getAllIdsInPreFoundWordAnimation(GamePlayState gamePlayState, int turn) {

    Map<String,dynamic> turnData = gamePlayState.scoreSummary.firstWhere((e)=>e["turn"]==turn,orElse: ()=>{});
    List<Map<String,dynamic>> res = [];
    if (turnData["moveData"]["type"]=="swap") {
      List<int> keys = res.map((e)=>e["id"]as int).toList();
      Map<String,dynamic> source = turnData["moveData"]["data"]["source"];
      Map<String,dynamic> target = turnData["moveData"]["data"]["target"];
      for (int i=0; i<turnData["ids"].length;i++) {
        res.add({"id":turnData["ids"][i]["id"],"body":turnData["ids"][i]["body"]});
      }

      if (!keys.contains(source["key"])) {
        res.add({"id":source["key"],"body":source["body"]});
      }

      if (!keys.contains(target["key"])) {
        res.add({"id":target["key"],"body":target["body"]});
      }      

    } else {
      res = turnData["ids"];
    }

    return res;
  }


  Map<String,dynamic> getAnimationDuration(GamePlayState gamePlayState, String type) {
    String animationType = "";
    if (type == "placed") {
      animationType = "tap-up";
      
    } else if (type == "dropped") {
      animationType = "tile-drop";
    
    } else if (type == "freeze") {
      animationType = "tile-freeze";
    
    } else if (type == "swap") {
      animationType = "tile-swap";
    } else if (type=="explode") {
      animationType="explode";
    }
    Map<String,dynamic> animationDurationData = gamePlayState.animationLengths.firstWhere((e)=>e["type"]==animationType); 
    return animationDurationData;
  }


  double getHighlightEffectShadowOpacity(GamePlayState gamePlayState, int tileId) {
    int totalTiles = gamePlayState.tileData.length;
    int duration = gamePlayState.highlightEffectDuration.inMilliseconds;
    if (totalTiles <= 0) return 0.4; // Prevent division by zero

    // Base frequency for a full cycle in 1000ms
    const double baseFrequency = 2 * pi / 1000;

    // Assign a unique speed factor to each tile (between 0.8x and 1.2x speed variation)
    double speedFactor = 0.8 + (tileId % totalTiles) * (0.4 / (totalTiles - 1));

    // Calculate frequency per tile
    double tileFrequency = baseFrequency * speedFactor;

    // Phase shift to ensure different wave offsets
    double phaseShift = (tileId % totalTiles) * (2 * pi / totalTiles);

    // Normalize sine wave to range 0.0 - 1.0
    return 0.4 + 0.3 * (sin(duration * tileFrequency + phaseShift) + 1);
  }

  double getOscillatingEffect(double progress, int stop, int stops ) {
    // int totalTiles = gamePlayState.tileData.length;
    // int duration = gamePlayState.highlightEffectDuration.inMilliseconds;
    int duration = (progress * 10000).floor();

    const double baseFrequency = 2 * pi / 1000;
    // Assign a unique speed factor to each tile (between 0.8x and 1.2x speed variation)
    double speedFactor = 0.4 + (stop % stops) * (0.4 / (stops - 1));

    // Calculate frequency per tile
    double tileFrequency = baseFrequency * speedFactor;

    // Phase shift to ensure different wave offsets
    double phaseShift = (stop % stops) * (2 * pi / stops);

    double res = 0.4 + 0.3 * (sin(duration * tileFrequency + phaseShift) + 1);
    return res;
  }


double getLoadingDotsOscillatingEffect(double progress, int index ) {
  // int totalTiles = gamePlayState.tileData.length;
  // int duration = gamePlayState.highlightEffectDuration.inMilliseconds;
  int duration = (progress*100).floor();

  const double baseFrequency = 2 * pi / 1000;
  // Assign a unique speed factor to each tile (between 0.8x and 1.2x speed variation)
  double speedFactor = 0.08;

  // Calculate frequency per tile
  double tileFrequency = baseFrequency * speedFactor;

  // Phase shift to ensure different wave offsets
  double phaseShift =  (2 * pi / (index+1));

  double res = 0.4 + 0.3 * (sin(duration * tileFrequency + phaseShift) + 1);
  return res;
}

  double getPlusNPointsOpacity(double progress) {
    double res = progress * 2;
    if (progress >= 0.5 ) {
      res = (1-progress) * 2;
    }
    return res;
  }

  double getAcceleratedProgress(double progress, double accelerator,) {
    double res = progress*accelerator;
    double limit = 1.0/accelerator;

    if (progress < limit) {
      res = progress*accelerator;
    } else {
      res = 0.0;
    }
    return res;
  }

  Color getPlusNPointsColor(double progress, ColorPalette palette) {
    Color res = Colors.transparent;
    Color baseColor = palette.text1; // Colors.white;
    Color yellow = palette.scoreboardAnimationBorder1; //const Color.fromARGB(255, 240, 227, 118);
    Color red = palette.scoreboardAnimationBorder2; //const Color.fromARGB(255, 253, 154, 147);

    List<Map<String,dynamic>> data = [
      {"source": Colors.transparent, "target": baseColor, "duration": 0.15},
      {"source": baseColor, "target": yellow, "duration": 0.15},
      {"source": yellow, "target": red, "duration": 0.2},
      {"source": red, "target": yellow, "duration": 0.2},
      {"source": yellow, "target": baseColor, "duration": 0.15},
      {"source": baseColor, "target": Colors.transparent, "duration": 0.15},
    ];

    res = StylingUtils().getColorLerp(data,progress);
    return res;
  }

  Color getPlusNPerksColor(double progress, ColorPalette palette) {
    Color res = Colors.transparent;
    Color baseColor = palette.text1; // Colors.white;
    Color glow = Color.lerp(baseColor,Colors.transparent,0.2)??palette.text1;

    List<Map<String,dynamic>> data = [
      {"source": Colors.transparent, "target": baseColor, "duration": 0.15},
      {"source": baseColor, "target": glow, "duration": 0.15},
      {"source": glow, "target": baseColor, "duration": 0.2},
      {"source": baseColor, "target": glow, "duration": 0.2},
      {"source": glow, "target": baseColor, "duration": 0.15},
      {"source": baseColor, "target": Colors.transparent, "duration": 0.15},
    ];

    res = StylingUtils().getColorLerp(data,progress);
    return res;
  }  


  double getAdjustedProgress(int index, int countAnimations, double progress, int durationMs) {
    double res = 0.0;
    double animDuration = durationMs/countAnimations; //double.parse((durationMs/countAnimations).toStringAsFixed(2));
    double durationAdjustment = (animDuration + (countAnimations-1) * (animDuration/2))/durationMs;
    double adjustedTotalDuration = durationMs * durationAdjustment; //double.parse((durationMs * durationAdjustment).toStringAsFixed(2));
    double adjustedAllocation = animDuration/adjustedTotalDuration; //double.parse((animDuration/adjustedTotalDuration).toStringAsFixed(2));
    // double startRatio = ((index * animDuration)/adjustedTotalDuration);
    // double startAllocation = (startRatio) - ( startRatio*adjustedAllocation );
    double startAllocation = index * (adjustedAllocation/2);
    double endAllocation = startAllocation + adjustedAllocation;



    if (progress >= startAllocation && progress < endAllocation) {
      res = double.parse(((progress-startAllocation)/adjustedAllocation).toStringAsFixed(2));
    } else if (progress >= endAllocation) {
      res = 1.0;
    }    

    return res;
  }









}