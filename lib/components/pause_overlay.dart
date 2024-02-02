import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/game_logic.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
// import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/screens/game_screen/dialogs/game_pause_dialog.dart';
// import 'package:scribby_flutter_v2/providers/game_state.dart';

class PauseOverlay extends StatelessWidget {
  const PauseOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    late AnimationState animationState =Provider.of<AnimationState>(context, listen: false);
    return Consumer<GamePlayState>(
      builder: (context, gamePlayState, child) {
        return AnimatedOpacity(
          opacity: gamePlayState.isGameStarted && gamePlayState.isGamePaused
              ? 1.0
              : 0.0,
          duration: const Duration(milliseconds: 300),
          child: IgnorePointer(
            ignoring: !gamePlayState.isGamePaused,
            child: Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      if (gamePlayState.isGamePaused) {
                        if (gamePlayState.isGameStarted) {
                          gamePlayState.setIsGamePaused(false, 0);
                          GameLogic().executeTimerAnimation(animationState);
                        }
                      }
                    },
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
                const Center(
                  child: GamePauseDialog(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
