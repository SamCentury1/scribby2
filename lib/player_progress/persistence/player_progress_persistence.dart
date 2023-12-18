abstract class PlayerProgressPersistence {
  
  Future<List<Map<String,dynamic>>> getGameData();

  Future<void> saveGameData(List<Map<String,dynamic>> gameData);
}