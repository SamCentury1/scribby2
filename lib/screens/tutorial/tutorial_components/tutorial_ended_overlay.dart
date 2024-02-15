import 'dart:ui';

// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/tutorial_state.dart';
import 'package:scribby_flutter_v2/resources/auth_service.dart';
import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
import 'package:scribby_flutter_v2/screens/game_screen/game_screen.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_helpers.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class TutorialEndedOverlay extends StatefulWidget {
  const TutorialEndedOverlay({super.key});

  @override
  State<TutorialEndedOverlay> createState() => _TutorialEndedOverlayState();
}

class _TutorialEndedOverlayState extends State<TutorialEndedOverlay> {
  @override
  Widget build(BuildContext context) {

    late ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
    late GamePlayState gamePlayState = Provider.of<GamePlayState>(context, listen: false);
    late SettingsController settings = Provider.of<SettingsController>(context, listen: false);
    
    return Consumer<TutorialState>(
      builder: (context, tutorialState, child) {

        final Map<String,dynamic> currentStep = TutorialHelpers().getCurrentStep2(tutorialState);

        return AnimatedOpacity(
          opacity: currentStep['isGameEnded']
              ? 1.0
              : 0.0,
          duration: const Duration(milliseconds: 300),
          child: IgnorePointer(
            ignoring: !currentStep['isGameEnded'],
            child: Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                    },
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                      child: Container(
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      const Expanded(flex: 1, child: SizedBox()),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: DefaultTextStyle(
                          style: TextStyle(
                            color: palette.textColor2,
                            fontSize: 28
                          ), 
                          child: Text(
                            Helpers().translateText(gamePlayState.currentLanguage, "Congratulations!")
                          )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: DefaultTextStyle(
                            style: TextStyle(
                              color: palette.textColor2,
                              fontSize: 22,
                              
                            ), 
                            child: Center(
                              child: Text(
                                  Helpers().translateText(gamePlayState.currentLanguage, 
                                  "You just completed the demo! How would you like to proceed?"
                                ),
                              ),
                            )
                          ),
                        ),
                      ),                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          ElevatedButton(
                            onPressed: () {
                              FirestoreMethods().updateParameters(AuthService().currentUser!.uid,'hasSeenTutorial',true);

                              Helpers().getStates(gamePlayState, settings);

                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const GameScreen()
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
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
                              Helpers().translateText(gamePlayState.currentLanguage, "Start Game!"),
                              ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              tutorialState.setSequenceStep(1);
                            },
                            style: ElevatedButton.styleFrom(
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
                              Helpers().translateText(gamePlayState.currentLanguage, "Restart Tutorial")
                            ),
                          ),                          
                        ],
                      ),
                      const Expanded(flex: 1, child: SizedBox()),

                    ],
                  ),
                )                

                // SizedBox(
                //   width: double.infinity,
                //   child: Column(
                //     children: [
                //       const Expanded(flex: 3, child: SizedBox()),
                //       Padding(
                //         padding: const EdgeInsets.all(12.0),
                //         child: Center(
                //           child: DefaultTextStyle(
                //             style: TextStyle(fontSize: 22, color: palette.textColor2,),
                //             textAlign: TextAlign.center,
                //             child: Text("Congratulations on completing the demo! How would you like to proceed?",),
                //           ),                          
                //         ),
                //       ),
                //       const Expanded(flex: 1, child: SizedBox()),
                //       ElevatedButton(
                //         onPressed: () {
                //           FirestoreMethods().updateParameters(AuthService().currentUser!.uid,'hasSeenTutorial',true);

                //           Helpers().getStates(gamePlayState, settings);

                //           Navigator.of(context).pushReplacement(
                //             MaterialPageRoute(
                //                 builder: (context) => const GameScreen()
                //             ),
                //           );
                //         }, 
                //         child: Text("Start Game")
                //       ),
                //       const Expanded(flex: 1, child: SizedBox()),
                //       ElevatedButton(
                //         onPressed: () {}, 
                //         child: Text("Restart Tutorial")
                //       ),
                //       const Expanded(flex: 3, child: SizedBox()),
                  
                //     ],
                //   ),
                // )

              ],
            ),
          ),
        );
      },
    );
  }
}