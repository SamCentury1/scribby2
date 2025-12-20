import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';

class StorageMethods {

  Future<void> saveUserDocumentToLocalStorage(SettingsController settings, Map<String,dynamic> userData) async {
    // Map<String,dynamic> userData = await FirestoreMethods().getFirestoreDocument(user!.uid);
    try {
      settings.setUserData(userData);
    } catch (e,t) {
      debugPrint("an error occured while saving the user data to local storage: $e | $t");
    }
  }
  

  Future<void> saveGameInfoDataFromJsonFileToLocalStorage(SettingsController settings) async {
    print("saveGameInfoDataFromJsonFileToLocalStorage has been called");
    // Load the JSON file as a string
    final String jsonData = await rootBundle.loadString('assets/json/game_types.json');
    // Decode the JSON string into a Map
    final List<dynamic> allData = jsonDecode(jsonData);
    settings.setGameInfoData(allData);
  }   

  Future<void> saveAchievementDataFromJsonFileToLocalStorage(SettingsController settings) async {
    print("saveAchievementDataFromJsonFileToLocalStorage has been called");
    // Load the JSON file as a string
    final String jsonData = await rootBundle.loadString('assets/json/achievements.json');
    // Decode the JSON string into a Map
    final List<dynamic> allData = jsonDecode(jsonData);
    settings.setAchievementData(allData);
  }

  Future<void> saveAchievementDataToLocalStorage(SettingsController settings) async {
    try {
      Map<String,dynamic> userData = settings.userData.value as Map<String,dynamic>;
      if (settings.achievementData.value.isEmpty) {
        final List<dynamic> allData = await FirestoreMethods().downloadAchievements();
        settings.setAchievementData(allData);   
      } else {

        if (userData.isNotEmpty) {
          List<dynamic> allData = settings.achievementData.value;
          Map<String,dynamic> userData =  settings.userData.value as Map<String,dynamic>;
          List<dynamic> gameHistory = userData["gameHistory"];
          List<dynamic> badgesEarned = [];
          for (int i=0; i<gameHistory.length; i++) {
            List<dynamic> badges = gameHistory[i]["gameResultData"]["badges"];
            badgesEarned.addAll(badges);
          }

          for (int i=0; i<badgesEarned.length; i++) {
            Map<String,dynamic> correspondingBadge = allData.firstWhere((e)=>e["badgeKey"]==badgesEarned[i]["badgeKey"],orElse:()=><String,dynamic>{});
            if (correspondingBadge.isNotEmpty) {
              correspondingBadge.update("completed", (v)=>true);
              correspondingBadge.update("dateCompleted", (v)=>badgesEarned[i]["dateCompleted"]);
            }
          }

          settings.setAchievementData(allData);
          print("--------------------------------------");
          print(badgesEarned);
          print("--------------------------------------");
        }
      }
      // Map<dynamic,dynamic> userData = settings.userData.value as Map<dynamic,dynamic>;
      // List<dynamic> userAchievements = userData["achievementData"];
      // final List<dynamic> allData = await FirestoreMethods().downloadAchievements();
      // for (int i=0; i<userAchievements.length; i++) {
      //   Map<dynamic,dynamic> badgeObject = allData.firstWhere((e)=>e["badgeKey"]==userAchievements[i]["badgeKey"],orElse: ()=>{});
      //   if (badgeObject.isNotEmpty) {
      //     badgeObject = userAchievements[i];
      //   }
      // }      
       
    } catch (e,t) {
      debugPrint("an error occured while setting achievement data to local storage: $e | $t");
    }
  }


  Future<void> saveRankDataFromJsonFileToLocalStorage(SettingsController settings) async {
    print("saveRankDataFromJsonFileToLocalStorage has been called");
    // Load the JSON file as a string
    final String jsonData = await rootBundle.loadString('assets/json/ranks.json');
    // Decode the JSON string into a Map
    final List<dynamic> allData = jsonDecode(jsonData);
    settings.setRankData(allData);
  }
  

  Future<void> saveRankDataToLocalStorage(SettingsController settings) async {
    try {
      if (settings.rankData.value.isEmpty) {
        print("rank data is empty - download it and set it to local storage!");
        final List<dynamic> allData = await FirestoreMethods().downloadRanks();
        settings.setRankData(allData);    
      }
    } catch (e,t) {
      debugPrint("an error occured while setting rank data to local storage: $e | $t");
    }
  }  

  Future<void> saveDeviceSizeInfoToSettings(SettingsController settings) async {
    // First get the FlutterView.
    FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;
    Size size = view.physicalSize / view.devicePixelRatio;

    print("----------------- ${view.physicalSize} --------------------");
    double width = size.width;
    double height = size.height;
    final double standardHeight = 890;
    final double scalor = height/standardHeight;

    Object deviceSizeInfo = {
      "width": width,
      "height":height,
      "scalor":scalor,
    };
    settings.setDeviceSizeInfo(deviceSizeInfo);

    print("device size ratio has been initialized in storage methods: ${deviceSizeInfo}");

  }

  Future<void> saveLanguageLocalesToSettings(SettingsController settings) async {
    print("language has been initialized in storage methods");
    final String languageCode = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    settings.setLanguage(languageCode);
  }

  Future<void> initializeThemeColor(SettingsController settings) async {
    // print("theme has been initialized in storage methods");
    Map<dynamic,dynamic> userData = settings.userData.value as Map<dynamic,dynamic>;
    // print("in the theme function: user data: ${userData}");
    if (userData.isEmpty) {
      settings.setTheme("default");
    } else {
      settings.setTheme(userData["parameters"]["theme"]);
    }
  }

  Future<void> clearSettings(SettingsController settings) async {
    // settings.setDeviceSizeInfo({});
    // settings.setLanguage("en");
    // Future.delayed(const Duration(milliseconds: 500), ()  {
      // settings.setTheme("default");
      // settings.setUser("User");
      settings.setUserData({});
      // settings.setCoins(0);
      // settings.setXP(0);
      // settings.setUserGameHistory([]);
      // settings.setAchievements({});
      // settings.setLevelData([]);
      // settings.setGameInfoData([]);
      // settings.setAlphabet([]);
      // settings.setDictionary("");
      // settings.setRankData([]);
      settings.setAchievementData([]);
      // settings.setDailyPuzzleData({});      
    // });
  }
  // Future<void> saveDummyUserToSettings(SettingsController settings, ColorPalette palette) async {
  //   Map<String,dynamic> userData = settings.userData.value as Map<String,dynamic>;
  //   if (userData.isEmpty) {
  //     Object newUserData = {
  //       "username": Helpers().generateRandomUsername(),
  //       "displayName": "User",
  //       "email" : "user@gmail.com",
  //       "rank": "1_1",
  //       "language": "english",
  //       "photoUrl": null,
  //       "soundOn": true,
  //       "colorTheme":"default",
  //       "createdAt": DateTime.now().toIso8601String(),
  //     };
  //     settings.setUserData(newUserData);
  //   } 
  //   if (userData["colorTheme"] != null) {
  //     palette.getThemeColors(userData["colorTheme"]);
  //   } else {
  //     palette.getThemeColors("default");
  //   }    
  // }


  Future<void> saveAlphabetToSettings(SettingsController settings, String currentLanguage) async {
    // Load the JSON file as a string
    final String jsonData = await rootBundle.loadString('assets/json/alphabets.json');

    // Decode the JSON string into a Map
    final Map<String, dynamic> allAlphabets = jsonDecode(jsonData);

    // Check if the specified language exists in the JSON data
    if (!allAlphabets.containsKey(currentLanguage)) {
      throw Exception("Language '$currentLanguage' not found in the JSON data");
    }

    // Extract the list of letters for the specified language
    final List<dynamic> targetAlphabet = allAlphabets[currentLanguage];

    // Convert the list of dynamic objects to a list of maps
    List<Map<String, dynamic>> res = List<Map<String, dynamic>>.from(targetAlphabet.map((item) => item as Map<String, dynamic>));

    settings.setAlphabet(res);
  }

  Future<void> saveAlphabetToLocalStorage(SettingsController settings) async {
    try {
      String currentLanguageLocale = settings.language.value;
      List<Map<String,dynamic>> alphabet = await FirestoreMethods().downloadAlphabet(currentLanguageLocale);
      settings.setAlphabet(alphabet);
    } catch (e,t) {
      debugPrint("an error occured while saving alphabet to local storage: $e | $t");
    }
  }  


  dynamic getDailyPuzzles(SettingsController settings) {
    late dynamic res = {};
    try {
      // print("RUNTIME TYPE: ${settings.dailyPuzzleData.value.runtimeType}");
      dynamic puzzles = settings.dailyPuzzleData.value as dynamic;
      res = puzzles;
    } catch (e,t) {
      print("error in getDailyPuzzles: ${e.toString()} | traceback: $t");
    }

    print("res: $res");
    return res;
  }  


  dynamic getSpecificPuzzle(SettingsController settings, String puzzleId) {
    late dynamic res = {};
    try {
      // print("RUNTIME TYPE: ${settings.dailyPuzzleData.value.runtimeType}");
      dynamic puzzles = settings.dailyPuzzleData.value as dynamic;
      String difficulty = puzzleId.split("-").last;
      res = puzzles[difficulty];
    } catch (e,t) {
      print("error in getDailyPuzzles: ${e.toString()} | traceback: $t");
    }

    print("res: $res");
    return res;
  }  
  // Future<void> saveWordListToLocalStorage(List<String> wordList, String fileName) async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   final filePath = '${directory.path}/$fileName';
  //   final file = File(filePath);

  //   // Write the word list to the file
  //   await file.writeAsString(wordList.join('\n'));
  // }

}