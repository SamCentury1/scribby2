// import 'package:flutter/foundation.dart';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/tutorial_state.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_components/tutorial_board.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_components/tutorial_bonus_items.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_components/tutorial_overlay.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_components/tutorial_random_letters.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_components/tutorial_scoreboard.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_components/tutorial_step.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_components/tutorial_time_widget.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_helpers.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';
import 'package:scribby_flutter_v2/utils/states.dart';

class TutorialScreen1 extends StatefulWidget {
  const TutorialScreen1({super.key});

  @override
  State<TutorialScreen1> createState() => _TutorialScreen1State();
}

class _TutorialScreen1State extends State<TutorialScreen1> with TickerProviderStateMixin {
  late AnimationState _animationState;
  late AnimationController _textGlowController;
  late Animation<double> _textGlowAnimation;

  late ColorPalette palette;
  late TutorialState tutorialState;

  @override
  void initState() {
    super.initState();
    _animationState = Provider.of<AnimationState>(context, listen: false);
    tutorialState = Provider.of<TutorialState>(context, listen: false);
    palette = Provider.of<ColorPalette>(context, listen: false);
    initializeAnimations(palette);
    
    print(tutorialState.tutorialStateHistory);
    // _animationState.addListener(_handleAnimationStateChange);        
  } 

  void initializeAnimations(ColorPalette palette,) {

    _textGlowController = AnimationController(
      vsync: this, 
      duration: const Duration(milliseconds: 1500)
    );

    final List<TweenSequenceItem<double>> glowSequence = [
      TweenSequenceItem<double>(
          tween: Tween(
            begin: 1.0,
            end: 0.3,
          ),
          weight: 0.5),
      TweenSequenceItem<double>(
          tween: Tween(
            begin: 0.3,
            end: 1.0,
          ),
          weight: 0.5),
    ];
    _textGlowAnimation = TweenSequence<double>(glowSequence).animate(_textGlowController);

    _textGlowController.forward();
    _textGlowController.addListener(() {
      if (_textGlowController.isCompleted) {
        _textGlowController.repeat();
      }
    });

    


  }

  @override
  void dispose() {
    _textGlowController.dispose();
    super.dispose();
  }


Color getColor(ColorPalette palette, Animation animation, Map<String,dynamic> currentStep, String widgetId) {
  final bool active = currentStep['targets'].contains(widgetId);
  late Color res = palette.textColor2;
  if (active) {
    res = Color.fromRGBO(
      palette.textColor2.red,
      palette.textColor2.green,
      palette.textColor2.blue,
      animation.value  
    );
  }
  return res;
}


  @override
  Widget build(BuildContext context) {
    // final GamePlayState gamePlayState = Provider.of<GamePlayState>(context, listen: false);
    // final SettingsController settings = Provider.of<SettingsController>(context, listen: false);
    // final Palette palette = Provider.of<Palette>(context, listen: false);
    // final TutorialState tutorialState = Provider.of<TutorialState>(context, listen: false);
    final ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
    // tutorialState.setTutorialTextGlowOpacity(_textGlowAnimation.value);
    return Consumer<TutorialState>(
      builder: (context, tutorialState, child) {        

        // final Map<String,dynamic> currentStep = tutorialDetails.firstWhere((element) => element['step'] == tutorialState.sequenceStep);
        // currentStep = tutorialDetails.firstWhere((element) => element['step'] == tutorialState.sequenceStep)
        final Map<String,dynamic> currentStep = tutorialState.tutorialStateHistory.firstWhere((element) => element['step'] == tutorialState.sequenceStep);
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: palette.optionButtonBgColor,
              title: Text(
                'Tutorial',
                style: TextStyle(color: palette.textColor2),
              ),
              actions: <Widget>[
                AnimatedBuilder(
                  animation: _textGlowAnimation,
                  builder: (context, child) {
                    return TextButton(
                      onPressed: () {
                        debugPrint('skip this tutorial');
                      },
                      child: Text(
                        'Skip Tutorial',
                        style: TextStyle(
                          color: getColor(palette, _textGlowAnimation, currentStep, 'skip_tutorial')
                        ),
                      ),
                    );
                  },
                ),
                AnimatedBuilder(
                  animation: _textGlowAnimation,
                  builder: (context, child) {  
                    return IconButton(
                      color: palette.optionButtonBgColor,
                      onPressed: () {
                        debugPrint("Go back ");
                        TutorialHelpers().executePreviousStep(tutorialState, _animationState);
                      },
                      icon: Icon(
                        Icons.replay_circle_filled_sharp, 
                        color: getColor(palette, _textGlowAnimation, currentStep, 'back_step')
                      ),
                    );
                  },
                ),            
              ],
            ),
            body: Stack(
              children: [
                Container(
                  width: double.infinity,
                  color: palette.screenBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                    child: Column(
                      children: [
        
                        const TutorialTimerWidget(),
                        TutorialScoreboard(animation: _textGlowAnimation),
                        TutorialBonusItems(animation: _textGlowAnimation),
                        const Expanded(child: SizedBox()),
                        TutorialRandomLetters(animation: _textGlowAnimation),
                        const Expanded(child: SizedBox()),
                        TutorialBoard(animation: _textGlowAnimation),
                        const Expanded(child: SizedBox()),
                        Container(
                          color: palette.screenBackgroundColor,
                          child: IconButton(
                            icon: const Icon(Icons.pause_circle),
                            iconSize: 26,
                            color: palette.textColor2,
                            onPressed: () {
                              debugPrint('pause');
                            },
                          ),
                        ),
                        const TutorialStep(),                    
                      ],
                    ),
                  ),
                ),
                const TutorialOverlay(),
              ],
            ),
          ),
        );
      },
    );
  }
}
