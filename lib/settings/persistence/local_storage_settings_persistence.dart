import 'package:scribby_flutter_v2/settings/persistence/settings_persistence.dart';
// import 'package:scribby_flutter_v2/utils/states.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// An implementation of [SettingsPersistence] that uses
/// `package:shared_preferences`.

class LocalStorageSettingsPersistence extends SettingsPersistence {
  final Future<SharedPreferences> instanceFuture =
      SharedPreferences.getInstance();

  /// ========= GET THE DATA =================
  @override
  Future<bool> getMuted({required bool defaultValue}) async {
    final prefs = await instanceFuture;
    return prefs.getBool('mute') ?? defaultValue;
  }

  @override
  Future<bool> getSoundsOn() async {
    final prefs = await instanceFuture;
    return prefs.getBool('soundsOn') ?? true;
  }

  @override
  Future<String> getUser() async {
    final prefs = await instanceFuture;
    return prefs.getString('user') ?? "";
  }

  @override
  Future<bool> getDarkTheme() async {
    final prefs = await instanceFuture;
    return prefs.getBool('darkTheme') ?? true;
  }

  @override
  Future<Object> getUserData() async {
    final prefs = await instanceFuture;
    return json.decode(prefs.getString('userData') ?? json.encode([]));
  }

  @override
  Future<List<dynamic>> getAlphabet() async {
    final prefs = await instanceFuture;
    // return json.decode(prefs.getString('alphabet') ?? json.encode(englishAlphabet));
    return json.decode(prefs.getString('alphabet') ?? json.encode([]));
  }

  @override
  Future<Object> getInitialTileState() async {
    final prefs = await instanceFuture;
    // return json.decode(prefs.getString('alphabet') ?? json.encode(englishAlphabet));
    return json.decode(prefs.getString('initialTileState') ?? json.encode([]));
  }  

  @override
  Future<String> getDictionary() async {
    final prefs = await instanceFuture;
    return prefs.getString('dictionary') ?? "";
  }    

  /// ========= SAVE THE DATA =================
  @override
  Future<void> saveMuted(bool value) async {
    final prefs = await instanceFuture;
    await prefs.setBool('mute', value);
  }

  @override
  Future<void> saveSoundsOn(bool value) async {
    final prefs = await instanceFuture;
    await prefs.setBool('soundsOn', value);
  }

  @override
  Future<void> saveUser(String value) async {
    final prefs = await instanceFuture;
    await prefs.setString('user', value);
  }

  @override
  Future<void> saveDarkTheme(bool value) async {
    final prefs = await instanceFuture;
    await prefs.setBool('darkTheme', value);
  }

  @override
  Future<void> saveUserData(Object value) async {
    final prefs = await instanceFuture;
    await prefs.setString('userData', json.encode(value));
  }

  @override
  Future<void> saveAlphabet(List<dynamic> value) async {
    final prefs = await instanceFuture;
    await prefs.setString('alphabet', json.encode(value));
  }

  @override
  Future<void> saveInitialTileState(Object value) async {
    final prefs = await instanceFuture;
    await prefs.setString('initialTileState', json.encode(value));
  }  

  @override
  Future<void> saveDictionary(String value) async {
    final prefs = await instanceFuture;
    await prefs.setString('dictionary', value);
  }    
}
