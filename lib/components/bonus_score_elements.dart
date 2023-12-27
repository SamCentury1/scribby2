import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class BonusScoreElements extends StatefulWidget {
  const BonusScoreElements({super.key});

  @override
  State<BonusScoreElements> createState() => _BonusScoreElementsState();
}

class _BonusScoreElementsState extends State<BonusScoreElements>
    with TickerProviderStateMixin {
  late AnimationState _animationState;

  late AnimationController _streakSlideEnterController;
  late Animation<Offset> _streakSlideEnterAnimation;

  late AnimationController _streakTextController;
  late Animation<Color?> _streakTextAnimation;

  late AnimationController _multiSlideController;
  late Animation<Offset> _multiSlideAnimation;

  late AnimationController _multiTextController;
  late Animation<Color?> _multiTextAnimation;

  late AnimationController _cwSlideController;
  late Animation<Offset> _cwSlideAnimation;

  late AnimationController _cwTextController;
  late Animation<Color?> _cwTextAnimation;

  late ColorPalette palette;

  @override
  void initState() {
    super.initState();
    // displayFormattedTime(0);
    palette = Provider.of<ColorPalette>(context, listen: false);
    initializeAnimations(palette);

    // formattedTime = GameLogic().formatTime(timeInSeconds)

    _animationState = Provider.of<AnimationState>(context, listen: false);
    _streakTextController.addListener(_animationListener);
    _streakSlideEnterController.addListener(_animationListener);
    _multiSlideController.addListener(_animationListener);
    _multiTextController.addListener(_animationListener);
    _animationState.addListener(_handleAnimationStateChange);
  }

  void _handleAnimationStateChange() {
    if (_animationState.shouldRunWordAnimation) {
      _streakTextController.reset();
      _streakTextController.forward();
    }
    if (_animationState.shouldRunCrossWordAnimation) {
      // _runAnimations();
      Future.delayed(const Duration(milliseconds: 400), () {
        _runCrossWordAnimation();
      });
    }

    if (_animationState.shouldRunMultiWordAnimation) {
      // _runAnimations();
      Future.delayed(const Duration(milliseconds: 200), () {
        _runMultiWordAnimation();
      });
    }

    if (_animationState.shouldRunStreaksEnterAnimation) {
      _runStreakAnimation('enter');
    }

    if (_animationState.shouldRunStreaksExitAnimation) {
      _runStreakAnimation('exit');
    }
  }

  void _runStreakAnimation(String status) {
    if (status == 'enter') {
      _streakTextController.reset();
      _streakTextController.forward();

      _streakSlideEnterController.reset();
      _streakSlideEnterController.forward();
    } else if (status == 'exit') {
      _streakSlideEnterController.reverse();
    }
  }

  void _runCrossWordAnimation() {
    _cwTextController.reset();
    _cwSlideController.reset();

    _cwTextController.forward();
    _cwSlideController.forward();
  }

  void _runMultiWordAnimation() {
    _multiTextController.reset();
    _multiSlideController.reset();

    _multiTextController.forward();
    _multiSlideController.forward();
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

    /// ============== vvvvvvvvvvvvvvvv ======================
    /// ============== SCOREBOARD TEXT COLOR ================
    _streakTextController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // Adjust duration as needed
    );
    final List<TweenSequenceItem<Color?>> streakTextTweenSequence = [
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
    _streakTextAnimation = TweenSequence<Color?>(streakTextTweenSequence)
        .animate(_streakTextController);

    /// ============== SCOREBOARD TEXT COLOR ================
    /// ============== ^^^^^^^^^^^^^^^^ ======================

    /// ============== vvvvvvvvvvvvvvvv ======================
    /// ============== ITEM SLIDE ================
    _multiSlideController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));

    final List<TweenSequenceItem<Offset>> itemSlideSequence = [
      TweenSequenceItem<Offset>(
          tween: Tween<Offset>(
            begin: const Offset(-1.2, 0.0),
            end: Offset.zero,
          ),
          weight: 0.1),
      TweenSequenceItem<Offset>(
          tween: Tween<Offset>(
            begin: Offset.zero,
            end: Offset.zero,
          ),
          weight: 0.8),
      TweenSequenceItem<Offset>(
          tween: Tween<Offset>(
            begin: Offset.zero,
            end: const Offset(0.0, -1.0),
          ),
          weight: 0.1),
    ];

    _multiSlideAnimation = TweenSequence<Offset>(
            // streakSlideEnterTweenSequence
            itemSlideSequence
            // begin: Offset(-1.2, 0.0),
            // end: Offset(0.0, -1.0),
            )
        .animate(_multiSlideController);

    /// ============== ITEM SLIDE ================
    /// ============== ^^^^^^^^^^^^^^^^ ======================

    /// ============== vvvvvvvvvvvvvvvv ======================
    /// ============== SCOREBOARD TEXT COLOR ================
    _multiTextController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // Adjust duration as needed
    );
    final List<TweenSequenceItem<Color?>> itemTextTweenSequence = [
      TweenSequenceItem<Color?>(
          tween: ColorTween(
            begin: const Color.fromRGBO(0, 0, 0, 0),
            end: palette.tileBgColor,
          ),
          weight: 0.4),
      TweenSequenceItem<Color?>(
          tween: ColorTween(
            begin: palette.tileBgColor,
            end: palette.tileBgColor,
          ),
          weight: 0.1),
      TweenSequenceItem<Color?>(
          tween: ColorTween(
            begin: const Color.fromRGBO(255, 45, 45, 1),
            end: const Color.fromRGBO(255, 251, 10, 1),
          ),
          weight: 0.1),
      TweenSequenceItem<Color?>(
          tween: ColorTween(
            begin: const Color.fromRGBO(255, 251, 10, 1),
            end: const Color.fromRGBO(255, 45, 45, 1),
          ),
          weight: 0.1),
      TweenSequenceItem<Color?>(
          tween: ColorTween(
            begin: const Color.fromRGBO(255, 45, 45, 1),
            end: const Color.fromRGBO(255, 251, 10, 1),
          ),
          weight: 0.1),
      TweenSequenceItem<Color?>(
          tween: ColorTween(
            begin: const Color.fromRGBO(255, 251, 10, 1),
            end: const Color.fromRGBO(0, 0, 0, 0),
          ),
          weight: 0.2),
    ];
    _multiTextAnimation = TweenSequence<Color?>(itemTextTweenSequence)
        .animate(_multiTextController);

    /// ============== SCOREBOARD TEXT COLOR ================
    /// ============== ^^^^^^^^^^^^^^^^ ======================
    ///
    ///
    ///
    /// ============== vvvvvvvvvvvvvvvv ======================
    /// ============== ITEM SLIDE ================
    _cwSlideController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));

    final List<TweenSequenceItem<Offset>> cwSlideSequence = [
      TweenSequenceItem<Offset>(
          tween: Tween<Offset>(
            begin: const Offset(-1.2, 0.0),
            end: Offset.zero,
          ),
          weight: 0.1),
      TweenSequenceItem<Offset>(
          tween: Tween<Offset>(
            begin: Offset.zero,
            end: Offset.zero,
          ),
          weight: 0.8),
      TweenSequenceItem<Offset>(
          tween: Tween<Offset>(
            begin: Offset.zero,
            end: const Offset(0.0, -1.0),
          ),
          weight: 0.1),
    ];

    _cwSlideAnimation = TweenSequence<Offset>(
            // streakSlideEnterTweenSequence
            cwSlideSequence
            // begin: Offset(-1.2, 0.0),
            // end: Offset(0.0, -1.0),
            )
        .animate(_cwSlideController);

    /// ============== ITEM SLIDE ================
    /// ============== ^^^^^^^^^^^^^^^^ ======================

    /// ============== vvvvvvvvvvvvvvvv ======================
    /// ============== SCOREBOARD TEXT COLOR ================
    _cwTextController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // Adjust duration as needed
    );
    final List<TweenSequenceItem<Color?>> cwTextTweenSequence = [
      TweenSequenceItem<Color?>(
          tween: ColorTween(
            begin: const Color.fromRGBO(0, 0, 0, 0),
            end: palette.tileBgColor,
          ),
          weight: 0.4),
      TweenSequenceItem<Color?>(
          tween: ColorTween(
            begin: palette.tileBgColor,
            end: palette.tileBgColor,
          ),
          weight: 0.1),
      TweenSequenceItem<Color?>(
          tween: ColorTween(
            begin: const Color.fromRGBO(255, 45, 45, 1),
            end: const Color.fromRGBO(255, 251, 10, 1),
          ),
          weight: 0.1),
      TweenSequenceItem<Color?>(
          tween: ColorTween(
            begin: const Color.fromRGBO(255, 251, 10, 1),
            end: const Color.fromRGBO(255, 45, 45, 1),
          ),
          weight: 0.1),
      TweenSequenceItem<Color?>(
          tween: ColorTween(
            begin: const Color.fromRGBO(255, 45, 45, 1),
            end: const Color.fromRGBO(255, 251, 10, 1),
          ),
          weight: 0.1),
      TweenSequenceItem<Color?>(
          tween: ColorTween(
            begin: const Color.fromRGBO(255, 251, 10, 1),
            end: const Color.fromRGBO(0, 0, 0, 0),
          ),
          weight: 0.2),
    ];
    _cwTextAnimation =
        TweenSequence<Color?>(cwTextTweenSequence).animate(_cwTextController);

    /// ============== SCOREBOARD TEXT COLOR ================
    /// ============== ^^^^^^^^^^^^^^^^ ======================
  }

  void _animationListener() {
    if (_streakTextController.status == AnimationStatus.completed) {
      // _streakTextController.reset();
    }

    if (_streakSlideEnterController.status == AnimationStatus.completed) {}

    if (_multiSlideAnimation.status == AnimationStatus.completed) {}
    if (_multiTextController.status == AnimationStatus.completed) {}

    if (_cwSlideAnimation.status == AnimationStatus.completed) {}
    if (_cwTextController.status == AnimationStatus.completed) {}
  }

  @override
  void dispose() {
    _animationState.removeListener(_handleAnimationStateChange);
    _streakTextController.dispose();
    _streakSlideEnterController.dispose();
    _multiSlideController.dispose();
    _multiTextController.dispose();
    _cwSlideController.dispose();
    _cwTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GamePlayState>(builder: (context, gamePlayState, child) {
      return Row(
        children: [
          gamePlayState.gameSummaryLog.isEmpty
              ? const SizedBox()
              : gamePlayState.gameSummaryLog[
                          gamePlayState.gameSummaryLog.length - 1]['streak'] >
                      1
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          AnimatedBuilder(
                            animation: _streakSlideEnterAnimation,
                            builder: (context, child) {
                              return SlideTransition(
                                position: _streakSlideEnterAnimation,
                                // child: Expanded(
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 75,
                                      child: AnimatedBuilder(
                                        animation: _streakTextAnimation,
                                        builder: (context, child) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.electric_bolt,
                                                  color: _streakTextAnimation
                                                          .value ??
                                                      palette.tileBgColor,
                                                ),
                                                const Expanded(
                                                  flex: 1,
                                                  child: Center(),
                                                ),
                                                Text(
                                                  // "${widget.activeStreak.toString()}x",
                                                  "${gamePlayState.activeStreak.toString()}x",
                                                  style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 22,
                                                    color: _streakTextAnimation
                                                            .value ??
                                                        palette.tileBgColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        ],
                      ))
                  : const SizedBox(),
          gamePlayState.gameSummaryLog.isEmpty
              ? const SizedBox()
              : gamePlayState.gameSummaryLog[
                          gamePlayState.gameSummaryLog.length - 1]['count'] >
                      0
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          AnimatedBuilder(
                            animation: _multiSlideAnimation,
                            builder: (context, child) {
                              return SlideTransition(
                                position: _multiSlideAnimation,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 75,
                                      child: AnimatedBuilder(
                                        animation: _multiTextAnimation,
                                        builder: (context, child) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.bookmarks_outlined,
                                                  color: _multiTextAnimation
                                                          .value ??
                                                      palette.tileBgColor,
                                                ),
                                                const Expanded(
                                                  flex: 1,
                                                  child: Center(),
                                                ),
                                                Text(
                                                  "${gamePlayState.gameSummaryLog[gamePlayState.gameSummaryLog.length - 1]['count'].toString()}x",
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontSize: 22,
                                                      color: _multiTextAnimation
                                                              .value ??
                                                          palette.tileBgColor),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    // Expanded(flex:1, child: Center())
                                  ],
                                ),
                              );
                            },
                          )
                        ],
                      ))
                  : const SizedBox(),
          gamePlayState.gameSummaryLog.isEmpty
              ? const SizedBox()
              : gamePlayState.gameSummaryLog[
                              gamePlayState.gameSummaryLog.length - 1]
                          ['crossword'] >
                      1
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          AnimatedBuilder(
                            animation: _cwSlideAnimation,
                            builder: (context, child) {
                              return SlideTransition(
                                position: _cwSlideAnimation,
                                // child: Expanded(
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 75,
                                      child: AnimatedBuilder(
                                        animation: _cwTextAnimation,
                                        builder: (context, child) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.close,
                                                  color:
                                                      _cwTextAnimation.value ??
                                                          palette.tileBgColor,
                                                ),
                                                const Expanded(
                                                  flex: 1,
                                                  child: Center(),
                                                ),
                                                Text(
                                                  // "${widget.activeStreak.toString()}x",
                                                  "${gamePlayState.gameSummaryLog[gamePlayState.gameSummaryLog.length - 1]['crossword'].toString()}x",
                                                  style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 22,
                                                    color: _cwTextAnimation
                                                            .value ??
                                                        palette.tileBgColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        ],
                      ))
                  : const SizedBox(),
        ],
      );
    });
  }
}
