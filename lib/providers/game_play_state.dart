import 'dart:async';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
// import 'package:scribby_flutter_v2/utils/states.dart';

class GamePlayState with ChangeNotifier {

  late bool _isGameOver = false;
  bool get isGameOver => _isGameOver;
  void setIsGameOver(bool value) {
    _isGameOver = value;
    if (value == true) {
      _countDownController.pause();
      _duration = const Duration();
      _timer?.cancel();
    }
    notifyListeners();
  }

  late bool _didUserQuitGame = false;
  bool get didUserQuitGame => _didUserQuitGame;
  void setDidUserQuitGame(bool value) {
    _didUserQuitGame = value;
    if (value == true) {
      _countDownController.pause();
      _duration = const Duration();
      _timer?.cancel();
    }
    notifyListeners();
  }


  late bool _isGamePaused = false;
  bool get isGamePaused => _isGamePaused;
  void setIsGamePaused(bool value) {
    if (value == true) {
      _countDownController.pause();
      _selectedTileIndex = -1;
      _selectedReserveIndex = -1;
      _draggedReserveTile = {};
    } else if (value == false) {
      _countDownController.resume();
    }
    _isGamePaused = value;
    notifyListeners();
  }  

  late String _pauseScreen = 'summary';
  String get pauseScreen => _pauseScreen;
  void setPauseScreen(String value) {
    _pauseScreen = value;
    notifyListeners();
  }  
  // provides a log of turns.
  // ex: [{turn: 1, ...data...}, {turn: 2, ...data...},]
  // List<Map<String, dynamic>> _gameSummaryLog = [];
  // List<Map<String, dynamic>> get gameSummaryLog => _gameSummaryLog;

  // void setGameSummaryLog(List<Map<String, dynamic>> value) {
  //   _gameSummaryLog = value;
  //   notifyListeners();
  // }

  // provides a snapshot of the current state of the game at a given point in time
  // ex: {turns: 12, words: ['hello','world'], longestStreak:0, ...}
  // Map<String, dynamic> _summaryData = {};
  // Map<String, dynamic> get summaryData => _summaryData;

  // void setSummaryData(Map<String, dynamic> value) {
  //   _summaryData = value;
  //   notifyListeners();
  // }

  // provides a snapshot of the current state of the game at a given point in time
  // ex: {turns: 12, words: ['hello','world'], longestStreak:0, ...}
  Map<String, dynamic> _endOfGameData = {};
  Map<String, dynamic> get endOfGameData => _endOfGameData;

  void setEndOfGameData(Map<String, dynamic> value) {
    _endOfGameData = value;
    notifyListeners();
  }

  List<dynamic> _tileState = []; // startingTileState;
  List<dynamic> get tileState => _tileState;

  void setTileState(List<dynamic> value) {
    _tileState = value;
    notifyListeners();
  }  

  late bool _didShowStartAnimation = false;
  bool get didShowStartAnimation => _didShowStartAnimation;
  void setDidShowStartAnimation(bool value) {
    _didShowStartAnimation = value;
    notifyListeners();
  }

  // provides a VISUAL representation of the board. Meaning that it shows the letters that
  // were in a word temporarily while the animation plays
  // List<Map<String, dynamic>> _visualTileState = []; // startingTileState;
  // List<Map<String, dynamic>> get visualTileState => _visualTileState;

  // void setVisualTileState(List<Map<String, dynamic>> value) {
  //   _visualTileState = value;
  //   notifyListeners();
  // }

  // // provides a LOGICAL representation of the board. Meaning that it returns
  // // the board without the letters that were found in a word
  // List<Map<String, dynamic>> _logicalTileState = [];
  // List<Map<String, dynamic>> get logicalTileState => _logicalTileState;

  // void setLogicalTileState(List<Map<String, dynamic>> value) {
  //   _logicalTileState = value;
  //   notifyListeners();
  // }

  /// for the points animation
  // int _previousScore = 0;
  // int get previousScore => _previousScore;

  // void setPreviousScore(int value) {
  //   _previousScore = value;
  //   notifyListeners();
  // }

  // int _currentScore = 0;
  // int get currentScore => _currentScore;

  // void setCurrentScore(int value) {
  //   _currentScore = value;
  //   notifyListeners();
  // }

  // int _turnScore = 0;
  // int get turnScore => _turnScore;

  // void setTurnScore(int value) {
  //   _turnScore = value;
  //   notifyListeners();
  // }

  // int _turnWords = 0;
  // int get turnWords => _turnWords;

  // void setTurnWords(int value) {
  //   _turnWords = value;
  //   notifyListeners();
  // }

  // int _activeStreak = 0;
  // int get activeStreak => _activeStreak;

  // void setActiveStreak(int value) {
  //   _activeStreak = value;
  //   notifyListeners();
  // }

  // int _currentTurn = 0;
  // int get currentTurn => _currentTurn;

  // void setCurrentTurn(int value) {
  //   _currentTurn = value;
  //   notifyListeners();
  // }

  // bool _isWordAnimating = false;
  // bool get isWordAnimating => _isWordAnimating;

  // void setIsWordAnimating(bool value) {
  //   _isWordAnimating = value;
  //   notifyListeners();
  // }



  // bool _displayLevelChange = false;
  // bool get displayLevelChange => _displayLevelChange;

  // void setDisplayLevelChange(bool value) {
  //   _displayLevelChange = value;
  //   notifyListeners();
  // }

  List<Map<String,dynamic>> _scoringLog = [
    {
      "turn": 0,
      "points": 0,
      "cumulativePoints" : 0,
      "words": 0,
      "wordValues": [],
      "cumulativeWords" : 0,
      "streak" : 0,
      "crossWord": 0,      
    }
  ];
  List<Map<String,dynamic>> get scoringLog => _scoringLog;
  void setScoringLog(List<Map<String,dynamic>> value) {
    _scoringLog = value;
    notifyListeners();
  }


  // String _pressedTile = "";
  // String get pressedTile => _pressedTile;

  // void setPressedTile(String value) {
  //   _pressedTile = value;
  //   notifyListeners();
  // }

  List<Map<String,dynamic>> _validStrings = [];
  List<Map<String,dynamic>> get validStrings => _validStrings;
  void setValidStrings(List<Map<String,dynamic>> value) {
    _validStrings = value;
    notifyListeners();
  }

  List<Map<String,dynamic>> _validIds = [];
  List<Map<String,dynamic>> get validIds => _validIds;
  void setValidIds(List<Map<String,dynamic>> value) {
    _validIds = value;
    notifyListeners();
  }  

  List<Map<String, dynamic>> _reserveTiles = [
    {"id": 0, "body": "", "shade":0, "angle":0},
    {"id": 1, "body": "", "shade":0, "angle":0},
    {"id": 2, "body": "", "shade":0, "angle":0},
    {"id": 3, "body": "", "shade":0, "angle":0},
    {"id": 4, "body": "", "shade":0, "angle":0},
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

  // late Map<String, dynamic> _reserveTileTapped = {};
  // Map<String, dynamic> get reserveTileTapped => _reserveTileTapped;

  // void setReserveTileTapped(Map<String, dynamic> value) {
  //   _reserveTileTapped = value;
  //   notifyListeners();
  // }  

  int _currentLevel = 1;
  int get currentLevel => _currentLevel;

  void setCurrentLevel(int value) {
    _currentLevel = value;
    notifyListeners();
  }

  // int _previousLevel = 1;
  // int get previousLevel => _previousLevel;

  // void setPreviousLevel(int value) {
  //   _previousLevel = value;
  //   notifyListeners();
  // }

  // int _currentIndex = 0;
  // int get currentIndex => _currentIndex;

  // void setCurrentIndex(int value) {
  //   _currentIndex = value;
  //   notifyListeners();
  // }

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

  // a continuous list of randomly generated letters
  List<String> _dictionary = []; // randomLetterListState;
  List<String> get dictionary => _dictionary;

  void setDictionary(List<String> value) {
    _dictionary = value;
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
    // _previousLevel = 1;
    // _isGameEnded = false;
    _didUserQuitGame = false;
    _isGameOver = false;
    _isGamePaused = false;
    _isGameStarted = false;
    // _gameSummaryLog = [];
    // _summaryData = {};
    _scoringLog = [
    {
      "turn": 0,
      "points": 0,
      "cumulativePoints" : 0,
      "words": 0,
      "wordValues": [],
      "cumulativeWords" : 0,
      "streak" : 0,
      "crossWord": 0,      
    }    
    ];
    // _visualTileState = []; //startingTileState;
    _tileState = [];
    // _previousScore = 0;
    // _currentScore = 0;
    // _turnScore = 0;
    // _turnWords = 0;
    // _activeStreak = 0;
    // _currentTurn = 0;
    // _pressedTile = "";
    _alphabetState = []; // startingAlphabetState;
    _randomLetterList = []; // randomLetterListState;
    _reserveTiles = [
      {"id": 0, "body": "", "shade":0, "angle":0},
      {"id": 1, "body": "", "shade":0, "angle":0},
      {"id": 2, "body": "", "shade":0, "angle":0},
      {"id": 3, "body": "", "shade":0, "angle":0},
      {"id": 4, "body": "", "shade":0, "angle":0},
    ];

    _timer?.cancel();
    _duration = const Duration();
    _countDownController.restart(duration: Helpers().getCountdownDuration(1));
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

  // bool _isGamePaused = true;
  // bool get isGamePaused => _isGamePaused;

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

  // void setIsGamePaused(bool value, int page) {
  //   _isGamePaused = value;
  //   if (value != true) {
  //     Future.delayed(const Duration(milliseconds: 300), () {
  //       // if (_pageController.hasClients) {
  //       //   _pageController.jumpToPage(0);
  //       // }
  //       _countDownController.resume();
  //     });
  //   } else {
  //     Future.delayed(const Duration(milliseconds: 0), () {
  //       // if (_pageController.hasClients) {
  //       //   _pageController.jumpToPage(page);
  //       // }
  //       _countDownController.pause();
  //     });
  //   }
  //   notifyListeners();
  // }

  bool _isGameStarted = false;
  bool get isGameStarted => _isGameStarted;

  void setIsGameStarted(bool value) {
    _isGameStarted = value;

    if (value == true) {
      _isGamePaused = false;
      // startTimer();
      _countDownController.restart();
      _endOfGameData = {};
    }

    notifyListeners();
  }
  

  // bool _isGameEnded = false;
  // bool get isGameEnded => _isGameEnded;

  // void setIsGameEnded(bool value) {
  //   _isGameEnded = value;
  //   if (value == true) {
  //     _countDownController.pause();
  //     _duration = const Duration();
  //     _timer?.cancel();
  //   }
  //   notifyListeners();
  // }

  // late PageController _pageController = PageController();
  // PageController get pageController => _pageController;

  // void setPageController(PageController value) {
  //   _pageController = value;
  //   notifyListeners();
  // }

  /// ======== COUNT DOWN =========
  // Duration _cdDuration = Duration(seconds: 6);
  // Timer? _cdTimer;

  // Duration get cdDuration => _cdDuration;
  // Timer get cdTimer => _cdTimer!;

  // late int _isTileTapped = -1;
  // int get isTileTapped => _isTileTapped;

  // void setIsTileTapped(int value) {
  //   _isTileTapped = value;
  //   notifyListeners();
  // }

  int _selectedTileIndex = -1;
  int get selectedTileIndex => _selectedTileIndex;

  void setSelectedTileIndex(int value) {
    _selectedTileIndex = value;
    notifyListeners();
  }

  int _selectedReserveIndex = -1;
  int get selectedReserveIndex => _selectedReserveIndex;

  void setSelectedReserveIndex(int value) {
    _selectedReserveIndex = value;
    notifyListeners();
  } 


  late int _droppedTileIndex = -1;
  int get droppedTileIndex => _droppedTileIndex;
  void setDroppedTileIndex(int value) {
    _droppedTileIndex = value;
    notifyListeners();
  }

   late int _killedTileIndex = -1;
  int get killedTileIndex => _killedTileIndex;
  void setkilledTileIndex(int value) {
    _killedTileIndex = value;
    notifyListeners();
  }     




  // bool _shouldPauseCountDownAnimation = false;
  // bool get shouldPauseCountDownAnimation => _shouldPauseCountDownAnimation;

  // void setShouldPauseCountDownAnimation(bool value) {
  //   _shouldPauseCountDownAnimation = value;
  //   notifyListeners();
  // }

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

  // void stopTimer() {
  //   _timer?.cancel();
  //   // _cdTimer?.cancel();
  // }

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

  // void resetTimer() {
  //   _duration = const Duration(); // Resetting the duration to 0
  //   // _cdDuration = const Duration(seconds: 6);
  //   notifyListeners();
  // }

  // void resetCountDown() {
  //   _cdDuration = const Duration(seconds: 6);
  // }

  // void pauseTimer() {
  //   _isGamePaused = true;
  // }

  // void resumeTimer() {
  //   _isGamePaused = false;
  // }

  void endGame() {
    // _countDownController.pause();
    _currentLevel = 1;
    // _previousLevel = 1;
    // _isGameEnded = false;
    _isGameOver = false;
    _didUserQuitGame = false;
    _isGamePaused = false;
    _isGameStarted = false;
    // _gameSummaryLog = [];
    // _summaryData = {};
    _scoringLog = [
      {
        "points": 0,
        "cumulativePoints" : 0,
        "words": 0,
        "cumulativeWords" : 0,
        "streak" : 0,
        "crossWord": 0,      
      }      
    ];
    // _visualTileState = initialBoardState; //[]; //startingTileState;
    _tileState = [];//initialBoardState;
    // _previousScore = 0;
    // _currentScore = 0;
    // _turnScore = 0;
    // _turnWords = 0;
    // _activeStreak = 0;
    // _currentTurn = 0;
    // _pressedTile = "";
    _alphabetState = []; //startingAlphabetState;
    _randomLetterList = ["", "", ""];
    _reserveTiles = [
      {"id": 0, "body": "", "shade":0, "angle":0},
      {"id": 1, "body": "", "shade":0, "angle":0},
      {"id": 2, "body": "", "shade":0, "angle":0},
      {"id": 3, "body": "", "shade":0, "angle":0},
      {"id": 4, "body": "", "shade":0, "angle":0},
    ];

    _timer?.cancel();

    _duration = const Duration();

    notifyListeners();
  }

  late double _tileSize = 0.0;
  double get tileSize => _tileSize;
  void setTileSize(double value) {
    _tileSize = value;
    notifyListeners();
  }

  late List<Map<String,dynamic>> _decorationData = [];
  List<Map<String,dynamic>> get decorationData => _decorationData;
  void setDecorationData(List<Map<String,dynamic>> value) {
    _decorationData = value;
    notifyListeners();
  }  

  late List<List<dynamic>> _combinations = [];
  List<List<dynamic>> get combinations => _combinations;
  void setCombinations(List<List<dynamic>> value) {
    _combinations = value;
    notifyListeners();
  }  


  // int _adsDisplayed = 0;
  // int get adsDisplayed => _adsDisplayed;

  // void setAdsDisplayed(int value) {
  //   _adsDisplayed = value;
  //   notifyListeners();
  // }

  List<int> _randomShadeList = [];
  List<int> get randomShadeList => _randomShadeList;

  void setRandomShadeList(List<int> value) {
    _randomShadeList = value;
    notifyListeners();
  }

  List<int> _randomAngleList = [];
  List<int> get randomAngleList => _randomAngleList;

  void setRandomAngleList(List<int> value) {
    _randomAngleList = value;
    notifyListeners();
  }  




  @override
  void dispose() {
    _timer?.cancel();
    // _pageController.dispose();
    super.dispose();
  }
// }


}