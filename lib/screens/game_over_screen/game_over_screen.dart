// import 'package:flutter/foundation.dart';
import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
// import 'package:scribby_flutter_v2/ads/interstitial_ad_widget.dart';
import 'package:scribby_flutter_v2/functions/game_logic.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/resources/auth_service.dart';
import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
import 'package:scribby_flutter_v2/screens/menu_screen/menu_screen.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

import '../../functions/helpers.dart';

class GameOverScreen extends StatefulWidget {
  const GameOverScreen({super.key});

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  // late final InterstitialAd _interstitialAd;
  late bool isLoading = false;

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
        },
        // Called when a click is recorded for an ad.
        onAdClicked: (ad) {});
  }

  // int getCurrentHighScore(SettingsState settings) {
  //   final String currentLanguage =
  //       settings.userData['parameters']['currentLanguage'];
  //   final int currentHighScore =
  //       settings.userData['highScores'][currentLanguage] ?? 0;
  //   return currentHighScore;
  // }

  Widget getNewHighScore(
      SettingsState settings, ColorPalette palette, int currentScore) {
    String currentLanguage = settings.userData['parameters']['currentLanguage'];

    late int currentHighScore = 0;
    if (settings.userData['highScores'][currentLanguage] != null) {
      currentHighScore = settings.userData['highScores'][currentLanguage];
    }

    if (currentScore > currentHighScore) {
      return Expanded(
        flex: 3,
        child: Center(
          child: SizedBox(
            child: Text(
              "New High Score!!",
              style: TextStyle(fontSize: 32, color: palette.textColor3),
            ),
          ),
        ),
      );
    } else {
      return const Expanded(
        flex: 3,
        child: SizedBox(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    late ColorPalette palette =
        Provider.of<ColorPalette>(context, listen: false);
    late SettingsState settings =
        Provider.of<SettingsState>(context, listen: false);

    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : PopScope(
            onPopInvoked: (details) {
              debugPrint("navigate back to main menu");
            },
            child: Scaffold(
              body: Container(
                width: double.infinity,
                color: palette.screenBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 18.0),
                  child: Consumer<GamePlayState>(
                    builder: (context, gamePlayState, child) {
                      return SafeArea(
                          child: Column(
                        children: [
                          getNewHighScore(settings, palette,
                              gamePlayState.endOfGameData['points']),
                          Center(
                            child: Text(
                              "Score: ${gamePlayState.endOfGameData['points']}",
                              style: TextStyle(
                                  color: palette.textColor3, fontSize: 42),
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
                                  "High Score: ${Helpers().getCurrentHighScore(settings)}",
                                  style: TextStyle(
                                      color: palette.textColor3, fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          const Expanded(
                            flex: 1,
                            child: SizedBox(),
                          ),
                          // Text(
                          //   "Details",
                          //   style: TextStyle(
                          //       fontSize: 20, color: palette.textColor3),
                          // ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(16.0, 4.0, 26.0, 4.0),
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
                                    "Duration",
                                    GameLogic().formatTime(gamePlayState
                                        .endOfGameData['duration']),
                                    Icon(Icons.timer,
                                        size: 26, color: palette.textColor3),
                                    palette),
                                rowStatItem(
                                    "Level",
                                    gamePlayState.endOfGameData['level']
                                        .toString(),
                                    Icon(Icons.bar_chart_rounded,
                                        size: 26, color: palette.textColor3),
                                    palette),
                                rowStatItem(
                                    "Longest Streak",
                                    gamePlayState.endOfGameData['longestStreak']
                                        .toString(),
                                    Icon(Icons.electric_bolt,
                                        size: 26, color: palette.textColor3),
                                    palette),
                                rowStatItem(
                                    "Cross Words",
                                    gamePlayState.endOfGameData['crossWords']
                                        .toString(),
                                    Icon(Icons.close,
                                        size: 26, color: palette.textColor3),
                                    palette),
                                rowStatItem(
                                    "Most Points",
                                    gamePlayState.endOfGameData['mostPoints']
                                        .toString(),
                                    Icon(Icons.star,
                                        size: 26, color: palette.textColor3),
                                    palette),
                                rowStatItem(
                                    "Most Words",
                                    gamePlayState.endOfGameData['mostWords']
                                        .toString(),
                                    Icon(Icons.my_library_books_sharp,
                                        size: 26, color: palette.textColor3),
                                    palette),
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
                                    return AlertDialog(
                                      title: Text(
                                        "All Words",
                                        style: TextStyle(
                                            color: palette.textColor3),
                                      ),
                                      scrollable: true,
                                      backgroundColor:
                                          palette.optionButtonBgColor,
                                      content: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.width,
                                        child: SingleChildScrollView(
                                          child: Table(
                                            // border: TableBorder.all(),
                                            columnWidths: const <int,
                                                TableColumnWidth>{
                                              0: FlexColumnWidth(1),
                                              1: FlexColumnWidth(3),
                                            },
                                            defaultVerticalAlignment:
                                                TableCellVerticalAlignment
                                                    .middle,
                                            children: <TableRow>[
                                              for (int i = 0;
                                                  i <
                                                      gamePlayState
                                                              .endOfGameData[
                                                          'uniqueWords'];
                                                  i++)
                                                TableRow(children: [
                                                  Text(
                                                    (i + 1).toString(),
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color:
                                                            palette.textColor3),
                                                  ),
                                                  Text(
                                                    gamePlayState.endOfGameData[
                                                        'uniqueWordsList'][i],
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color:
                                                            palette.textColor3),
                                                  )
                                                ])
                                            ],
                                          ),
                                        ),
                                      ),
                                      actions: <Widget>[
                                        InkWell(
                                          child: Text(
                                            'Close',
                                            style: TextStyle(
                                                color: palette.textColor3),
                                          ),
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Text.rich(
                              TextSpan(
                                text: 'View all ',
                                style: TextStyle(
                                    fontSize: 24,
                                    color: palette.textColor3,
                                    fontStyle: FontStyle.italic),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: gamePlayState
                                          .endOfGameData['uniqueWords']
                                          .toString(),
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          decorationColor: palette.textColor3,
                                          decorationThickness: 1.0)),
                                  const TextSpan(text: ' words'),
                                ],
                              ),
                            ),
                          ),
                          const Expanded(
                            flex: 3,
                            child: SizedBox(),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: palette.optionButtonBgColor,
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
                              gamePlayState.endGame();
                              FirestoreMethods().updateSettingsState(
                                  settings, AuthService().currentUser!.uid);
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MenuScreen()));
                            },
                            child: Text(
                              "Main Menu",
                              style: TextStyle(
                                color: palette.textColor3,
                              ),
                            ),
                          ),
                        ],
                      ));
                    },
                  ),
                ),
              ),
            ),
          );
  }
}

TableRow rowStatItem(
    String text, String data, Icon icon, ColorPalette palette) {
  // final ColorPalette palette = context.read<ColorPalette?>();

  return TableRow(children: <Widget>[
    Center(child: icon),
    Text(
      text,
      style: TextStyle(fontSize: 22, color: palette.textColor3),
    ),
    Align(
      alignment: Alignment.centerRight,
      child: Text(
        data.toString(),
        style: TextStyle(fontSize: 22, color: palette.textColor3),
      ),
    ),
  ]);
}
