// import 'package:flutter/foundation.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/ads/interstitial_ad_widget.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/screens/menu_screen/menu_screen.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

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

              setState(() {
                isLoading = false;
              });

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
        onAdShowedFullScreenContent: (ad) {},
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

  // void showInterstitialAd() {
  //   _interstitialAd.show();
  // }

  @override
  Widget build(BuildContext context) {
    late ColorPalette palette =
        Provider.of<ColorPalette>(context, listen: false);

    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
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
                        const Expanded(child: SizedBox()),
                        Center(
                          child: Text(
                            "Score: ${gamePlayState.summaryData['points']}",
                            style: TextStyle(
                                color: palette.textColor2, fontSize: 32),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "All ${gamePlayState.summaryData['uniqueWords'].length} words:",
                            style: TextStyle(
                                color: palette.textColor2, fontSize: 22),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ListView.builder(
                              itemCount: gamePlayState
                                  .summaryData['uniqueWords'].length,
                              itemBuilder: (context, index) {
                                final String word = gamePlayState
                                    .summaryData['uniqueWords'][index];
                                return Text(
                                  word,
                                  style: TextStyle(
                                    color: palette.textColor2,
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.start,
                                );
                              },
                            ),
                          ),
                        ),
                        // const Text("Game Summary"),

                        const Expanded(
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
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              // side: BorderSide(
                              //     color: palette.textColor3,
                              //     width: 1,
                              //     style: BorderStyle.solid),
                            ),
                          ),
                          onPressed: () {
                            gamePlayState.endGame();
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const MenuScreen()));
                          },
                          child: Text(
                            "Main Menu",
                            style: TextStyle(
                              color: palette.textColor2,
                            ),
                          ),
                        ),
                      ],
                    ));
                  },
                ),
              ),
            ),
          );
  }
}
