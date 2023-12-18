import 'dart:convert';

import 'package:scribby_flutter_v2/player_progress/persistence/player_progress_persistence.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStoragePlayerProgressPersistence extends PlayerProgressPersistence {
  final Future<SharedPreferences> instanceFuture = SharedPreferences.getInstance();

  @override
  Future<List<Map<String,dynamic>>> getGameData() async {
    final prefs = await instanceFuture;
    late String jsonData = prefs.getString('gameData') ?? "";



    if (jsonData.isNotEmpty) {
      try {
        final List<dynamic> data = jsonDecode(jsonData);
        final List<Map<String,dynamic>> dataList = List<Map<String,dynamic>>.from(data);
        return dataList;
      } catch (e) {
        return [];
      }
    } else {
      return [];
    }
  }

  @override
  Future<void> saveGameData(List<Map<String,dynamic>> gameData) async {


    final prefs = await instanceFuture;
    String jsonData = jsonEncode(gameData);
    await prefs.setString('gameData', jsonData);
  }

}