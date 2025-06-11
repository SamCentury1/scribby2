import 'package:flutter/material.dart';

class GamePlayState extends ChangeNotifier {

  late Map<String,dynamic> _elementSizes = {};
  Map<String,dynamic> get elementSizes => _elementSizes;
  void setElementSizes(Map<String,dynamic> value) {
    _elementSizes = value;
    notifyListeners();
  }
  
}