import 'dart:async'; // Completer

import 'package:google_mobile_ads/google_mobile_ads.dart'; // AdSize, AdRequest, BannerAd, BannerAdListener

class PreloadedBannerAd {
  /// something like [AdSize.mediumRectangle]
  final AdSize size;

  final AdRequest _adRequest;

  BannerAd? _bannerAd;

  final String adUnitId;

  final _adCompleter = Completer<BannerAd>();

  PreloadedBannerAd({
    required this.size,
    required this.adUnitId,
    AdRequest? adRequest,
  }) : _adRequest = adRequest ?? const AdRequest();

  Future<BannerAd> get ready => _adCompleter.future;

  Future<void> load() {
    _bannerAd = BannerAd(
      size: size,
      adUnitId: adUnitId,
      request: _adRequest,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _adCompleter.complete(_bannerAd);
        },
        onAdFailedToLoad: (ad, error) {
          _adCompleter.completeError(error);
          ad.dispose();
        },
        // onAdImpression: (ad) {
        //   //_log.info('Ad impression registered');
        // },
        // onAdClicked: (ad) {
        //   //_log.info('Ad click registered');
        // },
      ),
    );

    return _bannerAd!.load();
  }

  void dispose() {
    _bannerAd?.dispose();
  }
}

// class PreloadedInterstitialAd {
//   /// something like [AdSize.mediumRectangle]
//   final AdSize size;

//   final AdRequest _adRequest;

//   InterstitialAd? _interstitialAd;

//   final String adUnitId;

//   final _adCompleter = Completer<InterstitialAd>(); 

//   PreloadedInterstitialAd({
//     required this.size,
//     required this.adUnitId,
//     AdRequest? adRequest,
//   }) : _adRequest = adRequest ?? const AdRequest();

//   Future<InterstitialAd> get ready => _adCompleter.future;

//   Future<void> load() {
    
//     _interstitialAd = InterstitialAd.load(
//       // size: size, 
//       adUnitId: adUnitId, 
//       request: _adRequest,
//       listener: BannerAdListener(
//         onAdLoaded: (ad) {
//           _adCompleter.complete(_interstitialAd);
//         },
//         onAdFailedToLoad: (ad,error) {
//           _adCompleter.completeError(error);
//           ad.dispose();          
//         },
//         // onAdImpression: (ad) {
//         //   //_log.info('Ad impression registered');
//         // },
//         // onAdClicked: (ad) {
//         //   //_log.info('Ad click registered');
//         // },
//       ), 
//     );

//     return _interstitialAd!.load();
//   }

//   void dispose() {
//     _interstitialAd?.dispose();
//   }
// }
