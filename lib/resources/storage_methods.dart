import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';

class StorageMethods {
  
  Future<void> saveLevelDataFromJsonFileToLocalStorage(SettingsController settings) async {
    print("saveLevelDataFromJsonFileToLocalStorage has been called");
    // Load the JSON file as a string
    final String jsonData = await rootBundle.loadString('assets/json/levels.json');
    // Decode the JSON string into a Map
    final List<dynamic> allLevels = jsonDecode(jsonData);

    settings.setLevelData(allLevels);
    
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

  Future<void> saveRankDataFromJsonFileToLocalStorage(SettingsController settings) async {
    print("saveRankDataFromJsonFileToLocalStorage has been called");
    // Load the JSON file as a string
    final String jsonData = await rootBundle.loadString('assets/json/ranks.json');
    // Decode the JSON string into a Map
    final List<dynamic> allData = jsonDecode(jsonData);
    settings.setRankData(allData);
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
    print("theme has been initialized in storage methods");
    Map<dynamic,dynamic> userData = settings.userData.value as Map<dynamic,dynamic>;
    print("in the theme function: user data: ${userData}");
    settings.setTheme(settings.theme.value);
    // if (userData.isEmpty) {
    //   settings.setTheme("default");
    // } else {
    //   settings.setTheme(userData["parameters"]["theme"]);
    // }
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




  // Future<void> saveWordListToLocalStorage(List<String> wordList, String fileName) async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   final filePath = '${directory.path}/$fileName';
  //   final file = File(filePath);

  //   // Write the word list to the file
  //   await file.writeAsString(wordList.join('\n'));
  // }

}