import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:scribby_flutter_v2/functions/game_logic.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';
// import 'package:scribby_flutter_v2/providers/game_state.dart';
// import 'package:scribby_flutter_v2/providers/timer_state.dart';

class Scoreboard extends StatefulWidget {
  const Scoreboard({
    super.key,
  });

  @override
  State<Scoreboard> createState() => _ScoreboardState();
}

class _ScoreboardState extends State<Scoreboard> with TickerProviderStateMixin {
  late AnimationState _animationState;

  // late AnimationController _streakSlideEnterController;
  // late Animation<Offset> _streakSlideEnterAnimation;

  // late int scorePoints = 0;

  late AnimationController _scoreScaleController;
  late Animation<double> _scoreScaleAnimation;

  late AnimationController _scoreTextController;
  late Animation<Color?> _scoreTextAnimation;

  late AnimationController _scoreBorderController;
  late Animation<Color?> _scoreBorderAnimation;

  late SequenceAnimation sequenceAnimation;

  late ColorPalette palette;
  // late AnimationController _timerController;
  // late Animation<double> _timerAnimation;

  late String formattedTime;

  @override
  void initState() {
    super.initState();
    // displayFormattedTime(0);
    palette = Provider.of<ColorPalette>(context, listen: false);
    
    initializeAnimations(palette);

    // formattedTime = GameLogic().formatTime(timeInSeconds)

    _animationState = Provider.of<AnimationState>(context, listen: false);
    _scoreTextController.addListener(_animationListener);
    // _streakSlideEnterController.addListener(_animationListener);
    // _timerAnimation.addListener(_animationListener);
    _animationState.addListener(_handleAnimationStateChange);
  }

  void _handleAnimationStateChange() {
    if (_animationState.shouldRunWordAnimation) {
      _runAnimations();
    }

    // if (_animationState.shouldRunStreaksEnterAnimation) {
    //   _runStreakAnimation('enter');
    // }

    // if (_animationState.shouldRunStreaksExitAnimation) {
    //   _runStreakAnimation('exit');
    // }

    // if (_animationState.shouldRunTimerAnimation) {
    //   _runTimerAnimation();
    // }
  }

  void _animationListener() {
    if (_scoreTextController.status == AnimationStatus.completed) {
      _scoreTextController.reset();
      _scoreScaleController.reset();
      _scoreBorderController.reset();
    }

    // if (_streakSlideEnterController.status == AnimationStatus.completed) {

    // }

    // if (_timerController.status == AnimationStatus.completed) {
    //   _timerController.reset();
    // }
  }

  // void _runStreakAnimation(String status) {
  //   if (status == 'enter') {
  //     _streakSlideEnterController.reset();
  //     _streakSlideEnterController.forward();
  //   } else if (status == 'exit') {
  //     _streakSlideEnterController.reverse();
  //   }
  // }

  void _runAnimations() {
    _scoreTextController.reset();
    _scoreScaleController.reset();
    _scoreBorderController.reset();

    _scoreTextController.forward();
    _scoreScaleController.forward();
    _scoreBorderController.forward();
  }

  // void _runTimerAnimation() {
  //   _timerController.reset();

  //   _timerController.forward();
  // }

  void initializeAnimations(ColorPalette palette) {
    // /// ============== vvvvvvvvvvvvvvvv ======================
    // /// ============== STREAK OFFSET ================
    // _streakSlideEnterController = AnimationController(
    //   vsync: this,
    //   duration: const Duration(milliseconds: 300)
    // );

    // _streakSlideEnterAnimation = Tween<Offset>(
    //   // streakSlideEnterTweenSequence
    //   begin: Offset(-1.2, 0.0),
    //   end: Offset(0.0, 0.0),
    // ).animate(_streakSlideEnterController);
    // /// ============== STREAK OFFSET ================
    // /// ============== ^^^^^^^^^^^^^^^^ ======================

    /// ============== vvvvvvvvvvvvvvvv ======================
    /// ============== SCOREBOARD SCALE ================
    _scoreScaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // Adjust duration as needed
    );
    final List<TweenSequenceItem<double>> scoreScaleTweenSequence = [
      TweenSequenceItem<double>(
          tween: Tween(
            begin: 1.0,
            end: 1.0,
          ),
          weight: 0.2),
      TweenSequenceItem<double>(
          tween: Tween(
            begin: 1.0,
            end: 1.0,
          ),
          weight: 0.2),
      TweenSequenceItem<double>(
          tween: Tween(
            begin: 1.0,
            end: 1.0,
          ),
          weight: 0.2),
      TweenSequenceItem<double>(
          tween: Tween(
            begin: 1.1,
            end: 1.1,
          ),
          weight: 0.2),
      TweenSequenceItem<double>(
          tween: Tween(
            begin: 1.1,
            end: 1.0,
          ),
          weight: 0.2),
    ];
    _scoreScaleAnimation =
        TweenSequence<double>(scoreScaleTweenSequence).animate(CurvedAnimation(
      parent: _scoreScaleController,
      curve: Curves.easeInOut,
    ));

    /// ============== SCOREBOARD SCALE ================
    /// ============== ^^^^^^^^^^^^^^^^ ======================

    /// ============== vvvvvvvvvvvvvvvv ======================
    /// ============== SCOREBOARD TEXT COLOR ================
    _scoreTextController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // Adjust duration as needed
    );
    final List<TweenSequenceItem<Color?>> scoreTextTweenSequence = [
      TweenSequenceItem<Color?>(
          tween: ColorTween(
            begin: palette.tileBgColor,
            end: palette.tileBgColor,
          ),
          weight: 0.4),
      TweenSequenceItem<Color?>(
          tween: ColorTween(
            begin: palette.tileBgColor,
            end: const Color.fromRGBO(0, 0, 0, 0),
          ),
          weight: 0.1),
      TweenSequenceItem<Color?>(
          tween: ColorTween(
            begin: const Color.fromRGBO(0, 0, 0, 0),
            end: const Color.fromRGBO(0, 0, 0, 0),
          ),
          weight: 0.2),
      TweenSequenceItem<Color?>(
          tween: ColorTween(
            begin: const Color.fromRGBO(255, 45, 45, 1),
            end: const Color.fromRGBO(255, 251, 10, 1),
          ),
          weight: 0.1),
      TweenSequenceItem<Color?>(
          tween: ColorTween(
            begin: const Color.fromRGBO(255, 251, 3, 1),
            end: const Color.fromRGBO(255, 45, 45, 1),
          ),
          weight: 0.1),
      TweenSequenceItem<Color?>(
          tween: ColorTween(
            begin: const Color.fromRGBO(255, 45, 45, 1),
            end: palette.tileBgColor,
          ),
          weight: 0.2),
    ];
    _scoreTextAnimation = TweenSequence<Color?>(scoreTextTweenSequence)
        .animate(_scoreTextController);

    /// ============== SCOREBOARD TEXT COLOR ================
    /// ============== ^^^^^^^^^^^^^^^^ ======================

    /// ============== vvvvvvvvvvvvvvvv ======================
    /// ============== SCOREBOARD BORDER COLOR ================
    _scoreBorderController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // Adjust duration as needed
    );
    final List<TweenSequenceItem<Color?>> scoreBorderTweenSequence = [
      TweenSequenceItem<Color?>(
          tween: ColorTween(
            begin: palette.tileBgColor,
            end: palette.tileBgColor,
          ),
          weight: 0.3),
      TweenSequenceItem<Color?>(
          tween: ColorTween(
            begin: palette.tileBgColor,
            end: palette.tileBgColor,
          ),
          weight: 0.3),
      TweenSequenceItem<Color?>(
          tween: ColorTween(
            begin: palette.tileBgColor,
            end: const Color.fromRGBO(255, 251, 10, 1),
          ),
          weight: 0.1),
      TweenSequenceItem<Color?>(
          tween: ColorTween(
            begin: const Color.fromRGBO(255, 251, 3, 1),
            end: const Color.fromRGBO(255, 45, 45, 1),
          ),
          weight: 0.1),
      TweenSequenceItem<Color?>(
          tween: ColorTween(
            begin: const Color.fromRGBO(255, 45, 45, 1),
            end: palette.tileBgColor,
          ),
          weight: 0.2),
    ];
    _scoreBorderAnimation = TweenSequence<Color?>(scoreBorderTweenSequence)
        .animate(_scoreBorderController);
  }

  @override
  void dispose() {
    _animationState.removeListener(_handleAnimationStateChange);
    _scoreTextController.dispose();
    _scoreScaleController.dispose();
    _scoreBorderController.dispose();
    // _timerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);
    return Consumer<GamePlayState>(
      builder: (context, gamePlayState, child) {
        return Column(
          children: [
            Row(
              children: [
                AnimatedBuilder(
                  animation: _scoreTextAnimation,
                  builder: (context, child) {
                    // int current = _scoreTextAnimation.value;
                    return Transform.scale(
                      scale: _scoreScaleAnimation.value,
                      child: Container(
                        // height: 30,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(0, 0, 0, 0),
                          border: Border.all(
                              color: _scoreBorderAnimation.value ?? palette.tileBgColor,
                              width: (3 * settingsState.sizeFactor)
                            ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all((8.0 * settingsState.sizeFactor)),
                          child: Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: _scoreTextAnimation.value ?? palette.tileBgColor,
                                size: 22* settingsState.sizeFactor,
                              ),
                              // Expanded(flex: 1, child: Center(),),
                              SizedBox(
                                width: (15 * settingsState.sizeFactor),
                              ),
                              AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 200),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: (22 * settingsState.sizeFactor),
                                  color: _scoreTextAnimation.value ?? palette.tileBgColor,
                                ),
                                child: Text(
                                    // widget.turnScore.toString(),
                                    gamePlayState.turnScore.toString()),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const Expanded(flex: 1, child: SizedBox()),
                AnimatedBuilder(
                  animation: _scoreTextAnimation,
                  builder: (context, child) {
                    // int current = _scoreTextAnimation.value;
                    return Transform.scale(
                      scale: _scoreScaleAnimation.value,
                      child: Container(
                        // height: 30,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(0, 0, 0, 0),
                          border: Border.all(
                              color: _scoreBorderAnimation.value ??
                                  palette.tileBgColor,
                              width: (3 * settingsState.sizeFactor)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all((8.0 * settingsState.sizeFactor)),
                          child: Row(
                            children: [
                              Icon(
                                Icons.library_books,
                                color: _scoreTextAnimation.value ?? palette.tileBgColor,
                                size: 22 * settingsState.sizeFactor,
                              ),
                              SizedBox(
                                width: (15 * settingsState.sizeFactor),
                              ),
                              AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 200),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: (22 * settingsState.sizeFactor),
                                  color: _scoreTextAnimation.value ??
                                      const Color.fromRGBO(0, 0, 0, 0),
                                ),
                                child: Text(
                                  // widget.turnWords.toString(),
                                  gamePlayState.turnWords.toString(),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
