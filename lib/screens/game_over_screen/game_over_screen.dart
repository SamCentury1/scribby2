// import 'package:flutter/foundation.dart';
import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/audio/audio_controller.dart';
import 'package:scribby_flutter_v2/audio/sounds.dart';
// import 'package:scribby_flutter_v2/ads/interstitial_ad_widget.dart';
import 'package:scribby_flutter_v2/functions/game_logic.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/resources/auth_service.dart';
import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
import 'package:scribby_flutter_v2/screens/menu_screen/menu_screen.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';
import 'package:scribby_flutter_v2/styles/confetti.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

// import '../../functions/helpers.dart';

class GameOverScreen extends StatefulWidget {
  const GameOverScreen({super.key});

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  // late final InterstitialAd _interstitialAd;
  late bool isLoading = false;
  late bool _duringCelebration = false;

  final adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-3940256099942544/4411468910';

  /// Loads an interstitial ad.

  @override
  void initState() {
    // TO DO: implement initState
    super.initState();

    loadAd();
  }

  void loadAd() {
    setState(() {
      isLoading = true;
    });
    try {
      InterstitialAd.load(
          adUnitId: adUnitId,
          request: const AdRequest(),
          adLoadCallback: InterstitialAdLoadCallback(
            // Called when an ad is successfully received.
            onAdLoaded: (InterstitialAd ad) {
              debugPrint("ad loaded");

              // setState(() {
              //   isLoading = false;
              // });

              setFullScreenContentCallback(ad);
              ad.show();

              debugPrint('$ad loaded.');
            },
            // Called when an ad request failed.
            onAdFailedToLoad: (LoadAdError error) {
              setState(() {
                isLoading = false;
              });
              debugPrint('InterstitialAd failed to load: $error');
            },
          ));
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  void setFullScreenContentCallback(InterstitialAd ad) {
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
          // Dispose the ad here to free resources.
          ad.dispose();
          validateHighScore();
        },
        // Called when a click is recorded for an ad.
        onAdClicked: (ad) {});
  }

  void validateHighScore() {
    // SettingsState settings, ColorPalette palette, int currentScore
    final settings = context.read<SettingsController>();
    final audioController = context.read<AudioController>();
    // final palette = context.read<ColorPalette>();
    final gamePlayState = context.read<GamePlayState>();
    final int currentScore = gamePlayState.endOfGameData['points'];
    final Map<String, dynamic> userData =
        (settings.userData.value as Map<String, dynamic>);

    String currentLanguage = userData['parameters']['currentLanguage'];
    late int currentHighScore = 0;
    if (userData['highScores'][currentLanguage] != null) {
      currentHighScore = userData['highScores'][currentLanguage];
    }

    if (currentScore > currentHighScore) {
      audioController.playSfx(SfxType.highScore);
      setState(() {
        _duringCelebration = true;

      });

      Future.delayed(const Duration(milliseconds: 2000), () {
        setState(() {
          _duringCelebration = false;
        });
      });
    }
  }

  // int getCurrentHighScore(SettingsState settings) {
  //   final String currentLanguage =
  //       settings.userData['parameters']['currentLanguage'];
  //   final int currentHighScore =
  //       settings.userData['highScores'][currentLanguage] ?? 0;
  //   return currentHighScore;
  // }

  Widget displayScores( SettingsState settings, ColorPalette palette, int currentScore) {
    String currentLanguage = settings.userData['parameters']['currentLanguage'];
    double sizeFactor = settings.sizeFactor;

    late int currentHighScore = 0;
    if (settings.userData['highScores'][currentLanguage] != null) {
      currentHighScore = settings.userData['highScores'][currentLanguage];
    }

    if (currentScore > currentHighScore) {
      return Column(
        children: [
          Row(
            children: [
              const Expanded(flex: 1, child: SizedBox(),),
              Icon(
                Icons.emoji_events,
                size: 36*sizeFactor,
                color: palette.textColor2,
              ),
              const Expanded(flex: 3, child: SizedBox(),),                 
              Column(
                children: [
                  Center(
                    child: SizedBox(
                      child: Text(
                        Helpers().translateText(currentLanguage, "New High Score"),
                        
                        style: TextStyle(fontSize: 32*sizeFactor, color: palette.textColor3),
                      ),
                    ),
                  ),
                  Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        currentScore.toString(),
                        style: TextStyle(color: palette.textColor3, fontSize: 42*sizeFactor),
                      ),
                    ),
                  ),
                ],
              ),
              const Expanded(flex: 1, child: SizedBox(),),
              Icon(
                Icons.emoji_events,
                size: 36*sizeFactor,
                color: palette.textColor2,
              ),
              const Expanded(flex: 3, child: SizedBox(),),                         
            ],
          ),
          SizedBox(
            height: 15*sizeFactor,
          ),
          Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                
                "${Helpers().translateText(currentLanguage, "Previous High Score:")} $currentHighScore",
                style: TextStyle(color: palette.textColor3, fontSize: 24*sizeFactor),
              ),
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Center(
            child: Text(
              // Helpers().translateText(currentLanguage, "Score:")
              "${Helpers().translateText(currentLanguage, "Score")}: ${currentScore.toString()}",
              style: TextStyle(color: palette.textColor3, fontSize: 42*sizeFactor),
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.emoji_events,
                  color: palette.textColor3,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  // Helpers().translateText(currentLanguage, "High Score:")
                  "${Helpers().translateText(currentLanguage, "High Score:")} $currentHighScore",
                  style: TextStyle(color: palette.textColor3, fontSize: 18*sizeFactor),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    late ColorPalette palette =
        Provider.of<ColorPalette>(context, listen: false);
    late GamePlayState gamePlayState =
        Provider.of<GamePlayState>(context, listen: false);
    late SettingsState settingsState =
        Provider.of<SettingsState>(context, listen: false);
        
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : PopScope(
            onPopInvoked: (details) {
              gamePlayState.endGame();
              FirestoreMethods().updateSettingsState(settingsState, AuthService().currentUser!.uid);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const MenuScreen())
              );
            },
            child: Scaffold(
              body: Stack(children: [
                Container(
                  width: double.infinity,
                  color: palette.screenBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 18.0),
                    child: Consumer<GamePlayState>(
                      builder: (context, gamePlayState, child) {
                        late List<Map<String,dynamic>> summary = GameLogic().getPointsSummary(gamePlayState);
                        return SafeArea(
                            child: Column(
                          children: [
                            const Expanded(
                              flex: 2,
                              child: SizedBox(),
                            ),
                            displayScores(settingsState, palette, gamePlayState.endOfGameData['points']),
                            const Expanded(
                              flex: 1,
                              child: SizedBox(),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  16.0, 4.0, 26.0, 4.0),
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
                                      Helpers().translateText(gamePlayState.currentLanguage, "Duration",),
                                      GameLogic().formatTime(gamePlayState
                                          .endOfGameData['duration']),
                                      Icon(Icons.timer,
                                          size: 22*settingsState.sizeFactor, color: palette.textColor3),
                                      palette, settingsState.sizeFactor),
                                  rowStatItem(
                                      Helpers().translateText(gamePlayState.currentLanguage, "Level",),
                                      gamePlayState.endOfGameData['level']
                                          .toString(),
                                      Icon(Icons.bar_chart_rounded,
                                          size: 22*settingsState.sizeFactor, color: palette.textColor3),
                                      palette,
                                      settingsState.sizeFactor),
                                  rowStatItem(
                                      Helpers().translateText(gamePlayState.currentLanguage, "Longest Streak",),
                                      gamePlayState
                                          .endOfGameData['longestStreak']
                                          .toString(),
                                      Icon(Icons.electric_bolt,
                                          size: 22*settingsState.sizeFactor, color: palette.textColor3),
                                      palette,
                                      settingsState.sizeFactor),
                                  rowStatItem(
                                      Helpers().translateText(gamePlayState.currentLanguage, "Cross Words",),
                                      gamePlayState.endOfGameData['crossWords']
                                          .toString(),
                                      Icon(Icons.close,
                                          size: 22*settingsState.sizeFactor, color: palette.textColor3),
                                      palette,
                                      settingsState.sizeFactor),
                                  rowStatItem(
                                      Helpers().translateText(gamePlayState.currentLanguage, "Most Points",),
                                      gamePlayState.endOfGameData['mostPoints']
                                          .toString(),
                                      Icon(Icons.star,
                                          size: 22*settingsState.sizeFactor, color: palette.textColor3),
                                      palette,
                                      settingsState.sizeFactor),
                                  rowStatItem(
                                      Helpers().translateText(gamePlayState.currentLanguage, "Most Words",),
                                      gamePlayState.endOfGameData['mostWords']
                                          .toString(),
                                      Icon(Icons.my_library_books_sharp,
                                          size: 22*settingsState.sizeFactor, color: palette.textColor3),
                                      palette,
                                      settingsState.sizeFactor),
                                ],
                              ),
                            ),
                            const Expanded(child: SizedBox()),
                            const Expanded(
                              flex: 1,
                              child: SizedBox(),
                            ),
                            InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        
                                        insetPadding: const EdgeInsets.all(0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15.0),
                                          child: Container(
                                            width: MediaQuery.of(context).size.width * 0.85,
                                            height: MediaQuery.of(context).size.height * 0.65,
                                            decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                                                color: palette.optionButtonBgColor
                                                // color: Color.fromARGB(125, 71, 65, 65)
                                                ),
                                            child: Column(
                                              children: <Widget>[
                                                // TextButton(onPressed: changeBackToZero, child: Text("change")),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(24.0, 8.0, 4.0, 8.0),
                                                  child: Row(
                                                    children: [
                                                      Align(
                                                        alignment: Alignment.centerLeft,
                                                        child: Text(
                                                          Helpers().translateText(gamePlayState.currentLanguage, "Summary of Points",),
                                                          style: TextStyle(
                                                            fontSize: 24*settingsState.sizeFactor,
                                                            color: palette.textColor2
                                                          ),
                                                        ),
                                                      ),
                                                      const Expanded(child: SizedBox()),
                                                      IconButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        }, 
                                                        icon: Icon(
                                                          Icons.close,
                                                          size: 24 * settingsState.sizeFactor,
                                                          color: palette.textColor2,
                                                        )
                                                      )
                                                    ],
                                                  )
                                                ),

                                                Expanded(
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          // padding: EdgeInsets.symmetric(horizontal: 18.0 * settingsState.sizeFactor),
                                                          padding: EdgeInsets.zero,
                                                          child: Table(
                                                            columnWidths: const <int, TableColumnWidth>{
                                                              0: FlexColumnWidth(1),
                                                              1: FlexColumnWidth(5),
                                                              2: FlexColumnWidth(2),
                                                            },
                                                            border: TableBorder(
                                                              horizontalInside: BorderSide(
                                                                width: 0.5, 
                                                                color: palette.textColor2, 
                                                                style: BorderStyle.solid
                                                              )
                                                            ),     
                                                            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                                            children: <TableRow>[
                                                              TableRow(
                                                                decoration: BoxDecoration(
                                                                ),
                                                                children: [
                                                                  Align(
                                                                    alignment: Alignment.centerLeft,
                                                                    child: Text(
                                                                      "#",
                                                                      style: TextStyle(color: palette.textColor2, fontSize: 22*settingsState.sizeFactor),
                                                                    ),
                                                                  ),
                                                                  Align(
                                                                    alignment: Alignment.centerLeft,
                                                                    child: Text(
                                                                      Helpers().translateText(gamePlayState.currentLanguage, "Word",),
                                                                      style: TextStyle(color: palette.textColor2, fontSize: 22*settingsState.sizeFactor),
                                                                    ),
                                                                  ),
                                                                  Align(
                                                                    alignment: Alignment.centerRight,
                                                                    child: Padding(
                                                                      padding: EdgeInsets.symmetric(horizontal: 4.0*settingsState.sizeFactor),
                                                                      child: Text(
                                                                        Helpers().translateText(gamePlayState.currentLanguage, "Points"),
                                                                        style: TextStyle(color: palette.textColor2, fontSize: 22*settingsState.sizeFactor),
                                                                        textAlign: TextAlign.right,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ]
                                                              ),
                                                              for (int i=0; i< summary.length; i++)
                                                              Helpers().scoreSummaryTableRow2(
                                                                i, 
                                                                palette,
                                                                summary[i], 
                                                                context, 
                                                                gamePlayState.currentLanguage, 
                                                                settingsState.sizeFactor
                                                              ),                                                          
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );                                      
                                      // return AlertDialog(
                                      //   title: Text(
                                      //     Helpers().translateText(gamePlayState.currentLanguage, "Summary of Points",),
                                      //     style: TextStyle(
                                      //         color: palette.textColor3,
                                      //         fontSize: 22*settingsState.sizeFactor),
                                      //   ),
                                      //   scrollable: true,
                                      //   backgroundColor:
                                      //       palette.optionButtonBgColor,
                                      //   content: SizedBox(
                                      //     width:
                                      //         MediaQuery.of(context).size.width,
                                      //     height:
                                      //         MediaQuery.of(context).size.width,
                                      //     child: SingleChildScrollView(
                                      //       child: Table(
                                      //         columnWidths: const <int, TableColumnWidth>{
                                      //           0: FlexColumnWidth(1),
                                      //           1: FlexColumnWidth(5),
                                      //           2: FlexColumnWidth(2),
                                      //         },
                                      //         defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                      //         children: <TableRow>[
                                      //           TableRow(
                                      //             children: [
                                      //               Center(
                                      //                 child: Text(
                                      //                   "#",
                                      //                   style: TextStyle(color: palette.textColor2, fontSize: 20*settingsState.sizeFactor),
                                      //                 ),
                                      //               ),
                                      //               Align(
                                      //                 alignment: Alignment.centerLeft,
                                      //                 child: Text(
                                      //                   Helpers().translateText(gamePlayState.currentLanguage, "Word",),
                                      //                   style: TextStyle(color: palette.textColor2, fontSize: 20*settingsState.sizeFactor),
                                      //                 ),
                                      //               ),
                                      //               Align(
                                      //                 alignment: Alignment.centerRight,
                                      //                 child: Text(
                                      //                   Helpers().translateText(gamePlayState.currentLanguage, "Points"),
                                      //                   style: TextStyle(color: palette.textColor2, fontSize: 20*settingsState.sizeFactor),
                                      //                   textAlign: TextAlign.right,
                                      //                 ),
                                      //               ),
                                      //             ]
                                      //           ),
                                      //           for (int i=0; i< summary.length; i++)
                                      //           Helpers().scoreSummaryTableRow2(i, palette,summary[i], context, gamePlayState.currentLanguage, settingsState.sizeFactor ),
                                      //         ]
                                      //       ),                                              
                                      //     ),
                                      //   ),
                                      //   actions: <Widget>[
                                      //     InkWell(
                                      //       child: Text(
                                      //         Helpers().translateText(gamePlayState.currentLanguage, "Close"),
                                      //         style: TextStyle(
                                      //             color: palette.textColor3,
                                      //             fontSize: 22*settingsState.sizeFactor),
                                      //       ),
                                      //       onTap: () {
                                      //         Navigator.of(context).pop();
                                      //       },
                                      //     ),
                                      //   ],
                                      // );
                                    });
                              },
                              child: Text(
                                Helpers().translateText(gamePlayState.currentLanguage, "View points summary"),
                                style: TextStyle(
                                  color: palette.textColor2,
                                  fontSize: 24*settingsState.sizeFactor,
                                  fontStyle: FontStyle.italic
                                ),
                              ),
                              // child: Text.rich(
                              //   TextSpan(
                              //     text: 'View all ',
                              //     style: TextStyle(
                              //         fontSize: 24,
                              //         color: palette.textColor3,
                              //         fontStyle: FontStyle.italic),
                              //     children: <TextSpan>[
                              //       TextSpan(
                              //           text: gamePlayState
                              //               .endOfGameData['uniqueWords']
                              //               .toString(),
                              //           style: TextStyle(
                              //               decoration:
                              //                   TextDecoration.underline,
                              //               decorationColor: palette.textColor3,
                              //               decorationThickness: 1.0)),
                              //       const TextSpan(text: ' words'),
                              //     ],
                              //   ),
                              // ),
                            ),
                            const Expanded(
                              flex: 3,
                              child: SizedBox(),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: palette.optionButtonBgColor,
                                foregroundColor: palette.textColor1,
                                shadowColor:const Color.fromRGBO(123, 123, 123, 0.7),
                                elevation: 3.0,
                                minimumSize: Size(double.infinity, 50 * settingsState.sizeFactor),
                                padding: EdgeInsets.all(4.0*settingsState.sizeFactor),
                                // textStyle: TextStyle(
                                //   fontSize: 22*settingsState.sizeFactor,
                                // ),
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                              ),
                              onPressed: () {
                                gamePlayState.endGame();
                                FirestoreMethods().updateSettingsState(
                                    settingsState, AuthService().currentUser!.uid);
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MenuScreen()));
                              },
                              child: Text(
                                Helpers().translateText(gamePlayState.currentLanguage, "Main Menu"),
                                style: TextStyle(
                                  color: palette.textColor3,
                                  fontSize: 22* settingsState.sizeFactor
                                ),
                              ),
                            ),
                          ],
                        ));
                      },
                    ),
                  ),
                ),
                SizedBox.expand(
                  child: Visibility(
                    visible: _duringCelebration,
                    child: IgnorePointer(
                      child: Confetti(
                        palette: palette,
                        isStopped: !_duringCelebration,
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          );
  }
}

TableRow rowStatItem(String text, String data, Icon icon, ColorPalette palette, double sizeFactor) {
  // final ColorPalette palette = context.read<ColorPalette?>();

  return TableRow(children: <Widget>[
    Center(child: icon),
    FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(fontSize: 18*sizeFactor, color: palette.textColor3),
      ),
    ),
    Align(
      alignment: Alignment.centerRight,
      child: Text(
        data.toString(),
        style: TextStyle(fontSize: 18*sizeFactor, color: palette.textColor3),
      ),
    ),
  ]);
}
