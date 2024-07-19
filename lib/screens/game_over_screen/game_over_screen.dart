import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/audio/audio_controller.dart';
import 'package:scribby_flutter_v2/audio/sounds.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/resources/auth_service.dart';
import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
import 'package:scribby_flutter_v2/screens/game_over_screen/components/game_over_score_widget.dart';
import 'package:scribby_flutter_v2/screens/game_over_screen/components/game_over_screen_overlay.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/play_area/decorations/decorations.dart';
import 'package:scribby_flutter_v2/screens/menu_screen/menu_screen.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';
import 'package:scribby_flutter_v2/styles/confetti.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class GameOverScreen extends StatefulWidget {
  const GameOverScreen({super.key});

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  // late final InterstitialAd _interstitialAd;
  late bool isLoading = false;
  late int adsLoaded = 0;
  late int adsDismissed = 0;

  // late bool showConfetti = false;

  late AnimationState _animationState;

  late bool isConnected = true;

  final adUnitId = Platform.isAndroid
      // ? 'ca-app-pub-2459167095237263/4958251976' // prod
      ? 'ca-app-pub-3940256099942544/1033173712' // test

      // : 'ca-app-pub-2459167095237263/7967558693'; // prod
      : 'ca-app-pub-3940256099942544/4411468910'; // test

  /// Loads an interstitial ad.

  @override
  void initState() {
    super.initState();
    _animationState = Provider.of<AnimationState>(context, listen: false);

      getIsConnected();

      loadAd(_animationState);


  }

  void loadAd(AnimationState animationState) {
    setState(() {
      isLoading = true;
    });
    try {
      InterstitialAd.load(
          adUnitId: adUnitId,
          request: const AdRequest(),
          adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (InterstitialAd ad) {

              setState(() {
                adsLoaded = adsLoaded + 1;
              });              
              setFullScreenContentCallback(ad, animationState);
              ad.show();
              // debugPrint('ad #${adsLoaded} loaded.');
            },
            // Called when an ad request failed.
            onAdFailedToLoad: (LoadAdError error) {
              setState(() {
                isLoading = false;
              });
              // debugPrint('InterstitialAd failed to load: $error');
            },
          ));
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void setFullScreenContentCallback(InterstitialAd ad, AnimationState animationState,) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
        // Called when the ad showed the full screen content.
        onAdShowedFullScreenContent: (ad) {
          setState(() {
            isLoading = false;
          });
        },
        // Called when an impression occurs on the ad.
        onAdImpression: (ad) {},
        // Called when the ad failed to show full screen content.
        onAdFailedToShowFullScreenContent: (ad, err) {
          // Dispose the ad here to free resources.
          ad.dispose();

        },
        // Called when the ad dismissed full screen content.
        onAdDismissedFullScreenContent: (ad) {
          setState(() {
            adsDismissed = adsDismissed + 1;
          });
          // Dispose the ad here to free resources.
          ad.dispose();
          if (adsLoaded == adsDismissed) {
            validateHighScore(animationState);
          }
        },
        // Called when a click is recorded for an ad.
        onAdClicked: (ad) {});
  }

  void validateHighScore(AnimationState animationState) {
    animationState.setShouldRunGameOverPointsCounting(true);
  }

  int currentHighScore(SettingsState settings, ColorPalette palette, int currentScore) {
    String currentLanguage = settings.userData['parameters']['currentLanguage'];
    late int currentHighScore = 0;
    if (settings.userData['highScores'][currentLanguage] != null) {
      currentHighScore = settings.userData['highScores'][currentLanguage];
    }
    return currentHighScore;
  }   

  bool newHighScore(SettingsState settings, ColorPalette palette, int currentScore) {
    int highScore = currentHighScore(settings, palette, currentScore);
    return  currentScore > highScore ;
  } 

  Future<void> getIsConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    final bool _isConnected = connectivityResult[0] != ConnectivityResult.none;
    setState(() {
      isConnected = _isConnected;
    });
  }

  @override
  Widget build(BuildContext context) {
    late ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
    late SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);
    late GamePlayState gamePlayState = Provider.of<GamePlayState>(context, listen: false);
    late SettingsController settings = Provider.of<SettingsController>(context, listen: false);
    late AnimationState animationState = Provider.of<AnimationState>(context, listen: false);

    final AudioController audioController =Provider.of<AudioController>(context, listen: false);
    
    double maxScreenWidth = Helpers().getScreenWidth(MediaQuery.of(context).size.width,1);

    final double screenWidth = settingsState.screenSizeData['width'];
    final double screenHeight = settingsState.screenSizeData['height'];
    final List<Map<String,dynamic>> decorationDetails = gamePlayState.decorationData;     

    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : PopScope(
            canPop: false,
            child: SafeArea(
              child: Scaffold(
                body: Stack(children: [
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
                  Container(
                    width: double.infinity,
                    // color: palette.screenBackgroundColor,
                    child: Align(
                      alignment: Alignment.center,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: maxScreenWidth
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 18.0),
                          child: Consumer<GamePlayState>(
                            builder: (context, gamePlayState, child) {
                              return Column(
                               children: [
                              // Expanded(
                              //   flex: 2,
                              //   child: Container(
                              //     width: double.infinity,
                              //     height: double.infinity,
                              //     color: Colors.orange,
                              //     child: SizedBox()
                              //   ),
                              // ),
                              Expanded(child: SizedBox(),),
                              Flexible(
                                flex: 3,
                                child: ScoreWidget(
                                  score: gamePlayState.endOfGameData['points'], 
                                  newHs: newHighScore(settingsState, palette, gamePlayState.endOfGameData['points']),
                                  highScore: currentHighScore(settingsState, palette, gamePlayState.endOfGameData['points']),
                                )
                              ),
                              // Expanded(
                              //   flex: 1,
                              //   child: Container(
                              //     width: double.infinity,
                              //     height: double.infinity,
                              //     color: Colors.orange,
                              //     child: SizedBox()
                              //   ),
                              // ),
                              Flexible(
                                flex: 6,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      gamePlayState.tileSize*0.25, 
                                      gamePlayState.tileSize*0.10, 
                                      gamePlayState.tileSize*0.45, 
                                      gamePlayState.tileSize*0.10,
                                    ),
                                  child: Table(
                                    // border: TableBorder.all(),
                                    columnWidths: const <int, TableColumnWidth>{
                                      0: FlexColumnWidth(1),
                                      1: FlexColumnWidth(3),
                                      2: FlexColumnWidth(2),
                                    },
                                    defaultVerticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    children: <TableRow>[
                                      rowStatItem(
                                          Helpers().translateText(gamePlayState.currentLanguage, "Points",settingsState),
                                          gamePlayState.endOfGameData['points'].toString(),
                                          Icon(Icons.emoji_events,size: gamePlayState.tileSize*0.35, color: palette.textColor3),
                                          palette, gamePlayState.tileSize*0.35),
                                      rowStatItem(
                                          Helpers().translateText(gamePlayState.currentLanguage, "Words",settingsState),
                                          gamePlayState.endOfGameData['uniqueWords'].toString(),
                                          Icon(Icons.library_books,size: gamePlayState.tileSize*0.35, color: palette.textColor3),
                                          palette, gamePlayState.tileSize*0.35),
                                      rowStatItem(
                                          Helpers().translateText(gamePlayState.currentLanguage, "Turns",settingsState),
                                          "134",// gamePlayState.endOfGameData['turns'].toString(),
                                          Icon(Icons.touch_app,size: gamePlayState.tileSize*0.35, color: palette.textColor3),
                                          palette, gamePlayState.tileSize*0.35),                                                                                                                          
                                      rowStatItem(
                                          Helpers().translateText(gamePlayState.currentLanguage, "Duration",settingsState),
                                          Helpers().formatTime(gamePlayState.endOfGameData['duration']),
                                          Icon(Icons.timer,size: gamePlayState.tileSize*0.35, color: palette.textColor3),
                                          palette, gamePlayState.tileSize*0.35),
                                      rowStatItem(
                                          Helpers().translateText(gamePlayState.currentLanguage, "Level",settingsState),
                                          gamePlayState.endOfGameData['level'].toString(),
                                          Icon(Icons.bar_chart_rounded,size: gamePlayState.tileSize*0.35, color: palette.textColor3),
                                          palette,
                                          gamePlayState.tileSize*0.35),
                                      rowStatItem(
                                          Helpers().translateText(gamePlayState.currentLanguage, "Longest Streak",settingsState),
                                          gamePlayState.endOfGameData['longestStreak'].toString(),
                                          Icon(Icons.electric_bolt,size: gamePlayState.tileSize*0.35, color: palette.textColor3),
                                          palette,
                                          gamePlayState.tileSize*0.35),
                                      rowStatItem(
                                          Helpers().translateText(gamePlayState.currentLanguage, "Cross Words",settingsState),
                                          gamePlayState.endOfGameData['crossWords'].toString(),
                                          Icon(Icons.close,size: gamePlayState.tileSize*0.35, color: palette.textColor3),
                                          palette,
                                          gamePlayState.tileSize*0.35),
                                      rowStatItem(
                                          Helpers().translateText(gamePlayState.currentLanguage, "Most Points",settingsState),
                                          gamePlayState.endOfGameData['mostPoints'].toString(),
                                          Icon(Icons.star,size: gamePlayState.tileSize*0.35, color: palette.textColor3),
                                          palette,
                                          gamePlayState.tileSize*0.35),
                                      rowStatItem(
                                          Helpers().translateText(gamePlayState.currentLanguage, "Most Words",settingsState),
                                          gamePlayState.endOfGameData['mostWords'].toString(),
                                          Icon(Icons.my_library_books_sharp,size: gamePlayState.tileSize*0.35, color: palette.textColor3),
                                          palette,
                                          gamePlayState.tileSize*0.35),
                                    ],
                                  ),
                                ),
                              ),
                              // const Expanded(child: SizedBox()),
                              // const Expanded(
                              //   flex: 2,
                              //   child: SizedBox(),
                              // ),
                              Expanded(child: SizedBox()),
                              Flexible(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    animationState.setShouldShowGameOverScreenOverlay(true);
                                  },
                                  child: Text(
                                    Helpers().translateText(gamePlayState.currentLanguage, "View points summary",settingsState),
                                    style: TextStyle(
                                      color: palette.textColor2,
                                      fontSize: gamePlayState.tileSize*0.3,
                                      decoration: TextDecoration.underline
                                    ),
                                  ),
                                ),
                              ),
                              // const Expanded(
                              //   flex: 2,
                              //   child: SizedBox(),
                              // ),
                              Expanded(child: SizedBox()),
                              if (!isConnected) Flexible(
                                flex: 2,
                                child: GestureDetector(
                                  onTap: () {
                                    audioController.playSfx(SfxType.optionSelected);
                                    gamePlayState.endGame();
                                    gamePlayState.setTileState(settings.initialTileState.value as List<Map<String,dynamic>>);
                                    FirestoreMethods().updateSettingsState( settingsState, AuthService().currentUser!.uid);
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => const MenuScreen()
                                      )
                                    );
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: gamePlayState.tileSize*0.8,
                                    decoration: Decorations().getTileDecoration(gamePlayState.tileSize, palette, 2, 2),
                                      child: Center(
                                        child: Text(
                                          Helpers().translateText(gamePlayState.currentLanguage, "Main Menu",settingsState),
                                          style: TextStyle(
                                            color: palette.fullTileTextColor,
                                            fontSize: gamePlayState.tileSize*0.4,
                                          ),
                                        ),
                                      ),                                        
                                  ),
                                ),
                              ) else Flexible(
                                flex: 1,
                                child: Consumer<AnimationState>(
                                  builder: (context, animationState, child) {
                                    return AnimatedOpacity(
                                      duration: const Duration(milliseconds: 500),
                                      opacity: animationState.shouldRunGameOverPointsFinishedCounting ? 1.0 : 1.0,
                                      child: GestureDetector(
                                        onTap: () {
                                          animationState.setShouldRunGameOverPointsCounting(false);
                                          animationState.setShouldRunGameOverPointsFinishedCounting(false);
                                          audioController.stopLoopSfx();
                                          audioController.playSfx(SfxType.optionSelected);
                                          gamePlayState.endGame();
                                          gamePlayState.setTileState(settings.initialTileState.value as List<Map<String,dynamic>>);
                                          animationState.setShouldRunGameOverPointsFinishedCounting(false);
                                          FirestoreMethods().updateSettingsState( settingsState, AuthService().currentUser!.uid);
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                const MenuScreen()
                                            )
                                          );
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          height: gamePlayState.tileSize*0.8,
                                          decoration: Decorations().getTileDecoration(gamePlayState.tileSize, palette, 2, 2),
                                            child: Center(
                                              child: Text(
                                                Helpers().translateText(gamePlayState.currentLanguage, "Main Menu",settingsState),
                                                style: TextStyle(
                                                  color: palette.fullTileTextColor,
                                                  fontSize: gamePlayState.tileSize*0.4,
                                                ),
                                              ),
                                            ),                                        
                                        ),
                                      ),
                                    );
                                  }
                                ),
                              ),
                              // const Expanded(
                              //   flex: 1,
                              //   child: SizedBox(),
                              // ),                        
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  GameOverScreenOverlay(),
                  Consumer<AnimationState>(
                    builder: (context, animationState, child) {
                      return SizedBox.expand(
                        child: Visibility(
                          visible: animationState.shouldRunNewHighScore,
                          child: IgnorePointer(
                            child: Confetti(
                              palette: palette,
                              isStopped: !animationState.shouldRunNewHighScore,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ]),
              ),
            ),
          );
  }
}

TableRow rowStatItem(String text, String data, Icon icon, ColorPalette palette, double fontSize) {
  return TableRow(children: <Widget>[
    Center(child: icon),
    FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(fontSize: fontSize, color: palette.textColor3),
      ),
    ),
    Align(
      alignment: Alignment.centerRight,
      child: Text(
        data.toString(),
        style: TextStyle(fontSize: fontSize, color: palette.textColor3),
      ),
    ),
  ]);
}


