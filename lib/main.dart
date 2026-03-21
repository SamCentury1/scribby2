import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/ads/ads_controller.dart';
import 'package:scribby_flutter_v2/app_lifecycle/app_lifecycle.dart';
import 'package:scribby_flutter_v2/audio/audio_controller.dart';
import 'package:scribby_flutter_v2/audio/audio_service.dart';
import 'package:scribby_flutter_v2/functions/initializations.dart';
import 'package:scribby_flutter_v2/providers/ad_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/providers/tutorial_state.dart';
import 'package:scribby_flutter_v2/resources/iap_service.dart';
import 'package:scribby_flutter_v2/resources/storage_methods.dart';
import 'package:scribby_flutter_v2/screens/authentication/auth_screen.dart';
import 'package:scribby_flutter_v2/settings/persistence/local_storage_settings_persistence.dart';
import 'package:scribby_flutter_v2/settings/persistence/settings_persistence.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';
import 'firebase_options.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await MobileAds.instance.initialize();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Hive.initFlutter();
  await Hive.openBox('wordBox');

  AdsController? adsController;
  if (kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
    adsController = AdsController(MobileAds.instance);
    adsController.initialize();
  }

  final settings = SettingsController(
    persistence: LocalStorageSettingsPersistence(),
  );

  print("*  *  *  * BEFORE INITIALIZATION *  *  *  *  *  ");
  Initializations().printAllSettingsData(settings);

  await settings.loadStateFromPersistence();

  // Attach and initialise IAP
  final iapService = IAPService();
  iapService.attach(settings);
  await iapService.initialize();  

  final palette = ColorPalette();
  await Initializations().initializeDeviceData(settings);
  palette.getThemeColors(settings.theme.value);

  await Initializations().initializeAppData1(settings);

  print("*  *  *  * AFTER INITIALIZATION *  *  *  *  *  ");
  Initializations().printAllSettingsData(settings);

  runApp(
    MyApp(settings: settings, adsController: adsController, palette: palette),
  );
}

class MyApp extends StatefulWidget {
  final SettingsController settings;
  final AdsController? adsController;
  final ColorPalette palette;
  const MyApp({
    super.key,
    required this.settings,
    required this.adsController,
    required this.palette,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AudioService _audioService;
  // late final GamePlayState _gamePlayState;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _gamePlayState = GamePlayState();
    _audioService = AudioService(
      settings: widget.settings,
      // gamePlayState: _gamePlayState,
    );

    _audioService.init();
    initializeSplashScreen();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _audioService.dispose();
    super.dispose();
  }

  void initializeSplashScreen() async {
    print("pausing...");
    await Future.delayed(const Duration(seconds: 3));
    print("unpausing");
    FlutterNativeSplash.remove();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AppLifecycleObserver(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => GamePlayState()),
          ChangeNotifierProvider(create: (_) => SettingsState()),
          ChangeNotifierProvider(create: (_) => AdState()),
          ChangeNotifierProvider(create: (_) => TutorialState()),
          // ChangeNotifierProvider(create: (_) => AudioService(settings: widget.settings)),
          ChangeNotifierProvider.value(value: widget.palette),
          Provider<AdsController?>.value(value: widget.adsController),
          Provider<SettingsController>.value(value: widget.settings),
          ChangeNotifierProvider<AudioService>(
            create: (context) {
              final service = AudioService(settings: widget.settings);
              // initialize and preload immediately
              service.init().then((_) async {
                await service.preload("assets/audio/sfx/score_tally.wav");
                await service.preload("assets/audio/sfx/score_tally_end.wav");
                await service.preload("assets/audio/sfx/score_tally_end_2.wav");

                await service.preload("assets/audio/sfx/new_rank.wav");

                await service.preload("assets/audio/sfx/special_1.wav");
                await service.preload("assets/audio/sfx/crossword_1.wav");
                await service.preload("assets/audio/sfx/streak_1.wav");
                await service.preload("assets/audio/sfx/thaw_1.wav");
                await service.preload("assets/audio/sfx/thaw_2.wav");
                await service.preload("assets/audio/sfx/perk_select.wav");
                // await service.preload("assets/audio/sfx/special_2.wav");
                // await service.preload("assets/audio/sfx/special_2_2.wav");
                await service.preload("assets/audio/sfx/special_3.wav");

                await service.preload("assets/audio/sfx/tile_undo_1.wav");
                await service.preload("assets/audio/sfx/tile_undo_2.wav");

                await service.preload("assets/audio/sfx/glass_break_1.wav");
                await service.preload("assets/audio/sfx/glass_break_2.wav");

                await service.preload("assets/audio/sfx/freeze_1.wav");
                await service.preload("assets/audio/sfx/freeze_2.wav");
                await service.preload("assets/audio/sfx/freeze_3.wav");
                await service.preload("assets/audio/sfx/freeze_4.wav");

                await service.preload("assets/audio/sfx/tap_1.wav");
                await service.preload("assets/audio/sfx/tap_2.wav");
                await service.preload("assets/audio/sfx/tap_3.wav");
                await service.preload("assets/audio/sfx/tap_4.wav");
                await service.preload("assets/audio/sfx/tap_5.wav");
                await service.preload("assets/audio/sfx/tap_6.wav");                                

                await service.preload("assets/audio/sfx/tile_swap_1.wav");
                await service.preload("assets/audio/sfx/tile_swap_2.wav");

                await service.preload("assets/audio/sfx/tile_kill_1.wav");
                await service.preload("assets/audio/sfx/ding_2.wav");
                await service.preload("assets/audio/sfx/coins.wav");
                await service.preload("assets/audio/sfx/game_over.wav");
                await service.preload("assets/audio/sfx/mission_accomplished.wav");

                for (int i in [1,2,3,4,5,6,7,8,9]) {
                  for (int j in [1,2,3,4,5,6,7,8,9]) {
                    await service.preload("assets/audio/sfx/word_found_${i}_$j.wav");
                  }
                }

              });
              return service;
            },
          ),
          // ProxyProvider2<SettingsController, ValueNotifier<AppLifecycleState>,AudioController>(
          //   lazy: false,
          //   create: (context) => AudioController()..initialize(),
          //   update: (context, settings, lifecycleNotifier, audio) {
          //     if (audio == null) throw ArgumentError.notNull();
          //     audio.attachSettings(settings);
          //     audio.attachLifecycleNotifier(lifecycleNotifier);
          //     return audio;
          //   },
          // create: (context) => AudioController(polyphony: 6),
          // update: (context, settings, lifecycle, audio) {
          //   audio ??= AudioController(polyphony: 6);
          //   audio.attachSettings(settings);
          //   audio.attachLifecycleNotifier(lifecycle);
          //   return audio;
          // },

          //   dispose: (context, audio) => audio.dispose(),
          // ),
          // Provider<SettingsController>(
          //   lazy: false,
          //   create: (context) => SettingsController(
          //     persistence: widget.settingsPersistence
          //   )..loadStateFromPersistence(),
          // ),
        ],
        child: MaterialApp(
          title: "Scribby",
          debugShowCheckedModeBanner: false,
          home: const AuthScreen(),
        ),
      ),
    );
  }
}
