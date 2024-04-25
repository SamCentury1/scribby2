import 'dart:math';
import 'dart:ui';


import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:scribby_flutter_v2/audio/sounds.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';
import 'package:synchronized/synchronized.dart';

class AudioController {

  // final AudioPlayer ;

  // final AudioPlayer tileSelectPlayer;
  // final AudioPlayer wordFoundPlayer;
  final List<AudioPlayer> _sfxPlayers;
  final _lock = Lock();

  int _currentSfxPlayer = 0;

  SettingsController? _settings;

  ValueNotifier<AppLifecycleState>? _lifecycleNotifier;

  final Random _random = Random();


  /// Creates an instance that plays music and sound.
  ///
  /// Use [polyphony] to configure the number of sound effects (SFX) that can
  /// play at the same time. A [polyphony] of `1` will always only play one
  /// sound (a new sound will stop the previous one). See discussion
  /// of [_sfxPlayers] to learn why this is the case.
  ///
  /// Background music does not count into the [polyphony] limit. Music will
  /// never be overridden by sound effects because that would be silly.
  AudioController({int polyphony = 2}) : assert(polyphony >= 1),

  _sfxPlayers = Iterable.generate(polyphony, (i) => AudioPlayer(playerId: 'sfxPlayer#$i')).toList(growable: false);
       


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
  void attachSettings(SettingsController settingsController) {
    if (_settings == settingsController) {
      // Already attached to this instance. Nothing to do.
      return;
    }

    // Remove handlers from the old settings controller if present
    final oldSettings = _settings;
    if (oldSettings != null) {
      oldSettings.muted.removeListener(_mutedHandler);
      oldSettings.soundsOn.removeListener(_soundsOnHandler);
    }

    _settings = settingsController;

    // Add handlers to the new settings controller
    settingsController.muted.addListener(_mutedHandler);
    settingsController.soundsOn.addListener(_soundsOnHandler);

  }

  void dispose() {
    _lifecycleNotifier?.removeListener(_handleAppLifecycle);
    _stopAllSound();
    for (final player in _sfxPlayers) {
      player.dispose();
    }    
    // tileSelectPlayer.dispose();
    // wordFoundPlayer.dispose();
  }

  Future<void> initialize() async {
    // tileSelectPlayer = AudioPlayer(playerId: 'tileSelect');
    // wordFoundPlayer = AudioPlayer(playerId: 'wordFound');

    await AudioCache.instance.loadAll(SfxType.values
        .expand(soundTypeToFileName)
        .map((path) => 'sfx/$path')
        .toList());    
  }

  void playSfx(SfxType type) async {
    await _lock.synchronized(() {
      final muted = _settings?.muted.value ?? true;
      if (muted) {
        // ignoring the playing sound
        return;
      }
      final soundsOn = _settings?.soundsOn.value ?? false;
      if (!soundsOn) {
        // ignoring the playing sound
        return;
      }

      final options = soundTypeToFileName(type);
      final fileName = options[_random.nextInt(options.length)];
      final currentPlayer = _sfxPlayers[_currentSfxPlayer];
      currentPlayer.play(AssetSource('audio/sfx/$fileName'));
      _currentSfxPlayer = (_currentSfxPlayer + 1) % _sfxPlayers.length; // removing this prevents sounds from playing simultaneously
    });
  }

  late AudioPlayer _gameOverAudioPlayer = AudioPlayer();

  void playLoopSfx() async {
    await _lock.synchronized(()  {
      final muted = _settings?.muted.value ?? true;
      if (muted) {
        // ignoring the playing sound
        return;
      }
      final soundsOn = _settings?.soundsOn.value ?? false;
      if (!soundsOn) {
        // ignoring the playing sound
        return;
      }
      _gameOverAudioPlayer.setReleaseMode(ReleaseMode.loop);
      _gameOverAudioPlayer.play(AssetSource('audio/sfx/points-count-electronic.mp3'));
      
    });
  }

  void stopLoopSfx() async {
    await _lock.synchronized(()  {
      _gameOverAudioPlayer.stop();
    });
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

  void _mutedHandler() {
    if(_settings!.muted.value) {
      // All sound just got muted.
      _stopAllSound();
    }
  }

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