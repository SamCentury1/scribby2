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
   final List<Map<String,SoundHandle>> _activeHandles2 = [];

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
    SfxType soundType,
    String type, {
      double volume = 1.0,
      bool loop = false,
  }) async {
    

    if (!_initialized) {
      print("not initialized");
      return;
    };

    Map<String,dynamic> userData = settings.userData.value as Map<String,dynamic>;
    bool soundOn = userData['parameters']['soundOn'];

    if (!soundOn) return;

    // if (gamePlayState.isGamePaused) return;
    // List<String> assetPaths =[];
    // String? assetPath;
    // switch (soundType) {
    //   case 'glassBreak':
    //     assetPath = 'assets/audio/';
    // }
    final files = soundTypeToFileName(soundType);
    print(" AUDIO FILES ${files.length}");
    Random rand = Random();
    int randIndex = rand.nextInt(files.length-1);
    String assetPath = "assets/audio/sfx/${files[randIndex]}";
    print("***************** play $assetPath!  ********************");
    
    if (!_sources.containsKey(assetPath)) {
      await preload(assetPath);
    }

    final source = _sources[assetPath];
    if (source==null) return;

    final handle = await _soLoud.play(source,volume: volume, looping: loop);
    // _activeHandles.add(handle);
    Map<String,SoundHandle> handle2 = {type:handle};
    _activeHandles2.add(handle2);
  

  }


  Future<void> playWordFound(
    int streak,
    int words, {
      double volume = 1.0,
      bool loop = false,
  }) async {
    print("***************** play sound!  ********************");

    if (!_initialized) {
      print("not initialized");
      return;
    }

    Map<String,dynamic> userData = settings.userData.value as Map<String,dynamic>;
    bool soundOn = userData['parameters']['soundOn'];
    if (!soundOn) return;


    String assetPath = 'assets/audio/sfx/word_found_${streak}_$words.wav';
    
    if (!_sources.containsKey(assetPath)) {
      await preload(assetPath);
    }

    final source = _sources[assetPath];
    if (source==null) return;

    final handle = await _soLoud.play(source,volume: volume, looping: loop);

    // _activeHandles.add(handle);

    Map<String,SoundHandle> handle2 = {"wordFound":handle};
    _activeHandles2.add(handle2);    
  

  }


  void pauseAll() {
    for (final handleObj in _activeHandles2) {
      try {
        final handle = handleObj.values.first;
        if (handle != null) {
          _soLoud.setPause(handle, true);
        }
      } catch (_) {
        debugPrint("error pausing sound");
      }
    }
  }
  void resumeAll() {

    Map<String,dynamic> userData = settings.userData.value as Map<String,dynamic>;
    bool soundOn = userData['parameters']['soundOn'];

    if (!soundOn) return;
        
    for (final handleObj in _activeHandles2) {
      try {
        final handle = handleObj.values.first;
        if (handle != null) {
          _soLoud.setPause(handle, false);
        }
      } catch (_) {
        debugPrint("error resuming sound");        
      }
    }
  }

  void stopAll() {
    for (final handleObject in _activeHandles2) {
      try {
        final handle = handleObject.values.first;
        if (handle!=null) {
          _soLoud.stop(handle!);
        }
        print("stopped all sound");
      } catch (_) {
        debugPrint("error stopping sound");        
      }
    }
    _activeHandles2.clear();
  }

  void stopTally() async {

      try {
        String assetPath = 'assets/audio/sfx/score_tally.wav';
        
        if (!_sources.containsKey(assetPath)) {
          await preload(assetPath);
        }

        final source = _sources[assetPath];
        if (source==null) return;

        // final handle = await _soLoud.play(source,volume: 1, looping: false);
        // [handle].clear();
        print(_activeHandles2);
        List<Map<String,SoundHandle>> tallyHandles = _activeHandles2.where((e)=>e.keys.first == 'scoreTally').toList();

        for (final handleObject in tallyHandles) {
          SoundHandle? handle = handleObject['scoreTally'];
          if (handle != null) {
            _soLoud.stop(handle);
          }
        }


        print("stopped score tally sound");
      } catch (_) {
        debugPrint("error stopping sound");        
      }
  
      _activeHandles.clear();
  }  

  void dispose() {
    stopAll();
    _soLoud.deinit();
    _initialized = false;
  }

}