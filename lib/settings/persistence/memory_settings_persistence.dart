import 'package:scribby_flutter_v2/settings/persistence/settings_persistence.dart';

/// An in-memory implementation of [SettingsPersistence].
/// Useful for testing.

class MemoryOnlySettingsPersistence implements SettingsPersistence {
  bool soundsOn = true;
  bool muted = false;
  String user = "User";
  bool darkTheme = true;
  Object userData = {};
  List<dynamic> alphabet = [];
  Object initialTileState = {};
  String dictionary = "";

  /// ============= GET ===================
  @override
  Future<bool> getSoundsOn() async => soundsOn;

  @override
  Future<bool> getMuted({required bool defaultValue}) async => muted;

  @override
  Future<String> getUser() async => user;

  @override
  Future<bool> getDarkTheme() async => darkTheme;

  @override
  Future<Object> getUserData() async => userData;

  @override
  Future<List<dynamic>> getAlphabet() async => alphabet;

  @override
  Future<Object> getInitialTileState() async => initialTileState;  

  @override
  Future<String> getDictionary() async => dictionary;    

  /// =========== SAVE ========================
  @override
  Future<void> saveSoundsOn(bool value) async => soundsOn = value;

  @override
  Future<void> saveMuted(bool value) async => muted = value;

  @override
  Future<void> saveUser(String value) async => user = value;

  @override
  Future<void> saveDarkTheme(bool value) async => darkTheme = value;

  @override
  Future<void> saveUserData(Object value) async => userData = value;

  @override
  Future<void> saveAlphabet(List<dynamic> value) async => alphabet = value;

  @override
  Future<void> saveInitialTileState(Object value) async => initialTileState = value; 
  
  @override
  Future<void> saveDictionary(String value) async => initialTileState = value;    
}
