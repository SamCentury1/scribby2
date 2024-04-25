import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/game_logic.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class TimerWidget extends StatefulWidget {
  final bool darkTheme;
  final ColorPalette palette;
  const TimerWidget({
    super.key,
    required this.darkTheme,
    required this.palette,
  });

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget>
    with TickerProviderStateMixin {
  late AnimationState animationState;
  late AnimationController _timerController;
  late Animation<double> _timerAnimation;

  @override
  void initState() {
    super.initState();
    animationState = Provider.of<AnimationState>(context, listen: false);
    initializeAnimations();
    _timerController.addListener(_animationListener);
    animationState.addListener(_handleAnimationStateChange);
  }

  void _animationListener() {
    if (_timerController.status == AnimationStatus.completed) {
      // _timerController.reset();
    }
  }

  void _handleAnimationStateChange() {
    if (animationState.shouldRunTimerAnimation) {
      _runTimerAnimation();
    }
  }

  void _runTimerAnimation() {
    _timerController.reset();

    _timerController.forward();
  }

  void initializeAnimations() {
    /// ============== vvvvvvvvvvvvvvvv ======================
    /// ============== TIMER ANIMATION =======================
    _timerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    final List<TweenSequenceItem<double>> timerTweenSequence = [
      TweenSequenceItem<double>(
          tween: Tween(begin: 0.2, end: 1.0), weight: 0.1),
      TweenSequenceItem<double>(
          tween: Tween(begin: 1.0, end: 1.0), weight: 0.8),
      TweenSequenceItem<double>(
          tween: Tween(begin: 1.0, end: 0.2), weight: 0.1),
    ];

    _timerAnimation =
        TweenSequence<double>(timerTweenSequence).animate(_timerController);

    /// ============== TIMER ANIMATION =======================
    /// ============== ^^^^^^^^^^^^^^^^ ======================
  }

  // @override
  // void dispose() {
  //   // _timerAnimation.removeListener(_handleAnimationStateChange);
  //   // _timerController.dispose();
  //   // animationState.dispose();
  //   super.dispose();
  // }

  String displayFormattedTime(int seconds) {
    String formattedTime = GameLogic().formatTime(seconds);
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    final ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
    final SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);

    

    return Consumer<GamePlayState>(
      builder: (context, gamePlayState, child) {
        late String levelText = Helpers().translateText(gamePlayState.currentLanguage, "Level");
        return Row(
          children: [
            Text(
              // Helpers().translateText("Level", gamePlayState.currentLanguage),
              // "level",
              "$levelText ${gamePlayState.currentLevel}",
              style: TextStyle(
                fontSize: (22 * settingsState.sizeFactor),
                color: palette.textColor1,
              ),
            ),
            const Expanded(
              flex: 1,
              child: SizedBox(),
            ), // Spacer(),
            AnimatedBuilder(
              animation: _timerAnimation,
              builder: (context, child) {
                // int current = _scoreTextAnimation.value;
                return Opacity(
                  opacity: _timerAnimation.value,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Row(
                      children: [
                        Consumer<GamePlayState>(
                          builder: (context, gamePlayState, child) {
                            return Text(
                              displayFormattedTime(
                                  gamePlayState.duration.inSeconds),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: (22 * settingsState.sizeFactor),
                                // color: const Color.fromARGB(255, 224, 224, 224),
                                color: palette.textColor1,
                              ),
                            );
                          },
                        ),
                        // Expanded(flex: 1, child: Center(),),
                        const SizedBox(width: 10),
                        Icon(
                          Icons.timer,
                          // color: GameLogic().getColor(widget.darkTheme, widget.palette, "timer_text"),
                          color: palette.textColor1,
                          size: (22 * settingsState.sizeFactor),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
