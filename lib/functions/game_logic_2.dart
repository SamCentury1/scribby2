import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/audio/audio_controller.dart';
import 'package:scribby_flutter_v2/audio/sounds.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';

import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/resources/auth_service.dart';
import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
// import 'package:scribby_flutter_v2/utils/states.dart';

class GameLogic {
  Map<String, dynamic> generateRandomLetterData(GamePlayState gamePlayState) {
    List<Map<String, dynamic>> alphabet = gamePlayState.alphabetState;

    List<String> randomLettersList = gamePlayState.randomLetterList;
    List<int> randomShadeList = gamePlayState.randomShadeList;
    List<int> randomAngleList = gamePlayState.randomAngleList;
    Random random = Random();

    String letterType = getNextLetterType(alphabet);
    String previousLetter = randomLettersList[randomLettersList.length - 1];
    List<String> availableLetters = [];
    for (Map<String, dynamic> randomLetterObject in alphabet) {
      for (var i = 1; i < randomLetterObject["count"]; i++) {
        if (randomLetterObject["type"] == letterType &&
            randomLetterObject["letter"] != previousLetter) {
          availableLetters.add(randomLetterObject["letter"]);
        }
      }
    }

    int availableLettersCount = availableLetters.length;


    int randomIndex = random.nextInt(availableLettersCount);
    String randomLetter = availableLetters[randomIndex];

    List<Map<String, dynamic>> newRandomLetterState = [];
    for (Map<String, dynamic> randomLetterObject in alphabet) {
      if (randomLetterObject["letter"] == randomLetter) {
        randomLetterObject.update("count", (value) => randomLetterObject["count"] - 1);
        randomLetterObject.update("inPlay", (value) => randomLetterObject["inPlay"] + 1);
      }
      newRandomLetterState.add(randomLetterObject);
    }

    int randomShadeIndex = random.nextInt(5);
    int randomAngleIndex = random.nextInt(5);
    final List<String> newRandomLettersList = [...randomLettersList,randomLetter];
    final List<int> newRandomShadeList = [...randomShadeList,randomShadeIndex];
    final List<int> newRandomAngleList = [...randomAngleList,randomAngleIndex];

    final Map<String, dynamic> randomLetterData = {
      "randomList": newRandomLettersList,
      "shadeList": newRandomShadeList,
      "angleList": newRandomAngleList,
      "randomState": newRandomLetterState,
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
      if (shareOfVowels <= 0.49) {
        res = "vowel";
      } else if (shareOfVowels > 0.50) {
        res = "consonant";
      } else {
        Random random = Random();
        int randomNumber = random.nextInt(10);
        if (randomNumber > 5) {
          res ='vowel';
        } else {
          res = 'consonant';
        }
      }
    }
    return res;
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

  int displayRandomLetterStyle(List<int> randomList, int position) {
    late int style;
    if (position == 3) {
      if (randomList.length < 3) {
        style = 0;
      } else {
        style = randomList[randomList.length - position];
      }
    } else {
      style = randomList[randomList.length - position];
    }
    return style;
  }  




  void validateString(GamePlayState gamePlayState) {
    List<Map<String,dynamic>> validWords = [];
    List<Map<String,dynamic>> ids = [];
    for(List<dynamic> combination in gamePlayState.combinations) {
      List<String> letters = [];
      for (int index in combination) {
        Map<dynamic,dynamic> tileObject = Helpers().getTileObject(gamePlayState, index);
        if (tileObject["letter"] != "") {
          letters.add(tileObject["letter"]) ;
        } else {
          letters.add("-");
        }
      }
      String string = letters.join("");

      

      if (gamePlayState.dictionary.contains(string)) {
        for (int item in combination) {
          if (!ids.contains(item)) {
            Map<dynamic,dynamic> tileObject = Helpers().getTileObject(gamePlayState, item);
            ids.add({"id" : item, "body" : tileObject["letter"]});
          }
        }
        validWords.add({"word" : string, "ids" : combination}); 
      }
    }
    gamePlayState.setValidIds(ids);
    gamePlayState.setValidStrings(validWords);
    
  }    


  void checkGameOver(GamePlayState gamePlayState, AnimationState animationState,BuildContext context) {

    List<dynamic> emptyTiles = [];
    for (Map<dynamic,dynamic> item in gamePlayState.tileState) {
      if (item['letter'] == "" && item['alive']){
        emptyTiles.add(item['index']);
      }
    }

    if (emptyTiles.isEmpty) {
      
      gamePlayState.countDownController.pause();
      executeGameOver(gamePlayState,context);
      animationState.setShouldRunTimerAnimation(false);
      animationState.setShouldRunGameEndedAnimation(true);  
    }
  }


  void tileTapDownBehavior(GamePlayState gamePlayState, AnimationState animationState, int index) {
    gamePlayState.setSelectedTileIndex(index);
  }

  void tileTapUpBehavior(BuildContext context, GamePlayState gamePlayState, AnimationState animationState, int index) {


    if (index == gamePlayState.selectedTileIndex) {
      
      animationState.setShouldRunWordFoundAnimation(false);
      // animationState.setShouldRunTimerAnimation(false);
      late AudioController audioController = context.read<AudioController>();
      gamePlayState.countDownController.restart(
        duration: Helpers().getCountdownDuration(gamePlayState.currentLevel)
      );
      gamePlayState.countDownController.pause();

      audioController.playSfx(SfxType.tilePress);
      // LAUNCH ANIMATION
      animationState.setShouldRunTileTappedAnimation(true);

      late Map<String, dynamic> randomLetterData = GameLogic().generateRandomLetterData(gamePlayState);

      // get the new alphabet state (now that a letter has been taken out of the "bag")
      late List<Map<String, dynamic>> newAlphabetState = randomLetterData["randomState"];
      gamePlayState.setAlphabetState(newAlphabetState);

      // get the new list of random letters
      late List<String> newRandomLetterList = randomLetterData["randomList"];
      gamePlayState.setRandomLetterList(newRandomLetterList);

      late List<int> newRandomShadeList = randomLetterData["shadeList"];
      gamePlayState.setRandomShadeList(newRandomShadeList);   

      late List<int> newRandomAngleList = randomLetterData["angleList"];
      gamePlayState.setRandomAngleList(newRandomAngleList);           

      late String newLetter = newRandomLetterList[newRandomLetterList.length - 3];
      late int newShade = newRandomShadeList[newRandomShadeList.length-3];
      late int newAngle = newRandomAngleList[newRandomAngleList.length-3];

      // GET STATE WITH TILE ADDED TO BOARD
      List<dynamic> tileStatePostTap = List.from(gamePlayState.tileState.map((tile) {
        if (tile['index'] == gamePlayState.selectedTileIndex) {
          return {...tile,'letter': newLetter, 'shade': newShade, 'angle': newAngle};
        } else {
          return tile;
        }
      }));


      // CALCULATE THE DURATION OF THE ANIM FOR THE TILE MOVING IINTO PLACE BASED ON WHERE IT IS
      final int duration = 280;

      
      // SET A DELAY - TILESTATEPOSTTAP DOES
      Future.delayed(Duration(milliseconds: duration), () {
      // Future.microtask(() {
    
        animationState.setShouldRunTileTappedAnimation(false);

        // gamePlayState.countDownController.restart(duration: 10);
        animationState.setShouldRunTimerAnimation(true);          


        gamePlayState.setTileState(tileStatePostTap);
        validateString(gamePlayState);

        
        /// IF SCORE
        if (gamePlayState.validStrings.isNotEmpty) {


          Helpers().executeWordFoundSounds(audioController,gamePlayState.validStrings.length);
          animationState.setShouldRunScoreBoardPointsCount(true);  

          processScore(gamePlayState);

          Helpers().executeStreakSound(audioController,gamePlayState);
          Helpers().executeCrossWordSound(audioController,gamePlayState);



          shouldLevelUp(context, gamePlayState,animationState);

          runStreakAnimation(gamePlayState,animationState);

          gamePlayState.countDownController.pause();

          List<dynamic> validIdIndexes = gamePlayState.validIds.map((e) => e['id']).toList();

          List<dynamic> tileStatePostFoundWord = List.from(gamePlayState.tileState.map((tile) {

            
            if (validIdIndexes.contains(tile['index'])) {
              return {...tile, 'letter': ""};
            } else {
              return tile;
            }
          }));
          gamePlayState.setTileState(tileStatePostFoundWord);
          animationState.setShouldRunWordFoundAnimation(true);
          

          Helpers().updateRandomLetterDataAfterWordFound(gamePlayState);
  

        } else {
          Helpers().setEmptyTurnScoreLog(gamePlayState);

          runStreakAnimation(gamePlayState,animationState);

          gamePlayState.countDownController.resume();
          checkGameOver(gamePlayState,animationState,context);
        }
        gamePlayState.setSelectedTileIndex(-1);
      });
    } else if (index != gamePlayState.selectedTileIndex) {

    }

      
  }

  void tileTapCancelBehavior(GamePlayState gamePlayState) {
      gamePlayState.setSelectedTileIndex(-1);
  }


  void reserveTapDownBehavior(GamePlayState gamePlayState, AnimationState animationState, int index) {
    gamePlayState.setSelectedReserveIndex(index);
  }

  void reserveTapUpBehavior(BuildContext context, GamePlayState gamePlayState, AnimationState animationState, int index) {

    if (index == gamePlayState.selectedReserveIndex) {
      late AudioController audioController = context.read<AudioController>();
      audioController.playSfx(SfxType.tilePress);

      // LAUNCH ANIMATION
      animationState.setShouldRunWordFoundAnimation(false);
      animationState.setShouldRunTileTappedAnimation(true);
      gamePlayState.countDownController.pause();




      late Map<String, dynamic> randomLetterData = GameLogic().generateRandomLetterData(gamePlayState);

      // get the new alphabet state (now that a letter has been taken out of the "bag")
      late List<Map<String, dynamic>> newAlphabetState = randomLetterData["randomState"];
      gamePlayState.setAlphabetState(newAlphabetState);

      // get the new list of random letters
      late List<String> newRandomLetterList = randomLetterData["randomList"];
      gamePlayState.setRandomLetterList(newRandomLetterList);

      late List<int> newRandomShadeList = randomLetterData["shadeList"];
      gamePlayState.setRandomShadeList(newRandomShadeList);   

      late List<int> newRandomAngleList = randomLetterData["angleList"];
      gamePlayState.setRandomAngleList(newRandomAngleList);           

      late String newLetter = newRandomLetterList[newRandomLetterList.length - 3];
      late int newShade = newRandomShadeList[newRandomShadeList.length-3];
      late int newAngle = newRandomAngleList[newRandomAngleList.length-3];

      List<Map<String, dynamic>> reserveStatePostTap = List.from(gamePlayState.reserveTiles.map((reserve) {
        if (reserve['id'] == gamePlayState.selectedReserveIndex) {
          return {'id': reserve['id'], 'body': newLetter,'shade':newShade,'angle':newAngle};
        } else {
          return reserve;
        }
      }));

      gamePlayState.countDownController.restart(
        duration: Helpers().getCountdownDuration(gamePlayState.currentLevel)
      );

      Future.delayed(const Duration(milliseconds: 280), () {
        gamePlayState.setReserveTiles(reserveStatePostTap);
        gamePlayState.setSelectedReserveIndex(-1);
        animationState.setShouldRunTileTappedAnimation(false);
        
        animationState.setShouldRunTimerAnimation(true);           
      });

      Helpers().setEmptyTurnScoreLog(gamePlayState);
      runStreakAnimation(gamePlayState,animationState);
    }
    


  }


  void reserveTapCancelBehavior(GamePlayState gamePlayState) {
    gamePlayState.setSelectedReserveIndex(-1);
  }


  void dropDraggedTileBehavior(BuildContext context, GamePlayState gamePlayState, AnimationState animationState, int dropIndex) {
    
    late AudioController audioController = context.read<AudioController>();

    audioController.playSfx(SfxType.tilePress);

    animationState.setShouldRunWordFoundAnimation(false);

    gamePlayState.setDroppedTileIndex(dropIndex);


    animationState.setShouldRunTileDroppedAnimation(true);

    final String letter = gamePlayState.draggedReserveTile['body'];

    

    List<Map<String, dynamic>> reserveTileStatePostDrop = List.from(gamePlayState.reserveTiles.map((reserve) {
      if (reserve['id'] == gamePlayState.draggedReserveTile['id']) {return {...reserve,'body': ""};} else {return reserve;}
    }));

    

    List<dynamic> tileStatePostDrop = List.from(gamePlayState.tileState.map((tile) {
      if (tile['index'] == dropIndex) { return {...tile, 'letter': letter};} else {return tile;}
    }));


    gamePlayState.setReserveTiles(reserveTileStatePostDrop); 
    gamePlayState.setTileState(tileStatePostDrop);    
    Future.delayed(const Duration(milliseconds: 100), () {

      animationState.setShouldRunTileDroppedAnimation(false);
 
      validateString(gamePlayState);

      if (gamePlayState.validStrings.isNotEmpty) {

        // audioController.playSfx(SfxType.wordFound);
        Helpers().executeWordFoundSounds(audioController,gamePlayState.validStrings.length);     

        processScore(gamePlayState);

        Helpers().executeStreakSound(audioController,gamePlayState);
        Helpers().executeCrossWordSound(audioController,gamePlayState);
        shouldLevelUp(context, gamePlayState,animationState);
        runStreakAnimation(gamePlayState,animationState);

        

        gamePlayState.countDownController.pause();

        List<dynamic> validIdIndexes = gamePlayState.validIds.map((e) => e['id']).toList();

        List<dynamic> tileStatePostFoundWord = List.from(gamePlayState.tileState.map((tile) {
          if (validIdIndexes.contains(tile['index'])) {
            return {...tile, 'letter': ""};} else {return tile;}
          })
        );


        gamePlayState.setDroppedTileIndex(-1);
        gamePlayState.setTileState(tileStatePostFoundWord);
        animationState.setShouldRunWordFoundAnimation(true);
        animationState.setShouldRunTimerAnimation(false);
        gamePlayState.setDraggedReserveTile({});

      } else {
        gamePlayState.countDownController.restart(
          duration: Helpers().getCountdownDuration(gamePlayState.currentLevel)
        );
        animationState.setShouldRunTimerAnimation(true);  
        checkGameOver(gamePlayState,animationState,context);
        Helpers().setEmptyTurnScoreLog(gamePlayState);
        runStreakAnimation(gamePlayState,animationState);
        gamePlayState.setDraggedReserveTile({});

      }
    });
  }


  void wordFoundAnimationCompletedBehavior(GamePlayState gamePlayState, AnimationState animationState) {
    animationState.setShouldRunWordFoundAnimation(false);
    if (!gamePlayState.isGamePaused) {
      gamePlayState.countDownController.restart(
        duration: Helpers().getCountdownDuration(gamePlayState.currentLevel)
      );
    }
    // animationState.setShouldRunTimerAnimation(true);
  }

  void executeTimeRanOut(BuildContext context, GamePlayState gamePlayState, AnimationState animationState) {
    animationState.setShouldRunTileTappedAnimation(false);
    animationState.setShouldRunTimerAnimation(false);

    late AudioController audioController = context.read<AudioController>();

    // // GENERATE A RANDOM LETTER AND ADD IT TO THE ARRAY OF RANDOM LETTERS 
    // generateRandomLetter(gamePlayState);

    Random rand = Random();
    List<int> availableTiles = [];
    for (Map<dynamic,dynamic> tileObject in gamePlayState.tileState) {
      if (tileObject['letter']=="" && tileObject['alive']) {
        availableTiles.add(tileObject['index']);
      }
    }
    int randIndex = rand.nextInt(availableTiles.length);
    int randomTileIndex = availableTiles[randIndex];

    List<dynamic> newTileState = List.from(gamePlayState.tileState.map((tile) {
      if (tile['index'] == randomTileIndex) {
        return {...tile, 'alive': false};} else {return tile;}
      })
    );
    audioController.playSfx(SfxType.bad);
    animationState.setShouldRunKillTileAnimation(true);
    gamePlayState.setkilledTileIndex(randomTileIndex);
    gamePlayState.setTileState(newTileState);
    Future.delayed(const Duration(milliseconds: 300), () {
      gamePlayState.countDownController.restart(
        duration: Helpers().getCountdownDuration(gamePlayState.currentLevel)
      );      
      animationState.setShouldRunTimerAnimation(true);
      animationState.setShouldRunKillTileAnimation(false);
      gamePlayState.setkilledTileIndex(-1);
      checkGameOver(gamePlayState,animationState,context);
    });
  }










  //// SCORING
  void processScore(GamePlayState gamePlayState) {


    int currentScore = gamePlayState.scoringLog[gamePlayState.scoringLog.length-1]['cumulativePoints']; 
    int currentWords = gamePlayState.scoringLog[gamePlayState.scoringLog.length-1]['cumulativeWords']; 
    int streak = gamePlayState.scoringLog[gamePlayState.scoringLog.length-1]['streak']; 
    List<Map<String,dynamic>> wordValues = [];

    int score = 0;
    int wordsLength = gamePlayState.validStrings.length;

    for (Map<String,dynamic> validString in gamePlayState.validStrings) {
      int wordPoints = 0;
      for (int id in validString['ids']) {
        String letter = gamePlayState.validIds.firstWhere((element) => element['id'] == id)['body'];
        int value = gamePlayState.alphabetState.firstWhere((element) => element['letter']==letter)['points'];
        wordPoints = wordPoints+value;
      }
      if (validString['ids'].length == 5) {wordPoints = wordPoints*2;}
      if (validString['ids'].length == 6) {wordPoints = wordPoints*3;}
      score = score + wordPoints;
      wordValues.add({"word": validString['word'], "points": wordPoints});
    }

    bool wasCrossWord = Helpers().getWasCrossWord(gamePlayState);
    int streakMultiplier = streak+1;
    int wordMultiplier = wordsLength;
    int crossWordMultiplier = wasCrossWord ? 2 : 1;

    final int total = score *streakMultiplier * wordMultiplier * crossWordMultiplier;


    gamePlayState.setScoringLog(
      [
        ...gamePlayState.scoringLog,
        {
          "turn" : gamePlayState.scoringLog.length,
          "points": total,
          "cumulativePoints" : currentScore+total,
          "words": wordsLength,
          "wordValues": wordValues,
          "cumulativeWords" : currentWords+wordsLength,
          "streak" : streakMultiplier,
          "crossWord": crossWordMultiplier,
        }
      ]
    );
  }


  void runStreakAnimation(GamePlayState gamePlayState, AnimationState animationState) {
    
    late Map<String,dynamic> lastTurnData = gamePlayState.scoringLog[0];
    if (gamePlayState.scoringLog.length > 1) {
      lastTurnData = gamePlayState.scoringLog[gamePlayState.scoringLog.length-1];
    }
    int streak = lastTurnData['streak'];
    if (streak ==2) {
      animationState.setShouldRunStreakInAnimation(true);
      Future.microtask(() {
        animationState.setShouldRunStreakInAnimation(false);
      });
    }

    if (streak == 0) {
      if (gamePlayState.scoringLog[gamePlayState.scoringLog.length-2]['streak'] > 1) {
        animationState.setShouldRunStreakOutAnimation(true);
        Future.microtask(() {
          animationState.setShouldRunStreakOutAnimation(false);
        });
      }
    }
  }


  void shouldLevelUp(BuildContext context, GamePlayState gamePlayState, AnimationState animationState) {
    late AudioController audioController = context.read<AudioController>();
    final List<Map<String, dynamic>> levelMaps = [
      {"level": 1, "points_low": 0, "points_high": 100},
      {"level": 2, "points_low": 101, "points_high": 200},
      {"level": 3, "points_low": 201, "points_high": 350},
      {"level": 4, "points_low": 351, "points_high": 500},
      {"level": 5, "points_low": 501, "points_high": 1000},
      {"level": 6, "points_low": 1001, "points_high": 1500},
      {"level": 7, "points_low": 1501, "points_high": 2000},
      {"level": 8, "points_low": 2001, "points_high": 3000},
      {"level": 9, "points_low": 3001, "points_high": 5000},
      {"level": 10, "points_low": 5001, "points_high": double.infinity},
    ];
   
    final Map<String,dynamic> turnData = gamePlayState.scoringLog[gamePlayState.scoringLog.length-1];
    final int score = turnData['cumulativePoints'];
    late int upperBound = 0;
    final Map<String,dynamic> currentLevelObject = levelMaps.firstWhere((element) => element['level']==gamePlayState.currentLevel);
    upperBound = currentLevelObject['points_high'];
    if (score > upperBound) {
      gamePlayState.setCurrentLevel(gamePlayState.currentLevel+1);
      audioController.playSfx(SfxType.levelUp);
      animationState.setShouldRunLevelUpAnimation(true);
      Future.microtask(() {
        animationState.setShouldRunLevelUpAnimation(false);
      });
    }
  }





  List<Map<String, dynamic>> getTurnSummaryData(
    List<dynamic> boardState,
    List<Map<String, dynamic>> randomLetterState,
    List<Map<String, dynamic>> summaryState,
    int turn,
    int activeStreak,
    GamePlayState gamePlayState,
  ) {
    List<Map<String, dynamic>> validStringObjects = [];
    List<String> dictionary = gamePlayState.dictionary;

    for (List<dynamic> comboIds in gamePlayState.combinations) {

      List<Map<String, dynamic>> contents = [];
      List<String> letters = [];
      // final List<String> string = stringCombo["arr"];

      for (int comboId in comboIds) {
        Map<String, dynamic> correspondingTile = boardState.firstWhere((element) => element["index"] == comboId);
        String correspondingTileContents = correspondingTile["letter"];
        if (correspondingTileContents == "") {
          contents.add({"index": comboId, "tileId": correspondingTile["tileId"], "content": "-"});
          letters.add("-");
        } else {
          contents.add({"index": comboId, "tileId": correspondingTile["tileId"], "content": correspondingTileContents});
          letters.add(correspondingTileContents);
        }
      }

      String totalString = letters.join();
      if (!totalString.contains("-")) {validStringObjects.add({"string": letters.join(), "contents": contents});
      }
    }

    List<String> wordsList = [];
    List<String> uniqueIds = [];
    List<Map<String,dynamic>> validIds = [];
    List<Map<String, dynamic>> validWordsList = [];
    num totalPoints = 0;

    int crossWordMultiplier = 1;
    // int wordCount = 0;
    List<int> rows = [];
    List<int> cols = [];

    for (Map<String, dynamic> stringObject in validStringObjects) {
      if (dictionary.contains(stringObject["string"])) {

        wordsList.add(stringObject["string"]);

        List<Map<String, dynamic>> stringContents = stringObject["contents"];
        num wordPoints = 0;
        int wordLength = stringContents.length;

        for (Map<String, dynamic> stringContent in stringContents) {
          validIds.add(stringContent);
          String contentLetter = stringContent["content"];
          Map<String, dynamic> correspondingAlphabetObject = randomLetterState.firstWhere((element) => element["letter"] == contentLetter);
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
        int wordLengthMultiplier = Helpers().getWordLengthMultiplier(wordLength);

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

    num finalTurnPoints = totalPoints * (activeStreak + 1) * crossWordMultiplier * (wordsList.length);

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
      "validIds": Helpers().getUniqueValidIdsMaps(validIds),
      "isDrag": gamePlayState.draggedReserveTile.isNotEmpty
    };

    newTurnSummaryState.add(pointSummary);

    return newTurnSummaryState;
  }


  void executeGameOver(GamePlayState gamePlayState, BuildContext context,) {
 
    Map<String,dynamic> data = Helpers().getGameSummaryData(gamePlayState.scoringLog);
    List<Map<String,dynamic>> wordSummary = Helpers().getPointsSummary(gamePlayState.scoringLog);
    SettingsState settingsState = context.read<SettingsState>();

      late Map<String, dynamic> newGameData = {
        "timeStamp": DateTime.now().toIso8601String(),
        "duration": gamePlayState.duration.inSeconds,
        "turns" : gamePlayState.scoringLog.length,
        "points": data['points'],
        "uniqueWords": data['uniqueWords'].length,
        "uniqueWordsList": data['uniqueWords'],
        "longestStreak": data['longestStreak'],
        "mostPoints": data['mostPoints'],
        "mostWords": data["mostWords"],
        "crossWords": data['crosswords'],
        "level": gamePlayState.currentLevel,
        "language": gamePlayState.currentLanguage,
        "wordSummary": wordSummary,
      };
      
      if (!settingsState.isPlayingOffline) {
        FirestoreMethods().saveHighScore(AuthService().currentUser!.uid, newGameData);
      }
      gamePlayState.setEndOfGameData(newGameData);

  }










}

