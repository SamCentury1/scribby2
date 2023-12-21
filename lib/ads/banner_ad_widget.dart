import 'dart:async';

// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/ads/ads_controller.dart';
import 'package:scribby_flutter_v2/ads/preloaded_banner_ad.dart';

/// Displays a banner ad that conforms to the widget's size in the layout,
/// and reloads the ad when the user changes orientation.
///
/// Do not use this widget on platforms that AdMob currently doesn't support.
/// For example:
///
/// ```dart
/// if (kIsWeb) {
///   return Text('No ads here! (Yet.)');
/// } else {
///   return MyBannerAd();
/// }
/// ```
///
/// This widget is adapted from pkg:google_mobile_ads's example code,
/// namely the `anchored_adaptive_example.dart` file:
/// https://github.com/googleads/googleads-mobile-flutter/blob/main/packages/google_mobile_ads/example/lib/anchored_adaptive_example.dart

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  static const useAnchoredAdaptiveSize = true;
  BannerAd? _bannerAd;
  _LoadingState _adLoadingState = _LoadingState.initial;

  late Orientation _currentOrientation;

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentOrientation = MediaQuery.of(context).orientation;
    // _loadAd(); /// added this line following this issue: https://github.com/googleads/googleads-mobile-flutter/issues/78
  }

  // Load (another) ad, disposing of the current ad if there is one.
  Future<void> _loadAd() async {
    if (!mounted) return;
    if (_adLoadingState == _LoadingState.loading ||
        _adLoadingState == _LoadingState.disposing) {
      debugPrint("ad is already being loaded or disposed. aborting");
      return;
    }

    // Check if _bannerAd is not null before disposing
    if (_bannerAd != null) {
      await _bannerAd!.dispose();
    }

    _adLoadingState = _LoadingState.disposing;
    await _bannerAd?.dispose();
    if (!mounted) return;

    setState(() {
      _bannerAd = null;
      _adLoadingState = _LoadingState.loading;
    });

    AdSize size;

    if (useAnchoredAdaptiveSize) {
      final AnchoredAdaptiveBannerAdSize? adaptiveSize =
          await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
              MediaQuery.of(context).size.width.truncate());
      if (adaptiveSize == null) {
        debugPrint("unable to get height of anchored banner");
        size = AdSize.banner;
      } else {
        size = adaptiveSize;
      }
    } else {
      size = AdSize.banner;
    }

    if (!mounted) return;

    // This is a test ad unit ID from
    // https://developers.google.com/admob/android/test-ads. When ready,
    // you replace this with your own, production ad unit ID,
    // created in https://apps.admob.com/.
    _bannerAd = BannerAd(
      size: size,
      adUnitId: Theme.of(context).platform == TargetPlatform.android
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716',
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            // When the ad is loaded, get the ad size and use it to set
            // the height of the ad container.
            _bannerAd = ad as BannerAd;
            _adLoadingState = _LoadingState.loaded;
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint("ad failed to load");
          ad.dispose();
        },
        // onAdImpression: (ad) {
        //   _log.info('Ad impression registered');
        // },
        // onAdClicked: (ad) {
        //   _log.info('Ad click registered');
        // },
      ),
    );
    // return _bannerAd!.load();
    return _bannerAd
        ?.load(); // I changed it to this following this issue: https://github.com/googleads/googleads-mobile-flutter/issues/78
  }

  Future<void> _showPreloadedAd(PreloadedBannerAd ad) async {
    // It's possible that the banner is still loading (even though it started
    // preloading at the start of the previous screen).
    _adLoadingState = _LoadingState.loading;
    try {
      _bannerAd = await ad.ready;
    } on LoadAdError catch (error) {
      debugPrint("Error when loading preloaded banner ad $error");
      unawaited(_loadAd());
      return;
    }

    if (!mounted) return;

    setState(() {
      _adLoadingState = _LoadingState.loaded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (_currentOrientation == orientation &&
            _bannerAd != null &&
            _adLoadingState == _LoadingState.loaded) {
          debugPrint("good to go, show the ad");
          return SizedBox(
            width: _bannerAd!.size.width.toDouble(),
            height: _bannerAd!.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd!),
          );
        }
        // Reload the ad if the orientation changes
        if (_currentOrientation != orientation) {
          debugPrint("orientation changed, relaod ad");
          _currentOrientation = orientation;
          _loadAd();
        }
        return const SizedBox();
      },
    );
  }

  @override
  void initState() {
    super.initState();

    final adsController = context.read<AdsController?>();
    final ad = adsController?.takePreloadedAd();
    if (ad != null) {
      _showPreloadedAd(ad);
    } else {
      _loadAd();
    }
  }
}

enum _LoadingState {
  /// The state before we even start loading anything.
  initial,

  /// The ad is being loaded at this point.
  loading,

  /// The previous ad is being disposed of. After that is done, the next
  /// ad will be loaded.
  disposing,

  /// An ad has been loaded already.
  loaded,
}
