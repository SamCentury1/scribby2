import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/play_area/decorations/flags.dart';

class FlagWidget extends StatelessWidget {
  final double radius;
  final String flag;
  const FlagWidget({super.key, required this.radius, required this.flag,});

  @override
  Widget build(BuildContext context) {

    CustomPainter returnFlag(String flag) {
      if (flag == 'french') {
        return FrenchFlag();
      } else if (flag == 'spanish') {
        return SpanishFlag();
      } else if (flag == 'portuguese') {
        return PortugueseFlag();
      } else if (flag == 'greek') {
        return GreekFlag();
      } else if (flag == 'german') {
        return GermanFlag();
      } else if (flag == 'dutch') {
        return DutchFlag();
      } else if (flag == 'english') {
        return UnitedKingdomFlag();
      } else if (flag == 'italian') {
        return ItalianFlag();
      } else  {
        return UnitedKingdomFlag();
      }
    }
    return ClipOval(
      child: SizedBox.fromSize(
        size: Size.fromRadius(radius),
        child: CustomPaint(
          size: Size(radius, radius),
          painter: returnFlag(flag),
          child: Stack(
            children: [
              Container(
                width: radius,
                height: radius,
              ),
              BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 00.0,
                  sigmaY: 00.0,
                ),
                child: Container(
                  alignment: Alignment.center,
                  width: radius,
                  height: radius,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


