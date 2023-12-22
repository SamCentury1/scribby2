// // // import 'package:flutter/foundation.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:google_mobile_ads/google_mobile_ads.dart';

// // // class InterstitialAdWidget extends StatefulWidget {
// // //   const InterstitialAdWidget({super.key});

// // //   @override
// // //   State<InterstitialAdWidget> createState() => _InterstitialAdWidgetState();
// // // }

// // // class _InterstitialAdWidgetState extends State<InterstitialAdWidget> {
// // //   // static const useAnchoredAdaptiveSize = true;
// // //   // late final InterstitialAd _interstitialAd;
// // //   InterstitialAd? _interstitialAd;
// // //   _LoadingState _adLoadingState = _LoadingState.initial;

// // //   @override
// // //   void dispose() {
// // //     _interstitialAd?.dispose();
// // //     super.dispose();
// // //   }

// // //   Future<void> _loadAd() async {
// // //     if (!mounted) return;
// // //     if (_adLoadingState == _LoadingState.loading ||
// // //         _adLoadingState == _LoadingState.disposing) {
// // //       debugPrint(
// // //           "Interstitial ad is already being loaded or disposed. aborting");
// // //       return;
// // //     }

// // //     // Check if _bannerAd is not null before disposing
// // //     if (_interstitialAd != null) {
// // //       await _interstitialAd!.dispose();
// // //     }

// // //     _adLoadingState = _LoadingState.disposing;
// // //     await _interstitialAd?.dispose();
// // //     if (!mounted) return;

// // //     setState(() {
// // //       _interstitialAd = null;
// // //       _adLoadingState = _LoadingState.loading;
// // //     });

// // //     if (!mounted) return;

// // //     return InterstitialAd.load(
// // //       // size: AdSize.
// // //       adUnitId: Theme.of(context).platform == TargetPlatform.android
// // //           ? 'ca-app-pub-3940256099942544/1033173712'
// // //           : 'ca-app-pub-3940256099942544/4411468910',
// // //       request: const AdRequest(),
// // //       adLoadCallback: InterstitialAdLoadCallback(
// // //         // Called when an ad is successfully received.
// // //         onAdLoaded: (ad) {
// // //           debugPrint('$ad loaded.');
// // //           // Keep a reference to the ad so you can show it later.
// // //           // _interstitialAd = ad;
// // //         ad.fullScreenContentCallback = FullScreenContentCallback(
// // //             onAdShowedFullScreenContent: (InterstitialAd ad) =>
// // //                 debugPrint("$ad onAdShowedFullScreenContent"),
// // //             onAdDismissedFullScreenContent: (InterstitialAd ad) {
// // //               debugPrint("$ad onAdDismissedFullScreenContent");
// // //               ad.dispose();
// // //             },
// // //             onAdFailedToShowFullScreenContent:
// // //                 (InterstitialAd ad, AdError error) {
// // //               debugPrint("error: $error");
// // //             },
// // //             onAdImpression: (InterstitialAd ad) {
// // //               debugPrint("impression $ad");
// // //             });
// // //         },
// // //         // Called when an ad request failed.
// // //         onAdFailedToLoad: (LoadAdError error) {
// // //           debugPrint('InterstitialAd failed to load: $error');
// // //         },
// // //       ),
// // //     );
// // //   }

// // //   // Future<void> _showPreloadedAd(PreloadedBannerAd ad) async {
// // //   //   // It's possible that the banner is still loading (even though it started
// // //   //   // preloading at the start of the previous screen).
// // //   //   _adLoadingState = _LoadingState.loading;
// // //   //   try {
// // //   //     _bannerAd = await ad.ready;
// // //   //   } on LoadAdError catch (error) {
// // //   //     debugPrint("Error when loading preloaded banner ad $error");
// // //   //     unawaited(_loadAd());
// // //   //     return;
// // //   //   }

// // //   //   if (!mounted) return;

// // //   //   setState(() {
// // //   //     _adLoadingState = _LoadingState.loaded;
// // //   //   });
// // //   // }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return SizedBox(
// // //       width: double.infinity,
// // //       height: double.infinity,
// // //       child: AdWidget(ad: _interstitialAd),
// // //     );
// // //   }
// // // }

// // // enum _LoadingState {
// // //   /// The state before we even start loading anything.
// // //   initial,

// // //   /// The ad is being loaded at this point.
// // //   loading,

// // //   /// The previous ad is being disposed of. After that is done, the next
// // //   /// ad will be loaded.
// // //   disposing,

// // //   /// An ad has been loaded already.
// // //   loaded,
// // // }
// // import 'package:flutter/foundation.dart';
// // import 'package:flutter/material.dart';
// // import 'package:google_mobile_ads/google_mobile_ads.dart';

// // class ShowInterstitialAd {
// //   Future<void> loadAd() async {
// //     final adUnitId = defaultTargetPlatform == TargetPlatform.android
// //         ? 'ca-app-pub-3940256099942544/1033173712'
// //         : 'ca-app-pub-3940256099942544/4411468910';
// //     return InterstitialAd.load(
// //       // size: AdSize.
// //       adUnitId: adUnitId,
// //       request: const AdRequest(),
// //       adLoadCallback: InterstitialAdLoadCallback(
// //         // Called when an ad is successfully received.
// //         onAdLoaded: (ad) {
// //           debugPrint('$ad loaded.');
// //           // Keep a reference to the ad so you can show it later.
// //           // _interstitialAd = ad;
// //           ad.fullScreenContentCallback = FullScreenContentCallback(
// //               onAdShowedFullScreenContent: (InterstitialAd ad) =>
// //                   debugPrint("$ad onAdShowedFullScreenContent"),
// //               onAdDismissedFullScreenContent: (InterstitialAd ad) {
// //                 debugPrint("$ad onAdDismissedFullScreenContent");
// //                 ad.dispose();
// //               },
// //               onAdFailedToShowFullScreenContent:
// //                   (InterstitialAd ad, AdError error) {
// //                 debugPrint("error: $error");
// //               },
// //               onAdImpression: (InterstitialAd ad) {
// //                 debugPrint("impression $ad");
// //               });
// //         },
// //         // Called when an ad request failed.
// //         onAdFailedToLoad: (LoadAdError error) {
// //           debugPrint('InterstitialAd failed to load: $error');
// //         },
// //       ),
// //     );
// //   }
// // }
// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// class InterstitialAdWidget extends StatefulWidget {
//   const InterstitialAdWidget({super.key});

//   @override
//   State<InterstitialAdWidget> createState() => _InterstitialAdWidgetState();
// }

// class _InterstitialAdWidgetState extends State<InterstitialAdWidget> {
//   InterstitialAd? _interstitialAd;
//   late bool isLoading = false;

//   final adUnitId = Platform.isAndroid
//       ? 'ca-app-pub-3940256099942544/1033173712'
//       : 'ca-app-pub-3940256099942544/4411468910';

//   /// Loads an interstitial ad.

//   @override
//   void initState() {
//     // TO DO: implement initState
//     super.initState();
//     loadAd();
//   }

//   void loadAd() {
//     setState(() {
//       isLoading = true;
//     });
//     try {
//       InterstitialAd.load(
//           adUnitId: adUnitId,
//           request: const AdRequest(),
//           adLoadCallback: InterstitialAdLoadCallback(
//             // Called when an ad is successfully received.
//             onAdLoaded: (InterstitialAd ad) {
//               debugPrint("ad loaded");

//               setState(() {
//                 _interstitialAd = ad;
//                 isLoading = false;
//               });

//               setFullScreenContentCallback(ad);

//               // ad.show();
//               debugPrint('$ad loaded.');
//             },
//             // Called when an ad request failed.
//             onAdFailedToLoad: (LoadAdError error) {
//               debugPrint('InterstitialAd failed to load: $error');
//             },
//           ));
//     } catch (e) {
//       debugPrint(e.toString());
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   void setFullScreenContentCallback(InterstitialAd ad) {
//     ad.fullScreenContentCallback = FullScreenContentCallback(
//         // Called when the ad showed the full screen content.
//         onAdShowedFullScreenContent: (ad) {},
//         // Called when an impression occurs on the ad.
//         onAdImpression: (ad) {},
//         // Called when the ad failed to show full screen content.
//         onAdFailedToShowFullScreenContent: (ad, err) {
//           // Dispose the ad here to free resources.
//           ad.dispose();
//         },
//         // Called when the ad dismissed full screen content.
//         onAdDismissedFullScreenContent: (ad) {
//           // Dispose the ad here to free resources.
//           ad.dispose();
//         },
//         // Called when a click is recorded for an ad.
//         onAdClicked: (ad) {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Positioned.fill(
//       child: SizedBox(),
//     );
//   }
// }
