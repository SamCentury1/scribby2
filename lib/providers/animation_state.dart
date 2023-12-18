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
  bool get shouldRunLanguageSelectedAnimation => _shouldRunLanguageSelectedAnimation;

  void setShouldRunLanguageSelectedAnimation(bool value) {
    _shouldRunLanguageSelectedAnimation = value;
    notifyListeners();
  }  

  bool _shouldRunLanguageUnSelectedAnimation = false;
  bool get shouldRunLanguageUnSelectedAnimation => _shouldRunLanguageUnSelectedAnimation;

  void setShouldRunLanguageUnSelectedAnimation(bool value) {
    _shouldRunLanguageUnSelectedAnimation = value;
    notifyListeners();
  }    

  // bool _shouldPauseCountDownAnimation = false;
  // bool get shouldPauseCountDownAnimation => _shouldPauseCountDownAnimation;

  // void setShouldPauseCountDownAnimation(bool value) {
  //   _shouldPauseCountDownAnimation = value;
  //   notifyListeners();
  // }



}



