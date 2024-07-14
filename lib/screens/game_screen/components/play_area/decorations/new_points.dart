import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';

class NewPoints extends StatefulWidget {
  final AnimationController wordFoundController;
  final Offset coords;
  const NewPoints({super.key, required this.wordFoundController, required this.coords});

  @override
  State<NewPoints> createState() => _NewPointsState();
}

class _NewPointsState extends State<NewPoints> with SingleTickerProviderStateMixin{

  late AnimationState animationState;
  late GamePlayState gamePlayState;
  late Animation<Color?> colorAnimation;
  late Animation<double> wordFoundPoints;
  late Animation<double> newPointsOpacity;

  @override
  void initState() {
    super.initState();
    gamePlayState = Provider.of<GamePlayState>(context, listen: false);
    animationState = Provider.of<AnimationState>(context, listen: false);
    initializeAnimations(widget.wordFoundController);
  }

  void initializeAnimations(AnimationController wordFoundController) {

    Color color_0 = Colors.transparent;
    Color color_1 = Colors.red;
    Color color_2 = Colors.yellow;
    List<Color> colors = [color_0,color_1,color_2];

    List<TweenSequenceItem<Color?>> colorAnimationTweenSequence =  [
      TweenSequenceItem(tween: ColorTween(begin: colors[1], end: colors[2],), weight: 15.0),
      TweenSequenceItem(tween: ColorTween(begin: colors[2], end: colors[1],), weight: 15.0),

      TweenSequenceItem(tween: ColorTween(begin: colors[1], end: colors[2],), weight: 15.0),
      TweenSequenceItem(tween: ColorTween(begin: colors[2], end: colors[1],), weight: 15.0),
      
      TweenSequenceItem(tween: ColorTween(begin: colors[1], end: colors[2],), weight: 15.0),
      TweenSequenceItem(tween: ColorTween(begin: colors[2], end: colors[1],), weight: 15.0),

      TweenSequenceItem(tween: ColorTween(begin: colors[1], end: colors[2],), weight: 10.0),
      TweenSequenceItem(tween: ColorTween(begin: colors[2], end: colors[0],), weight: 5.0),
    ];

    colorAnimation = TweenSequence(colorAnimationTweenSequence).animate(wordFoundController);


    List<TweenSequenceItem<double>> newPointsPositionSequence =  [
      TweenSequenceItem(tween: Tween(begin:gamePlayState.tileSize*0.5, end:gamePlayState.tileSize*2,), weight: 100),
    ];
    wordFoundPoints = TweenSequence<double>(newPointsPositionSequence).animate(wordFoundController);    

    List<TweenSequenceItem<double>> newPointsOpacitySequence =  [
      TweenSequenceItem(tween: Tween(begin:1.0, end:1,), weight: 80),
      TweenSequenceItem(tween: Tween(begin:1.0, end:0,), weight: 20),
    ];
    newPointsOpacity = TweenSequence<double>(newPointsOpacitySequence).animate(wordFoundController);         

  }
  @override
  void dispose() {
    super.dispose();
  }


  double showNewPointsAnimation(AnimationController controller) {
    double res = 1.0; 
    if (controller.isAnimating) {
      res = 1.0;
    } else {
      res = 0.0;
    }
    return res;
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<GamePlayState>(
      builder: (context,gamePlayState,child) {
        final int newPoints = gamePlayState.scoringLog[gamePlayState.scoringLog.length-1]['points'];
        return AnimatedBuilder(
          animation: widget.wordFoundController,
          builder: (context, child) {
            return Positioned(
              top: widget.coords.dy-wordFoundPoints.value,
              left: widget.coords.dx,
              child: IgnorePointer(
                ignoring: true,
                child: Container(
                  child: Center(
                    child: DefaultTextStyle(
                      style: TextStyle(
                        color: colorAnimation.value!.withOpacity(newPointsOpacity.value),
                        fontSize: (gamePlayState.tileSize*0.6)* showNewPointsAnimation(widget.wordFoundController),
                        shadows: [
                          Shadow(
                            offset: Offset.zero,
                            blurRadius: 5,
                            color: Colors.black.withOpacity(newPointsOpacity.value),
                          )
                        ],
                        fontWeight: FontWeight.w600
                      ),
                      child: Text("+${newPoints}",),
                    ),
                  ),
                ),
              ),
            );
          }
        );
      }
    );
  }
}