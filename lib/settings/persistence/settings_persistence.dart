/// An interface of persistence stores for settings.
///
/// Implementations can range from simple in-memory storage through
/// local preferences to cloud-based solutions.
abstract class SettingsPersistence {


  /// ========== GET THE DATA ===================
  Future<bool> getSoundsOn();

  Future<bool> getMuted({required bool defaultValue});

  Future<String> getUser();

  Future<bool> getDarkTheme();

  

  /// ========== SAVE THE DATA ===================
  Future<void> saveSoundsOn(bool value);

  Future<void> saveMuted(bool value);

  Future<void> saveUser(String value);
  
  Future<void> saveDarkTheme(bool value);
}