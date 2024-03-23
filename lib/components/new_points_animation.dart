import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/game_logic.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/styles/buttons.dart';

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
  late AnimationController _newPointsAnimationController;

  // late AnimationController _newPointsTextController;
  late Animation<Color?> _newPointsTextAnimation;

  // late AnimationController _newPointsPositionController;
  late Animation<Offset> _newPointsPositionAnimation;

  // late AnimationController _newPointsShadowController;
  late Animation<Color?> _newPointsShadowAnimation;

  // late AnimationController _newPointsFontSizeController;
  late Animation<double> _newPointsFontSizeAnimation;

  late bool isAnimate = false;

  @override
  void initState() {
    super.initState();
    initializeAnimations();

    _animationState = Provider.of<AnimationState>(context, listen: false);
    _newPointsAnimationController.addListener(_animationListener);
    // _newPointsTextController.addListener(_animationListener);
    // _newPointsPositionController.addListener(_animationListener);
    // _newPointsShadowController.addListener(_animationListener);
    // _newPointsFontSizeController.addListener(_animationListener);
    _animationState.addListener(_handleAnimationStateChange);
  }

  Map<String, dynamic> getTileLocation(String tile, double sideLength) {
    if (tile != "") {
      List<String> details = tile.split("_");
      String row = details[0];
      String col = details[1];
      // double sideLength = 330;

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
    } else {
      return {"x": 0.0, "y": 0.0};
    }
  }

  void _handleAnimationStateChange() {
    if (_animationState.shouldRunPointsAnimation) {
      _runAnimations();
    }
  }

  void _animationListener() {
    if (_newPointsAnimationController.status == AnimationStatus.completed) {
      _newPointsAnimationController.reset();
    }
    // if (_newPointsTextController.status == AnimationStatus.completed) {
    //   _newPointsTextController.reset();
    // }
    // if (_newPointsPositionController.status == AnimationStatus.completed) {
    //   _newPointsPositionController.reset();
    // }
    // if (_newPointsShadowController.status == AnimationStatus.completed) {
    //   _newPointsShadowController.reset();
    // }
    // if (_newPointsFontSizeController.status == AnimationStatus.completed) {
    //   _newPointsFontSizeController.reset();
    // }
  }

  void _runAnimations() {
    _newPointsAnimationController.reset();
    _newPointsAnimationController.forward();
    // _newPointsTextController.reset();
    // _newPointsPositionController.reset();
    // _newPointsShadowController.reset();
    // _newPointsFontSizeController.reset();

    // _newPointsTextController.forward();
    // _newPointsPositionController.forward();
    // _newPointsShadowController.forward();
    // _newPointsFontSizeController.forward();
  }

  void initializeAnimations() {
    late GamePlayState gamePlayState = context.read<GamePlayState>();
    // _newPointsTextController = AnimationController(
    //   vsync: this, duration: const Duration(milliseconds: 1500)
    // );
    _newPointsAnimationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1500)
    );

    Color color_0 = Colors.transparent;
    Color color_1 = const Color.fromRGBO(255, 4, 4, 1);
    Color color_2 = const Color.fromRGBO(255, 212, 18, 1);
    Color color_4 = Colors.black;

    final List<TweenSequenceItem<Color?>> newPointsTextSequence = [
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_0,end: color_1,),weight: 0.1),
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_1,end: color_2,),weight: 0.1),
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_2,end: color_1,),weight: 0.1),
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_1,end: color_2,),weight: 0.1),
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_1,end: color_2,),weight: 0.1),
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_2,end: color_1,),weight: 0.1),
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_1,end: color_2,),weight: 0.1),
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_2,end: color_1,),weight: 0.1),
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_1,end: color_2,),weight: 0.1),
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_2,end: color_0,),weight: 0.1),
    ];

    _newPointsTextAnimation = TweenSequence<Color?>(newPointsTextSequence)
        .animate(_newPointsAnimationController);

    // _newPointsPositionController = AnimationController(
    //   vsync: this,
    //   duration: const Duration(milliseconds: 1500),
    // );

    final List<TweenSequenceItem<Offset>> newPointsPositionSequence = [
      TweenSequenceItem<Offset>(
          tween: Tween(begin: Offset.zero, end: const Offset(0.0, -1.0)),
          weight: 1.0),
    ];

    _newPointsPositionAnimation =
        TweenSequence<Offset>(newPointsPositionSequence)
            .animate(_newPointsAnimationController);

    // _newPointsShadowController = AnimationController(
    //     vsync: this, duration: const Duration(milliseconds: 1500));

    final List<TweenSequenceItem<Color?>> newPointsShadowSequence = [
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_0,end: color_4,),weight: 0.1),
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_4,end: color_4,),weight: 0.8),
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_4,end: color_0,),weight: 0.1),
    ];

    _newPointsShadowAnimation = TweenSequence<Color?>(newPointsShadowSequence)
        .animate(_newPointsAnimationController);

    /// ============= FONT SIZE =====================
    // _newPointsFontSizeController = AnimationController(
    //     vsync: this, duration: const Duration(milliseconds: 1500));

    final List<TweenSequenceItem<double>> newPointsFontSizeSequence = [
      TweenSequenceItem<double>(tween: Tween(begin: 0.0,end: 1.0,),weight: 0.01),
      TweenSequenceItem<double>(tween: Tween(begin: 1.0,end: 1.0,),weight: 0.98),
      TweenSequenceItem<double>(tween: Tween(begin: 1.0,end: 0.0,),weight: 0.01),
    ];

    _newPointsFontSizeAnimation =TweenSequence<double>(newPointsFontSizeSequence).animate(_newPointsAnimationController);




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
    _newPointsAnimationController.dispose();
    // _newPointsTextController.dispose();
    // _newPointsPositionController.dispose();
    // _newPointsShadowController.dispose();
    // _newPointsFontSizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);
    final double sideLength = (MediaQuery.of(context).size.width*0.9) * settingsState.sizeFactor;
    return Consumer<GamePlayState>(
      builder: (context, gamePlayState, child) {
        return Positioned(
            top: getTileLocation(gamePlayState.pressedTile, sideLength )['y'],
            left: getTileLocation(gamePlayState.pressedTile, sideLength )['x'],
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _newPointsTextAnimation,
                _newPointsPositionAnimation,
                _newPointsShadowAnimation,
                _newPointsFontSizeAnimation
              ]),
              builder: (context, child) {
                return SlideTransition(
                  position: _newPointsPositionAnimation,
                  child: Text(
                    // "+${(widget.currentScore - widget.previousScore).toString()}",
                    getNewPointsValue(gamePlayState),
                    style: TextStyle(
                        fontSize: getTextSize(_newPointsFontSizeAnimation,settingsState.sizeFactor,gamePlayState), //(38 * settingsState.sizeFactor) * _newPointsFontSizeAnimation.value,
                        // fontSize:38,
                        color: _newPointsTextAnimation.value ?? Colors.black,
                        shadows: <Shadow>[
                          Shadow(
                            offset: const Offset(0.0, 0.0),
                            blurRadius: 30.0,
                            color: _newPointsShadowAnimation.value ?? Colors.black,
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

double getTextSize(Animation animation, double sizeFactor, GamePlayState gamePlayState) {
  double res = (38 *sizeFactor) * animation.value;
  if (gamePlayState.validIds.isEmpty) {
    res = 0;
  }
  return res;
}