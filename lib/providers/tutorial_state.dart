import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/foundation.dart';
import 'package:scribby_flutter_v2/utils/states.dart';

class TutorialState extends ChangeNotifier {
  bool _isStep1Complete = false;
  bool get isStep1Complete => _isStep1Complete;

  void setIsStep1Complete(bool value) {
    _isStep1Complete = value;
    notifyListeners();
  }

  int _sequenceStep = 0;
  int get sequenceStep => _sequenceStep;

  void setSequenceStep(int value) {
    _sequenceStep = value;
    notifyListeners();
  }

  final CountDownController _tutorialCountDownController =CountDownController();
  CountDownController get tutorialCountDownController =>_tutorialCountDownController;

  // List<String> _tutorialRandomLetterList = [
  //   "",
  //   "",
  //   "",
  //   "T",
  //   "A"
  // ]; // tutorialRandomLetterListState;
  // List<String> get tutorialRandomLetterList => _tutorialRandomLetterList;

  // void setTutorialRandomLetterList(List<String> value) {
  //   _tutorialRandomLetterList = value;
  //   notifyListeners();
  // }

  List<Map<String, dynamic>> _tutorialTileState = tutorialBoard_1; // startingTileState;
  List<Map<String, dynamic>> get tutorialTileState => _tutorialTileState;

  void setTutorialTileState(List<Map<String, dynamic>> value) {
    _tutorialTileState = value;
    notifyListeners();
  }

  int _tutorialTurn = 0;
  int get tutorialTurn => _tutorialTurn;

  void setTutorialTurn(int value) {
    _tutorialTurn = value;
    notifyListeners();
  }

  int _tutorialGameTurn = 0;
  int get tutorialGameTurn => _tutorialGameTurn;

  void setTutorialGameTurn(int value) {
    _tutorialGameTurn = value;
    notifyListeners();
  }  

  List<String> _tutorialLettersToAdd = [
    "",
    "T",
    "L",
    "A",
    "C",
    "A",
    "E",
    "S",
    "P",
    "W", // 2
    "T", // 20
    "A", // 22
    "G", // 27
    "B", // 15,
    "P", // 5
    "N", // 24
    "S", // 4
    "H", // 17
    "I", // 18
    "N", // 29
    "T", // 30
    "U",
    // "V",
    "R",
    "Z",
    "E",
    "Y",
    "W",
    "O"
  ]; // tutorialLettersToAddState;
  List<String> get tutorialLettersToAdd => _tutorialLettersToAdd;

  void setTutorialLettersToAdd(List<String> value) {
    _tutorialLettersToAdd = value;
    notifyListeners();
  }


  // List<String> _tutorialLettersToPlace = [
  //   "",
  //   "T",
  //   "A",
  //   "C",
  //   "S",
  //   "P",
  //   "W",
  //   "T",
  //   "A",
  //   "G",
  //   "B",
  //   "P",
  //   "N",
  //   "S",
  //   "H",
  //   "I",
  //   "N",
  //   "T",
  //   "A",
  //   "E",
  //   "E",
  //   "V",
  //   "Z",
  //   "R",
  // ]; // tutorialLettersToPlaceState;
  // List<String> get tutorialLettersToPlace => _tutorialLettersToPlace;

  // void setTutorialLettersToPlace(List<String> value) {
  //   _tutorialLettersToPlace = value;
  //   notifyListeners();
  // }



  List<Map<String, dynamic>> _reserveTiles = [
    {"id": 0, "body": ""},
    {"id": 1, "body": ""},
    {"id": 2, "body": ""},
    {"id": 3, "body": ""},
    {"id": 4, "body": ""},
  ];

  List<Map<String, dynamic>> get reserveTiles => _reserveTiles;

  void setReserveTiles(List<Map<String, dynamic>> value) {
    _reserveTiles = value;
    notifyListeners();
  }

  late Map<String, dynamic> _draggedReserveTile = {};
  Map<String, dynamic> get draggedReserveTile => _draggedReserveTile;

  void setDraggedReserveTile(Map<String, dynamic> value) {
    _draggedReserveTile = value;
    notifyListeners();
  }



  // int _tutorialPointsTally = 0;
  // int get tutorialPointsTally => _tutorialPointsTally;

  // void setTutorialPointsTally(int value) {
  //   _tutorialPointsTally = value;
  //   notifyListeners();
  // }

  // int _tutorialNewPoints = 0;
  // int get tutorialNewPoints => _tutorialNewPoints;

  // void setTutorialNewPoints(int value) {
  //   _tutorialNewPoints = value;
  //   notifyListeners();
  // }  

  // int _tutorialWordsTally = 0;
  // int get tutorialWordsTally => _tutorialWordsTally;

  // void setTutorialWordsTally(int value) {
  //   _tutorialWordsTally = value;
  //   notifyListeners();
  // }

  // int _tutorialNewWords = 0;
  // int get tutorialNewWords => _tutorialNewWords;

  // void setTutorialNewWords(int value) {
  //   _tutorialNewWords = value;
  //   notifyListeners();
  // } 


  // int _tutorialStreak = 3;
  // int get tutorialStreak => _tutorialStreak;

  // void setTutorialStreak(int value) {
  //   _tutorialStreak = value;
  //   notifyListeners();
  // }     

  // int _tutorialMultiWords = 3;
  // int get tutorialMultiWords => _tutorialMultiWords;

  // void setTutorialMultiWords(int value) {
  //   _tutorialMultiWords = value;
  //   notifyListeners();
  // } 

  // int _tutorialCrossWords = 3;
  // int get tutorialCrossWords => _tutorialCrossWords;

  // void setTutorialCrossWords(int value) {
  //   _tutorialCrossWords = value;
  //   notifyListeners();
  // }



  // double _tutorialTextGlowOpacity = 0.0;
  // double get tutorialTextGlowOpacity => _tutorialTextGlowOpacity;

  // void setTutorialTextGlowOpacity(double value) {
  //   _tutorialTextGlowOpacity = value;
  //   notifyListeners();
  // }


  // List<Map<String,dynamic>> _tutorialStateHistory = [];
  // List<Map<String,dynamic>> get tutorialStateHistory => _tutorialStateHistory;

  // void setTutorialStateHistory(List<Map<String,dynamic>> value) {
  //   _tutorialStateHistory = value;
  //   notifyListeners();
  // }


  List<Map<String,dynamic>> _tutorialStateHistory2 = [];
  List<Map<String,dynamic>> get tutorialStateHistory2 => _tutorialStateHistory2;

  void setTutorialStateHistory2(List<Map<String,dynamic>> value) {
    _tutorialStateHistory2 = value;
    notifyListeners();
  }  

  int _tutorialMove = 0;
  int get tutorialMove => _tutorialMove;

  void setTutorialMove(int value) {
    _tutorialMove = value;
    notifyListeners();
  }  


  Map<String,dynamic> _tutorialSummaryData = {
    "score": 462,
    "words": 9,
    "longestStreak": 4,
    "crosswords": 1,
    "mostPoints": 304,
    "mostWords": 3,
    "summary": [
      {"turn": 1, "index": 1, "word": "CAT", "wordMultiplier": 1, "crosswordMultiplier": 1, "streakMultiplier": 1, "points": 4},
      {"turn": 2, "index": 2, "word": "WAS", "wordMultiplier": 3, "crosswordMultiplier": 1, "streakMultiplier": 1, "points": 12},
      {"turn": 2, "index": 3, "word": "ASP", "wordMultiplier": 3, "crosswordMultiplier": 1, "streakMultiplier": 1, "points": 9},
      {"turn": 2, "index": 4, "word": "WASP", "wordMultiplier": 3, "crosswordMultiplier": 1, "streakMultiplier": 1, "points": 15},
      {"turn": 3, "index": 5, "word": "HUN", "wordMultiplier": 1, "crosswordMultiplier": 1, "streakMultiplier": 2, "points": 10},
      {"turn": 4, "index": 6, "word": "TEA", "wordMultiplier": 2, "crosswordMultiplier": 2, "streakMultiplier": 3, "points": 48},
      {"turn": 4, "index": 7, "word": "BEG", "wordMultiplier": 2, "crosswordMultiplier": 2, "streakMultiplier": 3, "points": 60},
      {"turn": 5, "index": 8, "word": "PRINT", "wordMultiplier": 2, "crosswordMultiplier": 1, "streakMultiplier": 4, "points": 112},
      {"turn": 5, "index": 9, "word": "SPRINT", "wordMultiplier": 2, "crosswordMultiplier": 1, "streakMultiplier": 4, "points": 192},        
    ]

  };
  Map<String,dynamic> get tutorialSummaryData => _tutorialSummaryData;

  void setTutorialSummaryData(Map<String,dynamic> value) {
    _tutorialSummaryData = value;
    notifyListeners();
  }

    
}
