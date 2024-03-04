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

    // _gamePlayState = Provider.of<GamePlayState>(context, listen: false);
    // _palette = Provider.of<ColorPalette>(context, listen: false);
    // _settingsState = Provider.of<SettingsState>(context, listen: false);
    // _settings = Provider.of<SettingsController>(context, listen: false);
    // _audioController = Provider.of<AudioController>(context, listen: false);

    // getUserFromFirebase(_gamePlayState);
    // _checkUsername();
  }

  // Future<void> getUserFromFirebase(GamePlayState gamePlayState) async {
  //   print("hey you hit the menu screen!");
  //   final String uid = AuthService().currentUser!.uid;
  //   print("you have user id $uid ");


  //   setState(() {
  //     isLoading = true;
  //   });
  //   final Map<String, dynamic>? userData = await FirestoreMethods().getUserData(uid);

  //   print("user data $userData");
  //   if (userData!.isNotEmpty) {

  //     gamePlayState.setCurrentLanguage(userData['parameters']['currentLanguage']);

  //     // saving a copy of the user data in firebase to a Provider class
  //     _settingsState.updateUserData(userData);

  //     // saving the copy of the alphabet to the shared preferences
  //     await FirestoreMethods().saveAlphabetToLocalStorage(uid, _settings);

  //     // Saving a copy of the user data to shared preferences
  //     _settings.setUserData(userData);
      

  //     // get the size factor
  //     Helpers().getSizeFactor(_settingsState, MediaQuery.of(context).size.height);

  //     _palette.getThemeColors(userData['parameters']['darkMode']);

  //     if (userData['username'] == "" || userData['parameters']['currentLanguage'] == "") {    
  //       navigateToChooseLanguage();
  //     }      

  //     String currentLanguage = userData['parameters']['currentLanguage'];

  //     print("current language = $currentLanguage");

  //     List<String> listOfWords = await StorageMethods().downloadWordList(currentLanguage);

  //     gamePlayState.setDictionary(listOfWords);

  //     // log(listOfWords[4142].toString());

  //     setState(() {
  //       // _userData = userData;
  //       isLoading = false;
  //       language = currentLanguage;
  //     });
  //     if (userData['username'] == "") {
  //       setState(() {
  //         // _userData = userData;
  //         isLoading = false;
  //         language = 'english';
  //       });        
  //       navigateToChooseLanguage();
  //       // Navigator.of(context).pushReplacement(
  //       //   MaterialPageRoute(
  //       //     builder: (context) => const ChooseLanguage()
  //       //   )
  //       // );
  //     }
  //   }
  // }

  void navigateToChooseLanguage() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ChooseLanguage()));
  }






  // Future<Map<dynamic, dynamic>> getDataFromStorage() async {
  //   late Map<dynamic, dynamic> res = {};
  //   try {
  //     final Map<dynamic,dynamic> userData = (_settings.userData.value as Map<dynamic, dynamic>);
  //     res = {"userData": userData, };

  //   } catch(error) {
  //     log(error.toString());
  //   }
  //   return res;
  // }

  Future<void> getDataFromStorage() async {

    _gamePlayState = Provider.of<GamePlayState>(context, listen: false);
    _palette = Provider.of<ColorPalette>(context, listen: false);
    _settingsState = Provider.of<SettingsState>(context, listen: false);
    _settings = Provider.of<SettingsController>(context, listen: false);
    _audioController = Provider.of<AudioController>(context, listen: false);


    try {

      final String uid = AuthService().currentUser!.uid;

      final Map<String, dynamic>? userData = await FirestoreMethods().getUserData(uid);
      // final Map<String, dynamic>? userData = await FirestoreMethods().getUserData("caca");



      if (userData != null) {

        log("a user has that id - let's pull that data up");


        // check if the user has any parameters 

        if (userData['username'] == "" || userData['parameters']['currentLanguage'] == "") {    
          navigateToChooseLanguage();

          // String currentLanguage = userData['parameters']['currentLanguage'];

          // print("current language = $currentLanguage");

          // List<String> listOfWords = await StorageMethods().downloadWordList(currentLanguage);

          // _gamePlayState.setDictionary(listOfWords);          
        } else {
          String currentLanguage = userData['parameters']['currentLanguage'];

          language = currentLanguage;

          List<String> listOfWords = await StorageMethods().downloadWordList(currentLanguage);
          _gamePlayState.setDictionary(listOfWords);  

          _gamePlayState.setCurrentLanguage(userData['parameters']['currentLanguage']);

          // saving a copy of the user data in firebase to a Provider class
          _settingsState.updateUserData(userData);

          // saving the copy of the alphabet to the shared preferences
          await FirestoreMethods().saveAlphabetToLocalStorage(uid, _settings);

          // Saving a copy of the user data to shared preferences
          _settings.setUserData(userData);
          

          // get the size factor
          Helpers().getSizeFactor(_settingsState, MediaQuery.of(context).size.height);

          _palette.getThemeColors(userData['parameters']['darkMode']);


        }     

      } else {
        language = "english";
        log("if this appears, there's a problem as new users are supposed to have a doc created in the main file");
        _palette.getThemeColors(true);
        navigateToChooseLanguage();


      }

      

    } catch (error) {
      log(error.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    // final settings = context.watch<SettingsController>();

    // return isLoading ? const Center(child: CircularProgressIndicator(),):


        return FutureBuilder(
          future: getDataFromStorage(),
          builder:(context, snapshot) {
            // print(snapshot.data);
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(),);
            } else if (snapshot.hasError ) {
              return Center(child: Text("Error"),);
            } else {
              // print(snapshot.data!);
              // String language = snapshot.data!['userData']['parameters']['currentLanguage'];

              final Map<String,dynamic> userData = (_settings.userData.value as Map<String, dynamic>);
              return  Consumer<ColorPalette>(
                  builder: (context, palette, child) {
                    return SafeArea(
                      child: Scaffold(
                          appBar: AppBar(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(30.0)
                              )
                            ),
                            title: Text(
                              Helpers().translateText(language, "Home"),
                              style: TextStyle(color: palette.textColor1),
                            ),
                            backgroundColor: palette.appBarColor,
                          ),
                          backgroundColor: palette.screenBackgroundColor,
                          body: Container(
                            color: palette.screenBackgroundColor,
                            child: Column(
                              children: [
                                // const SizedBox(
                                //   height: 10,
                                // ),

                                const Expanded(
                                  flex: 2,  
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(flex: 1, child: SizedBox(),),
                                      Expanded(
                                        flex: 4,
                                        child: ScribbyLogoAnimation()
                                      ),
                                    ],
                                  ),
                                ),

                      
                                

                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [

                                      MenuButtonWidget(
                                        settingsState: _settingsState, 
                                        palette: palette, 
                                        language: language,
                                        body: Helpers().translateText(language, "New Game"),
                                        onPressed: () {  
                                          _audioController.playSfx(SfxType.optionSelected);
                                          if (userData['parameters']['hasSeenTutorial'] == false) {
                                            TutorialHelpers().navigateToTutorial(context);
                                          } else {
                                            Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                builder: (context) => const GameScreen()
                                              ),
                                            );
                                            Helpers().getStates(_gamePlayState, _settings);         
                                          }
                                        },
                                      ),
                                      MenuButtonWidget(
                                        settingsState: _settingsState, 
                                        palette: palette, 
                                        language: language,
                                        body: Helpers().translateText(language, "Leaderboards"),
                                        onPressed: () {
                                          _audioController.playSfx(SfxType.optionSelected);
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const LeaderboardsScreen()),
                                          );
                                        },
                                      ),
                                      MenuButtonWidget(
                                        settingsState: _settingsState, 
                                        palette: palette, 
                                        language: language,
                                        body: Helpers().translateText(language, "Instructions"),
                                        onPressed: () {
                                          _audioController.playSfx(SfxType.optionSelected);
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const InstructionsScreen()),
                                          );
                                        },
                                      ),
                                      MenuButtonWidget(
                                        settingsState: _settingsState, 
                                        palette: palette, 
                                        language: language,
                                        body: Helpers().translateText(language, "Settings"),
                                        onPressed: () {
                                          _audioController.playSfx(SfxType.optionSelected);
                          
                                          Helpers().getStates(_gamePlayState, _settings);
                          
                                          bool darkMode = (_settings.userData.value as Map<String, dynamic>)['parameters']['darkMode'];
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) => SettingsScreen(darkMode: darkMode),
                                            ),
                                                
                                          );
                                        },
                                      ),
                                    ],
                                  )
                                ),

                                const SizedBox(height: 15,),
                              ],
                            ),
                          )),
                    );
                  },
                );
            }
          }         
        );
    //   },
    // );
  }
}



class MenuButtonWidget extends StatelessWidget {
  final SettingsState settingsState;
  final ColorPalette palette;
  final String language;
  final String body;
  final void Function()? onPressed;
  const MenuButtonWidget({
    super.key,
    required this.settingsState,
    required this.palette,
    required this.language,
    required this.body,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16.0 * settingsState.sizeFactor,
        8.0 * settingsState.sizeFactor,
        16.0 * settingsState.sizeFactor,
        8.0 * settingsState.sizeFactor,
      ),
      child: TextButton(
          // decoration: const BoxDecoration(
          //     gradient: LinearGradient(
          //         begin: Alignment.topLeft,
          //         end: Alignment.bottomRight,
          //         colors: <Color>[
          //           Color.fromARGB(255, 87, 87, 87),
          //           Color.fromARGB(255, 87, 87, 87),
          //           // const Color.fromARGB(255, 148, 148, 148),
          //         ],
          //         tileMode: TileMode.mirror),
          //     border: Border(),
          //     borderRadius: BorderRadius.all(Radius.circular(12.0))),        
        // style: ElevatedButton.styleFrom(
        //   backgroundColor: palette.optionButtonBgColor,
        //   foregroundColor: palette.textColor1,
        //   shadowColor:palette.textColor3,
        //   elevation: 3.0,
        //   minimumSize:  Size(double.infinity, 50*settingsState.sizeFactor),
        //   padding: const EdgeInsets.all(8.0),
          
        //   shape: const RoundedRectangleBorder(
        //     borderRadius:
        //       BorderRadius.all(Radius.circular(10.0)
        //     ),
        //   ),
        // ),
        onPressed: onPressed,
        child: Container(
          constraints: BoxConstraints(
            minHeight: 50 * settingsState.sizeFactor
          ),
          decoration: BoxDecoration(
          
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                palette.optionButtonBgColor2,
                palette.optionButtonBgColor3,
                palette.optionButtonBgColor3,
                palette.optionButtonBgColor3,
                palette.optionButtonBgColor3,
              ],
              tileMode: TileMode.mirror),
                
              borderRadius: BorderRadius.all(Radius.circular(10.0 * settingsState.sizeFactor)),  
              boxShadow: const [
                BoxShadow(color: Color.fromARGB(139, 0, 0, 0), offset: Offset(3.0, 3.0), blurRadius: 5.0,)
              ]               
            ),
            



          
          child: Align(
            alignment: Alignment.center,
            child: Text(
              body,
              style: TextStyle(
                fontSize: (24*settingsState.sizeFactor), 
                color: palette.optionButtonTextColor
              ),
            )
          ),
        ),                                    
      ),
    );
  }
}



