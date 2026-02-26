import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/functions/styling_utils.dart';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:scribby_flutter_v2/screens/game_screen/components/painters/bonus_painters.dart';

class BadgePainter extends CustomPainter {
  final Map<String,dynamic> badgeData;
  const BadgePainter({
    required this.badgeData,
  });

  @override
  void paint(Canvas canvas, Size size) {

    
    Offset center = Offset(size.width/2,size.height/2);
    
    // Rect rect = Rect.fromCenter(center:center,width:size.width,height:size.height);

    // Map<String,dynamic> colorGroups = {
    //   "bronze": [Colors.brown, const Color.fromARGB(255, 207, 109, 29)],
    //   "silver": [Colors.grey, Colors.white],
    //   "gold": [Colors.amber, const Color.fromARGB(255, 223, 162, 71)],
    //   "platinum": [Colors.blueGrey, const Color.fromARGB(255, 85, 85, 85)],
    // };

    final bool isCompleted = badgeData["completed"];

    Map<String,dynamic> defaultColors = {
      "gradient1": updateOpacity(Colors.grey,isCompleted), 
      "gradient2": updateOpacity(Colors.white,isCompleted),
      "borderColor1": updateOpacity(Color.fromRGBO(200,200,200,1.0),isCompleted), 
      "borderColor2": updateOpacity(Color.fromRGBO(100,100,100,1.0),isCompleted),
      "middleColor1": updateOpacity(Color.fromRGBO(255,255,255,0.3),isCompleted),
      "iconColor": updateOpacity(Color.fromARGB(255, 117, 117, 117),isCompleted),
    };
    List<Map<String,dynamic>> badgeColorPalettes = [
      {"key": "bronze", "xpRange":[0,10], "colors": {
        "gradient1": updateOpacity(Color.fromARGB(255, 75, 59, 54),isCompleted),
        "gradient2": updateOpacity(Colors.brown,isCompleted),
        "borderColor1": updateOpacity(Color.fromARGB(255, 165, 123, 107),isCompleted),
        "borderColor2": updateOpacity(Color.fromARGB(255, 150, 87, 69),isCompleted),
        "middleColor1": updateOpacity(Color.fromARGB(255, 168, 131, 117),isCompleted),
        "iconColor": updateOpacity(Color.fromARGB(255, 87, 58, 47),isCompleted),
        }
      },
      {"key": "silver", "xpRange":[11,30], "colors": {
        "gradient1": updateOpacity(Colors.grey,isCompleted),
        "gradient2": updateOpacity(Colors.white,isCompleted),
        "borderColor1": updateOpacity(Color.fromRGBO(200,200,200,1.0),isCompleted), 
        "borderColor2": updateOpacity(Color.fromRGBO(100,100,100,1.0),isCompleted), 
        "middleColor1": updateOpacity(Color.fromRGBO(255,255,255,0.3),isCompleted), 
        "iconColor": updateOpacity(Color.fromARGB(255, 117, 117, 117),isCompleted),
        }
      },
      {"key": "gold", "xpRange":[31,50], "colors": {
        "gradient1": updateOpacity(Color.fromARGB(255, 255, 147, 7),isCompleted),
        "gradient2": updateOpacity(Colors.amber,isCompleted),
        "borderColor1": updateOpacity(Color.fromARGB(255, 212, 174, 57),isCompleted),
        "borderColor2": updateOpacity(Color.fromARGB(255, 190, 120, 28),isCompleted),
        "middleColor1": updateOpacity(Color.fromARGB(255, 238, 191, 120),isCompleted),
        "iconColor": updateOpacity(Color.fromARGB(255, 172, 123, 32),isCompleted),}
      },
      {"key": "platinum", "xpRange":[51,100], "colors": {
        "gradient1": updateOpacity(Color.fromARGB(255, 51, 51, 51),isCompleted),
        "gradient2": updateOpacity(Colors.grey,isCompleted),
        "borderColor1": updateOpacity(Color.fromARGB(255, 219, 214, 214),isCompleted),
        "borderColor2": updateOpacity(Color.fromARGB(255, 70, 69, 69),isCompleted),
        "middleColor1": updateOpacity(Color.fromARGB(255, 114, 113, 113),isCompleted),
        "iconColor": updateOpacity(Color.fromARGB(255, 68, 68, 68),isCompleted),}
      },
    ];

    Map<String,dynamic> colorObject = badgeColorPalettes.firstWhere( (e)=>
      e["xpRange"][0]<=badgeData["xp"]&&
      e["xpRange"][1]>=badgeData["xp"],
      orElse: ()=>{}
    );

    Map<String,dynamic> badgeColors = defaultColors;
    if (colorObject.isNotEmpty) {
      badgeColors = colorObject["colors"];
    }

    
    Paint shieldPaint = Paint()
    ..shader = ui.Gradient.linear(
      Offset.zero,
      Offset(size.width,size.height),
      [

        badgeColors["gradient1"],
        badgeColors["gradient2"]
        // Colors.grey,
        // Colors.white
      ],
    );
    
    Paint shieldBorderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = size.width*0.025
    ..shader = ui.Gradient.linear(
      Offset(size.width,size.height),
      Offset.zero,
      [
        badgeColors["borderColor1"],
        badgeColors["borderColor2"],
        // Color.fromRGBO(200,200,200,1.0),
        // Color.fromRGBO(100,100,100,1.0)
      ],
    ); 
    
    Paint centerCirclePaint = Paint()
      ..color = badgeColors["middleColor1"]; //Color.fromRGBO(255,255,255,0.3);

    Paint bannerPaint2 = Paint()
      ..color = updateOpacity(Color.fromRGBO(219, 186, 127,1.0),isCompleted);
    
    Paint bannerPaint1 = Paint()
      ..color = updateOpacity(Color.fromRGBO(235, 214, 176,1.0),isCompleted);    


    final double inc = size.width*0.1;


    // BADGE SHAPE
    Map<String,dynamic> badgeObject = badgeDetails.firstWhere( (e)=>
      e["xpRange"][0]<=badgeData["xp"]&&
      e["xpRange"][1]>=badgeData["xp"]&&
      e["type"]==badgeData["type"],
      orElse: ()=>{}
    );
    int badgeKey = badgeObject["badge"];

    final List<Map<String,dynamic>> badgePoints = badgeShapesData[badgeKey];
    Path badgePath = StylingUtils().getBadgePath(badgePoints,inc);
    canvas.drawPath(badgePath,shieldPaint);

    // SHIELD BORDER
    canvas.drawPath(badgePath,shieldBorderPaint);    
    
    // ICON CONTAINER
    canvas.drawCircle(Offset(size.width/2,size.height/2),size.width*0.275,centerCirclePaint);


    if (badgeData["target"] == "streak") {
      BonusPainters().drawStreakIcon(canvas, Size(size.width*0.3,size.height*0.3), center, badgeColors["iconColor"]);
    } else if (badgeData["target"]== "crosswords") {
      BonusPainters().drawCrossWordIcon(canvas, Size(size.width*0.3,size.height*0.3), center, badgeColors["iconColor"]);
    } else if (badgeData["target"]== "words") {
      BonusPainters().drawMultiWordIcon(canvas, Size(size.width*0.3,size.height*0.3), center, badgeColors["iconColor"]);
    } else if (badgeData["target"]=="tutorial") {
      BonusPainters().drawTutorialIcon(canvas, Size(size.width*0.3,size.height*0.3), center, badgeColors["iconColor"]);
    }

    
    // LEFT SIDE OF BANNER
    final List<Map<String,dynamic>> pointData2 = [
      {"type": "start", "data": [0.5,10]},
      {"type": "line", "data": [0.0,8]},
      {"type": "curve", "data": [[0.25,7.25],[1.5,7]]},
      {"type": "line", "data": [2.0,9]},
      {"type": "curve", "data": [[1.5,9],[0.5,10]]},
      {"type": "end", "data": []},
    ];          
    Path elementPath2 = StylingUtils().getBadgePath(pointData2,inc);
    canvas.drawPath(elementPath2,bannerPaint2); 

    // RIGHT SIDE OF BANNER
    final List<Map<String,dynamic>> pointData3 = [
      {"type": "start", "data": [9.5,10]},
      {"type": "line", "data": [10,8]},
      {"type": "curve", "data": [[9.75,7.25],[8.5,7]]},
      {"type": "line", "data": [8.0,9]},
      {"type": "curve", "data": [[8.5,9],[9.5,10]]},
      {"type": "end", "data": []},
    ];  
    Path elementPath3 = StylingUtils().getBadgePath(pointData3,inc);
    canvas.drawPath(elementPath3,bannerPaint2);      
    

    // FRONT OF BANNER
    final List<Map<String,dynamic>> pointData4 = [
      {"type": "start", "data": [1,9.5]},
      {"type": "line", "data": [0.5,7.5]},
      {"type": "curve", "data": [[5,5.5],[9.5,7.5]]},
      {"type": "line", "data": [9,9.5]},
      {"type": "curve", "data": [[5,8],[1,9.5]]},
      {"type": "end", "data": []},
    ];  
    Path elementPath4 = StylingUtils().getBadgePath(pointData4,inc);
    canvas.drawPath(elementPath4,bannerPaint1); 
    

    // TEXT
    TextStyle textStyle = GoogleFonts.cinzel(
      textStyle: TextStyle(
        color: updateOpacity(Colors.black, isCompleted),
        fontSize: size.width*0.1,
        fontWeight: FontWeight.bold,
      )
    );

    BadgePainters().getCurvedText(canvas,size,badgeData["name"], size.width*0.9,textStyle,);
    

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}  

class BadgePainters {
  Canvas getCurvedText(Canvas canvas, Size size, String text, double radius, TextStyle textStyle) {
      final center = Offset(size.width / 2, size.height*1.725 );

      // Precalculate character widths
      final textPainters = text.characters.map((char) {
        final tp = TextPainter(
          text: TextSpan(text: char, style: textStyle),
          textDirection: TextDirection.ltr,
        )..layout();
        return tp;
      }).toList();

      final totalArcLength = textPainters.fold(0.0, (sum, tp) => sum + tp.width / radius);

      double startAngle = (270.0 * (pi / 180))  -totalArcLength / 2;

      double currentAngle = startAngle;
      for (var tp in textPainters) {
        final charArc = tp.width / radius;
        final angle = currentAngle + charArc / 2;

        final x = center.dx + radius * cos(angle);
        final y = center.dy + radius * sin(angle);

        canvas.save();

        // Move to character position
        canvas.translate(x, y);
        // Rotate canvas to keep character upright
        canvas.rotate(angle + pi / 2);
        // Paint the character (offset by its own width/height to center it)
        tp.paint(canvas, Offset(-tp.width / 2, -tp.height));

        canvas.restore();

        currentAngle += charArc;
      }
    
    return canvas;
  }  


}

List<Map<String,dynamic>> badgeDetails = [
  {"xpRange":[0,10], "type":"inGame", "badge": 0,},
  {"xpRange":[11,30], "type":"inGame", "badge": 1,},
  {"xpRange":[31,50], "type":"inGame", "badge": 2,},
  {"xpRange":[51,100], "type":"inGame", "badge": 3,},

  {"xpRange":[0,10], "type":"global", "badge": 4,},
  {"xpRange":[11,30], "type":"global", "badge": 5,},
  {"xpRange":[31,50], "type":"global", "badge": 6,},
  {"xpRange":[51,100], "type":"global", "badge": 7,} 
];


Map<int,dynamic> badgeShapesData = {

    // SHIELD SHAPE
    0 : [
      {"type": "start", "data": [1.0,   2.0]},
      {"type": "curve", "data": [[4.0,  2.5], [5.0, 0.5]]},
      {"type": "curve", "data": [[6.0,  2.5], [9.0,  2.0]]},
      {"type": "curve", "data": [[10.0,  9.0], [5.0,  9.5]]},
      {"type": "curve", "data": [[0.0,  9.0], [1.0,  2.0]]},
      {"type": "end", "data": []},
    ],

    1: [
      {"type": "start", "data": [1.0,   2.0]},
      {"type": "curve", "data": [[5.0,  0.5], [9.0, 2.0]]},
      {"type": "curve", "data": [[9.0,  8.0], [5.0,  9.5]]},
      {"type": "curve", "data": [[1.0, 8.0], [1.0, 2.0]]},
      {"type": "end", "data": []},
    ],

    2:[     
      {"type": "start", "data": [1.0,   2.0]},
      {"type": "curve", "data": [[2.0,  2.0], [2.0, 1.0]]},
      {"type": "curve", "data": [[5.0,  0.0], [8.0, 1.0]]},
      {"type": "curve", "data": [[8.0,  2.0], [9.0, 2.0]]},
      {"type": "curve", "data": [[9.0,  8.0], [5.0, 9.5]]},
      {"type": "curve", "data": [[1.0,  8.0], [1.0, 3.0]]},
      {"type": "end", "data": []},
    ],

    3: [
      {"type": "start", "data": [2,1]},
      {"type": "curve", "data": [[3.5,2],[5,1]]},
      {"type": "curve", "data": [[6.5,2],[8,1]],},
      {"type": "line", "data":  [9,3]},
      {"type": "curve", "data": [[8,4],[9,7]],},
      {"type": "curve", "data": [[9,9],[7,9]],},
      {"type": "curve", "data": [[5,9],[5,9.5]],},
      {"type": "curve", "data": [[5,9],[3,9]],},
      {"type": "curve", "data": [[1,9],[1,7]],},
      {"type": "curve", "data": [[2,4],[1,3]],},
      {"type": "end", "data": []},
    ],

    4: [
      {"type": "start", "data": [1.0,   2.0]},
      {"type": "curve", "data": [[4.0,  2.5], [5.0, 0.5]]},
      {"type": "curve", "data": [[6.0,  2.5], [9.0,  2.0]]},
      {"type": "curve", "data": [[10.0,  9.0], [5.0,  9.5]]},
      {"type": "curve", "data": [[0.0,  9.0], [1.0,  2.0]]},
      {"type": "end", "data": []},
    ],

    5: [
      {"type": "start", "data": [1.0,   2.0]},
      {"type": "curve", "data": [[4.0,  2.5], [5.0, 0.5]]},
      {"type": "curve", "data": [[6.0,  2.5], [9.0,  2.0]]},
      {"type": "curve", "data": [[10.0,  9.0], [5.0,  9.5]]},
      {"type": "curve", "data": [[0.0,  9.0], [1.0,  2.0]]},
      {"type": "end", "data": []},
    ],

    6: [
      {"type": "start", "data": [1.0,   2.0]},
      {"type": "curve", "data": [[4.0,  2.5], [5.0, 0.5]]},
      {"type": "curve", "data": [[6.0,  2.5], [9.0,  2.0]]},
      {"type": "curve", "data": [[10.0,  9.0], [5.0,  9.5]]},
      {"type": "curve", "data": [[0.0,  9.0], [1.0,  2.0]]},
      {"type": "end", "data": []},
    ],

    7: [
      {"type": "start", "data": [1.0,   2.0]},
      {"type": "curve", "data": [[4.0,  2.5], [5.0, 0.5]]},
      {"type": "curve", "data": [[6.0,  2.5], [9.0,  2.0]]},
      {"type": "curve", "data": [[10.0,  9.0], [5.0,  9.5]]},
      {"type": "curve", "data": [[0.0,  9.0], [1.0,  2.0]]},
      {"type": "end", "data": []},
    ],

                    
};


Color updateOpacity(Color color, bool completed) {
  // final double r = color.r;
  // final double g = color.g;
  // final double b = color.b;
  // final double o = color.a;
  Color res = color;
  if (!completed) {
    res = Color.lerp(color, const Color.fromARGB(183, 114, 114, 114), 0.5)??color;
  }

  return res;
}