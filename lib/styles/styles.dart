import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget scrabbleTile(String letter, int value, double side, double sizeFactor) {
  return Container(
    width: side,
    height: side,
    decoration: const BoxDecoration(
      // color: Color.fromARGB(255, 227, 207, 170),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          Color.fromARGB(255, 227, 207, 170),
          Color.fromARGB(255, 185, 164, 125),
          Color.fromARGB(255, 165, 145, 109),
        ],
        tileMode: TileMode.mirror
      ),
      boxShadow: [
        BoxShadow(
          color: Color.fromARGB(255, 139, 122, 89),
          offset: Offset(3.0, 3.0)
        )
      ],
      borderRadius: BorderRadius.all(Radius.circular(5.0))      
    ),
    child: Stack(
      children: <Widget>[
        Center(
          child: Text(
            letter,
            style: GoogleFonts.inter(
              fontSize: side*0.6,
              fontWeight: FontWeight.w400,
              textStyle: const TextStyle(
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(1.0, 1.0),
                    blurRadius: 1.0,
                    color: Color.fromARGB(255, 88, 88, 88),
                  ),
                ]
              )
            )
          )
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.all(side*0.02),
            child: Text(
              value.toString(),
              style: TextStyle(
                fontSize: side*0.35
              ),
            ),
          ),
        )
      ],
    ),
  );
}



