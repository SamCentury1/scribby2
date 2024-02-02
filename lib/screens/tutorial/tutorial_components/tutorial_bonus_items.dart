// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/tutorial_state.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_helpers.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';
// import 'package:scribby_flutter_v2/utils/states.dart';

class TutorialBonusItems extends StatefulWidget {
  final Animation animation;
  const TutorialBonusItems({
    super.key,
    required this.animation
  });

  @override
  State<TutorialBonusItems> createState() => _TutorialBonusItemsState();
}

class _TutorialBonusItemsState extends State<TutorialBonusItems>  with TickerProviderStateMixin{

  late AnimationState _animationState;

  // late AnimationController _textGlowController;
  // late Animation<double> _textGlowAnimation;


  late AnimationController _streakSlideEnterController;
  late Animation<Offset> _streakSlideEnterAnimation;


  late AnimationController _multiSlideController;
  late Animation<Offset> _multiSlideAnimation;

  // late AnimationController _multiTextController;
  // late Animation<Color?> _multiTextAnimation;

  late AnimationController _cwSlideController;
  late Animation<Offset> _cwSlideAnimation;

  // late AnimationController _cwTextController;
  // late Animation<Color?> _cwTextAnimation;

  late ColorPalette palette;

  @override
  void initState() {
    super.initState();
    _animationState = Provider.of<AnimationState>(context, listen: false);
    palette = Provider.of<ColorPalette>(context, listen: false);
    initializeAnimations(palette);
    
    _animationState.addListener(_handleAnimationStateChange);        
  }

  /// governs which animations should go and when
  void _handleAnimationStateChange() {
  

    if (_animationState.shouldRunTutorialStreakEnterAnimation) {
      _runStreakAnimation('enter');
    }

    if (_animationState.shouldRunTutorialStreakExitAnimation) {
      _runStreakAnimation('exit');
    }

    if (_animationState.shouldRunTutorialMultiWordEnterAnimation) {
      _runMultiWordAnimation('enter');
    }

    if (_animationState.shouldRunTutorialMultiWordExitAnimation) {
      _runMultiWordAnimation('exit');
    }

    if (_animationState.shouldRunTutorialCrosswordEnterAnimation) {
      _runCrossWordAnimation('enter');
    }

    if (_animationState.shouldRunTutorialCrosswordExitAnimation) {
      _runCrossWordAnimation('exit');
    }        


  }

  void _runStreakAnimation(String status) {
    if (status == 'enter') {
      _streakSlideEnterController.reset();
      _streakSlideEnterController.forward();
    } else if (status == 'exit') {
      _streakSlideEnterController.reverse();
    }
  }  

  void _runCrossWordAnimation(String status) {
    if (status == 'enter') {
      _cwSlideController.reset();
      _cwSlideController.forward();
    } else if (status == 'exit') {
      _cwSlideController.reverse();
    }
  }

  void _runMultiWordAnimation(String status) {
    if (status == 'enter') {
      _multiSlideController.reset();
      _multiSlideController.forward();
    } else if (status == 'exit') {
      _multiSlideController.reverse();
    }
  }


  void initializeAnimations(ColorPalette palette) {
    /// ============== vvvvvvvvvvvvvvvv ======================
    /// ============== STREAK OFFSET ================
    _streakSlideEnterController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _streakSlideEnterAnimation = Tween<Offset>(
      // streakSlideEnterTweenSequence
      begin: const Offset(-1.2, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(_streakSlideEnterController);

    /// ============== STREAK OFFSET ================
    /// ============== ^^^^^^^^^^^^^^^^ ======================
    /// 
    /// 
    /// ============== vvvvvvvvvvvvvvvv ======================
    /// ============== ITEM SLIDE ================
    _multiSlideController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _multiSlideAnimation = Tween<Offset>(
      // streakSlideEnterTweenSequence
      begin: const Offset(0.0, 1.0),
      end: const Offset(0.0, 0.0),
    ).animate(_multiSlideController);

    /// ============== ITEM SLIDE ================
    /// ============== ^^^^^^^^^^^^^^^^ ======================
    /// 
        /// ============== vvvvvvvvvvvvvvvv ======================
    /// ============== ITEM SLIDE ================
    _cwSlideController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _cwSlideAnimation = Tween<Offset>(
      // streakSlideEnterTweenSequence
      begin: const Offset(0.0, 1.0),
      end: const Offset(0.0, 0.0),
    ).animate(_cwSlideController);

    /// ============== ITEM SLIDE ================
    /// ============== ^^^^^^^^^^^^^^^^ ======================/// 
    /// 
    // /// ============== vvvvvvvvvvvvvvvv ======================
    // /// ============== TEXT GLOW ================
  
    // _textGlowController = AnimationController(
    //   vsync: this, 
    //   duration: const Duration(milliseconds: 1500)
    // );

    // final List<TweenSequenceItem<double>> glowSequence = [
    //   TweenSequenceItem<double>(
    //       tween: Tween(
    //         begin: 1.0,
    //         end: 0.3,
    //       ),
    //       weight: 0.5),
    //   TweenSequenceItem<double>(
    //       tween: Tween(
    //         begin: 0.3,
    //         end: 1.0,
    //       ),
    //       weight: 0.5),
    // ];
    // _textGlowAnimation = TweenSequence<double>(glowSequence).animate(_textGlowController);

    // _textGlowController.forward();
    // _textGlowController.addListener(() {
    //   if (_textGlowController.isCompleted) {
    //     _textGlowController.repeat();
    //   }
    // });  
    // /// ============== TEXT GLOW ================
    // /// ============== ^^^^^^^^^^^^^^^^ ======================/// 
  }


  Color getColor(ColorPalette palette, Animation animation, Map<String,dynamic> currentStep, String widgetId, String stat) {
    final bool glowing = currentStep['targets'].contains(widgetId);
    final bool active = widgetId == 'streak' ? currentStep[stat] >= 1 : currentStep[stat] > 1;
    late Color res = Colors.transparent;
    if (active) {
      if (glowing) {
        res = Color.fromRGBO(
          palette.textColor2.red,
          palette.textColor2.green,
          palette.textColor2.blue,
          animation.value  
        );
      } else {
        res = palette.textColor2;
      }
    }
    return res;
  }




  @override
  Widget build(BuildContext context) {

    return Consumer<TutorialState>(
      builder:(context, tutorialState, child) {


        // final Map<String,dynamic> currentStep = TutorialHelpers().getCurrentStep(tutorialState);
        final Map<String,dynamic> currentStep = TutorialHelpers().getCurrentStep2(tutorialState);
        // final Map<String,dynamic> currentStep = tutorialDetails.firstWhere((element) => element['step'] == tutorialState.sequenceStep); 

        return SizedBox(
          width: double.infinity,
          height: 50,
          // color: Colors.grey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
        
              AnimatedBuilder(
                animation: _streakSlideEnterAnimation,
                builder: (context, child) {
                  return SlideTransition(
                    position: _streakSlideEnterAnimation,
                    child: AnimatedBuilder(
                      animation: widget.animation,
                      builder: (context, child) {
                        return Row(
                          children: [
                            Icon(
                              Icons.bolt, 
                              size: 30,
                              color: getColor(palette, widget.animation, currentStep, 'streak', 'streak'),
                              shadows: TutorialHelpers().getTextShadow(currentStep, palette, 'streak', widget.animation),
                            ),
                            Text(
                              "${currentStep['streak'].toString()}x",
                              style: TextStyle(
                                fontSize: 22,
                                color:  getColor(palette, widget.animation, currentStep, 'streak', 'streak'),
                                shadows: TutorialHelpers().getTextShadow(currentStep, palette, 'streak', widget.animation),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  );
                },
              ), 


              AnimatedBuilder(
                animation: _multiSlideAnimation,
                builder: (context, child) {
                  return SlideTransition(
                    position: _multiSlideAnimation,
                    child: AnimatedBuilder(
                      animation: widget.animation,
                      builder: (context, child) {
                        return Row(
                          children: [
                            Icon(
                              Icons.book, 
                              size: 30, 
                              color: getColor(palette, widget.animation, currentStep, 'multi_word', 'newWords'),
                              shadows: TutorialHelpers().getTextShadow(currentStep, palette, 'multi_word', widget.animation),
                            ),
                            Text(
                              "${currentStep['newWords'].toString()}x",
                              style: TextStyle(
                                fontSize: 22,
                                color: getColor(palette, widget.animation, currentStep, 'multi_word', 'newWords'),
                                shadows: TutorialHelpers().getTextShadow(currentStep, palette, 'multi_word', widget.animation),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  );
                },
              ), 


              AnimatedBuilder(
                animation: _cwSlideAnimation,
                builder: (context, child) {
                  return SlideTransition(
                    position: _cwSlideAnimation,
                    child: AnimatedBuilder(
                      animation: widget.animation,
                      builder: (context, child) {
                        return Row(
                          children: [
                            Icon(
                              Icons.close, 
                              size: 30,
                              color: getColor(palette, widget.animation, currentStep, 'cross_word', 'crossword'),
                              shadows: TutorialHelpers().getTextShadow(currentStep, palette, 'cross_word', widget.animation),
                            ),
                            Text(
                              "${currentStep['crossword'].toString()}x",
                              style: TextStyle(
                                fontSize: 22,
                                color: getColor(palette, widget.animation, currentStep, 'cross_word', 'crossword'),
                                shadows: TutorialHelpers().getTextShadow(currentStep, palette, 'cross_word', widget.animation),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  );
                },
              ),                                    
            ],
          ),
        );
      },
    );
  }
}


// Widget bonusElement(String value, String item, bool show, double opacity, ColorPalette palette) {

//   Color getColor(bool show, ColorPalette palette) {
//     Color res = Colors.transparent;
//     if (show) {
//       int red = palette.textColor2.red;
//       int green = palette.textColor2.green;
//       int blue = palette.textColor2.blue;
//       res = Color.fromRGBO(red,green,blue,opacity);
//     } else {
//       res = Colors.transparent;
//     }
//     return res;
//   }

//   late Icon icon;
//   if (item == 'streak') {
//     icon = Icon(Icons.bolt, size: 33, color: getColor(show, palette));
//   } else if (item == 'mulit_word') {
//     icon = Icon(Icons.book_online_rounded, size: 33, color: getColor(show, palette));
//   } else if (item == 'cross_word') {
//     icon = Icon(Icons.close, size: 33, color: getColor(show, palette));
//   }

//   return Row(
//     children: [
//       icon,
//       Text("${value}x"),
//     ],
//   );
// }

// class StreakItem extends StatelessWidget {
//   final Animation animation;
//   final double opacity;
//   final bool show;
//   const StreakItem({
//     super.key,
//     required this.animation,
//     required this.opacity,
//     required this.show,
//   });

//   @override
//   Widget build(BuildContext context) {
//     late TutorialState tutorialState = Provider.of<TutorialState>(context, listen: false);
//     late ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);

//     Color itemColor(ColorPalette palette, double opacity, bool show) {
//       late Color res = Colors.transparent;
//       if (show) {
//         int red = palette.textColor2.red;
//         int green = palette.textColor2.green;
//         int blue = palette.textColor2.blue;
//         res = Color.fromRGBO(red, green, blue, opacity);
//       }
//       return res;
//     }

//     return AnimatedBuilder(
//       animation: animation,
//       builder: (context, child) {
//         return Row(
//           children: [
//             Icon(Icons.bolt, size: 36, color: itemColor(palette,opacity,show),),
//             Text("${tutorialState.tutorialStreak.toString()}x")
//           ],
//         );
//       },
//     );
//   }
// }