import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:scribby_flutter_v2/audio/sounds.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';

class AudioService extends ChangeNotifier{
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
    print("AudioService initialized ✅");
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
    SfxType soundType, {
      double volume = 1.0,
      bool loop = false,
  }) async {
    print("***************** play sound!  ********************");

    if (!_initialized) {
      print("not initialized");
      return;
    };

    // if (gamePlayState.isGamePaused) return;
    // List<String> assetPaths =[];
    // String? assetPath;
    // switch (soundType) {
    //   case 'glassBreak':
    //     assetPath = 'assets/audio/';
    // }
    final files = soundTypeToFileName(soundType);
    Random rand = Random();
    int rand_index = rand.nextInt(files.length-1);
    String assetPath = "assets/audio/sfx/${files[rand_index]}";
    
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