import 'package:flutter/foundation.dart';
import 'package:scribby_flutter_v2/functions/game_logic.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';
import 'package:scribby_flutter_v2/utils/states.dart';

class Helpers {
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  String fixForCharacter(String s, String character) {
    List<String> strings = s.split(character);
    List<String> newList = [];
    for (String item in strings) {
      newList.add(capitalize(item));
    }
    String stringsCleaned = newList.join(character);
    return stringsCleaned;
  }

  String capitalizeName(String s) {
    String stringWitoutSpaces = fixForCharacter(s, " ");
    String stringWithoutDashes = fixForCharacter(stringWitoutSpaces, "-");
    String stringWithoutPeriods = fixForCharacter(stringWithoutDashes, ".");

    return stringWithoutPeriods;
  }

  int getCurrentHighScore(SettingsState settings) {
    final String currentLanguage =
        settings.userData['parameters']['currentLanguage'];
    final int currentHighScore =
        settings.userData['highScores'][currentLanguage] ?? 0;
    return currentHighScore;
  }

  void getStates(GamePlayState gamePlayState, SettingsController settings) {
    final Map<String, dynamic> alphabetDocumnet =
        (settings.alphabet.value as Map<String, dynamic>);
    final List<dynamic> alphabet = alphabetDocumnet['alphabet'];

    if (alphabet.isNotEmpty) {
      late List<Map<String, dynamic>> startingAlphabetState = GameLogic()
          .generateStartingStates(
              alphabet, initialBoardState, [])['startingAlphabet'];
      late List<String> randomLetterListState = GameLogic()
          .generateStartingStates(
              alphabet, initialBoardState, [])['startingRandomLetterList'];
      late List<Map<String, dynamic>> startingTileState = GameLogic()
          .generateStartingStates(
              alphabet, initialBoardState, [])['startingTileState'];

      gamePlayState.setAlphabetState(startingAlphabetState);
      gamePlayState.setRandomLetterList(randomLetterListState);
      gamePlayState.setVisualTileState(startingTileState);
    } else {
      debugPrint("something went wrong retrieving the alphabet from storage");
    }
  }
}
