// import 'dart:async';

import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scribby_flutter_v2/functions/game_logic.dart';
import 'package:scribby_flutter_v2/utils/states.dart';
// import 'package:scribby_flutter_v2/functions/game_logic.dart';
// import 'package:scribby_flutter_v2/resources/auth_service.dart';
// import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
// import 'package:scribby_flutter_v2/utils/states.dart';

class GamePlayState with ChangeNotifier {
  // provides a log of turns.
  // ex: [{turn: 1, ...data...}, {turn: 2, ...data...},]
  List<Map<String, dynamic>> _gameSummaryLog = [];
  List<Map<String, dynamic>> get gameSummaryLog => _gameSummaryLog;

  void setGameSummaryLog(List<Map<String, dynamic>> value) {
    _gameSummaryLog = value;
    notifyListeners();
  }

  // provides a snapshot of the current state of the game at a given point in time
  // ex: {turns: 12, words: ['hello','world'], longestStreak:0, ...}
  Map<String, dynamic> _summaryData = {};
  Map<String, dynamic> get summaryData => _summaryData;

  void setSummaryData(Map<String, dynamic> value) {
    _summaryData = value;
    notifyListeners();
  }

  // provides a snapshot of the current state of the game at a given point in time
  // ex: {turns: 12, words: ['hello','world'], longestStreak:0, ...}
  Map<String, dynamic> _endOfGameData = {};
  Map<String, dynamic> get endOfGameData => _endOfGameData;

  void setEndOfGameData(Map<String, dynamic> value) {
    _endOfGameData = value;
    notifyListeners();
  }

  // provides a VISUAL representation of the board. Meaning that it shows the letters that
  // were in a word temporarily while the animation plays
  List<Map<String, dynamic>> _visualTileState = []; // startingTileState;
  List<Map<String, dynamic>> get visualTileState => _visualTileState;

  void setVisualTileState(List<Map<String, dynamic>> value) {
    _visualTileState = value;
    notifyListeners();
  }

  // // provides a LOGICAL representation of the board. Meaning that it returns
  // // the board without the letters that were found in a word
  // List<Map<String, dynamic>> _logicalTileState = [];
  // List<Map<String, dynamic>> get logicalTileState => _logicalTileState;

  // void setLogicalTileState(List<Map<String, dynamic>> value) {
  //   _logicalTileState = value;
  //   notifyListeners();
  // }

  /// for the points animation
  int _previousScore = 0;
  int get previousScore => _previousScore;

  void setPreviousScore(int value) {
    _previousScore = value;
    notifyListeners();
  }

  int _currentScore = 0;
  int get currentScore => _currentScore;

  void setCurrentScore(int value) {
    _currentScore = value;
    notifyListeners();
  }

  int _turnScore = 0;
  int get turnScore => _turnScore;

  void setTurnScore(int value) {
    _turnScore = value;
    notifyListeners();
  }

  int _turnWords = 0;
  int get turnWords => _turnWords;

  void setTurnWords(int value) {
    _turnWords = value;
    notifyListeners();
  }

  int _activeStreak = 0;
  int get activeStreak => _activeStreak;

  void setActiveStreak(int value) {
    _activeStreak = value;
    notifyListeners();
  }

  int _currentTurn = 0;
  int get currentTurn => _currentTurn;

  void setCurrentTurn(int value) {
    _currentTurn = value;
    notifyListeners();
  }

  bool _isAnimating = false;
  bool get isAnimating => _isAnimating;

  void setIsAnimating(bool value) {
    _isAnimating = value;
    notifyListeners();
  }

  bool _displayLevelChange = false;
  bool get displayLevelChange => _displayLevelChange;

  void setDisplayLevelChange(bool value) {
    _displayLevelChange = value;
    notifyListeners();
  }

  // int _currentTime = 0;
  // int get currentTime => _currentTime;

  // void setCurrentTime(int value) {
  //   _currentTime = value;
  //   notifyListeners();
  // }

  String _pressedTile = "1_1";
  String get pressedTile => _pressedTile;

  void setPressedTile(String value) {
    _pressedTile = value;
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

  int _currentLevel = 1;
  int get currentLevel => _currentLevel;

  void setCurrentLevel(int value) {
    _currentLevel = value;
    notifyListeners();
  }

  int _previousLevel = 1;
  int get previousLevel => _previousLevel;

  void setPreviousLevel(int value) {
    _previousLevel = value;
    notifyListeners();
  }

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void setCurrentIndex(int value) {
    _currentIndex = value;
    notifyListeners();
  }

  // returns the two initial random letters and updates the bag accordingly
  // Map<String,dynamic> _startingRandomLetterData = {};
  // Map<String,dynamic> get startingRandomLetterData => _startingRandomLetterData;

  // void setStartingRandomLetterData(Map<String,dynamic> value) {
  //   _startingRandomLetterData = value;
  //   notifyListeners();
  // }

  // a continuous list of randomly generated letters
  String _currentLanguage = "english";
  String get currentLanguage => _currentLanguage;

  void setCurrentLanguage(String value) {
    _currentLanguage = value;
    notifyListeners();
  }

  // a virtual version of a tile bag
  List<Map<String, dynamic>> _alphabetState = []; //startingAlphabetState;
  List<Map<String, dynamic>> get alphabetState => _alphabetState;

  void setAlphabetState(List<Map<String, dynamic>> value) {
    _alphabetState = value;
    notifyListeners();
  }

  // a continuous list of randomly generated letters
  List<String> _randomLetterList = []; // randomLetterListState;
  List<String> get randomLetterList => _randomLetterList;

  void setRandomLetterList(List<String> value) {
    _randomLetterList = value;
    notifyListeners();
  }

  void restartGame() {
    // Reset your state variables here
    _currentLevel = 1;
    _previousLevel = 1;
    _isGameEnded = false;
    _isGamePaused = true;
    _isGameStarted = false;
    _gameSummaryLog = [];
    _summaryData = {};
    _visualTileState = []; //startingTileState;
    _previousScore = 0;
    _currentScore = 0;
    _turnScore = 0;
    _turnWords = 0;
    _activeStreak = 0;
    _currentTurn = 0;
    _pressedTile = "1_1";
    _alphabetState = []; // startingAlphabetState;
    _randomLetterList = []; // randomLetterListState;
    _reserveTiles = [
      {"id": 0, "body": ""},
      {"id": 1, "body": ""},
      {"id": 2, "body": ""},
      {"id": 3, "body": ""},
      {"id": 4, "body": ""},
    ];

    _timer?.cancel();
    _duration = const Duration();
    _countDownController.restart(duration: GameLogic().getCountdownDuration(1));
    _countDownController.pause();
    // if (_pageController.hasClients) {
    //   _pageController.jumpToPage(0);
    // }

    notifyListeners();

    // _visualTileState = GameLogic().generateStartingStates(initialRandomLetterState, initialBoardState, [])['startingTileState'];
    // Notify listeners after resetting the state variables
    // notifyListeners();
  }

  // final Map<String,dynamic> startingRandomLetterData = {
  //   "list" : startingRandomLetterList,
  //   "state" : alphabetState2
  // };

  bool _isGamePaused = true;
  bool get isGamePaused => _isGamePaused;

  // void setIsGamePaused(bool value, int page) {
  //   _isGamePaused = value;
  //   if (value != true) {
  //     Future.delayed(const Duration(milliseconds: 300), () {
  //       if (_pageController.hasClients) {
  //         _pageController.jumpToPage(0);
  //       }
  //       _countDownController.resume();
  //     });
  //   } else {
  //     Future.delayed(const Duration(milliseconds: 0), () {
  //       if (_pageController.hasClients) {
  //         _pageController.jumpToPage(page);
  //       }
  //       _countDownController.pause();
  //     });
  //   }
  //   notifyListeners();
  // }

  void setIsGamePaused(bool value, int page) {
    _isGamePaused = value;
    if (value != true) {
      Future.delayed(const Duration(milliseconds: 300), () {
        // if (_pageController.hasClients) {
        //   _pageController.jumpToPage(0);
        // }
        _countDownController.resume();
      });
    } else {
      Future.delayed(const Duration(milliseconds: 0), () {
        // if (_pageController.hasClients) {
        //   _pageController.jumpToPage(page);
        // }
        _countDownController.pause();
      });
    }
    notifyListeners();
  }

  bool _isGameStarted = false;
  bool get isGameStarted => _isGameStarted;

  void setIsGameStarted(bool value) {
    _isGameStarted = value;

    if (value == true) {
      _isGamePaused = false;
      startTimer();
      _countDownController.restart();
      _endOfGameData = {};
    }

    notifyListeners();
  }

  bool _isGameEnded = false;
  bool get isGameEnded => _isGameEnded;

  void setIsGameEnded(bool value) {
    _isGameEnded = value;
    if (value == true) {
      _countDownController.pause();
      _duration = const Duration();
      _timer?.cancel();
    }
    notifyListeners();
  }

  late PageController _pageController = PageController();
  PageController get pageController => _pageController;

  void setPageController(PageController value) {
    _pageController = value;
    notifyListeners();
  }

  /// ======== COUNT DOWN =========
  // Duration _cdDuration = Duration(seconds: 6);
  // Timer? _cdTimer;

  // Duration get cdDuration => _cdDuration;
  // Timer get cdTimer => _cdTimer!;

  bool _shouldPauseCountDownAnimation = false;
  bool get shouldPauseCountDownAnimation => _shouldPauseCountDownAnimation;

  void setShouldPauseCountDownAnimation(bool value) {
    _shouldPauseCountDownAnimation = value;
    notifyListeners();
  }

  final Duration _countdownDuration = const Duration();
  Duration get countdownDuration => _countdownDuration;

  // final CountDownController _countDownControllerStart = CountDownController();
  // CountDownController get countDownControllerStart => _countDownControllerStart;

  final CountDownController _countDownController = CountDownController();
  CountDownController get countDownController => _countDownController;

  // Timer? _cdTimer;
  // Timer get cdTimer => _cdTimer!;

  Duration _duration = const Duration();
  Duration get duration => _duration;

  Timer? _timer;
  Timer get timer => _timer!;

  // bool get isPaused => _isPaused;

  // TimerProvider() {
  //   startTimer();
  // }

  // void addTickCountDown() {
  //   if (!_isGamePaused) {
  //     const int addSeconds = 1;
  //     final int seconds = _cdDuration.inSeconds - addSeconds;
  //     _cdDuration = Duration(seconds: seconds);
  //     notifyListeners();
  //   }
  // }

  void addTick() {
    if (!_isGamePaused) {
      const int addSeconds = 1;
      final int seconds = _duration.inSeconds + addSeconds;
      _duration = Duration(seconds: seconds);
      notifyListeners();
    }
  }

  // void addCdTick() {
  //   if (!_isGamePaused) {
  //     const int addSeconds = 1;
  //     final int seconds = _countdownDuration.inSeconds + addSeconds;
  //     _countdownDuration = Duration(seconds: seconds);
  //     notifyListeners();
  //   }
  // }

  // void restartCountDown() {
  //   _countdownDuration = const Duration();
  //   notifyListeners();
  // }

  void stopTimer() {
    _timer?.cancel();
    // _cdTimer?.cancel();
  }

  // void restartGame() {
  //   _timer?.cancel();
  //   _isGamePaused = true;
  //   _isGameStarted = false;
  //   _duration = Duration();
  //   _pageController.jumpToPage(0);

  //   notifyListeners();

  // }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => addTick());

    // _cdTimer?.cancel();
    // _cdTimer = Timer.periodic(Duration(seconds: 1), (_) => addCdTick());
    // countDownController.reset();
    // countDownController.start();

    // _cdTimer?.cancel();
    // _cdTimer = Timer.periodic(Duration(seconds: 1), (_) => addTickCountDown());
  }

  void resetTimer() {
    _duration = const Duration(); // Resetting the duration to 0
    // _cdDuration = const Duration(seconds: 6);
    notifyListeners();
  }

  // void resetCountDown() {
  //   _cdDuration = const Duration(seconds: 6);
  // }

  void pauseTimer() {
    _isGamePaused = true;
  }

  void resumeTimer() {
    _isGamePaused = false;
  }

  void endGame() {
    // _countDownController.pause();
    _currentLevel = 1;
    _previousLevel = 1;
    _isGameEnded = false;
    _isGamePaused = true;
    _isGameStarted = false;
    _gameSummaryLog = [];
    _summaryData = {};
    _visualTileState = initialBoardState; //[]; //startingTileState;
    _previousScore = 0;
    _currentScore = 0;
    _turnScore = 0;
    _turnWords = 0;
    _activeStreak = 0;
    _currentTurn = 0;
    _pressedTile = "1_1";
    _alphabetState = []; //startingAlphabetState;
    _randomLetterList = ["", "", ""];
    _reserveTiles = [
      {"id": 0, "body": ""},
      {"id": 1, "body": ""},
      {"id": 2, "body": ""},
      {"id": 3, "body": ""},
      {"id": 4, "body": ""},
    ];

    _timer?.cancel();

    _duration = const Duration();

    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }
}
