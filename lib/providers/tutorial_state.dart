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
      "letter_00" ,
      "letter_01" ,
      "letter_02" ,
      "letter_03" ,
      "letter_04" ,
      "letter_05" ,
      "letter_06" ,
      "letter_07" ,
      "letter_08" ,
      "letter_09" ,
      "letter_10" ,
      "letter_11" ,
      "letter_12" ,
      "letter_13" ,
      "letter_14" ,
      "letter_15" ,
      "letter_16" ,
      "letter_17" ,
      "letter_18" ,   
      "letter_19" ,
      "letter_20" ,
      "letter_21" ,
      "letter_22" ,
      "letter_23" ,       
      "letter_24" ,
      "letter_25" ,     
      "letter_26" ,     
      "letter_27" ,       
    // "",
    // "T",
    // "L",
    // "A",
    // "C",
    // "A",
    // "E",
    // "S",
    // "P",
    // "W", // 2
    // "T", // 20
    // "A", // 22
    // "G", // 27
    // "B", // 15,
    // "P", // 5
    // "N", // 24
    // "S", // 4
    // "H", // 17
    // "I", // 18
    // "N", // 29
    // "T", // 30
    // "U",
    // // "V",
    // "R",
    // "Z",
    // "E",
    // "Y",
    // "W",
    // "O"
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

    "english": {

      "score": 462,
      "words": 9,
      "longestStreak": 4,
      "crosswords": 1,
      "mostPoints": 304,
      "mostWords": 3,
      "summary": [
        {"turn": 1, "index": 1, "word": "word_1", "wordMultiplier": 1, "crosswordMultiplier": 1, "streakMultiplier": 1, "points": 4}, // "CAT"
        {"turn": 2, "index": 2, "word": "word_2", "wordMultiplier": 3, "crosswordMultiplier": 1, "streakMultiplier": 1, "points": 12}, // "WAS"
        {"turn": 2, "index": 3, "word": "word_3", "wordMultiplier": 3, "crosswordMultiplier": 1, "streakMultiplier": 1, "points": 9}, // "ASP"
        {"turn": 2, "index": 4, "word": "word_4", "wordMultiplier": 3, "crosswordMultiplier": 1, "streakMultiplier": 1, "points": 15}, // "WASP"
        {"turn": 3, "index": 5, "word": "word_5", "wordMultiplier": 1, "crosswordMultiplier": 1, "streakMultiplier": 2, "points": 10}, // "HUN"
        {"turn": 4, "index": 6, "word": "word_6", "wordMultiplier": 2, "crosswordMultiplier": 2, "streakMultiplier": 3, "points": 48}, // "TEA"
        {"turn": 4, "index": 7, "word": "word_7", "wordMultiplier": 2, "crosswordMultiplier": 2, "streakMultiplier": 3, "points": 60}, // "BEG"
        {"turn": 5, "index": 8, "word": "word_8", "wordMultiplier": 2, "crosswordMultiplier": 1, "streakMultiplier": 4, "points": 112}, // "PRINT"
        {"turn": 5, "index": 9, "word": "word_9", "wordMultiplier": 2, "crosswordMultiplier": 1, "streakMultiplier": 4, "points": 192}, // "SPRINT"        
      ]

    },

    "french": {
      "score": 551,
      "words": 9,
      "longestStreak": 4,
      "crosswords": 1,
      "mostPoints": 272,
      "mostWords": 3,
      "summary": [
        {'turn': 1,'index': 1,'word': 'word_1','wordMultiplier': 1,'crosswordMultiplier': 1,'streakMultiplier': 1,'points': 3}, //'EAU'
        {'turn': 2,'index': 2,'word': 'word_2','wordMultiplier': 3,'crosswordMultiplier': 1,'streakMultiplier': 1,'points': 30}, //'JEU'
        {'turn': 2,'index': 3,'word': 'word_3','wordMultiplier': 3,'crosswordMultiplier': 1,'streakMultiplier': 1,'points': 36}, //'EUX'
        {'turn': 2,'index': 4,'word': 'word_4','wordMultiplier': 3,'crosswordMultiplier': 1,'streakMultiplier': 1,'points': 60}, //'JEUX'
        {'turn': 3,'index': 5,'word': 'word_5','wordMultiplier': 1,'crosswordMultiplier': 1,'streakMultiplier': 2,'points': 6}, //'LIT'
        {'turn': 4,'index': 6,'word': 'word_6','wordMultiplier': 2,'crosswordMultiplier': 2,'streakMultiplier': 3,'points': 144}, //'NEZ'
        {'turn': 4,'index': 7,'word': 'word_7','wordMultiplier': 2,'crosswordMultiplier': 2,'streakMultiplier': 3,'points': 48}, //'MER'
        {'turn': 5,'index': 8,'word': 'word_8','wordMultiplier': 2,'crosswordMultiplier': 1,'streakMultiplier': 4,'points': 80}, //'LAINE'
        {'turn': 5,'index': 9,'word': 'word_9','wordMultiplier': 2,'crosswordMultiplier': 1,'streakMultiplier': 4,'points': 192} //'PLAINE'
      ]

    },


    "spanish": {
      "score": 580,
      "words": 9,
      "longestStreak": 4,
      "crosswords": 1,
      "mostPoints": 384,
      "mostWords": 3,
      "summary": [
        {'turn': 1, 'index': 1,  'word': 'word_1',  'wordMultiplier': 1,  'crosswordMultiplier': 1,  'streakMultiplier': 1,  'points': 4}, //'GOL' 
        {'turn': 2,  'index': 2,  'word': 'word_2',  'wordMultiplier': 3,  'crosswordMultiplier': 1,  'streakMultiplier': 1,  'points': 15}, //'MIR' 
        {'turn': 2,  'index': 3,  'word': 'word_3',  'wordMultiplier': 3,  'crosswordMultiplier': 1,  'streakMultiplier': 1,  'points': 9}, //'IRA' 
        {'turn': 2,  'index': 4,  'word': 'word_4',  'wordMultiplier': 3,  'crosswordMultiplier': 1,  'streakMultiplier': 1,  'points': 18}, //'MIRA' 
        {'turn': 3,  'index': 5,  'word': 'word_5',  'wordMultiplier': 1,  'crosswordMultiplier': 1,  'streakMultiplier': 2,  'points': 6}, //'TEA' 
        {'turn': 4,  'index': 6,  'word': 'word_6',  'wordMultiplier': 2,  'crosswordMultiplier': 2,  'streakMultiplier': 3,  'points': 72}, //'SOY' 
        {'turn': 4,  'index': 7,  'word': 'word_7',  'wordMultiplier': 2,  'crosswordMultiplier': 2,  'streakMultiplier': 3,  'points': 72}, //'VOS' 
        {'turn': 5,  'index': 8,  'word': 'word_8',  'wordMultiplier': 2,  'crosswordMultiplier': 1,  'streakMultiplier': 4,  'points': 240}, //'PRIMAR' 
        {'turn': 5,  'index': 9,  'word': 'word_9',  'wordMultiplier': 2,  'crosswordMultiplier': 1,  'streakMultiplier': 4,  'points': 144} //'PRIMA'
      ]
    },  



    "german": {
      "score": 652,
      "words": 9,
      "longestStreak": 4,
      "crosswords": 1,
      "mostPoints": 416,
      "mostWords": 3,
      "summary": [
        {'turn': 1,'index': 1,  'word': 'word_1',  'wordMultiplier': 1,  'crosswordMultiplier': 1,  'streakMultiplier': 1,  'points': 6}, //'CES' 
        {'turn': 2,'index': 2,'word': 'word_2','wordMultiplier': 3,'crosswordMultiplier': 1,'streakMultiplier': 1,'points': 9}, //'ADE'
        {'turn': 2,'index': 3,'word': 'word_3','wordMultiplier': 3,'crosswordMultiplier': 1,'streakMultiplier': 1,'points': 9}, //'DER'
        {'turn': 2,'index': 4,'word': 'word_4','wordMultiplier': 3,'crosswordMultiplier': 1,'streakMultiplier': 1,'points': 12}, //'ADER'
        {'turn': 3,'index': 5,'word': 'word_5','wordMultiplier': 1,'crosswordMultiplier': 1,'streakMultiplier': 2,'points': 8}, //'TAL'
        {'turn': 4,'index': 6,'word': 'word_6','wordMultiplier': 2,'crosswordMultiplier': 2,'streakMultiplier': 3,'points': 120}, //'ÜBE'
        {'turn': 4,'index': 7,'word': 'word_7','wordMultiplier': 2,'crosswordMultiplier': 2,'streakMultiplier': 3,'points': 72}, //'ABO'
        {'turn': 5,'index': 8,'word': 'word_8','wordMultiplier': 2,'crosswordMultiplier': 1,'streakMultiplier': 4,'points': 288}, //'FLOGEN'
        {'turn': 5,'index': 9,'word': 'word_9','wordMultiplier': 2,'crosswordMultiplier': 1,'streakMultiplier': 4,'points': 128} //'LOGEN'
      ]

    },  

    "italian": {
      "score": 1067,
      "words": 9,
      "longestStreak": 4,
      "crosswords": 1,
      "mostPoints": 808,
      "mostWords": 3,
      "summary": [
          {'turn': 1,'index': 1,'word': 'word_1','wordMultiplier': 1,'crosswordMultiplier': 1,'streakMultiplier': 1,'points': 5}, //'EIL'
          {'turn': 2,'index': 2,'word': 'word_2','wordMultiplier': 3,'crosswordMultiplier': 1,'streakMultiplier': 1,'points': 24}, //'CAP'
          {'turn': 2,'index': 3,'word': 'word_3','wordMultiplier': 3,'crosswordMultiplier': 1,'streakMultiplier': 1,'points': 21}, //'API'
          {'turn': 2,'index': 4,'word': 'word_4','wordMultiplier': 3,'crosswordMultiplier': 1,'streakMultiplier': 1,'points': 27}, //'CAPI'
          {'turn': 3,'index': 5,'word': 'word_5','wordMultiplier': 1,'crosswordMultiplier': 1,'streakMultiplier': 2,'points': 14}, //'UNO'
          {'turn': 4,'index': 6,'word': 'word_6','wordMultiplier': 2,'crosswordMultiplier': 2,'streakMultiplier': 3,'points': 84}, //'VIA'
          {'turn': 4,'index': 7,'word': 'word_7','wordMultiplier': 2,'crosswordMultiplier': 2,'streakMultiplier': 3,'points': 84}, //'PIO'
          {'turn': 5,'index': 8,'word': 'word_8','wordMultiplier': 2,'crosswordMultiplier': 1,'streakMultiplier': 4,'points': 504}, //'RAGGIO'
          {'turn': 5,'index': 9,'word': 'word_9','wordMultiplier': 2,'crosswordMultiplier': 1,'streakMultiplier': 4,'points': 304} //'AGGIO'
      ]

    },  

    "portuguese": {
      "score": 769,
      "words": 9,
      "longestStreak": 4,
      "crosswords": 1,
      "mostPoints": 504,
      "mostWords": 3,
      "summary": [
        {'turn': 1,'index': 1,'word': 'word_1','wordMultiplier': 1,'crosswordMultiplier': 1,'streakMultiplier': 1,'points': 3}, //'TIR'
        {'turn': 2,'index': 2,'word': 'word_2','wordMultiplier': 3,'crosswordMultiplier': 1,'streakMultiplier': 1,'points': 12}, //'PAR'
        {'turn': 2,'index': 3,'word': 'word_3','wordMultiplier': 3,'crosswordMultiplier': 1,'streakMultiplier': 1,'points': 9}, //'ARA'
        {'turn': 2,'index': 4,'word': 'word_4','wordMultiplier': 3,'crosswordMultiplier': 1,'streakMultiplier': 1,'points': 15}, //'PARA'
        {'turn': 3,'index': 5,'word': 'word_5','wordMultiplier': 1,'crosswordMultiplier': 1,'streakMultiplier': 2,'points': 10}, //'ABE'
        {'turn': 4,'index': 6,'word': 'word_6','wordMultiplier': 2,'crosswordMultiplier': 2,'streakMultiplier': 3,'points': 144}, //'SAÍ'
        {'turn': 4,'index': 7,'word': 'word_7','wordMultiplier': 2,'crosswordMultiplier': 2,'streakMultiplier': 3,'points': 72}, //'VAI'
        {'turn': 5,'index': 8,'word': 'word_8','wordMultiplier': 2,'crosswordMultiplier': 1,'streakMultiplier': 4,'points': 312}, //'TEXTOS'
        {'turn': 5,'index': 9,'word': 'word_9','wordMultiplier': 2,'crosswordMultiplier': 1,'streakMultiplier': 4,'points': 192} //'TEXTO'
      ]

    },  

    "greek": {
      "score": 546,
      "words": 9,
      "longestStreak": 4,
      "crosswords": 1,
      "mostPoints": 344,
      "mostWords": 3,
      "summary": [
        {'turn': 1,'index': 1,'word': 'word_1','wordMultiplier': 1,'crosswordMultiplier': 1,'streakMultiplier': 1,'points': 4}, //'ΟΡΕ'
        {'turn': 2,'index': 2,'word': 'word_2','wordMultiplier': 3,'crosswordMultiplier': 1,'streakMultiplier': 1,'points': 15}, //'ΜΕΣ'
        {'turn': 2,'index': 3,'word': 'word_3','wordMultiplier': 3,'crosswordMultiplier': 1,'streakMultiplier': 1,'points': 15}, //'ΕΣΩ'
        {'turn': 2,'index': 4,'word': 'word_4','wordMultiplier': 3,'crosswordMultiplier': 1,'streakMultiplier': 1,'points': 24}, //'ΜΕΣΩ'
        {'turn': 3,'index': 5,'word': 'word_5','wordMultiplier': 1,'crosswordMultiplier': 1,'streakMultiplier': 2,'points': 24}, //'ΑΨΕ'
        {'turn': 4,'index': 6,'word': 'word_6','wordMultiplier': 2,'crosswordMultiplier': 2,'streakMultiplier': 3,'points': 72}, //'ΑΠΩ'
        {'turn': 4,'index': 7,'word': 'word_7','wordMultiplier': 2,'crosswordMultiplier': 2,'streakMultiplier': 3,'points': 48}, //'ΟΠΑ'
        {'turn': 5,'index': 8,'word': 'word_8','wordMultiplier': 2,'crosswordMultiplier': 1,'streakMultiplier': 4,'points': 216}, //'ΣΚΥΡΟΣ'
        {'turn': 5,'index': 9,'word': 'word_9','wordMultiplier': 2,'crosswordMultiplier': 1,'streakMultiplier': 4,'points': 128} //'ΚΥΡΟΣ'
      ]

    },  

    "dutch": {
      "score": 549,
      "words": 9,
      "longestStreak": 4,
      "crosswords": 1,
      "mostPoints": 304,
      "mostWords": 3,
      "summary": [
        {'turn': 1,'index': 1,'word': 'word_1','wordMultiplier': 1,'crosswordMultiplier': 1,'streakMultiplier': 1,'points': 5}, //'TAS'
        {'turn': 2,'index': 2,'word': 'word_2','wordMultiplier': 3,'crosswordMultiplier': 1,'streakMultiplier': 1,'points': 21}, //'GAL'
        {'turn': 2,'index': 3,'word': 'word_3','wordMultiplier': 3,'crosswordMultiplier': 1,'streakMultiplier': 1,'points': 21}, //'ALG'
        {'turn': 2,'index': 4,'word': 'word_4','wordMultiplier': 3,'crosswordMultiplier': 1,'streakMultiplier': 1,'points': 30}, //'GALG'
        {'turn': 3,'index': 5,'word': 'word_5','wordMultiplier': 1,'crosswordMultiplier': 1,'streakMultiplier': 2,'points': 12}, //'ZEE'
        {'turn': 4,'index': 6,'word': 'word_6','wordMultiplier': 2,'crosswordMultiplier': 2,'streakMultiplier': 3,'points': 84}, //'BAL'
        {'turn': 4,'index': 7,'word': 'word_7','wordMultiplier': 2,'crosswordMultiplier': 2,'streakMultiplier': 3,'points': 72}, //'JAN'
        {'turn': 5,'index': 8,'word': 'word_8','wordMultiplier': 2,'crosswordMultiplier': 1,'streakMultiplier': 4,'points': 192}, //'AARDEN'
        {'turn': 5,'index': 9,'word': 'word_9','wordMultiplier': 2,'crosswordMultiplier': 1,'streakMultiplier': 4,'points': 112} //'AARDE'
      ]
    },  

                        
  

  };


  

  Map<String,dynamic> get tutorialSummaryData => _tutorialSummaryData;

  void setTutorialSummaryData(Map<String,dynamic> value) {
    _tutorialSummaryData = value;
    notifyListeners();
  }

    
}
