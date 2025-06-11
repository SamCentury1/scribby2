import 'package:flutter/material.dart';

class ColorPalette extends ChangeNotifier {


  late Color _bg1 = Colors.transparent;
  Color get bg1 => _bg1;

  late Color _bg2 = Colors.transparent;
  Color get bg2 => _bg2;

  late Color _dialogBg1 = Colors.transparent;
  Color get dialogBg1 => _dialogBg1;

  late Color _dialogBg2 = Colors.transparent;
  Color get dialogBg2 => _dialogBg2;  

  late Color _text1 = Colors.transparent;
  Color get text1 => _text1;

  late Color _text2 = Colors.transparent;
  Color get text2 => _text2;

  late Color _text3 = Colors.transparent;
  Color get text3 => _text3;

  late Color _text4 = Colors.transparent;
  Color get text4 => _text4;

  late Color _text5 = Colors.transparent;
  Color get text5 => _text5;        

  late Color _widget1 = Colors.transparent;
  Color get widget1 => _widget1;    

  late Color _widget2 = Colors.transparent;
  Color get widget2 => _widget2;   



  void getThemeColors(String themeValue) {
    if (themeValue == "default") {
      _bg1 = const Color.fromARGB(255, 55, 116, 173);
      _bg2 = const Color.fromARGB(255, 38, 9, 92);
      _dialogBg1 = const Color.fromARGB(255, 2, 75, 134);
      _dialogBg2 = const Color.fromARGB(255, 2, 26, 134);
      _text1 = const Color.fromARGB(255, 224, 224, 224);
      _text2 = const Color.fromARGB(255, 209, 209, 209);
      _text3 = const Color.fromARGB(255, 13, 6, 110);
      _text4 = const Color.fromARGB(255, 20, 20, 20);
      _text5 = const Color.fromARGB(255, 44, 44, 44);   
      _widget1 = const Color.fromARGB(255, 13, 6, 110);
      _widget2 = const Color.fromARGB(177, 9, 21, 73);
    } else if (themeValue == "light") {
      _bg1 = const Color.fromARGB(255, 252, 254, 255);
      _bg2 = const Color.fromARGB(255, 104, 233, 250);
      _dialogBg1 = const Color.fromARGB(255, 233, 233, 233);
      _dialogBg2 = const Color.fromARGB(255, 231, 255, 254);      
      _text1 = const Color.fromARGB(255, 10, 10, 10);
      _text2 = const Color.fromARGB(255, 39, 39, 39);
      _text3 = const Color.fromARGB(255, 234, 233, 236);
      _text4 = const Color.fromARGB(255, 255, 255, 255);
      _text5 = const Color.fromARGB(255, 235, 235, 235);   
      _widget1 = const Color.fromARGB(255, 181, 241, 252);
      _widget2 = const Color.fromARGB(255, 255, 252, 252);

    } else if (themeValue == "dark") {
      _bg1 = const Color.fromARGB(255, 37, 37, 37);
      _bg2 = const Color.fromARGB(255, 14, 14, 14);
      _dialogBg1 = const Color.fromARGB(255, 46, 46, 46);
      _dialogBg2 = const Color.fromARGB(255, 58, 58, 58);      
      _text1 = const Color.fromARGB(255, 224, 224, 224);
      _text2 = const Color.fromARGB(255, 209, 209, 209);
      _text3 = const Color.fromARGB(255, 22, 22, 22);
      _text4 = const Color.fromARGB(255, 20, 20, 20);
      _text5 = const Color.fromARGB(255, 44, 44, 44);   
      _widget1 = const Color.fromARGB(255, 56, 56, 56);
      _widget2 = const Color.fromARGB(255, 49, 49, 49);

    } else if (themeValue == "nature") {
      _bg1 = const Color.fromARGB(255, 114, 199, 90);
      _bg2 = const Color.fromARGB(255, 17, 94, 7);
      _dialogBg1 = const Color.fromARGB(255, 74, 128, 38);
      _dialogBg2 = const Color.fromARGB(255, 12, 78, 4);      
      _text1 = const Color.fromARGB(255, 224, 224, 224);
      _text2 = const Color.fromARGB(255, 209, 209, 209);
      _text3 = const Color.fromARGB(255, 1, 49, 1);
      _text4 = const Color.fromARGB(255, 20, 20, 20);
      _text5 = const Color.fromARGB(255, 44, 44, 44);   
      _widget1 = const Color.fromARGB(255, 71, 24, 2);
      _widget2 = const Color.fromARGB(255, 165, 116, 84);

    } else if (themeValue == "techno") {
      _bg1 = const Color.fromARGB(255, 134, 133, 121);
      _bg2 = const Color.fromARGB(255, 89, 89, 90);
      _dialogBg1 = const Color.fromARGB(255, 41, 42, 43);
      _dialogBg2 = const Color.fromARGB(255, 8, 16, 51);      
      _text1 = const Color.fromARGB(255, 224, 224, 224);
      _text2 = const Color.fromARGB(255, 209, 209, 209);
      _text3 = const Color.fromARGB(255, 255, 116, 255);
      _text4 = const Color.fromARGB(255, 20, 20, 20);
      _text5 = const Color.fromARGB(255, 44, 44, 44);   
      _widget1 = const Color.fromARGB(176, 182, 253, 102);
      _widget2 = const Color.fromARGB(255, 233, 233, 233);

    } else if (themeValue == "beach") {
      _bg1 = const Color.fromARGB(255, 255, 245, 153);
      _bg2 = const Color.fromARGB(255, 48, 91, 172);

      _dialogBg1 = const Color.fromARGB(255, 25, 208, 214);
      _dialogBg2 = const Color.fromARGB(255, 7, 27, 121);
            
      _text1 = const Color.fromARGB(255, 27, 27, 27);
      _text2 = const Color.fromARGB(255, 44, 44, 44);
      _text3 = const Color.fromARGB(255, 27, 27, 27);
      _text4 = const Color.fromARGB(255, 224, 224, 224);
      _text5 = const Color.fromARGB(255, 209, 209, 209);   
      _widget1 = const Color.fromARGB(255, 97, 179, 255);
      _widget2 = const Color.fromARGB(255, 233, 233, 233);

    }

    print("set to $themeValue");

    notifyListeners();
  }
  
}