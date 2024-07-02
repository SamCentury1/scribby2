import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/audio/audio_controller.dart';
import 'package:scribby_flutter_v2/audio/sounds.dart';
import 'package:scribby_flutter_v2/functions/game_logic_2.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/screens/game_over_screen/game_over_screen.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/overlays/game_over_overlay.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/overlays/game_pause_overlay.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/overlays/game_start_overlay.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/play_area/decorations/board_animation.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/play_area/decorations/bonus_items.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/play_area/decorations/decorations.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/play_area/game_board.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/scoreboard/scoreboard.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/top_layer/top_layer.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> with TickerProviderStateMixin{

  late AnimationState animationState;
  late GamePlayState gamePlayState;
  // late double buttonOpacity;
  late double tileSize = 0.0;

  late AnimationController gameStartedController;
  late AnimationController gameEndedController;
  late AnimationController wordFoundController;
  late AnimationController clockController;
  late AnimationController streakController;
  late AnimationController streakOutController;
  late AnimationController levelUpController;
  late AnimationController tileTappedController2;

  late Animation<double> gameStartedOpacityAnimation;
  late Animation<double> gameEndedOpacityAnimation;
  late Animation<double> gameStartedOverlayAnimation;
  // late bool startAnimationCompleted;
  late double wordControllerValueWhenPaused;
  
  late Animation<double> multiWordPositionAnimation;
  late Animation<double> crossWordPositionAnimation;

  late AudioController _audioController;
  
  
  @override
  void initState() {
    super.initState();
    animationState = Provider.of<AnimationState>(context, listen: false);
    gamePlayState =  Provider.of<GamePlayState>(context, listen: false);
    _audioController = Provider.of<AudioController>(context, listen: false);
    initializeAnimations();
    animationState.addListener(handleAnimationStateChange);
    wordControllerValueWhenPaused = 0.0;
  }

  void initializeAnimations() {
    gameStartedController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync:this
    );

    List<TweenSequenceItem<double>> gameStartedOpacitySequence = [
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.0,), weight: 90),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0,), weight: 10),
    ];
    gameStartedOpacityAnimation = TweenSequence<double>(gameStartedOpacitySequence)
    .animate(gameStartedController);      

    gameStartedOpacityAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationState.setShouldRunGameStartedAnimation(false);
        gamePlayState.startTimer();
        gamePlayState.setDidShowStartAnimation(true);

        // if (gamePlayState.isGameOver) {
        //   GameLogic().executeGameOver(gamePlayState, context);
        //   // Navigator.of(context).pushReplacement(
        //   //   MaterialPageRoute(builder: (context) => GameOverScreen() )
        //   // );
        // }
      }
    });
    List<TweenSequenceItem<double>> gameStartedOverlaySequence = [
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0,), weight: 10),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.0,), weight: 90),
    ];
    gameStartedOverlayAnimation = TweenSequence<double>(gameStartedOverlaySequence).animate(gameStartedController);  

    tileTappedController2 = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this
    );






    const int duration = 2500;
    wordFoundController = AnimationController(
      duration: Duration(milliseconds: duration),
      vsync:this
    );

    wordFoundController.addListener(() {
      // bool wasStopped = false;
      if (wordFoundController.isAnimating) {
        // print(gamePlayState.selectedTileIndex);
        if (gamePlayState.selectedTileIndex > -1 || gamePlayState.selectedReserveIndex > -1) {
          if (animationState.shouldRunTileTappedAnimation) {
            // wordFoundController.stop();
            wordFoundController.forward(from: 1.0);
          }
        }

        if (gamePlayState.isGamePaused) {       
          wordFoundController.forward(from: 1.0);
          // wordFoundController.value;
          // gamePlayState.countDownController.pause();

        }
      }
      if (wordFoundController.isCompleted) {
        // print("okay it's complete");
        // wordFoundController.forward(from: 1.0);
        GameLogic().wordFoundAnimationCompletedBehavior(gamePlayState, animationState);
        animationState.setShouldRunTimerAnimation(true);
      }
    });

              


    clockController = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync:this
    );

    streakController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync:this
    );

    streakOutController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync:this
    );

    levelUpController = AnimationController(
      duration: const Duration(milliseconds: 3500),
      vsync:this
    );



    gameEndedController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync:this
    );

    List<TweenSequenceItem<double>> gameEndedOpacitySequence = [
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.0,), weight: 90),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0,), weight: 10),
    ];
    gameEndedOpacityAnimation = TweenSequence<double>(gameEndedOpacitySequence)
    .animate(gameEndedController);      


    

  }

  void handleAnimationStateChange() {
    if (animationState.shouldRunGameStartedAnimation) {
      executeGameStartedAnimation();
    }
    if (animationState.shouldRunClockAnimation) {
      runClockAnimation();
    }
    if (animationState.shouldRunStreakInAnimation) {
      runStreakInAnimation();
    }
    if (animationState.shouldRunStreakOutAnimation) {
      runStreakOutAnimation();
    }    
    if (animationState.shouldRunLevelUpAnimation) {
      runLevelUpAnimation();
    }
    if (animationState.shouldRunGameEndedAnimation) {
      executeGameEndedAnimation();
    }    
  }


  void runClockAnimation() {
    clockController.reset();
    clockController.forward();
  }  

  void executeGameStartedAnimation() {
    gameStartedController.reset();
    gameStartedController.forward();

    _audioController.playSfx(SfxType.startGame);

  }

  void runStreakInAnimation() {
    streakController.reset();
    streakController.forward();
  }

  void runStreakOutAnimation() {
    streakOutController.reset();
    streakOutController.forward();
  }  

  void runLevelUpAnimation() {
    levelUpController.reset();
    levelUpController.forward();
  }

  void executeGameEndedAnimation() {
    gameEndedController.reset();
    gameEndedController.forward();
    _audioController.playSfx(SfxType.finishGame);
    // GameLogic().executeGameOver(gamePlayState,context);
    gamePlayState.setIsGameOver(true); 
    Future.delayed(const Duration(milliseconds: 2500), () {
      
      animationState.setShouldRunGameEndedAnimation(false);
      Helpers().clearTilesFromBoard(gamePlayState);
      //  gamePlayState.endGame();
       if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const GameOverScreen())
        );
       }

    });
  }


  @override
  void dispose() { 
    super.dispose();
  }  
  
  @override
  Widget build(BuildContext context) {
    return Consumer<GamePlayState>(
      builder: (BuildContext context, GamePlayState gamePlayState, Widget? child) {
        final SettingsState settingsState =Provider.of<SettingsState>(context, listen: false);        
        final ColorPalette palette =Provider.of<ColorPalette>(context, listen: false);
        final double screenWidth = settingsState.screenSizeData['width'];
        final double screenHeight = settingsState.screenSizeData['height'];
        final double tileSize = gamePlayState.tileSize;
        final List<Map<String,dynamic>> decorationDetails = gamePlayState.decorationData;

        return PopScope(
          canPop: false,
          child: SafeArea(
              child: Stack(
                children: [

                  CustomPaint(size: Size(screenWidth, screenHeight), painter: CustomBackground(palette: palette)),
                
                  Decorations().decorativeSquare(decorationDetails[0]),
                  Decorations().decorativeSquare(decorationDetails[1]),
                  Decorations().decorativeSquare(decorationDetails[2]),
                  Decorations().decorativeSquare(decorationDetails[3]),
                  Decorations().decorativeSquare(decorationDetails[4]),
                  Decorations().decorativeSquare(decorationDetails[5]),
                  Decorations().decorativeSquare(decorationDetails[6]),
                  Decorations().decorativeSquare(decorationDetails[7]),
                  Decorations().decorativeSquare(decorationDetails[8]),
                  Decorations().decorativeSquare(decorationDetails[9]),
                  Decorations().decorativeSquare(decorationDetails[10]),


                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: screenWidth,
                      height: screenHeight,
                      child: Scaffold(
                        backgroundColor: Colors.transparent,
                        body: AnimatedBuilder(
                          animation: gameStartedController,
                          builder: (context,child) {
                            return Center(
                              child: Column(
                                children: [
                                  TopLayer(
                                    gameStartedAnimation: gameStartedOpacityAnimation,
                                    clockController: clockController,
                                  ),
                                  Scoreboard(
                                    wordFoundController: wordFoundController, 
                                    gameStartedController: gameStartedController, 
                                    gameStartedOpacityAnimation: gameStartedOpacityAnimation
                                  ),
                        
                                  /// BONUS ITEMS + LEVEL UP
                                  BonusItems(
                                    wordFoundController: wordFoundController,
                                    streakController: streakController,
                                    streakOutController: streakOutController,
                                    levelUpController: levelUpController,
                                  ),
                        
                                  Spacer(flex: 1,),
                        
                                  /// GAME PLAY AREA                       
                                  Consumer<AnimationState>(
                                    builder: (context, animationState, child) {
                                      if (!gamePlayState.isGameStarted || gameStartedController.isAnimating) {
                                        return Container(
                                          height: (tileSize*9).roundToDouble(),
                                          width: (tileSize*6).roundToDouble(),
                                          child: BoardAnimation(gameStartedController: gameStartedController),
                                        );                                    
                                      } else if (gameEndedController.isAnimating || gamePlayState.isGameOver) {
                                        return Container(
                                          height: (tileSize*9).roundToDouble(),
                                          width: (tileSize*6).roundToDouble(),
                                          child: BoardAnimation(gameStartedController: gameEndedController),
                                        );
                                      } else {
                                        return Container(
                                          height: (tileSize*9).roundToDouble(),
                                          width: (tileSize*6).roundToDouble(),
                                          child: GameBoard(wordFoundController: wordFoundController,),
                                        );
                                      }  
                                    }
                                  ),
                                  Spacer(flex: 1,),
                        
                                ],
                              ),
                            );
                          },
                        ),
                        bottomNavigationBar: Container(

                          width: double.infinity,
                          color: Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (!animationState.shouldRunTileTappedAnimation) {
                                    gamePlayState.setIsGamePaused(true);
                                    gamePlayState.setPauseScreen('summary');
                                  }                                  
                                }, 
                                icon: Icon(Icons.emoji_events,size: tileSize*0.4, color: palette.textColor3.withOpacity(0.5),),
                              ),
                              IconButton(
                                onPressed: () {
                                  if (!animationState.shouldRunTileTappedAnimation) {
                                    gamePlayState.setIsGamePaused(true);
                                    gamePlayState.setPauseScreen('help');
                                  }                                  
                                }, 
                                icon: Icon(Icons.help,size: tileSize*0.4, color: palette.textColor3.withOpacity(0.5),),
                              ),
                              IconButton(
                                onPressed: () {
                                  if (!animationState.shouldRunTileTappedAnimation) {
                                    gamePlayState.setIsGamePaused(true);
                                    gamePlayState.setPauseScreen('settings');
                                  }                                  
                                }, 
                                icon: Icon(Icons.settings,size: tileSize*0.4, color: palette.textColor3.withOpacity(0.5),),
                              ),
                              IconButton(
                                onPressed: () {
                                  if (!animationState.shouldRunTileTappedAnimation) {
                                    gamePlayState.setIsGamePaused(true);
                                    gamePlayState.setPauseScreen('quit');
                                  }                                  
                                }, 
                                icon: Icon(Icons.exit_to_app,size: tileSize*0.4, color: palette.textColor3.withOpacity(0.5),),
                              ),                                                                                          
                            ],
                          ),
                        ),
                      )
                    )
                  ),

                  GameStartOverlay(
                    gameStartedController: gameStartedController, 
                    gameStartedAnimation: gameStartedOverlayAnimation,
                  ),


                  GamePauseOverlay(),
                  GameOverOverlay(),
                ],
              ),
            // ),
          )
        );
      },
    );
  }
}

