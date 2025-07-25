
import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scribby_flutter_v2/components/bonus_icons.dart';
import 'package:scribby_flutter_v2/functions/animations.dart';
import 'package:scribby_flutter_v2/functions/game_logic.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/painters/tile_painters.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';
import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Helpers {

  Map<String,dynamic> getPointerElement(GamePlayState gamePlayState, Offset location) {
    Map<String,dynamic> element = {};
    // check if a tile was tapped;
    for (int i=0; i<gamePlayState.tileData.length; i++) {
      if (gamePlayState.tileData[i]["path"].contains(location)) {
        element = gamePlayState.tileData[i];

      }
    }
    // check if a reserve tile was tapped;
    for (int i=0; i<gamePlayState.reserveTileData.length; i++) {
      if (gamePlayState.reserveTileData[i]["path"].contains(location)) {
        element = gamePlayState.reserveTileData[i];
      }
    }
    return element;    
  }

  Map<String,dynamic> getPointerElement2(List<Map<String,dynamic>> tileData, Offset? location) {
    Map<String,dynamic> element = {};
    // check if a tile was tapped;
    if (location != null) {
      for (int i=0; i<tileData.length; i++) {
        if (tileData[i]["path"].contains(location)) {
          element = tileData[i];
        }
      }
    }
    return element;    
  }  


  // Map<String, dynamic> generateRandomLetterData(GamePlayState gamePlayState) {
  //   List<Map<String, dynamic>> alphabet = gamePlayState.alphabet;

  //   print("RANDOM LETTER DATA");
  //   print(gamePlayState.randomLetterData);

  //   List<String> randomLettersList = gamePlayState.randomLetterData;
  //   List<int> randomShadeList = gamePlayState.randomShadeList;
  //   List<int> randomAngleList = gamePlayState.randomAngleList;
  //   Random random = Random();

  //   String letterType = getNextLetterType(alphabet);
  //   String previousLetter = randomLettersList[randomLettersList.length - 1];
  //   List<String> availableLetters = [];
  //   for (Map<String, dynamic> randomLetterObject in alphabet) {
  //     for (var i = 1; i < randomLetterObject["count"]; i++) {
  //       if (randomLetterObject["type"] == letterType &&
  //           randomLetterObject["letter"] != previousLetter) {
  //         availableLetters.add(randomLetterObject["letter"]);
  //       }
  //     }
  //   }

  //   int availableLettersCount = availableLetters.length;


  //   int randomIndex = random.nextInt(availableLettersCount);
  //   String randomLetter = availableLetters[randomIndex];

  //   List<Map<String, dynamic>> newRandomLetterState = [];
  //   for (Map<String, dynamic> randomLetterObject in alphabet) {
  //     if (randomLetterObject["letter"] == randomLetter) {
  //       randomLetterObject.update("count", (value) => randomLetterObject["count"] - 1);
  //       randomLetterObject.update("inPlay", (value) => randomLetterObject["inPlay"] + 1);
  //     }
  //     newRandomLetterState.add(randomLetterObject);
  //   }

  //   int randomShadeIndex = random.nextInt(5);
  //   int randomAngleIndex = random.nextInt(5);
  //   final List<String> newRandomLettersList = [...randomLettersList,randomLetter];
  //   final List<int> newRandomShadeList = [...randomShadeList,randomShadeIndex];
  //   final List<int> newRandomAngleList = [...randomAngleList,randomAngleIndex];

  //   final Map<String, dynamic> randomLetterData = {
  //     "randomList": newRandomLettersList,
  //     "shadeList": newRandomShadeList,
  //     "angleList": newRandomAngleList,
  //     "randomState": newRandomLetterState,
  //   };

  
  //   // return randomLetterData;
  //   return {};
  // }

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
      if (shareOfVowels <= 0.40) {
        res = "vowel";
      } else if (shareOfVowels > 0.60) {
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
    // print("vowels: $vows | cons: $cons");
    return res;
  }  

  Offset getCoordinatesFromDistanceAndAngle(Offset origin, double angle, double distance) {
    // double angle1Radians = pointData["angle"] * (pi/180);
    double angle1Radians = angle * (pi/180);

    double sideA = distance * sin(angle1Radians);
    double sideB = distance * cos(angle1Radians);

    final double dx = (origin.dx + sideA);
    final double dy = (origin.dy + sideB);

    return Offset(dx,dy);
  }  

  List<double> generateWave({
    required int numPoints,
    required double amplitude,
    required double frequency,
    double phaseShift = 0.0,
    double dampingFactor = 0.1,
  }) {
    List<double> yCoordinates = [];
    for (int i = 0; i < numPoints; i++) {
      double x = (2 * pi * i) / numPoints; // Normalize x to range [0, 2*pi]
      double y = amplitude * dampingFactor * sin(frequency * x + phaseShift);
      double res = double.parse(y.toStringAsFixed(4));
      yCoordinates.add(res);
    }
    return yCoordinates;
  }

  double getWaveValue(int numPoints, double progress, double amplitude, double frequency, double phaseShift, double dampingFactor) {
    int progressIndex = (numPoints*progress).round();
    double x = (2 * pi * progressIndex) / numPoints;
    double res = amplitude * dampingFactor * sin(frequency * x + phaseShift);
    double val = double.parse(res.toStringAsFixed(4));
    return val;
  }

  int getPreviousScore(GamePlayState gamePlayState, int turn) {
    int res = 0;
    for (int i=0;i<gamePlayState.scoreSummary.length;i++) {
      if (gamePlayState.scoreSummary[i]["turn"]<turn) {
        res = res + gamePlayState.scoreSummary[i]["score"] as int;
      }
    }
    return res;
  }
  
  double toRadians(double angle) {
    double res = angle * pi / 180.0;
    return res;
  }

  List<Map<String,dynamic>> getOpenTiles(GamePlayState gamePlayState) {
    List<Map<String,dynamic>> openCandidates = [];
    for (int i=0; i<gamePlayState.tileData.length; i++) {
      String letter = gamePlayState.tileData[i]["body"];
      bool active = gamePlayState.tileData[i]["active"];
      if (letter == "" && active) {
        openCandidates.add(gamePlayState.tileData[i]);
      }
    }
    return openCandidates;
  }


  int getStreakMultiplier(GamePlayState gamePlayState, int countStrings) {
    int res = 0; 
    if (gamePlayState.scoreSummary.length > 1) {
      if (countStrings>0) {
        res = gamePlayState.scoreSummary.last["multipliers"]["streak"]+1;
      }
    }
    return res;
  }

  int getCrossWordMultiplier(GamePlayState gamePlayState, List<Map<String,dynamic>> validIds) {
    int res = 0;
    List<int> uniqueRows = [];
    List<int> uniqueColumns = []; 
    for (int i=0; i<validIds.length; i++) {
      Map<String,dynamic> idObject = validIds[i];
      int id = idObject["id"];
      Map<String,dynamic> tileObject = gamePlayState.tileData.firstWhere((e)=>e["key"]==id, orElse: ()=> {});
      if (tileObject.isNotEmpty) {

        int row = tileObject["row"];
        if (!uniqueRows.contains(row)) {
          uniqueRows.add(row);
        }
        int column = tileObject["column"];
        if (!uniqueColumns.contains(column)) {
          uniqueColumns.add(column);
        }

      }
    } 

    if (uniqueRows.length > 1 && uniqueColumns.length > 1) {
      res = 2;
    } else {
      res = 1;
    }

    return res;
  }

  bool getIsTapInForbiddenZone(PointerEvent details, GamePlayState gamePlayState) {

    bool res = false;
    
    Size boardSize = gamePlayState.elementSizes["boardAreaSize"];
    Offset boardCenter = gamePlayState.elementPositions["boardCenter"];

    Size randomLettersSize = gamePlayState.elementSizes["randomLettersAreaSize"];
    Offset randomLettersCenter = gamePlayState.elementPositions["randomLettersCenter"];

    double topLimit = randomLettersCenter.dy - randomLettersSize.height/2;
    double bottomLimit = boardCenter.dy + boardSize.height/2;
    double leftLimit = boardCenter.dx - boardSize.width/2;
    double rightLimit = boardCenter.dx + boardSize.width/2;

    if (details.localPosition.dy <= topLimit && details.localPosition.dy >= bottomLimit) {
      if (details.position.dx <= leftLimit || details.position.dx >= rightLimit) {
        res = true;
      } 
    }

    if (gamePlayState.isTutorial) {
      int currentTurn = gamePlayState.tutorialData["currentTurn"];
      List<Map<String,dynamic>> steps = gamePlayState.tutorialData["steps"];
      Map<String,dynamic> step = steps.firstWhere((e)=>e["step"]==currentTurn,orElse: ()=>{});
      if (step.isNotEmpty) {
        int? targetKey = step["focusTile"];
        // String tileType = step["type"];
        String moveType = step["moveType"];
        String? targetOption = step["perk"];
        Map<String,dynamic> targetTile = {};
        // if (tileType == "board") {
        targetTile = gamePlayState.tileData.firstWhere((e)=>e["key"]==targetKey,orElse: ()=>{});
        // } else {
        if (targetTile.isEmpty) {
          targetTile = gamePlayState.reserveTileData.firstWhere((e)=>e["key"]==targetKey,orElse: ()=>{});
        }
        // }


        
        if (targetTile.isNotEmpty) {

          if (moveType == "drag") {

            res = false;

          } else {

            if (targetTile["type"]=="board") {
              if (targetTile["menuOpen"]) {

                
                if (targetOption != null) {

                  List<Map<String,dynamic>> perkMenu = targetTile["menuData"]; 
                  // Map<String,dynamic> targetPerk = perkMenu.firstWhere((e)=>e["option"]==targetOption, orElse: ()=>{});
                  Map<String,dynamic> selectedPerk = perkMenu.firstWhere((e)=>e["path"].contains(details.position), orElse: ()=>{});


                  if (selectedPerk.isNotEmpty) {
                    if (selectedPerk["option"]!=targetOption) {
                      res = true;
                    }
                  }

                }

              } else {
                Path targetTilePath = targetTile["path"];
                if (!targetTilePath.contains(details.position)) {
                  res = true;
                }
              }
            } else if (targetTile["type"]=="reserve") {
              Path targetTilePath = targetTile["path"];
              if (!targetTilePath.contains(details.position)) {
                res = true;
              }            
            }

          }


        } else {
          if (moveType=="finish") {
            res = false;
          } else {
            res = true;
          }
        }
      }
    }
    return res;
  }


  void validateTutorialComplete(GamePlayState gamePlayState, BuildContext context) {
    // late bool res = false;
    if (gamePlayState.isTutorial) {
      int currentTurn = gamePlayState.tutorialData["currentTurn"];
      List<Map<String,dynamic>> steps = gamePlayState.tutorialData["steps"];
      Map<String,dynamic> step = steps.firstWhere((e)=>e["step"]==currentTurn,orElse: ()=>{});
      if (step.isNotEmpty) {
        String moveType = step["moveType"];
        if (moveType=="finish") {
          // res = true;
          GameLogic().executeTutorialStep(gamePlayState,context);
        }
      }
    }
    // return res;
  }

  bool validateTutorialDragDropGesture(GamePlayState gamePlayState, Map<String,dynamic> pointedElement) {
    late bool res = false;

    String? elementType = pointedElement.isEmpty ? null : pointedElement["type"];
    bool? isPointedElementActive = pointedElement.isEmpty ? null : pointedElement["active"];
    String? elementBody = pointedElement.isEmpty ? null : pointedElement["body"];
    Map<String,dynamic> swappingTile = getSwappingTile(gamePlayState);

    if (pointedElement.isNotEmpty) {
      
      
      if (gamePlayState.isTutorial) {
        int currentTurn = gamePlayState.tutorialData["currentTurn"];
        // print("validating tutorial drag drop gesture. currentTurn:  $currentTurn");
        List<Map<String,dynamic>> steps = gamePlayState.tutorialData["steps"];
        Map<String,dynamic> stepData = steps.firstWhere((e)=>e["step"]==currentTurn,orElse: ()=>{}); 

        if (stepData.isNotEmpty) {
          // print("validating tutorial drag drop gesture. step:  $stepData");
          if (stepData["moveType"]=="drag") {

            if (gamePlayState.draggedElementData != null) {
              int draggedElementKey = gamePlayState.draggedElementData!["key"];
              int stepDraggedKey = stepData["focusTile"];

              int targetKey = stepData["targetKey"];
              int pointedElementKey = pointedElement["key"];
              if (draggedElementKey == stepDraggedKey && targetKey == pointedElementKey)  {
                res = true;
              }
            }
          } 
        }  
        
      } else {
        if (elementType=="board" && isPointedElementActive==true && elementBody== "" && swappingTile.isEmpty) {
          res = true;
        }
      }
    }
    return res;
  }

  Map<String,dynamic> getSwappingTile(GamePlayState gamePlayState) {
    Map<String,dynamic> res = gamePlayState.tileData.firstWhere((e)=> e["swapping"]==true,orElse: ()=>{});
    return res;
  }

  void updateTileStyleAfterSwapAnimation(GamePlayState gamePlayState, int sourceKey, int targetKey) {
    Map<String,dynamic> sourceTile = gamePlayState.tileData.firstWhere((e)=>e["key"]==sourceKey,orElse: ()=>{});
    Map<String,dynamic> targetTile = gamePlayState.tileData.firstWhere((e)=>e["key"]==targetKey,orElse: ()=>{});

    Map<String,dynamic> targetStyle = targetTile["decorationData"];
    sourceTile.update("decorationData", (v) => targetStyle);
    print("animation has ended for tile $sourceTile");
  }  


  String getMenuBuyMoreMessage(String item) {

    String perk = "";
    if (item == "freeze") {
      perk = "frosties";
    } 

    if (item == "explode") {
      perk = "bombs";
    } 

    if (item == "swap") {
      perk = "swaps";
    }         

    String message = "You do not have any more ${perk}!";
    return message;
  }

  int calculateScore(GamePlayState gamePlayState) {
    late int score = 0;
    if (gamePlayState.scoreSummary.isNotEmpty) {
      late int val = 0;
      for (int i=0;i<gamePlayState.scoreSummary.length;i++) {
        val = val + gamePlayState.scoreSummary[i]["score"] as int;
      }
      score = val;
    }  
    return score;  
  }

  List<String> getUniqueWords(GamePlayState gamePlayState) {
    late List<String> uniqueWords = [];
    if (gamePlayState.scoreSummary.isNotEmpty) {
      for (int i=0;i<gamePlayState.scoreSummary.length;i++) {
        List<Map<String,dynamic>> validStrings =  gamePlayState.scoreSummary[i]["validStrings"];
        for (int j=0; j<validStrings.length;j++) {
          String word = validStrings[j]["word"];
          if (!uniqueWords.contains(word)) {
            uniqueWords.add(word);
          }
        }
      }
    }  
    return uniqueWords;
  }  

  int countUniqueWords(GamePlayState gamePlayState) {
    List<String> uniqueWords = getUniqueWords(gamePlayState);
    return uniqueWords.length;
  }

  int countCrosswords(GamePlayState gamePlayState) {
    int count = 0;
    if (gamePlayState.scoreSummary.isNotEmpty) {
      for (int i=0;i<gamePlayState.scoreSummary.length;i++) {
        if (gamePlayState.scoreSummary[i]["multipliers"]["cross"]>1) {
          count++;
        }
      }
    }
    return count;
  }

  int getLongestStreak(GamePlayState gamePlayState) {
    int longestStreak = 1;
    if (gamePlayState.scoreSummary.isNotEmpty) {
      for (int i=0;i<gamePlayState.scoreSummary.length;i++) {
        if (gamePlayState.scoreSummary[i]["multipliers"]["streak"]>longestStreak) {
          longestStreak=gamePlayState.scoreSummary[i]["multipliers"]["streak"];
        }
      }
    }
    return longestStreak;
  }

  int getBiggestTurn(GamePlayState gamePlayState) {
    int res = 0;
    // dynamic turnData = {};
    if (gamePlayState.scoreSummary.isNotEmpty) {
      for (int i=0;i<gamePlayState.scoreSummary.length;i++) {
        if (gamePlayState.scoreSummary[i]["score"]>res) {
          res=gamePlayState.scoreSummary[i]["score"];
        }
      }
    }
    return res;
  }

  int countTurns(GamePlayState gamePlayState) {
    return gamePlayState.scoreSummary.length;
  }

  String formatDuration(int duration) {
    String formatDigit(int val) {
      String res = "$val";
      if (val < 10) {
        res = "0$val";
      }
      return res;
    }  
    String getTime(int duration) {
      String res = "";
      int seconds = (duration%60);
      int minutes = (duration / 60).floor();
      int hours = 0;
      if (duration > 3600) {
        int updatedMinutes = minutes%60;
        hours = (minutes/60).floor();
        res = "${formatDigit(hours)}:${formatDigit(updatedMinutes)}:${formatDigit(seconds)}";
      } else {
        res = "${formatDigit(minutes)}:${formatDigit(seconds)}";
      }
      return res;
    }
    return getTime(duration);
  }


  double getScoreFontSize(MediaQueryData mediaQuery, double sizeFactor) {
    double  res = 0;
    double width = mediaQuery.size.width;
    double height = mediaQuery.size.height;
    double halfPerimiter = width+height;
    // double ratio = halfPerimiter
    if (halfPerimiter > 1200) {
      res = 1200 *sizeFactor;
    } else {
      res = halfPerimiter * sizeFactor;
    }
    return res;
  }

  double getScalor(SettingsController settings) {
    late double res = 1.0;
    final Map<String,dynamic> deviceSizeData = settings.deviceSizeInfo.value as Map<String,dynamic>;
    res = deviceSizeData["scalor"];
    return res;  
  }


  bool shouldShowCountdown(GamePlayState gamePlayState) {
    late bool res = false;
    

    bool isTimeToPlace = gamePlayState.gameParameters["timeToPlace"]!=null;
    res = isTimeToPlace;
    // if (isTimeToPlace) {
    //   res = isTimeToPlace;
    // }

    if (gamePlayState.isTutorial) {
      int currentTurn = gamePlayState.tutorialData["currentTurn"];
      List<Map<String,dynamic>> steps = gamePlayState.tutorialData["steps"];
      Map<String,dynamic> step = steps.firstWhere((e)=>e["step"]==currentTurn,orElse: ()=>{});      

      if (step.isNotEmpty) {
        if (step["shouldStartCountDown"]) {
          res = true;
        }
      }

    }
    return res;
  }

  String generateRandomUsername() {
    final adjectives = [
      'Adventurous', 'Brave', 'Curious', 'Daring', 'Eager',
      'Fancy', 'Gentle', 'Happy', 'Icy', 'Jolly',
      'Kind', 'Lucky', 'Mighty', 'Nimble', 'Odd',
      'Proud', 'Quick', 'Royal', 'Sharp', 'Tough',
      'Unique', 'Vivid', 'Witty', 'Young', 'Zany'
    ];

    final nouns = [
      'Hawk', 'Panther', 'Battleship', 'Scissors', 'Mountain',
      'Falcon', 'Tiger', 'Tornado', 'Planet', 'Shadow',
      'Volcano', 'Puzzle', 'Wizard', 'Comet', 'Dragon',
      'Helmet', 'Rocket', 'Anchor', 'Beacon', 'Whale',
      'Jungle', 'Saber', 'Knight', 'Lantern', 'Phoenix'
    ];

    final random = Random();
    final adjective = adjectives[random.nextInt(adjectives.length)];
    final noun = nouns[random.nextInt(nouns.length)];

    return '$adjective $noun';
  }

  String translateRankTitle(int rank, String language) {
    Map<int,dynamic> rankMap = {
      1:   {"en": "Spore", "fr": "Spore", "es": "Espora", "de": "Spore"},
      2:	  {"en":"Novice",	"fr":"Novice",	"es": "Novato",	"de":"Neuling"},
      3:	  {"en":"Beginner",	"fr":"Débutant",	"es": "Principiante",	"de":"Anfänger"},
      4:	  {"en":"Learner",	"fr":"Apprenant",	"es": "Aprendiz",	"de":"Lernender"},
      5:	  {"en":"Explorer",	"fr":"Explorateur",	"es": "Explorador",	"de":"Entdecker"},
      6:	  {"en":"Seeker",	"fr":"Chercheur",	"es": "Buscador",	"de":"Suchender"},
      7:	  {"en":"Thinker",	"fr":"Penseur",	"es": "Pensador",	"de":"Denker"},
      8:	  {"en":"Solver",	"fr":"Résolveur",	"es": "Solucionador",	"de":"Löser"},
      9:	  {"en":"Strategist",	"fr":"Stratège",	"es": "Estratega",	"de":"Stratege"},
      10:	  {"en":"Analyst",	"fr":"Analyste",	"es": "Analista",	"de":"Analytiker"},
      11:	  {"en":"Scholar",	"fr":"Savant",	"es": "Erudito",	"de":"Gelehrter"},
      12:	  {"en":"Adept",	"fr":"Adepte",	"es": "Experto",	"de":"Erfahrene(r)"},
      13:	  {"en":"Expert",	"fr":"Expert",	"es": "Experto",	"de":"Experte"},
      14:	  {"en":"Tactician",	"fr":"Tacticien",	"es": "Táctico",	"de":"Taktiker"},
      15:	  {"en":"Mastermind",	"fr":"Génie",	"es": "Cerebro",	"de":"Mastermind"},
      16:	  {"en":"Champion",	"fr":"Champion",	"es": "Campeón",	"de":"Champion"},
      17:	  {"en":"Elite",	"fr":"Élite",	"es": "Élite",	"de":"Elite"},
      18:	  {"en":"Grandmaster",	"fr":"Grand Maître", "es": "Gran Maestro","de":"Großmeister"},
      19:	  {"en":"Virtuoso",	"fr":"Virtuose",	"es": "Virtuoso",	"de":"Virtuose"},
      20:	  {"en":"Legend",	"fr":"Légende",	"es": "Leyenda",	"de":"Legende"},
      21:	  {"en":"Ascendant",	"fr":"Ascendant",	"es": "Ascendido",	"de":"Aufgestiegener"},
    };
    String display = rankMap[rank][language];
    return display;
  }


  List<String> getAllUniqueWords(SettingsController settings) {
    List<String> allUniqueWords = [];
    for (int i=0; i<settings.userGameHistory.value.length; i++) {
      List<dynamic> uniqueWords = settings.userGameHistory.value[i]["uniqueWords"];
      for (int j=0; j<uniqueWords.length; j++) {
        if (!allUniqueWords.contains(uniqueWords[j])) {
          allUniqueWords.add(uniqueWords[j]);
        }
      }
    }
    return allUniqueWords;
  }

  int getAllPointsScored(SettingsController settings) {
    int scored = 0;
    for (int i=0; i<settings.userGameHistory.value.length; i++) {
      int score = settings.userGameHistory.value[i]["score"];
      scored = scored + score;
    } 
    return scored;
  }

  String? getNewRank(SettingsController settings, GamePlayState gamePlayState) {
    late String? res = null;
    Map<String,dynamic> userData = settings.userData.value as Map<String,dynamic>;
    String currentRank = userData["rank"];

    String newRank = currentRank;
    List<dynamic> ranks = settings.rankData.value;
    for (int i=0; i<ranks.length; i++) {
      if (settings.xp.value >= ranks[i]["xpRange"][0] && settings.xp.value <= ranks[i]["xpRange"][1]) {
        newRank = ranks[i]["key"];
      }
    }


    if (currentRank != newRank) {
      res = newRank;
    }

    return res;   
  }

  String formatDate(String isoString) {
    DateTime dateTime = DateTime.parse(isoString);
    return DateFormat('MMMM d, y').format(dateTime); // e.g., May 5, 2025
  }

  String formatWord(String s) {
    List<String> pieces = s.split("-");
    List<String> pieces2 = [];
    for (String piece in pieces) {
      String lower = piece.toLowerCase();
      String newString = lower[0].toUpperCase() + lower.substring(1);
      pieces2.add(newString);
    }
    String res = pieces2.join("-");
    return res;
  }

  Future<Map<String,dynamic>> fetchDefinition(String word, String language) async {

    Map<String,dynamic> res = {};

    if (language == 'en') {

      String baseUrl_1 = "https://firebasestorage.googleapis.com/v0/b/scribby-6934e.appspot.com/o/definitions%2F";

      String baseUrl_2 = "%2F";
   
      String baseUrl_3 = ".json?alt=media&token=511d5629-7808-4821-a455-b66360cbf707";
      
      String url = baseUrl_1 + language + baseUrl_2 + word + baseUrl_3;

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final String decodedBody = utf8.decode(response.bodyBytes);
        final Map<String,dynamic> jsonMap = json.decode(decodedBody);

        // late String def = "Defintions temporarily unavailable";
        res = {
          "result" : "success",
          "data": jsonMap,
        };


      } else {

        res = {
          "result" : "fail",
          // "data": Helpers().translateText(language, "No definition available at this time",settingsState)
          "data":"No definition available at this time",
        };        
        // res = Helpers().translateText(language, "No definition available at this time");
      }

    } else {

      String baseUrl_1 = "https://firebasestorage.googleapis.com/v0/b/scribby-6934e.appspot.com/o/definitions%2F";

      String baseUrl_2 = "%2F";
   
      String baseUrl_3 = ".json?alt=media&token=511d5629-7808-4821-a455-b66360cbf707";
      
      String url = baseUrl_1 + language + baseUrl_2 + word + baseUrl_3;

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // dynamic jsonResponse = json.decode(response.body);
        final String decodedBody = utf8.decode(response.bodyBytes);
        final Map<String,dynamic> jsonMap = json.decode(decodedBody);
        res = {
          "result": "success",
          "data": jsonMap['data']
        };
        // res = jsonMap['data'][0];
      } else {
        res = {
          "result" : "fail",
          // "data": Helpers().translateText(language, "No definition available at this time",settingsState)
          "data": "No definition available at this time",
        };
        // res = Helpers().translateText(language, "No definition available at this time");
      }      
    }

    return res;
  }


}
