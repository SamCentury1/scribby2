import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/painters/scoreboard_painters.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';

class XPHoldings extends StatefulWidget {
  const XPHoldings({super.key});

  @override
  State<XPHoldings> createState() => _XPHoldingsState();
}



class _XPHoldingsState extends State<XPHoldings> {

  final GlobalKey _containerKey = GlobalKey();
  late Size containerSize = Size.zero;


  late SettingsController settings;
  late int? xp;

  late double progress1 = 0;
  late double progress2 = 0;
  late bool isAnimating = false;

  Timer? _xpCountTimer;
  Timer? _highlightTimer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    settings = Provider.of<SettingsController>(context,listen: false);
    Map<String,dynamic> userData = settings.userData.value as Map<String,dynamic>;

    Map<dynamic,dynamic> achievements = settings.achievements.value as Map<dynamic,dynamic>;

    int currentXP = userData["xp"]; //settings.xp.value;
    xp = currentXP;

    if (achievements.isNotEmpty) {
      if (achievements["xp"]!= null && achievements["xp"]>0) {
        print(achievements);
        startXPCount(currentXP,achievements["xp"],settings);
      }

      if (achievements["badges"].isNotEmpty) {
        for (Map<dynamic,dynamic> badge in achievements["badges"]) {
          print("earned a badge => $badge");
        }
      }
    }


    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBox = _containerKey.currentContext?.findRenderObject() as RenderBox;
      setState(() {
        containerSize = renderBox.size;
      });
      print("Container size: ${containerSize.width} x ${containerSize.height}");
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _xpCountTimer?.cancel();
    _highlightTimer?.cancel();
    super.dispose();
  }


  void startXPCount(int currentXP, int newXP, SettingsController settings) {
    late int count = currentXP-newXP;
    late int target = currentXP;
    final int increment = 1; 
    _xpCountTimer = Timer.periodic(const Duration(milliseconds: 20), (Timer t) {

      if (!mounted) {
        t.cancel();
        return;
      }

      if (count >= target) {
        t.cancel();
        settings.setAchievements({});

        if (mounted) {
          setState(() {
            isAnimating = true;
          });
        }
        
        startHighlightAnimation();
      } else {
        count = count + increment;
        if (mounted) {
          setState(() {
            xp = count;
          });
        }
      }
    });
  }

  void startHighlightAnimation() {
    final int target1 = 30;
    final int target2 = 30;

    late int animationCount1 = 0;
    late int animationCount2 = 0;    

    _highlightTimer = Timer.periodic(const Duration(milliseconds: 17), (Timer t) {
      if (!mounted) {
        t.cancel();
        return;
      }      

      if (animationCount2 == target2) {
        if (mounted) {
          setState(() {
            isAnimating = false;
          });
        }
        t.cancel();
      } else {

        if (animationCount1 < target1) {
          setState(() {
            animationCount1++;
          });
        }

        if (animationCount1 >= (target1/2)) {
          setState(() {
            animationCount2++;
          });
        }
        if (mounted) {
          setState(() {
            progress1 = animationCount1/target1;
            progress2 = animationCount2/target2;
          });
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {

    return Consumer<SettingsController>(
      builder: (context,settings,child) {
        ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
        
        final double scalor = Helpers().getScalor(settings);

        return Padding(
          padding: EdgeInsets.only(right: 12.0 * scalor),
          child: Stack(
            children: [
              Container(
                width: containerSize.width,
                height: containerSize.height,
                child: CustomPaint(
                  painter: XPCounterPainter(isAnimating:isAnimating, progress1: progress1, progress2: progress2,scalor: scalor,palette: palette),
                ),
              ),
              Container(
                key: _containerKey,
                decoration: BoxDecoration(
                  border: Border.all(color: palette.coinCounterBorder, width: 2.0 * scalor),
                  borderRadius: BorderRadius.all(Radius.circular(8.0*scalor))
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0*scalor),
                  child: Row(
                    children: [
              
                      SizedBox(
                        width: 22*scalor,
                        height: 22*scalor,
                        child: Image.asset("assets/images/xp_image.png")
                      ),
                      SizedBox(width: 10,),
                
                
                      Container(
                        // color: Colors.orange,
                        child: Text(
                          "$xp",
                          style: palette.counterFont(
                            textStyle: TextStyle(
                              color: palette.coinCounterText,
                              fontSize: 22*scalor,
                            ),
                          ),
                        ),
                      )
                
                
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

class XPCounterPainter extends CustomPainter {
  final bool isAnimating;
  final double progress1;
  final double progress2;
  final double scalor;
  final ColorPalette palette;

  const XPCounterPainter({
    required this.isAnimating,
    required this.progress1,
    required this.progress2,
    required this.scalor,
    required this.palette,
  });

  @override
  void paint(Canvas canvas, Size size) {

    // print("progress 1: $progress1 | progress 2: $progress2 ");

    // late bool isAnimationActive = (progress1 <= 1.0 && progress2 <= 1.0 && progress1 > 0.0);

    if (isAnimating) {
      
      Offset center = Offset(size.width/2,size.height/2);

      final int r = (palette.coinCounterBorder.r*255).floor();
      final int g = (palette.coinCounterBorder.g*255).floor(); 
      final int b = (palette.coinCounterBorder.b*255).floor();
      
      Paint paint1 = Paint()
      ..color =  Color.fromRGBO(r,g,b,(1.0-progress1)) // Color.fromRGBO(255, 255, 255, (1.0-progress1))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0*scalor;

      
      Rect rect1 = Rect.fromCenter(
        center: center, 
        width: size.width + (20.0*progress1), 
        height: size.height + (20.0*progress1),
      );
      RRect rrect1 = RRect.fromRectAndRadius(rect1, Radius.circular(6.0*scalor));
      canvas.drawRRect(rrect1,paint1);


      Paint paint2 = Paint()
      ..color = Color.fromRGBO(r, g, b, (1.0-progress2))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0*scalor;        

      Rect rect2 = Rect.fromCenter(
        center: center, 
        width: size.width + (20.0*progress2), 
        height: size.height + (20.0*progress2),
      );
      RRect rrect2 = RRect.fromRectAndRadius(rect2, Radius.circular(6.0*scalor));
      canvas.drawRRect(rrect2,paint2);
    }

    // print("isAnimating: $isAnimating, progress1: $progress1, progress2: $progress2");


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}