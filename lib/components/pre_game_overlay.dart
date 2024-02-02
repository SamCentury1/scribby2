import 'dart:ui';

// import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
// import 'package:scribby_flutter_v2/functions/game_logic.dart';
// import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';

class PreGameOverlay extends StatefulWidget {
  const PreGameOverlay({super.key});

  @override
  State<PreGameOverlay> createState() => _PreGameOverlayState();
}

class _PreGameOverlayState extends State<PreGameOverlay> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GamePlayState>(
      builder: (context, gamePlayState, child) {
        return AnimatedOpacity(
          opacity: !gamePlayState.isGameStarted ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: IgnorePointer(
            ignoring: gamePlayState.isGameStarted,
            child: Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 9, sigmaY: 9),
                        child: Container(
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                      onTap: () {
                        // print("start game");
                        gamePlayState.setIsGameStarted(true);
                      }),
                ),
                Center(
                  child: DefaultTextStyle(
                    style: const TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontStyle: FontStyle.italic),
                    child: Text(
                      Helpers().translateText(gamePlayState.currentLanguage, "Tap to Start",),
                      
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
