import 'package:flutter/material.dart';

class AnimationState with ChangeNotifier {
  bool _shouldRunAnimation = false;

  bool get shouldRunAnimation => _shouldRunAnimation;

  void setShouldRunAnimation(bool value) {
    _shouldRunAnimation = value;
    notifyListeners();
  }

  bool _shouldRunWordAnimation = false;

  bool get shouldRunWordAnimation => _shouldRunWordAnimation;

  void setShouldRunWordAnimation(bool value) {
    _shouldRunWordAnimation = value;
    notifyListeners();
  }

  bool _shouldRunMultiWordAnimation = false;

  bool get shouldRunMultiWordAnimation => _shouldRunMultiWordAnimation;

  void setShouldRunMultiWordAnimation(bool value) {
    _shouldRunMultiWordAnimation = value;
    notifyListeners();
  }

  bool _shouldRunCrossWordAnimation = false;

  bool get shouldRunCrossWordAnimation => _shouldRunCrossWordAnimation;

  void setShouldRunCrossWordAnimation(bool value) {
    _shouldRunCrossWordAnimation = value;
    notifyListeners();
  }

  bool _shouldRunPointsAnimation = false;

  bool get shouldRunPointsAnimation => _shouldRunPointsAnimation;

  void setShouldRunPointsAnimation(bool value) {
    _shouldRunPointsAnimation = value;
    notifyListeners();
  }

  bool _shouldRunStreaksEnterAnimation = false;

  bool get shouldRunStreaksEnterAnimation => _shouldRunStreaksEnterAnimation;

  void setShouldRunStreaksEnterAnimation(bool value) {
    _shouldRunStreaksEnterAnimation = value;
    notifyListeners();
  }

  bool _shouldRunStreaksExitAnimation = false;

  bool get shouldRunStreaksExitAnimation => _shouldRunStreaksExitAnimation;

  void setShouldRunStreaksExitAnimation(bool value) {
    _shouldRunStreaksExitAnimation = value;
    notifyListeners();
  }

  /// FOR THE MODAL TO APPEAR OR DISAPPEAR WHEN PRESSING PAUSE OR CLICKING THE BLUR AROUND THE MODAL
  bool _shouldRunPauseAnimation = false;
  bool get shouldRunPauseAnimation => _shouldRunPauseAnimation;

  void setShouldRunPauseAnimation(bool value) {
    _shouldRunPauseAnimation = value;
    notifyListeners();
  }

  bool _shouldRunPlayAnimation = false;
  bool get shouldRunPlayAnimation => _shouldRunPlayAnimation;

  void setShouldRunPlayAnimation(bool value) {
    _shouldRunPlayAnimation = value;
    notifyListeners();
  }

  bool _shouldRunTimerAnimation = false;
  bool get shouldRunTimerAnimation => _shouldRunTimerAnimation;

  void setShouldRunTimerAnimation(bool value) {
    _shouldRunTimerAnimation = value;
    notifyListeners();
  }

  bool _shouldRunLanguageSelectedAnimation = false;
  bool get shouldRunLanguageSelectedAnimation =>
      _shouldRunLanguageSelectedAnimation;

  void setShouldRunLanguageSelectedAnimation(bool value) {
    _shouldRunLanguageSelectedAnimation = value;
    notifyListeners();
  }

  bool _shouldRunLanguageUnSelectedAnimation = false;
  bool get shouldRunLanguageUnSelectedAnimation =>
      _shouldRunLanguageUnSelectedAnimation;

  void setShouldRunLanguageUnSelectedAnimation(bool value) {
    _shouldRunLanguageUnSelectedAnimation = value;
    notifyListeners();
  }

  bool _shouldRunNewLevelAnimation = false;
  bool get shouldRunNewLevelAnimation => _shouldRunNewLevelAnimation;

  void setShouldRunNewLevelAnimation(bool value) {
    _shouldRunNewLevelAnimation = value;
    notifyListeners();
  }

  // bool _shouldPauseCountDownAnimation = false;
  // bool get shouldPauseCountDownAnimation => _shouldPauseCountDownAnimation;

  // void setShouldPauseCountDownAnimation(bool value) {
  //   _shouldPauseCountDownAnimation = value;
  //   notifyListeners();
  // }

  /// =================================================================
  ///                          TUTORIAL
  /// =================================================================

  bool _shouldRunTutorialTimerdAnimation = false;
  bool get shouldRunTutorialTimerdAnimation =>
      _shouldRunTutorialTimerdAnimation;

  void setShouldRunTutorialTimerdAnimation(bool value) {
    _shouldRunTutorialTimerdAnimation = value;
    notifyListeners();
  }

  bool _shouldRunTutorialScoreboardAnimation = false;
  bool get shouldRunTutorialScoreboardAnimation =>
      _shouldRunTutorialScoreboardAnimation;

  void setShouldRunTutorialScoreboardAnimation(bool value) {
    _shouldRunTutorialScoreboardAnimation = value;
    notifyListeners();
  }


  /// STREAK
  bool _shouldRunTutorialStreakEnterAnimation = false;
  bool get shouldRunTutorialStreakEnterAnimation =>
      _shouldRunTutorialStreakEnterAnimation;

  void setShouldRunTutorialStreakEnterAnimation(bool value) {
    _shouldRunTutorialStreakEnterAnimation = value;
    notifyListeners();
  }  

  bool _shouldRunTutorialStreakExitAnimation = false;
  bool get shouldRunTutorialStreakExitAnimation =>
      _shouldRunTutorialStreakExitAnimation;

  void setShouldRunTutorialStreakExitAnimation(bool value) {
    _shouldRunTutorialStreakExitAnimation = value;
    notifyListeners();
  } 


  /// MULTI WORD
  bool _shouldRunTutorialMultiWordEnterAnimation = false;
  bool get shouldRunTutorialMultiWordEnterAnimation =>
      _shouldRunTutorialMultiWordEnterAnimation;

  void setShouldRunTutorialMultiWordEnterAnimation(bool value) {
    _shouldRunTutorialMultiWordEnterAnimation = value;
    notifyListeners();
  }  

  bool _shouldRunTutorialMultiWordExitAnimation = false;
  bool get shouldRunTutorialMultiWordExitAnimation =>
      _shouldRunTutorialMultiWordExitAnimation;

  void setShouldRunTutorialMultiWordExitAnimation(bool value) {
    _shouldRunTutorialMultiWordExitAnimation = value;
    notifyListeners();
  } 

  /// CROSS WORD
  bool _shouldRunTutorialCrosswordEnterAnimation = false;
  bool get shouldRunTutorialCrosswordEnterAnimation =>
      _shouldRunTutorialCrosswordEnterAnimation;

  void setShouldRunTutorialCrosswordEnterAnimation(bool value) {
    _shouldRunTutorialCrosswordEnterAnimation = value;
    notifyListeners();
  }  

  bool _shouldRunTutorialCrosswordExitAnimation = false;
  bool get shouldRunTutorialCrosswordExitAnimation =>
      _shouldRunTutorialCrosswordExitAnimation;

  void setShouldRunTutorialCrosswordExitAnimation(bool value) {
    _shouldRunTutorialCrosswordExitAnimation = value;
    notifyListeners();
  }


  bool _shouldRunTutorialNextStepAnimation = false;
  bool get shouldRunTutorialNextStepAnimation =>
      _shouldRunTutorialNextStepAnimation;

  void setShouldRunTutorialNextStepAnimation(bool value) {
    _shouldRunTutorialNextStepAnimation = value;
    notifyListeners();
  }  

  bool _shouldRunTutorialPreviousStepAnimation = false;
  bool get shouldRunTutorialPreviousStepAnimation =>
      _shouldRunTutorialPreviousStepAnimation;

  void setShouldRunTutorialPreviousStepAnimation(bool value) {
    _shouldRunTutorialPreviousStepAnimation = value;
    notifyListeners();
  }    


  bool _shouldRunTilePressedAnimation = false;
  bool get shouldRunTilePressedAnimation =>
      _shouldRunTilePressedAnimation;

  void setShouldRunTilePressedAnimation(bool value) {
    _shouldRunTilePressedAnimation = value;
    notifyListeners();
  }



  /// ==========================================
  ///  =========== GAME OVER ======================
  /// ==========================================

  bool _shouldRunGameOverPointsCounting = false;
  bool get shouldRunGameOverPointsCounting => _shouldRunGameOverPointsCounting;

  void setShouldRunGameOverPointsCounting(bool value) {
    _shouldRunGameOverPointsCounting = value;
    notifyListeners();
  }

  bool _shouldRunGameOverPointsFinishedCounting = false;
  bool get shouldRunGameOverPointsFinishedCounting => _shouldRunGameOverPointsFinishedCounting;

  void setShouldRunGameOverPointsFinishedCounting(bool value) {
    _shouldRunGameOverPointsFinishedCounting = value;
    notifyListeners();
  }    


  bool _shouldRunNewHighScore = false;
  bool get shouldRunNewHighScore => _shouldRunNewHighScore;

  void setShouldRunNewHighScore(bool value) {
    _shouldRunNewHighScore = value;
    notifyListeners();
  }      


}
