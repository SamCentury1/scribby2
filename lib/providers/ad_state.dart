import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/ads/ad_mob_service.dart';
import 'package:scribby_flutter_v2/functions/animations.dart';
import 'package:scribby_flutter_v2/functions/game_logic.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
import 'package:scribby_flutter_v2/screens/home_screen/home_screen.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';


class AdState extends ChangeNotifier {


  // // GAME OVER REWARDED AD
  // late bool _isGameOverRewardedAdLoaded = false;
  // bool get isGameOverRewardedAdLoaded => _isGameOverRewardedAdLoaded ;
  // void setIsGameOverRewardedAdLoaded(bool value) {
  //   _isGameOverRewardedAdLoaded = value;
  //   notifyListeners();
  // }

  // late RewardedAd? _gameOverRewardedAd = null;
  // RewardedAd? get gameOverRewardedAd => _gameOverRewardedAd;
  // void setGameOverRewardedAd(RewardedAd? value) {
  //   _gameOverRewardedAd = value;
  //   notifyListeners();
  // }

  // void loadGameOverRewardedAd() {
  //   RewardedAd.load(
  //     adUnitId: AdMobService.rewardedAdUnitId!,
  //     request: const AdRequest(),
  //     rewardedAdLoadCallback: RewardedAdLoadCallback(
  //       onAdLoaded: (ad) {
  //         _gameOverRewardedAd = ad;
  //         _isGameOverRewardedAdLoaded = true;

  //         _gameOverRewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
  //           onAdDismissedFullScreenContent: (ad) {
  //             ad.dispose();
  //             loadGameOverRewardedAd(); // Reload for future use
  //           },
  //           onAdFailedToShowFullScreenContent: (ad, error) {
  //             ad.dispose();
  //             loadGameOverRewardedAd();
  //           },
  //         );
  //         notifyListeners();
  //       },
  //       onAdFailedToLoad: (error) {
  //         debugPrint("Failed to load rewarded ad: $error");
  //         _isGameOverRewardedAdLoaded = false;
  //         notifyListeners();
  //       },
  //     ),
      
  //   );
  // } 

// void loadGameOverRewardedAd(BuildContext context, GamePlayState gamePlayState, SettingsController settings) {
//   RewardedAd.load(
//     adUnitId: AdMobService.rewardedAdUnitId!,
//     request: const AdRequest(),
//     rewardedAdLoadCallback: RewardedAdLoadCallback(
//       onAdLoaded: (ad) {
//         _gameOverRewardedAd = ad;
//         _isGameOverRewardedAdLoaded = true;

//         _gameOverRewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
//           onAdDismissedFullScreenContent: (ad) {
//             ad.dispose();
//             loadGameOverRewardedAd(context, gamePlayState, settings);

//             Navigator.of(context).pushReplacement(
//               MaterialPageRoute(builder: (context) => const HomeScreen())
//             );            
//           },
//           onAdFailedToShowFullScreenContent: (ad, error) {
//             ad.dispose();
//             loadGameOverRewardedAd(context, gamePlayState, settings);
//           },
//         );

//         _gameOverRewardedAd!.setImmersiveMode(true);
        
//         // _gameOverRewardedAd!.show(
//         //   onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
//         //     // Reward logic here
//         //     final int coins = settings.coins.value;
//         //     final int rewardAmount = gamePlayState.gameResultData["reward"];
//         //     settings.setCoins(coins + rewardAmount);

//         //     // Now navigate home and reset
//         //     Navigator.of(context).pushReplacement(
//         //       MaterialPageRoute(builder: (context) => const HomeScreen())
//         //     );
//         //     gamePlayState.refreshAllData();
//         //   },
//         // );

//         notifyListeners();
//       },
//       onAdFailedToLoad: (error) {
//         debugPrint("Failed to load rewarded ad: $error");
//         _isGameOverRewardedAdLoaded = false;
//         notifyListeners();
//       },
//     ),
//   );
// }  


  // void showGameOverRewardedAd(BuildContext context, GamePlayState gamePlayState, SettingsController settings) {
  //       _gameOverRewardedAd?.show(
  //         onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
  //           // Reward logic here
  //           final int coins = settings.coins.value;
  //           final int rewardAmount = gamePlayState.gameResultData["reward"];
  //           settings.setCoins(coins + rewardAmount);

  //           // Now navigate home and reset
  //           Navigator.of(context).pop();
  //           Navigator.of(context).pushReplacement(
  //             MaterialPageRoute(builder: (context) => const HomeScreen())
  //           );
  //           gamePlayState.refreshAllData();
  //         },
  //       );
  //       notifyListeners();
  // }
  // ===================================================


  // // GAME  REWARDED AD
  late bool _isGameRewardedAdLoaded = false;
  bool get isgameRewardedAdLoaded => _isGameRewardedAdLoaded ;
  void setIsGameRewardedAdLoaded(bool value) {
    _isGameRewardedAdLoaded = value;
    notifyListeners();
  }

  late RewardedAd? _gameRewardedAd = null;
  RewardedAd? get gameRewardedAd => _gameRewardedAd;
  void setGameRewardedAd(RewardedAd? value) {
    _gameRewardedAd = value;
    notifyListeners();
  }
  void loadRewardedAd(GamePlayState gamePlayState, ColorPalette palette) {
    RewardedAd.load(
      adUnitId: AdMobService.rewardedAdUnitId!,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _gameRewardedAd = ad;
          _isGameRewardedAdLoaded = true;

          _gameRewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              loadRewardedAd(gamePlayState,palette); // Reload for future use
              GameLogic().closeTileMenuBuyMoreModal(gamePlayState, palette, 0);
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              loadRewardedAd(gamePlayState,palette);
            },
          );
          notifyListeners();
        },
        
        onAdFailedToLoad: (error) {
          debugPrint("Failed to load rewarded ad: $error");
          _isGameRewardedAdLoaded = false;
          notifyListeners();
        },
      ),
      
    );
  } 



  // // --- Load Rewarded Ad ---
  // void loadRewardedAd(GamePlayState gamePlayState, ColorPalette palette) {
  //   RewardedAd.load(
  //     adUnitId: AdMobService.rewardedAdUnitId!,
  //     request: const AdRequest(),
  //     rewardedAdLoadCallback: RewardedAdLoadCallback(
  //       onAdLoaded: (ad) {
  //         _gameRewardedAd = ad;
  //         _isGameRewardedAdLoaded = true;

  //         _gameRewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
  //           onAdDismissedFullScreenContent: (ad) {
  //             ad.dispose();
  //             _gameRewardedAd = null;
  //             _isGameRewardedAdLoaded = false;
  //             notifyListeners();

  //             // Reload the next ad automatically
  //             loadRewardedAd(gamePlayState, palette);
  //           },
  //           onAdFailedToShowFullScreenContent: (ad, error) {
  //             ad.dispose();
  //             _gameRewardedAd = null;
  //             _isGameRewardedAdLoaded = false;
  //             notifyListeners();

  //             // Reload the next ad
  //             loadRewardedAd(gamePlayState, palette);
  //           },
  //         );

  //         notifyListeners();
  //       },
  //       onAdFailedToLoad: (error) {
  //         debugPrint("Failed to load rewarded ad: $error");
  //         _isGameRewardedAdLoaded = false;
  //         notifyListeners();
  //       },
  //     ),
  //   );
  // }

    // --- Show Rewarded Ad ---
    void showRewardedAd({
      required GamePlayState gamePlayState,
      required ColorPalette palette,
      required VoidCallback onRewardEarned,
      required VoidCallback onAdClosed,
    }) {
      final rewardedAd = _gameRewardedAd;

      if (rewardedAd == null) {
        debugPrint("No rewarded ad ready!");
        return;
      }

      bool didEarnReward = false;

      rewardedAd.show(
        onUserEarnedReward: (ad, reward) {
          didEarnReward = true;
          onRewardEarned(); // grant the reward
        },
      );

      // The FullScreenContentCallback will fire after the ad closes
      rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _gameRewardedAd = null;
          _isGameRewardedAdLoaded = false;
          notifyListeners();

          // Reload next ad
          loadRewardedAd(gamePlayState, palette);

          // Always run the logic after the ad is closed
          onAdClosed();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _gameRewardedAd = null;
          _isGameRewardedAdLoaded = false;
          notifyListeners();

          // Reload next ad
          loadRewardedAd(gamePlayState, palette);

          // Run close logic even if ad fails
          onAdClosed();
        },
      );
    }
  



  // // BANNER AD
  // // GAME OVER REWARDED AD
  // late bool _isBannerAdLoaded = false;
  // bool get isBannerAdLoaded => _isBannerAdLoaded ;
  // void setIsBannerAdLoaded(bool value) {
  //   _isBannerAdLoaded = value;
  //   notifyListeners();
  // }

  // late BannerAd? _bannerAd = null;
  // BannerAd? get bannerAd => _bannerAd;
  // void setBannerAd(BannerAd? value) {
  //   _bannerAd = value;
  //   notifyListeners();
  // }

  // void initializeBannerAd() {
  //   String bannerAdId = AdMobService.bannerAdUnitId!;

  //   _bannerAd = BannerAd(
  //     size: AdSize.fullBanner,
  //     adUnitId: bannerAdId, 
  //     listener: BannerAdListener(
  //       onAdLoaded: (ad) {
  //         _isBannerAdLoaded = true;
  //         notifyListeners();
  //       },
  //       onAdFailedToLoad: (ad, error) {
  //         ad.dispose();
  //         // _bannerAd = null;
  //         _isBannerAdLoaded = false;
  //         notifyListeners();
  //       },
  //     ),
      
  //     request: const AdRequest()
  //   )..load();
  //   notifyListeners();
  // }
  // // ===================================================


  // // =============== INTERSTITIAL AD =======================

  late bool _isInterstitialAdLoading = false;
  bool get isInterstitialAdLoading => _isInterstitialAdLoading ;
  void setIsInterstitialAdLoading(bool value) {
    _isInterstitialAdLoading = value;
    notifyListeners();
  }

  // void loadGameOverInterstitialAd(GamePlayState gamePlayState) {
  //   _isInterstitialAdLoading = true;
  //   try {
  //     InterstitialAd.load(
  //         adUnitId: AdMobService.interstitialAdUnitId!,
  //         request: const AdRequest(),
  //         adLoadCallback: InterstitialAdLoadCallback(
  //           onAdLoaded: (InterstitialAd ad) {
  //             setFullScreenContentCallback(ad,gamePlayState);
  //             ad.show();
  //           },
  //           // Called when an ad request failed.
  //           onAdFailedToLoad: (LoadAdError error) {
  //             _isInterstitialAdLoading = false;
  //           },
  //         ));
  //   } catch (e) {
  //     _isInterstitialAdLoading = false;
  //   }
  // }

  // void setFullScreenContentCallback(InterstitialAd ad, GamePlayState gamePlayState) {

  //   // GamePlayState gamePlayState = context.watch<GamePlayState>();
  //   ad.fullScreenContentCallback = FullScreenContentCallback(
  //       // Called when the ad showed the full screen content.
  //     onAdShowedFullScreenContent: (ad) {
  //       _isInterstitialAdLoading = false;
  //     },
  //     // Called when an impression occurs on the ad.
  //     onAdImpression: (ad) {},
  //     // Called when the ad failed to show full screen content.
  //     onAdFailedToShowFullScreenContent: (ad, err) {
  //       // Dispose the ad here to free resources.
  //       ad.dispose();
  //     },
  //     // Called when the ad dismissed full screen content.
  //     onAdDismissedFullScreenContent: (ad) {
  //       // Dispose the ad here to free resources.
  //       ad.dispose();
  //       // startCountAnimation();

  //       Animations().startGameOverScreenCountAnimation(gamePlayState);
  //     },
  //     // Called when a click is recorded for an ad.
  //     onAdClicked: (ad) {

  //     }
  //   );
  // }








// ======================================================================
// ---------------------- GAME OVER REWARDED AD --------------------------
// ========================================================================
  RewardedAd? _gameOverRewardedAd;
  bool _isGameOverRewardedAdLoading = false;

  bool get isRewardedAdReady => _gameOverRewardedAd != null;

  Future<void> loadGameOverRewardedAd() async {
    if (_isGameOverRewardedAdLoading) return; 
    _isGameOverRewardedAdLoading = true;

    try {
      await RewardedAd.load(
        adUnitId: AdMobService.rewardedAdUnitId!,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            _gameOverRewardedAd = ad;
            _isGameOverRewardedAdLoading = false;
            notifyListeners();
          },
          onAdFailedToLoad: (error) {
            _gameOverRewardedAd = null;
            _isGameOverRewardedAdLoading = false;
            notifyListeners();
            debugPrint("Rewarded ad in Game Over Screen failed to load: $error");
            // notifyListeners();
          },
        ),
      );
    } catch (e) {
      // _gameOverRewardedAd = null;
      _isGameOverRewardedAdLoading = false;
      notifyListeners();
      // notifyListeners();
    }
  }

  // Future<void> showGameOverRewardedAd({
  //   required VoidCallback onRewardEarned,
  //   required VoidCallback onAdClosed,
  // }) async {
  //   if (_gameOverRewardedAd == null) return;

  //   final ad = _gameOverRewardedAd;
  //   _gameOverRewardedAd = null;
  //   notifyListeners();

  //   await ad!.show(
  //     onUserEarnedReward: (ad, reward) => onRewardEarned(),
  //   );
  //   onAdClosed();
  // }

  // @override
  // void dispose() {
  //   _gameOverRewardedAd?.dispose();
  //   super.dispose();
  // }
  // Future<void> showGameOverRewardedAd(BuildContext context) async {
  //   if (_gameOverRewardedAd == null) {
  //     await loadGameOverRewardedAd();
  //     if (_gameOverRewardedAd == null) return;
  //   }

  //   final navigator = Navigator.of(context);

  //   _gameOverRewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
  //     onAdShowedFullScreenContent: (ad) {
  //       debugPrint("Rewarded ad shown.");
  //     },
  //     onAdDismissedFullScreenContent: (ad) {
  //       debugPrint("Rewarded ad dismissed.");

  //       ad.dispose();
  //       _gameOverRewardedAd = null;
  //       _isGameOverRewardedAdLoading = false;
  //       notifyListeners();        

  //       navigator.pop();          // pop GameOverScreen
  //       navigator.pop();          // pop back to HomeScreen
  //     },
  //     onAdFailedToShowFullScreenContent: (ad, error) {
  //       debugPrint("Failed to show rewarded ad: $error");
  //       ad.dispose();
  //       _gameOverRewardedAd = null;
  //       _isGameOverRewardedAdLoading = false;
  //       notifyListeners();
  //     },
  //   );

  //   // Earn reward (but do NOT navigate here)
  //   _gameOverRewardedAd!.setImmersiveMode(true);
  //   _gameOverRewardedAd!.show(
  //     onUserEarnedReward: (ad, reward) {
  //       debugPrint("User earned reward!");

  //       // Update coins, XP, achievements, rank, etc.
  //       final SettingsController settings = Provider.of<SettingsController>(context, listen: false);
  //       final GamePlayState gamePlayState = Provider.of<GamePlayState>(context, listen: false);

  //       // Reward logic here
  //       final int coins = Helpers().getUserCoins(settings); // settings.coins.value;
  //       final int rewardAmount = gamePlayState.gameResultData["reward"];
  //       final int xpAmount = gamePlayState.gameResultData["xp"];
  //       final String? rank = gamePlayState.gameResultData["newRank"];
  //       List<Map<dynamic,dynamic>> badgeData = gamePlayState.gameResultData["badges"];
  //       // settings.setCoins(coins + rewardAmount);
  //       FirestoreMethods().updateUserDoc(settings,"coins",(coins + rewardAmount));
  //       settings.setAchievements({"coins":rewardAmount,"xp":xpAmount, "rank":rank, "badges":badgeData});                                      

  //       // Now navigate home and reset
  //       gamePlayState.refreshAllData();
  //       notifyListeners();       
  //     },
  //   );
  // }
  


  Future<void> showGameOverRewardedAd({
    required VoidCallback onUserEarnedReward,
    required VoidCallback onAdDismissed,
  }) async {
    if (_gameOverRewardedAd == null) return;

    _gameOverRewardedAd!.fullScreenContentCallback =
        FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _gameOverRewardedAd = null;
        loadGameOverRewardedAd(); // Preload next one
        onAdDismissed();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _gameOverRewardedAd = null;
        loadGameOverRewardedAd();
        onAdDismissed();
      },
    );

    _gameOverRewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        onUserEarnedReward();
      },
    );

    _gameOverRewardedAd = null; // Prevent double usage
  }  
}

