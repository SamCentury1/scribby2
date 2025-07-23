import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {

  static String? get bannerAdUnitId {
    if (Platform.isAndroid) {   
      return 'ca-app-pub-3940256099942544/9214589741'; /// DEVELOPMENT
      // return 'ca-app-pub-2459167095237263/5176346614'; /// PRODUCTION
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2435281174'; /// DEVELOPMENT
      // return 'ca-app-pub-2459167095237263/5678909491'; /// PRODUCTION
    }
    return null;
  }

  static final BannerAdListener bannerAdListener = BannerAdListener(
    onAdLoaded: (ad) => debugPrint('ad loaded'),
    onAdFailedToLoad: (ad,error) {
      ad.dispose();
      debugPrint("ad failed to load: => ${error.toString()}");
    },
    onAdOpened: (ad) => debugPrint("ad opened"),
    onAdClicked: (ad) => debugPrint("ad clicked"),
    onAdClosed: (ad) => debugPrint("ad closed"),
  );



  static String? get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712';  /// DEVELOPMENT
      // return 'ca-app-pub-2459167095237263/4958251976';  /// PRODUCTION
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910'; // DEVELOPMENT
      // return 'ca-app-pub-2459167095237263/7967558693'; // PRODUCTION
    }
    return null;
  }  




  static String? get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/5224354917'; /// DEVELOPMENT
      // return 'ca-app-pub-2459167095237263/6483890554'; /// PRODUCTION 
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/1712485313'; /// DEVELOPMENT
      // return 'ca-app-pub-2459167095237263/8305072833'; /// PRODUCTION
    }
    return null;
  }    
}




