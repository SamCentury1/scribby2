import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/animation_utils.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';

class LoadingImage extends StatefulWidget {
  const LoadingImage({super.key});

  @override
  State<LoadingImage> createState() => _LoadingImageState();
}

class _LoadingImageState extends State<LoadingImage> {


  Timer? _timer;
  late double progress = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: 10), (Timer timer) {
      setState(() {
        progress++;
      });
    });
    
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {



    return Consumer<ColorPalette>(
      builder: (context,palette,child) {
        return Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: CustomPaint(
                painter: LoadingImgaeBackground(palette: palette),
              ),
            ),
            Column(
              children: [
        
                Expanded(
                  flex: 1,
                  child: SizedBox()
                ),  
        
        
                Expanded(
                  flex: 4,
                  child:SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                    child: Image(
                      semanticLabel: "logo",
                      image: AssetImage(
                        'assets/images/scribby_label_1.png'
                      )
                    ),
                  ),              
                ),
                
                Expanded(
                  flex: 1,
                  child:SizedBox(
                    width: MediaQuery.of(context).size.width*0.5,
                    height: MediaQuery.of(context).size.width*0.15,                
                    child: CustomPaint(
                      painter: LoadingDots(progress: progress),
                    ),
                  ),
                ),
                            
        
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "created by",
                          style: TextStyle(
                            color: palette.text1,
                            fontSize: 16
                          ),
                        ),                    
                        Text(
                          "No Damn Good Studios",
                          style: TextStyle(
                            color: palette.text1,
                            fontSize: 24
                          ),
                        ),
                      ],
        
                    ),
                  )
                ),            
              ],
            )
          ],
        );
      }
    );
  }
}




class LoadingDots extends CustomPainter {
  final double progress;
  const LoadingDots({
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {



    final Paint dotPaint = Paint();
    dotPaint.color = const Color.fromARGB(255, 14, 3, 63);


    Offset center = Offset(size.width/2,size.height/2);

    final double dotGap = size.width*0.15;
    Offset dotPosition1 = Offset(center.dx-(dotGap*2), center.dy+size.height*0.35);
    Offset dotPosition2 = Offset(center.dx-(dotGap*1), center.dy+size.height*0.35);
    Offset dotPosition3 = Offset(center.dx, center.dy+size.height*0.35);
    Offset dotPosition4 = Offset(center.dx+(dotGap*1), center.dy+size.height*0.35);
    Offset dotPosition5 = Offset(center.dx+(dotGap*2), center.dy+size.height*0.35);

    final double oscillator1 = AnimationUtils().getLoadingDotsOscillatingEffect((progress),0);
    final double oscillator2 = AnimationUtils().getLoadingDotsOscillatingEffect((progress),1);
    final double oscillator3 = AnimationUtils().getLoadingDotsOscillatingEffect((progress),2);
    final double oscillator4 = AnimationUtils().getLoadingDotsOscillatingEffect((progress),3);
    final double oscillator5 = AnimationUtils().getLoadingDotsOscillatingEffect((progress),4);

    // TextStyle textStyle = TextStyle(
    //   color: Colors.black,
    //   fontSize: fontSize,
    // );
    // TextSpan textSpan = TextSpan(
    //   text: "Loading",
    //   style: textStyle,
    // );
    // final textPainter = TextPainter(
    //   text: textSpan,
    //   textDirection: TextDirection.ltr,
    // );
    // textPainter.layout();
    // final textPosition = Offset(center.dx - (textPainter.width/2), center.dy - (textPainter.height/2));
    // textPainter.paint(canvas, textPosition);

    
    final double dotSize = 20;
    Rect dotRect1 = Rect.fromCenter(center: dotPosition1, width: dotSize*oscillator1, height: dotSize*oscillator2);
    Rect dotRect2 = Rect.fromCenter(center: dotPosition2, width: dotSize*oscillator2, height: dotSize*oscillator3);
    Rect dotRect3 = Rect.fromCenter(center: dotPosition3, width: dotSize*oscillator3, height: dotSize*oscillator4);
    Rect dotRect4 = Rect.fromCenter(center: dotPosition4, width: dotSize*oscillator4, height: dotSize*oscillator5);
    Rect dotRect5 = Rect.fromCenter(center: dotPosition5, width: dotSize*oscillator5, height: dotSize*oscillator1);

    RRect dotRRect1 = RRect.fromRectAndRadius(dotRect1, Radius.circular(2.0));
    RRect dotRRect2 = RRect.fromRectAndRadius(dotRect2, Radius.circular(2.0));
    RRect dotRRect3 = RRect.fromRectAndRadius(dotRect3, Radius.circular(2.0));
    RRect dotRRect4 = RRect.fromRectAndRadius(dotRect4, Radius.circular(2.0));
    RRect dotRRect5 = RRect.fromRectAndRadius(dotRect5, Radius.circular(2.0));


    canvas.drawRRect(dotRRect1, dotPaint);
    canvas.drawRRect(dotRRect2, dotPaint);
    canvas.drawRRect(dotRRect3, dotPaint);
    canvas.drawRRect(dotRRect4, dotPaint);
    canvas.drawRRect(dotRRect5, dotPaint);    

  }

  
  @override
  bool shouldRepaint(covariant LoadingDots oldDelegate) => true;
}



class LoadingImgaeBackground extends CustomPainter {
  final ColorPalette palette;
  const LoadingImgaeBackground({
    required this.palette,
  });

  @override
  void paint(Canvas canvas, Size size) {


    final Rect rect = Offset.zero & size;

    final Paint paint = Paint()
      ..shader = RadialGradient(
        colors: [palette.bg1, palette.bg2],
        center: Alignment.center, // You can also use Alignment.topLeft, etc.
        radius: 0.9,              // Relative to the shorter side of the rect
      ).createShader(rect);

    canvas.drawRect(rect, paint); // Or drawCircle, drawRRect, etc.
  }

  
  @override
  bool shouldRepaint(covariant LoadingImgaeBackground oldDelegate) => true;
}