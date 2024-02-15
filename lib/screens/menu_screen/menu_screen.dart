// import 'dart:math';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:scribby_flutter_v2/components/scribby_logo_animation.dart';
// import 'package:scribby_flutter_v2/screens/game_screen/game_screen.dart';
// import 'package:scribby_flutter_v2/screens/instructions_screen/instructions_screen.dart';
// import 'package:scribby_flutter_v2/screens/settings_screen/settings_screen.dart';
// import 'package:scribby_flutter_v2/screens/stats_screen/stats_screen.dart';
// import 'package:scribby_flutter_v2/settings/settings.dart';
// import 'package:scribby_flutter_v2/styles/buttons.dart';
// import 'package:scribby_flutter_v2/styles/palette.dart';

// class MenuScreen extends StatefulWidget {
//   const MenuScreen({super.key});

//   @override
//   State<MenuScreen> createState() => _MenuScreenState();
// }

// class _MenuScreenState extends State<MenuScreen> {
//   @override
//   Widget build(BuildContext context) {

//     final settings = context.watch<SettingsController>();
//     final palette = context.watch<Palette>();

//     // final SettingsController settings = Provider.of<SettingsController>(context, listen: false);
//     // final Palette palette = Provider.of<Palette>(context, listen: false);

//         return Scaffold(
//           appBar: AppBar(
//             title: const Text(
//               "Scribby"
//             ),
//             backgroundColor:  Color.fromARGB(255, 9, 1, 34),
//             actions: <Widget>[
//               IconButton(
//                 onPressed: () {},
//                 icon: Icon(Icons.more_vert)
//               )
//             ],
//           ),
//           body: Container(
//             color: settings.darkTheme.value ? palette.darkScreenBgColor : palette.lightScreenBgColor,
//             child: Column(
//               children: [
//                 Text(
//                   settings.darkTheme.value.toString(),
//                   style: TextStyle(
//                     color:Colors.red
//                   ),
//                 ),
//                 const SizedBox(height: 10,),
//                 const Expanded(flex: 1,child: SizedBox()) ,
//                 const ScribbyLogoAnimation(),

//                 const Expanded(flex:1,child: SizedBox()),

//                 menuSelectionButton(context, "New Game", GameScreen()),
//                 menuSelectionButton(context, "Statistics", StatsScreen()),
//                 menuSelectionButton(context, "Instructions", InstructionsScreen()),
//                 menuSelectionButton(context, "Settings", SettingsScreen()),

//                 const Expanded(flex: 1,child: SizedBox())
//               ],
//             ),
//           ),
//         );

//   }
// }

// import 'dart:math';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/audio/audio_controller.dart';
import 'package:scribby_flutter_v2/audio/sounds.dart';
import 'package:scribby_flutter_v2/components/scribby_logo_animation.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
// import 'package:scribby_flutter_v2/functions/game_logic.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/providers/tutorial_state.dart';
import 'package:scribby_flutter_v2/resources/auth_service.dart';
import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
import 'package:scribby_flutter_v2/resources/storage_methods.dart';
import 'package:scribby_flutter_v2/screens/game_screen/game_screen.dart';
import 'package:scribby_flutter_v2/screens/instructions_screen/instructions_screen.dart';
import 'package:scribby_flutter_v2/screens/leaderboards_screen/leaderboards_screen.dart';
// import 'package:scribby_flutter_v2/screens/menu_screen/menu_screen.dart';
import 'package:scribby_flutter_v2/screens/settings_screen/settings_screen.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_helpers.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_screen_1.dart';
// import 'package:scribby_flutter_v2/screens/stats_screen/stats_screen.dart';
import 'package:scribby_flutter_v2/screens/welcome_user/choose_language.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';
// import 'package:scribby_flutter_v2/screens/welcome_user/welcome_user.dart';
// import 'package:scribby_flutter_v2/settings/settings.dart';
// import 'package:scribby_flutter_v2/styles/buttons.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';
import 'package:scribby_flutter_v2/utils/states.dart';
// import 'package:scribby_flutter_v2/utils/states.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // late String _userName = "";

  // late SettingsController _settings;
  late bool isLoading = false;

  // late String _userName;
  // late Map<String, dynamic>? _userData = {};

  late GamePlayState _gamePlayState;
  late ColorPalette _palette;
  late SettingsState _settingsState;
  late SettingsController _settings;
  late AudioController _audioController;


  late String language = "";

  @override
  void initState() {
    super.initState();

    _gamePlayState = Provider.of<GamePlayState>(context, listen: false);
    _palette = Provider.of<ColorPalette>(context, listen: false);
    _settingsState = Provider.of<SettingsState>(context, listen: false);
    _settings = Provider.of<SettingsController>(context, listen: false);
    _audioController = Provider.of<AudioController>(context, listen: false);

    getUserFromFirebase(_gamePlayState);
    // _checkUsername();
  }

  Future<void> getUserFromFirebase(GamePlayState gamePlayState) async {
    final String uid = AuthService().currentUser!.uid;
    setState(() {
      isLoading = true;
    });
    final Map<String, dynamic>? userData = await FirestoreMethods().getUserData(uid);
    if (userData!.isNotEmpty) {


      gamePlayState.setCurrentLanguage(userData['parameters']['currentLanguage']);

      // saving a copy of the user data in firebase to a Provider class
      _settingsState.updateUserData(userData);

      // saving the copy of the alphabet to the shared preferences

      await FirestoreMethods().saveAlphabetToLocalStorage(uid, _settings);

      // Saving a copy of the user data to shared preferences
      _settings.setUserData(userData);

      _palette.getThemeColors(userData['parameters']['darkMode']);

      String currentLanguage = userData['parameters']['currentLanguage'];

      List<String> listOfWords = await StorageMethods().downloadWordList(currentLanguage);

      gamePlayState.setDictionary(listOfWords);

      // log(listOfWords[4142].toString());

      setState(() {
        // _userData = userData;
        isLoading = false;
        language = currentLanguage;
      });
      if (userData['username'] == "") {
        navigateToChooseLanguage();
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(
        //     builder: (context) => const ChooseLanguage()
        //   )
        // );
      }
    }
  }

  void navigateToChooseLanguage() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ChooseLanguage()));
  }

  // void navigateToTutorial() {
  //   late TutorialState tutorialState = context.read<TutorialState>();
  //   // TutorialHelpers().saveStateHistory(tutorialState, tutorialDetails);
  //   TutorialHelpers().getFullTutorialStates2(tutorialState, tutorialDetails);
  //   // TutorialHelpers().getFullTutorialStates(tutorialState, tutorialDetails);
    
  //   Navigator.of(context).pushReplacement(
  //     MaterialPageRoute(
  //       builder: (context) => const TutorialScreen1()
  //     )
  //   );
  // }

  @override
  void dispose() {
    super.dispose();
  }

  // final List<Map<String, dynamic>> translation = [
  //   {
  //     "phrase": "New Game",
  //     "english": "New Game",
  //     "french": "Nouvelle Partie",
  //     "spanish": "Nuevo Juego",
  //   },
  //   {
  //     "phrase": "Leaderboards",
  //     "english": "Leaderboards",
  //     "french": "Classement",
  //     "spanish": "Tabla de clasificación",
  //   },
  //   {
  //     "phrase": "Instructions",
  //     "english": "Instructions",
  //     "french": "Instructions",
  //     "spanish": "Instrucciones",
  //   },
  //   {
  //     "phrase": "Settings",
  //     "english": "Settings",
  //     "french": "Paramètres",
  //     "spanish": "Ajustes",
  //   },
  // ];

  // String translate(String source, String targetLanguage) {
  //   late String match = translation
  //       .firstWhere((element) => element['phrase'] == source)[targetLanguage];
  //   return match;
  // }

  @override
  Widget build(BuildContext context) {
    // final settings = context.watch<SettingsController>();

    return isLoading ? const Center(child: CircularProgressIndicator(),):


        Consumer<ColorPalette>(
            builder: (context, palette, child) {
              return Scaffold(
                  appBar: AppBar(
                    leading: const SizedBox(),
                    title: Text(
                      'Home',
                      style: TextStyle(color: palette.textColor1),
                    ),
                    // backgroundColor: settings.darkTheme.value ? Colors.black : Colors.grey,
                    backgroundColor: palette.appBarColor,
                  ),
                  body: Container(
                    // color: settings.darkTheme.value ? palette.darkScreenBgColor : palette.lightScreenBgColor,
                    // color: GameLogic().getColor(settings.darkTheme.value, palette, "screen_background"),
                    color: palette.screenBackgroundColor,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const Expanded(flex: 1, child: SizedBox()),

                        const ScribbyLogoAnimation(),

                        const Expanded(flex: 1, child: SizedBox()),

                        TextButton(
                            onPressed: () {
                              setState(() {
                                isLoading = true;
                              });

                              _audioController.playSfx(SfxType.optionSelected);


                              if ((_settings.userData.value as Map<String, dynamic>)['parameters']['hasSeenTutorial'] ==false) {
                                TutorialHelpers().navigateToTutorial(context);
                                setState(() {
                                  isLoading = false;
                                });
                              } else {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => const GameScreen()),
                                );
                                Helpers().getStates(_gamePlayState, _settings);

                              }
                            },
                            child: menuButton( 
                              palette, 
                              Helpers().translateText(language, "New Game")
                            )
                          ),

                        TextButton(
                            onPressed: () {
                              _audioController.playSfx(SfxType.optionSelected);
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const LeaderboardsScreen()),
                              );
                            },
                            child: menuButton(
                              palette,
                              Helpers().translateText(language, "Leaderboards")
                            )),

                        TextButton(
                            onPressed: () {
                              _audioController.playSfx(SfxType.optionSelected);

                              Helpers().getStates(_gamePlayState, _settings);

                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const InstructionsScreen()),
                              );
                            },
                            child: menuButton(
                              palette,
                              Helpers().translateText(language, "Instructions")
                            )),

                        TextButton(
                            onPressed: () {
                              _audioController.playSfx(SfxType.optionSelected);

                              Helpers().getStates(_gamePlayState, _settings);

                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SettingsScreen()),
                              );
                            },
                            child: menuButton(
                              palette,
                              Helpers().translateText(language, "Settings")
                            )),


                        const Expanded(flex: 1, child: SizedBox()),
                      ],
                    ),
                  ));
            },
          );
    //   },
    // );
  }
}

Widget menuButton(ColorPalette palette, String body) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
    child: Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                palette.optionButtonBgColor,
                palette.optionButtonBgColor
              ],
              tileMode: TileMode.mirror),
          border: const Border(),
          borderRadius: const BorderRadius.all(Radius.circular(12.0))),
      child: Align(
          alignment: Alignment.center,
          child: Text(
            body,
            style:
                TextStyle(fontSize: 24, color: palette.optionButtonTextColor),
          )),
    ),
  );
}


