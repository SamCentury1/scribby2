import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';

class GameOverOverlay extends StatelessWidget {
  const GameOverOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsState settingsState = Provider.of<SettingsState>(context,listen: false);
    return Consumer<GamePlayState>(
      builder: (context, gamePlayState, child) {
        return AnimatedOpacity(
          opacity: gamePlayState.isGameOver
              ? 1.0
              : 0.0,
          duration: const Duration(milliseconds: 300),
          child: IgnorePointer(
            ignoring: true,
            child: Stack(
              children: [
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      child: Center(
                        child: DefaultTextStyle(
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: gamePlayState.tileSize*0.7
                          ),
                          child: Text(
                            Helpers().translateText(gamePlayState.currentLanguage, "Game Over",settingsState)
                          ),
                        ),
                      ),                      
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
