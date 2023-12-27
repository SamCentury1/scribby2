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
import 'package:scribby_flutter_v2/resources/auth_service.dart';
import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
import 'package:scribby_flutter_v2/screens/game_screen/game_screen.dart';
import 'package:scribby_flutter_v2/screens/instructions_screen/instructions_screen.dart';
import 'package:scribby_flutter_v2/screens/leaderboards_screen/leaderboards_screen.dart';
// import 'package:scribby_flutter_v2/screens/menu_screen/menu_screen.dart';
import 'package:scribby_flutter_v2/screens/settings_screen/settings_screen.dart';
// import 'package:scribby_flutter_v2/screens/stats_screen/stats_screen.dart';
import 'package:scribby_flutter_v2/screens/welcome_user/choose_language.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';
// import 'package:scribby_flutter_v2/screens/welcome_user/welcome_user.dart';
// import 'package:scribby_flutter_v2/settings/settings.dart';
import 'package:scribby_flutter_v2/styles/buttons.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';
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
  late Map<String, dynamic>? _userData = {};

  late GamePlayState _gamePlayState;
  late ColorPalette _palette;
  late SettingsState _settingsState;
  late SettingsController _settings;
  late AudioController _audioController;

  // Future<void> readPrefs() async {
  //   final SharedPreferences prefs = await _prefs;
  //   final String userName = (prefs.getString('user') ?? "");

  //   // if (userName == "") {
  //   //   Navigator.of(context).pushAndRemoveUntil(
  //   //     MaterialPageRoute(
  //   //       builder: (context) => SettingsSc
  //   //     ),
  //   //     ModalRoute.withName('/'),
  //   //   );
  //   // }
  // }

  // late SharedPreferences _prefs;
  // bool _hasUsername = false;

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
    final Map<String, dynamic>? userData =
        await FirestoreMethods().getUserData(uid);
    if (userData!.isNotEmpty) {
      gamePlayState
          .setCurrentLanguage(userData['parameters']['currentLanguage']);

      // saving a copy of the user data in firebase to a Provider class
      _settingsState.updateUserData(userData);

      // saving the copy of the alphabet to the shared preferences

      await FirestoreMethods().saveAlphabetToLocalStorage(uid, _settings);

      // Saving a copy of the user data to shared preferences
      _settings.setUserData(userData);

      _palette.getThemeColors(userData['parameters']['darkMode']);
      setState(() {
        _userData = userData;
        isLoading = false;
        language = userData['parameters']['currentLanguage'];
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

  @override
  void dispose() {
    super.dispose();
  }

  final List<Map<String, dynamic>> translation = [
    {
      "phrase": "New Game",
      "english": "New Game",
      "french": "Nouvelle Partie",
      "spanish": "Nuevo Juego",
    },
    {
      "phrase": "Leaderboards",
      "english": "Leaderboards",
      "french": "Classement",
      "spanish": "Tabla de clasificación",
    },
    {
      "phrase": "Instructions",
      "english": "Instructions",
      "french": "Instructions",
      "spanish": "Instrucciones",
    },
    {
      "phrase": "Settings",
      "english": "Settings",
      "french": "Paramètres",
      "spanish": "Ajustes",
    },
  ];

  String translate(String source, String targetLanguage) {
    late String match = translation
        .firstWhere((element) => element['phrase'] == source)[targetLanguage];
    return match;
  }

  @override
  Widget build(BuildContext context) {
    // final settings = context.watch<SettingsController>();

    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        :
        // ValueListenableBuilder(
        //   valueListenable: settings.darkTheme,
        //   builder: (context,darkTheme,child) {

        // if (AuthService().currentUser!.uid == null ) {
        //   return WelcomeUser();
        // }
        // if (_userName == "") {
        //   return WelcomeUser();
        // }
        // if (_userData?["username"] == "") {
        //   return ChooseLanguage();
        // }

        Consumer<ColorPalette>(
            builder: (context, palette, child) {
              return Scaffold(
                  appBar: AppBar(
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
                              _audioController.playSfx(SfxType.optionSelected);

                              Helpers().getStates(_gamePlayState, _settings);

                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const GameScreen()),
                              );
                            },
                            child: menuButton(
                              palette,
                              translate("New Game", language),
                            )),

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
                              translate("Leaderboards", language),
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
                              translate("Instructions", language),
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
                              translate("Settings", language),
                            )),

                        // menuSelectionButton(
                        //     context,
                        //     translate("Leaderboards", language),
                        //     const LeaderboardsScreen()),
                        // menuSelectionButton(
                        //     context,
                        //     translate("Instructions", language),
                        //     const InstructionsScreen()),
                        // menuSelectionButton(
                        //     context,
                        //     translate("Settings", language),
                        //     const SettingsScreen()),

                        // ElevatedButton(
                        //   onPressed: () {
                        //     FirestoreMethods().uploadAlphabet(alphabets);
                        //   },
                        //   child: Text("upload alphabets")
                        // ),

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

// Widget menuSelectionButton(BuildContext context, String body, Widget target) {
//   return Padding(
//     padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
//     child: Container(
//       width: double.infinity,
//       height: 50,
//       decoration: const BoxDecoration(
//           gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: <Color>[
//                 Color.fromARGB(255, 87, 87, 87),
//                 Color.fromARGB(255, 87, 87, 87),
//                 // const Color.fromARGB(255, 148, 148, 148),
//               ],
//               tileMode: TileMode.mirror),
//           border: Border(),
//           borderRadius: BorderRadius.all(Radius.circular(12.0))),
//       child: InkWell(
//         onTap: () {
//           audioController.playSfx(SfxType.optionSelected);
//           // Future.delayed(const Duration(milliseconds: 400), () {
//           Navigator.of(context).pushAndRemoveUntil(
//             MaterialPageRoute(builder: (context) => target),
//             ModalRoute.withName('/'),
//           );
//           // });
//         },
//         child: Align(
//           alignment: Alignment.center,
//           child: Text(
//             body,
//             style: const TextStyle(
//                 fontSize: 22, color: Color.fromARGB(255, 235, 235, 235)),
//           ),
//         ),
//       ),
//     ),
//   );
// }
