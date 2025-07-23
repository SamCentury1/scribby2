import 'package:flutter/material.dart';

class TutorialState extends ChangeNotifier {
  


  late bool _isTutorial = false;
  bool get isTutorial => _isTutorial;
  void setIsTutorial(bool value) {
    _isTutorial = value;
    notifyListeners();
  }
  
  late Map<String,dynamic> _tutorialData = {
    "steps":[
      {"step":0, "focusTile": 23, "isStepCompleted":false},
      {"step":1, "focusTile": 2, "isStepCompleted":false},
      {"step":2, "focusTile": 17, "isStepCompleted":false},
      {"step":3, "focusTile": 6, "isStepCompleted":false},
      {"step":4, "focusTile": 11, "isStepCompleted":false},
      {"step":5, "focusTile": 9, "isStepCompleted":false},
    ],
  };
  Map<String,dynamic> get tutorialData => _tutorialData;
  void setTutorialData(Map<String,dynamic> value) {
    _tutorialData = value;
    notifyListeners();
  }  

}