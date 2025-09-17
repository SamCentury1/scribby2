import 'package:flutter/material.dart';
import 'package:scribby_flutter_v2/functions/initializations.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/screens/daily_puzzles_screen/daily_puzzles_screen.dart';
import 'package:scribby_flutter_v2/screens/game_screen/game_screen.dart';
import 'package:scribby_flutter_v2/screens/home_screen/home_screen.dart';
import 'package:scribby_flutter_v2/screens/leaderboards_screen/leaderboards_screen.dart';
import 'package:scribby_flutter_v2/screens/shop_screen/shop_screen.dart';
import 'package:scribby_flutter_v2/screens/statistics_screen.dart/statistics_screen.dart';
import 'package:scribby_flutter_v2/screens/instructions_screen/instructions_screen.dart';
import 'package:scribby_flutter_v2/screens/profile_screen/profile_screen.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';
// import 'package:scribby_flutter_v2/screens/temp_screen.dart';

class HomeScreenUtils {


  void navigateToInstructionsScreen(BuildContext context, bool drawer) {          
    if (drawer) {
      Navigator.pop(context);
    }  
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const InstructionsScreen())
    );      
  }


  void navigateToUserGameHistoryScreen(BuildContext context, bool drawer) async {        

    if (drawer) {
      Navigator.pop(context);
    }  
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const StatsPageView())
      // MaterialPageRoute(builder: (context) => const GameHistoryScreen())
    );      
  }

  void navigateToUserProfileScreen(BuildContext context, bool drawer) async {          
    if (drawer) {
      Navigator.pop(context);
    }  
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ProfileScreen())
    );      
  }  

  void navigateToHomeScreen(BuildContext context, bool drawer) async {          
    if (drawer) {
      Navigator.pop(context);
    }  
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const HomeScreen())
    );      
  }  

  void navigateToLeaderboardsScreen(BuildContext context, bool drawer) async {          
    if (drawer) {
      Navigator.pop(context);
    }  
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const LeaderboardsScreen())
    );      
  }  


  void navigateToShopScreen(BuildContext context, bool drawer) async {          
    if (drawer) {
      Navigator.pop(context);
    }  
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ShopScreen())
    );      
  }  


  void navigateToDailyPuzzlesScreen(BuildContext context, bool drawer) async {          
    if (drawer) {
      Navigator.pop(context);
    }  
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const DailyPuzzlesScreen())
    );      
  }  







  void navigateToTutorial(BuildContext context, GamePlayState gamePlayState, SettingsController settings, ColorPalette palette) async {

      gamePlayState.setGameParameters({
        "gameType":"tutorial",
        "target":null,
        "targetType": null,
        "rows":6,
        "columns":6,
        "durationInMinutes":null,
        "mediaQueryData": MediaQuery.of(context),
      });
      Map<String,dynamic> deviceSizeData = settings.deviceSizeInfo.value as Map<String,dynamic>;
      gamePlayState.setScalor(deviceSizeData["scalor"]);
      Initializations().initializeTime(gamePlayState,"tutorial", null,null);
      Initializations().initializeTileData(gamePlayState,6,6);
      Initializations().initializeElementSizes(gamePlayState,MediaQuery.of(context));
      Initializations().initializeElementPositions(gamePlayState,MediaQuery.of(context));
      // Initializations().initializeDictionary(settings,gamePlayState);

      Initializations().initializeTutorial(settings, gamePlayState,palette);

      print(gamePlayState.gameParameters);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const GameScreen())
        // MaterialPageRoute(builder: (context) => const TempScreen())
      );      
    // }    
  }
 


  
}