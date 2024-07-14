import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';

class GameStartOverlay extends StatefulWidget {
  final AnimationController gameStartedController;
  final Animation<double> gameStartedAnimation;
  const GameStartOverlay({
    super.key,
    required this.gameStartedController,
    required this.gameStartedAnimation,
  });

  @override
  State<GameStartOverlay> createState() => _GameStartOverlayState();
}

class _GameStartOverlayState extends State<GameStartOverlay> {
  @override
  Widget build(BuildContext context) {
    late  AnimationState animationState = Provider.of<AnimationState>(context,listen: false);
    late  SettingsState settingsState = Provider.of<SettingsState>(context,listen: false);
    return Consumer<GamePlayState>(

      builder: (builder,gamePlayState,child) {
        final double tileSize = gamePlayState.tileSize;

        return AnimatedBuilder(
          animation: widget.gameStartedController,
          builder: (context,child) {
            return Positioned.fill(
              child: IgnorePointer(
                ignoring: gamePlayState.isGameStarted,
                child: Container(
                  child: GestureDetector(
                    onTap: () {

                      gamePlayState.setIsGameStarted(true);
                      animationState.setShouldRunGameStartedAnimation(false);
                      animationState.setShouldRunGameStartedAnimation(true);
                    },
                                    
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 5.0*widget.gameStartedAnimation.value, 
                          sigmaY: 5.0*widget.gameStartedAnimation.value,
                        ),
                        child: Container(
                          color: gamePlayState.isGameStarted ? Colors.black.withOpacity(0.6*widget.gameStartedAnimation.value) : Colors.black.withOpacity(0.6),
                            child: Center(
                              child: DefaultTextStyle(
                                style: TextStyle(
                                  color: gamePlayState.isGameStarted ? Colors.white.withOpacity(widget.gameStartedAnimation.value) : Colors.white.withOpacity(1.0),
                                  fontSize: tileSize*0.7
                                ),
                                textAlign: TextAlign.center,
                                child: Text(
                                  Helpers().translateText(gamePlayState.currentLanguage, "Tap to Start", settingsState),
                                ),
                              ),
                            ),
                          ),                        
                        ),
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