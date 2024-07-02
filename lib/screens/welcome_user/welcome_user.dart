// import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/audio/audio_controller.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
// import 'package:scribby_flutter_v2/models/tile_model.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/resources/auth_service.dart';
import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
import 'package:scribby_flutter_v2/resources/storage_methods.dart';
import 'package:scribby_flutter_v2/screens/menu_screen/menu_screen.dart';
import 'package:scribby_flutter_v2/screens/welcome_user/choose_language.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class WelcomeUser extends StatefulWidget {
  const WelcomeUser({super.key});

  @override
  State<WelcomeUser> createState() => _WelcomeUserState();
}

class _WelcomeUserState extends State<WelcomeUser> {



  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // final screenWidth = MediaQuery.of(context).size.width;
      // final screenHeight = MediaQuery.of(context).size.height;
      // final sizeFactor = Helpers().getSizeFactor(screenHeight);
      final settingsState = Provider.of<SettingsState>(context, listen: false);
      // settingsState.setSizeFactor(sizeFactor);
      // settingsState.setScreensizedata({"width" : screenWidth, "height": screenHeight});

      final screenwidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height-MediaQuery.of(context).padding.top;
      final gamePlayState = Provider.of<GamePlayState>(context, listen: false);

      final double playAreaHeight = screenHeight - 170;
      final double playAreaWidth = screenwidth > 600.0 ? 600.0 : screenwidth;
      final double minTileSize = playAreaHeight/9;
      final double maxTileSize = (playAreaWidth*0.95)/6;
      late double tileSize = 0.0;
      if (minTileSize > maxTileSize) {
        tileSize = maxTileSize;
      } else {
        tileSize = minTileSize;
      }

      final List<Map<String,dynamic>> decorationDetails = Helpers().getRandomDecorativeSquareDetails(playAreaWidth,playAreaHeight);
      gamePlayState.setDecorationData(decorationDetails);
      gamePlayState.setTileSize(tileSize);
      settingsState.setScreenSizeData({"width" : screenwidth, "height": screenHeight});      
    });
  }



  void navigateToChooseLanguage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const ChooseLanguage()
      )
    );
  }

  void navigateToMainMenu() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const MenuScreen()
      )
    );
  }  
  Future<Map<String,dynamic>?> getUserFromDatabase(
    GamePlayState gamePlayState,
    ColorPalette palette,
    SettingsState settingsState,
    SettingsController settings,
    AudioController audioController,
  ) async {

    Map<String,dynamic> res = {};

    try {

      final String uid = AuthService().currentUser!.uid;

      final Map<String, dynamic>? userData = await FirestoreMethods().getUserData(uid);

      if (userData != null) {

        // saving a copy of the user data in firebase to a Provider class
        settingsState.updateUserData(userData);

        // Saving a copy of the user data to shared preferences
        settings.setUserData(userData); 

        // update size factor of the screen size
        palette.getThemeColors(userData['parameters']['darkMode']);                

        // check if either the language or the username is missing.
        if (userData['parameters']['currentLanguage'] == "") {

          // navigate to the choose language page
          navigateToChooseLanguage();
          

        } else {

          final String currentLanguage = userData['parameters']['currentLanguage'];

          gamePlayState.setCurrentLanguage(currentLanguage);

          List<String> listOfWords = await StorageMethods().downloadWordList(currentLanguage);
          gamePlayState.setDictionary(listOfWords);  
          await FirestoreMethods().saveAlphabetToLocalStorage(uid, settings);

          List<Map<String,dynamic>> initialBoardState = await StorageMethods().downloadInitialBoardState();
          settings.setInitialTileState(initialBoardState);

          List<List<dynamic>> combinations = await StorageMethods().downloadCombinations();
          gamePlayState.setCombinations(combinations);

          Map<dynamic,dynamic> demoStates = await StorageMethods().downloadDemoBoardStates();
          settingsState.setDemoStates(demoStates);

          Map<dynamic,dynamic> demoDynamicLetters = await StorageMethods().downloadDemoStateDynamicLetters();
          settingsState.setDemoLetters(demoDynamicLetters);

          List<Map<String,dynamic>> translations = await StorageMethods().downloadTranslations();
          settingsState.setTranslations(translations);

          navigateToMainMenu();

        }

        res = userData;


      }  else {
        // it seems that when a user first installs, anonymous sign in automatically creates a doc
        // in the main file. so this should never occur. It occurs only when I delete a doc in the
        // db which only happens in dev.
        log("there is a problem, user was never created ");
      }
    
    } catch (error) {
      // debugPrint(error.toString());
    }

    return res;
  }



  @override
  Widget build(BuildContext context) {

    late GamePlayState gamePlayState = Provider.of<GamePlayState>(context, listen: false);
    late ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
    late SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);
    late SettingsController settings = Provider.of<SettingsController>(context, listen: false);
    late AudioController audioController = Provider.of<AudioController>(context, listen: false); 

    

    return FutureBuilder(
      future: getUserFromDatabase(gamePlayState,palette,settingsState,settings,audioController,),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(),);

        } else if (snapshot.hasError ) {

          return const Center(child: Text("Error"),);

        } else {

          // final Map<String, dynamic>? userData = snapshot.data;

          return SafeArea(
            child: Scaffold(
              body: Container(
                color: palette.screenBackgroundColor,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          );
        }
      },
    );
  }
}