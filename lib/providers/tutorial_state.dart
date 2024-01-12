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

  final CountDownController _tutorialCountDownController =
      CountDownController();
  CountDownController get tutorialCountDownController =>
      _tutorialCountDownController;

  List<String> _tutorialRandomLetterList = [
    "",
    "",
    "",
    "T",
    "A"
  ]; // tutorialRandomLetterListState;
  List<String> get tutorialRandomLetterList => _tutorialRandomLetterList;

  void setTutorialRandomLetterList(List<String> value) {
    _tutorialRandomLetterList = value;
    notifyListeners();
  }

  List<Map<String, dynamic>> _tutorialTileState =
      tutorialBoard_1; // startingTileState;
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
    "C",
    "S",
    "P",
    "W",
    "T",
    "A",
    "G",
    "B",
    "P",
    "N",
    "S",
    "H",
    "I",
    "N",
    "T",
    "A",
    "E",
    "E",
    "V",
    "Z",
    "R",
  ]; // tutorialLettersToAddState;
  List<String> get tutorialLettersToAdd => _tutorialLettersToAdd;

  void setTutorialLettersToAdd(List<String> value) {
    _tutorialLettersToAdd = value;
    notifyListeners();
  }


  List<String> _tutorialLettersToPlace = [
    "T",
    "A",
    "C",
    "S",
    "P",
    "W",
    "T",
    "A",
    "G",
    "B",
    "P",
    "N",
    "S",
    "H",
    "I",
    "N",
    "T",
    "A",
    "E",
    "E",
    "V",
    "Z",
    "R",
  ]; // tutorialLettersToPlaceState;
  List<String> get tutorialLettersToPlace => _tutorialLettersToPlace;

  void setTutorialLettersToPlace(List<String> value) {
    _tutorialLettersToPlace = value;
    notifyListeners();
  }



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



  int _tutorialPointsTally = 0;
  int get tutorialPointsTally => _tutorialPointsTally;

  void setTutorialPointsTally(int value) {
    _tutorialPointsTally = value;
    notifyListeners();
  }

  int _tutorialNewPoints = 0;
  int get tutorialNewPoints => _tutorialNewPoints;

  void setTutorialNewPoints(int value) {
    _tutorialNewPoints = value;
    notifyListeners();
  }  

  int _tutorialWordsTally = 0;
  int get tutorialWordsTally => _tutorialWordsTally;

  void setTutorialWordsTally(int value) {
    _tutorialWordsTally = value;
    notifyListeners();
  }

  int _tutorialNewWords = 0;
  int get tutorialNewWords => _tutorialNewWords;

  void setTutorialNewWords(int value) {
    _tutorialNewWords = value;
    notifyListeners();
  } 


  int _tutorialStreak = 3;
  int get tutorialStreak => _tutorialStreak;

  void setTutorialStreak(int value) {
    _tutorialStreak = value;
    notifyListeners();
  }     

  int _tutorialMultiWords = 3;
  int get tutorialMultiWords => _tutorialMultiWords;

  void setTutorialMultiWords(int value) {
    _tutorialMultiWords = value;
    notifyListeners();
  } 

  int _tutorialCrossWords = 3;
  int get tutorialCrossWords => _tutorialCrossWords;

  void setTutorialCrossWords(int value) {
    _tutorialCrossWords = value;
    notifyListeners();
  }



  // double _tutorialTextGlowOpacity = 0.0;
  // double get tutorialTextGlowOpacity => _tutorialTextGlowOpacity;

  // void setTutorialTextGlowOpacity(double value) {
  //   _tutorialTextGlowOpacity = value;
  //   notifyListeners();
  // }


  List<Map<String,dynamic>> _tutorialStateHistory = [];
  List<Map<String,dynamic>> get tutorialStateHistory => _tutorialStateHistory;

  void setTutorialStateHistory(List<Map<String,dynamic>> value) {
    _tutorialStateHistory = value;
    notifyListeners();
  }


    
}
