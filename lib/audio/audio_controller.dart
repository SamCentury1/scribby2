
import 'dart:math';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:scribby_flutter_v2/audio/sounds.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';
import 'package:synchronized/synchronized.dart';


class AudioController {
  final List<AudioPlayer> _sfxPlayers;
  final _lock = Lock();

  int _currentSfxPlayer = 0;
  SettingsController? _settings;
  ValueNotifier<AppLifecycleState>? _lifecycleNotifier;

  SettingsController? settingsController;
  final Random _random = Random();
  ValueNotifier<bool>? _soundsOnNotifier;
  bool _soundsOn = false;
  

  /// Creates an instance that plays music and sound.
  ///
  /// Use [polyphony] to configure the number of sound effects (SFX) that can
  /// play at the same time. A [polyphony] of `1` will always only play one
  /// sound (a new sound will stop the previous one). See discussion
  /// of [_sfxPlayers] to learn why this is the case.
  ///
  /// Background music does not count into the [polyphony] limit. Music will
  /// never be overridden by sound effects because that would be silly.
  AudioController({int polyphony = 8}) : assert(polyphony >= 1),
  // _sfxPlayers = Iterable.generate(polyphony, (i) => AudioPlayer(playerId: 'sfxPlayer#$i')).toList(growable: false);

  _sfxPlayers = Iterable.generate(
    polyphony,
    (i) {
      final player = AudioPlayer(playerId: 'sfxPlayer#$i');
      player.setPlayerMode(PlayerMode.lowLatency);
      player.setReleaseMode(ReleaseMode.stop);
      return player;
    },
  ).toList(growable: false);  


  /// Enables the [AudioController] to listen to [AppLifecycleState] events,
  /// and therefore do things like stopping playback when the game
  /// goes into the background.
  void attachLifecycleNotifier( ValueNotifier<AppLifecycleState> lifecycleNotifier) {
      _lifecycleNotifier?.removeListener(_handleAppLifecycle);
      lifecycleNotifier.addListener(_handleAppLifecycle);
      _lifecycleNotifier = lifecycleNotifier;
  } 


  /// Enables the [AudioController] to track changes to settings.
  /// Namely, when any of [SettingsController.muted],
  /// [SettingsController.musicOn] or [SettingsController.soundsOn] changes,
  /// the audio controller will act accordingly.
  

  void attachSettings(SettingsController settings) {
    _soundsOnNotifier?.removeListener(_onSoundsChanged);

    _soundsOnNotifier = settings.soundsOn;
    _soundsOn = _soundsOnNotifier!.value;

    _soundsOnNotifier!.addListener(_onSoundsChanged);
  }

  void _onSoundsChanged() {
    _soundsOn = _soundsOnNotifier!.value;

    if (!_soundsOn) {
      _stopAllSound();
    }
  }

  // void _onSettingsChanged() {
  //   if (_settings == null) return;

  //   final userData = _settings!.userData.value as Map<String, dynamic>;
  //   _soundsOn = userData['parameters']['soundOn'] ?? false;

  //   if (!_soundsOn) {
  //     _stopAllSound();
  //   }
  // }  

  void dispose() {
    _lifecycleNotifier?.removeListener(_handleAppLifecycle);
    _stopAllSound();
    for (final player in _sfxPlayers) {
      player.dispose();
    }
  } 

  // Future<void> initialize() async {
  //   await AudioCache.instance.loadAll(SfxType.values
  //       .expand(soundTypeToFileName)
  //       .map((path) => 'sfx/$path')
  //       .toList());    
  // }

  Future<void> initialize() async {
    for (final type in SfxType.values) {
      final files = soundTypeToFileName(type);
      for (final file in files) {
        await AudioPlayer().setSource(
          AssetSource('audio/sfx/$file'),
        );
      }
    }
  }

  // void playSfx(SfxType type,) async {
  //   await _lock.synchronized(() {

  //     // print("muted? ${_settings?.muted.value}");
  //     // final muted = _settings?.muted.value ?? true;
  //     // if (muted) {
  //     //   print("is muted");
  //     //   // ignoring the playing sound
  //     //   return;
  //     // }

  //     if (_settings == null) return;

  //     final userData = _settings!.userData.value as Map<String,dynamic>;
  //     final soundsOn = userData['parameters']['soundOn'] ?? false;

  //     // print("soundsOn? ${settingsState.userData['parameters']}");
  //     if (!soundsOn) return;


  //     final options = soundTypeToFileName(type);
  //     final fileName = options[_random.nextInt(options.length)];

  //     final currentPlayer = _sfxPlayers[_currentSfxPlayer];
  //     currentPlayer.play(AssetSource('audio/sfx/$fileName'));
  //     _currentSfxPlayer = (_currentSfxPlayer + 1) % _sfxPlayers.length; // removing this prevents sounds from playing simultaneously
  //   });
  // }

  void playSfx(SfxType type) async {
    if (!_soundsOn) {
      print("sound is off - play nothing");
      return;
    }

    // await _lock.synchronized(() {
    final options = soundTypeToFileName(type);
    final fileName = options[_random.nextInt(options.length)];

    final currentPlayer = _sfxPlayers[_currentSfxPlayer];
    await currentPlayer.setSource(
      AssetSource('audio/sfx/$fileName'),
    );    
    print("play audio/sfx/$fileName");
    await currentPlayer.resume();
    // currentPlayer.play(AssetSource('audio/sfx/$fileName'));

    _currentSfxPlayer = (_currentSfxPlayer + 1) % _sfxPlayers.length;
    // });
  }






  void _handleAppLifecycle() {
    switch (_lifecycleNotifier!.value) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        _stopAllSound();
      case AppLifecycleState.resumed:
      case AppLifecycleState.inactive:
        break;
    }
  }

  // void _mutedHandler() {
  //   if(_settings!.muted.value) {
  //     // All sound just got muted.
  //     _stopAllSound();
  //   }
  // }

  void _soundsOnHandler() {
    for (final player in _sfxPlayers) {
      if (player.state == PlayerState.playing) {
        player.stop();
      }
    }
  }

  void _stopAllSound() {
    for (final player in _sfxPlayers) {
      if (player.state == PlayerState.playing) {
        player.stop();
      }
    }
  }  
}


// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:scribby_flutter_v2/audio/sounds.dart';
// import 'package:scribby_flutter_v2/settings/settings.dart';

// class AudioController {
//   final List<AudioPlayer> _sfxPlayers;
//   final Random _random = Random();
//   int _currentSfxPlayer = 0;

//   SettingsController? _settings;
//   ValueNotifier<AppLifecycleState>? _lifecycleNotifier;

//   AudioController({int polyphony = 6})
//       : assert(polyphony >= 1),
//         _sfxPlayers = List.generate(polyphony, (i) {
//           final player = AudioPlayer(playerId: 'sfxPlayer#$i');
//           player.setPlayerMode(PlayerMode.lowLatency); // instant response
//           player.setReleaseMode(ReleaseMode.stop);      // reusable player
//           return player;
//         });

//   /// Attach settings controller to check soundsOn
//   void attachSettings(SettingsController settings) {
//     _settings = settings;
//   }

//   /// Attach lifecycle notifier to handle pause/resume
//   void attachLifecycleNotifier(ValueNotifier<AppLifecycleState> notifier) {
//     _lifecycleNotifier?.removeListener(_handleLifecycle);
//     notifier.addListener(_handleLifecycle);
//     _lifecycleNotifier = notifier;
//   }

//   /// Preload all WAV assets to reduce latency
//   Future<void> initialize(List<SfxType> allTypes) async {
//     for (final type in allTypes) {
//       final files = soundTypeToFileName(type);
//       for (final file in files) {
//         // Preload by setting source on a random player
//         final player = _sfxPlayers[_random.nextInt(_sfxPlayers.length)];
//         await player.setSource(AssetSource('audio/sfx/$file'));
//       }
//     }
//   }

//   // /// Play a sound effect immediately, allows overlapping
//   // void playSfx(SfxType type) async {
//   //   // Check if sound is enabled
//   //   if (!(_settings?.soundsOn.value ?? true)) {
//   //     print("sound is off");
//   //     return;
//   //   }

//   //   final options = soundTypeToFileName(type);
//   //   final fileName = options[_random.nextInt(options.length)];

//   //   final player = _sfxPlayers[_currentSfxPlayer];

//   //   // Fire-and-forget; player will handle loading
//   //   await player.setSource(AssetSource('audio/sfx/$fileName')).then((_) {
//   //     print("play audio/sfx/$fileName");
//   //     player.resume();
//   //   }).catchError((e) {
//   //     debugPrint('Failed to play sound $fileName: $e');
//   //   });

//   //   // Rotate to next player for polyphony
//   //   _currentSfxPlayer = (_currentSfxPlayer + 1) % _sfxPlayers.length;
//   // }
//   void playSfx(SfxType type) async {
//     if (!(_settings?.soundsOn.value ?? true)) {
//       print("sound is off - play nothing");
//       return;
//     }

//     // await _lock.synchronized(() {
//     final options = soundTypeToFileName(type);
//     final fileName = options[_random.nextInt(options.length)];

//     final currentPlayer = _sfxPlayers[_currentSfxPlayer];
//     await currentPlayer.setSource(
//       AssetSource('audio/sfx/$fileName'),
//     );    
//     print("play audio/sfx/$fileName");
//     await currentPlayer.resume();
//     // currentPlayer.play(AssetSource('audio/sfx/$fileName'));

//     _currentSfxPlayer = (_currentSfxPlayer + 1) % _sfxPlayers.length;
//     // });
//   }

//   /// Stop all playing sounds
//   void _stopAllSounds() {
//     for (final player in _sfxPlayers) {
//       player.stop();
//     }
//   }

//   /// Handle app lifecycle changes
//   void _handleLifecycle() {
//     switch (_lifecycleNotifier?.value) {
//       case AppLifecycleState.paused:
//       case AppLifecycleState.detached:
//       case AppLifecycleState.hidden:
//         _stopAllSounds();
//         break;
//       case AppLifecycleState.resumed:
//       case AppLifecycleState.inactive:
//         break;
//       default:
//         break;
//     }
//   }

//   /// Dispose all players and listeners
//   void dispose() {
//     _lifecycleNotifier?.removeListener(_handleLifecycle);
//     _stopAllSounds();
//     for (final player in _sfxPlayers) {
//       player.dispose();
//     }
//   }
// }
