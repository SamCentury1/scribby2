import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/tutorial_state.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class TutorialTimerWidget extends StatefulWidget {
  const TutorialTimerWidget({
    super.key,
  });

  @override
  State<TutorialTimerWidget> createState() => _TutorialTimerWidgetState();
}

class _TutorialTimerWidgetState extends State<TutorialTimerWidget>
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
    if (animationState.shouldRunTutorialTimerdAnimation) {
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

  // String displayFormattedTime(int seconds) {
  //   // String formattedTime = GameLogic().formatTime(seconds);
  //   // return formattedTime;
  // }

  @override
  Widget build(BuildContext context) {
    final ColorPalette palette =
        Provider.of<ColorPalette>(context, listen: false);

    return Consumer<TutorialState>(
      builder: (context, tutorialState, child) {
        return Row(
          children: [
            Text(
              "Level 1",
              style: TextStyle(
                fontSize: 22,
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
                return Opacity(
                  opacity: _timerAnimation.value,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Row(
                      children: [
                        Text(
                          "00:00",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            color: palette.textColor1,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          Icons.timer,
                          color: palette.textColor1,
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
