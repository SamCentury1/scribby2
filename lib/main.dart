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
import 'package:scribby_flutter_v2/functions/initializations.dart';
import 'package:scribby_flutter_v2/providers/ad_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/providers/tutorial_state.dart';
import 'package:scribby_flutter_v2/resources/storage_methods.dart';
import 'package:scribby_flutter_v2/screens/authentication/auth_screen.dart';
import 'package:scribby_flutter_v2/settings/persistence/local_storage_settings_persistence.dart';
import 'package:scribby_flutter_v2/settings/persistence/settings_persistence.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';
import 'firebase_options.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);  
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

  final palette = ColorPalette();
  await Initializations().initializeDeviceData(settings);
  palette.getThemeColors(settings.theme.value);

  await Initializations().initializeAppData1(settings);

  print("*  *  *  * AFTER INITIALIZATION *  *  *  *  *  ");
  Initializations().printAllSettingsData(settings);  
  
    
  runApp(MyApp(
    settings: settings,
    adsController: adsController,
    palette: palette,
  ));
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeSplashScreen();

  }

  @override
  void dispose() {
    // TODO: implement dispose
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
          ChangeNotifierProvider(create: (_) => AdState(),),
          ChangeNotifierProvider(create: (_) => TutorialState(),),
          ChangeNotifierProvider.value(value: widget.palette,),
          Provider<AdsController?>.value(value: widget.adsController),
          Provider<SettingsController>.value(value: widget.settings,),
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

