import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
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

  }

  Future<void> saveDummyUserToSettings(SettingsController settings, ColorPalette palette) async {
    Map<String,dynamic> userData = settings.userData.value as Map<String,dynamic>;
    if (userData.isEmpty) {
      Object newUserData = {
        "username": Helpers().generateRandomUsername(),
        "displayName": "User",
        "email" : "user@gmail.com",
        "rank": "1_1",
        "language": "english",
        "photoUrl": null,
        "soundOn": true,
        "colorTheme":"default",
        "createdAt": DateTime.now().toIso8601String(),
      };
      settings.setUserData(newUserData);
    } 
    if (userData["colorTheme"] != null) {
      palette.getThemeColors(userData["colorTheme"]);
    } else {
      palette.getThemeColors("default");
    }    
  }
}