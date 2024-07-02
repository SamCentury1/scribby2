import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class Decorations {


  // Widget decorativeSquare(double w, double h) {
  Widget decorativeSquare(Map<String,dynamic> details) {    
    double topRandomValue = details['top'].toDouble();
    double leftRandomValue = details['left'].toDouble();
    double sizeRandomValue = details['size'].toDouble();
    double opacity = details['opacity'];
    return Positioned(
      top: topRandomValue,
      left: leftRandomValue,
      child: Transform.rotate(
        angle: pi / details['angle'],
        child: Container(
          width: sizeRandomValue,
          height: sizeRandomValue,
          decoration: BoxDecoration(
            color: Color.fromRGBO(8, 8, 8, opacity),
            borderRadius: BorderRadius.all(Radius.circular(15.0))
          ),
        ),
      ),
    );
  }

  BoxDecoration getEmptyTileDecoration(double tileSize, ColorPalette palette, int shadeIndex, int angleIndex) {


    late Map<int,dynamic> angles = {
      0: {"begin": Alignment.bottomLeft, "end": Alignment.topRight,},
      1: {"begin": Alignment.bottomRight, "end": Alignment.topLeft,},
      2: {"begin": Alignment.topLeft, "end": Alignment.bottomRight,},
      3: {"begin": Alignment.topRight, "end": Alignment.bottomLeft,},
      4: {"begin": Alignment.topCenter, "end": Alignment.bottomCenter,},
    };

    return BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(tileSize*0.25)),
      gradient: LinearGradient(
        begin: angles[angleIndex]['begin'],
        end: angles[angleIndex]['end'],
        colors: <Color>[
       
          // Color.fromRGBO(101, 150, 190, 0.7),
          // Color.fromRGBO(218, 233, 245, 0.7),
          palette.emptyTileGradientBackGroundColor1,
          palette.emptyTileGradientBackGroundColor2

          // ui.Color.fromARGB(175, 83, 218, 65),
          // ui.Color.fromRGBO(60, 150, 75, 0.698),          
        ],
      ),
      border:  Border(
        bottom: BorderSide(
          // color: Color.fromRGBO(211, 210, 210, 0.663),
          color: palette.emptyTileBorderColor,
          width: tileSize*0.03,
        ),
        left: BorderSide(
          // color: Color.fromRGBO(211, 210, 210, 0.663),
          color: palette.emptyTileBorderColor,
          width: tileSize*0.03,
        )
      ),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: ui.Color.fromARGB(41, 15, 15, 15),
          offset: Offset(0.0, (tileSize*0.04)),
          blurRadius: tileSize*0.04,
          spreadRadius: tileSize*0.01,
        )
      ]
    );
  }

  BoxDecoration getEmptyReserveDecoration(double tileSize, ColorPalette palette) {
    return BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(tileSize*0.2)),
      gradient: LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: <Color>[
          palette.emptyReserveGradientBackGroundColor1.withOpacity(0.6),
          palette.emptyReserveGradientBackGroundColor2.withOpacity(0.6),
        ],
      ),
      border:  Border(
        bottom: BorderSide(
          color: palette.fullReserveBorderColor.withOpacity(0.3),
          width: tileSize*0.03,
        ),
        left: BorderSide(
          color: palette.fullReserveBorderColor.withOpacity(0.3),
          width: tileSize*0.03,
        ),
        top: BorderSide(
          color: palette.fullReserveBorderColor.withOpacity(0.3),
          width: tileSize*0.03,
        ),
        right: BorderSide(
          color: palette.fullReserveBorderColor.withOpacity(0.3),
          width: tileSize*0.03,
        )        
      ),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: ui.Color.fromARGB(41, 15, 15, 15),
          offset: Offset(0.0, (tileSize*0.04)),
          blurRadius: tileSize*0.04,
          spreadRadius: tileSize*0.01,
        )
      ]
    );
  }

  BoxDecoration getTileDecoration(double tileSize, ColorPalette palette, int shadeIndex, int angleIndex) {

    late Map<int,dynamic> angles = {
      0: {"begin": Alignment.bottomLeft, "end": Alignment.topRight,},
      1: {"begin": Alignment.bottomRight, "end": Alignment.topLeft,},
      2: {"begin": Alignment.topLeft, "end": Alignment.bottomRight,},
      3: {"begin": Alignment.topRight, "end": Alignment.bottomLeft,},
      4: {"begin": Alignment.topCenter, "end": Alignment.bottomCenter,},
    };

    List<Color> shade1List = [
      palette.tileGradientShade1Color1,
      palette.tileGradientShade2Color1,
      palette.tileGradientShade3Color1,
      palette.tileGradientShade4Color1,
      palette.tileGradientShade5Color1,
    ];
    List<Color> shade2List = [
      palette.tileGradientShade1Color2,
      palette.tileGradientShade2Color2,
      palette.tileGradientShade3Color2,
      palette.tileGradientShade4Color2,
      palette.tileGradientShade5Color2,
    ];    

    return BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(tileSize*0.20)),
      gradient: LinearGradient(
        begin: angles[angleIndex]['begin'],
        end: angles[angleIndex]['end'],
        // begin: Alignment.bottomLeft,
        // end: Alignment.topRight,
        colors: <Color>[
          // Color.fromRGBO(101, 150, 190, 0.7),
          // Color.fromRGBO(218, 233, 245, 0.7),
          // Color(0xfff39060),
          // Color.fromRGBO(250, 203, 156, 1),
          // ui.Color.fromARGB(255, 194, 131, 183),
          // ui.Color.fromARGB(255, 239, 195, 250)
          // const Color.fromARGB(255, 35, 42, 141),
          // ui.Color.fromARGB(255, 89, 94, 163),

          // palette.fullTileGradientBackGroundColor1,
          // palette.fullTileGradientBackGroundColor2   
          shade1List[shadeIndex],
          shade2List[shadeIndex],
        ],
      ),
      border: Border(
        bottom: BorderSide(
          // color: ui.Color.fromARGB(204, 151, 149, 149),
          color: palette.fullTileBorderColor,
          width: tileSize*0.03,
        ),
        left: BorderSide(
          // color: ui.Color.fromARGB(204, 151, 149, 149),
          color: palette.fullTileBorderColor,
          width: tileSize*0.03,
        )
      ),
      boxShadow:  <BoxShadow>[
        BoxShadow(
          color: Color.fromRGBO(15, 15, 15, tileSize*0.003),
          offset: Offset(0.0, 2.0),
          blurRadius: tileSize*0.04,
          spreadRadius: 1,
        )
      ]
    );
  }


  BoxDecoration getFullReserveDecoration(double tileSize, ColorPalette palette,int shadeIndex, int angleIndex) {

    late Map<int,dynamic> angles = {
      0: {"begin": Alignment.bottomLeft, "end": Alignment.topRight,},
      1: {"begin": Alignment.bottomRight, "end": Alignment.topLeft,},
      2: {"begin": Alignment.topLeft, "end": Alignment.bottomRight,},
      3: {"begin": Alignment.topRight, "end": Alignment.bottomLeft,},
      4: {"begin": Alignment.topCenter, "end": Alignment.bottomCenter,},
    };

    List<Color> shadeList = [
      palette.fullReserveGradientBackGroundColor1,
      palette.fullReserveGradientBackGroundColor2,
      palette.fullReserveGradientBackGroundColor3,
      palette.fullReserveGradientBackGroundColor4,
      palette.fullReserveGradientBackGroundColor5,
    ];


    return BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(tileSize*0.2)),
      gradient: LinearGradient(
        begin: angles[angleIndex]['begin'],
        end: angles[angleIndex]['end'],
        colors: <Color>[
          shadeList[shadeIndex],
          shadeList[angleIndex],
          // palette.fullReserveGradientBackGroundColor1,
          // palette.fullReserveGradientBackGroundColor2          
        ],
      ),
      border: Border(
        bottom: BorderSide(
          color: palette.fullReserveBorderColor,
          width: tileSize*0.03,
        ),
        left: BorderSide(
          color: palette.fullReserveBorderColor,
          width: tileSize*0.03,
        )
      ),
      boxShadow:  <BoxShadow>[
        BoxShadow(
          color: Color.fromRGBO(15, 15, 15, tileSize*0.003,),
          offset: Offset(0.0, 2.0),
          blurRadius: tileSize*0.04,
          spreadRadius: 1,
        )
      ]
    );
  }  


  BoxDecoration getDeadTileDecoration(double tileSize,double opacity, ColorPalette palette) {
    return BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(tileSize*0.20)),
      gradient: LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: <Color>[
          // ui.Color.fromRGBO(24, 24, 24, 0.69*opacity),
          // ui.Color.fromRGBO(85, 85, 85, 0.69*opacity),
          palette.deadTileGradientBackGroundColor1.withOpacity(opacity),
          palette.deadTileGradientBackGroundColor2.withOpacity(opacity)
        ],
      ),
      border:  Border(
        bottom: BorderSide(
          // color: Color.fromRGBO(85, 84, 84, 0.663*opacity),
          // color: Colors.green,
          color: palette.deadTileGradientBackGroundColor1.withOpacity(opacity),
          width: tileSize*0.03,
        ),
        left: BorderSide(
          color: palette.deadTileGradientBackGroundColor1.withOpacity(opacity),
          // color: Colors.green,
          width: tileSize*0.03,
        )
      ),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: palette.deadTileGradientBackGroundColor1.withOpacity(opacity),
          offset: Offset(0.0, tileSize*0.00),
          blurRadius: tileSize*0.0*opacity,
          spreadRadius: tileSize*0.01,
        )
      ]
    );
  }

  // BoxDecoration appButtonStyle(double tileSize, double width, double height, ColorPalette palette, int shadeIndex, int angleIndex) {

  //   late Map<int,dynamic> angles = {
  //     0: {"begin": Alignment.bottomLeft, "end": Alignment.topRight,},
  //     1: {"begin": Alignment.bottomRight, "end": Alignment.topLeft,},
  //     2: {"begin": Alignment.topLeft, "end": Alignment.bottomRight,},
  //     3: {"begin": Alignment.topRight, "end": Alignment.bottomLeft,},
  //     4: {"begin": Alignment.topCenter, "end": Alignment.bottomCenter,},
  //   };

  //   List<Color> shade1List = [
  //     palette.tileGradientShade1Color1,
  //     palette.tileGradientShade2Color1,
  //     palette.tileGradientShade3Color1,
  //     palette.tileGradientShade4Color1,
  //     palette.tileGradientShade5Color1,
  //   ];
  //   List<Color> shade2List = [
  //     palette.tileGradientShade1Color2,
  //     palette.tileGradientShade2Color2,
  //     palette.tileGradientShade3Color2,
  //     palette.tileGradientShade4Color2,
  //     palette.tileGradientShade5Color2,
  //   ];    

  //   return BoxDecoration(
  //     borderRadius: BorderRadius.all(Radius.circular(tileSize*0.20)),
  //     gradient: LinearGradient(
  //       begin: angles[angleIndex]['begin'],
  //       end: angles[angleIndex]['end'],
  //       colors: <Color>[
  //         shade1List[shadeIndex],
  //         shade2List[shadeIndex],
  //       ],
  //     ),
  //     border: Border(
  //       bottom: BorderSide(
  //         color: palette.fullTileBorderColor,
  //         width: tileSize*0.03,
  //       ),
  //       left: BorderSide(
  //         color: palette.fullTileBorderColor,
  //         width: tileSize*0.03,
  //       )
  //     ),
  //     boxShadow:  <BoxShadow>[
  //       BoxShadow(
  //         color: Color.fromRGBO(15, 15, 15, tileSize*0.003),
  //         offset: Offset(0.0, 2.0),
  //         blurRadius: tileSize*0.04,
  //         spreadRadius: 1,
  //       )
  //     ]
  //   );
  // }

}


class CustomBackground extends CustomPainter {
  final ColorPalette palette;

  CustomBackground({required this.palette});

  @override
  void paint(Canvas canvas, Size size) {
  final paint = Paint()
    ..shader = ui.Gradient.linear(
      Offset(0,0),
      Offset(size.width, size.height),
      [
        // ui.Color.fromARGB(255, 138, 186, 231),
        // ui.Color.fromARGB(255, 200, 210, 231),
        palette.screenGradientBackgroundColor1,
        palette.screenGradientBackgroundColor2,

        // ui.Color.fromARGB(167, 207, 87, 147),
        // ui.Color.fromARGB(255, 117, 11, 38)
      ],
    );
    // Draw background
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}



