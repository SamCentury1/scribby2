import 'package:scribby_flutter_v2/player_progress/persistence/player_progress_persistence.dart';

class MemoryOnlyPlayerProgressPersistence implements PlayerProgressPersistence {

  List<Map<String,dynamic>> games = [];
  @override
  Future<List<Map<String,dynamic>>> getGameData() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return games;
  }

  @override
  Future<void> saveGameData(List<Map<String,dynamic>> games) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    this.games = games;
  }

}