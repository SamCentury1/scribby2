import 'package:flutter/foundation.dart';

class SettingsState with ChangeNotifier {
  // late List<Map<String,dynamic>> _languageDataList = [
  //   {'primary': false, 'selected': false, 'body': "Français" , 'flag':'french', 'url': 'https://cdn-icons-png.flaticon.com/512/197/197560.png'},
  //   {'primary': false, 'selected': false, 'body': "Español" , 'flag':'spanish' , 'url': 'https://cdn-icons-png.flaticon.com/512/197/197593.png'},
  //   {'primary': false, 'selected': false, 'body': "Português" , 'flag':'portuguese' , 'url': 'https://cdn-icons-png.flaticon.com/512/1795/1795606.png'},
  //   {'primary': false, 'selected': false, 'body': "Ελληνικά" , 'flag':'greek' , 'url': 'https://cdn-icons-png.flaticon.com/512/5921/5921998.png'},
  //   {'primary': false, 'selected': false, 'body': "Deutsch" , 'flag':'german' , 'url': 'https://cdn-icons-png.flaticon.com/512/4855/4855806.png'},
  //   {'primary': false, 'selected': false, 'body': "Nederlands" , 'flag':'dutch' , 'url': 'https://cdn-icons-png.flaticon.com/512/197/197441.png'},
  //   {'primary': false, 'selected': false, 'body': "English" , 'flag':'english' , 'url': 'https://cdn-icons-png.flaticon.com/512/197/197374.png'},
  //   {'primary': false, 'selected': false, 'body': "Italiano" , 'flag':'italian' , 'url': 'https://cdn-icons-png.flaticon.com/512/9906/9906483.png'},  
  // ];
  late List<Map<String,dynamic>> _languageDataList = [
    {'primary': false, 'selected': false, 'body': "Français" , 'flag':'french', },
    {'primary': false, 'selected': false, 'body': "Español" , 'flag':'spanish' ,},
    {'primary': false, 'selected': false, 'body': "Português" , 'flag':'portuguese' ,},
    {'primary': false, 'selected': false, 'body': "Ελληνικά" , 'flag':'greek' , },
    {'primary': false, 'selected': false, 'body': "Deutsch" , 'flag':'german' , },
    {'primary': false, 'selected': false, 'body': "Nederlands" , 'flag':'dutch' , },
    {'primary': false, 'selected': false, 'body': "English" , 'flag':'english' , },
    {'primary': false, 'selected': false, 'body': "Italiano" , 'flag':'italian' , },  
  ];


  List<Map<String,dynamic>> get languageDataList => _languageDataList; 

  void setLanguageDataList(List<Map<String,dynamic>> value) {
    _languageDataList = value;
    notifyListeners();
  }


  late List<String> _selectedLanguagesList = [];
  List<String> get selectedLanguagesList => _selectedLanguagesList;

  void setSelectedLanguagesList(List<String> value) {
    _selectedLanguagesList = value;
    notifyListeners();
  }


  late String _currentLanguageSelection = "";
  String get currentLanguageSelection => _currentLanguageSelection;

  void setCurrentLanguageSelection(String value) {
    _currentLanguageSelection = value;
    notifyListeners();
  } 

  Map<String, dynamic> _userData = {};
  Map<String, dynamic> get userData => _userData;
  void updateUserData(Map<String, dynamic> newData) {
    _userData = newData;
    notifyListeners();
  }




  List<Map<dynamic, dynamic>> _translations = [];
  List<Map<dynamic, dynamic>> get translations => _translations;
  void setTranslations(List<Map<dynamic, dynamic>> value) {
    _translations = value;
    notifyListeners();
  }  


  late List<dynamic> _alphabetCopy = [];
  List<dynamic> get alphabetCopy => _alphabetCopy;

  void setAlphabetCopy(List<dynamic> value) {
    _alphabetCopy = value;
    notifyListeners();
  }


  double _sizeFactor = 1.0; 
  double get sizeFactor => _sizeFactor;

  void setSizeFactor(double value) {
    _sizeFactor = value;
    notifyListeners();
  }

  late Map<String,dynamic> _screenSizeData = {"width" : 0.0, "height" : 0.0};
  Map<String,dynamic> get screenSizeData => _screenSizeData;
  void setScreenSizeData(Map<String,dynamic> value) {
    _screenSizeData = value;
    notifyListeners();
  }  

  late Map<String,dynamic> _demoStates = {
    "demoBoardState1": [
      {"tileId": "0_0", "row": 0, "column": 0, "letter": "letter_01", "active": false},
      {"tileId": "0_1", "row": 0, "column": 1, "letter": "letter_02", "active": false},
      {"tileId": "1_1", "row": 1, "column": 1, "letter": "", "active": false},
      {"tileId": "1_2", "row": 1, "column": 2, "letter": "", "active": false},
      {"tileId": "1_3", "row": 1, "column": 3, "letter": "", "active": false},
      {"tileId": "2_1", "row": 2, "column": 1, "letter": "", "active": false},
      {"tileId": "2_2", "row": 2, "column": 2, "letter": "", "active": false},
      {"tileId": "2_3", "row": 2, "column": 3, "letter": "", "active": false},
      {"tileId": "3_1", "row": 3, "column": 1, "letter": "", "active": false},
      {"tileId": "3_2", "row": 3, "column": 2, "letter": "", "active": false},
      {"tileId": "3_3", "row": 3, "column": 3, "letter": "", "active": false}       
    ],
    "demoBoardState2": [
      {"tileId": "0_0", "row": 0, "column": 0, "letter": "letter_02", "active": false},
      {"tileId": "0_1", "row": 0, "column": 1, "letter": "letter_03", "active": false},
      {"tileId": "1_1", "row": 1, "column": 1, "letter": "letter_01", "active": false},
      {"tileId": "1_2", "row": 1, "column": 2, "letter": "", "active": false},
      {"tileId": "1_3", "row": 1, "column": 3, "letter": "", "active": false},
      {"tileId": "2_1", "row": 2, "column": 1, "letter": "", "active": false},
      {"tileId": "2_2", "row": 2, "column": 2, "letter": "", "active": false},
      {"tileId": "2_3", "row": 2, "column": 3, "letter": "", "active": false},
      {"tileId": "3_1", "row": 3, "column": 1, "letter": "", "active": false},
      {"tileId": "3_2", "row": 3, "column": 2, "letter": "", "active": false},
      {"tileId": "3_3", "row": 3, "column": 3, "letter": "", "active": false}
    ],
    "demoBoardState3": [
      {"tileId": "0_0", "row": 0, "column": 0, "letter": "letter_03", "active": false},
      {"tileId": "0_1", "row": 0, "column": 1, "letter": "letter_04", "active": false},
      {"tileId": "1_1", "row": 1, "column": 1, "letter": "letter_01", "active": false},
      {"tileId": "1_2", "row": 1, "column": 2, "letter": "", "active": false},
      {"tileId": "1_3", "row": 1, "column": 3, "letter": "letter_02", "active": false},
      {"tileId": "2_1", "row": 2, "column": 1, "letter": "", "active": false},
      {"tileId": "2_2", "row": 2, "column": 2, "letter": "", "active": false},
      {"tileId": "2_3", "row": 2, "column": 3, "letter": "", "active": false},
      {"tileId": "3_1", "row": 3, "column": 1, "letter": "", "active": false},
      {"tileId": "3_2", "row": 3, "column": 2, "letter": "", "active": false},
      {"tileId": "3_3", "row": 3, "column": 3, "letter": "", "active": false}
    ],
    "demoBoardState4": [
      {"tileId": "0_0", "row": 0, "column": 0, "letter": "letter_04", "active": false},
      {"tileId": "0_1", "row": 0, "column": 1, "letter": "letter_05", "active": false},
      {"tileId": "1_1", "row": 1, "column": 1, "letter": "letter_01", "active": false},
      {"tileId": "1_2", "row": 1, "column": 2, "letter": "", "active": false},
      {"tileId": "1_3", "row": 1, "column": 3, "letter": "letter_02", "active": false},
      {"tileId": "2_1", "row": 2, "column": 1, "letter": "", "active": false},
      {"tileId": "2_2", "row": 2, "column": 2, "letter": "", "active": false},
      {"tileId": "2_3", "row": 2, "column": 3, "letter": "letter_03", "active": false},
      {"tileId": "3_1", "row": 3, "column": 1, "letter": "", "active": false},
      {"tileId": "3_2", "row": 3, "column": 2, "letter": "", "active": false},
      {"tileId": "3_3", "row": 3, "column": 3, "letter": "", "active": false}
    ],
    "demoBoardState5": [
      {"tileId": "0_0", "row": 0, "column": 0, "letter": "letter_05", "active": false},
      {"tileId": "0_1", "row": 0, "column": 1, "letter": "letter_06", "active": false},
      {"tileId": "1_1", "row": 1, "column": 1, "letter": "letter_01", "active": true},
      {"tileId": "1_2", "row": 1, "column": 2, "letter": "letter_04", "active": true},
      {"tileId": "1_3", "row": 1, "column": 3, "letter": "letter_02", "active": true},
      {"tileId": "2_1", "row": 2, "column": 1, "letter": "", "active": false},
      {"tileId": "2_2", "row": 2, "column": 2, "letter": "", "active": false},
      {"tileId": "2_3", "row": 2, "column": 3, "letter": "letter_03", "active": false},
      {"tileId": "3_1", "row": 3, "column": 1, "letter": "", "active": false},
      {"tileId": "3_2", "row": 3, "column": 2, "letter": "", "active": false},
      {"tileId": "3_3", "row": 3, "column": 3, "letter": "", "active": false}
    ],
    "demoBoardState6": [
      {"tileId": "0_0", "row": 0, "column": 0, "letter": "letter_05", "active": false},
      {"tileId": "0_1", "row": 0, "column": 1, "letter": "letter_06", "active": false},
      {"tileId": "1_1", "row": 1, "column": 1, "letter": "", "active": false},
      {"tileId": "1_2", "row": 1, "column": 2, "letter": "", "active": false},
      {"tileId": "1_3", "row": 1, "column": 3, "letter": "", "active": false},
      {"tileId": "2_1", "row": 2, "column": 1, "letter": "", "active": false},
      {"tileId": "2_2", "row": 2, "column": 2, "letter": "", "active": false},
      {"tileId": "2_3", "row": 2, "column": 3, "letter": "letter_03", "active": false},
      {"tileId": "3_1", "row": 3, "column": 1, "letter": "", "active": false},
      {"tileId": "3_2", "row": 3, "column": 2, "letter": "", "active": false},
      {"tileId": "3_3", "row": 3, "column": 3, "letter": "", "active": false}
    ],
                
  };
  Map<String,dynamic> get demoStates => _demoStates;


  Map<dynamic, dynamic> _demoLetters = {
    "english": {
        "letter_01" : "A",
        "letter_02" : "K",
        "letter_03" : "U",
        "letter_04" : "S",
        "letter_05" : "E",
        "letter_06" : "N",
        "WORD" : "ASK"
      },
    
      "french": {
        "letter_01" : "E",
        "letter_02" : "U",
        "letter_03" : "V",
        "letter_04" : "A",
        "letter_05" : "R",
        "letter_06" : "S",
        "WORD" : "EAU"
      },  
    
      "spanish": {
        "letter_01" : "G",
        "letter_02" : "L",
        "letter_03" : "S",
        "letter_04" : "O",
        "letter_05" : "B",
        "letter_06" : "T",
        "WORD" : "GOL"
      },  
    
      "german": {
        "letter_01" : "I",
        "letter_02" : "H",
        "letter_03" : "T",
        "letter_04" : "C",
        "letter_05" : "W",
        "letter_06" : "R",
        "WORD" : "ICH"
      },  
    
      "italian": {
        "letter_01" : "O",
        "letter_02" : "A",
        "letter_03" : "Z",
        "letter_04" : "R",
        "letter_05" : "I",
        "letter_06" : "B",
        "WORD" : "ORA"
      },  
    
      "portuguese": {
        "letter_01" : "B",
        "letter_02" : "M",
        "letter_03" : "L",
        "letter_04" : "O",
        "letter_05" : "J",
        "letter_06" : "A",
        "WORD" : "BOM"
      },  
    
      "greek": {
        "letter_01" : "Ε",
        "letter_02" : "Ρ",
        "letter_03" : "Ζ",
        "letter_04" : "Α",
        "letter_05" : "Τ",
        "letter_06" : "Π",
        "WORD" : "ΕΑΡ"
      }, 
    
      "dutch": {
        "letter_01" : "S",
        "letter_02" : "T",
        "letter_03" : "H",
        "letter_04" : "E",
        "letter_05" : "X",
        "letter_06" : "G",
        "WORD" : "SET"
      }
  }  ;
  Map<dynamic, dynamic> get demoLetters => _demoLetters;


  late bool _isPlayingOffline = false;
  bool get isPlayingOffline => _isPlayingOffline;
  void setIsPlayingOffline(bool value) {
    _isPlayingOffline = value;
    notifyListeners();
  }


  // void setDemoLetters(Map<dynamic, dynamic> value) {
  //   _demoLetters = value;
  //   notifyListeners();
  // }    


  // void setDemoBoardStates(Map<String,dynamic> value) {
  //   _demoBoardStates = value;
  //   notifyListeners();
  // }    
}