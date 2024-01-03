import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class TutorialScoreboard extends StatefulWidget {
  const TutorialScoreboard({super.key});

  @override
  State<TutorialScoreboard> createState() => _TutorialScoreboardState();
}

class _TutorialScoreboardState extends State<TutorialScoreboard>
    with TickerProviderStateMixin {
  late AnimationState _animationState;
  late ColorPalette palette;

  late AnimationController _highlightComponentController;
  late Animation<double> _highlightComponentAnimation;

  @override
  void initState() {
    super.initState();
    palette = Provider.of<ColorPalette>(context, listen: false);
    initializeAnimations(palette);
    _animationState = Provider.of<AnimationState>(context, listen: false);
    _highlightComponentController.addListener(_animationListener);
    _animationState.addListener(_handleAnimationStateChange);
  }

  void _animationListener() {
    if (_highlightComponentController.status == AnimationStatus.completed) {
      _highlightComponentController.reset();
    }
  }

  void _handleAnimationStateChange() {
    if (_animationState.shouldRunTutorialScoreboardAnimation) {
      _runAnimations();
    }
  }

  void _runAnimations() {
    _highlightComponentController.reset();
    _highlightComponentController.forward();
  }

  void initializeAnimations(ColorPalette palette) {
    _highlightComponentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // Adjust duration as needed
    );
    final List<TweenSequenceItem<double>> scoreTextTweenSequence = [
      TweenSequenceItem<double>(
          tween: Tween(
            begin: 1.0,
            end: 0.0,
          ),
          weight: 0.5),
      TweenSequenceItem<double>(
          tween: Tween(
            begin: 0.0,
            end: 0.1,
          ),
          weight: 0.5),
    ];
    _highlightComponentAnimation = TweenSequence<double>(scoreTextTweenSequence)
        .animate(_highlightComponentController);
  }

  @override
  void dispose() {
    _highlightComponentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              AnimatedBuilder(
                animation: _highlightComponentAnimation,
                builder: (context, child) {
                  return scoreWidget(palette);
                },
              ),
              const Expanded(flex: 1, child: SizedBox()),
              AnimatedBuilder(
                animation: _highlightComponentAnimation,
                builder: (context, child) {
                  // int current = _highlightComponentAnimation.value;
                  return wordsWidget(palette);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget scoreWidget(ColorPalette palette) {
  return Container(
    // height: 30,
    decoration: BoxDecoration(
      color: const Color.fromRGBO(0, 0, 0, 0),
      border: Border.all(color: palette.tileBgColor, width: 3),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(
            Icons.star,
            color: palette.tileBgColor,
          ),
          // Expanded(flex: 1, child: Center(),),
          const SizedBox(
            width: 15,
          ),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              color: palette.tileBgColor,
            ),
            child: const Text("0"),
          )
        ],
      ),
    ),
  );
}

Widget wordsWidget(ColorPalette palette) {
  return Container(
    // height: 30,
    decoration: BoxDecoration(
      color: const Color.fromRGBO(0, 0, 0, 0),
      border: Border.all(color: palette.tileBgColor, width: 3),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(
            Icons.library_books,
            color: palette.tileBgColor,
          ),
          const SizedBox(
            width: 15,
          ),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              color: palette.tileBgColor,
            ),
            child: const Text("0"),
          )
        ],
      ),
    ),
  );
}
