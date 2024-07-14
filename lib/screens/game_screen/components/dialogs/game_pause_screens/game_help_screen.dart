import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/play_area/decorations/demo_board_state.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class GameHelpScreen extends StatefulWidget {
  const GameHelpScreen({super.key});

  @override
  State<GameHelpScreen> createState() => _GameHelpScreenState();
}

class _GameHelpScreenState extends State<GameHelpScreen> {
  Key? get key => null;

  late ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
  late SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);
  late AnimationState animationState = Provider.of<AnimationState>(context, listen: false);



  @override
  Widget build(BuildContext context) {
    return Consumer<GamePlayState>(
      builder: (context, gamePlayState, child) {

        return Stack(
          children: [
        
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  gamePlayState.tileSize*0.2,
                  gamePlayState.tileSize*0.0,
                  gamePlayState.tileSize*0.2,
                  gamePlayState.tileSize*0.0,
                ),
                child: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Container(
                            height: gamePlayState.tileSize*1,
                            child:FittedBox(
                                fit: BoxFit.scaleDown,
                                child: DefaultTextStyle(
                                  child: Text(
                                    Helpers().translateText(gamePlayState.currentLanguage, "Instructions",settingsState),
                                  ),
                                  style: Helpers().customTextStyle(palette.overlayText,gamePlayState.tileSize*0.5),
                                ),
                              ),                        
                            ),
                        ),
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: gamePlayState.tileSize*0.2),
                            child: Divider(
                              color: palette.overlayText,
                              height: 2,
                            ),
                          ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Helpers().instructionsHeading(palette.overlayText, "Objective",gamePlayState.currentLanguage, gamePlayState.tileSize*0.35,settingsState),
                        Helpers().instructionsText(palette.overlayText,
                            "The objective of the game is to create words with the randomly generated letters.",
                            gamePlayState.currentLanguage,
                            false,
                            gamePlayState.tileSize*0.30,
                            settingsState.demoLetters,
                            settingsState),
                        Helpers().instructionsHeading(palette.overlayText, "Demo",gamePlayState.currentLanguage, gamePlayState.tileSize*0.35,settingsState),
                        Helpers().instructionsText(palette.overlayText,
                            "The two letters at the top are randomly generated. The center letter letter_01 gets placed next",
                            gamePlayState.currentLanguage,
                            true,
                            gamePlayState.tileSize*0.30,
                            settingsState.demoLetters,
                            settingsState),
                        DemoBoardState(demoBoardState: settingsState.demoStates['demoBoardState1'], language: gamePlayState.currentLanguage),
                        Helpers().instructionsText(palette.overlayText,
                            "When the letter letter_01 is placed inside the board, the letter to the right letter_02 will become the center letter and a new random letter will be generated and take its spot",
                            gamePlayState.currentLanguage,
                            true,
                            gamePlayState.tileSize*0.30,
                            settingsState.demoLetters,
                            settingsState),
                        Helpers().instructionsText(palette.overlayText,
                            "A new letter letter_03 is randomly generated to be place after the next letter letter_02 is placed.",
                            gamePlayState.currentLanguage,
                            true,
                            gamePlayState.tileSize*0.30,
                            settingsState.demoLetters,
                            settingsState),
                        DemoBoardState(demoBoardState: settingsState.demoStates['demoBoardState2'], language: gamePlayState.currentLanguage),
                        Helpers().instructionsText(palette.overlayText,
                            "Place your letters strategically to create words. In this case, we see the letter_04 coming after the letter_03",
                            gamePlayState.currentLanguage,
                            true,
                            gamePlayState.tileSize*0.30,
                            settingsState.demoLetters,
                            settingsState),
                        DemoBoardState(demoBoardState: settingsState.demoStates['demoBoardState3'], language: gamePlayState.currentLanguage),
                        Helpers().instructionsText(palette.overlayText,
                            "The letter_03 is placed below the letter_02 so the letter_04 can be placed between the letter_01 and the letter_02 and create the word WORD",
                            gamePlayState.currentLanguage,
                            true,
                            gamePlayState.tileSize*0.30,
                            settingsState.demoLetters,
                            settingsState),
                        DemoBoardState(demoBoardState: settingsState.demoStates['demoBoardState4'], language: gamePlayState.currentLanguage),
                        Helpers().instructionsText(palette.overlayText,
                            "The letter_04 is placed in between the letter_01 and letter_02. The letters animate and you are granted points for the letters.",
                            gamePlayState.currentLanguage,
                            true,
                            gamePlayState.tileSize*0.30,
                            settingsState.demoLetters,
                            settingsState),
                        // Helpers().instructionsHeading(palette.overlayText,
                        //     "Swipe to 'Settings' to understand how points are allocated",gamePlayState.currentLanguage, gamePlayState.tileSize*0.35),
                        DemoBoardState(demoBoardState: settingsState.demoStates['demoBoardState5'], language: gamePlayState.currentLanguage),
                        Helpers().instructionsText(palette.overlayText,
                            "After an animation plays, the letters from the word WORD will disappear from the board and the spaces will become available for new letters",
                            gamePlayState.currentLanguage,
                            true,
                            gamePlayState.tileSize*0.30,
                            settingsState.demoLetters,
                            settingsState),
                        DemoBoardState(demoBoardState: settingsState.demoStates['demoBoardState6'], language: gamePlayState.currentLanguage),
                        Helpers().instructionsText(palette.overlayText,
                            "The spaces become available for the new letters to be placed",
                            gamePlayState.currentLanguage,
                            false,
                            gamePlayState.tileSize*0.30,
                            settingsState.demoLetters,
                            settingsState)
                      ],
                    ),
                                  ),
                                ),
                    
                        ],
                      ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: gamePlayState.tileSize*0.2,
              right: (settingsState.screenSizeData['width']-(gamePlayState.tileSize*6))/2,
              // right: 0,
              child: Container(
                width: gamePlayState.tileSize*6,
                // color: Colors.blue,
                child: Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
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
                    child: Container(
                      width: gamePlayState.tileSize*0.7,
                      height: gamePlayState.tileSize*0.7,  
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.all(Radius.circular(100.0))
                      ),
                      child: Icon(
                        Icons.close, 
                        size: gamePlayState.tileSize*0.4,
                        color: palette.overlayText.withOpacity(0.5),
                      )  
                    ),
                  ),
                ),
              ),
            )
          ],
        );     
      },

    );
  }
}


