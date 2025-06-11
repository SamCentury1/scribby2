import 'package:scribby_flutter_v2/settings/persistence/settings_persistence.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// An implementation of [SettingsPersistence] that uses
/// `package:shared_preferences`.

class LocalStorageSettingsPersistence extends SettingsPersistence {
  final Future<SharedPreferences> instanceFuture = SharedPreferences.getInstance();

  /// ========= GET THE DATA =================

  @override
  Future<bool> getSoundsOn({required bool defaultValue}) async {
    final prefs = await instanceFuture;
    return prefs.getBool('soundsOn') ?? defaultValue;
  }

  @override
  Future<String> getUser() async {
    final prefs = await instanceFuture;
    return prefs.getString('user') ?? "";
  }

  // @override
  // Future<String> getColorTheme() async {
  //   final prefs = await instanceFuture;
  //   return prefs.getString('colorTheme') ?? 'dark';
  // }

  // @override
  // Future<Object> getUserData() async {
  //   final prefs = await instanceFuture;
  //   return json.decode(prefs.getString('userData') ?? json.encode([]));
  // }
  @override
  Future<List<dynamic>> getLevelData() async {
    final prefs = await instanceFuture;
    return json.decode(prefs.getString("levelData")??json.encode([]));
  }

  @override
  Future<List<dynamic>> getGameInfoData() async {
    final prefs = await instanceFuture;
    return json.decode(prefs.getString("gameInfoData")??json.encode([]));
  }

  @override
  Future<int> getCoins() async {
    final prefs = await instanceFuture;
    return prefs.getInt('coins')??10;
  }

  @override
  Future<Object> getDeviceSizeInfo() async {
    final prefs = await instanceFuture;
    return json.decode(prefs.getString("deviceSizeInfo")??json.encode({}));
  }  
  @override
  Future<Object> getAchievements() async {
    final prefs = await instanceFuture;
    return json.decode(prefs.getString("achievements")??json.encode({}));
  }


  @override
  Future<List<dynamic>> getUserGameHistory() async {
    final prefs = await instanceFuture;
    return json.decode(prefs.getString("userGameHistory")??json.encode([]));
  }

  @override
  Future<Object> getUserData() async {
    final prefs = await instanceFuture;
    return json.decode(prefs.getString("userData")??json.encode({}));
  }


  @override
  Future<List<dynamic>> getRankData() async {
    final prefs = await instanceFuture;
    return json.decode(prefs.getString("rankData")??json.encode([]));
  }

  @override
  Future<List<dynamic>> getAchievementData() async {
    final prefs = await instanceFuture;
    return json.decode(prefs.getString("achievementData")??json.encode([]));
  }

  @override
  Future<int> getXP() async {
    final prefs = await instanceFuture;
    return prefs.getInt('xp')??0;
  }  



  /// ========= SAVE THE DATA =================

  // @override
  // Future<void> saveSoundsOn(bool value) async {
  //   final prefs = await instanceFuture;
  //   await prefs.setBool('soundsOn', value);
  // }

  @override
  Future<void> saveUser(String value) async {
    final prefs = await instanceFuture;
    await prefs.setString('user', value);
  }

  // @override
  // Future<void> saveColorTheme(String value) async {
  //   final prefs = await instanceFuture;
  //   await prefs.setString('colorTheme', value);
  // }

  // @override
  // Future<void> saveUserData(Object value) async {
  //   final prefs = await instanceFuture;
  //   await prefs.setString('userData', json.encode(value));
  // }
   

  @override
  Future<void> saveLevelData(List<dynamic> value) async {
    final prefs = await instanceFuture;
    prefs.setString("levelData", json.encode(value)); 
  }

  @override
  Future<void> saveGameInfoData(List<dynamic> value) async {
    final prefs = await instanceFuture;
    prefs.setString("gameInfoData", json.encode(value)); 
  }  

  @override
  Future<void> saveSoundsOn(bool value) async {
    final prefs = await instanceFuture;
    prefs.setBool("soundsOn", value); 
  }    


  @override
  Future<void> saveCoins(int value) async {
    final prefs = await instanceFuture;
    prefs.setInt("coins", value); 
  }   

  @override
  Future<void> saveDeviceSizeInfo(Object value) async {
    final prefs = await instanceFuture;
    prefs.setString("deviceSizeInfo", json.encode(value)); 
  }     
  @override
  Future<void> saveAchievements(Object value) async {
    final prefs = await instanceFuture;
    prefs.setString("achievements", json.encode(value)); 
  }     

  @override
  Future<void> saveUserGameHistory(List<dynamic> value) async {
    final prefs = await instanceFuture;
    prefs.setString("userGameHistory", json.encode(value)); 
  }  

  @override
  Future<void> saveUserData(Object value) async {
    final prefs = await instanceFuture;
    prefs.setString("userData", json.encode(value)); 
  }     

  @override
  Future<void> saveRankData(List<dynamic> value) async {
    final prefs = await instanceFuture;
    prefs.setString("rankData", json.encode(value)); 
  }       
  @override
  Future<void> saveAchievementData(List<dynamic> value) async {
    final prefs = await instanceFuture;
    prefs.setString("achievementData", json.encode(value)); 
  }  

  @override
  Future<void> saveXP(int value) async {
    final prefs = await instanceFuture;
    prefs.setInt("xp", value); 
  }   

}
