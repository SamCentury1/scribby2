abstract class SettingsPersistence {
  /// ========== GET THE DATA ===================
  // Future<bool> getSoundsOn({required bool defaultValue});

  Future<String> getUser();

  // Future<String> getColorTheme();

  // Future<Object> getUserData();

  Future<List<dynamic>> getLevelData();

  
  Future<List<dynamic>> getGameInfoData();

  Future<bool> getSoundsOn({required bool defaultValue});  

  Future<int> getCoins();

  Future<Object> getDeviceSizeInfo();

  Future<Object> getAchievements();

  Future<List<dynamic>> getUserGameHistory();

  Future<Object> getUserData();

  Future<List<dynamic>> getRankData();

  Future<List<dynamic>> getAchievementData();

  Future<int> getXP();  



  /// ========== SAVE THE DATA ===================
  // Future<void> saveSoundsOn(bool value);

  Future<void> saveUser(String value);

  // Future<void> saveColorTheme(String value);

  // Future<void> saveUserData(Object value);

  Future<void> saveLevelData(List<dynamic> value);

  Future<void> saveGameInfoData(List<dynamic> value);  

  Future<void> saveSoundsOn(bool value);  

  Future<void> saveCoins(int value);
  
  Future<void> saveDeviceSizeInfo(Object value);

  Future<void> saveAchievements(Object value);

  Future<void> saveUserGameHistory(List<dynamic> value);  

  Future<void> saveUserData(Object value);

  Future<void> saveRankData(List<dynamic> value);  

  Future<void> saveAchievementData(List<dynamic> value); 

  Future<void> saveXP(int value);       


}
