// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/components/dialog_widget.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/providers/tutorial_state.dart';
import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
import 'package:scribby_flutter_v2/screens/game_screen/game_screen.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_components/tutorial_board.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_components/tutorial_bonus_items.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_components/tutorial_ended_overlay.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_components/tutorial_floating_step.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_components/tutorial_overlay.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_components/tutorial_pause_overlay.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_components/tutorial_random_letters.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_components/tutorial_scoreboard.dart';
// import 'package:scribby_flutter_v2/screens/tutorial/tutorial_components/tutorial_step.dart';
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

class _TutorialScreen1State extends State<TutorialScreen1>
    with TickerProviderStateMixin {
  late AnimationState _animationState;
  late AnimationController _textGlowController;
  late Animation<double> _textGlowAnimation;
  late SettingsController settings;
  late GamePlayState gamePlayState;

  late ColorPalette palette;
  late TutorialState tutorialState;
  late bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationState = Provider.of<AnimationState>(context, listen: false);
    tutorialState = Provider.of<TutorialState>(context, listen: false);
    settings = Provider.of<SettingsController>(context, listen: false);
    palette = Provider.of<ColorPalette>(context, listen: false);
    gamePlayState = Provider.of<GamePlayState>(context, listen: false);
    initializeAnimations(palette);



  }

  void initializeAnimations(
    ColorPalette palette,
  ) {
    _textGlowController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));

    final List<TweenSequenceItem<double>> glowSequence = [
      TweenSequenceItem<double>(
          tween: Tween(
            begin: 0.3,
            end: 1.0,
          ),
          weight: 0.5),
      TweenSequenceItem<double>(
          tween: Tween(
            begin: 1.0,
            end: 0.3,
          ),
          weight: 0.5),
    ];
    _textGlowAnimation =
        TweenSequence<double>(glowSequence).animate(_textGlowController);

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

  Color getColor(ColorPalette palette, Animation animation,
      Map<String, dynamic> currentStep, String widgetId) {
    final bool active = currentStep['targets'].contains(widgetId);
    late Color res = palette.textColor2;
    if (active) {
      res = Color.fromRGBO(palette.textColor2.red, palette.textColor2.green,
          palette.textColor2.blue, animation.value);
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {

    final ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
    final AnimationState animationState = Provider.of<AnimationState>(context, listen: false);
    final SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);
    return Consumer<TutorialState>(
      builder: (context, tutorialState, child) {
        final Map<String, dynamic> currentStep = TutorialHelpers().getCurrentStep2(tutorialState);

        return SafeArea(
            child: Stack(
          children: [
            Scaffold(            
              backgroundColor: palette.screenBackgroundColor,
              appBar: PreferredSize(
                
                preferredSize: Size(double.infinity, 58.0*settingsState.sizeFactor,),

                child: AppBar(
                  leading: null,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(30.0)
                    )
                  ),
                  backgroundColor: palette.appBarColor,
                  title: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      Helpers().translateText(gamePlayState.currentLanguage, "Demonstration"),
                      style: TextStyle(color: palette.textColor2),
                    ),
                  ),
                  actions: <Widget>[
                    AnimatedBuilder(
                      animation: _textGlowAnimation,
                      builder: (context, child) {
                        return TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: palette.optionButtonBgColor,
                                  title: Text(
                                    Helpers().translateText(gamePlayState.currentLanguage, "Skip Tutorial"),
                                    style: TextStyle(
                                      color: palette.textColor2,
                                      fontSize: 22 * settingsState.sizeFactor
                                    ),
                                  ),
                                  content: Text(
                                    Helpers().translateText(
                                      gamePlayState.currentLanguage,
                                      'Are you sure you want to skip the tutorial?',
                                    ),
                                    style: TextStyle(
                                      color: palette.textColor2,
                                      fontSize: 18 * settingsState.sizeFactor
                                    ),
                                  ),
                                  actions: <TextButton>[
                                    TextButton(
                                        onPressed: () {
                                          FirestoreMethods().updateParameters(
                                              (settings.userData.value as Map<String, dynamic>)['uid'],'hasSeenTutorial',true);
                                          Helpers().getStates(gamePlayState, settings);

                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) => const GameScreen()),
                                          );
                                        },
                                        child: Text(
                                          Helpers().translateText(gamePlayState.currentLanguage, "Yes"),
                                          style: TextStyle(
                                            color: palette.textColor2,
                                            fontSize: 18 * settingsState.sizeFactor
                                          ),
                                        ),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          Helpers().translateText(gamePlayState.currentLanguage, "Cancel"),
                                          style: TextStyle(
                                            color: palette.textColor2,
                                            fontSize: 18 * settingsState.sizeFactor
                                          ),                                          
                                        ),
                                    )
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(
                            Helpers().translateText(gamePlayState.currentLanguage, 'Skip Tutorial'),
                            
                            style: TextStyle(
                              color: getColor(palette, _textGlowAnimation,currentStep, 'skip_tutorial'),
                              fontSize: 16*settingsState.sizeFactor
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
                          iconSize: 22*settingsState.sizeFactor,
                          onPressed: () {
                            // if (currentStep['step'] == 36) {
                            //   tutorialState.setSequenceStep(tutorialState.sequenceStep-14);
                            // }
                            TutorialHelpers().executePreviousStep(tutorialState, animationState);
                            if (tutorialState.sequenceStep == 6) {
                              tutorialState.tutorialCountDownController.restart(
                                duration: 5,
                              );
                              tutorialState.tutorialCountDownController.pause();                       
                              // tutorialState.tutorialCountDownController.restart();
                            }
                            debugPrint(tutorialState.sequenceStep.toString());
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
                          TutorialTimerWidget(animation: _textGlowAnimation, language: gamePlayState.currentLanguage),
                          TutorialScoreboard(animation: _textGlowAnimation),
                          TutorialBonusItems(animation: _textGlowAnimation),
                          const Expanded(flex: 10, child: SizedBox()),
                          TutorialRandomLetters(animation: _textGlowAnimation, sizeFactor: settingsState.sizeFactor,),
                          TutorialBoard(animation: _textGlowAnimation),
                          const Expanded(child: SizedBox()),
                          Container(
                            padding: EdgeInsets.only(bottom: 10.0*settingsState.sizeFactor),
                            color: palette.screenBackgroundColor,
                            child: AnimatedBuilder(
                              animation: _textGlowAnimation,
                              builder: (context, child) {
                                return InkWell(
                                  child: Icon(
                                    Icons.pause_circle,
                                    shadows: TutorialHelpers().getTextShadow(currentStep,palette,'pause',_textGlowAnimation),
                                    size: 26*settingsState.sizeFactor,
                                    color: getColor(palette,_textGlowAnimation,currentStep,'pause'), //palette.textColor2,
                                  ),
                                  onTap: () {
                                    if (currentStep['callbackTarget'] =='pause') {
                                      tutorialState.setSequenceStep(tutorialState.sequenceStep + 1);
                                      animationState.setShouldRunTutorialNextStepAnimation(true);
                                      animationState.setShouldRunTutorialNextStepAnimation(false);
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // TutorialPauseOverlay(
                  //   animation: _textGlowAnimation,
                  // ),
                  // const TutorialOverlay(),
                ],
              ),
            ),
            const TutorialEndedOverlay(),
            const PreGameOverlay(),
            TutorialFloatingStep(
              width: MediaQuery.of(context).size.width,
              // tutorialState: tutorialState,
            )
          ],
        ));
      },
    );
  }
}

Widget spaceForSteps(Map<String, dynamic> currentStep) {
  Widget res = const SizedBox();
  if (currentStep['isGameStarted']) {
    if (currentStep['isGameEnded']) {
      res = const SizedBox(
        height: 100,
      );
    } else {
      res = const SizedBox();
    }
  } else {
    res = const SizedBox(
      height: 100,
    );
  }
  return res;
}

