import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class TopLayer extends StatefulWidget {
  final Animation<double> gameStartedAnimation;
  final AnimationController clockController;
  const TopLayer({
    super.key,
    required this.gameStartedAnimation,
    required this.clockController
  });

  @override
  State<TopLayer> createState() => _TopLayerState();
}

class _TopLayerState extends State<TopLayer>
    with TickerProviderStateMixin {
  late AnimationState animationState;
  late Animation<double> clockAnimation;

  @override
  void initState() {
    super.initState();
    animationState = Provider.of<AnimationState>(context, listen: false);
    initializeAnimations();
  }

  void initializeAnimations() {
    final List<TweenSequenceItem<double>> timerTweenSequence = [
      TweenSequenceItem<double>(tween: Tween(begin: 0.2, end: 1.0), weight: 0.1),
      TweenSequenceItem<double>(tween: Tween(begin: 1.0, end: 1.0), weight: 0.8),
      TweenSequenceItem<double>(tween: Tween(begin: 1.0, end: 0.2), weight: 0.1),
    ];
    clockAnimation = TweenSequence<double>(timerTweenSequence).animate(widget.clockController);
  }

  double getContainerWidth(GamePlayState gamePlayState) {
    late double res = 0; 
    if (MediaQuery.of(context).size.width > 500) {
      res = gamePlayState.tileSize*6;
    } else {
      res = MediaQuery.of(context).size.width * 0.95;
    }
    return res;
  }

  String displayFormattedTime(int seconds) {
    String formattedTime = Helpers().formatTime(seconds);
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    final ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
    final SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);
    return Consumer<GamePlayState>(
      builder: (context, gamePlayState, child) {
        late String levelText = Helpers().translateText(gamePlayState.currentLanguage, "Level", settingsState);
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 500
          ),
          child: Center(
            child: Container(
              width: getContainerWidth(gamePlayState),
              child: Row(
                children: [
                  Text(
                    "$levelText ${gamePlayState.currentLevel}",
                    style: TextStyle(
                      fontSize: (gamePlayState.tileSize*0.45),
                      color: palette.textColor1.withOpacity(widget.gameStartedAnimation.value),
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                  AnimatedBuilder(
                    animation: widget.clockController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: clockAnimation.value,
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
                                      fontSize: (gamePlayState.tileSize*0.45),
                                      // color: const Color.fromARGB(255, 224, 224, 224),
                                      color: palette.textColor1.withOpacity(widget.gameStartedAnimation.value),
                                    ),
                                  );
                                },
                              ),
                              // Expanded(flex: 1, child: Center(),),
                              const SizedBox(width: 10),
                              Icon(
                                Icons.timer,
                                // color: GameLogic().getColor(widget.darkTheme, widget.palette, "timer_text"),
                                color: palette.textColor1.withOpacity(widget.gameStartedAnimation.value),
                                size: (gamePlayState.tileSize*0.45),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
