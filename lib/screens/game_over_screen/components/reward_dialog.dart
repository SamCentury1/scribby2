


import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/ad_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
import 'package:scribby_flutter_v2/screens/authentication/auth_screen.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';

class RewardDialog extends StatefulWidget {
  final SettingsController settings;
  final VoidCallback onRewardedAdSuccess;  
  const RewardDialog({
    super.key,
    required this.settings,
    required this.onRewardedAdSuccess,
  });

  @override
  State<RewardDialog> createState() => _RewardDialogState();
}

class _RewardDialogState extends State<RewardDialog> {

  late AdState _adState;
  late GamePlayState gamePlayState;
  // late SettingsController settings;


  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    gamePlayState = Provider.of<GamePlayState>(context,listen: false);
    _adState = Provider.of<AdState>(context,listen: false);
    // settings = Provider.of<SettingsController>(context,listen: false);
    
    // _loadRewardedAd();
    // setState(() {
    //   _adState.loadGameOverRewardedAd(context, gamePlayState, settings);
    // });
    //
    // _adState.loadGameOverRewardedAd(); 
  }

  void _navigateHome() {
    gamePlayState.refreshAllData();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const AuthScreen()),
      (_) => false,
    );
  }  

  @override
  void dispose() {
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final palette = Provider.of<ColorPalette>(context);
    final settings = widget.settings;
    final scalor = Helpers().getScalor(settings);

    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          _buildBackground(palette),
          _buildContent(scalor, palette, settings),
        ],
      ),
    );


    // final rewardedAd = context.watch<AdState>().rewardedAd; 
    // late AdState adState = Provider.of<AdState>(context, listen: false);
    // return Consumer<AdState>(
    //   builder: (context,adState,child) {
    //     return Consumer<GamePlayState>(
    //       builder: (context,gamePlayState,child) {

    //         final double scalor = Helpers().getScalor(widget.settings);

    //         // print("------------- ${gamePlayState.gameResultData}");

    //         void executeNavigateHome() {

    //           Navigator.of(context).pushReplacement(
    //             MaterialPageRoute(builder: (context) => const AuthScreen())
    //           );
    //           gamePlayState.refreshAllData();
    //         }

    //         SettingsController settings = Provider.of<SettingsController>(context,listen: false);
    //         ColorPalette palette = Provider.of<ColorPalette>(context,listen: false);
    //         return Dialog(
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.all(Radius.circular(12.0))
    //           ),
    //           backgroundColor: const Color.fromARGB(0, 32, 32, 32),
    //           child: IntrinsicHeight(
    //             child: Stack(
    //               alignment: Alignment.center,
    //               children: [
    //                 Positioned.fill(
    //                   child: Container(
    //                     // width: double.infinity,
    //                     // height: 400,
    //                     decoration: BoxDecoration(
    //                       gradient: RadialGradient(
    //                         colors: [
    //                           Color.fromARGB(255, 208, 233, 253), 
    //                           const Color.fromARGB(255, 17, 71, 219)],
    //                         radius: 0.6
    //                       ),
    //                       borderRadius: BorderRadius.all(Radius.circular(12.0))
    //                     ),
    //                   ),
    //                 ),
    //                 Padding(
    //                   padding: const EdgeInsets.all(8.0),
    //                   child: Column(
    //                     mainAxisSize: MainAxisSize.min,
    //                     children: [
    //                       Text(
    //                         "AWESOME!",
    //                         style: GoogleFonts.luckiestGuy(
    //                           color: Colors.white,
    //                           fontSize: 36*scalor,
    //                         ),
    //                       ),
                      
    //                       SizedBox(
    //                         width: 200*scalor,
    //                         height: 200*scalor,
    //                         // child: Image(
    //                         //   semanticLabel: "Treasure",
    //                         //   image: AssetImage(
    //                         //     'assets/images/treasure_scribby.png'
    //                         //   )
    //                         // ),
    //                       ),
                    
    //                       Text(
    //                         "+${gamePlayState.gameResultData["reward"]}",
    //                         style: GoogleFonts.luckiestGuy(
    //                           color: const Color.fromARGB(255, 255, 155, 5),
    //                           fontSize: 25*scalor,
    //                           shadows: [
    //                             Shadow(color: const Color.fromARGB(255, 0, 0, 0), offset: Offset.zero, blurRadius: 10),
    //                             Shadow(color: Colors.white, offset: Offset.zero, blurRadius: 55)
    //                           ]
    //                         ),
    //                       ),                
    //                       Padding(
    //                         padding: const EdgeInsets.all(8.0),
    //                         child: ElevatedButton(
    //                           onPressed: () {
    //                             // adState.showGameOverRewardedAd(context,gamePlayState,settings);

    //                               // adState.gameOverRewardedAd?.show(
    //                               //   onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
    //                               //     // Reward logic here
    //                               //     final int coins = Helpers().getUserCoins(settings); // settings.coins.value;
    //                               //     final int rewardAmount = gamePlayState.gameResultData["reward"];
    //                               //     final int xpAmount = gamePlayState.gameResultData["xp"];
    //                               //     final String? rank = gamePlayState.gameResultData["newRank"];
    //                               //     List<Map<dynamic,dynamic>> badgeData = gamePlayState.gameResultData["badges"];
    //                               //     // settings.setCoins(coins + rewardAmount);
    //                               //     FirestoreMethods().updateUserDoc(settings,"coins",(coins + rewardAmount));
    //                               //     settings.setAchievements({"coins":rewardAmount,"xp":xpAmount, "rank":rank, "badges":badgeData});                                      

    //                               //     // Now navigate home and reset
    //                               //     gamePlayState.refreshAllData();
    //                               //   },
                                    
    //                               // );                                

    //                             // Reset ad state
    //                             setState(() {
    //                               // adState.setGameOverRewardedAd(null);
    //                               // adState.setIsGameOverRewardedAdLoaded(false);
    //                               // adState.setIsInterstitialAdLoading(false);

                                  
    //                             });
    //                           },
    //                           style: ElevatedButton.styleFrom(
    //                             // backgroundColor: const Color.fromARGB(255, 51, 51, 51),
    //                             // shadowColor: const Color.fromARGB(255, 212, 212, 212),
    //                             backgroundColor: palette.navigationButtonBg2,
    //                             foregroundColor: palette.navigationButtonText2,
    //                             shadowColor: palette.navigationButtonBorder2,
    //                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    //                           ),
    //                           child: Row(
    //                             mainAxisSize: MainAxisSize.min,
    //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                             children: [
                            
    //                                 SvgPicture.asset(
    //                                   'assets/images/play-player-button-of-video-svgrepo-com.svg',
    //                                   colorFilter: ColorFilter.mode(palette.navigationButtonText2, BlendMode.srcIn),
    //                                   height: 20*scalor,
    //                                   width: 20*scalor,
    //                                 ),
                            
    //                                 SizedBox(width: 12.0*scalor,),
                            
    //                               Text(
    //                                 "Double Reward!",
    //                                 style: palette.mainAppFont(
    //                                   textStyle: TextStyle(
    //                                     fontSize: 22*scalor,
    //                                   ),
    //                                 ) 
    //                               ),
    //                             ],
    //                           ),
    //                         ),
    //                       ),                                                            
                            
    //                       Padding(
    //                         padding: const EdgeInsets.all(8.0),
    //                         child: ElevatedButton(
    //                           onPressed: () {
    //                             // int coins = settings.coins.value;
    //                             // print(gamePlayState.gameResultData);
    //                             final int reward = gamePlayState.gameResultData["reward"];
    //                             final int xpAmount = gamePlayState.gameResultData["xp"];
    //                             final String? rank = gamePlayState.gameResultData["newRank"];
    //                             List<dynamic> badgeData = gamePlayState.gameResultData["badges"];
    //                             // settings.setCoins(coins + reward);
    //                             settings.setAchievements({"coins":reward,"xp":xpAmount, "rank":rank,"badges":badgeData});    
    //                             executeNavigateHome();                   
    //                           },
    //                           style: ElevatedButton.styleFrom(
    //                             backgroundColor: palette.navigationButtonBg2,
    //                             foregroundColor: palette.navigationButtonText2,
    //                             shadowColor: palette.navigationButtonBorder2,
    //                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    //                           ),
    //                           child: Text(
    //                             "Tap to Claim",
    //                                 style: palette.mainAppFont(
    //                                   textStyle: TextStyle(
    //                                     fontSize: 22*scalor,
    //                                   ),
    //                                 ) 
    //                           ),
    //                         ),
    //                       ),                        
                          
    //                     ],
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         );
    //       }
    //     );
    //   }
    // );
  }


  Widget _buildContent(double scalor, ColorPalette palette, SettingsController settings) {
    final reward = gamePlayState.gameResultData["reward"];
    final xp = gamePlayState.gameResultData["xp"];
    final rank = gamePlayState.gameResultData["newRank"];
    final badges = gamePlayState.gameResultData["badges"];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _title(scalor),
          const SizedBox(height: 16),

          SizedBox(
            width: 200*scalor,
            height: 200*scalor,
            child: Image(
              semanticLabel: "Treasure",
              image: AssetImage(
                'assets/images/treasure_scribby.png'
              )
            ),
          ),

          Text(
            "+$reward",
            style: GoogleFonts.luckiestGuy(
              color: Colors.orangeAccent,
              fontSize: 28 * scalor,
              shadows: [
                const Shadow(color: Colors.black, blurRadius: 10),
                const Shadow(color: Colors.white, blurRadius: 40),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ---------------------------
          // WATCH AD BUTTON
          // ---------------------------
          Consumer<AdState>(
            builder: (_, adState, __) {
              return ElevatedButton(
                onPressed: adState.isRewardedAdReady
                    ? () {
                        adState.showGameOverRewardedAd(
                          onUserEarnedReward: () {
                            widget.onRewardedAdSuccess();
                          },
                          onAdDismissed: () {
                            // After ad closes, send user home
                            Navigator.of(context).pop();
                            // Goes back to Auth Screen
                            _navigateHome();
                          },
                        );                        
                      }
                    : null,
                style: buttonStyle(palette),
                child: _adButtonContent(scalor, palette),
              );
            },
          ),

          const SizedBox(height: 12),


          // ---------------------------
          // CLAIM NORMAL REWARD
          // ---------------------------
          ElevatedButton(
            onPressed: () {
              settings.setAchievements({
                "coins": reward,
                "xp": xp,
                "rank": rank,
                "badges": badges,
              });
              _navigateHome();
            },
            style: buttonStyle(palette),
            child: Text(
              "Tap to Claim",
              style: palette.mainAppFont(textStyle: TextStyle(fontSize: 22 * scalor)),
            ),
          ),
        ],
      ),
    );
  }

  ButtonStyle buttonStyle(ColorPalette palette) {
    return ElevatedButton.styleFrom(
      backgroundColor: palette.navigationButtonBg2,
      foregroundColor: palette.navigationButtonText2,
      shadowColor: palette.navigationButtonBorder2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }


  Widget _adButtonContent(double scalor, ColorPalette palette) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          'assets/images/play-player-button-of-video-svgrepo-com.svg',
          height: 20 * scalor,
          width: 20 * scalor,
          colorFilter: ColorFilter.mode(palette.navigationButtonText2, BlendMode.srcIn),
        ),
        SizedBox(width: 10 * scalor),
        Text(
          "Double Reward!",
          style: palette.mainAppFont(textStyle: TextStyle(fontSize: 22 * scalor)),
        ),
      ],
    );
  }

  Widget _title(double scalor) {
    return Text(
      "AWESOME!",
      style: GoogleFonts.luckiestGuy(
        color: Colors.white,
        fontSize: 36 * scalor,
      ),
    );
  }


  Widget _buildBackground(ColorPalette palette) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              palette.dialogBg1,
              palette.dialogBg2,
            ],
            radius: 0.6,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }  

}


