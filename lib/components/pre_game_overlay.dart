import 'dart:ui';

// import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
// import 'package:scribby_flutter_v2/functions/game_logic.dart';
// import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_helpers.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class PreGameOverlay extends StatefulWidget {
  const PreGameOverlay({super.key});

  @override
  State<PreGameOverlay> createState() => _PreGameOverlayState();
}

class _PreGameOverlayState extends State<PreGameOverlay> {
  @override
  Widget build(BuildContext context) {
    late ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
    late SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);
    return Consumer<GamePlayState>(
      builder: (context, gamePlayState, child) {
        final bool hasSeenTutorial = settingsState.userData['parameters']['hasSeenTutorial'];
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

                Column(
                  children: [
                    const Expanded(flex: 3, child: SizedBox()),

                    GestureDetector(
                      onTap: () {
                        gamePlayState.setIsGameStarted(true);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Center(
                          child: DefaultTextStyle(
                            style: const TextStyle(
                                fontSize: 32,
                                color: Colors.white,
                                fontStyle: FontStyle.italic),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                Helpers().translateText(gamePlayState.currentLanguage, "Tap to Start",),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Expanded(flex: 1, child: SizedBox()),

                    hasSeenTutorial
                    ? const SizedBox() 
                    : Column(
                      children: [
                        DefaultTextStyle(
                          style: const TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontStyle: FontStyle.italic),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              Helpers().translateText(gamePlayState.currentLanguage, "Not sure how to play?",),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        ElevatedButton(
                          onPressed: () {
                            TutorialHelpers().navigateToTutorial(context, gamePlayState.currentLanguage);
                            // processLanguageSelection(settingsState);
                          },
                          style: ElevatedButton.styleFrom(
                            // backgroundColor: GameLogic().getColor(_userData['parameters']['darkMode'], palette, "option_button_bg"), //olor.fromARGB(255, 248, 175, 175) ,
                            // foregroundColor: GameLogic().getColor(_userData['parameters']['darkMode'], palette, "option_button_text"),
                            backgroundColor: palette.optionButtonBgColor , 
                            foregroundColor: palette.optionButtonTextColor,
                            shadowColor: const Color.fromRGBO(123, 123, 123, 0.7),
                            shape:  RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                              side: BorderSide(
                                // color: GameLogic().getColor(_userData['parameters']['darkMode'], palette, "option_button_bg"),
                                color: palette.optionButtonBgColor,
                                width: 1,
                                style: BorderStyle.solid
                              ), 
                            ),                            
                          ),
                          child: Text(
                            Helpers().translateText(gamePlayState.currentLanguage, "Watch a Demo!",),
                            style: TextStyle(
                              color: palette.textColor2,
                            ),                         
                          ),
                        ),                       
                      ],
                    ),                   
                    const Expanded(flex: 3, child: SizedBox()),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
