import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:scribby_flutter_v2/player_progress/persistence/player_progress_persistence.dart';

class PlayerProgress extends ChangeNotifier {
  final PlayerProgressPersistence _store;

  List<Map<String,dynamic>> _gamesPlayed = [];

  PlayerProgress(PlayerProgressPersistence store) : _store = store;

  List<Map<String,dynamic>> get gamesPlayed => _gamesPlayed;

  /// Fetches the latest data from the backing persistence store
  Future<void> getLatestFromStore() async {
    final games = await _store.getGameData();
    _gamesPlayed = games;
    notifyListeners();
  }

  void saveLatestGame(Map<String,dynamic> newGameData) async {
    List<Map<String,dynamic>> updatedGamesPlayed = [... _gamesPlayed, newGameData];
    // unawaited(_store.saveGameData(updatedGamesPlayed));
    await _store.saveGameData(updatedGamesPlayed);
    _gamesPlayed = updatedGamesPlayed;
    notifyListeners();
  }
}






















