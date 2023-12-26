// import 'package:expansion_tile_card/expansion_tile_card.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/components/dialog_widget.dart';
// import 'package:scribby_flutter_v2/functions/game_logic.dart';
// import 'package:scribby_flutter_v2/player_progress/player_progress.dart';
// import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
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
    // late GamePlayState gamePlayState = Provider.of<GamePlayState>(context, listen: false);
    // late gamePlayState gameState = Provider.of<GameState>(context, listen: false);
    return Consumer<GamePlayState>(
      builder: (context, gamePlayState, child) {
        return DialogWidget(
            key,
            "Quit Game",
            Column(
              children: [
                const Expanded(flex: 3, child: SizedBox()),

                TextButton(
                    onPressed: () {
                      debugPrint(
                          "Activate 'are you sure you want to quit game?' ");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: palette.optionButtonBgColor2,
                      padding: const EdgeInsets.all(4.0),
                      textStyle:
                          TextStyle(fontSize: 22, color: palette.textColor2),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        side: BorderSide(
                            color: Color.fromARGB(255, 245, 245, 245),
                            width: 1,
                            style: BorderStyle.solid),
                      ),
                    ),
                    child: const Text(
                      "Quit Game",
                    )),

                const Expanded(child: SizedBox()),

                TextButton(
                    onPressed: () {
                      debugPrint(
                          "Activate 'are you sure you want restart game?' ");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: palette.optionButtonBgColor2,
                      padding: const EdgeInsets.all(4.0),
                      textStyle:
                          TextStyle(fontSize: 22, color: palette.textColor2),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        side: BorderSide(
                            color: Color.fromARGB(255, 245, 245, 245),
                            width: 1,
                            style: BorderStyle.solid),
                      ),
                    ),
                    child: const Text(
                      "Restart Game",
                    )),
                const Expanded(flex: 3, child: SizedBox()),
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
