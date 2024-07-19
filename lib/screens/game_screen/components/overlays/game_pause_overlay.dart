import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/dialogs/game_pause_screens/game_help_screen.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/dialogs/game_pause_screens/game_quit_screen.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/dialogs/game_pause_screens/game_settings_screen.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/dialogs/game_pause_screens/game_summary_screen.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class GamePauseOverlay extends StatelessWidget {
  const GamePauseOverlay({super.key});


  Widget displayPage(String pageName) {                    
    if (pageName == 'summary') {
      return GameSummaryScreen();
    } else if (pageName == 'help') {
      return GameHelpScreen();
    } else if (pageName == 'settings') {
      return GameSettings();
    } else if (pageName == 'quit') {
      return GameQuitScreen();
    } else {
      // print("a problem occured");
      return GameSummaryScreen();
    }
  }  

  @override
  Widget build(BuildContext context) {
    late AnimationState animationState = Provider.of<AnimationState>(context, listen: false);
    late ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
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
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),
                ),
                Center(
                  child: displayPage(gamePlayState.pauseScreen)
                ),

                  Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(
                      onPressed: () {
                        if (gamePlayState.isGamePaused) {
                          if (gamePlayState.isGameStarted) {
                            gamePlayState.setIsGamePaused(false);
                            gamePlayState.countDownController.resume();
                            animationState.setShouldRunClockAnimation(true);
                            Future.microtask(() {
                              animationState.setShouldRunClockAnimation(false);
                            });                        
                          }
                        }   
                      },
                      icon: Icon(Icons.close),
                      iconSize: gamePlayState.tileSize*0.35,
                      color: palette.overlayText,
                    )
                  ),                  
              ],
            ),
          ),
        );
      },
    );
  }
}
