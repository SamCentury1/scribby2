import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/app_lifecycle/app_lifecycle.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/resources/storage_methods.dart';
import 'package:scribby_flutter_v2/screens/authentication/auth_screen.dart';
import 'package:scribby_flutter_v2/screens/home_screen.dart';
import 'package:scribby_flutter_v2/settings/persistence/local_storage_settings_persistence.dart';
import 'package:scribby_flutter_v2/settings/persistence/settings_persistence.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );  
  // await MobileAds.instance.initialize();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // AdsController? adsController;
  // if (kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
  //   adsController = AdsController(MobileAds.instance);
  //   adsController.initialize();
  // }


    
  runApp(MyApp(
    settingsPersistence: LocalStorageSettingsPersistence(),
    // adsController: adsController,
  ));
}

class MyApp extends StatefulWidget {
  final SettingsPersistence settingsPersistence;
  // final AdsController? adsController;
  const MyApp({
    super.key, 
    required this.settingsPersistence,
    // required this.adsController,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // initializeSplashScreen();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  // void initializeSplashScreen() async {
  //   print("pausing...");
  //   await Future.delayed(const Duration(seconds: 3));
  //   print("unpausing");
  //   FlutterNativeSplash.remove();
  // }


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return AppLifecycleObserver(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => GamePlayState()),
          // ChangeNotifierProvider(create: (_) => SettingsState()),
          // ChangeNotifierProvider(create: (_) => AdState(),),
          ChangeNotifierProvider(create: (_) => ColorPalette(),),
          // ChangeNotifierProvider(create: (_) => TutorialState(),),
          // Provider<AdsController?>.value(value: widget.adsController),
          Provider<SettingsController>(
            lazy: false,
            create: (context) => SettingsController(
              persistence: widget.settingsPersistence
            )..loadStateFromPersistence(),
          ),
        ],
        child: Builder(
          builder: (context)  {




            // palette.getThemeColors("default");
            
            return MaterialApp(
              title: "Scribby",
              debugShowCheckedModeBanner: false,
              home: const AuthScreen(),
            );
          }
        ),
      ),
    );
  }
}

