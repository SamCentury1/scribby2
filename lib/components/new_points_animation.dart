import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/game_logic.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';

class NewPointsAnimation extends StatefulWidget {
  const NewPointsAnimation({
    super.key,
  });

  @override
  State<NewPointsAnimation> createState() => _NewPointsAnimationState();
}

class _NewPointsAnimationState extends State<NewPointsAnimation>
    with TickerProviderStateMixin {
  late AnimationState _animationState;
  late AnimationController _newPointsTextController;
  late Animation<Color?> _newPointsTextAnimation;

  late AnimationController _newPointsPositionController;
  late Animation<Offset> _newPointsPositionAnimation;

  late AnimationController _newPointsShadowController;
  late Animation<Color?> _newPointsShadowAnimation;

  late AnimationController _newPointsFontSizeController;
  late Animation<double> _newPointsFontSizeAnimation;

  late bool isAnimate = false;

  @override
  void initState() {
    super.initState();
    initializeAnimations();

    _animationState = Provider.of<AnimationState>(context, listen: false);
    _newPointsTextController.addListener(_animationListener);
    _newPointsPositionController.addListener(_animationListener);
    _newPointsShadowController.addListener(_animationListener);
    _newPointsFontSizeController.addListener(_animationListener);
    _animationState.addListener(_handleAnimationStateChange);
  }

  Map<String, dynamic> getTileLocation(String tile) {
    List<String> details = tile.split("_");
    String row = details[0];
    String col = details[1];
    double sideLength = 330;

    late double posX;
    late double posY;

    if (int.parse(col) >= 4) {
      posX = (sideLength / 6) * (int.parse(col) - 1);
    } else {
      posX = (sideLength / 6) * (int.parse(col) - 0);
    }

    if (int.parse(row) >= 4) {
      posY = (sideLength / 6) * (int.parse(row) - 2);
    } else {
      posY = (sideLength / 6) * (int.parse(row) - 1);
    }

    return {"x": posX, "y": posY};
  }

  void _handleAnimationStateChange() {
    if (_animationState.shouldRunPointsAnimation) {
      _runAnimations();
    }
  }

  void _animationListener() {
    if (_newPointsTextController.status == AnimationStatus.completed) {
      _newPointsTextController.reset();
    }
    if (_newPointsPositionController.status == AnimationStatus.completed) {
      _newPointsPositionController.reset();
    }
    if (_newPointsShadowController.status == AnimationStatus.completed) {
      _newPointsShadowController.reset();
    }
    if (_newPointsFontSizeController.status == AnimationStatus.completed) {
      _newPointsFontSizeController.reset();
    }
  }

  void _runAnimations() {
    _newPointsTextController.reset();
    _newPointsPositionController.reset();
    _newPointsShadowController.reset();
    _newPointsFontSizeController.reset();

    _newPointsTextController.forward();
    _newPointsPositionController.forward();
    _newPointsShadowController.forward();
    _newPointsFontSizeController.forward();
  }

  void initializeAnimations() {
    _newPointsTextController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));

    final List<TweenSequenceItem<Color?>> newPointsTextSequence = [
      TweenSequenceItem<Color?>(
          tween: ColorTween(
            begin: const Color.fromRGBO(0, 0, 0, 0),
            end: const Color.fromRGBO(255, 4, 4, 1),
          ),
          weight: 0.1),
      TweenSequenceItem<Color?>(
          tween: ColorTween(
            begin: const Color.fromRGBO(228, 0, 0, 1),
            end: const Color.fromRGBO(255, 212, 18, 1),
          ),
          weight: 0.1),
      TweenSequenceItem<Color?>(
          tween: ColorTween(
            begin: const Color.fromRGBO(255, 232, 28, 1),
            end: const Color(0xFFFF1212),
          ),
          weight: 0.1),
      TweenSequenceItem<Color?>(
          tween: ColorTween(
            begin: const Color.fromRGBO(228, 0, 0, 1),
            end: const Color.fromRGBO(255, 212, 18, 1),
          ),
          weight: 0.1),
      TweenSequenceItem<Color?>(
          tween: ColorTween(
            begin: const Color.fromRGBO(228, 0, 0, 1),
            end: const Color.fromRGBO(255, 212, 18, 1),
          ),
          weight: 0.1),
      TweenSequenceItem<Color?>(
          tween: ColorTween(
            begin: const Color.fromRGBO(255, 232, 28, 1),
            end: const Color(0xFFFF1212),
          ),
          weight: 0.1),
      TweenSequenceItem<Color?>(
          tween: ColorTween(
            begin: const Color.fromRGBO(228, 0, 0, 1),
            end: const Color.fromRGBO(255, 212, 18, 1),
          ),
          weight: 0.1),
      TweenSequenceItem<Color?>(
          tween: ColorTween(
            begin: const Color.fromRGBO(255, 232, 28, 1),
            end: const Color(0xFFFF1212),
          ),
          weight: 0.1),
      TweenSequenceItem<Color?>(
          tween: ColorTween(
            begin: const Color.fromRGBO(228, 0, 0, 1),
            end: const Color.fromRGBO(255, 212, 18, 1),
          ),
          weight: 0.1),
      TweenSequenceItem<Color?>(
          tween: ColorTween(
            begin: const Color.fromRGBO(255, 224, 47, 1),
            end: const Color.fromRGBO(0, 0, 0, 0),
          ),
          weight: 0.1),
    ];

    _newPointsTextAnimation = TweenSequence<Color?>(newPointsTextSequence)
        .animate(_newPointsTextController);

    _newPointsPositionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    final List<TweenSequenceItem<Offset>> newPointsPositionSequence = [
      TweenSequenceItem<Offset>(
          tween: Tween(begin: Offset.zero, end: const Offset(0.0, -1.0)),
          weight: 1.0),
      // TweenSequenceItem<Offset>(tween: Tween(begin: Offset.zero, end: Offset.zero), weight: 0.7),
      // TweenSequenceItem<Offset>(tween: Tween(begin: Offset.zero, end: Offset(0.0, -1.0)), weight: 0.1),
    ];

    _newPointsPositionAnimation =
        TweenSequence<Offset>(newPointsPositionSequence)
            .animate(_newPointsPositionController);

    _newPointsShadowController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));

    final List<TweenSequenceItem<Color?>> newPointsShadowSequence = [
      TweenSequenceItem<Color?>(
          tween: ColorTween(
            begin: const Color.fromRGBO(0, 0, 0, 0),
            end: const Color.fromRGBO(0, 0, 0, 1),
          ),
          weight: 0.1),
      TweenSequenceItem<Color?>(
          tween: ColorTween(
            begin: const Color.fromRGBO(0, 0, 0, 1),
            end: const Color.fromRGBO(0, 0, 0, 1),
          ),
          weight: 0.8),
      TweenSequenceItem<Color?>(
          tween: ColorTween(
            begin: const Color.fromRGBO(0, 0, 0, 1),
            end: const Color.fromRGBO(0, 0, 0, 0),
          ),
          weight: 0.1),
    ];

    _newPointsShadowAnimation = TweenSequence<Color?>(newPointsShadowSequence)
        .animate(_newPointsShadowController);

    /// ============= FONT SIZE =====================
    _newPointsFontSizeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));

    final List<TweenSequenceItem<double>> newPointsFontSizeSequence = [
      TweenSequenceItem<double>(
          tween: Tween(
            begin: 0.0,
            end: 1.0,
          ),
          weight: 0.01),
      TweenSequenceItem<double>(
          tween: Tween(
            begin: 1.0,
            end: 1.0,
          ),
          weight: 0.98),
      TweenSequenceItem<double>(
          tween: Tween(
            begin: 1.0,
            end: 0.0,
          ),
          weight: 0.01),
    ];

    _newPointsFontSizeAnimation =
        TweenSequence<double>(newPointsFontSizeSequence)
            .animate(_newPointsFontSizeController);
  }

  String getNewPointsValue(state) {
    String res = "";

    int previousTotal = GameLogic().getPreviousPoints(state.gameSummaryLog);
    int currentTotal = GameLogic().getTotalPoints(state.gameSummaryLog);
    int newPointsValue = currentTotal - previousTotal;

    res = "+${newPointsValue.toString()}";
    return res;
  }

  @override
  void dispose() {
    _animationState.removeListener(_handleAnimationStateChange);
    _newPointsTextController.dispose();
    _newPointsPositionController.dispose();
    _newPointsShadowController.dispose();
    _newPointsFontSizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GamePlayState>(
      builder: (context, gamePlayState, child) {
        return Positioned(
            top: getTileLocation(gamePlayState.pressedTile)['y'],
            left: getTileLocation(gamePlayState.pressedTile)['x'],
            child: AnimatedBuilder(
              animation: _newPointsPositionAnimation,
              builder: (context, child) {
                return SlideTransition(
                  position: _newPointsPositionAnimation,
                  child: Text(
                    // "+${(widget.currentScore - widget.previousScore).toString()}",
                    getNewPointsValue(gamePlayState),
                    style: TextStyle(
                        fontSize: 38 * _newPointsFontSizeAnimation.value,
                        // fontSize:38,
                        color: _newPointsTextAnimation.value ?? Colors.black,
                        shadows: <Shadow>[
                          Shadow(
                            offset: const Offset(0.0, 0.0),
                            blurRadius: 30.0,
                            color:
                                _newPointsShadowAnimation.value ?? Colors.black,
                          ),
                        ]),
                  ),
                );
              },
            ));
      },
    );
  }
}
