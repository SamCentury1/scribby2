import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/ads/ad_mob_service.dart';
import 'package:scribby_flutter_v2/audio/audio_service.dart';
import 'package:scribby_flutter_v2/audio/sounds.dart';
import 'package:scribby_flutter_v2/components/background_painter.dart';
import 'package:scribby_flutter_v2/components/daily_puzzle_ranking_widget.dart';
import 'package:scribby_flutter_v2/components/loading_image.dart';
import 'package:scribby_flutter_v2/functions/animations.dart';
import 'package:scribby_flutter_v2/functions/game_logic.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/functions/widget_utils.dart';
import 'package:scribby_flutter_v2/providers/ad_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
import 'package:scribby_flutter_v2/screens/authentication/auth_screen.dart';
import 'package:scribby_flutter_v2/screens/game_over_screen/components/daily_puzzle_ranking_section.dart';
import 'package:scribby_flutter_v2/screens/game_over_screen/components/game_failed_section.dart';
import 'package:scribby_flutter_v2/screens/game_over_screen/components/game_over_badge_section.dart';
import 'package:scribby_flutter_v2/screens/game_over_screen/components/game_over_counter_painter.dart';
import 'package:scribby_flutter_v2/screens/game_over_screen/components/game_over_data_section.dart';
import 'package:scribby_flutter_v2/screens/game_over_screen/components/reward_dialog.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/painters/bonus_painters.dart';
import 'package:scribby_flutter_v2/screens/home_screen/home_screen.dart';
import 'package:scribby_flutter_v2/screens/statistics_screen.dart/components/badge_painters.dart';
import 'package:scribby_flutter_v2/screens/statistics_screen.dart/views/badges_view.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';

class GameOverScreen extends StatefulWidget {
  const GameOverScreen({super.key});

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {

  late GamePlayState gamePlayState;
  late SettingsState settingsState;
  late SettingsController settings;

  // late AdState _adState;

  late bool shouldShowInterstitialAd = false;
  late List<dynamic> badgeData = [];
  late bool isLoading = true;
  late bool isRankingLoading = true;

  // interstitial ad
  InterstitialAd? _interstitialAd;
  bool _isAdLoading = false;  

  // rewarded ad
  RewardedAd? _rewardedAd;
  bool _isRewardedLoading = false;  
  late bool isObjectiveFailed = false;


  final adUnitId = Platform.isAndroid
      // ? 'ca-app-pub-2459167095237263/4958251976' // prod
      ? 'ca-app-pub-3940256099942544/1033173712' // test

      // : 'ca-app-pub-2459167095237263/7967558693'; // prod
      : 'ca-app-pub-3940256099942544/4411468910'; // test


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gamePlayState = Provider.of<GamePlayState>(context,listen: false);
    AdState _adState = Provider.of<AdState>(context,listen: false);
    settings = Provider.of<SettingsController>(context,listen: false);
    
    // if (gamePlayState.gameResultData["didCompleteGame"]==false) {
    //   setState(() {
    //     shouldShowInterstitialAd = true;
    //     _adState.loadGameOverInterstitialAd(gamePlayState);
    //   });
    // } else {
    //   setState(() {
    //     shouldShowInterstitialAd = false;
    //   });

    //   GameLogic().storeEndOfGameData(settings,gamePlayState);
    //   // Helpers().saveUserGameHistoryData(settings,gamePlayState);
    //   GameLogic().updateRank(settings,gamePlayState);

    //   print("game result data: ${gamePlayState.gameResultData}");

    //   badgeData = gamePlayState.gameResultData["badges"];
    //   Animations().startGameOverScreenCountAnimation(gamePlayState);
    // }


    if (gamePlayState.gameParameters["gameType"]=="sprint") {
      if (gamePlayState.gameResultData['didAchieveObjective']==false) {
        setState(() {
          isObjectiveFailed = true;
        });
      }
    } 



      // setState(() {
      //   shouldShowInterstitialAd = false;
      // });

    // setState(() {
    //   _adState.loadGameOverInterstitialAd(gamePlayState);
    // });      
    GameLogic().storeEndOfGameData(settings,gamePlayState);
    GameLogic().updateRank(settings,gamePlayState);

    // print("game result data: ${gamePlayState.gameResultData}");

    badgeData = gamePlayState.gameResultData["badges"];
    // Animations().startGameOverScreenCountAnimation(gamePlayState);

    // loadAd();

    loadInterstitialAd();

    Future.microtask(() {
      _adState.loadGameOverRewardedAd();
    });    
 
    // setState(() {
    //   _adState.loadGameOverRewardedAd(context,gamePlayState,settings);
    // });
    // Animations().startGameOverScreenCountAnimation(gamePlayState);

  }

  void onUserEarnedReward() {

    try {
      // Update coins, XP, achievements, rank, etc.
      final SettingsController settings = Provider.of<SettingsController>(context, listen: false);
      final GamePlayState gamePlayState = Provider.of<GamePlayState>(context, listen: false);

      // Reward logic here
      final int coins = Helpers().getUserCoins(settings); // settings.coins.value;
      final int rewardAmount = gamePlayState.gameResultData["reward"]*2;
      final int xpAmount = gamePlayState.gameResultData["xp"];
      final String? rank = gamePlayState.gameResultData["newRank"];
      List<dynamic> badgeData = gamePlayState.gameResultData["badges"];
      // settings.setCoins(coins + rewardAmount);
      FirestoreMethods().updateUserDoc(settings,"coins",(coins + rewardAmount));
      settings.setAchievements({"coins":rewardAmount,"xp":xpAmount, "rank":rank, "badges":badgeData});                                      

      // Now navigate home and reset
      // print("just earned that shit: {'coins':$rewardAmount,'xp':$xpAmount, 'rank':$rank, 'badges':$badgeData}");
      gamePlayState.refreshAllData();
    } catch (error, traceback) {
      // debugPrint("error in user earned reward function - $error | $traceback");
      Helpers().printError("onUserEarnedReward", error, traceback);
    }
  }


  // void loadAd() {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   try {
  //     InterstitialAd.load(
  //         adUnitId: adUnitId,
  //         request: const AdRequest(),
  //         adLoadCallback: InterstitialAdLoadCallback(
  //           onAdLoaded: (InterstitialAd ad) {

            
  //             setFullScreenContentCallback(ad);
  //             // ad.show();
  //             Future.microtask(() => ad.show());
  //             // debugPrint('ad #${adsLoaded} loaded.');
  //           },
  //           // Called when an ad request failed.
  //           onAdFailedToLoad: (LoadAdError error) {
  //             setState(() {
  //               isLoading = false;
  //             });
  //             // debugPrint('InterstitialAd failed to load: $error');
  //           },
  //         ));
  //   } catch (e) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }


  // void setFullScreenContentCallback(InterstitialAd ad, ) {
  //   ad.fullScreenContentCallback = FullScreenContentCallback(
  //       // Called when the ad showed the full screen content.
  //       onAdShowedFullScreenContent: (ad) {
  //         setState(() {
  //           isLoading = false;
  //         });
  //       },
  //       // Called when an impression occurs on the ad.
  //       onAdImpression: (ad) {},
  //       // Called when the ad failed to show full screen content.
  //       onAdFailedToShowFullScreenContent: (ad, err) {
  //         // Dispose the ad here to free resources.
  //         ad.dispose();

  //       },
  //       // Called when the ad dismissed full screen content.
  //       onAdDismissedFullScreenContent: (ad) {
  //         Animations().startGameOverScreenCountAnimation(gamePlayState);
  //         // Dispose the ad here to free resources.
  //         ad.dispose();
  //       },
  //       // Called when a click is recorded for an ad.
  //       onAdClicked: (ad) {});
  // }  


  Future<void> loadInterstitialAd() async {
    if (_isAdLoading) return; // avoid duplicate loads
    _isAdLoading = true;

    setState(() {
      isLoading = true;
    });

    try {
      await InterstitialAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _interstitialAd = ad;
            _isAdLoading = false;

            if (!mounted) return;

            setInterstitialCallbacks(ad);

            setState(() {
              isLoading = false;
            });

            // Recommended: give UI time to settle before showing
            Future.delayed(const Duration(milliseconds: 20), () {
              if (mounted) {
                _interstitialAd?.show();
              }
            });
          },
          onAdFailedToLoad: (error) {
            _isAdLoading = false;
            _interstitialAd = null;

            if (!mounted) return;

            debugPrint("Interstitial failed to load : ${error.code} - ${error.message}");

            setState(() {
              isLoading = false;
            });

            // Continue to game over screen animation even if ad fails
            final audioService = context.read<AudioService>();
            // print("????");
            // audioService.play(SfxType.scoreTally);
            if (!isObjectiveFailed) {
              Animations().startGameOverScreenCountAnimation(gamePlayState,audioService);
            } 
          },
        ),
      );
    } catch (e, stack) {
      _isAdLoading = false;
      _interstitialAd = null;

      Helpers().printError("loadInterstitialAd", e, stack);

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
      final audioService = context.read<AudioService>();
      // audioService.play(SfxType.scoreTally);
      if (!isObjectiveFailed) {
        Animations().startGameOverScreenCountAnimation(gamePlayState,audioService);
      } 
      
    }
  }

  void setInterstitialCallbacks(InterstitialAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        debugPrint("Interstitial shown");
      },
      onAdDismissedFullScreenContent: (ad) {
        debugPrint("Interstitial dismissed");
        ad.dispose();
        _interstitialAd = null;

        if (!mounted) return;

        if (!isObjectiveFailed) {
          Animations().startGameOverScreenCountAnimation(gamePlayState,context.read<AudioService>());
        }
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint("Interstitial failed to show: $error");
        ad.dispose();
        _interstitialAd = null;

        if (!mounted) return;
        if (!isObjectiveFailed) {
          Animations().startGameOverScreenCountAnimation(gamePlayState,context.read<AudioService>());
        }
      },
    );
  }  

  @override
  Widget build(BuildContext context) {
    
    // return Consumer<AdState>(
    //   builder: (context,adState,child) {

        if (isLoading) {
          // return Center(child: CircularProgressIndicator(),);
          return PopScope(
            canPop: false,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SizedBox(
                width:MediaQuery.of(context).size.width, 
                height:MediaQuery.of(context).size.height,
                child: LoadingImage()
              )
            ),
          );           

        } else {
          return FutureBuilder(
            future: FirestoreMethods().getDailyPuzzleObject(gamePlayState.gameParameters["puzzleId"]),
            builder: (context,asyncSnapshot) {
              if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                return PopScope(
                  canPop: false,
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: SizedBox(
                      width:MediaQuery.of(context).size.width, 
                      height:MediaQuery.of(context).size.height,
                      child: LoadingImage()
                    )
                  ),
                );                  
              } else if (asyncSnapshot.hasError) {
                return Text("Error: ${asyncSnapshot.error}");
              } else if (asyncSnapshot.hasData) {
                
                List<dynamic> fakeRankingData=[];
                final puzzle = asyncSnapshot.data!;
                if (puzzle.isNotEmpty) {
                  fakeRankingData= Helpers().fakeRanking(puzzle["data"],puzzle["gameType"]);
                }
                return Consumer<GamePlayState>(          
                  builder: (context,gamePlayState,child) {
                    ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
                    final double scalor = Helpers().getScalor(settings);
                    double scoreFontSize = Helpers().getScoreFontSize(MediaQuery.of(context),0.045);
                    return PopScope(
                      canPop: false,
                      child: Scaffold(
                        backgroundColor: Colors.transparent,
                        body: Stack(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              child: CustomPaint(painter: GradientBackground(settings: settings, palette: palette, decorationData: []),)
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.0*scalor),
                              child: Column(
                                children: [
                                        
                                  // top section
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox()
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: isObjectiveFailed 
                                    ? SizedBox(
                                      child: Center(
                                        child: Text(
                                          "Game Over",
                                          style: palette.mainAppFont(
                                            textStyle: TextStyle(
                                              fontSize: 42*scalor,
                                              color: palette.text1
                                            )
                                          ),
                                        ),
                                      ),
                                    )
                                    
                                    : SizedBox(
                                      child: Column(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: SizedBox(),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                child: GameOverCounter(settings: settings, palette: palette,),
                                              ),
                                            ),
                                          ),
                              
                                          GameOverBadgeSection(badgeData: badgeData,),
                              
                                        ],
                                      ),
                                    )
                                  ),
                                  // Text(gamePlayState.gameResultData.toString()),
                                            
                                  // middle section
                                  Expanded(
                                    flex: 7,
                                    child: Builder(
                                      builder: (context) {
                                        if (isObjectiveFailed) {
                                          return GameFailedSection();
                                        } else {
                                          if (gamePlayState.gameParameters["puzzleId"] == null) {
                                            return GameOverDataSection();
                                          } else {
                                            return DailyPuzzleRankingWidget(gameType:puzzle["gameType"], ranking: puzzle["data"], settings: settings,);
                                          }
                                        }
                                      }
                                    ),

                                  ),
                                        
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical:4.0*scalor),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(vertical: 2.0*scalor),
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: palette.navigationButtonBg2, //const Color.fromARGB(255, 220, 220, 223),
                                                  foregroundColor: palette.navigationButtonText2, // const Color.fromARGB(255, 44, 34, 185),
                                                  textStyle: GoogleFonts.lilitaOne(
                                                    fontSize: 24*scalor
                                                  ),                                    
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(scoreFontSize*0.15)),
                                                  ),
                                                  minimumSize: Size(200*scalor,50*scalor)
                                                ),                          
                                                onPressed: () => openViewSummaryDialog(context,settings,palette), 
                                                child: Text("View Points Summary")
                                              ),
                                            ),
                                          ),
                                              
                                          Padding(
                                            padding: EdgeInsets.symmetric(vertical: 2.0*scalor),
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: palette.navigationButtonBg1,
                                                  // backgroundColor: const Color.fromARGB(255, 4, 19, 87),
                                                  foregroundColor: palette.navigationButtonText1,
                                                  textStyle: GoogleFonts.lilitaOne(
                                                    fontSize: 24*scalor
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(scoreFontSize*0.15)),
                                                  ),
                                                  minimumSize: Size(200*scalor,50*scalor)
                                                ),
                                                onPressed: () {

                                            
                                                                                
                                                  if (gamePlayState.gameResultData["didCompleteGame"] && gamePlayState.gameResultData["reward"] > 0) {
                                                    // openDoubleCoinsDialog(context,settings);
                                                    showDialog<void>(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        // return DoubleCoinsDialog(settings: settings,);
                                                        return RewardDialog(
                                                          settings: settings,
                                                          onRewardedAdSuccess: onUserEarnedReward,
                                                            
                                                        );
                                                      }
                                                    );                                                          
                                                  } else {
                                                    final int rewardAmount = gamePlayState.gameResultData["reward"];
                                                    final int xpAmount = gamePlayState.gameResultData["xp"];
                                                    final String? rank = gamePlayState.gameResultData["newRank"];
                                                    settings.setAchievements({"coins":rewardAmount,"xp": xpAmount, "rank":rank, "badges":badgeData});  
                                                    Navigator.of(context).pushAndRemoveUntil(
                                                      MaterialPageRoute(builder: (context) => const AuthScreen()),
                                                      (Route<dynamic> route) => false,
                                                    );
                                                    gamePlayState.refreshAllData();  
                                                                                      
                                                  }
                                                                                    
                                                }, 
                                                child: Text("Home"),
                                              ),
                                            ),
                                          ),                                
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).padding.bottom,)                
                                        
                                  // // bottom section
                                  // Expanded(
                                  //   flex: 2,
                                  //   child: Container(
                                  //     child: Center(
                                  //       child:ElevatedButton(
                                  //         style: ElevatedButton.styleFrom(
                                  //           backgroundColor: const Color.fromARGB(255, 4, 19, 87),
                                  //           foregroundColor: Colors.white,
                                  //           textStyle: GoogleFonts.lilitaOne(
                                  //             fontSize: 24*scalor
                                  //           ),
                                  //           shape: RoundedRectangleBorder(
                                  //             borderRadius: BorderRadius.all(Radius.circular(scoreFontSize*0.15)),
                                  //           ),
                                  //           minimumSize: Size(200*scalor,scoreFontSize*0.7)
                                  //         ),
                                  //         onPressed: () {
                                            
                                  //           if (gamePlayState.gameResultData["didCompleteGame"]) {
                                  //             openDoubleCoinsDialog(context,settings);
                                  //           } else {
                                  //             final int rewardAmount = gamePlayState.gameResultData["reward"];
                                  //             settings.setAchievements({"coins":rewardAmount,"rank":null, "badges":badgeData});  
                                              
                                            
                                  //             print("navigating home");
                                  //             Navigator.of(context).pushAndRemoveUntil(
                                          
                                  //               MaterialPageRoute(builder: (context) => const HomeScreen()),
                                  //               (Route<dynamic> route) => false,
                                  //             );
                                  //             gamePlayState.refreshAllData();  
                                                                                
                                  //           }
                                            
                                  //         }, 
                                  //         child: Text("Home"),
                                  //       ),                        
                                  //     ),
                                  //   ),
                                  // ),
                                ]
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  
                );
              }
              return SizedBox();
            }
          );
        }
    //   }
    // );
  }
}


// Widget summaryItem(IconData icon, String body, dynamic value, double size, ColorPalette palette) {
//   Widget res = ConstrainedBox(
//     constraints: BoxConstraints(
//       maxWidth: 400
//     ),
//     child: Padding(
//       padding: EdgeInsets.symmetric(horizontal: size),
//       child: Container(
//         child: Row(
//           children: [
//             Expanded(
//               flex:2, 
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: Icon(icon,size: size,color: palette.text1)
//               )
//             ),
//             Expanded(
//               flex:5, 
//               child: FittedBox(
//                 fit: BoxFit.scaleDown,
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   body, 
//                   style: TextStyle(
//                       color: palette.text1,
//                       fontSize: size
//                   ),
//                   // textAlign: TextAlign.start,
//                 ),
//               )
//             ),
//             Expanded(
//               flex:3, 
//               child: Align(
//                 alignment: Alignment.centerRight, 
//                 child: Text(
//                   value.toString(), 
//                   style: TextStyle(
//                     fontSize: size,
//                     color: palette.text1,
//                   ),
//                 )
//               )
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
//   return res;
// }


Future<void> openViewSummaryDialog(BuildContext context, SettingsController settings, ColorPalette palette) async {

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return ViewSummaryDialog(settings: settings,palette:palette);
    }
  );
}


class ViewSummaryDialog extends StatelessWidget {
  final SettingsController settings;
  final ColorPalette palette;
  const ViewSummaryDialog({
    super.key,
    required this.settings,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<GamePlayState>(
      builder: (context,gamePlayState,child) {
        final double scalor = Helpers().getScalor(settings);
        List<TableRow> rows = WidgetUtils().getSummaryTableRows(context,gamePlayState,scalor,palette);
        

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0))
          ),
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                radius: 0.6*scalor,
                colors: [palette.dialogBg1,palette.dialogBg2]
              ),
              borderRadius: BorderRadius.all(Radius.circular(12.0*scalor))
            ),              
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                        
                    Table(
                      columnWidths: const <int, TableColumnWidth>{
                        0: IntrinsicColumnWidth(),
                        1: FlexColumnWidth(),
                        2: FlexColumnWidth(),
                        3: FlexColumnWidth(),
                      },
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      border: TableBorder(
                        horizontalInside: BorderSide(width: 1.0, color: const Color.fromARGB(139, 255, 255, 255)) 
                      ),
                      children: [
                        TableRow(
                          children: [
                            WidgetUtils().headingItem("Trun",scalor,palette),
                            WidgetUtils().headingItem("Words",scalor,palette),
                            WidgetUtils().headingItem("Bonus",scalor,palette),
                            WidgetUtils().headingItem("Points",scalor,palette),
                          ]
                        ), ... rows
                      ],
                    ), 
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
