// import 'package:expansion_tile_card/expansion_tile_card.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/components/dialog_widget.dart';
import 'package:scribby_flutter_v2/functions/game_logic.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
// import 'package:scribby_flutter_v2/functions/game_logic.dart';
// import 'package:scribby_flutter_v2/player_progress/player_progress.dart';
// import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';
// import 'package:scribby_flutter_v2/providers/game_state.dart';
// import 'package:scribby_flutter_v2/screens/game_over_screen/game_over_screen.dart';
// import 'package:scribby_flutter_v2/screens/game_screen/game_screen.dart';
// import 'package:scribby_flutter_v2/styles/buttons.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';
// import 'package:scribby_flutter_v2/utils/states.dart';

class GameQuitScreen extends StatefulWidget {
  // final Function(bool) setGamePaused;
  // final bool gamePaused;
  const GameQuitScreen(
      {
      // required this.setGamePaused,
      // required this.gamePaused,
      super.key});

  @override
  State<GameQuitScreen> createState() => _GameQuitScreenState();
}

class _GameQuitScreenState extends State<GameQuitScreen>
    with TickerProviderStateMixin {
  late bool isPause;

  Key? get key => null;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // late AnimationState animationState =
    //     Provider.of<AnimationState>(context, listen: false);

    late ColorPalette palette =
        Provider.of<ColorPalette>(context, listen: false);

    late SettingsController settings =
        Provider.of<SettingsController>(context, listen: false);
    // late GamePlayState gamePlayState = Provider.of<GamePlayState>(context, listen: false);
    // late gamePlayState gameState = Provider.of<GameState>(context, listen: false);
    return Consumer<GamePlayState>(
      builder: (context, gamePlayState, child) {
        return DialogWidget(
            key,
            Helpers().translateText(gamePlayState.currentLanguage,"Quit Game",),
            Column(
              children: [
          const Expanded(flex: 2, child: SizedBox(),),
          Text(
            Helpers().translateText(gamePlayState.currentLanguage,
            "Would you like to leave?",
            ),
            style: TextStyle(
              color: palette.textColor2,
              fontSize: 22
            ),
          ),
          TextButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: palette.optionButtonBgColor3,
              foregroundColor: palette.textColor1,
              shadowColor:
                  const Color.fromRGBO(123, 123, 123, 0.7),
              elevation: 3.0,
              minimumSize: const Size(double.infinity, 50),
              padding: const EdgeInsets.all(4.0),
              textStyle: TextStyle(
                fontSize: 22,
                color: palette.textColor2
              ),
              shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(10.0)),
              ),
            ),      
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: palette.optionButtonBgColor2,
                      title: Text(
                        Helpers().translateText(gamePlayState.currentLanguage,
                          "Quit Game",
                        ),
                        style: TextStyle(color: palette.textColor2),
                      ),
                      content: Text(
                        Helpers().translateText(gamePlayState.currentLanguage,
                          "Are you sure you want to quit the game?",
                        ),
                        style: TextStyle(
                            fontSize: 20, color: palette.textColor2),
                      ),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () {
                              GameLogic().executeGameOver(
                                  gamePlayState, context);
                            },
                            child: Text(
                              Helpers().translateText(gamePlayState.currentLanguage,
                                "Yes",
                              ),
                              style:
                                  TextStyle(color: palette.textColor2),
                            )),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              Helpers().translateText(gamePlayState.currentLanguage,
                                "Cancel",
                              ),
                              style:
                                  TextStyle(color: palette.textColor2),
                            )),
                      ],
                    );
                  });

              debugPrint(
                  "Activate 'are you sure you want to quit the game?' ");
            },              
    
            child: Text(
              Helpers().translateText(gamePlayState.currentLanguage,"Exit",)),
          ),
      
          const Expanded(flex: 1, child: SizedBox(),),
          Text(
            Helpers().translateText(gamePlayState.currentLanguage,
            "Or simply restart?",
            ),
            style: TextStyle(
              color: palette.textColor2,
              fontSize: 22
            ),          
          ),
          TextButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: palette.optionButtonBgColor3,
              foregroundColor: palette.textColor1,
              shadowColor:
                  const Color.fromRGBO(123, 123, 123, 0.7),
              elevation: 3.0,
              minimumSize: const Size(double.infinity, 50),
              padding: const EdgeInsets.all(4.0),
              textStyle: const TextStyle(
                fontSize: 22,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(10.0)),
              ),
            ),            
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: palette.optionButtonBgColor2,
                      title: Text(
                        Helpers().translateText(gamePlayState.currentLanguage,
                        "Restart",
                        ),
                        style: TextStyle(color: palette.textColor2),
                      ),
                      content: Text(
                        Helpers().translateText(gamePlayState.currentLanguage,
                          "Are you sure you want to restart the game?",
                        ),
                        style: TextStyle(
                            fontSize: 20, color: palette.textColor2),
                      ),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () {
                              gamePlayState.restartGame();
                              Helpers()
                                  .getStates(gamePlayState, settings);
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              Helpers().translateText(gamePlayState.currentLanguage,
                              "Yes",
                              ),
                              style:
                                  TextStyle(color: palette.textColor2),
                            )),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              Helpers().translateText(gamePlayState.currentLanguage,
                              "Cancel",
                              ),
                              style:
                                  TextStyle(color: palette.textColor2),
                            )),
                      ],
                    );
                  });

              debugPrint(
                  "Activate 'are you sure you want restart game?' ");
            },
            child: Text(
              Helpers().translateText(gamePlayState.currentLanguage,
              "Restart"
              ),
            )
          ),       
          const Expanded(flex: 3, child: SizedBox(),),                
                // const Expanded(flex: 3, child: SizedBox()),

                // TextButton(
                //     onPressed: () {
                //       showDialog(
                //           context: context,
                //           builder: (BuildContext context) {
                //             return AlertDialog(
                //               backgroundColor: palette.optionButtonBgColor2,
                //               title: Text(
                //                 "Quit Game",
                //                 style: TextStyle(color: palette.textColor2),
                //               ),
                //               content: Text(
                //                 "Are you sure you want to quit this game?",
                //                 style: TextStyle(
                //                     fontSize: 20, color: palette.textColor2),
                //               ),
                //               actions: <Widget>[
                //                 TextButton(
                //                     onPressed: () {
                //                       GameLogic().executeGameOver(
                //                           gamePlayState, context);
                //                     },
                //                     child: Text(
                //                       "Yes",
                //                       style:
                //                           TextStyle(color: palette.textColor2),
                //                     )),
                //                 TextButton(
                //                     onPressed: () {
                //                       Navigator.of(context).pop();
                //                     },
                //                     child: Text(
                //                       "Cancel",
                //                       style:
                //                           TextStyle(color: palette.textColor2),
                //                     )),
                //               ],
                //             );
                //           });

                //       debugPrint(
                //           "Activate 'are you sure you want to quit game?' ");
                //     },
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: palette.optionButtonBgColor2,
                //       padding: const EdgeInsets.fromLTRB(16, 4.0, 16.0, 4.0),
                //       textStyle:
                //           TextStyle(fontSize: 22, color: palette.textColor2),
                //       shape: const RoundedRectangleBorder(
                //         borderRadius: BorderRadius.all(Radius.circular(10.0)),
                //         side: BorderSide(
                //             color: Color.fromARGB(0, 0, 0, 0),
                //             width: 1,
                //             style: BorderStyle.solid),
                //       ),
                //     ),
                //     child: Text(
                //       "Quit Game",
                //       style: TextStyle(color: palette.textColor2, fontSize: 22),
                //     )),

                // const Expanded(child: SizedBox()),

                // TextButton(
                //     onPressed: () {
                //       showDialog(
                //           context: context,
                //           builder: (BuildContext context) {
                //             return AlertDialog(
                //               backgroundColor: palette.optionButtonBgColor2,
                //               title: Text(
                //                 "Restart Game",
                //                 style: TextStyle(color: palette.textColor2),
                //               ),
                //               content: Text(
                //                 "Are you sure you want to restart this game?",
                //                 style: TextStyle(
                //                     fontSize: 20, color: palette.textColor2),
                //               ),
                //               actions: <Widget>[
                //                 TextButton(
                //                     onPressed: () {
                //                       gamePlayState.restartGame();
                //                       Helpers()
                //                           .getStates(gamePlayState, settings);
                //                       Navigator.of(context).pop();
                //                     },
                //                     child: Text(
                //                       "Yes",
                //                       style:
                //                           TextStyle(color: palette.textColor2),
                //                     )),
                //                 TextButton(
                //                     onPressed: () {
                //                       Navigator.of(context).pop();
                //                     },
                //                     child: Text(
                //                       "Cancel",
                //                       style:
                //                           TextStyle(color: palette.textColor2),
                //                     )),
                //               ],
                //             );
                //           });

                //       debugPrint(
                //           "Activate 'are you sure you want restart game?' ");
                //     },
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: palette.optionButtonBgColor2,
                //       padding: const EdgeInsets.fromLTRB(16, 4.0, 16.0, 4.0),
                //       textStyle:
                //           TextStyle(fontSize: 22, color: palette.textColor2),
                //       shape: const RoundedRectangleBorder(
                //         borderRadius: BorderRadius.all(Radius.circular(10.0)),
                //         side: BorderSide(
                //             color: Color.fromARGB(0, 0, 0, 0),
                //             width: 1,
                //             style: BorderStyle.solid),
                //       ),
                //     ),
                //     child: Text(
                //       "Restart Game",
                //       style: TextStyle(color: palette.textColor2, fontSize: 22),
                //     )),
                // const Expanded(flex: 3, child: SizedBox()),
                // const SizedBox(
                //   height: 20,
                // ),

                // ExpansionTileCard(
                //   leading: const Icon(Icons.cancel),
                //   title: const SizedBox(
                //       width: double.infinity,
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           Text("Quit Current Game?"),
                //         ],
                //       )),
                //   trailing: const SizedBox(),
                //   children: [
                //     Row(
                //       children: [
                //         const SizedBox(
                //           width: 10,
                //         ),
                //         Expanded(
                //           flex: 2,
                //           child: ElevatedButton(
                //               style: gameCancel,
                //               onPressed: () {
                //                 gamePlayState.setIsGamePaused(false, 0);
                //                 GameLogic()
                //                     .executeTimerAnimation(animationState);
                //               },
                //               child: const Text("No")),
                //         ),
                //         const Expanded(
                //           flex: 1,
                //           child: SizedBox(),
                //         ),
                //         Expanded(
                //           flex: 2,
                //           child: ElevatedButton(
                //               style: gameQuit,
                //               onPressed: () {
                //                 GameLogic()
                //                     .executeGameOver(gamePlayState, context);
                //               },
                //               child: const Text("Yes, Quit")),
                //         ),
                //         const SizedBox(
                //           width: 10,
                //         ),
                //       ],
                //     )
                //   ],
                // ),
                // const SizedBox(
                //   height: 10,
                // ),
                // ExpansionTileCard(
                //   leading: const Icon(Icons.refresh),
                //   title: const SizedBox(
                //       width: double.infinity,
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           Text("Restart Current Game?"),
                //         ],
                //       )),
                //   trailing: const SizedBox(),
                //   children: [
                //     Row(
                //       children: [
                //         const SizedBox(
                //           width: 10,
                //         ),
                //         Expanded(
                //           flex: 2,
                //           child: ElevatedButton(
                //               style: gameCancel,
                //               onPressed: () {
                //                 // updateGamePaused(false);
                //                 gamePlayState.setIsGamePaused(false, 0);
                //                 GameLogic()
                //                     .executeTimerAnimation(animationState);
                //               },
                //               child: const Text("No")),
                //         ),
                //         const Expanded(
                //           flex: 1,
                //           child: SizedBox(),
                //         ),
                //         Expanded(
                //           flex: 2,
                //           child: ElevatedButton(
                //               style: gameRestart,
                //               onPressed: () {
                //                 // gamePlayState.setIsGameStarted(false);
                //                 // gamePlayState.setIsGamePaused(true);
                //                 gamePlayState.restartGame();
                //                 // GameLogic().removeStartGameOverlay(gamePlayState);
                //                 // gamePlayState.restartGame();
                //                 // gamePlayState.startTimer();
                //               },
                //               child: const Text("Yes, Restart")),
                //         ),
                //         const SizedBox(
                //           width: 10,
                //         )
                //       ],
                //     )
                //   ],
                // ),
              ],
            ),
            null);
      },
    );
  }
}
