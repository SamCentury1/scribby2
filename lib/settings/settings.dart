import 'package:flutter/foundation.dart';
import 'package:scribby_flutter_v2/settings/persistence/settings_persistence.dart';

/// An class that holds settings like [playerName] or [musicOn],
/// and saves them to an injected persistence store.


class SettingsController  {
  final SettingsPersistence _persistence;

  /// Whether or not the sound is on at all. This overrides both music
  /// and sound.
  ValueNotifier<bool> muted = ValueNotifier(false);

  ValueNotifier<bool> soundsOn = ValueNotifier(false);

  ValueNotifier<String> user = ValueNotifier("User");

  ValueNotifier<bool> darkTheme = ValueNotifier(false);

  /// Creates a new instance of [SettingsController] backed by [persistence].
  SettingsController({required SettingsPersistence persistence}) : _persistence = persistence;


  /// Asynchronously loads values from the injected persistence store.
  Future<void> loadStateFromPerisitence() async {
    await Future.wait([
      _persistence.getMuted(defaultValue: kIsWeb).then((value) => muted.value = value),
      _persistence.getSoundsOn().then((value) => soundsOn.value = value),
      _persistence.getUser().then((value) => user.value = value),
      _persistence.getDarkTheme().then((value) => darkTheme.value = value)
    ]);
  }

  void toggleMuted() {
    muted.value = !muted.value;
    _persistence.saveMuted(muted.value);
  }

  void toggleSoundsOn() {
    soundsOn.value = !soundsOn.value;
    _persistence.saveSoundsOn(soundsOn.value);
  }  

  void setUser(String name) {
    user.value = name;
    _persistence.saveUser(user.value);
  }

  void toggleDarkTheme() {
    darkTheme.value = !darkTheme.value;
    _persistence.saveDarkTheme(darkTheme.value);
    
  }




}