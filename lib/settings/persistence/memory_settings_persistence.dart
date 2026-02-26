
import 'package:scribby_flutter_v2/settings/persistence/settings_persistence.dart';

/// An in-memory implementation of [SettingsPersistence].
/// Useful for testing.

class MemoryOnlySettingsPersistence implements SettingsPersistence {
  bool soundsOn = true;
  String user = "User";
  String language = 'en';
  String theme = 'default';
  List<dynamic> levelData = [];
  List<dynamic> gameInfoData = [];
  int coins = 10;
  Object deviceSizeInfo = {};
  Object achievements = {};
  List<dynamic> userGameHistory = [];
  Object userData = {};
  List<dynamic> rankData = [];
  List<dynamic> alphabet = [];
  String dictionary = "";
  List<dynamic> achievementData = [];
  int xp = 10;  
  Object dailyPuzzleData = {};
  Object updates = {};

  /// ============= GET ===================
  @override
  Future<bool> getSoundsOn({required bool defaultValue}) async => soundsOn;


  @override
  Future<String> getUser() async => user;

  @override
  Future<String> getLanguage() async => language;  

  @override
  Future<String> getTheme() async => theme;    

  // @override
  // Future<String> getColorTheme() async => darkTheme;

  // @override
  // Future<Object> getUserData() async => userData;

  @override
  Future<List<dynamic>> getLevelData() async => levelData;

  @override
  Future<List<dynamic>> getGameInfoData() async => gameInfoData;  

  @override
  Future<int> getCoins() async => coins;    

  @override
  Future<Object> getDeviceSizeInfo() async => deviceSizeInfo;      

  @override
  Future<Object> getAchievements() async => achievements;              

  @override
  Future<List<dynamic>> getUserGameHistory() async => userGameHistory;  

  @override
  Future<Object> getUserData() async => userData;

  @override
  Future<List<dynamic>> getRankData() async => rankData;  

  @override
  Future<List<dynamic>> getAlphabet() async => alphabet;

  @override
  Future<String> getDictionary() async => dictionary;   

  @override
  Future<List<dynamic>> getAchievementData() async => achievementData;
  
  @override
  Future<int> getXP() async => xp;
  
  @override
  Future<Object> getDailyPuzzleData() async => dailyPuzzleData;

  @override
  Future<Object> getUpdates() async => updates;  
  /// =========== SAVE ========================
  // @override
  // Future<void> saveSoundsOn(bool value) async => soundsOn = value;


  @override
  Future<void> saveUser(String value) async => user = value;

  @override
  Future<void> saveLanguage(String value) async => language = value;  

  @override
  Future<void> saveTheme(String value) async => theme = value;    

  // @override
  // Future<String> saveColorTheme(String value) async => darkTheme = value;

  // @override
  // Future<void> saveUserData(Object value) async => userData = value;


  @override
  Future<void> saveLevelData(List<dynamic> value) async => levelData = value;

  @override
  Future<void> saveGameInfoData(List<dynamic> value) async => gameInfoData = value;

  @override
  Future<void> saveSoundsOn(bool value) async => soundsOn = value;  

  @override
  Future<void> saveCoins(int value) async => coins = value;    

  @override
  Future<void> saveDeviceSizeInfo(Object value) async => deviceSizeInfo = value;    


  @override
  Future<void> saveAchievements(Object value) async => achievements = value;   

  @override
  Future<void> saveUserGameHistory(List<dynamic> value) async => userGameHistory = value;

  @override
  Future<void> saveUserData(Object value) async => userData = value;

  @override
  Future<void> saveRankData(List<dynamic> value) async => rankData = value;

  @override
  Future<void> saveAlphabet(List<dynamic> value) async => alphabet = value;

  @override
  Future<void> saveDictionary(String value) async => dictionary = value;      

  @override
  Future<void> saveAchievementData(List<dynamic> value) async => achievementData = value;

  @override
  Future<void> saveXP(int value) async => xp = value;

  @override
  Future<void> saveDailyPuzzleData(Object value) async => dailyPuzzleData = value; 

  @override
  Future<void> saveUpdates(Object value) async => updates = value;    
}