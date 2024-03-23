// import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:scribby_flutter_v2/ads/ads_controller.dart';
// import 'package:scribby_flutter_v2/ads/banner_ad_widget.dart';
import 'package:scribby_flutter_v2/audio/audio_controller.dart';
import 'package:scribby_flutter_v2/components/board.dart';
// import 'package:scribby_flutter_v2/audio/sounds.dart';
import 'package:scribby_flutter_v2/components/bonus_score_elements.dart';
import 'package:scribby_flutter_v2/components/draggable_tile.dart';
import 'package:scribby_flutter_v2/components/game_over_overlay.dart';
// import 'package:scribby_flutter_v2/components/level_change_overlay.dart';
import 'package:scribby_flutter_v2/components/new_points_animation.dart';
import 'package:scribby_flutter_v2/components/pause_overlay.dart';
import 'package:scribby_flutter_v2/components/pre_game_overlay.dart';
import 'package:scribby_flutter_v2/components/random_letters.dart';
import 'package:scribby_flutter_v2/components/reserve_tiles.dart';
import 'package:scribby_flutter_v2/components/scoreboard.dart';
import 'package:scribby_flutter_v2/components/tile.dart';
import 'package:scribby_flutter_v2/components/timer_widget.dart';
import 'package:scribby_flutter_v2/functions/game_logic.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
// import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
// import 'package:scribby_flutter_v2/providers/game_state.dart';
// import 'package:scribby_flutter_v2/resources/auth_service.dart';
// import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';
import 'package:scribby_flutter_v2/utils/states.dart';
// import 'package:scribby_flutter_v2/utils/dictionary.dart';
// import 'package:scribby_flutter_v2/utils/states.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  // late AnimationState _animationState;
  // late GameState _gameState;
  late AudioController _audioController;
  // late GamePlayState gamePlayState;
  // late SettingsController _settings;
  // late AnimationState _animationState;
  late bool isAnimating = false;
  late bool isDragging = false;
  late Map<String, dynamic> draggedSpot = {};
  late List<Map<String, dynamic>> reserveLetters = [];

  // late List<dynamic> _alphabetData = [];
  late bool isLoading = false;
  late bool pressingOnTile = false;

  // late List<Map<String,dynamic>> _startingAlphabetState = [];
  // late List<String> _randomLetterListState = [];
  // late List<Map<String,dynamic>> _startingTileState = [];

  @override
  void initState() {
    super.initState();

    _audioController = Provider.of<AudioController>(context, listen: false);
    // gamePlayState = Provider.of<GamePlayState>(context, listen: false);

  }



  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // final adsController = context.watch<AdsController?>();
    // adsController?.preloadAd();

    // final GamePlayState gamePlayState = Provider.of<GamePlayState>(context, listen: false);
    final SettingsController settings =
        Provider.of<SettingsController>(context, listen: false);

    final SettingsState settingsState =
        Provider.of<SettingsState>(context, listen: false);        
    // final Palette palette = Provider.of<Palette>(context, listen: false);
    final ColorPalette palette =
        Provider.of<ColorPalette>(context, listen: false);

    final AnimationState animationState =
        Provider.of<AnimationState>(context, listen: false);     

    final GamePlayState gamePlayState =
        Provider.of<GamePlayState>(context, listen: false);                

    // return isLoading ? const Center(child: CircularProgressIndicator(),): 
          return Consumer<GamePlayState>(
            builder: (context, gamePlayState, child) {
              
              return PopScope(
                canPop: false,
                onPopInvoked: (details) {
                  gamePlayState.setIsGamePaused(true, 0);
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: palette.optionButtonBgColor,
                          title: Text(
                            "Quit Game",
                            style:
                                TextStyle(fontSize: 22, color: palette.textColor2),
                          ),
                          content: Text(
                            "Are you sure you want to quit the current game?",
                            style:
                                TextStyle(fontSize: 20, color: palette.textColor2),
                          ),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () {
                                  GameLogic()
                                      .executeGameOver(gamePlayState, context);
                                },
                                child: Text(
                                  "Yes",
                                  style: TextStyle(color: palette.textColor2),
                                )),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(color: palette.textColor2),
                                )),
                          ],
                        );
                      });
                },
                child: Stack(
                  children: [
                    SafeArea(
                      child: Scaffold(
                        // appBar: const PreferredSize(
                        //   preferredSize: Size.fromHeight(120),
                        //   child: BannerAdWidget() ,
                        // ),
                        body: Container(
                          // color: GameLogic().getColor(settings.darkTheme.value, palette, "screen_background"),
                          color: palette.screenBackgroundColor,
                          child: Padding(
                            padding:const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                            child: Center(
                              child: Column(
                                children: [
                                  // const SizedBox(height: 20,),
                                  TimerWidget(
                                    darkTheme: settings.darkTheme.value,
                                    palette: palette,
                                  ),
              
                                  const Scoreboard(),
                                  const BonusScoreElements(),
              
                                  // RANDOM LETTERS LAYER
                                  const Expanded(flex: 1, child: SizedBox()),
                                  RandomLetters(tileSize: MediaQuery.of(context).size.width *0.2, settingsState: settingsState,),
                                  
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  // Expanded(child: SizedBox()),
                                  const Board(),
                                  const ReserveTiles(),
                                  // Stack(
                                  //   children: [
                                  //     Center(
                                  //       child: SizedBox(
                                  //         // height:(MediaQuery.of(context).size.width ) * settingsState.sizeFactor,
                                  //         width:(MediaQuery.of(context).size.width ) * settingsState.sizeFactor, //330,
                                  //         child: Wrap(
                                  //           direction: Axis.horizontal,
                                  //           alignment: WrapAlignment.center,
                                  //           children: [
                                  //             for (int i = 0; i < 36; i ++ )
                                  //             Padding(
                                  //               padding: const EdgeInsets.all(1.0),
                                  //               child: SizedBox(
                                  //                 width: ((MediaQuery.of(context).size.width ) / 7) * settingsState.sizeFactor ,
                                  //                 height: ((MediaQuery.of(context).size.width ) / 7) * settingsState.sizeFactor,
                                  //                 child: GestureDetector(
                                  //                   onTapUp: (details) {
                                  //                     animationState.setShouldRunTilePressedAnimation(false);
                                  //                     gamePlayState.setIsTiletapped(null);
                                                      
                                  //                     GameLogic().pressTile(context,i,gamePlayState,_audioController); 
                                                      
                                  //                   },
              
                                  //                   onTapCancel: () {
                                  //                     animationState.setShouldRunTilePressedAnimation(false);
                                  //                     gamePlayState.setIsTiletapped(null);
                                  //                     gamePlayState.setPressedTile("");
                                  //                   },
                                  //                   onTapDown: (details) {
                                  //                     animationState.setShouldRunTilePressedAnimation(true);
                                  //                     gamePlayState.setIsTiletapped(i);
                                  //                     gamePlayState.setPressedTile(tileKeys[i]);
                                  //                     animationState.setShouldRunTilePressedAnimation(false);
                                  //                     gamePlayState.setIsTiletapped(null);
                                  //                   },
                                  //                   child: Stack(
                                  //                     children: [
                                  //                       Tile(
                                  //                         // row: i + 1,
                                  //                         // column: j + 1,
                                  //                         index: i,
                                  //                         tileSize: ((MediaQuery.of(context).size.width )/7) * settingsState.sizeFactor,
                                  //                       ),
                                  //                       DragTarget(
                                  //                         onAcceptWithDetails: (details) {
                                  //                           // GameLogic().dropTile(context,i + 1,j + 1,gamePlayState,_audioController);
                                  //                           GameLogic().dropTile(context,i,gamePlayState,_audioController);
                                  //                         }, 
                                  //                         builder: (BuildContext context, List<dynamic> accepted, List<dynamic> rejected) {
                                  //                           // return const DraggableTile(tileState: {});
                                  //                           return SizedBox();
                                  //                           // return draggedTile(
                                  //                             // draggedSpot.isEmpty ? "" : "", 
                                  //                             // Colors.transparent, 
                                  //                             // ((MediaQuery.of(context).size.width)  / 7) * settingsState.sizeFactor );
                                  //                       })                                                     
                                  //                     ]
                                  //                   ),
                                  //                 ),
                                  //               ),
                                  //             )
                                  //           ],
                                  //         )
                                  //       ),
                                  //     ),
                                  //     const NewPointsAnimation()
                                  //   ],
                                  // ),
                                  // // SizedBox(
                                  // //   height: (10 * settingsState.sizeFactor),
                                  // // ),
                                  // // const SizedBox(height: 15,),
                                  // Consumer<GamePlayState>(
                                  //   builder: (context, gamePlayState, child) {
                                  //     return FittedBox(
                                  //       fit: BoxFit.scaleDown,
                                  //       child: SizedBox(
                                  //         width: MediaQuery.of(context).size.width * settingsState.sizeFactor,
                                  //         child: Padding(
                                  //           padding: const EdgeInsets.all(0.0),
                                  //           child: Row(
                                  //             mainAxisAlignment: MainAxisAlignment.center,
                                  //             children: [
                                  //               for (Map<String, dynamic> reserveLetter in gamePlayState.reserveTiles)
                                  //                 Stack(
                                  //                   children: [
                                  //                     Draggable(
                                  //                       data: reserveLetter["body"] == "" ? const SizedBox() : draggedTile(reserveLetter["body"],Colors.red, 0), // draggedTile(reserveLetter["body"], Colors.red),
                                  //                       feedback: reserveLetter["body"] =="" ? const SizedBox() : DraggableTile(tileState:reserveLetter), // draggedTile(reserveLetter["body"], const Color.fromARGB(255, 73, 54, 244)),
                                  //                       childWhenDragging:
                                  //                           reserveLetter["body"] == ""
                                  //                               ? DraggableTile(tileState:reserveLetter)
                                  //                               : DraggableTile(tileState: {"id":reserveLetter["id"],"body": ""}),
                                  //                       child: DraggableTile(tileState:reserveLetter), //draggedTile(reserveLetter["body"], Colors.black),
                                        
                                  //                       onDragStarted: () {
                                  //                         if (reserveLetter['body'] =="") {
                                  //                           GameLogic().placeIntoReserves(context,gamePlayState,reserveLetter);
                                  //                         } else {
                                  //                           gamePlayState.setDraggedReserveTile(reserveLetter);
                                  //                         }
                                  //                       },
                                  //                       onDragEnd: (details) {
                                  //                         gamePlayState.setDraggedReserveTile({});
                                  //                       },
                                  //                     ),
                                  //                     // DraggableTile(tileState: reserveLetter),
                                  //                   ],
                                  //                 )
                                  //             ],
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     );
                                  //   },
                                  // )
                                ],
                              ),
                            ),
                          ),
                        ),
              
                        bottomNavigationBar: Container(
                          color: palette.screenBackgroundColor,
                          
                          child: Padding(
                            
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              width: double.infinity,
                              height: (40 * settingsState.sizeFactor),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                                color: palette.optionButtonBgColor2,
                              ),
                              child: IconButton(
                                onPressed: () {
                                  gamePlayState.setIsGamePaused(true, 0);
                                },
                                icon: const Icon(Icons.pause_circle_outline),
                                color: palette.tileBgColor,
                                iconSize: (22 * settingsState.sizeFactor),
                              ),
                            ),
                          ),
                        ),
                        // bottomNavigationBar: const BannerAdWidget(),
                      ),
                    ),
                    // gamePlayState.isGameStarted && gamePlayState.isGamePaused ? const PauseOverlay() : const SizedBox(),
                    const PauseOverlay(),
              
                    const GameOverOverlay(),
                    // const GameOverOverlay(),
                    // const LevelChangeOverlay(),
              
                    const PreGameOverlay(),
                    // const PreGameOverlay(),
                  ],
                ),
              );
            },
          );
  }
}

Widget draggedTile(String letter, Color color, double tileSize) {
  return Container(
    width: tileSize,
    height: tileSize,
    color: color,
    child: Center(
      child: Text(
        letter,
        style: const TextStyle(fontSize: 22, color: Colors.white),
      ),
    ),
  );
}

// void dropTile(String letter, int row, int column) {
//   print("dropped $letter in row ${row}_$column ");

// }
