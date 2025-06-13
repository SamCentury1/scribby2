import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scribby_flutter_v2/settings/persistence/settings_persistence.dart';

class SettingsController {
  final SettingsPersistence _persistence;

  /// Whether or not the sound is on at all. This overrides both music and sound.

  ValueNotifier<Object> deviceSizeInfo = ValueNotifier({});
  
  ValueNotifier<String> language = ValueNotifier("en");

  ValueNotifier<String> theme = ValueNotifier("default");  

  ValueNotifier<String> user = ValueNotifier("User");

  ValueNotifier<Object> userData = ValueNotifier({});

  ValueNotifier<bool> soundsOn = ValueNotifier(false);

  ValueNotifier<int> coins = ValueNotifier(10);  

  ValueNotifier<int> xp = ValueNotifier(0);

  ValueNotifier<List<dynamic>> userGameHistory = ValueNotifier([]);
  // a temporary object in between the game_over_screen and the home_page which
  // determines how much more coins, xp, and new ranks need to be animating
  ValueNotifier<Object> achievements = ValueNotifier({});


  ValueNotifier<List<dynamic>> levelData = ValueNotifier([]);
  // ValueNotifier<List<dynamic>> campaignData = ValueNotifier([]);
  ValueNotifier<List<dynamic>> gameInfoData = ValueNotifier([]);

  // takes in the JSON document and sets it in local storage
  ValueNotifier<List<dynamic>> rankData = ValueNotifier([]);  
  // takes in the JSON document and sets it in local storage
  ValueNotifier<List<dynamic>> achievementData = ValueNotifier([]); 

  // ValueNotifier<String> colorTheme = ValueNotifier('dark');


  /// Creates a new instance of [SettingsController] backed by [persistence].
  SettingsController({required SettingsPersistence persistence})
      : _persistence = persistence;

  /// Asynchronously loads values from the injected persistence store.

  Future<void> loadStateFromPersistence() async {
    await Future.wait([ // await
      _persistence.getDeviceSizeInfo().then((value)=>deviceSizeInfo.value = value),
      _persistence.getLanguage().then((value) => language.value = value),
      _persistence.getTheme().then((value) => theme.value = value),
      _persistence.getUser().then((value) => user.value = value),
      _persistence.getUserData().then((value) => userData.value = value),
      _persistence.getSoundsOn(defaultValue: kIsWeb).then((value) => soundsOn.value = value),
      _persistence.getCoins().then((value) => coins.value = value),
      _persistence.getXP().then((value) => xp.value = value),
      _persistence.getUserGameHistory().then((value) => userGameHistory.value = value),
      _persistence.getAchievements().then((value) => achievements.value = value),
      _persistence.getLevelData().then((value) => levelData.value = value),
      _persistence.getGameInfoData().then((value) => gameInfoData.value = value),
      _persistence.getRankData().then((value) => rankData.value = value),
      _persistence.getAchievementData().then((value) => achievementData.value = value),
      // _persistence.getColorTheme().then((value) => colorTheme.value = value),

    ]);
  }

  void setDeviceSizeInfo(Object value) {
    deviceSizeInfo.value = value;
    _persistence.saveDeviceSizeInfo(deviceSizeInfo.value);    
  }  

  void setLanguage(String value) {
    language.value = value;
    _persistence.saveLanguage(language.value);
  }  


  void setTheme(String value) {
    theme.value = value;
    _persistence.saveTheme(theme.value);
  }  

  void setUser(String value) {
    user.value = value;
    _persistence.saveUser(user.value);
  }  

  void setUserData(Object value) {
    userData.value = value;
    _persistence.saveUserData(userData.value);
  }  

  void toggleSoundOn() {
    soundsOn.value = !soundsOn.value;
    _persistence.saveSoundsOn(soundsOn.value);
  }

  void setCoins(int value) {
    coins.value = value;
    _persistence.saveCoins(coins.value);
  } 

  void setXP(int value) {
    xp.value = value;
    _persistence.saveXP(xp.value);
  } 

  void setUserGameHistory(List<dynamic> value) {
    userGameHistory.value = value;
    _persistence.saveUserGameHistory(userGameHistory.value);
  }
  
  void setAchievements(Object value) {
    achievements.value = value;
    _persistence.saveAchievements(achievements.value);
  }  

  void setLevelData(List<dynamic> value) {
    levelData.value = value;
    _persistence.saveLevelData(levelData.value);
  }

  void setGameInfoData(List<dynamic> value) {
    gameInfoData.value = value;
    _persistence.saveGameInfoData(gameInfoData.value);
  }  

  void setRankData(List<dynamic> value) {
    rankData.value = value;
    _persistence.saveRankData(rankData.value);
  }  

  void setAchievementData(List<dynamic> value) {
    achievementData.value = value;
    _persistence.saveAchievementData(achievementData.value);
  }


}
