import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';

class GamePlayState extends ChangeNotifier {

/// ================= TUTORIAL =============================

  void refreshTutorialData() {
    _isTutorial = false;
    _tutorialData.update("currentTurn", (v)=>0);
  }

  late bool _isTutorial = false;
  bool get isTutorial => _isTutorial;
  void setIsTutorial(bool value) {
    _isTutorial = value;
    notifyListeners();
  }



  late Map<String,dynamic> _tutorialData = {
    "randomLetters": ["C","A",],
    "currentTurn":0,
    "dictionary": [ "CAT", "BAKER", "BAKE", "STICK", "TICK", "GET", "ARE", "TOP", "CROSS", "WORDS", "SMILE", "MILE", "ILE", "BLACK", "LACK", "SWAP", "TILES", "SEA","SEAL"],
    "steps":[

      // first word complete
      {"step":0,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 13, "isStepCompleted":false, "newLetter":"T", "shouldStartCountDown": false,"perk":null, "delay":300, "message": "tap the glowing tiles"}, // C
      {"step":1,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 14, "isStepCompleted":false, "newLetter":"B", "shouldStartCountDown": false,"perk":null, "delay":300, "message": ""}, // A
      {"step":2,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 15, "isStepCompleted":false, "newLetter":"A", "shouldStartCountDown": false,"perk":null, "delay":300, "message": "complete the word CAT"}, // T

      // - b
      {"step":3,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 18, "isStepCompleted":false, "newLetter":"K", "shouldStartCountDown": false,"perk":null, "delay":300, "message": ""}, // B
      {"step":4,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 19, "isStepCompleted":false, "newLetter":"R", "shouldStartCountDown": false,"perk":null, "delay":300, "message": ""}, // A
      {"step":5,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 20, "isStepCompleted":false, "newLetter":"E", "shouldStartCountDown": false,"perk":null, "delay":300, "message": ""}, // K
      {"step":6,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 22, "isStepCompleted":false, "newLetter":"S", "shouldStartCountDown": false,"perk":null, "delay":600, "message": "Strategically place the letter R so you can complete the words BAKE and BAKER with the E that is coming up"}, // R
      {"step":7,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 21, "isStepCompleted":false, "newLetter":"T", "shouldStartCountDown": false,"perk":null, "delay":2000, "message": ""}, // E


      {"step":8,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 11, "isStepCompleted":false, "newLetter":"I", "shouldStartCountDown": false,"perk":null, "delay":300, "message": ""}, // S
      {"step":9,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 17, "isStepCompleted":false, "newLetter":"C", "shouldStartCountDown": false,"perk":null, "delay":300, "message": ""}, // T
      {"step":10,"type": "reserve", "moveType":"tap", "targetKey":null, "focusTile": 3000, "isStepCompleted":false, "newLetter":"K", "shouldStartCountDown": false,"perk":null, "delay":500, "message": "place the letter in a reserve to complete a bigger word later"}, // I


      {"step":11,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 29, "isStepCompleted":false, "newLetter":"G", "shouldStartCountDown": false,"perk":null, "delay":0, "message": ""}, // C
      {"step":12,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 35, "isStepCompleted":false, "newLetter":"T", "shouldStartCountDown": false,"perk":null, "delay":300, "message": ""}, // K

      // DRAG MOVE
      {"step":13,"type": "board", "moveType":"drag", "targetKey":23, "focusTile": 3000, "isStepCompleted":false, "newLetter":null, "shouldStartCountDown": false,"perk":null, "delay":3000, "message": "drag the letter from the reserve to the empty spot to complete the word"}, 
      

      // SET UP 3 TURN POINT STREAK
      {"step":14,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 3, "isStepCompleted":false, "newLetter":"A", "shouldStartCountDown": false,"perk":null, "delay":300, "message": ""}, // G
      {"step":15,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 5, "isStepCompleted":false, "newLetter":"E", "shouldStartCountDown": false,"perk":null, "delay":300, "message": ""}, // T 
      
      {"step":16,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 12, "isStepCompleted":false, "newLetter":"T", "shouldStartCountDown": false,"perk":null, "delay":300, "message": ""}, // A
      {"step":17,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 14, "isStepCompleted":false, "newLetter":"P", "shouldStartCountDown": false,"perk":null, "delay":300, "message": ""}, // E

      {"step":18,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 25, "isStepCompleted":false, "newLetter":"E", "shouldStartCountDown": false,"perk":null, "delay":300, "message": ""}, // T
      {"step":19,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 27, "isStepCompleted":false, "newLetter":"R", "shouldStartCountDown": false,"perk":null, "delay":300, "message": ""}, // P

      // COMPLETE FIRST WORD OF STREAK
      {"step":20,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 4, "isStepCompleted":false, "newLetter":"O", "shouldStartCountDown": false,"perk":null, "delay":1500, "message": "streaks are a valuable way to multiply your score"}, // E
      // COMPLETE SECOND WORD OF STREAK
      {"step":21,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 13, "isStepCompleted":false, "newLetter":"C", "shouldStartCountDown": false,"perk":null, "delay":1500, "message": "double your score by completing this word"}, // R
      // COMPLETE THIRD WORD OF STREAK
      {"step":22,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 26, "isStepCompleted":false, "newLetter":"R", "shouldStartCountDown": false,"perk":null, "delay":1500, "message": "triple your score by completing this word"}, // 0

      // {"step":23,"type": "board", "moveType":"delay", "targetKey":null, "focusTile": null, "isStepCompleted":false, "newLetter":"R", "shouldStartCountDown": false,"perk":null, "delay":0, "message": "RANDOM DELAY"}, // 0
// ========================================
      // SHOW THE ABILITY TO DO CROSSWORDS
      {"step":23,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 8, "isStepCompleted":false, "newLetter":"S", "shouldStartCountDown": false,"perk":null, "delay":300, "message": ""}, // C
      {"step":24,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 14, "isStepCompleted":false, "newLetter":"S", "shouldStartCountDown": false,"perk":null, "delay":300, "message": ""}, // R
      {"step":25,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 26, "isStepCompleted":false, "newLetter":"W", "shouldStartCountDown": false,"perk":null, "delay":300, "message": "skip the middle letter of the cross word"}, // S
      {"step":26,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 32, "isStepCompleted":false, "newLetter":"R", "shouldStartCountDown": false,"perk":null, "delay":300, "message": ""}, // S
      {"step":27,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 19, "isStepCompleted":false, "newLetter":"D", "shouldStartCountDown": false,"perk":null, "delay":300, "message": ""}, // W
      {"step":28,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 21, "isStepCompleted":false, "newLetter":"S", "shouldStartCountDown": false,"perk":null, "delay":300, "message": ""}, // R
      {"step":29,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 22, "isStepCompleted":false, "newLetter":"O", "shouldStartCountDown": false,"perk":null, "delay":300, "message": ""}, // D
      {"step":30,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 23, "isStepCompleted":false, "newLetter":"Q", "shouldStartCountDown": false,"perk":null, "delay":300, "message": ""}, // S

      // 
      {"step":31,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 20, "isStepCompleted":false, "newLetter":"B", "shouldStartCountDown": false,"perk":null, "delay":3000, "message": "crossing words is another way to double your turn's score"}, // O - complete
      {"step":32,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 35, "isStepCompleted":false, "newLetter":"L", "shouldStartCountDown": false,"perk":null, "delay":300, "message": ""}, // Q
      {"step":33,"type": "board", "moveType":"kill", "targetKey":8, "focusTile": null, "isStepCompleted":false, "newLetter":null, "shouldStartCountDown": true, "perk":null, "delay":300, "message": "in some games, you may have a limited amount of time to make a play - otherwise a tile gets blocked!"},


      {"step":34,"type": "board", "moveType":"perk", "targetKey":null, "focusTile": 8, "isStepCompleted":false, "newLetter":null, "shouldStartCountDown": false, "perk":"explode", "delay":300, "message": "press the tile for 1 second then tap the flashing bomb perk"},
      {"step":35,"type": "board", "moveType":"perk", "targetKey":null, "focusTile": 35, "isStepCompleted":false, "newLetter":null, "shouldStartCountDown": false, "perk":"explode", "delay":300, "message": "this also works for those pesky letters you can't get rid of (What word ends with Q???)"},
      // {"step":35,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 35, "isStepCompleted":false, "newLetter":null, "shouldStartCountDown": false,"perk":"explode", "delay":300, "message": "this also works for those pesky letters you can't get rid of (What word ends with Q???)"},

      {"step":36,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 24, "isStepCompleted":false, "newLetter":"A", "shouldStartCountDown": false,"perk":null, "delay":300, "message": "Let's take a look at another perk!"}, // B
      {"step":37,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 25, "isStepCompleted":false, "newLetter":"C", "shouldStartCountDown": false,"perk":null, "delay":300, "message": ""}, // L
      {"step":38,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 26, "isStepCompleted":false, "newLetter":"K", "shouldStartCountDown": false,"perk":null, "delay":300, "message": ""}, // A
      {"step":39,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 27, "isStepCompleted":false, "newLetter":"S", "shouldStartCountDown": false,"perk":null, "delay":300, "message": "Instead of completing the word black, freeze the L so we can cross it"}, // C
      {"step":40,"type": "board", "moveType":"perk", "targetKey":null, "focusTile": 25, "isStepCompleted":false, "newLetter":null, "shouldStartCountDown": false,"perk":"freeze", "delay":300, "message": "open up the perk menu for the L to freeze it"}, // L
      {"step":41,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 28, "isStepCompleted":false, "newLetter":"M", "shouldStartCountDown": false,"perk":null, "delay":300, "message": "now we can place the K and the word BLACK won't be counted"}, // K
      {"step":42,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 7, "isStepCompleted":false, "newLetter":"I", "shouldStartCountDown": false,"perk":null, "delay":300, "message": "Let's make another word with an L to cross with"}, // S
      {"step":43,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 13, "isStepCompleted":false, "newLetter":"E", "shouldStartCountDown": false,"perk":null, "delay":300, "message": ""}, // M
      {"step":44,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 19, "isStepCompleted":false, "newLetter":"S", "shouldStartCountDown": false,"perk":null, "delay":300, "message": ""}, // I
      {"step":45,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 31, "isStepCompleted":false, "newLetter":"E", "shouldStartCountDown": false,"perk":null, "delay":300, "message": ""},// E
      {"step":46,"type": "board", "moveType":"perk", "targetKey":null, "focusTile": 25, "isStepCompleted":false, "newLetter":null, "shouldStartCountDown": false,"perk":"freeze", "delay":3000, "message": "Now we can unfreeze (thaw?) the L and complete the cross word 'BLACK-SMILE' - tap the glowing perk"}, // L

      {"step":47,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 18, "isStepCompleted":false, "newLetter":"A", "shouldStartCountDown": false,"perk":null, "delay":300, "message": "The next perk is the 'UNDO' perk"}, // C
      {"step":48,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 19, "isStepCompleted":false, "newLetter":"L", "shouldStartCountDown": false,"perk":null, "delay":300, "message": ""}, // A   QtKey":null, "focusTile": 20, "isStepCompleted":false, "newLetter":"S", "shouldStartCountDown": false,"perk":null, "delay":300, "message": "Sometimes when building a bigger word, you will complete a smaller one"}, // T
      // {"step":50,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 21, "isStepCompleted":false, "newLetter":"W", "shouldStartCountDown": false,"perk":null, "delay":300, "message": "In this case, we want to complete the word 'SEAL' but get the word 'SEA' first"},
      
      {"step":49,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 20, "isStepCompleted":false, "newLetter":'S', "shouldStartCountDown": false,"perk":null, "delay":1000, "message": "In this case, we want to complete the word 'SEAL' but get the word 'SEA' first"}, // S
      {"step":50,"type": "board", "moveType":"perk", "targetKey":null, "focusTile": 0, "isStepCompleted":false, "newLetter":null, "shouldStartCountDown": false,"perk":'undo', "delay":500, "message": "Undo the last move so you can put the 'A' in the reserves"}, // S
      {"step":51,"type": "reserve", "moveType":"tap", "targetKey":null, "focusTile": 2000, "isStepCompleted":false, "newLetter":'S', "shouldStartCountDown": false,"perk":null, "delay":300, "message": "tap the reserve tile"}, // S
      {"step":52,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 21, "isStepCompleted":false, "newLetter":'W', "shouldStartCountDown": false,"perk":null, "delay":500, "message": "tap the board tile to place the 'L'"}, // S
      {"step":53,"type": "board", "moveType":"drag", "targetKey":20, "focusTile": 2000, "isStepCompleted":false, "newLetter":null, "shouldStartCountDown": false,"perk":null, "delay":300, "message": "drag the 'A' into the word to make the words 'SEA' and 'SEAL' "},
      
      {"step":54,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 6, "isStepCompleted":false, "newLetter":'L', "shouldStartCountDown": false,"perk":null, "delay":300, "message": "Well done!"}, // S
      {"step":55,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 7, "isStepCompleted":false, "newLetter":"P", "shouldStartCountDown": false,"perk":null, "delay":300, "message": "The last perk is the 'SWAP' perk"}, // W
      {"step":56,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 8, "isStepCompleted":false, "newLetter":"T", "shouldStartCountDown": false,"perk":null, "delay":300, "message": ""}, // L
      {"step":57,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 9, "isStepCompleted":false, "newLetter":"I", "shouldStartCountDown": false,"perk":null, "delay":300, "message": ""}, // P
      {"step":58,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 11, "isStepCompleted":false, "newLetter":"A", "shouldStartCountDown": false,"perk":null, "delay":300, "message": ""}, // T
      {"step":59,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 17, "isStepCompleted":false, "newLetter":"E", "shouldStartCountDown": false,"perk":null, "delay":300, "message": ""}, // I
      {"step":60,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 23, "isStepCompleted":false, "newLetter":"S", "shouldStartCountDown": false,"perk":null, "delay":300, "message": ""}, // A
      {"step":61,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 29, "isStepCompleted":false, "newLetter":"!", "shouldStartCountDown": false,"perk":null, "delay":300, "message": ""}, // E
      {"step":62,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 35, "isStepCompleted":false, "newLetter":"@", "shouldStartCountDown": false,"perk":null, "delay":300, "message": "tap the glowing perk at the bottom"}, // S
      {"step":63,"type": "board", "moveType":"perk", "targetKey":null, "focusTile": 23, "isStepCompleted":false, "newLetter":null, "shouldStartCountDown": false,"perk":"swap", "delay":300, "message": "tap the glowing 'A'"}, // 
      {"step":64,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": 8, "isStepCompleted":false, "newLetter":null, "shouldStartCountDown": false,"perk":null, "delay":2000, "message": "tap the glowing 'L' to swap the tiles"}, // 
      {"step":65,"type": "board", "moveType":"finish", "targetKey":null, "focusTile": null, "isStepCompleted":false, "newLetter":null, "shouldStartCountDown": false,"perk":null, "delay":5000, "message": "well done! You're now ready to go!"},

      // {"step":59,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": null, "isStepCompleted":false, "newLetter":"%", "shouldStartCountDown": false,"perk":null}, //
      // {"step":60,"type": "board", "moveType":"tap", "targetKey":null, "focusTile": null, "isStepCompleted":false, "newLetter":"%", "shouldStartCountDown": false,"perk":null}, //                         
    ],
  };
  Map<String,dynamic> get tutorialData => _tutorialData;
  void setTutorialData(Map<String,dynamic> value) {
    _tutorialData = value;
    notifyListeners();
  }  
// ========================================================




  final double _minimumTileSize = 40.0;
  double get minimumTileSize => _minimumTileSize;

  final double _minimumFontSize = 20.0;
  double get minimumFontSize => _minimumFontSize; 

  late double _scalor = 1.0;
  double get scalor => _scalor;
  void setScalor(double value) {
    _scalor = value;
    notifyListeners();
  }   

  late Offset? _currentGestureLocation = null;
  Offset? get currentGestureLocation => _currentGestureLocation;
  void setCurrentGestureLocation(Offset? value) {
    _currentGestureLocation = value;
    notifyListeners();
  }

  late List<Map<String,dynamic>> _animationData = [];
  List<Map<String,dynamic>> get animationData => _animationData;
  void setAnimationData(List<Map<String,dynamic>> value) {
    _animationData = value;
    notifyListeners();
  }

  late Map<String,dynamic> _elementPaths = {};
  Map<String,dynamic> get elementPaths => _elementPaths;
  void setElementPaths(Map<String,dynamic> value) {
    _elementPaths = value;
    notifyListeners();
  }

  // --------- TILE STYLE ---------------
  late Map<String,dynamic> _tileDecorationData = {
    "previousColor":Colors.transparent,
    "nextColor":Colors.transparent,
    "interval":0,
  };
  Map<String,dynamic> get tileDecorationData => _tileDecorationData;
  void setTileDecorationData(Map<String,dynamic> value) {
    _tileDecorationData = value;
    notifyListeners();
  }
  void refreshTileDecorationData() {
    _tileDecorationData = {
      "previousColor":Colors.transparent,
      "nextColor":Colors.transparent,
      "interval":0,
    };    
    notifyListeners();    
  }
  // ------------------------------------

  /// 
    // gamePlayState.setGameParameters({
    // });
  /// 
  late Map<String,dynamic> _gameParameters = {}; // "gameType":str,"target":int?,"targetType": null,"rows":int?,"columns":int?,"durationInMinutes":int?,"timeToPlace": int?,"puzzleId": String?,"mediaQueryData": mediaQueryData,
  Map<String,dynamic> get gameParameters => _gameParameters;
  void setGameParameters(Map<String,dynamic> value) {
    _gameParameters = value;
    notifyListeners();
  }

  late Map<String,dynamic> _gameResultData = {
    "didCompleteGame":null,
    "didAchieveObjective":null,
    "newRank": null,
    "reward":null,
    "xp": null,
    "badges":[],
  };
  Map<String,dynamic> get gameResultData => _gameResultData;
  void setGameResultData(Map<String,dynamic> value) {
    _gameResultData = value;
    notifyListeners();
  } 

  void refreshGameResultData() {
    _gameResultData = {
      "didCompleteGame":null,
      "didAchieveObjective":null,
      "newRank": null,
      "reward":null,
      "xp":null,
      "badges":[],
    };
    notifyListeners();
  }



  


  final List<Map<String,dynamic>> _animationLengths = [
    {"type": "tap-down", "stops": 15, "interval": 17},
    {"type": "tap-cancel", "stops": 15, "interval": 17 },
    {"type": "tap-up", "stops": 15, "interval": 17 },
    {"type": "word-found", "stops": (150), "interval": 17 },
    {"type": "pre-word-found", "stops": 15, "interval": 17 }, // stops: 15
    {"type": "tile-drop", "stops": 15, "interval": 17 },
    {"type": "kill-tile", "stops": 15, "interval": 17 },
    {"type": "score-points", "stops": 50, "interval": 17 },
    {"type": "score-highlight", "stops": 20, "interval": 17 },
    {"type": "game-over", "stops": 30, "interval": 17 },
    {"type": "bonus", "stops": (200), "interval": 17 },
    {"type": "level-up", "stops": 100, "interval": 17 },
    {"type": "new-points", "stops": 120, "interval": 17 },
    {"type": "tile-menu", "stops": 15, "interval": 13 },
    {"type": "menu-charge", "stops": 200, "interval": 100 },
    {"type": "tile-freeze", "stops": 30, "interval": 17 },
    {"type": "tile-swap", "stops": 50, "interval": 17 },
    {"type": "tile-explode", "stops": 40, "interval": 15 },
    {"type": "undo", "stops": 30, "interval": 15 },    
    {"type": "stopwatch-rewind", "stops": 20, "interval": 17 },
    {"type": "add-perks", "stops": 15, "interval": 17 },
    {"type": "tutorial-message-fade", "stops": 25, "interval": 17 },
  ];
  List<Map<String,dynamic>> get animationLengths => _animationLengths;  

  late List<Map<String,dynamic>> _tileMenuOptions = [
    {"item": "swap", "count": 3, "selected":false, "open":false},
    {"item": "explode", "count": 3, "selected":false, "open":false},
    {"item": "freeze", "count": 3, "selected":false, "open":false},
    {"item": "undo", "count": 3, "selected":false, "open":false},
  ];
  List<Map<String,dynamic>> get tileMenuOptions => _tileMenuOptions;
  void setTileMenuOptions(List<Map<String,dynamic>> value) {
    _tileMenuOptions = value;
    notifyListeners();
  }
  void refreshTileMenuOptions() {
    _tileMenuOptions = [
      {"item": "swap", "count": 3, "selected":false, "open":false},
      {"item": "explode", "count": 3, "selected":false, "open":false},
      {"item": "freeze", "count": 3, "selected":false, "open":false},
      {"item": "undo", "count": 3, "selected":false, "open":false},
    ];    
  }
 
  // late bool _isBuyMoreModalOpen = false;
  // bool get isBuyMoreModalOpen => _isBuyMoreModalOpen;
  // void setIsBuyMoreModalOpen(bool value) {
  //   _isBuyMoreModalOpen = value;
  //   notifyListeners();
  // }

  late Map<String,dynamic> _tileMenuBuyMoreModalData = {
    "tile":null,
    "open": false,
    "item": null,
    "message": "",
    "options": []
  };
  Map<String,dynamic> get tileMenuBuyMoreModalData => _tileMenuBuyMoreModalData;
  void setTileMenuBuyMoreModalData(Map<String,dynamic> value) {
    _tileMenuBuyMoreModalData = value;
    notifyListeners();
  }

  void refreshTileMenuBuyMoreModalData() {
    _tileMenuBuyMoreModalData={
      "tile":null,
      "open": false,
      "item": null,
      "message": "",
      "options": []
    };
    notifyListeners();    
  }

  late bool _isGameStarted = false;
  bool get isGameStarted => _isGameStarted;
  void setIsGameStarted(bool value) {
    _isGameStarted = value;
    notifyListeners();
  }  

  late bool _isGamePaused = false;
  bool get isGamePaused => _isGamePaused;
  void setIsGamePaused(bool value) {
    _isGamePaused = value;
    notifyListeners();
  }

  late bool _isGameOver = false;
  bool get isGameOver => _isGameOver;
  void setIsGameOver(bool value) {
    _isGameOver = value;
    notifyListeners();
  }


  late bool _isPointerDown = false;
  bool get isPointerDown => _isPointerDown;
  void setIsPointerDown(bool value) {
    _isPointerDown = value;
    notifyListeners();
  }


  void setReserveTileToDragging(int key) {
    Map<String,dynamic> tappedReserve = _reserveTileData.firstWhere((e)=>e["key"]==key,orElse: ()=>{});
    if (tappedReserve.isNotEmpty) {
      tappedReserve.update("dragging", (v) => true);
    }
  }



  late List<int> _selectedElementsWhileDrag = [];
  List<int> get selectedElementsWhileDrag => _selectedElementsWhileDrag;
  void setSelectedElementsWhileDrag(List<int> value) {
    _selectedElementsWhileDrag = value;
    notifyListeners();
  }



  late List<Map<String,dynamic>> _randomLetterData = [];
  List<Map<String,dynamic>> get randomLetterData => _randomLetterData;
  void setRandomLetterData(List<Map<String,dynamic>> value) {
    _randomLetterData = value;
    notifyListeners();
  }

  late List<Map<String,dynamic>> _tileData = [];
  List<Map<String,dynamic>> get tileData => _tileData;
  void setTileData(List<Map<String,dynamic>> value) {
    _tileData = value;
    notifyListeners();
  }

  late List<Map<String,dynamic>> _reserveTileData = [];
  List<Map<String,dynamic>> get reserveTileData => _reserveTileData;
  void setReserveTileData(List<Map<String,dynamic>> value) {
    _reserveTileData = value;
    notifyListeners();
  }  

  late Map<String,dynamic> _elementSizes = {};
  Map<String,dynamic> get elementSizes => _elementSizes;
  void setElementSizes(Map<String,dynamic> value) {
    _elementSizes = value;
    notifyListeners();
  }

  late Map<String,dynamic> _elementPositions = {};
  Map<String,dynamic> get elementPositions => _elementPositions;
  void setElementPositions(Map<String,dynamic> value) {
    _elementPositions = value;
    notifyListeners();
  }
  
  late Map<String,dynamic>? _focusedElement = {};
  Map<String,dynamic>? get focusedElement => _focusedElement;
  void setFocusedElement(Map<String,dynamic>? value) {
    _focusedElement = value;
    notifyListeners();
  }

  late Map<String,dynamic>? _tappedDownElement = {};
  Map<String,dynamic>? get tappedDownElement => _tappedDownElement;
  void setTappedDownElement(Map<String,dynamic>? value) {
    _tappedDownElement = value;
    notifyListeners();
  }

  // late bool _isLongPress = false;
  // bool get isLongPress => _isLongPress;
  // void setIsLongPress(bool value) {
  //   _isLongPress = value;
  //   notifyListeners();
  // }

  // void detectLongPress() {

  //   int count = 0;
  //   int target = 20;
  //   // late Map<String,dynamic> downObject = {};
  //   // late Map<String,dynamic> currentObject  = {};
  //   late int? downKey = null;
  //   late int? currentKey = null;

  //   // currentObject = Helpers().getPointerElement2(_tileData,_currentGestureLocation);

  //   print("*********** STARTING TIMER *****************");

  //   Timer.periodic(Duration(milliseconds: 20), (Timer t) {
  //     if (count == target) {
  //       t.cancel();
  //       String currentBody = Helpers().getPointerElement2(_tileData,_currentGestureLocation)["body"]??"";
  //       bool isTileActive = Helpers().getPointerElement2(_tileData,_currentGestureLocation)["active"]??true;
  //       if (currentBody != "" && isTileActive) {
  //         _isLongPress = true;
  //       }

  //       if (currentBody == "" && !isTileActive) {
  //         _isLongPress = true;
  //       }
  //       print("*********** FINISHED TIMER *****************");
  //     } else if (_currentGestureLocation == null) {
  //       t.cancel();
  //       _isLongPress = false;
  //       print("*********** TIMER INTERUPTED *****************");
  //     } else if (count == 0) {
  //       downKey = Helpers().getPointerElement2(_tileData,_currentGestureLocation)["key"]??null;
  //       count++;
  //     } else {
  //       currentKey = Helpers().getPointerElement2(_tileData,_currentGestureLocation)["key"]??null;
  //       Map<String,dynamic> pointedElement = Helpers().getPointerElement2(_tileData,_currentGestureLocation);
  //       String currentBody = "";
  //       bool isTileActive = true;
  //       if (pointedElement.isNotEmpty) {
  //         currentBody = Helpers().getPointerElement2(_tileData,_currentGestureLocation)["body"];
  //         isTileActive = Helpers().getPointerElement2(_tileData,_currentGestureLocation)["active"];
  //       } 
  //       if (downKey != currentKey) {
  //         t.cancel();
  //         _isLongPress = false;
  //         print("*********** TIMER INTERUPTED BECAUSE IT IS NOT THE SAME TILE *****************");
  //       } else if (currentBody == "" && isTileActive == true) {
  //         t.cancel();
  //         _isLongPress = false;
  //         print("*********** TIMER INTERUPTED BECAUSE THE TILE IS EMPTY AND NOT ACTIVE *****************");          
     
  //       } else {
  //         count++;
  //       }
  //     }
  //   });

  // }
  
  late Map<String,dynamic>? _tappedUpElement = {};
  Map<String,dynamic>? get tappedUpElement => _tappedUpElement;
  void setTappedUpElement(Map<String,dynamic>? value) {
    _tappedUpElement = value;
    notifyListeners();
  }

  late Map<String,dynamic>? _draggedElementData = null;
  Map<String,dynamic>? get draggedElementData => _draggedElementData;
  void setDraggedElementData(Map<String,dynamic>? value) {
    _draggedElementData = value;
    notifyListeners();
  }

  late Map<String,dynamic>? _openMenuTile = null;
  Map<String,dynamic>? get openMenuTile => _openMenuTile;
  void setOpenMenuTile(Map<String,dynamic>? value) {
    _openMenuTile = value;
    notifyListeners();
  }  

  late List<List<int>> _validIdCombinations = [];
  List<List<int>> get validIdCombinations => _validIdCombinations;
  void setValidIdCombinations(List<List<int>> value) {
    _validIdCombinations = value;
    notifyListeners();
  }


  // late List<Map<String,dynamic>> _foundWordData = [];
  // List<Map<String,dynamic>> get foundWordData => _foundWordData;
  // void setFoundWordData(List<Map<String,dynamic>> value) {
  //   _foundWordData = value;
  //   notifyListeners();
  // }   

  late List<Map<String,dynamic>> _scoreSummary = [];
  List<Map<String,dynamic>> get scoreSummary => _scoreSummary;
  void setscoreSummary(List<Map<String,dynamic>> value) {
    _scoreSummary = value;
    notifyListeners();    
  }


  Duration _highlightEffectDuration = const Duration(seconds: 0);
  Duration get highlightEffectDuration => _highlightEffectDuration;

  Timer? _highlightEffectTimer;
  Timer get highlightEffectTimer => _highlightEffectTimer!;

  void addHighlightEffectTick() {
    if (!_isGamePaused && !isGameOver || isGameStarted) {
      const int addMiilliseconds = 10;
      final int milliseconds = _highlightEffectDuration.inMilliseconds + addMiilliseconds;
      _highlightEffectDuration = Duration(milliseconds: milliseconds);
      notifyListeners();
    }

    
  }

  void startHighlightEffectTimer() {
    _highlightEffectTimer?.cancel();
    _highlightEffectTimer = Timer.periodic(const Duration(milliseconds: 10), (_)  {
      if (!_isGamePaused && !_isGameOver && _isGameStarted) {
        addHighlightEffectTick();
      } else {
        if (_isTutorial) {
          addHighlightEffectTick();
        } else {
          _highlightEffectTimer?.cancel();
        }
      }
    });
  }



  Duration _duration = const Duration(seconds: 0);
  Duration get duration => _duration;

  Timer? _timer;
  Timer get timer => _timer!;

  void addTick() {
    if (!_isGamePaused && !isGameOver || isGameStarted) {
      const int addSeconds = 1;
      final int seconds = _duration.inSeconds + addSeconds;
      _duration = Duration(seconds: seconds);
      notifyListeners();
    }
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_)  {
      if (!_isGamePaused && !_isGameOver && _isGameStarted) {
        // print("start timer add tick: ${_duration.inSeconds}");
        addTick();
      }
    });
  }

  void pauseTimer() {
    _stopWatchTimer?.cancel();
  }  

  int _stopWatchLimit = 0;
  int get stopWatchLimit => _stopWatchLimit;
  void setStopWatchLimit(int? value) {
    if (value != null) {
      _stopWatchLimit = value;
    }
    notifyListeners();
  }

  Duration _stopWatchDuration = Duration(milliseconds: 3000);
  Duration get stopWatchDuration => _stopWatchDuration;

  // void initializeStopWatchDuration() {
  //   _stopWatchDuration = Duration();
  // }


  Timer? _stopWatchTimer;
  Timer get stopWatchTimer => _stopWatchTimer!;


  // void checkTimeExpired() {
  //   if (stopWatchDuration.inMilliseconds <= 0) {
  //     print("ya run out of time!");
  //   }
  // }

  

  void stopWatchAddTick() {

    if (!_isGamePaused) {
      const int addMilliseconds = 10;
      final int milliseconds = _stopWatchDuration.inMilliseconds - addMilliseconds;
      if (milliseconds >= 0) {
        _stopWatchDuration = Duration(milliseconds: milliseconds);
      } else {
        _stopWatchTimer?.cancel();
        print("turn has ended");
        // _stopWatchDuration = Duration(milliseconds: _stopWatchLimit);
      }
    }
    notifyListeners();

  }

  void startStopWatch() {
    _stopWatchTimer?.cancel();
    _stopWatchDuration = Duration(milliseconds: _stopWatchLimit);
    String gameType = _gameParameters["gameType"]; 
    bool isTimeToPlace = _gameParameters["timeToPlace"]!=null;
    if (isTimeToPlace || gameType=="tutorial") {
      _stopWatchTimer = Timer.periodic(const Duration(milliseconds: 10), (_) {
        if (!_isGamePaused && !_isGameOver && _isGameStarted) {
          stopWatchAddTick();
        }
      });
    }
  }

  // void startStopWatchFromCustomTime(int time) {
  //   _stopWatchTimer?.cancel();
  //   _stopWatchDuration = Duration(milliseconds: time); 
  //   _stopWatchTimer = Timer.periodic(const Duration(milliseconds: 10), (_) => stopWatchAddTick());
  // }

  void pauseStopWatchTimer() {
    _stopWatchTimer?.cancel();
  }

  void restartStopWatchTimer() {
    _stopWatchTimer?.cancel();
    _stopWatchDuration = Duration(milliseconds: _stopWatchLimit);
    _stopWatchTimer = Timer.periodic(const Duration(milliseconds: 10), (_) => stopWatchAddTick());
  }



  /// COUNTDOWN
  Duration? _countDownDuration = Duration();
  Duration? get countDownDuration => _countDownDuration;
  void setCountDownDuration(Duration? value) {
    _countDownDuration = value;
    notifyListeners();
  }

  Timer? _countDownTimer;
  Timer get countDownTimer => _countDownTimer!;  


  void countDownAddTick() {
    if (_countDownDuration != null) {
      if (!_isGamePaused) {
        const int subtractSecond = 1;
        final int seconds = _countDownDuration!.inSeconds - subtractSecond;
        _countDownDuration = Duration(seconds: seconds);
      }
    }
    notifyListeners();
  }

  void startCountDown() {
    _countDownTimer?.cancel();
    _countDownTimer = Timer.periodic(Duration(seconds: 1), (_) {
      if (!_isGamePaused && !_isGameOver && _isGameStarted) {
        if (_countDownDuration != null) {
          if (_countDownDuration!.inSeconds > 0) {
            // print("add tick mf ${_countDownDuration!.inSeconds}");

            // if (!_isGameOver) {
              countDownAddTick();
            // }
          } else {
            // _isGameOver = true;
            _countDownTimer!.cancel();
            _timer!.cancel();
            _stopWatchTimer?.cancel();
            print("game over bitch");
            // quitGame();
          }
        }
      }
    });
  }  


  
  void refreshAllData() {

    _timer?.cancel();
    _countDownTimer?.cancel();
    _stopWatchTimer?.cancel();    


    _animationData=[];
    _elementPaths={};
    refreshTileMenuBuyMoreModalData();
    _isGameOver = false;
    _isGameStarted = false;
    _isGamePaused = false;
    _randomLetterData=[];
    _tileData=[];
    // _elementSizes={};
    // _elementPositions={};
    _focusedElement={};
    _tappedDownElement={};
    _tappedUpElement={};
    _draggedElementData=null;
    _openMenuTile=null;
    _validIdCombinations=[];
    _scoreSummary=[];

    refreshGameResultData();

    _timer = null;
    _stopWatchTimer = null;
    _countDownTimer = null;

    _gameParameters = {};
    _currentLevel = 1;
    refreshTileDecorationData();
    refreshTileMenuOptions();

    _duration = Duration(seconds: 0);
    _stopWatchDuration= Duration(milliseconds: 0);
    _countDownDuration = Duration(seconds: 0); 


  }

  void quitGame() {

    _animationData=[];
    _elementPaths={};
    _tileMenuBuyMoreModalData={};
    _isGameOver = true;
    _randomLetterData=[];
    _tileData=[];
    // _elementSizes={};
    // _elementPositions={};
    _focusedElement={};
    _tappedDownElement={};
    _tappedUpElement={};
    _draggedElementData=null;
    _openMenuTile=null;
    _validIdCombinations=[];
    _scoreSummary=[];
    _duration = Duration();
    _timer = null;
    _stopWatchDuration= Duration();
    _stopWatchTimer = null;
    _countDownTimer = null;
    _countDownDuration = null;
    _highlightEffectTimer=null;
    _highlightEffectDuration = Duration();
  }




  late List<Map<String,dynamic>> _alphabet = [];
  List<Map<String,dynamic>> get alphabet => _alphabet;
  void setAlphabet(List<Map<String,dynamic>> value) {
    _alphabet = value;
    notifyListeners();
  }        

  // late List<String> _dictionary = [
  //   "AAA",
  //   "AAAA",
  //   "AAAAA",
  //   "AAAAAA",
  //   "AAAAAAA",
  //   "AAAAAAAA",
  //   "BBB",
  //   "CCC",
  //   "DDD",
  //   "EEE",
  //   "FFF",
  //   "CAT",
  //   "BAKER",
  //   "BAKE",
  //   "STICK",
  //   "TICK",
  //   "GET",
  //   "ARE",
  //   "TOP",
  //   "CROSS",
  //   "WORDS",
  //   "SMILE",
  //   "MILE",
  //   "ILE",
  //   "BLACK",
  //   "LACK",
  //   "SWAP",
  //   "TILES"
  // ];
  // List<String> get dictionary => _dictionary;
  // void setDictionary(List<String> value) {
  //   _dictionary = value;
  //   notifyListeners();
  // }


  late int _currentLevel = 1;
  int get currentLevel => _currentLevel;
  void setCurrentLevel(int value) {
    _currentLevel = value;
    notifyListeners();
  }

  final List<Map<String,dynamic>> _levelData = [
    {"key":1, "start": 0, "end": 300},
    {"key":2, "start": 300, "end": 500},
    {"key":3, "start": 500, "end": 800},
    {"key":4, "start": 800, "end": 1200},
    {"key":5, "start": 1200, "end": 1800},
    {"key":6, "start": 1800, "end": 2500},
    {"key":7, "start": 2500, "end": 3000},
    {"key":8, "start": 3000, "end": 5000},
    {"key":9, "start": 5000, "end": 10000},
    {"key":10, "start": 10000, "end": 15000},
    {"key":11, "start": 15000, "end": 20000},
    {"key":12, "start": 20000, "end": 25000},
    {"key":13, "start": 25000, "end": 30000},
    {"key":14, "start": 30000, "end": 35000},
    {"key":15, "start": 35000, "end": 40000},
    {"key":16, "start": 40000, "end": 50000},
  ];
  List<Map<String,dynamic>> get levelData => _levelData;

  

  @override
  void dispose() {
    _timer?.cancel();
    _countDownTimer?.cancel();
    _stopWatchTimer?.cancel();
    super.dispose();
  }


}
