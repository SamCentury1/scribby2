import 'package:flutter/foundation.dart';

class SettingsState with ChangeNotifier {
  late List<Map<String,dynamic>> _languageDataList = [
    {'primary': false, 'selected': false, 'body': "Français" , 'flag':'french', 'url': 'https://cdn-icons-png.flaticon.com/512/197/197560.png'},
    {'primary': false, 'selected': false, 'body': "Español" , 'flag':'spanish' , 'url': 'https://cdn-icons-png.flaticon.com/512/197/197593.png'},
    {'primary': false, 'selected': false, 'body': "Português" , 'flag':'portuguese' , 'url': 'https://cdn-icons-png.flaticon.com/512/1795/1795606.png'},
    {'primary': false, 'selected': false, 'body': "Ελληνικά" , 'flag':'greek' , 'url': 'https://cdn-icons-png.flaticon.com/512/5921/5921998.png'},
    {'primary': false, 'selected': false, 'body': "Deutsch" , 'flag':'german' , 'url': 'https://cdn-icons-png.flaticon.com/512/4855/4855806.png'},
    {'primary': false, 'selected': false, 'body': "Nederlands" , 'flag':'dutch' , 'url': 'https://cdn-icons-png.flaticon.com/512/197/197441.png'},
    {'primary': false, 'selected': false, 'body': "English" , 'flag':'english' , 'url': 'https://cdn-icons-png.flaticon.com/512/197/197374.png'},
    {'primary': false, 'selected': false, 'body': "Italiano" , 'flag':'italian' , 'url': 'https://cdn-icons-png.flaticon.com/512/9906/9906483.png'},  
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
}