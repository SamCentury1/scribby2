// import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:scribby_flutter_v2/ads/ads_controller.dart';
// import 'package:scribby_flutter_v2/ads/banner_ad_widget.dart';
import 'package:scribby_flutter_v2/audio/audio_controller.dart';
// import 'package:scribby_flutter_v2/audio/sounds.dart';
import 'package:scribby_flutter_v2/components/bonus_score_elements.dart';
import 'package:scribby_flutter_v2/components/draggable_tile.dart';
import 'package:scribby_flutter_v2/components/game_over_overlay.dart';
// import 'package:scribby_flutter_v2/components/level_change_overlay.dart';
import 'package:scribby_flutter_v2/components/new_points_animation.dart';
import 'package:scribby_flutter_v2/components/pause_overlay.dart';
import 'package:scribby_flutter_v2/components/pre_game_overlay.dart';
import 'package:scribby_flutter_v2/components/random_letters.dart';
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
  late GamePlayState _gamePlayState;
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
    // _gameState = Provider.of<GameState>(context, listen: false);
    _gamePlayState = Provider.of<GamePlayState>(context, listen: false);
    // _animationState = Provider.of<AnimationState>(context, listen: false);
    // _settings = Provider.of<SettingsController>(context, listen: false);

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   getStates(_gamePlayState, _settings);
    // });

    // getStatesFromDatabase(_gamePlayState, _settings);

    // List<Map<String,dynamic>> startingAlphabetState = GameLogic().generateStartingStates(_alphabetData, initialBoardState, [],_gamePlayState)['startingAlphabet'];
    // _gamePlayState.setAlphabetState(startingAlphabetState);

    // List<String> randomLetterListState = GameLogic().generateStartingStates(_alphabetData, initialBoardState, [],_gamePlayState)['startingRandomLetterList'];
    // _gamePlayState.setRandomLetterList(randomLetterListState);

    // List<Map<String,dynamic>> startingTileState = GameLogic().generateStartingStates(_alphabetData, initialBoardState, [],_gamePlayState)['startingTileState'];
    // _gamePlayState.setVisualTileState(startingTileState);

    // _gamePlayState.set

    // GameLogic().removeStartGameOverlay(_gamePlayState);
  }

  // Future<void> getStatesFromDatabase(
  //     GamePlayState gamePlayState, SettingsController settings) async {
  //   setState(() {
  //     isLoading = true;
  //   });

  //   // final List<dynamic> alphabet = await FirestoreMethods().getAlphabet(AuthService().currentUser!.uid);
  //   final Map<String, dynamic> alphabetDocumnet =
  //       (settings.alphabet.value as Map<String, dynamic>);
  //   final List<dynamic> alphabet = alphabetDocumnet['alphabet'];

  //   if (alphabet.isNotEmpty) {
  //     late List<Map<String, dynamic>> startingAlphabetState = GameLogic()
  //         .generateStartingStates(
  //             alphabet, initialBoardState, [])['startingAlphabet'];
  //     late List<String> randomLetterListState = GameLogic()
  //         .generateStartingStates(
  //             alphabet, initialBoardState, [])['startingRandomLetterList'];
  //     late List<Map<String, dynamic>> startingTileState = GameLogic()
  //         .generateStartingStates(
  //             alphabet, initialBoardState, [])['startingTileState'];

  //     gamePlayState.setAlphabetState(startingAlphabetState);
  //     gamePlayState.setRandomLetterList(randomLetterListState);
  //     gamePlayState.setVisualTileState(startingTileState);

  //     setState(() {
  //       isLoading = false;
  //     });
  //   } else {
  //     debugPrint(
  //         "something went wrong retrieving the alphabet from the database");
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  // void getStates(GamePlayState gamePlayState, SettingsController settings) {
  //   final Map<String, dynamic> alphabetDocumnet =
  //       (settings.alphabet.value as Map<String, dynamic>);
  //   final List<dynamic> alphabet = alphabetDocumnet['alphabet'];

  //   if (alphabet.isNotEmpty) {
  //     late List<Map<String, dynamic>> startingAlphabetState = GameLogic()
  //         .generateStartingStates(
  //             alphabet, initialBoardState, [])['startingAlphabet'];
  //     late List<String> randomLetterListState = GameLogic()
  //         .generateStartingStates(
  //             alphabet, initialBoardState, [])['startingRandomLetterList'];
  //     late List<Map<String, dynamic>> startingTileState = GameLogic()
  //         .generateStartingStates(
  //             alphabet, initialBoardState, [])['startingTileState'];

  //     gamePlayState.setAlphabetState(startingAlphabetState);
  //     gamePlayState.setRandomLetterList(randomLetterListState);
  //     gamePlayState.setVisualTileState(startingTileState);

  //   } else {
  //     debugPrint("something went wrong retrieving the alphabet from storage");
  //   }
  // }



  @override
  void dispose() {
    super.dispose();
  }

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

    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : PopScope(
            canPop: false,
            onPopInvoked: (details) {
              _gamePlayState.setIsGamePaused(true, 0);
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
                                  .executeGameOver(_gamePlayState, context);
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
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
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

                              Stack(
                                children: [
                                  Center(
                                    child: SizedBox(
                                      // height:(MediaQuery.of(context).size.width ) * settingsState.sizeFactor,
                                      width:(MediaQuery.of(context).size.width ) * settingsState.sizeFactor, //330,
                                      child: Wrap(
                                        direction: Axis.horizontal,
                                        alignment: WrapAlignment.center,
                                        children: [
                                          for (int i = 0; i < 36; i ++ )
                                          Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: SizedBox(
                                              width: ((MediaQuery.of(context).size.width ) / 7) * settingsState.sizeFactor ,
                                              height: ((MediaQuery.of(context).size.width ) / 7) * settingsState.sizeFactor,
                                              child: GestureDetector(
                                                onTapUp: (details) {
                                                  animationState.setShouldRunTilePressedAnimation(false);
                                                  _gamePlayState.setIsTiletapped(null);
                                                  
                                                   GameLogic().pressTile(context,i,_gamePlayState,_audioController); 
                                                },

                                                onTapCancel: () {
                                                  animationState.setShouldRunTilePressedAnimation(false);
                                                  _gamePlayState.setIsTiletapped(null);
                                                  _gamePlayState.setPressedTile("");
                                                },
                                                onTapDown: (details) {
                                                  animationState.setShouldRunTilePressedAnimation(true);
                                                  _gamePlayState.setIsTiletapped(i);
                                                  _gamePlayState.setPressedTile(tileKeys[i]);
                                                },
                                                child: Stack(
                                                  children: [
                                                    Tile(
                                                      // row: i + 1,
                                                      // column: j + 1,
                                                      index: i,
                                                      tileSize: ((MediaQuery.of(context).size.width )/7) * settingsState.sizeFactor,
                                                    ),
                                                    DragTarget(
                                                      onAccept: (details) {
                                                        // GameLogic().dropTile(context,i + 1,j + 1,_gamePlayState,_audioController);
                                                        GameLogic().dropTile(context,i,_gamePlayState,_audioController);
                                                      }, 
                                                      builder: (BuildContext context, List<dynamic> accepted, List<dynamic> rejected) {
                                                        // return const DraggableTile(tileState: {});
                                                        return draggedTile(
                                                          draggedSpot.isEmpty ? "" : "", 
                                                          Colors.transparent, 
                                                          ((MediaQuery.of(context).size.width)  / 7) * settingsState.sizeFactor );
                                                    })                                                     
                                                  ]
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    ),
                                  ),
                                  const NewPointsAnimation()
                                ],
                              ),
                              // SizedBox(
                              //   height: (10 * settingsState.sizeFactor),
                              // ),
                              // const SizedBox(height: 15,),
                              Consumer<GamePlayState>(
                                builder: (context, gamePlayState, child) {
                                  return FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width * settingsState.sizeFactor,
                                      child: Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            for (Map<String, dynamic> reserveLetter in gamePlayState.reserveTiles)
                                              Stack(
                                                children: [
                                                  Draggable(
                                                    data: reserveLetter["body"] == "" ? const SizedBox() : draggedTile(reserveLetter["body"],Colors.red, 0), // draggedTile(reserveLetter["body"], Colors.red),
                                                    feedback: reserveLetter["body"] =="" ? const SizedBox() : DraggableTile(tileState:reserveLetter), // draggedTile(reserveLetter["body"], const Color.fromARGB(255, 73, 54, 244)),
                                                    childWhenDragging:
                                                        reserveLetter["body"] == ""
                                                            ? DraggableTile(tileState:reserveLetter)
                                                            : DraggableTile(tileState: {"id":reserveLetter["id"],"body": ""}),
                                                    child: DraggableTile(tileState:reserveLetter), //draggedTile(reserveLetter["body"], Colors.black),
                                    
                                                    onDragStarted: () {
                                                      if (reserveLetter['body'] =="") {
                                                        GameLogic().placeIntoReserves(context,gamePlayState,reserveLetter);
                                                      } else {
                                                        gamePlayState.setDraggedReserveTile(reserveLetter);
                                                      }
                                                    },
                                                    onDragEnd: (details) {
                                                      gamePlayState.setDraggedReserveTile({});
                                                    },
                                                  ),
                                                  // DraggableTile(tileState: reserveLetter),
                                                ],
                                              )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ),

                    bottomNavigationBar: Consumer<GamePlayState>(
                      builder: (context, gamePlayState, child) {
                        // final AnimationState animationState = Provider.of<AnimationState>(context, listen: false);
                        return Container(
                          width: double.infinity,
                          height: (40 * settingsState.sizeFactor),
                          color: palette.screenBackgroundColor,
                          child: IconButton(
                            onPressed: () {

                              gamePlayState.setIsGamePaused(true, 0);
                            },
                            icon: const Icon(Icons.pause_circle_outline),
                            color: palette.tileBgColor,
                            iconSize: (22 * settingsState.sizeFactor),
                          ),
                        );
                      },
                    ),
                    // bottomNavigationBar: const BannerAdWidget(),
                  ),
                ),
                // _gamePlayState.isGameStarted && _gamePlayState.isGamePaused ? const PauseOverlay() : const SizedBox(),
                const PauseOverlay(),

                const GameOverOverlay(),
                // const GameOverOverlay(),
                // const LevelChangeOverlay(),

                const PreGameOverlay(),
                // const PreGameOverlay(),
              ],
            ),
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
