import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:scribby_flutter_v2/ads/ad_mob_service.dart';
import 'package:scribby_flutter_v2/ads/pre_loaded_banner_ad.dart';

class AdsController {
  final MobileAds _instance;

//   PreloadedBannerAd? _preloadedAd;

  AdsController(MobileAds instance) : _instance = instance;

//   void dispose() {
//     _preloadedAd?.dispose();
//   }

  Future<void> initialize() async {
    await _instance.initialize();
  }
//   void preloadAd() {
//     // When ready, change this to the Ad Unit IDs provided by AdMob.
//     //       The current values are AdMob's sample IDs.
//     final adUnitId = defaultTargetPlatform == TargetPlatform.android
//         ? 'ca-app-pub-3940256099942544/6300978111'
//         // iOS
//         : 'ca-app-pub-3940256099942544/2934735716';    
//     // final adUnitId = AdMobService.bannerAdUnitId;

//     _preloadedAd = PreloadedBannerAd(size: AdSize.mediumRectangle, adUnitId: adUnitId!);

//     // Wait a bit so that calling at start of a new screen doesn't have
//     // adverse effects on performance.
//     Future<void>.delayed(const Duration(seconds: 1)).then((_) {
//       return _preloadedAd!.load();
//     });
//   }

//   /// Allows caller to take ownership of a [PreloadedBannerAd].
//   ///
//   /// If this method returns a non-null value, then the caller is responsible
//   /// for disposing of the loaded ad.
//   PreloadedBannerAd? takePreloadedAd() {
//     final ad = _preloadedAd;
//     _preloadedAd = null;
//     return ad;
//   }
}

