// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:provider/provider.dart';
// import 'package:scribby_flutter_v2/ads/ad_mob_service.dart';
// import 'package:scribby_flutter_v2/providers/ad_state.dart';

// class GameScreenBannerAd extends StatefulWidget {
//   const GameScreenBannerAd({super.key});

//   @override
//   State<GameScreenBannerAd> createState() => _GameScreenBannerAdState();
// }

// class _GameScreenBannerAdState extends State<GameScreenBannerAd> {

//   // late BannerAd _bannerAd;
//   // bool _isBannerAdLoaded = false;
//   late AdState _adState;



//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _adState = Provider.of<AdState>(context, listen: false);
//     _adState.initializeBannerAd();
//     // initializeBannerAd();
//   }

//   // void initializeBannerAd() {
//   //   String bannerAdId = AdMobService.bannerAdUnitId!;

//   //   _bannerAd = BannerAd(
//   //     size: AdSize.fullBanner,
//   //     adUnitId: bannerAdId, 
//   //     listener: BannerAdListener(
//   //       onAdLoaded: (ad) {
//   //         _isBannerAdLoaded = true;
//   //       },
//   //       onAdFailedToLoad: (ad, error) {
//   //         ad.dispose();
//   //         // _bannerAd = null;
//   //         _isBannerAdLoaded = false;
//   //       },
//   //       // Add other listener callbacks as needed
//   //     ),
//   //     request: const AdRequest()
//   //   )..load();
//   // }

//   @override
//   void dispose() {
//     // TODO: Dispose a BannerAd object
//     _adState.bannerAd?.dispose();
//     super.dispose();
//   }  


//   @override
//   Widget build(BuildContext context) {

//     return Consumer<AdState>(
//       builder: (context,adState,child) {
//         if (adState.isBannerAdLoaded) {
//           return SizedBox(
//             width: adState.bannerAd!.size.width.toDouble(),
//             height: adState.bannerAd!.size.height.toDouble(),
//             child: AdWidget(ad: adState.bannerAd!)
//           );       
//         } else {
//           return SizedBox();
//         }
//       }
//     );
//   }
// }