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
import 'package:scribby_flutter_v2/components/scribby_logo_animation.dart';
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
  late Map<String,dynamic>? _userData = {};

  late GamePlayState _gamePlayState;
  late ColorPalette _palette;
  late SettingsState _settingsState;

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
    getUserFromFirebase(_gamePlayState);
    // _checkUsername();
  }    



  Future<void> getUserFromFirebase(GamePlayState gamePlayState) async {
    setState(() {
      isLoading = true;
    });
    final Map<String,dynamic>? userData = await FirestoreMethods().getUserData(AuthService().currentUser!.uid);
    if (userData!.isNotEmpty) {
      gamePlayState.setCurrentLanguage(userData['parameters']['currentLanguage']);
      _settingsState.updateUserData(userData);
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
      MaterialPageRoute(
        builder: (context) => const ChooseLanguage()
      )
    );     
  }



  @override
  void dispose() {
    super.dispose();
  }

  final List<Map<String,dynamic>> translation = [
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
    late String match = translation.firstWhere((element) => element['phrase'] == source)[targetLanguage];
    return match;
  }


  @override
  Widget build(BuildContext context) {

    // final settings = context.watch<SettingsController>();


    return isLoading ? const Center(child: CircularProgressIndicator(),) :
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
                  style: TextStyle(
                    color: palette.textColor1
                  ),
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
            
                    const SizedBox(height: 10,),
                    const Expanded(flex: 1,child: SizedBox()) ,
            
                    const ScribbyLogoAnimation(),
                    // Row(
                    //   children: [
                    //     Center(child: logoLetter("S",1)),
                    //     Center(child: logoLetter("C",2)),
                    //     Center(child: logoLetter("R",1)),
                    //     Center(child: logoLetter("I",1)),
                    //     Center(child: logoLetter("B",3)),
                    //     Center(child: logoLetter("B",3)),
                    //     Center(child: logoLetter("Y",4)),
                    //   ],
                    // ),
                  
                    const Expanded(flex:1,child: SizedBox()),
                    Text("${AuthService().currentUser?.uid.toString()}"),
                    const SizedBox(),
                    Text(_userData?["username"]),
                    const SizedBox(),
                    Text(language),                    
            
                    // const Expanded(flex:1,child: SizedBox()),
              
                    menuSelectionButton(context, translate("New Game",language), const GameScreen()),
                    menuSelectionButton(context, translate("Leaderboards",language), const LeaderboardsScreen()),
                    menuSelectionButton(context, translate("Instructions",language), const InstructionsScreen()),
                    menuSelectionButton(context, translate("Settings",language), const SettingsScreen()),
            
                    // ElevatedButton(
                    //   onPressed: () {
                    //     FirestoreMethods().uploadAlphabet(alphabets);
                    //   }, 
                    //   child: Text("upload alphabets")
                    // ),
            
                    const Expanded(flex:1, child: SizedBox()),
            
                  ],
                ),
              )
            );
          },

        );
    //   },
    // );
  }
}





