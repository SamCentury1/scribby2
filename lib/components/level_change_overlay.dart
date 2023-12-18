import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:scribby_flutter_v2/functions/game_logic.dart';
// import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
// import 'package:scribby_flutter_v2/providers/animation_state.dart';
// import 'package:scribby_flutter_v2/screens/game_screen/dialogs/game_pause_dialog.dart';
// import 'package:scribby_flutter_v2/providers/game_state.dart';

class LevelChangeOverlay extends StatefulWidget {

  const LevelChangeOverlay({
    super.key,
  });

  @override
  State<LevelChangeOverlay> createState() => _LevelChangeOverlayState();
}

class _LevelChangeOverlayState extends State<LevelChangeOverlay>  with TickerProviderStateMixin{




  @override
  Widget build(BuildContext context) {

    return Consumer<GamePlayState>(
      builder: (context, gamePlayState, child) {

        return AnimatedOpacity(
          opacity: gamePlayState.displayLevelChange ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 150),
        
        
            child: IgnorePointer(
              ignoring: gamePlayState.isGameStarted,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: GestureDetector(
              
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                        child: Container(
                          color: Colors.black.withOpacity(0.35),
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
                          "Level ${gamePlayState.currentLevel}",
                          style: const TextStyle(
                            fontSize: 42,
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