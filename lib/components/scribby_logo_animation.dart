import 'dart:math';

import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:scribby_flutter_v2/styles/styles.dart';

class ScribbyLogoAnimation extends StatefulWidget {
  const ScribbyLogoAnimation({super.key});

  @override
  State<ScribbyLogoAnimation> createState() => _ScribbyLogoAnimationState();
}

class _ScribbyLogoAnimationState extends State<ScribbyLogoAnimation> with SingleTickerProviderStateMixin {


  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(0, 241, 101, 0),
      width: MediaQuery.of(context).size.width*0.9,
      height: 250,//MediaQuery.of(context).size.width*0.7,
      child: const Stack(
        children: <Widget>[
          LogoLetterAnimation(index: 0, letter: "S"),
          LogoLetterAnimation(index: 1, letter: "C"),
          LogoLetterAnimation(index: 2, letter: "R"),
          LogoLetterAnimation(index: 3, letter: "I"),
          LogoLetterAnimation(index: 4, letter: "B"),
          LogoLetterAnimation(index: 5, letter: "B"),
          LogoLetterAnimation(index: 6, letter: "Y"),                              
        ],
      ),
    );
  }
}


class LogoLetterAnimation extends StatefulWidget {
  final int index;
  final String letter;
  const LogoLetterAnimation({
    super.key,
    required this.index,
    required this.letter,
  });

  @override
  State<LogoLetterAnimation> createState() => _LogoLetterAnimationState();
}

class _LogoLetterAnimationState extends State<LogoLetterAnimation> with SingleTickerProviderStateMixin{

  late final AnimationController _slideController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2000),
  )..forward();

  late final Animation<double> _positionAnimation;
  late final Animation<double> _opacityAnimation;

  double getWeight1(int index) {
    double res = 0.0;
    if ((1/7)*index > 0.0) {
      res = (1/7)*index;
    } else {
      res = 0.01;
    }
    return res;
  } 

  double getWeight2(int index) {
    double res = 1/7;
    return res;
  }

  double getWeight3(int index) {
    double res = 0.0;

    double number = 1 -(((1/7)*index) + (1/7));
    if (number >0.0 ) {
      res = number;
    } else {
      res = 0.01;
    }
    return res;
    
  }  


  @override
  void initState() {

    super.initState();

    /// POSITION
    _positionAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 200.0, end: 200.0), 
        weight: getWeight1(widget.index)
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 200.0, end: 10.0), 
        weight: getWeight2(widget.index)
      ),  

      TweenSequenceItem(
        tween: Tween<double>(begin: 10.0, end: 10.0), 
        weight: getWeight3(widget.index)
      ),          

    ]).animate(CurvedAnimation(
      parent: _slideController, 
      curve: const Interval(0.0, 1.0, curve: Curves.easeIn)
    ));




    /// OPACITY
    _opacityAnimation = TweenSequence<double>([

      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end:0.0 ), 
        weight: getWeight1(widget.index),
      ),

      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end:1.0 ), 
        weight: getWeight2(widget.index),
      ),

      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end:1.0 ), 
        weight: getWeight3(widget.index),
      ),            
    ]).animate(CurvedAnimation(
      parent: _slideController, 
      curve: const Interval(0.0, 1.0, curve: Curves.easeIn)
    ));
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

      double sideLength = (MediaQuery.of(context).size.width*0.7)/5;
      // double foot = MediaQuery.of(context).size.width/20;
      double foot = ((MediaQuery.of(context).size.width*0.9) - (MediaQuery.of(context).size.width*0.8))/2;
      List<double> possibleAngles = [-pi/30,-pi/20,-pi/10,0,pi/10,pi/20,pi/30,];
      Random random = Random();
      int intValue = random.nextInt(possibleAngles.length);  
      int letterValue = random.nextInt(9) + 1 ;


      return AnimatedBuilder(
        animation: _slideController,
        builder: (context, child) {
          // double position = position;

          return Positioned(
            top: _positionAnimation.value,
            left: ((sideLength*0.8)*widget.index)+foot,
            child: Transform.rotate(
              angle: possibleAngles[intValue],
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200 ),
                opacity: _opacityAnimation.value,
                child: SizedBox(
                  width: sideLength,
                  height: sideLength,
                  child: scrabbleTile(widget.letter,letterValue,sideLength,1),

                ),
              ),
            ),
          );
        },
      ); 
  }
}

