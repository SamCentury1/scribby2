// import 'dart:ffi';
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/audio/audio_controller.dart';
import 'package:scribby_flutter_v2/audio/sounds.dart';
// import 'package:scribby_flutter_v2/components/level_change_overlay.dart';
// import 'package:scribby_flutter_v2/player_progress/player_progress.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/resources/auth_service.dart';
import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
import 'package:scribby_flutter_v2/screens/game_over_screen/game_over_screen.dart';
// import 'package:scribby_flutter_v2/styles/palette.dart';
import 'package:scribby_flutter_v2/utils/dictionary.dart';
import 'package:scribby_flutter_v2/utils/states.dart';

class GameLogic {
  // THIS FUNCTION TAKES IN THE BOARD LETTER STATE AND DISPLAYS IT
  String displayTileLetter(
      List<Map<String, dynamic>> letterState, String tileId) {
    String res = "";
    final Map<String, dynamic> correspondingTileState =
        letterState.firstWhere((element) => element["tileId"] == tileId);
    res = correspondingTileState["letter"];
    return res;
  }

  Map<String, dynamic> getTileState(
      List<Map<String, dynamic>> letterState, String tileId) {
    return letterState.firstWhere((element) => element["tileId"] == tileId);
  }

  String displayRandomLetters(List<String> randomLettersList, int position) {
    late String letter;
    if (position == 3) {
      if (randomLettersList.length < 3) {
        letter = "";
      } else {
        letter = randomLettersList[randomLettersList.length - position];
      }
    } else {
      letter = randomLettersList[randomLettersList.length - position];
    }
    return letter;
  }

  // Checks whether a tile is occupied by a letter or if is empty
  bool isTileOpen(List<Map<String, dynamic>> boardState, String tileId) {
    bool res = false;
    late Map<String, dynamic> tileObject = getTileState(boardState, tileId);
    if (tileObject["letter"] == "" && tileObject["alive"]) {
      res = true;
    } else {
      res = false;
    }

    return res;
  }

  List<Map<String, dynamic>> updateBoardLetterState(
      List<Map<String, dynamic>> boardState, String newLetter, String tileId) {
    List<Map<String, dynamic>> newBoardState = [];

    for (Map<String, dynamic> tileObject in boardState) {
      if (tileObject["tileId"] == tileId) {
        final Map<String, dynamic> newTileObject = {
          "tileId": tileId,
          "row": tileObject["row"],
          "column": tileObject["column"],
          "letter": newLetter,
          "active": tileObject["active"],
          "alive": tileObject["alive"]
        };
        newBoardState.add(newTileObject);
      } else {
        newBoardState.add(tileObject);
      }
    }
    return newBoardState;
  }

  // GENERATES A NEW RANDOM LETTER AND ADDS IT TO THE LIST OF RANDOM LETTERS AND UPDATES THE RANDOM LETTER STATE
  void updateRandomLetters(List<Map<String, dynamic>> randomLetterState) {}

  // THIS TAKES IN THE ALPHABET AND THE CURRENT LIST OF PREVIOUSLY GENERATED RANDOM LETTERS
  // IT CHECKS WHETHER THE PREVIOUSLY GENERATE LETTER LIST IS SHORTER THAN 2 (START OF GAME)
  // IT CREATES AN ARRAY OF AVAILABLE LETTERS TO CHOOSE FROM.
  // IT SELECTS A RANDOM LETTER AND UPDATES THE ALPHABET STATE AND RANDOM LETTER LIST
  // RETURNS A MAP WITH BOTH LISTS.
  Map<String, dynamic> generateRandomLetterData(
      List<Map<String, dynamic>> alphabet, List<String> randomLettersList) {
    Random random = Random();
    // create an array of available letters
    String letterType = getNextLetterType(alphabet);
    String previousLetter = randomLettersList[randomLettersList.length - 2];

    bool isInitialTurn = randomLettersList.length <= 2;
    List<String> availableLetters = [];
    for (Map<String, dynamic> randomLetterObject in alphabet) {
      for (var i = 1; i < randomLetterObject["count"]; i++) {
        if (isInitialTurn) {
          availableLetters.add(randomLetterObject["letter"]);
        } else {
          if (randomLetterObject["type"] == letterType &&
              randomLetterObject["letter"] != previousLetter) {
            availableLetters.add(randomLetterObject["letter"]);
          }
        }
      }
    }

    int availableLettersCount = availableLetters.length;

    int randomIndex = random.nextInt(availableLettersCount);
    String randomLetter = availableLetters[randomIndex];

    List<Map<String, dynamic>> newRandomLetterState = [];
    for (Map<String, dynamic> randomLetterObject in alphabet) {
      if (randomLetterObject["letter"] == randomLetter) {
        late Map<String, dynamic> newAlphabetObject = {
          "letter": randomLetterObject["letter"],
          "type": randomLetterObject["type"],
          "points": randomLetterObject["points"],
          "count": randomLetterObject["count"] - 1,
          "inPlay": randomLetterObject["inPlay"] + 1,
        };
        newRandomLetterState.add(newAlphabetObject);
      } else {
        newRandomLetterState.add(randomLetterObject);
      }
    }

    final List<String> newRandomLettersList = [
      ...randomLettersList,
      randomLetter
    ];

    final Map<String, dynamic> randomLetterData = {
      "randomList": newRandomLettersList,
      "randomState": newRandomLetterState
    };

    return randomLetterData;
  }

  // this function scans the board calculates the share of vowels
  // returns the type of letter depending on the share
  String getNextLetterType(List<Map<String, dynamic>> alphabet) {
    String res = "";
    int cons = 0;
    int vows = 0;

    for (Map<String, dynamic> letterObject in alphabet) {
      for (var i = 0; i < letterObject["inPlay"]; i++) {
        if (letterObject["type"] == "consonant") {
          cons = cons + 1;
        } else if (letterObject["type"] == "vowel") {
          vows = vows + 1;
        }
      }
    }

    num shareOfVowels = vows / (vows + cons);
    if (vows <= 0) {
      res = "vowel";
    } else {
      if (shareOfVowels <= 0.4) {
        res = "vowel";
      } else if (shareOfVowels > 0.40) {
        res = "consonant";
      }
    }
    return res;
  }

  int getWordLengthMultiplier(int wordLength) {
    int res = 0;
    if (wordLength == 3 || wordLength == 4) {
      res = 1;
    } else {
      res = wordLength - 3;
    }
    return res;
  }

  List<Map<String, dynamic>> getTurnSummaryData(
    List<Map<String, dynamic>> boardState,
    List<Map<String, dynamic>> randomLetterState,
    List<Map<String, dynamic>> summaryState,
    int turn,
    int activeStreak,
  ) {
    List<Map<String, dynamic>> validStringObjects = [];

    for (Map<String, dynamic> stringCombo in stringCombinations) {
      List<Map<String, dynamic>> contents = [];
      List<String> letters = [];
      final List<String> string = stringCombo["arr"];

      for (String tileId in string) {
        Map<String, dynamic> correspondingTile =
            boardState.firstWhere((element) => element["tileId"] == tileId);
        String correspondingTileContents = correspondingTile["letter"];
        if (correspondingTileContents == "") {
          contents.add({"tileId": tileId, "content": "-"});
          letters.add("-");
        } else {
          contents
              .add({"tileId": tileId, "content": correspondingTileContents});
          letters.add(correspondingTileContents);
        }
      }

      String totalString = letters.join();
      if (!totalString.contains("-")) {
        validStringObjects
            .add({"string": letters.join(), "contents": contents});
      }
    }

    List<String> wordsList = [];
    List<String> uniqueIds = [];
    List<Map<String, dynamic>> validWordsList = [];
    num totalPoints = 0;

    int crossWordMultiplier = 1;
    // int wordCount = 0;
    List<int> rows = [];
    List<int> cols = [];

    for (Map<String, dynamic> stringObject in validStringObjects) {
      // print(stringObject["string"]);
      if (dictionary.contains(stringObject["string"])) {
        wordsList.add(stringObject["string"]);

        List<Map<String, dynamic>> stringContents = stringObject["contents"];
        num wordPoints = 0;
        int wordLength = stringContents.length;

        for (Map<String, dynamic> stringContent in stringContents) {
          String contentLetter = stringContent["content"];
          Map<String, dynamic> correspondingAlphabetObject = randomLetterState
              .firstWhere((element) => element["letter"] == contentLetter);
          wordPoints = wordPoints + correspondingAlphabetObject["points"];
          if (!uniqueIds.contains(stringContent["tileId"])) {
            uniqueIds.add(stringContent["tileId"]);
          }

          Map<String, dynamic> correspondingBoardLetter = boardState.firstWhere(
              (element) => element["tileId"] == stringContent["tileId"]);
          int row = correspondingBoardLetter["row"];
          int col = correspondingBoardLetter["column"];

          if (!rows.contains(row)) {
            rows.add(row);
          }
          if (!cols.contains(col)) {
            cols.add(col);
          }
        }

        // multiply the points by the word length multiplier
        int wordLengthMultiplier = getWordLengthMultiplier(wordLength);

        validWordsList.add({
          "word": stringObject["string"],
          "points": (wordPoints * wordLengthMultiplier)
        });

        totalPoints = totalPoints + wordPoints * wordLengthMultiplier;
      }
    }

    if (rows.length > 1 && cols.length > 1) {
      crossWordMultiplier = 2;
    } else {
      crossWordMultiplier = 1;
    }

    num finalTurnPoints = totalPoints *
        (activeStreak + 1) *
        crossWordMultiplier *
        (wordsList.length);

    List<Map<String, dynamic>> newTurnSummaryState = summaryState;
    Map<String, dynamic> pointSummary = {};

    pointSummary = {
      "turn": turn,
      "points": finalTurnPoints,
      "words": validWordsList,
      "ids": uniqueIds,
      "crossword": finalTurnPoints == 0 ? 0 : crossWordMultiplier,
      "streak": finalTurnPoints == 0 ? activeStreak : (activeStreak + 1),
      "count": wordsList.length,
    };

    newTurnSummaryState.add(pointSummary);

    return newTurnSummaryState;
  }

  List<String> getUniqueWords(List<Map<String, dynamic>> turnSummaryData) {
    List<String> uniques = [];
    for (Map<String, dynamic> turnSummary in turnSummaryData) {
      List<Map<String, dynamic>> words = turnSummary["words"];
      for (Map<String, dynamic> word in words) {
        if (!uniques.contains(word["word"])) {
          uniques.add(word["word"]);
        }
      }
    }
    return uniques;
  }

  int getHighestValueOfStat(
      List<Map<String, dynamic>> turnSummaryData, String stat) {
    int highestVal = 0;
    if (turnSummaryData.isNotEmpty) {
      Map<String, dynamic> highestValObject = turnSummaryData.reduce(
          (currentTurn, nextTurn) =>
              currentTurn[stat] > nextTurn[stat] ? currentTurn : nextTurn);
      highestVal = highestValObject[stat];
    } else {
      highestVal = 0;
    }
    return highestVal;
  }

  int getCrossWords(List<Map<String, dynamic>> turnSummaryData) {
    int crosswords = 0;
    for (Map<String, dynamic> turnSummary in turnSummaryData) {
      if (turnSummary["crossword"] == 2) {
        crosswords = crosswords + 1;
      }
    }
    return crosswords;
  }

  // this returns data to be displayed in the pause menu or game over view
  Map<String, dynamic> getGameSummaryData(
      List<Map<String, dynamic>> turnSummaryData) {
    int turns = turnSummaryData.length;
    int points = getTotalPoints(turnSummaryData);
    List<String> uniqueWords = getUniqueWords(turnSummaryData);
    int mostPoints = getHighestValueOfStat(turnSummaryData, "points");
    int longestStreak = getHighestValueOfStat(turnSummaryData, "streak");
    int mostWords = getHighestValueOfStat(turnSummaryData, "count");
    int crosswords = getCrossWords(turnSummaryData);

    Map<String, dynamic> summary = {
      "turns": turns,
      "points": points,
      "uniqueWords": uniqueWords,
      "mostPoints": mostPoints,
      "longestStreak": longestStreak,
      "mostWords": mostWords,
      "crosswords": crosswords,
    };
    return summary;
  }

  List<Map<String, dynamic>> startFoundWordAnimation(
      List<Map<String, dynamic>> boardState,
      List<Map<String, dynamic>> turnSummaryData) {
    List<Map<String, dynamic>> updatedState = [];

    Map<String, dynamic> latestPoints =
        turnSummaryData[turnSummaryData.length - 1];
    List<String> targetIds = latestPoints["ids"];

    for (Map<String, dynamic> tileObject in boardState) {
      if (targetIds.contains(tileObject["tileId"])) {
        updatedState.add({
          "tileId": tileObject["tileId"],
          "row": tileObject["row"],
          "column": tileObject["column"],
          "letter": tileObject["letter"],
          // "letter" : "X",
          "active": true,
          "alive": tileObject["alive"],
        });
      } else {
        updatedState.add(tileObject);
      }
    }
    return updatedState;
  }

  List<Map<String, dynamic>> replaceTilesInFoundWords(
      List<Map<String, dynamic>> letterBoardState,
      List<Map<String, dynamic>> turnSummaryData) {
    List<Map<String, dynamic>> updatedState = [];

    Map<String, dynamic> latestPoints =
        turnSummaryData[turnSummaryData.length - 1];
    List<String> targetIds = latestPoints["ids"];

    for (Map<String, dynamic> tileObject in letterBoardState) {
      if (targetIds.contains(tileObject["tileId"])) {
        updatedState.add({
          "tileId": tileObject["tileId"],
          "row": tileObject["row"],
          "column": tileObject["column"],
          "letter": "",
          "active": false,
          "alive": tileObject["alive"],
        });
      } else {
        updatedState.add(tileObject);
      }
    }
    return updatedState;
  }

  List<Map<String, dynamic>> updateRandomLetterState(
      List<Map<String, dynamic>> boardState,
      List<Map<String, dynamic>> randomState,
      List<Map<String, dynamic>> turnSummaryData) {
    List<Map<String, dynamic>> updatedRandomState = [];

    Map<String, dynamic> latestPoints =
        turnSummaryData[turnSummaryData.length - 1];
    List<String> targetIds = latestPoints["ids"];

    List<String> letterList = [];

    Map<String, int> letterCounts = {};
    for (String tileId in targetIds) {
      Map<String, dynamic> tileObject =
          boardState.firstWhere((element) => element["tileId"] == tileId);
      String tileLetter = tileObject["letter"];

      letterCounts[tileLetter] = (letterCounts[tileLetter] ?? 0) + 1;

      if (!letterList.contains(tileLetter)) {
        letterList.add(tileLetter);
      }
    }

    List<Map<String, dynamic>> aggregateLetters = letterCounts.entries
        .map((entry) => {"letter": entry.key, "count": entry.value})
        .toList();

    for (Map<String, dynamic> randomLetterObject in randomState) {
      String letter = randomLetterObject["letter"];
      if (letterList.contains(letter)) {
        Map<String, dynamic> correspondingLetterCount = aggregateLetters
            .firstWhere((element) => element["letter"] == letter);

        late Map<String, dynamic> newAlphabetObject = {
          "letter": randomLetterObject["letter"],
          "type": randomLetterObject["type"],
          "points": randomLetterObject["points"],
          "count":
              randomLetterObject["count"] + correspondingLetterCount["count"],
          "inPlay":
              randomLetterObject["inPlay"] - correspondingLetterCount["count"],
        };
        updatedRandomState.add(newAlphabetObject);
      } else {
        updatedRandomState.add(randomLetterObject);
      }
    }

    return updatedRandomState;
  }

  Map<String, dynamic> startingRandomLetterData(List<dynamic> alphabetState) {
    // initialize Random
    Random random = Random();

    // first, get a list of all letters
    late List<String> availableLetters = [];
    for (Map<String, dynamic> letter in alphabetState) {
      for (var i = 0; i < letter['count']; i++) {
        availableLetters.add(letter['letter']);
      }
    }

    // select a random number to pick from the first letter
    int randomIndex1 = random.nextInt(availableLetters.length);
    String randomLetter1 = availableLetters[randomIndex1];

    // remove the letter from the list so we don't get a duplicate
    availableLetters.removeWhere((element) => element == randomLetter1);

    // select from the updated list
    int randomIndex2 = random.nextInt(26);
    String randomLetter2 = availableLetters[randomIndex2];

    List<String> startingRandomLetterList = [randomLetter1, randomLetter2];

    List<Map<String, dynamic>> alphabetState1 = [];
    for (Map<String, dynamic> letterObject in alphabetState) {
      if (letterObject["letter"] == randomLetter1) {
        late Map<String, dynamic> newAlphabetObject = {
          "letter": letterObject["letter"],
          "type": letterObject["type"],
          "points": letterObject["points"],
          "count": letterObject["count"] - 1,
          "inPlay": letterObject["inPlay"] + 1,
        };
        alphabetState1.add(newAlphabetObject);
      } else {
        alphabetState1.add(letterObject);
      }
    }

    List<Map<String, dynamic>> alphabetState2 = [];
    for (Map<String, dynamic> letterObject in alphabetState1) {
      if (letterObject["letter"] == randomLetter2) {
        late Map<String, dynamic> newAlphabetObject = {
          "letter": letterObject["letter"],
          "type": letterObject["type"],
          "points": letterObject["points"],
          "count": letterObject["count"] - 1,
          "inPlay": letterObject["inPlay"] + 1,
        };
        alphabetState2.add(newAlphabetObject);
      } else {
        alphabetState2.add(letterObject);
      }
    }

    final Map<String, dynamic> startingRandomLetterData = {
      "list": startingRandomLetterList,
      "state": alphabetState2
    };

    return startingRandomLetterData;
  }

  double getFontSize(
      bool selected, Map<String, dynamic> state, double fontSizeVal) {
    double res = 0;
    if (selected) {
      res = fontSizeVal;
    } else {
      if (state["letter"] == "") {
        res = 0;
      } else {
        if (state["active"]) {
          res = fontSizeVal;
        } else {
          res = 22;
        }
      }
    }
    return res;
  }

  int getTotalPoints(List<Map<String, dynamic>> turnSummaryData) {
    int runningTally = 0;
    for (Map<String, dynamic> turnData in turnSummaryData) {
      int points = turnData["points"];
      runningTally = runningTally + points;
    }

    return runningTally;
  }

  int getPreviousPoints(List<Map<String, dynamic>> turnSummaryData) {
    int runningTally = 0;
    for (var i = 0; i < turnSummaryData.length - 1; i++) {
      Map<String, dynamic> turnData = turnSummaryData[i];
      int points = turnData["points"];
      runningTally = runningTally + points;
    }

    return runningTally;
  }

  int getTotalWords(List<Map<String, dynamic>> turnSummaryData) {
    int totalWords = 0;
    for (var i = 0; i < turnSummaryData.length; i++) {
      Map<String, dynamic> turnData = turnSummaryData[i];
      int words = turnData["words"].length;
      totalWords = totalWords + words;
    }
    return totalWords;
  }

  int getPreviousWords(List<Map<String, dynamic>> turnSummaryData) {
    int totalWords = 0;
    for (var i = 0; i < turnSummaryData.length - 1; i++) {
      Map<String, dynamic> turnData = turnSummaryData[i];
      int words = turnData["words"].length;
      totalWords = totalWords + words;
    }
    return totalWords;
  }

  int getActiveStreak(List<Map<String, dynamic>> turnSummaryData, int streak) {
    int res = 0;

    int totalPoints = getTotalPoints(turnSummaryData);
    int pointsLastTurn = getPreviousPoints(turnSummaryData);

    if (totalPoints == 0) {
      res = 0;
    } else {
      if (totalPoints > 0 && totalPoints == pointsLastTurn) {
        res = 0;
      } else {
        res = streak + 1;
      }
    }

    return res;
  }

  double getFontPreference(String preference, String itemType) {
    double res = 0;
    if (itemType == 'random_1') {
      if (preference == 'small') {
        res = 50;
      } else if (preference == 'medium') {
        res = 60;
      } else if (preference == 'large') {
        res = 70;
      }
    } else if (itemType == 'random_2') {
      if (preference == 'small') {
        res = 22;
      } else if (preference == 'medium') {
        res = 26;
      } else if (preference == 'large') {
        res = 30;
      }
    } else if (itemType == 'tile') {
      if (preference == 'small') {
        res = 18;
      } else if (preference == 'medium') {
        res = 22;
      } else if (preference == 'large') {
        res = 28;
      }
    }
    return res;
  }

  Map<String, dynamic> getTimeData(int currentSeconds) {
    late double hours = 0;
    late double minutes = 0;
    late double seconds = 0;

    seconds = (currentSeconds % 60);

    late double absoluteMinutes = (currentSeconds - seconds) / 60;

    if (currentSeconds >= 3600) {
      late double secondsExtraFromHour = (currentSeconds % 3600);
      late double hoursInSeconds = currentSeconds - secondsExtraFromHour;

      hours = hoursInSeconds / 3600;
      minutes = (absoluteMinutes % 60);
    } else {
      minutes = (currentSeconds - seconds) / 60;
    }

    final Map<String, dynamic> res = {
      "hours": hours.round(),
      "minutes": minutes.round(),
      "seconds": seconds.round(),
    };
    return res;
  }

  String formatTimeDigit(int digit) {
    String res = "";
    if (digit >= 0 && digit <= 9) {
      res = "0$digit";
    } else {
      res = "$digit";
    }
    return res;
  }

  String formatTime(int timeInSeconds) {
    String res = "";

    late Map<String, dynamic> timeData = getTimeData(timeInSeconds);

    String formattedHours = formatTimeDigit(timeData['hours']);
    String formattedMinutes = formatTimeDigit(timeData['minutes']);
    String formattedSeconds = formatTimeDigit(timeData['seconds']);

    if (timeData['hours'] >= 1) {
      res = "$formattedHours:$formattedMinutes:$formattedSeconds";
    } else {
      res = "$formattedMinutes:$formattedSeconds";
    }

    return res;
  }

  void executeTimerAnimation(animationState) async {
    animationState.setShouldRunTimerAnimation(true);
    animationState.setShouldRunTimerAnimation(false);
    // Timer(const Duration(seconds: 5), () {
    //   animationState.setShouldRunTimerAnimation(false);
    // });
  }

  Map<String, dynamic> generateStartingStates(
    // List<Map<String,dynamic>> initialRandomLetterState,
    List<dynamic> letterState,
    List<Map<String, dynamic>> initialTileState,
    List<String> initialRandomLetterList,
    // GamePlayState gamePlayState,
  ) {
    late List<Map<String, dynamic>> startingAlphabet = [];
    late List<Map<String, dynamic>> startingTileState = [];
    late List<String> startingRandomLetterList = [];

    // print("starting random letter data = $letterState ");
    late Map<String, dynamic> startingRandomLetterStates =
        startingRandomLetterData(letterState);

    // late Map<String,dynamic> startingRandomLetterStates = startingRandomLetterData(gamePlayState.alphabetState);
    startingAlphabet = startingRandomLetterStates['state'];
    startingRandomLetterList = startingRandomLetterStates['list'];
    startingTileState = initialTileState;

    late Map<String, dynamic> res = {
      "startingAlphabet": startingAlphabet,
      "startingRandomLetterList": startingRandomLetterList,
      "startingTileState": startingTileState
    };
    return res;
  }

  List<Map<String, dynamic>> resetTileState(
      List<Map<String, dynamic>> tileState) {
    late List<Map<String, dynamic>> newTileState = [];
    for (Map<String, dynamic> letter in tileState) {
      newTileState.add(
        {
          "tileId": letter['tileId'],
          "row": letter['row'],
          "column": letter['column'],
          "letter": "",
          "active": false,
          "alive": letter["alive"],
        },
      );
    }
    return newTileState;
  }

  void killTileSpot(GamePlayState gamePlayState, BuildContext context) {
    late AnimationState animationState = context.read<AnimationState>();

    /// Get a random letter object
    List<Map<String, dynamic>> boardState = gamePlayState.visualTileState;
    List<Map<String, dynamic>> openTiles = boardState
        .where((element) => element["letter"] == "" && element["alive"] == true)
        .toList();
    late Random random = Random();
    late int randomIndex = random.nextInt(openTiles.length);
    Map<String, dynamic> randomTileObject = openTiles[randomIndex];

    animationState.setShouldRunAnimation(true);

    // get the new random letter
    late Map<String, dynamic> randomLetterData = GameLogic()
        .generateRandomLetterData(
            gamePlayState.alphabetState, gamePlayState.randomLetterList);

    // get the new alphabet state (now that a letter has been taken out of the "bag")
    late List<Map<String, dynamic>> newAlphabetState =
        randomLetterData["randomState"];
    gamePlayState.setAlphabetState(newAlphabetState);

    // get the new list of random letters
    late List<String> newRandomLetterList = randomLetterData["randomList"];
    gamePlayState.setRandomLetterList(newRandomLetterList);

    // update the state of the board to reflect the letter going to that tile

    late List<Map<String, dynamic>> updatedTileState = [];
    for (Map<String, dynamic> tileObject in boardState) {
      if (tileObject["tileId"] == randomTileObject["tileId"]) {
        // print("${tileObject["tileId"]} ~~~ ${randomTileObject["tileId"]}");
        updatedTileState.add({
          "tileId": tileObject["tileId"],
          "row": tileObject["row"],
          "column": tileObject["column"],
          "letter": "",
          "active": false,
          "alive": false,
        });
      } else {
        updatedTileState.add(tileObject);
      }
    }
    gamePlayState.setVisualTileState(updatedTileState);

    // makes the letter that was to be placed, visible in the tile that was tapped

    late List<Map<String, dynamic>> newTurnSummaryState = GameLogic()
        .getTurnSummaryData(
            updatedTileState,
            gamePlayState.alphabetState,
            gamePlayState.gameSummaryLog,
            gamePlayState.currentTurn,
            gamePlayState.activeStreak);

    gamePlayState.countDownController.restart();
    // _audioController.playSfx(SfxType.tilePress);

    // animations
    animationState.setShouldRunStreaksEnterAnimation(false);
    animationState.setShouldRunStreaksExitAnimation(true);
    animationState.setShouldRunAnimation(false);
    animationState.setShouldRunWordAnimation(false);
    animationState.setShouldRunStreaksExitAnimation(false);
    animationState.setShouldRunPointsAnimation(false);

    gamePlayState.setActiveStreak(0);

    Map<String, dynamic> summary =
        GameLogic().getGameSummaryData(newTurnSummaryState);
    gamePlayState.setSummaryData(summary);

    bool isGameOver = checkGameOver(gamePlayState.visualTileState);
    if (isGameOver) {
      executeGameOver(gamePlayState, context);
    }
  }

  bool checkGameOver(List<Map<String, dynamic>> boardState) {
    int countOfOpenTiles = 0;
    for (Map<String, dynamic> tileObject in boardState) {
      if (tileObject["letter"] == "" && tileObject["alive"] == true) {
        countOfOpenTiles++;
      }
    }
    return countOfOpenTiles == 0;
  }

  void executeGameOver(GamePlayState gamePlayState, BuildContext context) {
    late Map<String, dynamic> newGameData = {
      "timeStamp": DateTime.now().toIso8601String(),
      "duration": gamePlayState.duration.inSeconds,
      "points": gamePlayState.summaryData['points'],
      "uniqueWords": gamePlayState.summaryData['uniqueWords'].length,
      "uniqueWordsList": gamePlayState.summaryData['uniqueWords'],
      "longestStreak": gamePlayState.summaryData['longestStreak'],
      "mostPoints": gamePlayState.summaryData['mostPoints'],
      "mostWords": gamePlayState.summaryData["mostWords"],
      "crossWords": gamePlayState.summaryData['crosswords'],
      "level": gamePlayState.currentLevel,
      "language": gamePlayState.currentLanguage,
    };
    FirestoreMethods()
        .saveHighScore(AuthService().currentUser!.uid, newGameData);

    gamePlayState.setEndOfGameData(newGameData);
    gamePlayState.setIsGameEnded(true);
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const GameOverScreen()));
    });
  }

  // Color getColor(bool darkTheme, Palette palette, String element) {
  //   late Color res;
  //   switch (element) {
  //     case "screen_background":
  //       darkTheme ? res = palette.darkScreenBgColor : res = palette.lightScreenBgColor;
  //       break;
  //     case "option_button_bg":
  //       darkTheme ? res = palette.darkOptionButtonBgColor : res = palette.lightOptionButtonBgColor;
  //       break;
  //     case "option_button_text":
  //       darkTheme ? res = palette.darkOptionButtonTextColor : res = palette.lightOptionButtonTextColor;
  //       break;
  //     case "tile_bg":
  //       darkTheme ? res = palette.darkTileBgColor : res = palette.lightTileBgColor;
  //       break;
  //     case "tile_border":
  //       darkTheme ? res = palette.darkTileBorderColor : res = palette.lightTileBorderColor;
  //       break;
  //     case "tile_text":
  //       darkTheme ? res = palette.darkTileTextColor : res = palette.lightTileTextColor;
  //       break;
  //     case "timer_text":
  //       darkTheme ? res = palette.darkTimerTextColor : res = palette.lightTimerTextColor;
  //       break;
  //     case "bottom_navigation_bar":
  //       darkTheme ? res = palette.darkBottomNavigationBarColor : res = palette.lightBottomNavigationBarColor;
  //       break;
  //     case "bottom_navigation_item":
  //       darkTheme ? res = palette.darkBottomNavigationBarItemColor : res = palette.lightBottomNavigationBarItemColor;
  //       break;
  //     case "modal_bg":
  //       darkTheme ? res = palette.darkModalBgColor : res = palette.lightModalBgColor;
  //       break;
  //     case "modal_text":
  //       darkTheme ? res = palette.darkModalTextColor : res = palette.lightModalTextColor;
  //       break;
  //     case "modal_navigation_bar":
  //       darkTheme ? res = palette.darkModalNavigationBarBgColor : res = palette.lightModalNavigationBarBgColor;
  //       break;
  //     case "modal_navigation_item":
  //       darkTheme ? res = palette.darkModalNavigationBarItemColor : res = palette.lightModalNavigationBarItemColor;
  //       break;
  //   }
  //   return res;
  // }

  int getCountdownDuration(int level) {
    int res = 10;
    switch (level) {
      case 1:
        res = 10;
        break;
      case 2:
        res = 9;
        break;
      case 3:
        res = 8;
        break;
      case 4:
        res = 7;
        break;
      case 5:
        res = 6;
        break;
      case 6:
        res = 5;
        break;
      case 7:
        res = 4;
        break;
      case 8:
        res = 3;
        break;
      case 9:
        res = 2;
        break;
      case 10:
        res = 1;
        break;

      // case 1: res = 1;
      //   break;
      // case 2: res = 1;
      //   break;
      // case 3: res = 1;
      //   break;
      // case 4: res = 1;
      //   break;
      // case 5: res = 1;
      //   break;
      // case 6: res = 1;
      //   break;
      // case 7: res = 1;
      //   break;
      // case 8: res = 1;
      //   break;
      // case 9: res = 1;
      //   break;
      // case 10: res = 1;
      //   break;
    }
    return res;
  }

  void runChangeLevelEffect(GamePlayState gamePlayState) {
    Future.delayed(const Duration(milliseconds: 1500), () {
      gamePlayState.setDisplayLevelChange(true);
      Future.delayed(const Duration(milliseconds: 1200), () {
        gamePlayState.setDisplayLevelChange(false);
      });
    });
  }

  Map<String, dynamic> shouldChangeLevels(GamePlayState gamePlayState) {
    // late bool res = false;
    late Map<String, dynamic> levelChangeData = {};
    final int points = gamePlayState.summaryData['points'];
    final int currentLevel = gamePlayState.currentLevel;
    final List<Map<String, dynamic>> levelMaps = [
      {"level": 1, "points_low": 0, "points_high": 50},
      {"level": 2, "points_low": 51, "points_high": 100},
      {"level": 3, "points_low": 101, "points_high": 150},
      {"level": 4, "points_low": 151, "points_high": 200},
      {"level": 5, "points_low": 201, "points_high": 250},
      {"level": 6, "points_low": 251, "points_high": 300},
      {"level": 7, "points_low": 301, "points_high": 350},
      {"level": 8, "points_low": 351, "points_high": 400},
      {"level": 9, "points_low": 401, "points_high": 450},
      {"level": 10, "points_low": 451, "points_high": double.infinity},
    ];

    Map<String, dynamic> correspondingMapBasedOnPoints = levelMaps.firstWhere(
        (element) =>
            element["points_low"] <= points &&
            element["points_high"] >= points);
    if (correspondingMapBasedOnPoints["level"] > currentLevel) {
      levelChangeData = {
        "levelUp": true,
        "previous": currentLevel,
        "upcoming": correspondingMapBasedOnPoints["level"]
      };
      // res = true;
    } else {
      // res = false;
    }
    return levelChangeData;
  }

  void changeLevels(GamePlayState gamePlayState) {
    if (gamePlayState.currentLevel == 1) {
      if (gamePlayState.summaryData['points'] >= 51) {
        gamePlayState.setPreviousLevel(1);
        gamePlayState.setCurrentLevel(2);
        // runChangeLevelEffect(gamePlayState);

        // const LevelChangeOverlay(levelText: "3");
      }
    }

    if (gamePlayState.currentLevel == 2) {
      if (gamePlayState.summaryData['points'] >= 101) {
        gamePlayState.setPreviousLevel(2);
        gamePlayState.setCurrentLevel(3);
        // runChangeLevelEffect(gamePlayState);

        // const LevelChangeOverlay(levelText: "3");
      }
    }

    if (gamePlayState.currentLevel == 3) {
      if (gamePlayState.summaryData['points'] >= 151) {
        gamePlayState.setPreviousLevel(3);
        gamePlayState.setCurrentLevel(4);
        // runChangeLevelEffect(gamePlayState);
      }
    }

    if (gamePlayState.currentLevel == 4) {
      if (gamePlayState.summaryData['points'] >= 201) {
        gamePlayState.setPreviousLevel(4);
        gamePlayState.setCurrentLevel(5);
        // runChangeLevelEffect(gamePlayState);
      }
    }

    if (gamePlayState.currentLevel == 5) {
      if (gamePlayState.summaryData['points'] >= 251) {
        gamePlayState.setPreviousLevel(5);
        gamePlayState.setCurrentLevel(6);
        // runChangeLevelEffect(gamePlayState);
      }
    }

    if (gamePlayState.currentLevel == 6) {
      if (gamePlayState.summaryData['points'] >= 301) {
        gamePlayState.setPreviousLevel(6);
        gamePlayState.setCurrentLevel(7);
        // runChangeLevelEffect(gamePlayState);
      }
    }

    if (gamePlayState.currentLevel == 7) {
      if (gamePlayState.summaryData['points'] >= 351) {
        gamePlayState.setPreviousLevel(7);
        gamePlayState.setCurrentLevel(8);
        // runChangeLevelEffect(gamePlayState);
      }
    }

    if (gamePlayState.currentLevel == 8) {
      if (gamePlayState.summaryData['points'] >= 401) {
        gamePlayState.setPreviousLevel(8);
        gamePlayState.setCurrentLevel(9);
        // runChangeLevelEffect(gamePlayState);
      }
    }

    if (gamePlayState.currentLevel == 9) {
      if (gamePlayState.summaryData['points'] >= 451) {
        gamePlayState.setPreviousLevel(9);
        gamePlayState.setCurrentLevel(10);
        // runChangeLevelEffect(gamePlayState);
      }
    }
  }

  void pressTile(BuildContext context, int row, int column,
      GamePlayState gamePlayState, AudioController audioController) async {
    late AnimationState animationState = context.read<AnimationState>();

    // get the tile id as a string
    String tileKey = "${row}_$column";

    // check whether the board has a letter in that spot
    bool isTileOpen =
        GameLogic().isTileOpen(gamePlayState.visualTileState, tileKey);

    if (isTileOpen && !gamePlayState.isAnimating) {
      gamePlayState.setPressedTile(tileKey);

      // Set signal to animate the random letters changing, the tile being pressed
      animationState.setShouldRunAnimation(true);

      // get the new random letter
      late Map<String, dynamic> randomLetterData = GameLogic()
          .generateRandomLetterData(
              gamePlayState.alphabetState, gamePlayState.randomLetterList);

      // get the new alphabet state (now that a letter has been taken out of the "bag")
      late List<Map<String, dynamic>> newAlphabetState =
          randomLetterData["randomState"];
      gamePlayState.setAlphabetState(newAlphabetState);

      // get the new list of random letters
      late List<String> newRandomLetterList = randomLetterData["randomList"];
      gamePlayState.setRandomLetterList(newRandomLetterList);

      // get the newly created letter
      late String newLetter =
          newRandomLetterList[newRandomLetterList.length - 3];

      executeTilePlacement(
          context, gamePlayState, audioController, newLetter, tileKey);
    }
  }

  void dropTile(BuildContext context, int row, int column,
      GamePlayState gamePlayState, AudioController audioController) async {
    // late AnimationState _animationState = context.read<AnimationState>();

    // get the tile id as a string
    String tileKey = "${row}_$column";

    // check whether the board has a letter in that spot
    bool isTileOpen =
        GameLogic().isTileOpen(gamePlayState.visualTileState, tileKey);

    if (isTileOpen && !gamePlayState.isAnimating) {
      gamePlayState.setPressedTile(tileKey);

      String newLetter = gamePlayState.draggedReserveTile["body"];

      List<Map<String, dynamic>> updatedReserveTiles = removeFromReserves(
          gamePlayState.reserveTiles, gamePlayState.draggedReserveTile);

      gamePlayState.setReserveTiles(updatedReserveTiles);

      executeTilePlacement(
          context, gamePlayState, audioController, newLetter, tileKey);
    }
  }

  void executeTilePlacement(BuildContext context, GamePlayState gamePlayState,
      AudioController audioController, String newLetter, String tileKey) {
    late AnimationState animationState = context.read<AnimationState>();
    // update the state of the board to reflect the letter going to that tile
    late List<Map<String, dynamic>> newBoardState = GameLogic()
        .updateBoardLetterState(
            gamePlayState.visualTileState, newLetter, tileKey);
    // makes the letter that was to be placed, visible in the tile that was tapped
    gamePlayState.setVisualTileState(newBoardState);

    late List<Map<String, dynamic>> newTurnSummaryState = GameLogic()
        .getTurnSummaryData(
            newBoardState,
            gamePlayState.alphabetState,
            gamePlayState.gameSummaryLog,
            gamePlayState.currentTurn,
            gamePlayState.activeStreak);
    // now check if words were found
    if (newTurnSummaryState[newTurnSummaryState.length - 1]["words"].length >
        0) {
      audioController.playSfx(SfxType.wordFound);

      gamePlayState.setIsAnimating(true);

      // this state updates target tiles with the "active" property set to true to know what tile gets an animation
      List<Map<String, dynamic>> updatedTemporaryBoardState = GameLogic()
          .startFoundWordAnimation(newBoardState, newTurnSummaryState);
      gamePlayState.setVisualTileState(updatedTemporaryBoardState);

      List<Map<String, dynamic>> updateNewBoardState = GameLogic()
          .replaceTilesInFoundWords(newBoardState, newTurnSummaryState);

      List<Map<String, dynamic>> updatedNewAlphabetState = GameLogic()
          .updateRandomLetterState(
              newBoardState, gamePlayState.alphabetState, newTurnSummaryState);
      gamePlayState.setAlphabetState(updatedNewAlphabetState);

      // checks whether there's an active streak to account for
      int newStreak = GameLogic()
          .getActiveStreak(newTurnSummaryState, gamePlayState.activeStreak);
      if (newStreak == 2) {
        audioController.playSfx(SfxType.wordFound);
        animationState.setShouldRunStreaksEnterAnimation(true);
      }

      if (newTurnSummaryState[newTurnSummaryState.length - 1]["crossword"] ==
          2) {
        animationState.setShouldRunCrossWordAnimation(true);
      }

      if (newTurnSummaryState[newTurnSummaryState.length - 1]["count"] > 1) {
        animationState.setShouldRunMultiWordAnimation(true);
      }

      // update the score summary data
      Map<String, dynamic> summary =
          GameLogic().getGameSummaryData(newTurnSummaryState);
      gamePlayState.setSummaryData(summary);

      // add the score to the tally
      gamePlayState
          .setTurnScore(GameLogic().getPreviousPoints(newTurnSummaryState));

      // Execute Animations for found words and new points
      animationState.setShouldRunWordAnimation(true);
      animationState.setShouldRunPointsAnimation(true);

      Future.delayed(const Duration(milliseconds: 1000), () {
        gamePlayState
            .setTurnScore(GameLogic().getTotalPoints(newTurnSummaryState));
        gamePlayState
            .setTurnWords(GameLogic().getTotalWords(newTurnSummaryState));
        gamePlayState.setActiveStreak(newStreak);
      });

      // _gamePlayState.countDownController.restart(duration: GameLogic().getCountdownDuration(_gamePlayState.currentLevel));
      gamePlayState.countDownController.pause();
      late Map<String, dynamic> levelUpData = shouldChangeLevels(gamePlayState);
      if (levelUpData.isNotEmpty) {
        gamePlayState.setPreviousLevel(levelUpData['previous']);
        gamePlayState.setCurrentLevel(levelUpData['upcoming']);
        gamePlayState.setDisplayLevelChange(true);
      }
      // print(levelUp);

      Future.delayed(const Duration(milliseconds: 1500), () {
        gamePlayState.setVisualTileState(updateNewBoardState);

        // if (levelUpData.isNotEmpty) {
        // //   // changeLevels(_gamePlayState);
        //   gamePlayState.setPreviousLevel(levelUpData['previous']);
        //   gamePlayState.setCurrentLevel(levelUpData['upcoming']);
        // gamePlayState.setDisplayLevelChange(true);
        //   // Future.delayed(const Duration(milliseconds: 800), () {
        //     // _gamePlayState.countDownController.resume();
        //     gamePlayState.countDownController.restart(
        //         duration: GameLogic()
        //             .getCountdownDuration(gamePlayState.currentLevel));
        //     gamePlayState.setDisplayLevelChange(false);
        //   // });
        // } else {
        //   gamePlayState.countDownController.restart(
        //       duration:
        //           GameLogic().getCountdownDuration(gamePlayState.currentLevel));
        //   // ensures that in the event that a user pauses the game while animating - the countdown doesn't keep going
        //   if (gamePlayState.isGamePaused) {
        //     gamePlayState.countDownController.pause();
        //   }
        // }
        gamePlayState.countDownController.restart(
            duration:
                GameLogic().getCountdownDuration(gamePlayState.currentLevel));
        gamePlayState.setDisplayLevelChange(false);
        if (gamePlayState.isGamePaused) {
          gamePlayState.countDownController.pause();
        }

        gamePlayState.setIsAnimating(false);
      });
      animationState.setShouldRunWordAnimation(false);
      animationState.setShouldRunPointsAnimation(false);
      animationState.setShouldRunStreaksEnterAnimation(false);
      animationState.setShouldRunAnimation(false);
      animationState.setShouldRunMultiWordAnimation(false);
      animationState.setShouldRunCrossWordAnimation(false);
    } else {
      gamePlayState.countDownController.restart(
          duration:
              GameLogic().getCountdownDuration(gamePlayState.currentLevel));
      audioController.playSfx(SfxType.tilePress);
      // animations
      animationState.setShouldRunStreaksEnterAnimation(false);
      animationState.setShouldRunStreaksExitAnimation(true);
      animationState.setShouldRunAnimation(false);
      animationState.setShouldRunWordAnimation(false);
      animationState.setShouldRunStreaksExitAnimation(false);
      animationState.setShouldRunPointsAnimation(false);
      animationState.setShouldRunMultiWordAnimation(false);
      animationState.setShouldRunCrossWordAnimation(false);
      gamePlayState.setActiveStreak(0);

      Map<String, dynamic> summary =
          GameLogic().getGameSummaryData(newTurnSummaryState);
      gamePlayState.setSummaryData(summary);

      bool isGameOver =
          GameLogic().checkGameOver(gamePlayState.visualTileState);
      if (isGameOver) {
        GameLogic().executeGameOver(gamePlayState, context);
      }
    }
  }

  List<Map<String, dynamic>> removeFromReserves(
      List<Map<String, dynamic>> reserveTiles,
      Map<String, dynamic> spotToRemove) {
    // List<Map<String, dynamic>> newSpots = [];
    for (Map<String, dynamic> reserveSpot in reserveTiles) {
      if (spotToRemove["id"] == reserveSpot["id"]) {
        // newSpots.add({"id": spotToRemove["id"], "body": ""});
        reserveSpot.update("body", (value) => "");
      } // else {
      //   newSpots.add(reserveSpot);
      // }
    }
    return reserveTiles;
    // return newSpots;
  }

  void placeIntoReserves(BuildContext context, GamePlayState gamePlayState,
      Map<String, dynamic> reserveSpot) {
    late AnimationState animationState = context.read<AnimationState>();

    if (reserveSpot["body"] == "") {
      animationState.setShouldRunAnimation(true);
      // get the new random letter
      late Map<String, dynamic> randomLetterData = GameLogic()
          .generateRandomLetterData(
              gamePlayState.alphabetState, gamePlayState.randomLetterList);

      // get the new alphabet state (now that a letter has been taken out of the "bag")
      late List<Map<String, dynamic>> newAlphabetState =
          randomLetterData["randomState"];
      gamePlayState.setAlphabetState(newAlphabetState);

      // get the new list of random letters
      late List<String> newRandomLetterList = randomLetterData["randomList"];
      gamePlayState.setRandomLetterList(newRandomLetterList);

      // get the newly created letter
      late String newLetter =
          newRandomLetterList[newRandomLetterList.length - 3];

      List<Map<String, dynamic>> newReserves = [];
      for (Map<String, dynamic> spot in gamePlayState.reserveTiles) {
        if (reserveSpot["id"] == spot["id"]) {
          newReserves.add({"id": reserveSpot["id"], "body": newLetter});
        } else {
          newReserves.add(spot);
        }
      }

      gamePlayState.setReserveTiles(newReserves);
      gamePlayState.countDownController.restart(
          duration:
              GameLogic().getCountdownDuration(gamePlayState.currentLevel));
    }
  }
}
