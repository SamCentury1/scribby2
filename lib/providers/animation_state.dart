
import 'package:flutter/material.dart';

class AnimationState extends ChangeNotifier {
  
  late bool _shouldRunGameStartedAnimation = false;
  bool get shouldRunGameStartedAnimation => _shouldRunGameStartedAnimation;
  void setShouldRunGameStartedAnimation(bool value) {
    _shouldRunGameStartedAnimation = value;
    notifyListeners();
  }  

  // late bool _shouldRunGameOverAnimation = false;
  // bool get shouldRunGameOverAnimation => _shouldRunGameOverAnimation;
  // void setShouldRunGameOverAnimation(bool value) {
  //   _shouldRunGameOverAnimation = value;
  //   notifyListeners();
  // }


  late bool _shouldRunWordFoundAnimation = false;
  bool get shouldRunWordFoundAnimation => _shouldRunWordFoundAnimation;
  void setShouldRunWordFoundAnimation(bool value) {
    _shouldRunWordFoundAnimation = value;
    notifyListeners();
  }

  // late bool _shouldTileEnterAnimation = false;
  // bool get shouldTileEnterAnimation => _shouldTileEnterAnimation;
  // void setShouldTileEnterAnimation(bool value) {
  //   _shouldTileEnterAnimation = value;
  //   notifyListeners();
  // }  


  late bool _shouldRunTileTappedAnimation = false;
  bool get shouldRunTileTappedAnimation => _shouldRunTileTappedAnimation;
  void setShouldRunTileTappedAnimation(bool value) {
    _shouldRunTileTappedAnimation = value;
    notifyListeners();
  }

  late bool _shouldRunTileDroppedAnimation = false;
  bool get shouldRunTileDroppedAnimation => _shouldRunTileDroppedAnimation;
  void setShouldRunTileDroppedAnimation(bool value) {
    _shouldRunTileDroppedAnimation = value;
    notifyListeners();
  }  

  // late bool _shouldRunTestAnimation = false;
  // bool get shouldRunTestAnimation => _shouldRunTestAnimation;
  // void setShouldRunTestAnimation(bool value) {
  //   _shouldRunTestAnimation = value;
  //   notifyListeners();
  // }

  late bool _shouldRunTimerAnimation = false;
  bool get shouldRunTimerAnimation => _shouldRunTimerAnimation;
  void setShouldRunTimerAnimation(bool value) {
    _shouldRunTimerAnimation = value;
    notifyListeners();
  }  

  late bool _shouldRunKillTileAnimation = false;
  bool get shouldRunKillTileAnimation => _shouldRunKillTileAnimation;
  void setShouldRunKillTileAnimation(bool value) {
    _shouldRunKillTileAnimation = value;
    notifyListeners();
  }   

  late bool _shouldRunClockAnimation = false;
  bool get shouldRunClockAnimation => _shouldRunClockAnimation;
  void setShouldRunClockAnimation(bool value) {
    _shouldRunClockAnimation = value;
    notifyListeners();
  }     

  late bool _shouldRunStreakInAnimation = false;
  bool get shouldRunStreakInAnimation => _shouldRunStreakInAnimation;
  void setShouldRunStreakInAnimation(bool value) {
    _shouldRunStreakInAnimation = value;
    notifyListeners();
  }       

  late bool _shouldRunStreakOutAnimation = false;
  bool get shouldRunStreakOutAnimation => _shouldRunStreakOutAnimation;
  void setShouldRunStreakOutAnimation(bool value) {
    _shouldRunStreakOutAnimation = value;
    notifyListeners();
  }

  late bool _shouldRunLevelUpAnimation = false;
  bool get shouldRunLevelUpAnimation => _shouldRunLevelUpAnimation;
  void setShouldRunLevelUpAnimation(bool value) {
    _shouldRunLevelUpAnimation = value;
    notifyListeners();
  }

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

  late bool _shouldRunGameEndedAnimation = false;
  bool get shouldRunGameEndedAnimation => _shouldRunGameEndedAnimation;
  void setShouldRunGameEndedAnimation(bool value) {
    _shouldRunGameEndedAnimation = value;
    notifyListeners();
  }  

  late bool _shouldShowGameOverScreenOverlay = false;
  bool get shouldShowGameOverScreenOverlay => _shouldShowGameOverScreenOverlay;
  void setShouldShowGameOverScreenOverlay(bool value) {
    _shouldShowGameOverScreenOverlay = value;
    notifyListeners();
  }    

  late bool _shouldRunScoreBoardPointsCount = false;
  bool get shouldRunScoreBoardPointsCount => _shouldRunScoreBoardPointsCount;
  void setShouldRunScoreBoardPointsCount(bool value) {
    _shouldRunScoreBoardPointsCount = value;
    notifyListeners();
  }    

}