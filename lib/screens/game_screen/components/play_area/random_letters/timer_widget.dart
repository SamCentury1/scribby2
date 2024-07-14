import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/game_logic_2.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/play_area/decorations/timer_decoration_circle.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class TimerWidget extends StatefulWidget {
  final AnimationController timerController;
  final Animation timerAnimation;
  const TimerWidget({super.key, required this.timerController, required this.timerAnimation});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> with SingleTickerProviderStateMixin {

  late AnimationState animationState;
  late Duration durationValue;

  @override
  void initState() {
    super.initState();
    animationState = Provider.of<AnimationState>(context, listen: false);
    durationValue = Duration(milliseconds: 0);
  }

  late ColorPalette palette = Provider.of<ColorPalette>(context,listen: false);
  @override
  Widget build(BuildContext context) {
    return Consumer<GamePlayState>(
      builder: (context,gamePlayState,child) {
        late AnimationState animationState = Provider.of<AnimationState>(context,listen: false);
        double containerWidth = gamePlayState.tileSize*2;
        double diameter = gamePlayState.tileSize*1.5;
        return Container(
          width: containerWidth,
          height: containerWidth,
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: widget.timerController,
                builder: (context,child) {
                  return Positioned(
                    top: (containerWidth-diameter)/2,
                    left: (containerWidth-diameter)/2,
                    child: Container(
                      width: diameter,
                      height: diameter,
                      child: CustomPaint(
                        painter: MakeCircle(
                          radius: diameter/2, 
                          animationValue: widget.timerAnimation.value * Helpers().showEffectsTimerUnderThreeSeconds(gamePlayState, durationValue.inSeconds.toDouble())
                        ),
                      ),
                    ),
                  );
                }
              ),
              AnimatedBuilder(
                animation: widget.timerController,
                builder: (context,child) {
                  return Positioned(
                    top: (containerWidth-diameter)/2,
                    left: (containerWidth-diameter)/2,
                    child: Container(
                      width: diameter,
                      height: diameter,                  
                      child: CircularCountDownTimer(
                        duration: 10,
                        initialDuration:  0,
                        controller: gamePlayState.countDownController,
                        width: diameter,
                        height: diameter,
                        // ringColor: Color.fromARGB(164, 36, 85, 190),
                        ringColor: palette.timerRingColor,
                        ringGradient: LinearGradient(colors: [palette.timerRingGradient1, palette.timerRingGradient2]),
                        // fillColor: Color.fromARGB(230, 250, 239, 82), // Colors.purpleAccent[100]!,
                        fillColor: palette.timerFillColor,
                        fillGradient: LinearGradient(colors: [palette.timerFillGradient1, palette.timerFillGradient2]),
                        backgroundColor:Colors.transparent,
                        backgroundGradient: null,
                        strokeWidth: gamePlayState.tileSize*0.10,
                        strokeCap: StrokeCap.round,
                        textStyle: TextStyle(
                            fontSize: ((gamePlayState.tileSize*0.8)*widget.timerAnimation.value),
                            color: Colors.red.withOpacity(widget.timerAnimation.value * Helpers().showEffectsTimerUnderThreeSeconds(gamePlayState, durationValue.inSeconds.toDouble())),
                            shadows: [
                              Shadow(
                                color: Colors.red.withOpacity(widget.timerAnimation.value * Helpers().showEffectsTimerUnderThreeSeconds(gamePlayState, durationValue.inSeconds.toDouble())),
                                offset: Offset.zero,
                                blurRadius: 35.0 * widget.timerAnimation.value,
                              ),
                              Shadow(
                                color: Colors.white.withOpacity(widget.timerAnimation.value * Helpers().showEffectsTimerUnderThreeSeconds(gamePlayState, durationValue.inSeconds.toDouble())),
                                offset: Offset.zero,
                                blurRadius: 45.0 * widget.timerAnimation.value,
                              )
                            ]
                        ),
                        textFormat: CountdownTextFormat.S,
                        isReverse: true,
                        isReverseAnimation: false,
                        isTimerTextShown: true,
                        autoStart: true,
                        onStart: () {
                            Future.microtask(() {
                              animationState.setShouldRunTimerAnimation(true);
                            });                            
                        },
                        onComplete: () {
                          GameLogic().executeTimeRanOut(context, gamePlayState,animationState);
                          gamePlayState.countDownController.pause();
                        },
                        onChange: (String timeStamp) {},                            
                        timeFormatterFunction: (defaultFormatterFunction, duration) {
                            Future.microtask(() {
                              setState(() {
                                durationValue = duration;
                              });
                            });                                    
                          if (duration.inSeconds <= 2) {
                            return Function.apply(defaultFormatterFunction, [duration + const Duration(milliseconds: 1000) ]);
                          } else {
                            return "";
                          }
                        },
                      ),
                    ),
                  );
                }
              ),
            ],
          ),            
        );
      }
    );
  }
}
