import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
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

  late AnimationController _newLevelPositionController;
  late Animation<Offset> _newLevelPositionAnimation;

  late AnimationController _newLevelOpacityController;
  late Animation<double> _newLevelOpacityAnimation;

  // late AnimationController _newLevelOpacity

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
    _newLevelPositionController.addListener(_animationListener);
    _newLevelOpacityController.addListener(_animationListener);
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

    if (_animationState.shouldRunNewLevelAnimation) {
      _runNewLevelAnimation();
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

  void _runNewLevelAnimation() {
    _newLevelPositionController.reset();
    _newLevelOpacityController.reset();

    _newLevelPositionController.forward();
    _newLevelOpacityController.forward();
  }

  void initializeAnimations(ColorPalette palette) {
    /// ============== vvvvvvvvvvvvvvvv ======================
    /// ============== STREAK OFFSET ================
    _streakSlideEnterController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _streakSlideEnterAnimation = Tween<Offset>(
      // streakSlideEnterTweenSequence
      begin: const Offset(-1.5, 0.0),
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

    /// ============== NEW LEVEL ANIMATION ================
    /// ============== vvvvvvvvvvvvvvvvvvv  ======================

    /// POSITION
    _newLevelPositionController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 4500));

    final List<TweenSequenceItem<Offset>> newLevelPositionSequence = [
      TweenSequenceItem<Offset>(
          tween: Tween<Offset>(
            begin: const Offset(0.0, 0.0),
            end: const Offset(0.0, 0.0),
          ),
          weight: 0.5),
      TweenSequenceItem<Offset>(
          tween: Tween<Offset>(
            begin: const Offset(0.0, 0.0),
            end: Offset.zero,
          ),
          weight: 0.05),
      TweenSequenceItem<Offset>(
          tween: Tween<Offset>(
            begin: Offset.zero,
            end: Offset.zero,
          ),
          weight: 0.4),
      TweenSequenceItem<Offset>(
          tween: Tween<Offset>(
            begin: Offset.zero,
            end: const Offset(0.0, -1.0),
          ),
          weight: 0.05),
    ];

    _newLevelPositionAnimation = TweenSequence<Offset>(newLevelPositionSequence)
        .animate(_newLevelPositionController);

    /// OPACITY
    _newLevelOpacityController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 4500));

    final List<TweenSequenceItem<double>> newLevelOpacitySequence = [
      TweenSequenceItem<double>(
          tween: Tween<double>(
            begin: 0.0,
            end: 0.0,
          ),
          weight: 0.5),
      TweenSequenceItem<double>(
          tween: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ),
          weight: 0.05),
      TweenSequenceItem<double>(
          tween: Tween<double>(
            begin: 1.0,
            end: 1.0,
          ),
          weight: 0.4),
      TweenSequenceItem<double>(
          tween: Tween<double>(
            begin: 1.0,
            end: 0.0,
          ),
          weight: 0.05),
    ];

    _newLevelOpacityAnimation = TweenSequence<double>(newLevelOpacitySequence)
        .animate(_newLevelOpacityController);

    /// ============== NEW LEVEL ANIMATION ================
    /// ============== ^^^^^^^^^^^^^^^^ ======================
  }

  Color getLevelUpWidgetColor(ColorPalette palette, double opacity) {
    return Color.fromRGBO(palette.textColor2.red, palette.textColor2.green,
        palette.textColor2.blue, opacity);
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

    if (_newLevelPositionController.status == AnimationStatus.completed) {}
    if (_newLevelOpacityController.status == AnimationStatus.completed) {}
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
    _newLevelPositionController.dispose();
    _newLevelOpacityController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);
    return Consumer<GamePlayState>(builder: (context, gamePlayState, child) {
      return Stack(
        children: [
          Row(
            children: [
              bonusItem(
                gamePlayState, 
                settingsState.sizeFactor, 
                _streakTextAnimation, 
                _streakSlideEnterAnimation,
                'streak',
                1,
                // gamePlayState.gameSummaryLog[gamePlayState.gameSummaryLog.length - 1]['streak'] > 1, 
                palette),
              // gamePlayState.gameSummaryLog.isEmpty
              //     ? const SizedBox()
              //     : gamePlayState.gameSummaryLog[gamePlayState.gameSummaryLog.length - 1]['streak'] > 1
              //         ? Padding(
              //             padding: EdgeInsets.all((4.0 * settingsState.sizeFactor)),
              //             child: Row(
              //               children: [
              //                 AnimatedBuilder(
              //                   animation: _streakSlideEnterAnimation,
              //                   builder: (context, child) {
              //                     return SlideTransition(
              //                       position: _streakSlideEnterAnimation,
              //                       // child: Expanded(
              //                       child: Row(
              //                         children: [
              //                           SizedBox(
              //                             width: (75*settingsState.sizeFactor),
              //                             child: AnimatedBuilder(
              //                               animation: _streakTextAnimation,
              //                               builder: (context, child) {
              //                                 return Padding(
              //                                   padding:  EdgeInsets.all(4.0 * settingsState.sizeFactor),
              //                                   child: Row(
              //                                     children: [
              //                                       Icon(
              //                                         Icons.electric_bolt,
              //                                         color: _streakTextAnimation.value ?? palette.tileBgColor,
              //                                         size: (22 * settingsState.sizeFactor)
              //                                       ),
              //                                       const Expanded(
              //                                         flex: 1,
              //                                         child: Center(),
              //                                       ),
              //                                       Text(
              //                                         // "${widget.activeStreak.toString()}x",
              //                                         "${gamePlayState.activeStreak.toString()}x",
              //                                         style: TextStyle(
              //                                           fontStyle:FontStyle.italic,
              //                                           fontSize: (22 * settingsState.sizeFactor),
              //                                           color: _streakTextAnimation.value ?? palette.tileBgColor,
              //                                         ),
              //                                       ),
              //                                     ],
              //                                   ),
              //                                 );
              //                               },
              //                             ),
              //                           ),
              //                         ],
              //                       ),
              //                     );
              //                   },
              //                 )
              //               ],
              //             ))
              //         : const SizedBox(),

              bonusItem(
                gamePlayState, 
                settingsState.sizeFactor, 
                _multiTextAnimation, 
                _multiSlideAnimation, 
                'count', 
                0, 
                palette
              ),
              // gamePlayState.gameSummaryLog.isEmpty
              //     ? const SizedBox()
              //     : gamePlayState.gameSummaryLog[ gamePlayState.gameSummaryLog.length - 1]['count'] > 0
              //         ? Padding(
              //             padding: EdgeInsets.all(4.0 * settingsState.sizeFactor),
              //             child: Row(
              //               children: [
              //                 AnimatedBuilder(
              //                   animation: _multiSlideAnimation,
              //                   builder: (context, child) {
              //                     return SlideTransition(
              //                       position: _multiSlideAnimation,
              //                       child: Row(
              //                         children: [
              //                           SizedBox(
              //                             width: (75*settingsState.sizeFactor),
              //                             child: AnimatedBuilder(
              //                               animation: _multiTextAnimation,
              //                               builder: (context, child) {
              //                                 return Padding(
              //                                   padding:EdgeInsets.all(4.0 * settingsState.sizeFactor),
              //                                   child: Row(
              //                                     children: [
              //                                       Icon(
              //                                         Icons.bookmarks_outlined,
              //                                         color: _multiTextAnimation.value ?? palette.tileBgColor,
              //                                         size: (22 * settingsState.sizeFactor)
              //                                       ),
              //                                       const Expanded(
              //                                         flex: 1,
              //                                         child: Center(),
              //                                       ),
              //                                       Text(
              //                                         "${gamePlayState.gameSummaryLog[gamePlayState.gameSummaryLog.length - 1]['count'].toString()}x",
              //                                         style: TextStyle(
              //                                             fontStyle:FontStyle.italic,
              //                                             fontSize: (22 * settingsState.sizeFactor),
              //                                             color: _multiTextAnimation.value ??palette.tileBgColor),
              //                                       ),
              //                                     ],
              //                                   ),
              //                                 );
              //                               },
              //                             ),
              //                           ),
              //                           // Expanded(flex:1, child: Center())
              //                         ],
              //                       ),
              //                     );
              //                   },
              //                 )
              //               ],
              //             ))
              //         : const SizedBox(),

              bonusItem(
                gamePlayState, 
                settingsState.sizeFactor, 
                _cwTextAnimation, 
                _cwSlideAnimation, 
                'crossword', 
                1, 
                palette
              ),
              // gamePlayState.gameSummaryLog.isEmpty
              //     ? const SizedBox()
              //     : gamePlayState.gameSummaryLog[gamePlayState.gameSummaryLog.length - 1]['crossword'] > 1 ? 
              //       Padding(
              //             padding: EdgeInsets.all(4.0 * settingsState.sizeFactor),
              //             child: Row(
              //               children: [
              //                 AnimatedBuilder(
              //                   animation: _cwSlideAnimation,
              //                   builder: (context, child) {
              //                     return SlideTransition(
              //                       position: _cwSlideAnimation,
              //                       // child: Expanded(
              //                       child: Row(
              //                         children: [
              //                           SizedBox(
              //                             width: (75*settingsState.sizeFactor),
              //                             child: AnimatedBuilder(
              //                               animation: _cwTextAnimation,
              //                               builder: (context, child) {
              //                                 return Padding(
              //                                   padding:EdgeInsets.all(4.0 * settingsState.sizeFactor),
              //                                   child: Row(
              //                                     children: [
              //                                       Icon(
              //                                         Icons.close,
              //                                         color: _cwTextAnimation.value ?? palette.tileBgColor,
              //                                         size: (22 * settingsState.sizeFactor),
              //                                       ),
              //                                       const Expanded(
              //                                         flex: 1,
              //                                         child: Center(),
              //                                       ),
              //                                       Text(
              //                                         // "${widget.activeStreak.toString()}x",
              //                                         "${gamePlayState.gameSummaryLog[gamePlayState.gameSummaryLog.length - 1]['crossword'].toString()}x",
              //                                         style: TextStyle(
              //                                           fontStyle: FontStyle.italic,
              //                                           fontSize: (22 * settingsState.sizeFactor),
              //                                           color: _cwTextAnimation.value ?? palette.tileBgColor,
              //                                         ),
              //                                       ),
              //                                     ],
              //                                   ),
              //                                 );
              //                               },
              //                             ),
              //                           ),
              //                         ],
              //                       ),
              //                     );
              //                   },
              //                 )
              //               ],
              //             ))
              //         : const SizedBox(),
            ],
          ),
          // gamePlayState.displayLevelChange == false ? const SizedBox() :
          AnimatedBuilder(
            animation: _newLevelPositionAnimation,
            builder: (context, child) {
              return SlideTransition(
                position: _newLevelPositionAnimation,
                child: SizedBox(
                  width: double.infinity,
                  // color: Colors.pink,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                        "${Helpers().translateText(gamePlayState.currentLanguage, "Level")} ${gamePlayState.currentLevel.toString()}",
                        style: TextStyle(
                            fontSize: (42 * settingsState.sizeFactor),//(42 * settingsState.sizeFactor),
                            color: getLevelUpWidgetColor(
                                palette, _newLevelOpacityAnimation.value)
                            )),
                  ),
                ),
              );
            },
          )
        ],
      );
    });
  }
}


Widget bonusItem(
  GamePlayState gamePlayState, 
  double sizeFactor, 
  Animation textAnimation, 
  Animation<Offset> slideAnimation,
  String bonusItem,
  int bonusItemFactor,
  // bool condition,
  ColorPalette palette) {


    late double opacity = 0.0;

    Color getOpacityFactor(Animation animation, double opacity) {
      Color res = Color.fromRGBO(
        animation.value.red, 
        animation.value.green, 
        animation.value.blue, 
        animation.value.opacity
      );
      return res;
    }

    IconData getIcon(String bonusItem) {
      if (bonusItem == 'streak') {
        return Icons.bolt;
      } else if (bonusItem == 'count') {
        return Icons.my_library_books_sharp;
      } else if (bonusItem == 'crossword') {
        return Icons.close;
      } else {
        return Icons.abc;
      }
    }

    String getBonusItemString(String bonusItem, GamePlayState gamePlayState) {
      String res = "";
      if (bonusItem == 'streak') {
        res = "${gamePlayState.activeStreak.toString()}x";
      } else if (bonusItem == 'count') {
        if (gamePlayState.gameSummaryLog.isNotEmpty) {
          res = "${gamePlayState.gameSummaryLog[gamePlayState.gameSummaryLog.length - 1]['count'].toString()}x";
        } else {
          res = "0";
        }
      } else if (bonusItem == 'crossword') {
        if (gamePlayState.gameSummaryLog.isNotEmpty) {
          res = "${gamePlayState.gameSummaryLog[gamePlayState.gameSummaryLog.length - 1]['crossword'].toString()}x";
        } else {
          res = "0";
        }
      }
      return res;
    }

    if (gamePlayState.gameSummaryLog.isNotEmpty) {
      bool condition = gamePlayState.gameSummaryLog[gamePlayState.gameSummaryLog.length - 1][bonusItem] > bonusItemFactor;
      if (condition) {
        opacity = 1.0;
      }
    }    

    return Padding(
      padding: EdgeInsets.all((4.0 * sizeFactor)),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: slideAnimation,
            builder: (context, child) {
              return SlideTransition(
                position: slideAnimation,
                child: Row(
                  children: [
                    SizedBox(
                      width: (75*sizeFactor),
                      // width: double.infinity,
                      child: AnimatedBuilder(
                        animation: textAnimation,
                        builder: (context, child) {
                          return Padding(
                            padding:  EdgeInsets.all(4.0 * sizeFactor),
                            child: Row(
                              children: [
                                Icon(
                                  getIcon(bonusItem), //Icons.electric_bolt,
                                  color: getOpacityFactor(textAnimation,opacity), //textAnimation.value ?? palette.tileBgColor,
                                  size: (22 * sizeFactor)
                                ),
                                const Expanded(
                                  flex: 1,
                                  child: Center(),
                                ),
                                Text(
                                  getBonusItemString(bonusItem,gamePlayState), // "${gamePlayState.activeStreak.toString()}x",
                                  style: TextStyle(
                                    fontStyle:FontStyle.italic,
                                    fontSize: (22 * sizeFactor),
                                    color: getOpacityFactor(textAnimation,opacity),//textAnimation.value ?? palette.tileBgColor,
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
      )
    );    

}