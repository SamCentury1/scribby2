import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';

class AudioService {
  final SoLoud _soLoud = SoLoud.instance;

  final SettingsController settings;
  // final GamePlayState gamePlayState;

  bool _initialized = false;

  final Map<String,AudioSource> _sources = {};
  // final List<int> _activeHandles = [];
   final List<SoundHandle> _activeHandles = [];

  AudioService({
    required this.settings,
    // required this.gamePlayState,
  });

  Future<void> init() async {
    if (_initialized) return;
    await _soLoud.init();
    _initialized = true;

    // // Optional: automatically pause/resume when game state changes
    // gamePlayState.addListener(() {
    //   if (gamePlayState.isGamePaused) {
    //     pauseAll();
    //   } else {
    //     resumeAll();
    //   }
    // });
  }


  Future<void> preload(String assetPath) async {
    if (_sources.containsKey(assetPath)) return;
    final source = await _soLoud.loadAsset(assetPath);
    _sources[assetPath] = source;
  }

  Future<void> play(
    String assetPath, {
      double volume = 1.0,
      bool loop = false,
  }) async {
    if (!_initialized) return;

    // if (gamePlayState.isGamePaused) return;

    if (!_sources.containsKey(assetPath)) {
      await preload(assetPath);
    }

    final source = _sources[assetPath];
    if (source==null) return;

    final handle = await _soLoud.play(source,volume: volume, looping: loop);

    _activeHandles.add(handle);

  }

  void pauseAll() {
    for (final handle in _activeHandles) {
      try {
        _soLoud.setPause(handle, true);
      } catch (_) {
        debugPrint("error pausing sound");
      }
    }
  }
  void resumeAll() {
    for (final handle in _activeHandles) {
      try {
        _soLoud.setPause(handle, false);
      } catch (_) {
        debugPrint("error resuming sound");        
      }
    }
  }

  void stopAll() {
    for (final handle in _activeHandles) {
      try {
        _soLoud.stop(handle);
      } catch (_) {
        debugPrint("error stopping sound");        
      }
    }
    _activeHandles.clear();
  }

  void dispose() {
    stopAll();
    _soLoud.deinit();
    _initialized = false;
  }

}