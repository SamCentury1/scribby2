// // Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// // for details. All rights reserved. Use of this source code is governed by a
// // BSD-style license that can be found in the LICENSE file.

// import 'dart:async';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:provider/provider.dart';
// import 'package:scribby_flutter_v2/ads/ad_mob_service.dart';

// import 'ads_controller.dart';
// import 'pre_loaded_banner_ad.dart';

// /// Displays a banner ad that conforms to the widget's size in the layout,
// /// and reloads the ad when the user changes orientation.
// ///
// /// Do not use this widget on platforms that AdMob currently doesn't support.
// /// For example:
// ///
// /// ```dart
// /// if (kIsWeb) {
// ///   return Text('No ads here! (Yet.)');
// /// } else {
// ///   return MyBannerAd();
// /// }
// /// ```
// ///
// /// This widget is adapted from pkg:google_mobile_ads's example code,
// /// namely the `anchored_adaptive_example.dart` file:
// /// https://github.com/googleads/googleads-mobile-flutter/blob/main/packages/google_mobile_ads/example/lib/anchored_adaptive_example.dart
// class BannerAdWidget extends StatefulWidget {
//   const BannerAdWidget({super.key});

//   @override
//   State<BannerAdWidget> createState() => _BannerAdWidgetState();
// }

// class _BannerAdWidgetState extends State<BannerAdWidget> {

//   static const useAnchoredAdaptiveSize = false;
//   BannerAd? _bannerAd;
//   _LoadingState _adLoadingState = _LoadingState.initial;

//   late Orientation _currentOrientation;

//   @override
//   Widget build(BuildContext context) {
//     return OrientationBuilder(
//       builder: (context, orientation) {
//         if (_currentOrientation == orientation &&
//             _bannerAd != null &&
//             _adLoadingState == _LoadingState.loaded) {
//           return SizedBox(
//             width: _bannerAd!.size.width.toDouble(),
//             height: _bannerAd!.size.height.toDouble(),
//             child: AdWidget(ad: _bannerAd!),
//           );
//         }
//         // Reload the ad if the orientation changes.
//         if (_currentOrientation != orientation) {
//           _currentOrientation = orientation;
//           _loadAd();
//         }
//         return const SizedBox();
//       },
//     );
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _currentOrientation = MediaQuery.of(context).orientation;
//   }

//   @override
//   void dispose() {
//     _bannerAd?.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {

//     print("are we going?");
//     super.initState();

//     final adsController = context.read<AdsController>();
//     final ad = adsController.takePreloadedAd();
//     if (ad != null) {
//       _showPreloadedAd(ad);
//     } else {
//       _loadAd();
//     }
//   }

//   /// Load (another) ad, disposing of the current ad if there is one.
//   Future<void> _loadAd() async {
//     if (!mounted) return;
//     if (_adLoadingState == _LoadingState.loading ||
//         _adLoadingState == _LoadingState.disposing) {
//       return;
//     }
//     _adLoadingState = _LoadingState.disposing;
//     await _bannerAd?.dispose();
//     if (!mounted) return;

//     setState(() {
//       _bannerAd = null;
//       _adLoadingState = _LoadingState.loading;
//     });

//     AdSize size;

//     if (useAnchoredAdaptiveSize) {
//       final AnchoredAdaptiveBannerAdSize? adaptiveSize =
//           await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
//               MediaQuery.of(context).size.width.truncate());

//       if (adaptiveSize == null) {
//         size = AdSize.banner;
//       } else {
//         size = adaptiveSize;
//       }
//     } else {
//       size = AdSize.mediumRectangle;
//     }

//     if (!mounted) return;

//     assert(Platform.isAndroid || Platform.isIOS,
//         'AdMob currently does not support ${Platform.operatingSystem}');
//     _bannerAd = BannerAd(
//       // This is a test ad unit ID from
//       // https://developers.google.com/admob/android/test-ads. When ready,
//       // you replace this with your own, production ad unit ID,
//       // created in https://apps.admob.com/.
//       adUnitId: Theme.of(context).platform == TargetPlatform.android
//           ? 'ca-app-pub-3940256099942544/6300978111'
//           : 'ca-app-pub-3940256099942544/2934735716',
//       // adUnitId: AdMobService.bannerAdUnitId!,
//       size: size,
//       request: const AdRequest(),
//       listener: BannerAdListener(
//         onAdLoaded: (ad) {
//           setState(() {
//             // When the ad is loaded, get the ad size and use it to set
//             // the height of the ad container.
//             _bannerAd = ad as BannerAd;
//             _adLoadingState = _LoadingState.loaded;
//           });
//         },
//         onAdFailedToLoad: (ad, error) {
//           print('Banner failedToLoad: $error');
//           ad.dispose();
//         },
//         onAdImpression: (ad) {
//           print('Ad impression registered');
//         },
//         onAdClicked: (ad) {
//           print('Ad click registered');
//         },
//       ),
//     );
//     return _bannerAd!.load();
//   }

//   Future<void> _showPreloadedAd(PreloadedBannerAd ad) async {
//     // It's possible that the banner is still loading (even though it started
//     // preloading at the start of the previous screen).
//     _adLoadingState = _LoadingState.loading;
//     try {
//       _bannerAd = await ad.ready;
//     } on LoadAdError catch (error) {
//       print('Error when loading preloaded banner: $error');
//       unawaited(_loadAd());
//       return;
//     }
//     if (!mounted) return;

//     setState(() {
//       _adLoadingState = _LoadingState.loaded;
//     });
//   }
// }

// enum _LoadingState {
//   /// The state before we even start loading anything.
//   initial,

//   /// The ad is being loaded at this point.
//   loading,

//   /// The previous ad is being disposed of. After that is done, the next
//   /// ad will be loaded.
//   disposing,

//   /// An ad has been loaded already.
//   loaded,
// }