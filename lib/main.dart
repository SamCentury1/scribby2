import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/ads/ads_controller.dart';
import 'package:scribby_flutter_v2/app_lifecycle/app_lifecycle.dart';
import 'package:scribby_flutter_v2/audio/audio_controller.dart';
import 'package:scribby_flutter_v2/firebase_options.dart';
import 'package:scribby_flutter_v2/player_progress/persistence/local_storage_player_progress_persistence.dart';
import 'package:scribby_flutter_v2/player_progress/persistence/player_progress_persistence.dart';
import 'package:scribby_flutter_v2/player_progress/player_progress.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/providers/tutorial_state.dart';
import 'package:scribby_flutter_v2/resources/auth_service.dart';
import 'package:scribby_flutter_v2/screens/welcome_user/welcome_user.dart';
import 'package:scribby_flutter_v2/settings/persistence/local_storage_settings_persistence.dart';
import 'package:scribby_flutter_v2/settings/persistence/settings_persistence.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AuthService().getOrCreateUser(); 
  await MobileAds.instance.initialize();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  AdsController? adsController;
  if (kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
    /// Prepare the google_mobile_ads plugin so that the first ad loads
    /// faster. This can be done later or with a delay if startup
    /// experience suffers.
    adsController = AdsController(MobileAds.instance);
    adsController.initialize();
  }

  runApp(MyApp(
    playerProgressPersistence: LocalStoragePlayerProgressPersistence(),
    settingsPersistence: LocalStorageSettingsPersistence(),
    adsController: adsController,
  ));
}

class MyApp extends StatelessWidget {
  final PlayerProgressPersistence playerProgressPersistence;
  final SettingsPersistence settingsPersistence;
  final AdsController? adsController;
  // final SettingsController settingsController;

  const MyApp(
      {required this.playerProgressPersistence,
      required this.settingsPersistence,
      required this.adsController,
      // required this.settingsController,
      super.key});

  static final defaultDarkColorScheme = ColorScheme.fromSwatch(
      brightness: Brightness.dark,
      primarySwatch: const MaterialColor(20, {12: Colors.black}));

  // This widget is the root sof your application.  
  @override
  Widget build(BuildContext context) {
    return AppLifecycleObserver(
        child: MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          var progress = PlayerProgress(playerProgressPersistence);
          progress.getLatestFromStore();
          return progress;
        }),
        ChangeNotifierProvider(create: (context) => AnimationState(),),
        ChangeNotifierProvider(create: (context) => SettingsState(),),
        ChangeNotifierProvider(create: (context) => GamePlayState(),),
        ChangeNotifierProvider(create: (context) => TutorialState(),),
        ChangeNotifierProvider(create: (context) => ColorPalette(),),

        Provider<AdsController?>.value(value: adsController),
        Provider<SettingsController>(
          lazy: false,
          create: (context) => SettingsController(
            persistence: settingsPersistence,
          )..loadStateFromPerisitence(),
        ),
        ProxyProvider2<SettingsController, ValueNotifier<AppLifecycleState>,AudioController>(
          lazy: false,
          create: (context) => AudioController()..initialize(),
          update: (context, settings, lifecycleNotifier, audio) {
            if (audio == null) throw ArgumentError.notNull();
            audio.attachSettings(settings);
            audio.attachLifecycleNotifier(lifecycleNotifier);
            return audio;
          },
          dispose: (context, audio) => audio.dispose(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Scribby',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(3, 29, 68, 1)),
              useMaterial3: true,
            ),
            home: const WelcomeUser(),
          );
        }
      ),
    ));
  }
}
