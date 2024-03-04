import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/providers/tutorial_state.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_helpers.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class TutorialTimerWidget extends StatefulWidget {
  final Animation animation;
  final String language;
  const TutorialTimerWidget({
    super.key,
    required this.animation,
    required this.language,
  });

  @override
  State<TutorialTimerWidget> createState() => _TutorialTimerWidgetState();
}

class _TutorialTimerWidgetState extends State<TutorialTimerWidget>
    with TickerProviderStateMixin {
  // late AnimationState animationState;
  // late AnimationController _timerController;
  // late Animation<double> _timerAnimation;

  @override
  void initState() {
    super.initState();
    // animationState = Provider.of<AnimationState>(context, listen: false);
    // initializeAnimations();
    // _timerController.addListener(_animationListener);
    // animationState.addListener(_handleAnimationStateChange);
  }

  // void _animationListener() {
  //   if (_timerController.status == AnimationStatus.completed) {
  //     // _timerController.reset();
  //   }
  // }

  // void _handleAnimationStateChange() {
  //   if (animationState.shouldRunTutorialTimerdAnimation) {
  //     _runTimerAnimation();
  //   }
  // }

  // void _runTimerAnimation() {
  //   _timerController.reset();

  //   _timerController.forward();
  // }

  // void initializeAnimations() {
  //   /// ============== vvvvvvvvvvvvvvvv ======================
  //   /// ============== TIMER ANIMATION =======================
  //   _timerController = AnimationController(
  //     vsync: this,
  //     duration: const Duration(seconds: 5),
  //   );

  //   final List<TweenSequenceItem<double>> timerTweenSequence = [
  //     TweenSequenceItem<double>(
  //         tween: Tween(begin: 0.2, end: 1.0), weight: 0.1),
  //     TweenSequenceItem<double>(
  //         tween: Tween(begin: 1.0, end: 1.0), weight: 0.8),
  //     TweenSequenceItem<double>(
  //         tween: Tween(begin: 1.0, end: 0.2), weight: 0.1),
  //   ];

  //   _timerAnimation =
  //       TweenSequence<double>(timerTweenSequence).animate(_timerController);

  //   /// ============== TIMER ANIMATION =======================
  //   /// ============== ^^^^^^^^^^^^^^^^ ======================
  // }

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
    final ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
    final SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);
    return Consumer<TutorialState>(
      builder: (context, tutorialState, child) {

        final Map<String,dynamic> currentStep = TutorialHelpers().getCurrentStep2(tutorialState);

        return Row(
          children: [
            Text(
              "${Helpers().translateText(widget.language, "Level",)} 1",
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
              animation: widget.animation,
              builder: (context, child) {
                return Opacity(
                  opacity: currentStep['target'] == 'timer' ?  widget.animation.value : 1.0,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Row(
                      children: [
                        Text(
                          "00:00",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: (22 * settingsState.sizeFactor),
                            color: palette.textColor1,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          Icons.timer,
                          color: palette.textColor1,
                          size: 22*settingsState.sizeFactor,
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
