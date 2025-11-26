import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/ads/ad_mob_service.dart';
import 'package:scribby_flutter_v2/components/background_painter.dart';
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
import 'package:scribby_flutter_v2/screens/game_over_screen/components/game_over_badge_section.dart';
import 'package:scribby_flutter_v2/screens/game_over_screen/components/game_over_counter_painter.dart';
import 'package:scribby_flutter_v2/screens/game_over_screen/components/game_over_data_section.dart';
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

  late AdState _adState;

  late bool shouldShowInterstitialAd = false;
  late List<dynamic> badgeData = [];
  late bool isLoading = true;


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
    // _adState = Provider.of<AdState>(context,listen: false);
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






      // setState(() {
      //   shouldShowInterstitialAd = false;
      // });

    // setState(() {
    //   _adState.loadGameOverInterstitialAd(gamePlayState);
    // });      
    GameLogic().storeEndOfGameData(settings,gamePlayState);
    GameLogic().updateRank(settings,gamePlayState);

    print("game result data: ${gamePlayState.gameResultData}");

    badgeData = gamePlayState.gameResultData["badges"];
    // Animations().startGameOverScreenCountAnimation(gamePlayState);

    loadAd();
 
    // setState(() {
    //   _adState.loadGameOverRewardedAd(context,gamePlayState,settings);
    // });
    // Animations().startGameOverScreenCountAnimation(gamePlayState);

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
            onAdLoaded: (InterstitialAd ad) {

            
              setFullScreenContentCallback(ad);
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


  void setFullScreenContentCallback(InterstitialAd ad, ) {
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
          Animations().startGameOverScreenCountAnimation(gamePlayState);
          // Dispose the ad here to free resources.
          ad.dispose();
        },
        // Called when a click is recorded for an ad.
        onAdClicked: (ad) {});
  }  

  @override
  Widget build(BuildContext context) {
    
    // return Consumer<AdState>(
    //   builder: (context,adState,child) {

        if (isLoading) {
          return Center(child: CircularProgressIndicator(),);

        } else {
          return Builder(
            builder: (context) {
              return Consumer<GamePlayState>(          
                builder: (context,gamePlayState,child) {
                  ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
                  final double scalor = Helpers().getScalor(settings);
                  double scoreFontSize = Helpers().getScoreFontSize(MediaQuery.of(context),0.045);
                  // final String gameType = Helpers().capitalize(gamePlayState.gameParameters["gameType"]) ;
                  // final int score = Helpers().calculateScore(gamePlayState);
                  // final int uniqueWords = Helpers().countUniqueWords(gamePlayState);
                  // final int turns = Helpers().countTurns(gamePlayState);
                  // final int streak = Helpers().getLongestStreak(gamePlayState);
                  // final int crosswords = Helpers().countCrosswords(gamePlayState);
                  // final int biggestTurn = Helpers().getBiggestTurn(gamePlayState);
                  // final String duration = Helpers().formatDuration(gamePlayState.duration.inSeconds);
                  print("------------- puzzle data ---------------");
                  print(gamePlayState.gameParameters["puzzleId"]);
                  print("----------------------------------");
                  
                  // double scoreBorderSize = getScoreBorderWidth(MediaQuery.of(context));
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
                                  child: Container(
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
                                      if (gamePlayState.gameParameters["puzzleId"] == null) {
                                        return GameOverDataSection();
                                      } else {
                                        return DailyPuzzleRankingSection(gameData: gamePlayState.gameParameters,);
                                      }
                                    }
                                  ),
                                  // child: Padding(
                                  //   padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  //   child: Container(
                                  //     decoration: BoxDecoration(
                                  //       color: const Color.fromARGB(33, 255, 255, 255),
                                  //       borderRadius: BorderRadius.all(Radius.circular(12.0*scalor)),
                                  //     ),
                                  //     child: Column(
                                  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  //       children: [
                                        
                                  //         summaryItem(Icons.gamepad, "Game Type", Helpers().capitalize(gamePlayState.gameParameters["gameType"]),scoreFontSize*0.36,palette ),
                                  //         summaryItem(Icons.library_books, "Unique Words",uniqueWords ,scoreFontSize*0.36,palette ),
                                  //         ConstrainedBox(
                                  //           constraints: BoxConstraints(
                                  //             maxWidth:500,
                                  //           ),
                                  //           child: Padding(
                                  //             padding: EdgeInsets.symmetric(horizontal:scoreFontSize ),
                                  //             child: Divider(),
                                  //           ),
                                  //         ),
                                        
                                  //         gamePlayState.gameParameters["gameType"]=="sprint"
                                  //         ? summaryItem(Icons.score, "Score", score, scoreFontSize*0.36,palette )
                                  //         : summaryItem(Icons.timer, "Duration", duration,scoreFontSize*0.36,palette ),
                                        
                                  //         summaryItem(Icons.control_point_rounded, "Turns", turns,scoreFontSize*0.36,palette ),
                                  //         summaryItem(Icons.bar_chart, "Level", gamePlayState.currentLevel,scoreFontSize*0.36,palette ),
                                  //         ConstrainedBox(
                                  //           constraints: BoxConstraints(
                                  //             maxWidth:500,
                                  //           ),
                                  //           child: Padding(
                                  //             padding: EdgeInsets.symmetric(horizontal:scoreFontSize ),
                                  //             child: Divider(),
                                  //           ),
                                  //         ),
                                        
                                  //         summaryItem(Icons.bolt, "Longest Streak", streak,scoreFontSize*0.36,palette ),
                                  //         summaryItem(Icons.close, "Crosswords", crosswords,scoreFontSize*0.36,palette ),
                                  //         summaryItem(Icons.star, "Biggest Turn", biggestTurn,scoreFontSize*0.36,palette ),
                                        
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
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
                                                                                  
                                                // if (gamePlayState.gameResultData["didCompleteGame"]) {
                                                  openDoubleCoinsDialog(context,settings);
                                                // } else {
                                                  // final int rewardAmount = gamePlayState.gameResultData["reward"];
                                                  // final int xpAmount = gamePlayState.gameResultData["xp"];
                                                  // final String? rank = gamePlayState.gameResultData["newRank"];
                                                  // settings.setAchievements({"coins":rewardAmount,"xp": xpAmount, "rank":rank, "badges":badgeData});  
                                                  
                                                                                  
                                                  // print("navigating home");
                                                  // Navigator.of(context).pushAndRemoveUntil(
                                              
                                                  //   MaterialPageRoute(builder: (context) => const HomeScreen()),
                                                  //   (Route<dynamic> route) => false,
                                                  // );
                                                  // gamePlayState.refreshAllData();  
                                                                                    
                                                // }
                                                                                  
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


Future<void> openDoubleCoinsDialog(BuildContext context, SettingsController settings) async {
  
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return DoubleCoinsDialog(settings: settings,);
    }
  );
}

class DoubleCoinsDialog extends StatefulWidget {
  final SettingsController settings;
  const DoubleCoinsDialog({super.key,required this.settings});

  @override
  State<DoubleCoinsDialog> createState() => _DoubleCoinsDialogState();
}

class _DoubleCoinsDialogState extends State<DoubleCoinsDialog> {

  late AdState _adState;
  late GamePlayState gamePlayState;
  late SettingsController settings;


  @override
  void initState() {
    // TODO: implement initState

    gamePlayState = Provider.of<GamePlayState>(context,listen: false);
    _adState = Provider.of<AdState>(context,listen: false);
    settings = Provider.of<SettingsController>(context,listen: false);
    
    super.initState();
    // _loadRewardedAd();
    setState(() {
      _adState.loadGameOverRewardedAd(context, gamePlayState, settings);
    });    
  }

  @override
  void dispose() {
    super.dispose();
  }
  


  @override
  Widget build(BuildContext context) {
    // final rewardedAd = context.watch<AdState>().rewardedAd; 
    // late AdState adState = Provider.of<AdState>(context, listen: false);

    
    return Consumer<AdState>(
      builder: (context,adState,child) {
        return Consumer<GamePlayState>(
          builder: (context,gamePlayState,child) {

            final double scalor = Helpers().getScalor(widget.settings);

            // print("------------- ${gamePlayState.gameResultData}");

            void executeNavigateHome() {
              print("go caca !!!!");
        
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const AuthScreen())
              );
              gamePlayState.refreshAllData();
            }

            // Map<String,dynamic> getUserGameHistoryObject() {
            //   final int score = Helpers().calculateScore(gamePlayState);
            //   final String? gameType = gamePlayState.gameParameters["gameType"];
            //   final int? target=  null;
            //   final String? targetType =null;
            //   final int boardAxis = 6; 
            //   final int? durationInMinutes = 1;
            //   final int uniqueWords = Helpers().countUniqueWords(gamePlayState);
            //   final int turns = Helpers().countTurns(gamePlayState);
            //   final int streak = Helpers().getLongestStreak(gamePlayState);
            //   final int crosswords = Helpers().countCrosswords(gamePlayState);
            //   final int biggestTurn = Helpers().getBiggestTurn(gamePlayState);           

            //   final Map<String,dynamic> data = {
            //     "createdAt": DateTime.now(),
            //     "score": score,
            //     "uniqueWords":uniqueWords,
            //     "turns":turns,
            //     "streak":streak,
            //     "crosswords":crosswords,
            //     "biggestTurn":biggestTurn,
            //     "durationSeconds":gamePlayState.duration.inSeconds,
            //     "gameParameters": {"gameType": gameType,"target":target,"targetType":targetType,"boardAxis":boardAxis,"durationInMinutes":durationInMinutes},

            //   };

            //   return data;

            // }

            // Map<String,dynamic> userGameHistoryObject = getUserGameHistoryObject();


            SettingsController settings = Provider.of<SettingsController>(context,listen: false);
            ColorPalette palette = Provider.of<ColorPalette>(context,listen: false);
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0))
              ),
              backgroundColor: const Color.fromARGB(0, 32, 32, 32),
              child: IntrinsicHeight(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned.fill(
                      child: Container(
                        // width: double.infinity,
                        // height: 400,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              Color.fromARGB(255, 208, 233, 253), 
                              const Color.fromARGB(255, 17, 71, 219)],
                            radius: 0.6
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(12.0))
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "AWESOME!",
                            style: GoogleFonts.luckiestGuy(
                              color: Colors.white,
                              fontSize: 36*scalor,
                            ),
                          ),
                      
                          SizedBox(
                            width: 200*scalor,
                            height: 200*scalor,
                            // child: Image(
                            //   semanticLabel: "Treasure",
                            //   image: AssetImage(
                            //     'assets/images/treasure_scribby.png'
                            //   )
                            // ),
                          ),
                    
                          Text(
                            "+${gamePlayState.gameResultData["reward"]}",
                            style: GoogleFonts.luckiestGuy(
                              color: const Color.fromARGB(255, 255, 155, 5),
                              fontSize: 25*scalor,
                              shadows: [
                                Shadow(color: const Color.fromARGB(255, 0, 0, 0), offset: Offset.zero, blurRadius: 10),
                                Shadow(color: Colors.white, offset: Offset.zero, blurRadius: 55)
                              ]
                            ),
                          ),                
                    
        
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                // adState.showGameOverRewardedAd(context,gamePlayState,settings);

                                  adState.gameOverRewardedAd?.show(
                                    onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
                                      // Reward logic here
                                      final int coins = Helpers().getUserCoins(settings); // settings.coins.value;
                                      final int rewardAmount = gamePlayState.gameResultData["reward"];
                                      final int xpAmount = gamePlayState.gameResultData["xp"];
                                      final String? rank = gamePlayState.gameResultData["newRank"];
                                      List<Map<dynamic,dynamic>> badgeData = gamePlayState.gameResultData["badges"];
                                      // settings.setCoins(coins + rewardAmount);
                                      FirestoreMethods().updateUserDoc(settings,"coins",(coins + rewardAmount));
                                      settings.setAchievements({"coins":rewardAmount,"xp":xpAmount, "rank":rank, "badges":badgeData});                                      

                                      // Now navigate home and reset
                                      gamePlayState.refreshAllData();
                                    },
                                    
                                  );                                

                                // Reset ad state
                                setState(() {
                                  adState.setGameOverRewardedAd(null);
                                  adState.setIsGameOverRewardedAdLoaded(false);
                                  adState.setIsInterstitialAdLoading(false);

                                  
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                // backgroundColor: const Color.fromARGB(255, 51, 51, 51),
                                // shadowColor: const Color.fromARGB(255, 212, 212, 212),
                                backgroundColor: palette.navigationButtonBg2,
                                foregroundColor: palette.navigationButtonText2,
                                shadowColor: palette.navigationButtonBorder2,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                            
                                    SvgPicture.asset(
                                      'assets/images/play-player-button-of-video-svgrepo-com.svg',
                                      colorFilter: ColorFilter.mode(palette.navigationButtonText2, BlendMode.srcIn),
                                      height: 20*scalor,
                                      width: 20*scalor,
                                    ),
                            
                                    SizedBox(width: 12.0*scalor,),
                            
                                  Text(
                                    "Double Reward!",
                                    style: palette.mainAppFont(
                                      textStyle: TextStyle(
                                        fontSize: 22*scalor,
                                      ),
                                    ) 
                                  ),
                                ],
                              ),
                            ),
                          ),                                                            
                            
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                // int coins = settings.coins.value;
                                // print(gamePlayState.gameResultData);
                                final int reward = gamePlayState.gameResultData["reward"];
                                final int xpAmount = gamePlayState.gameResultData["xp"];
                                final String? rank = gamePlayState.gameResultData["newRank"];
                                List<dynamic> badgeData = gamePlayState.gameResultData["badges"];
                                // settings.setCoins(coins + reward);
                                settings.setAchievements({"coins":reward,"xp":xpAmount, "rank":rank,"badges":badgeData});    
                                executeNavigateHome();     
                                adState.setIsInterstitialAdLoading(false);                     
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: palette.navigationButtonBg2,
                                foregroundColor: palette.navigationButtonText2,
                                shadowColor: palette.navigationButtonBorder2,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                              ),
                              child: Text(
                                "Tap to Claim",
                                    style: palette.mainAppFont(
                                      textStyle: TextStyle(
                                        fontSize: 22*scalor,
                                      ),
                                    ) 
                              ),
                            ),
                          ),                        
                          
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        );
      }
    );
  }
}


class DialogButton extends StatelessWidget {
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double height;
  final Gradient gradient;
  final VoidCallback? onPressed;
  // final Widget child;
  final String body;
  final double scalor;

  const DialogButton({
    Key? key,
    required this.onPressed,
    // required this.child,
    required this.body,
    this.borderRadius,
    this.width,
    this.height = 36.0,
    this.gradient = const LinearGradient(colors: [Color.fromARGB(255, 5, 131, 104), Colors.indigo]),
    required this.scalor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = this.borderRadius ?? BorderRadius.circular(8.0);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: borderRadius,
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
          ),
          child: Text(
            body,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22*scalor,
            ),
          ),
        ),
      ),
    );
  }
}