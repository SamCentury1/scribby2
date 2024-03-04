import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:scribby_flutter_v2/functions/game_logic.dart';
// import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
// import 'package:scribby_flutter_v2/providers/animation_state.dart';
// import 'package:scribby_flutter_v2/screens/game_screen/dialogs/game_pause_dialog.dart';
// import 'package:scribby_flutter_v2/providers/game_state.dart';

class GameOverOverlay extends StatelessWidget {
  const GameOverOverlay({super.key});


  @override
  Widget build(BuildContext context) {

    late SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);


    return Consumer<GamePlayState>(
      builder: (context, gamePlayState, child) {

        return AnimatedOpacity(
          opacity: gamePlayState.isGameEnded ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
        
        
            child: IgnorePointer(
              ignoring: !gamePlayState.isGameEnded,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: GestureDetector(
              
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Center(
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          "Game Over",
                          style: TextStyle(
                            fontSize: 42 * settingsState.sizeFactor,
                            color: Colors.white,
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