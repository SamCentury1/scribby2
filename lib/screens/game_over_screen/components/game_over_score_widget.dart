
// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/audio/audio_controller.dart';
import 'package:scribby_flutter_v2/audio/sounds.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class ScoreWidget extends StatefulWidget {
  final int score;
  final bool newHs;
  final int highScore;
  const ScoreWidget({super.key, required this.score, required this.newHs, required this.highScore});

  @override
  State<ScoreWidget> createState() => _ScoreWidgetState();
}

class _ScoreWidgetState extends State<ScoreWidget> with TickerProviderStateMixin {

  late int count = 0;
  late int targetValue;
  late bool isCounting = false;
  // late bool isCounting = true;
  // late bool isFinalAnimationPlaying = false;

  late AnimationState animationState;

  late Animation<Color?> colorAnimation;
  late AnimationController colorController;

  late Animation<double> sizeAnimation;
  late AnimationController sizeController;  

  late Animation<double> endSizeAnimation;
  late AnimationController endSizeController; 

  late Animation<Color?> endColorAnimation;
  late AnimationController endColorController;

  late Animation<double> labelOpacityAnimation;
  late AnimationController labelOpacityController;    

  late Animation<Color?> decorationColorAnimation;
  late AnimationController decorationColorController;


  @override
  void initState() {
    super.initState();
    targetValue = widget.score;
    late ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
    initializeAnimations(widget.score, palette);
    animationState = Provider.of<AnimationState>(context, listen: false);
    animationState.addListener(_handleAnimationStateChange);
    isCounting = false;
    // _playNewHighScoreSound(isCounting);
  }

  void initializeAnimations(int score, ColorPalette palette) {
    const Color transparent =  Colors.transparent; 
    Color color_0 =  palette.textColor1; 
    const Color color_1 =  Color.fromRGBO(255,0,0,1); 
    const Color color_2 =  Color.fromRGBO(255,90,0,1); 
    const Color color_3 =  Color.fromRGBO(255,154,0,1); 
    const Color color_4 =  Color.fromRGBO(255,206,0,1); 
    const Color color_5 =  Color.fromRGBO(255,232,6,1); 

    colorController = AnimationController(
    vsync: this, duration: const Duration(milliseconds: 100));

    final List<TweenSequenceItem<Color?>> colorTweenSequenceItems = [
      TweenSequenceItem(tween: ColorTween(begin: color_2, end: color_4), weight: 0.5),
      TweenSequenceItem(tween: ColorTween(begin: color_4, end: color_2), weight: 0.5),
    ];

    colorAnimation = TweenSequence<Color?>(
      colorTweenSequenceItems,
    ).animate(colorController);


    sizeController = AnimationController(
    vsync: this, duration: const Duration(milliseconds: 100));

    final List<TweenSequenceItem<double>> sizeTweenSequenceItems = [
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 2.0), weight: 0.5),
      TweenSequenceItem(tween: Tween(begin: 2.0, end: 1.0), weight: 0.5),
    ];

    sizeAnimation = TweenSequence<double>(
      sizeTweenSequenceItems,
    ).animate(sizeController);

    endSizeController = AnimationController(
    vsync: this, duration: const Duration(milliseconds: 200));

    endSizeAnimation = Tween<double>(
      // sizeTweenSequenceItems,
      begin: 1.0, end: 0.0
    ).animate(endSizeController);

    endColorController = AnimationController(
    vsync: this, duration: const Duration(seconds: 1));

    final List<TweenSequenceItem<Color?>> endColorTweenSequenceItems = [
      TweenSequenceItem(tween: ColorTween(begin: color_0, end: color_1), weight: 0.1),
      TweenSequenceItem(tween: ColorTween(begin: color_1, end: color_2), weight: 0.1),
      TweenSequenceItem(tween: ColorTween(begin: color_2, end: color_3), weight: 0.1),
      TweenSequenceItem(tween: ColorTween(begin: color_3, end: color_4), weight: 0.1),
      TweenSequenceItem(tween: ColorTween(begin: color_4, end: color_5), weight: 0.1),
      TweenSequenceItem(tween: ColorTween(begin: color_5, end: color_4), weight: 0.1),
      TweenSequenceItem(tween: ColorTween(begin: color_4, end: color_3), weight: 0.1),
      TweenSequenceItem(tween: ColorTween(begin: color_3, end: color_2), weight: 0.1),
      TweenSequenceItem(tween: ColorTween(begin: color_2, end: color_1), weight: 0.1),
      TweenSequenceItem(tween: ColorTween(begin: color_1, end: color_0), weight: 0.1),
    ];

    endColorAnimation = TweenSequence<Color?>(
      endColorTweenSequenceItems,
    ).animate(endColorController);

    labelOpacityController = AnimationController(
    vsync: this, duration: const Duration(seconds: 2));

    labelOpacityAnimation = Tween<double>(
      // sizeTweenSequenceItems,
      begin: 0.0, end: 1.0
    ).animate(labelOpacityController);

    decorationColorController = AnimationController(
    vsync: this, duration: const Duration(seconds: 4));

    final List<TweenSequenceItem<Color?>> decorationColorTweenSequenceItems = [
      TweenSequenceItem(tween: ColorTween(begin: transparent, end: color_0), weight: 0.2),
      TweenSequenceItem(tween: ColorTween(begin: color_0, end: color_0), weight: 0.8),
    ];

    decorationColorAnimation = TweenSequence<Color?>(
      decorationColorTweenSequenceItems,
    ).animate(decorationColorController);

  }

  void _handleAnimationStateChange() {
    if (animationState.shouldRunGameOverPointsCounting) {
      _runCountPointsAnimation();
    }

    if (animationState.shouldRunGameOverPointsFinishedCounting) {
      _runFinishedCountingAnimation();

    }
  }

  _runCountPointsAnimation() {
    startCounting(widget.score, animationState);
    colorController.repeat();
    sizeController.repeat();
  }

  _runFinishedCountingAnimation() {
    endSizeController.forward();
    endColorController.forward();

    labelOpacityController.forward();
    decorationColorController.forward();
  }


  int getIncrementFactor(int score) {
    int res = 1;
    if (score >= 0 && score < 200) {
      res = 1;
    } else if (score >= 220 && score < 1500) {
      res = 5;
    } else if (score >= 1500 && score < 3000) {
      res = 10;
    } else if (score >= 3000 && score < 5000) {
      res = 15;
    } else if (score >= 5000 && score < 10000) {
      res = 20;
    } else if (score >= 10000) {
      res = 100;
    }
    return res;
  }




  void startCounting(int score, AnimationState animationState, ) {

    final audioController = context.read<AudioController>();
    audioController.playLoopSfx();

    int increment = getIncrementFactor(score);

    int i = 0; // Initialize counter outside the recursive function
    void incrementCounter() {
      if (i < score) {
        setState(() {
          count = i + increment;
        });
        i = i+increment; // Increment counter
        Future.delayed(const Duration(milliseconds: 10), incrementCounter); // Call the function recursively
      } else {
        isCounting = false;
        audioController.stopLoopSfx();
        animationState.setShouldRunGameOverPointsCounting(false);
        animationState.setShouldRunGameOverPointsFinishedCounting(true);

        if (widget.newHs) {
          animationState.setShouldRunNewHighScore(true);
          // _playNewHighScoreSound();
          audioController.playSfx(SfxType.highScore);
        } else {
          audioController.playSfx(SfxType.tada1);
        }
        Future.delayed(const Duration(seconds: 2), () {
          // animationState.setShouldRunGameOverPointsFinishedCounting(false);
          animationState.setShouldRunNewHighScore(false);
          
        });
      }
      // audioController.playSfx(SfxType.gameOverScoreCount);

    }
    
    incrementCounter(); // Start the counting process
  }  

  @override
  void dispose() {
    // Dispose of the animation controllers to release the resources
    colorController.dispose();
    sizeController.dispose();
    endSizeController.dispose();
    endColorController.dispose();
    labelOpacityController.dispose();
    decorationColorController.dispose();
    
    // If you're using the animationState listener, don't forget to remove it
    animationState.removeListener(_handleAnimationStateChange);

    // Always call super.dispose() at the end of the dispose method
    super.dispose();
  }

  String displayScoreValue(AnimationState animationState, int count, int score) {
    if (animationState.shouldRunGameOverPointsCounting) {
      return count.toString();
    } else {
      return score.toString();
    }
  }

  double containerWidth(AnimationState animationState, Animation sizeAnimation, Animation endSizeAnimation) {
    double res = 5.0;
    if (animationState.shouldRunGameOverPointsCounting) {
      res = res * sizeAnimation.value;
    } else {
      res = res * endSizeAnimation.value;
    }
    return res;
  }

  Color getTextColor(AnimationState animationState, Animation colorAnimation, Animation endColorAnimation, ColorPalette palette) {
    Color res = palette.textColor1;
    if (animationState.shouldRunGameOverPointsCounting) {
      res = colorAnimation.value;
    } 
    
    if (animationState.shouldRunGameOverPointsFinishedCounting) {
      res = endColorAnimation.value;
    }
    return res;
  }

  Color getContainerColor(AnimationState animationState, Animation colorAnimation, Animation endColorAnimation) {
    Color res = Colors.transparent;
    if (animationState.shouldRunGameOverPointsCounting) {
      res = colorAnimation.value;
    } 
    
    // if (isFinalAnimationPlaying) {
    //   res = endColorAnimation.value;
    // }
    return res;    
  }

  String sizeOfContainer(int score) {
    int digits = score.toString().length;
    late List<String> items = [];
    for (int i=0; i<digits; i++) {
      items.add("8");
    }
    return items.join("");
  }

  Color getLabelColor(AnimationState animationState, Animation animation, ColorPalette palette) {
    Color res = Colors.transparent;
    if (!animationState.shouldRunGameOverPointsCounting) {
      int r = palette.textColor2.red;
      int g = palette.textColor2.green;
      int b = palette.textColor2.blue;

      res = Color.fromRGBO(r,g,b,animation.value);
    }
    return res;
  }

   Color getDecorationColor(AnimationState animationState, Animation colorAnimation, bool newHs) {
    Color res = Colors.transparent;
    if (!animationState.shouldRunGameOverPointsCounting) {
      if (newHs) {
        res = colorAnimation.value;
      }
    } 
    return res;
  } 


  String getLabelText(bool newHs, String language) {
    String text = "";
    if (newHs) {
      text = "New High Score";
    } else {
      text = "Score";
    }
    String translated = Helpers().translateText(language, text);
    return translated;
  }

  String getLabelText2(bool newHs, int highScore, language) {
    String res = "";
    String text = ""; 
    if (newHs) {
      text = "Previous High Score:";
    } else {
      text = "High Score:";
    }
    String translated = Helpers().translateText(language, text);
    res = "$translated $highScore";

    return res;
  }  

  @override
  Widget build(BuildContext context) {

    late SettingsState settingsState = Provider.of<SettingsState>(context,listen: false);
    late ColorPalette palette = Provider.of<ColorPalette>(context,listen: false);
    final String language = settingsState.userData['parameters']['currentLanguage'];

    return AnimatedBuilder(
      animation: Listenable.merge([colorAnimation, sizeAnimation, endSizeAnimation, endColorAnimation, labelOpacityAnimation, decorationColorAnimation]),
      builder: (context, child) {
        return Column(
          children: [
            // isCounting ? Expanded(child: Container(width: 100, height: 20, color: Colors.red,)) : Expanded(child: SizedBox()),
            Text(
              getLabelText(widget.newHs, language),
              style: TextStyle(
                color: getLabelColor(animationState, labelOpacityAnimation, palette),
                fontSize: 22*settingsState.sizeFactor
              ),
            ),
            Center(
              child: Stack(
                children: [
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(
                          child: Icon(
                            Icons.emoji_events,
                            size: 32*settingsState.sizeFactor,
                            color: getDecorationColor(animationState, decorationColorAnimation, widget.newHs),
                          ),
                        )
                      ),
                  
                      Wrap(
                        direction: Axis.vertical,
                        // alignment: WrapAlignment.center,
                        // runAlignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:   Colors.transparent,
                                width:  containerWidth(animationState, sizeAnimation, endSizeAnimation) //5 * sizeAnimation.value
                              ),
                              borderRadius: const BorderRadius.all(Radius.circular(14.0))
                            ),
                                  
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18.0),
                              child: Text(
                                // score.toString(),
                                displayScoreValue(animationState, count, widget.score),
                          
                                style: GoogleFonts.zenDots(
                                  fontSize: 56*settingsState.sizeFactor,
                                  color: getTextColor(animationState,colorAnimation,endColorAnimation, palette), // colorAnimation.value ?? Colors.orange,
                                  letterSpacing: 0.0
                                    
                                    
                                ),
                              ),
                            ),
                          ),
                        ],
                      
                      ),       
                      Expanded(
                        child: SizedBox(
                          child: Icon(
                            Icons.emoji_events,
                            size: 32*settingsState.sizeFactor,
                            color: getDecorationColor(animationState,  decorationColorAnimation,widget.newHs),
                          ),
                        )
                      ),  
                    ],
                  ),
              
              
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(
                          child: Icon(
                            Icons.star,
                            size: 32*settingsState.sizeFactor,
                            color: Colors.transparent// getLabelColor(animationState, labelOpacityAnimation),
                          ),
                        )
                      ),
                  
                      Wrap(
                        direction: Axis.vertical,
                        // alignment: WrapAlignment.center,
                        // runAlignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: getContainerColor(animationState,colorAnimation,endColorAnimation), // colorAnimation.value ?? Colors.transparent,
                                width:  containerWidth(animationState, sizeAnimation, endSizeAnimation) //5 * sizeAnimation.value
                              ),
                              borderRadius: const BorderRadius.all(Radius.circular(14.0))
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18.0),
                              child: Text(
                                // score.toString(),
                                sizeOfContainer(widget.score),
                                                  
                                style: GoogleFonts.zenDots(
                                  fontSize: 56*settingsState.sizeFactor,
                                  color: Colors.transparent, //getTextColor(isCounting,isFinalAnimationPlaying,colorAnimation,endColorAnimation), // colorAnimation.value ?? Colors.orange,
                                  letterSpacing: 0.0
                                    
                                    
                                ),
                              ),
                            ),
                          ),
                        ],
                      
                      ),       
                      Expanded(
                        child: SizedBox(
                          child: Icon(
                            Icons.star,
                            size: 32*settingsState.sizeFactor,
                            color: Colors.transparent// getLabelColor(isCounting, labelOpacityAnimation),
                          ),
                        )
                      ),    
                    ],
                  ),        
                ],
              ),
            ),
            Text(
              getLabelText2(widget.newHs, widget.highScore, language),
              style: TextStyle(
                color: getLabelColor(animationState, labelOpacityAnimation, palette),
                fontSize: 18*settingsState.sizeFactor
              ),
            ),
            const Expanded(child: SizedBox()),
          ],
        );
      }
    );
  }
}



 