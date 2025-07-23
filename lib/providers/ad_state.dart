import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:scribby_flutter_v2/ads/ad_mob_service.dart';
import 'package:scribby_flutter_v2/functions/animations.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/screens/home_screen/home_screen.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';


class AdState extends ChangeNotifier {


  // GAME OVER REWARDED AD
  late bool _isGameOverRewardedAdLoaded = false;
  bool get isGameOverRewardedAdLoaded => _isGameOverRewardedAdLoaded ;
  void setIsGameOverRewardedAdLoaded(bool value) {
    _isGameOverRewardedAdLoaded = value;
    notifyListeners();
  }

  late RewardedAd? _gameOverRewardedAd = null;
  RewardedAd? get gameOverRewardedAd => _gameOverRewardedAd;
  void setGameOverRewardedAd(RewardedAd? value) {
    _gameOverRewardedAd = value;
    notifyListeners();
  }

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

void loadGameOverRewardedAd(BuildContext context, GamePlayState gamePlayState, SettingsController settings) {
  RewardedAd.load(
    adUnitId: AdMobService.rewardedAdUnitId!,
    request: const AdRequest(),
    rewardedAdLoadCallback: RewardedAdLoadCallback(
      onAdLoaded: (ad) {
        _gameOverRewardedAd = ad;
        _isGameOverRewardedAdLoaded = true;

        _gameOverRewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
            loadGameOverRewardedAd(context, gamePlayState, settings);

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen())
            );            
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            ad.dispose();
            loadGameOverRewardedAd(context, gamePlayState, settings);
          },
        );

        _gameOverRewardedAd!.setImmersiveMode(true);
        
        // _gameOverRewardedAd!.show(
        //   onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        //     // Reward logic here
        //     final int coins = settings.coins.value;
        //     final int rewardAmount = gamePlayState.gameResultData["reward"];
        //     settings.setCoins(coins + rewardAmount);

        //     // Now navigate home and reset
        //     Navigator.of(context).pushReplacement(
        //       MaterialPageRoute(builder: (context) => const HomeScreen())
        //     );
        //     gamePlayState.refreshAllData();
        //   },
        // );

        notifyListeners();
      },
      onAdFailedToLoad: (error) {
        debugPrint("Failed to load rewarded ad: $error");
        _isGameOverRewardedAdLoaded = false;
        notifyListeners();
      },
    ),
  );
}  


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


  // GAME OVER REWARDED AD
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
  void loadRewardedAd() {
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
              loadRewardedAd(); // Reload for future use
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              loadRewardedAd();
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







  // BANNER AD
  // GAME OVER REWARDED AD
  late bool _isBannerAdLoaded = false;
  bool get isBannerAdLoaded => _isBannerAdLoaded ;
  void setIsBannerAdLoaded(bool value) {
    _isBannerAdLoaded = value;
    notifyListeners();
  }

  late BannerAd? _bannerAd = null;
  BannerAd? get bannerAd => _bannerAd;
  void setBannerAd(BannerAd? value) {
    _bannerAd = value;
    notifyListeners();
  }

  void initializeBannerAd() {
    String bannerAdId = AdMobService.bannerAdUnitId!;

    _bannerAd = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: bannerAdId, 
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _isBannerAdLoaded = true;
          notifyListeners();
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          // _bannerAd = null;
          _isBannerAdLoaded = false;
          notifyListeners();
        },
      ),
      
      request: const AdRequest()
    )..load();
    notifyListeners();
  }
  // ===================================================


  // =============== INTERSTITIAL AD =======================

  // GAME OVER INTERSTITIAL AD
  late bool _isInterstitialAdLoading = false;
  bool get isInterstitialAdLoading => _isInterstitialAdLoading ;
  void setIsInterstitialAdLoading(bool value) {
    _isInterstitialAdLoading = value;
    notifyListeners();
  }

  void loadGameOverInterstitialAd(GamePlayState gamePlayState) {
    _isInterstitialAdLoading = true;
    try {
      InterstitialAd.load(
          adUnitId: AdMobService.interstitialAdUnitId!,
          request: const AdRequest(),
          adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (InterstitialAd ad) {
              setFullScreenContentCallback(ad,gamePlayState);
              ad.show();
            },
            // Called when an ad request failed.
            onAdFailedToLoad: (LoadAdError error) {
              _isInterstitialAdLoading = false;
            },
          ));
    } catch (e) {
      _isInterstitialAdLoading = false;
    }
  }

  void setFullScreenContentCallback(InterstitialAd ad, GamePlayState gamePlayState) {

    // GamePlayState gamePlayState = context.watch<GamePlayState>();
    ad.fullScreenContentCallback = FullScreenContentCallback(
        // Called when the ad showed the full screen content.
      onAdShowedFullScreenContent: (ad) {
        _isInterstitialAdLoading = false;
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
        // startCountAnimation();

        Animations().startGameOverScreenCountAnimation(gamePlayState);
      },
      // Called when a click is recorded for an ad.
      onAdClicked: (ad) {

      }
    );
  }









}