import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/game_logic.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/providers/tutorial_state.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_helpers.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';
import 'package:scribby_flutter_v2/utils/states.dart';

class TutorialRandomLetters extends StatefulWidget {
  final Animation animation;
  final double sizeFactor;
  const TutorialRandomLetters({
    super.key,
    required this.animation,
    required this.sizeFactor,
  });

  @override
  State<TutorialRandomLetters> createState() => _TutorialRandomLettersState();
}

class _TutorialRandomLettersState extends State<TutorialRandomLetters>
    with TickerProviderStateMixin {
  late AnimationState _animationState;

  // DEFINE THE VARIABLES THAT WILL CONTROL THE ANIMATIONS FOR THE FIRST LETTER AND SECOND LETTER
  // FIRST LETTER
  late AnimationController _shrinkAnimationController;
  late Animation<double> _shrinkAnimation;

  // HANDLES THE SMALL SLIDE FROM LETTER 2 TO LETTER 1
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  // HANDLES THE TILE GETTING BIGGER
  late AnimationController _sizeAnimationController;
  late Animation<double> _sizeAnimation;

  // HANDLES THE FONT GETTING BIGGER
  late AnimationController _fontAnimationController;
  late Animation<double> _fontAnimation;

  // HANDLES LETTER 2 SLIDING DOWN FROM THE TOP
  late AnimationController _letter2SlideController;
  late Animation<Offset> _letter2Animation;

  // HANDLES THE FONT GETTING BIGGER
  late int secondsLeft;
  late TutorialState _tutorialState;

  // HERE WE GET THE PROVIDER
  @override
  void initState() {
    super.initState();
    initializeAnimations(widget.sizeFactor);
    _animationState = Provider.of<AnimationState>(context, listen: false);
    _tutorialState = Provider.of<TutorialState>(context, listen: false);
    _animationState.addListener(_handleAnimationStateChange);
    // _tutorialState.addListener(_handleGamePlayStateChange);
    // _tutorialState.tutorialCountDownController.pause();


  }

  // void _handleGamePlayStateChange() {
  //   // Check if the level has changed
  //   if (_gamePlayState.currentLevel != _gamePlayState.previousLevel) {
  //     setState(() {
  //       secondsLeft =
  //           GameLogic().getCountdownDuration(_gamePlayState.currentLevel);
  //     });
  //   }
  // }

  void _handleAnimationStateChange() {
    if (_animationState.shouldRunAnimation) {
      _runAnimations();
    }
  }

  // THIS FUNCTION TELLS THE CODE WHAT TO DO
  void initializeAnimations(double sizeFactor) {

    // final double width = MediaQuery.of(context).size.width *0.6;
    // final double side = width/3;

    _shrinkAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _shrinkAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(CurvedAnimation(
        parent: _shrinkAnimationController, curve: Curves.easeIn));

    // FIRST LETTER
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(_slideController);

    _sizeAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _sizeAnimation = Tween<double>(
      begin: 40*sizeFactor, // 50,
      end: 76*sizeFactor // 100,
    ).animate(CurvedAnimation(
        parent: _sizeAnimationController, curve: Curves.easeIn));

    _fontAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _fontAnimation = Tween<double>(
      begin: 22*sizeFactor,
      end: 42*sizeFactor,
    ).animate(CurvedAnimation(
        parent: _fontAnimationController, curve: Curves.easeIn));

    // SECOND LETTER
    _letter2SlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _letter2Animation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(_letter2SlideController);

    _slideController.forward();
    _shrinkAnimationController.forward();
    _sizeAnimationController.forward();
    _fontAnimationController.forward();
    _letter2SlideController.forward();
  }

  void _runAnimations() {
    _slideController.reset();
    _shrinkAnimationController.reset();
    _sizeAnimationController.reset();
    _fontAnimationController.reset();
    _letter2SlideController.reset();
    // _countDownTextSizeController.reset();

    _slideController.forward();
    _shrinkAnimationController.forward();
    _sizeAnimationController.forward();
    _fontAnimationController.forward();
    _letter2SlideController.forward();
    // _countDownTextSizeController.forward();
  }

  @override
  void dispose() {
    _animationState.removeListener(_handleAnimationStateChange);
    _slideController.dispose();
    _shrinkAnimationController.dispose();
    _sizeAnimationController.dispose();
    _fontAnimationController.dispose();
    _letter2SlideController.dispose();
    // _countDownTextSizeController.dispose();

    // _gamePlayState.removeListener(_handleGamePlayStateChange);
    super.dispose();
  }


Color getColor(ColorPalette palette, Animation animation, Map<String,dynamic> currentStep, String widgetId) {
  final bool active = currentStep['targets'].contains(widgetId);
  late Color res = Colors.transparent;
  if (active) {
    res = Color.fromRGBO(
      palette.focusedTutorialTile.red,
      palette.focusedTutorialTile.green,
      palette.focusedTutorialTile.blue,
      animation.value  
    );
  }
  return res;
}

  @override
  Widget build(BuildContext context) {
    // final SettingsController settings = Provider.of<SettingsController>(context, listen: false);
    // final Palette palette = Provider.of<Palette>(context, listen: false);
    final ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
    final SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);

    final double width = MediaQuery.of(context).size.width *0.6*settingsState.sizeFactor;
    final double side = width/3;

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Consumer<TutorialState>(
              builder: (context, tutorialState, child) {

                // final Map<String,dynamic> currentStep = tutorialDetails.firstWhere((element) => element['step'] == tutorialState.sequenceStep,);
                final Map<String,dynamic> currentStep = TutorialHelpers().getCurrentStep2(tutorialState);

                if (currentStep['targets'].contains('countdown')) {
                  late Map<String,dynamic> tile35 = tutorialState.tutorialTileState.firstWhere((element) => element['index'] == 35);

                  if (tile35['alive']) {
                    tutorialState.tutorialCountDownController.restart(
                      duration: 5,
                    );
                  }
                }             

                return SizedBox(
                  // color: Color.fromARGB(255, 220, 171, 230),
                  // width: double.infinity,
                  // height: 100,
                  width: MediaQuery.of(context).size.width*0.8*settingsState.sizeFactor,
                  height: side*1.2,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: AnimatedBuilder(
                            animation: widget.animation,
                            builder: (context, child) {                              
                              return Container(
                                decoration: BoxDecoration(
                                  color: palette.screenBackgroundColor,
                                  border: Border.all(
                                    // color: Colors.white,
                                    color: getColor(palette,widget.animation, currentStep,'countdown'),
                                    width: 3
                                  ),
                                  borderRadius: const BorderRadius.all(Radius.circular(100.0)),
                                  boxShadow: [
                                    TutorialHelpers().getBoxShadow(currentStep, palette, 'countdown', widget.animation)
                                  ] 
                                ),                                
                                child: Stack(
                                  children: [
                                    // CountDownTimer()
                                
                                    Align(
                                      alignment: Alignment.center,
                                      child: CircularCountDownTimer(
                                        duration: 0,
                                        initialDuration: 0,
                                        controller: tutorialState.tutorialCountDownController,
                                        width: side*0.8,
                                            // 70, // MediaQuery.of(context).size.width / 3,
                                        height: side*0.8,
                                            // 70, // MediaQuery.of(context).size.height / 3,
                                        // ringColor: GameLogic().getColor(settings.darkTheme.value, palette, "tile_bg"),  // Colors.grey[300]!,
                                        ringColor: tutorialState.sequenceStep == 7 ? palette.tileBgColor : palette.tileTextColor,
                                        ringGradient: null,
                                        fillColor: palette.tileTextColor, // Colors.purpleAccent[100]!,
                                        fillGradient: null,
                                        // backgroundColor:GameLogic().getColor(settings.darkTheme.value, palette, "screen_background"),
                                        backgroundColor:
                                            palette.screenBackgroundColor,
                                        backgroundGradient: null,
                                        strokeWidth: 5.0,
                                        strokeCap: StrokeCap.round,
                                        textStyle: TextStyle(
                                            fontSize: 33.0*settingsState.sizeFactor,
                                            // color: GameLogic().getColor(settings.darkTheme.value, palette, "tile_bg"),
                                            color:  tutorialState.sequenceStep == 7 ? palette.tileBgColor : palette.screenBackgroundColor
                                          ),
                                        textFormat: CountdownTextFormat.S,
                                        isReverse: true,
                                        isReverseAnimation: false,
                                        isTimerTextShown: true,
                                        autoStart: true,
                                        onStart: () {
                                        },
                                        onComplete: () {
                                          if (currentStep['targets'].contains('countdown')) {
                                            // TutorialHelpers().killSpot(tutorialState, 35);
                                            tutorialState.setSequenceStep(tutorialState.sequenceStep+1);
                                            _animationState.setShouldRunAnimation(true);
                                            _animationState.setShouldRunAnimation(false);
                                            _animationState.setShouldRunTutorialNextStepAnimation(true);
                                            _animationState.setShouldRunTutorialNextStepAnimation(false);


                                          }
                                          // tutorialState.tutorialCountDownController.restart()
                                        },
                                        onChange: (String timeStamp) {},
                                        timeFormatterFunction: (defaultFormatterFunction, duration) {
                                          
                                          if (duration.inSeconds >= 0 && duration.inSeconds <= 5 ) {
                                            String durationString = Function.apply(defaultFormatterFunction, [duration]);
                                            int parsedDuration = int.parse(durationString);
                                            String finalDuration = (parsedDuration+1).toString();
                                            return finalDuration;
                                            // return Function.apply(defaultFormatterFunction, [duration]);
                                          } else {
                                            return "";
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: AnimatedBuilder(
                            animation: widget.animation,
                            builder: (context, child) {                           
                              return Container(
                                // color: Colors.blue,
                                decoration: BoxDecoration(
                                  color: palette.screenBackgroundColor,
                                  border: Border.all(
                                    color: getColor(palette,widget.animation, currentStep,'random_letter_1'),
                                    width: 3*settingsState.sizeFactor
                                  ),
                                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                  boxShadow: [
                                    TutorialHelpers().getBoxShadow(currentStep, palette, 'random_letter_1', widget.animation)
                                  ]                                  
                                ),
                                child: Stack(
                                  children: [
                                    AnimatedBuilder(
                                      animation: _shrinkAnimation,
                                      builder: (context, child) {
                                        return Center(
                                          child: Container(
                                            width: (side*0.8) * _shrinkAnimation.value,
                                            height: (side*0.8) * _shrinkAnimation.value,
                                            decoration: BoxDecoration(
                                                color: palette.tileBgColor,
                                                borderRadius: const BorderRadius.all(
                                                    Radius.circular(10))),
                                            child: Center(
                                                child: Text(
                                                // GameLogic().displayRandomLetters(tutorialState.tutorialRandomLetterList,3),
                                                currentStep['random_letter_3'],
                                              style: TextStyle(
                                                fontSize: 36 *settingsState.sizeFactor * _shrinkAnimation.value,
                                                color: palette.tileTextColor,
                                              ),
                                            )),
                                          ),
                                        );
                                      },
                                    ),
                                    AnimatedBuilder(
                                      animation: _sizeAnimation,
                                      builder: (context, child) {
                                        return SlideTransition(
                                          position: _slideAnimation,
                                          child: Center(
                                            child: Container(
                                              width: _sizeAnimation.value,
                                              height: _sizeAnimation.value,
                                              decoration: BoxDecoration(
                                                color: palette.tileBgColor,
                                                borderRadius: const BorderRadius.all(Radius.circular(10))),
                                                child: Center(
                                                  child: Text(currentStep['random_letter_2'],
                                                  style: TextStyle(
                                                    fontSize: _fontAnimation.value,
                                                    color: palette.tileTextColor,
                                                  ),
                                                )
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: AnimatedBuilder(
                            animation: widget.animation,
                            builder: (context, child) {
                              return SlideTransition(
                                position: _letter2Animation,
                                child: Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: palette.screenBackgroundColor,
                                      border: Border.all(
                                        color: getColor(palette,widget.animation, currentStep,'random_letter_2'),
                                        width: 3*settingsState.sizeFactor
                                      ),
                                      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                      boxShadow: [
                                        TutorialHelpers().getBoxShadow(currentStep, palette, 'random_letter_2', widget.animation)
                                      ]
                                    ),                                         
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0*settingsState.sizeFactor),
                                      child: Container(
                                        width: side *0.6, // 50,
                                        height: side *0.6, // 50,
                                        decoration: BoxDecoration(
                                            color: palette.tileBgColor,
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Center(
                                          child: Text(
                                            currentStep['random_letter_1'],
                                            style: TextStyle(
                                              fontSize: 22*settingsState.sizeFactor,
                                              color: palette.tileTextColor,
                                            ),
                                          ),
                                        )
                                      ),
                                    ),
                                  )
                                ),
                              );
                            },
                          ),
                        ),
                      ]),
                );
              },
            ),
          ],
        )
      ],
    );
  }
}
