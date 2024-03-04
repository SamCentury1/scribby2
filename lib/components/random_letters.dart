import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/game_logic.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
// import 'package:scribby_flutter_v2/settings/settings.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class RandomLetters extends StatefulWidget {
  final double tileSize;
  final SettingsState settingsState;
  const RandomLetters({
    super.key,
    required this.tileSize,
    required this.settingsState,
  });

  @override
  State<RandomLetters> createState() => _RandomLettersState();
}

class _RandomLettersState extends State<RandomLetters>
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
  late GamePlayState _gamePlayState;

  // HERE WE GET THE PROVIDER
  @override
  void initState() {
    super.initState();
    initializeAnimations(widget.tileSize, widget.settingsState.sizeFactor );
    _animationState = Provider.of<AnimationState>(context, listen: false);
    _gamePlayState = Provider.of<GamePlayState>(context, listen: false);
    _animationState.addListener(_handleAnimationStateChange);
    _gamePlayState.addListener(_handleGamePlayStateChange);
    secondsLeft = GameLogic().getCountdownDuration(_gamePlayState.currentLevel);
  }

  void _handleGamePlayStateChange() {
    // Check if the level has changed
    if (_gamePlayState.currentLevel != _gamePlayState.previousLevel) {
      setState(() {
        secondsLeft =
            GameLogic().getCountdownDuration(_gamePlayState.currentLevel);
      });
    }
  }

  void _handleAnimationStateChange() {
    if (_animationState.shouldRunAnimation) {
      _runAnimations();
    }
  }

  // THIS FUNCTION TELLS THE CODE WHAT TO DO
  void initializeAnimations(double tileSize, double sizeFactor) {
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
      begin: tileSize * 0.5,
      end: tileSize,
    ).animate(CurvedAnimation(
        parent: _sizeAnimationController, curve: Curves.easeIn));

    _fontAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _fontAnimation = Tween<double>(
      begin: 26 * sizeFactor,
      end: 44 * sizeFactor,
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

    _gamePlayState.removeListener(_handleGamePlayStateChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final SettingsController settings = Provider.of<SettingsController>(context, listen: false);
    // final Palette palette = Provider.of<Palette>(context, listen: false);
    final ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
    final SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);
    final double width = MediaQuery.of(context).size.width *0.6;
    final double side = width/3.3;

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Consumer<GamePlayState>(
              builder: (context, gamePlayState, child) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width * settingsState.sizeFactor,
                  height: side*1.1,                  
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Stack(
                            children: [
                              // CountDownTimer()

                              Align(
                                alignment: Alignment.center,
                                child: CircularCountDownTimer(
                                  duration: GameLogic().getCountdownDuration(
                                      gamePlayState.currentLevel), // 5,
                                  initialDuration: GameLogic()
                                      .getCountdownDuration(
                                          gamePlayState.currentLevel), // 5,
                                  controller: gamePlayState.countDownController,
                                  width: side * settingsState.sizeFactor,
                                      // 70, // MediaQuery.of(context).size.width / 3,
                                  height: side * settingsState.sizeFactor,// MediaQuery.of(context).size.height / 3,
                                  // ringColor: GameLogic().getColor(settings.darkTheme.value, palette, "tile_bg"),  // Colors.grey[300]!,
                                  ringColor: palette.tileBgColor,
                                  ringGradient: null,
                                  fillColor: palette
                                      .tileTextColor, // Colors.purpleAccent[100]!,
                                  fillGradient: null,
                                  // backgroundColor:GameLogic().getColor(settings.darkTheme.value, palette, "screen_background"),
                                  backgroundColor:
                                      palette.screenBackgroundColor,
                                  backgroundGradient: null,
                                  strokeWidth: 5.0,
                                  strokeCap: StrokeCap.round,
                                  textStyle: TextStyle(
                                      fontSize: (33.0 * settingsState.sizeFactor),
                                      // color: GameLogic().getColor(settings.darkTheme.value, palette, "tile_bg"),
                                      color: palette.tileBgColor),
                                  textFormat: CountdownTextFormat.S,
                                  isReverse: true,
                                  isReverseAnimation: false,
                                  isTimerTextShown: true,
                                  autoStart: true,
                                  onStart: () {},
                                  onComplete: () {
                                    if (gamePlayState.isGameStarted) {
                                      GameLogic()
                                          .killTileSpot(gamePlayState, context);
                                    } else {}
                                  },
                                  onChange: (String timeStamp) {},
                                  timeFormatterFunction:
                                      (defaultFormatterFunction, duration) {
                                    if (duration.inSeconds <= 3) {
                                      return Function.apply(
                                          defaultFormatterFunction, [duration]);
                                    } else {
                                      return "";
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Stack(
                            children: [
                              AnimatedBuilder(
                                animation: _shrinkAnimation,
                                builder: (context, child) {
                                  return Center(
                                    child: Container(
                                      width: (side * 1) * _shrinkAnimation.value,
                                      height: (side * 1) * _shrinkAnimation.value,
                                      decoration: BoxDecoration(
                                          color: palette.tileBgColor,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Center(
                                          child: Text(
                                        GameLogic().displayRandomLetters(
                                            gamePlayState.randomLetterList, 3),
                                        style: TextStyle(
                                          fontSize: (44 * settingsState.sizeFactor) * _shrinkAnimation.value,
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
                                        width:  (_sizeAnimation.value ),
                                        height:  (_sizeAnimation.value ),
                                        decoration: BoxDecoration(
                                            color: palette.tileBgColor,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10))),
                                        child: Center(
                                            child: Text(
                                          GameLogic().displayRandomLetters(
                                              gamePlayState.randomLetterList,
                                              2),
                                          // widget.letter_1,
                                          // "A",
                                          style: TextStyle(
                                            fontSize: _fontAnimation.value,
                                            color: palette.tileTextColor,
                                          ),
                                        )),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: SlideTransition(
                            position: _letter2Animation,
                            child: Center(
                                child: Container(
                                    width: (side*0.6),
                                    height: (side*0.6),
                                    decoration: BoxDecoration(
                                        color: palette.tileBgColor,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Center(
                                      child: Text(
                                        GameLogic().displayRandomLetters(
                                            gamePlayState.randomLetterList, 1),
                                        style: TextStyle(
                                          fontSize: (26 * settingsState.sizeFactor),
                                          color: palette.tileTextColor,
                                        ),
                                      ),
                                    ))),
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
