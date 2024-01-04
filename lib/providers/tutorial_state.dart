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
    "H",
    "E"
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

  List<String> _tutorialLettersToAdd = [
    "L",
    "L",
    "O",
    "W",
    "O",
    "R",
    "L",
    "D",
    "",
    "",
  ]; // tutorialLettersToAddState;
  List<String> get tutorialLettersToAdd => _tutorialLettersToAdd;

  void setTutorialLettersToAdd(List<String> value) {
    _tutorialLettersToAdd = value;
    notifyListeners();
  }
}
