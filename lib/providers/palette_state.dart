import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ColorPalette extends ChangeNotifier {

  // background
  late Color _bg1 = Colors.transparent;
  Color get bg1 => _bg1;

  late Color _bg2 = Colors.transparent;
  Color get bg2 => _bg2;


  late Color _appBarText = Colors.transparent;
  Color get appBarText => _appBarText;

  late Color _dialogBg1 = Colors.transparent;
  Color get dialogBg1 => _dialogBg1;

  late Color _dialogBg2 = Colors.transparent;
  Color get dialogBg2 => _dialogBg2;

  late Color _dialogText = Colors.transparent;
  Color get dialogText => _dialogText; 





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

  // auth
  late Color _inputFieldBgColor = Colors.transparent;
  Color get inputFieldBgColor => _inputFieldBgColor; 

  late Color _inputFieldBorderColor = Colors.transparent;
  Color get inputFieldBorderColor => _inputFieldBorderColor;

  late Color _inputFieldTextColor = Colors.transparent;
  Color get inputFieldTextColor => _inputFieldTextColor;





  // buttons
  late Color _navigationButtonBg1 = Colors.transparent;
  Color get navigationButtonBg1 => _navigationButtonBg1;   

  late Color _navigationButtonBg2 = Colors.transparent;
  Color get navigationButtonBg2 => _navigationButtonBg2;   

  late Color _navigationButtonBg3 = Colors.transparent;
  Color get navigationButtonBg3 => _navigationButtonBg3;   

  late Color _navigationButtonBorder1 = Colors.transparent;
  Color get navigationButtonBorder1 => _navigationButtonBorder1;   

  late Color _navigationButtonBorder2 = Colors.transparent;
  Color get navigationButtonBorder2 => _navigationButtonBorder2;   

  late Color _navigationButtonBorder3 = Colors.transparent;
  Color get navigationButtonBorder3 => _navigationButtonBorder3;    

  late Color _navigationButtonText1 = Colors.transparent;
  Color get navigationButtonText1 => _navigationButtonText1;   

  late Color _navigationButtonText2 = Colors.transparent;
  Color get navigationButtonText2 => _navigationButtonText2;   

  late Color _navigationButtonText3 = Colors.transparent;
  Color get navigationButtonText3 => _navigationButtonText3;           


  late Color _coinCounterBorder = Colors.transparent;
  Color get coinCounterBorder => _coinCounterBorder;

  late Color _coinCounterText = Colors.transparent;
  Color get coinCounterText => _coinCounterText;  


  // drawer
  late Color _drawerBg = Colors.transparent;
  Color get drawerBg => _drawerBg;

  late Color _drawerButtonBg = Colors.transparent;
  Color get drawerButtonBg => _drawerButtonBg;  

  late Color _drawerButtonText = Colors.transparent;
  Color get drawerButtonText => _drawerButtonText;    
  



  late Color _widget1 = Colors.transparent;
  Color get widget1 => _widget1;    

  late Color _widget2 = Colors.transparent;
  Color get widget2 => _widget2;

  late Color _widgetText1 = Colors.transparent;
  Color get widgetText1 => _widgetText1;    

  late Color _widgetText2 = Colors.transparent;
  Color get widgetText2 => _widgetText2;  

  late Color _widgetShadow1 = Colors.transparent;
  Color get widgetShadow1 => _widgetShadow1;    

  late Color _widgetShadow2 = Colors.transparent;
  Color get widgetShadow2 => _widgetShadow2;

  late Color _widgetParticulars1 = Colors.transparent;
  Color get widgetParticulars1 => _widgetParticulars1;  

  late Color _widgetParticulars2 = Colors.transparent;
  Color get widgetParticulars2 => _widgetParticulars2;



  late Color _gameplayText1 = Colors.transparent;
  Color get gameplayText1 => _gameplayText1;

  late Color _gameplayWordFound1 = Colors.transparent;
  Color get gameplayWordFound1 => _gameplayWordFound1;

  late Color _gameplayWordFound2 = Colors.transparent;
  Color get gameplayWordFound2 => _gameplayWordFound2;  

  late Color _gameplayTileShadow1 = Colors.transparent;
  Color get gameplayTileShadow1 => _gameplayTileShadow1;

  late Color _gameplayEmptyTileFill1 = Colors.transparent;
  Color get gameplayEmptyTileFill1 => _gameplayEmptyTileFill1;

  late Color _gameplayEmptyTileFill2 = Colors.transparent;
  Color get gameplayEmptyTileFill2 => _gameplayEmptyTileFill2;    

  late Color _gameplayEmptyTileBorder1 = Colors.transparent;
  Color get gameplayEmptyTileBorder1 => _gameplayEmptyTileBorder1;   

  late Color _gameplayEmptyTileBorder2 = Colors.transparent;
  Color get gameplayEmptyTileBorder2 => _gameplayEmptyTileBorder2;    

  late Color _gameplayDeadTileFill1 = Colors.transparent;
  Color get gameplayDeadTileFill1 => _gameplayDeadTileFill1;          

  late Color _gameplayDeadTileFill2 = Colors.transparent;
  Color get gameplayDeadTileFill2 => _gameplayDeadTileFill2;   

  late Color _scoreboardAnimationBorder1 = Colors.transparent;
  Color get scoreboardAnimationBorder1 => _scoreboardAnimationBorder1;  

  late Color _scoreboardAnimationBorder2 = Colors.transparent;
  Color get scoreboardAnimationBorder2 => _scoreboardAnimationBorder2;  

  // FONTS

  late GoogleFontFunction _tileFont = GoogleFonts.akayaKanadaka;
  GoogleFontFunction get tileFont => _tileFont;

  late GoogleFontFunction _mainAppFont = GoogleFonts.lilitaOne;
  GoogleFontFunction get mainAppFont => _mainAppFont;

  late GoogleFontFunction _authFont = GoogleFonts.roboto;
  GoogleFontFunction get authFont => _authFont;

  late GoogleFontFunction _counterFont = GoogleFonts.russoOne;
  GoogleFontFunction get counterFont => _counterFont;


  // final Map<String,Map<String,Color>> colorsDictionary = getColorsDictionary();
  void getThemeColors(String themeValue) {

      _bg1 = colorsDictionary[themeValue]!["bg1"]!; 
      _bg2 = colorsDictionary[themeValue]!["bg2"]!; 

      _drawerBg = colorsDictionary[themeValue]!["drawerBg"]!;

      _appBarText = colorsDictionary[themeValue]!["appBarText"]!; 

      _inputFieldBgColor = colorsDictionary[themeValue]!["inputFieldBgColor"]!; 
      _inputFieldBorderColor = colorsDictionary[themeValue]!["inputFieldBorderColor"]!; 
      _inputFieldTextColor = colorsDictionary[themeValue]!["inputFieldTextColor"]!; 

      _navigationButtonBg1 = colorsDictionary[themeValue]!["navigationButtonBg1"]!; 
      _navigationButtonBg2 = colorsDictionary[themeValue]!["navigationButtonBg2"]!; 
      _navigationButtonBg3 = colorsDictionary[themeValue]!["navigationButtonBg3"]!; 

      _navigationButtonText1 = colorsDictionary[themeValue]!["navigationButtonText1"]!; 
      _navigationButtonText2 = colorsDictionary[themeValue]!["navigationButtonText2"]!; 
      _navigationButtonText3 = colorsDictionary[themeValue]!["navigationButtonText3"]!; 
      
      _dialogBg1 = colorsDictionary[themeValue]!["dialogBg1"]!; 
      _dialogBg2 = colorsDictionary[themeValue]!["dialogBg2"]!; 
      _dialogText = colorsDictionary[themeValue]!["dialogText"]!; 

      _text1 = colorsDictionary[themeValue]!["text1"]!; 
      _text2 = colorsDictionary[themeValue]!["text2"]!; 
      _text3 = colorsDictionary[themeValue]!["text3"]!; 
      _text4 = colorsDictionary[themeValue]!["text4"]!; 
      _text5 = colorsDictionary[themeValue]!["text5"]!; 

      _widget1 = colorsDictionary[themeValue]!["widget1"]!; 
      _widget2 = colorsDictionary[themeValue]!["widget2"]!;


      _widgetText1 = colorsDictionary[themeValue]!["widgetText1"]!; 
      _widgetText2 = colorsDictionary[themeValue]!["widgetText2"]!;       

      _widgetShadow1 = colorsDictionary[themeValue]!["widgetShadow1"]!; 
      _widgetShadow2 = colorsDictionary[themeValue]!["widgetShadow2"]!;

      _widgetParticulars1 = colorsDictionary[themeValue]!["widgetParticulars1"]!;
      _widgetParticulars2 = colorsDictionary[themeValue]!["widgetParticulars2"]!;


      _coinCounterBorder = colorsDictionary[themeValue]!["coinCounterBorder"]!; 
      _coinCounterText = colorsDictionary[themeValue]!["coinCounterText"]!; 

      _gameplayText1 = colorsDictionary[themeValue]!["gameplayText1"]!; 
      _gameplayWordFound1 = colorsDictionary[themeValue]!["gameplayWordFound1"]!; 
      _gameplayWordFound2 = colorsDictionary[themeValue]!["gameplayWordFound2"]!; 
      _gameplayTileShadow1 = colorsDictionary[themeValue]!["gameplayTileShadow1"]!; 
      _gameplayEmptyTileFill1 = colorsDictionary[themeValue]!["gameplayEmptyTileFill1"]!; 
      _gameplayEmptyTileFill2 = colorsDictionary[themeValue]!["gameplayEmptyTileFill2"]!; 
      _gameplayEmptyTileBorder1 = colorsDictionary[themeValue]!["gameplayEmptyTileBorder1"]!; 
      _gameplayEmptyTileBorder2 = colorsDictionary[themeValue]!["gameplayEmptyTileBorder2"]!; 
      _gameplayDeadTileFill1 = colorsDictionary[themeValue]!["gameplayDeadTileFill1"]!; 
      _gameplayDeadTileFill2 = colorsDictionary[themeValue]!["gameplayDeadTileFill2"]!; 
      _scoreboardAnimationBorder1 = colorsDictionary[themeValue]!["scoreboardAnimationBorder1"]!; 
      _scoreboardAnimationBorder2 = colorsDictionary[themeValue]!["scoreboardAnimationBorder2"]!;    

      _tileFont = GoogleFonts.rowdies;

    // if (themeValue == "default") {
    //   _bg1 = const Color.fromARGB(255, 55, 116, 173);
    //   _bg2 = const Color.fromARGB(255, 38, 9, 92);

    //   _appBarText = const Color.fromARGB(230, 240, 240, 240);

    //   _inputFieldBgColor = const Color.fromARGB(199, 17, 3, 138);
    //   _inputFieldBorderColor = const Color.fromARGB(255, 35, 56, 236);
    //   _inputFieldTextColor = const Color.fromARGB(255, 238, 238, 238);

    //   _navigationButtonBg1 = const Color.fromARGB(255, 133, 164, 218);
    //   _navigationButtonBg2 = const Color.fromARGB(255, 13, 22, 138);
    //   _navigationButtonBg3 = const Color.fromARGB(255, 5, 12, 26);

    //   _navigationButtonText1 = const Color.fromARGB(255, 0, 4, 59);
    //   _navigationButtonText2 = Colors.white;
    //   _navigationButtonText3 = Colors.white;
      
    //   _dialogBg1 = const Color.fromARGB(255, 2, 75, 134);
    //   _dialogBg2 = const Color.fromARGB(255, 2, 26, 134);
    //   _dialogText = const Color.fromARGB(255, 235, 235, 235);

    //   _text1 = const Color.fromARGB(255, 224, 224, 224);
    //   _text2 = const Color.fromARGB(255, 209, 209, 209);
    //   _text3 = const Color.fromARGB(255, 13, 6, 110);
    //   _text4 = const Color.fromARGB(255, 20, 20, 20);
    //   _text5 = const Color.fromARGB(255, 44, 44, 44);

    //   _widget1 = const Color.fromARGB(255, 167, 228, 223);
    //   _widget2 = const Color.fromARGB(246, 49, 68, 151);

    //   _widgetText1 = const Color.fromARGB(255, 24, 24, 24);
    //   _widgetText2 = const Color.fromARGB(232, 241, 241, 241);      

    //   _widgetShadow1 = const Color.fromARGB(174, 31, 31, 31);
    //   _widgetShadow2 = const Color.fromARGB(232, 26, 26, 26);      


    //   _coinCounterBorder = const Color.fromARGB(211, 236, 236, 236);
    //   _coinCounterText = const Color.fromARGB(211, 236, 236, 236);


    //   _mainAppFont = GoogleFonts.lilitaOne;
    //   _tileFont = GoogleFonts.akayaKanadaka;
    //   _counterFont = GoogleFonts.russoOne;

    // } else if (themeValue == "light") {
    //   _bg1 = const Color.fromARGB(255, 252, 254, 255);
    //   _bg2 = const Color.fromARGB(255, 104, 233, 250);
    //   _dialogBg1 = const Color.fromARGB(255, 233, 233, 233);
    //   _dialogBg2 = const Color.fromARGB(255, 231, 255, 254);      
    //   _text1 = const Color.fromARGB(255, 10, 10, 10);
    //   _text2 = const Color.fromARGB(255, 39, 39, 39);
    //   _text3 = const Color.fromARGB(255, 234, 233, 236);
    //   _text4 = const Color.fromARGB(255, 255, 255, 255);
    //   _text5 = const Color.fromARGB(255, 235, 235, 235);   
    //   _widget1 = const Color.fromARGB(255, 181, 241, 252);
    //   _widget2 = const Color.fromARGB(255, 255, 252, 252);

    //   _mainAppFont = GoogleFonts.oi;
    //   _tileFont = GoogleFonts.galada;
    //   _counterFont = GoogleFonts.russoOne;

    // } else if (themeValue == "dark") {
    //   _bg1 = const Color.fromARGB(255, 37, 37, 37);
    //   _bg2 = const Color.fromARGB(255, 14, 14, 14);
    //   _dialogBg1 = const Color.fromARGB(255, 46, 46, 46);
    //   _dialogBg2 = const Color.fromARGB(255, 58, 58, 58);      
    //   _text1 = const Color.fromARGB(255, 224, 224, 224);
    //   _text2 = const Color.fromARGB(255, 209, 209, 209);
    //   _text3 = const Color.fromARGB(255, 22, 22, 22);
    //   _text4 = const Color.fromARGB(255, 20, 20, 20);
    //   _text5 = const Color.fromARGB(255, 44, 44, 44);   
    //   _widget1 = const Color.fromARGB(255, 56, 56, 56);
    //   _widget2 = const Color.fromARGB(255, 49, 49, 49);

    //   _mainAppFont = GoogleFonts.hurricane;
    //   _tileFont = GoogleFonts.alumniSans;        

    // } else if (themeValue == "nature") {
    //   _bg1 = const Color.fromARGB(255, 114, 199, 90);
    //   _bg2 = const Color.fromARGB(255, 17, 94, 7);
    //   _dialogBg1 = const Color.fromARGB(255, 74, 128, 38);
    //   _dialogBg2 = const Color.fromARGB(255, 12, 78, 4);      
    //   _text1 = const Color.fromARGB(255, 224, 224, 224);
    //   _text2 = const Color.fromARGB(255, 209, 209, 209);
    //   _text3 = const Color.fromARGB(255, 1, 49, 1);
    //   _text4 = const Color.fromARGB(255, 20, 20, 20);
    //   _text5 = const Color.fromARGB(255, 44, 44, 44);   
    //   _widget1 = const Color.fromARGB(255, 71, 24, 2);
    //   _widget2 = const Color.fromARGB(255, 165, 116, 84);

    //   _mainAppFont = GoogleFonts.knewave;
    //   _tileFont = GoogleFonts.pottaOne;
    //   _counterFont = GoogleFonts.russoOne;

    // } else if (themeValue == "techno") {
    //   _bg1 = const Color.fromARGB(255, 134, 133, 121);
    //   _bg2 = const Color.fromARGB(255, 89, 89, 90);
    //   _dialogBg1 = const Color.fromARGB(255, 41, 42, 43);
    //   _dialogBg2 = const Color.fromARGB(255, 8, 16, 51);      
    //   _text1 = const Color.fromARGB(255, 224, 224, 224);
    //   _text2 = const Color.fromARGB(255, 209, 209, 209);
    //   _text3 = const Color.fromARGB(255, 255, 116, 255);
    //   _text4 = const Color.fromARGB(255, 20, 20, 20);
    //   _text5 = const Color.fromARGB(255, 44, 44, 44);   
    //   _widget1 = const Color.fromARGB(176, 182, 253, 102);
    //   _widget2 = const Color.fromARGB(255, 233, 233, 233);

    //   _mainAppFont = GoogleFonts.audiowide;
    //   _tileFont = GoogleFonts.gugi;
    //   _counterFont = GoogleFonts.russoOne;

    // } else if (themeValue == "beach") {
    //   _bg1 = const Color.fromARGB(255, 255, 245, 153);
    //   _bg2 = const Color.fromARGB(255, 48, 91, 172);

    //   _dialogBg1 = const Color.fromARGB(255, 25, 208, 214);
    //   _dialogBg2 = const Color.fromARGB(255, 7, 27, 121);
            
    //   _text1 = const Color.fromARGB(255, 27, 27, 27);
    //   _text2 = const Color.fromARGB(255, 44, 44, 44);
    //   _text3 = const Color.fromARGB(255, 27, 27, 27);
    //   _text4 = const Color.fromARGB(255, 224, 224, 224);
    //   _text5 = const Color.fromARGB(255, 209, 209, 209);   
    //   _widget1 = const Color.fromARGB(255, 97, 179, 255);
    //   _widget2 = const Color.fromARGB(255, 233, 233, 233);

    //   _mainAppFont = GoogleFonts.leckerliOne;
    //   _tileFont = GoogleFonts.lemonada;
    //   _counterFont = GoogleFonts.russoOne;

    // }


    notifyListeners();
  }
  

    Map<String,Map<String,Color>> colorsDictionary = {
      "default" : {

          "bg1" : const Color.fromARGB(255, 55, 116, 173),
          "bg2" : const Color.fromARGB(255, 38, 9, 92),

          "appBarText" : const Color.fromARGB(230, 240, 240, 240),
          "drawerBg": const Color.fromARGB(255, 7, 13, 92),


          "inputFieldBgColor" : const Color.fromARGB(199, 17, 3, 138),
          "inputFieldBorderColor" : const Color.fromARGB(255, 35, 56, 236),
          "inputFieldTextColor" : const Color.fromARGB(255, 238, 238, 238),

          "navigationButtonBg1" : const Color.fromARGB(255, 133, 164, 218),
          "navigationButtonBg2" : const Color.fromARGB(255, 13, 22, 138),
          "navigationButtonBg3" : const Color.fromARGB(255, 5, 12, 26),

          "navigationButtonText1" : const Color.fromARGB(255, 0, 4, 59),
          "navigationButtonText2" : Colors.white,
          "navigationButtonText3" : Colors.white,
          
          "dialogBg1" : const Color.fromARGB(255, 2, 75, 134),
          "dialogBg2" : const Color.fromARGB(255, 2, 26, 134),
          "dialogText" : const Color.fromARGB(255, 235, 235, 235),

          "text1" : const Color.fromARGB(255, 224, 224, 224),
          "text2" : const Color.fromARGB(255, 209, 209, 209),
          "text3" : const Color.fromARGB(255, 13, 6, 110),
          "text4" : const Color.fromARGB(255, 20, 20, 20),
          "text5" : const Color.fromARGB(255, 44, 44, 44),

          "widget1" : const Color.fromARGB(246, 49, 68, 151),
          "widget2" : const Color.fromARGB(255, 236, 239, 255),

          "widgetText1" : const Color.fromARGB(255, 236, 236, 236),
          "widgetText2" : const Color.fromARGB(255, 11, 0, 109),      

          "widgetShadow1" : const Color.fromARGB(115, 0, 0, 0),
          "widgetShadow2" : const Color.fromARGB(90, 0, 0, 0),

          "widgetParticulars1" : const Color.fromARGB(255, 4, 15, 173),
          "widgetParticulars2" : const Color.fromARGB(255, 143, 197, 241),

          "coinCounterBorder" : const Color.fromARGB(211, 236, 236, 236),
          "coinCounterText" : const Color.fromARGB(211, 236, 236, 236),


          "gameplayText1" : const Color.fromARGB(225, 236, 236, 236),
          "gameplayWordFound1" : const Color.fromARGB(255, 255, 102, 13),
          "gameplayWordFound2" : const Color.fromARGB(255, 250, 231, 57),
          "gameplayTileShadow1" : const Color.fromARGB(255, 247, 247, 247),
          "gameplayEmptyTileFill1" : Color.fromARGB(239, 137, 241, 255),
          "gameplayEmptyTileFill2" : Color.fromARGB(239, 217, 255, 255),
          "gameplayEmptyTileBorder1" : Color.fromARGB(239, 137, 241, 255),
          "gameplayEmptyTileBorder2" : Color.fromARGB(236, 16, 14, 126),
          "gameplayDeadTileFill1" : const Color.fromARGB(255, 0, 0, 0),
          "gameplayDeadTileFill2" : const Color.fromARGB(255, 87, 87, 87),
          "scoreboardAnimationBorder1" : const Color.fromARGB(255, 236, 215, 23),
          "scoreboardAnimationBorder2" : const Color.fromARGB(255, 235, 55, 42),


      },
      "light" : {
          "bg1" : const Color.fromARGB(255, 240, 240, 240),
          "bg2" : const Color.fromARGB(255, 235, 235, 235),

          "appBarText" : const Color.fromARGB(230, 24, 24, 24),
          "drawerBg": const Color.fromARGB(255, 172, 219, 145),

          "inputFieldBgColor" : const Color.fromARGB(198, 166, 240, 224),
          "inputFieldBorderColor" : const Color.fromARGB(255, 63, 182, 190),
          "inputFieldTextColor" : const Color.fromARGB(255, 26, 26, 26),

          "navigationButtonBg1" : const Color.fromARGB(255, 66, 228, 206),
          "navigationButtonBg2" : const Color.fromARGB(255, 133, 243, 201),
          "navigationButtonBg3" : const Color.fromARGB(255, 114, 179, 240),

          "navigationButtonText1" : const Color.fromARGB(255, 15, 15, 15),
          "navigationButtonText2" : const Color.fromARGB(255, 10, 10, 10),
          "navigationButtonText3" : const Color.fromARGB(255, 14, 14, 14),
          
          "dialogBg1" : const Color.fromARGB(255, 155, 187, 212),
          "dialogBg2" : const Color.fromARGB(255, 238, 238, 238),
          "dialogText" : const Color.fromARGB(255, 15, 15, 15),

          "text1" : const Color.fromARGB(255, 19, 19, 19),
          "text2" : const Color.fromARGB(255, 24, 24, 24),
          "text3" : const Color.fromARGB(255, 24, 24, 24),
          "text4" : const Color.fromARGB(255, 20, 20, 20),
          "text5" : const Color.fromARGB(255, 44, 44, 44),

          "widget1" : const Color.fromARGB(255, 230, 181, 223),
          "widget2" : const Color.fromARGB(246, 207, 229, 185),

          "widgetText1" : const Color.fromARGB(255, 24, 24, 24),
          "widgetText2" : const Color.fromARGB(232, 15, 15, 15),      

          "widgetShadow1" : const Color.fromARGB(103, 0, 0, 0),
          "widgetShadow2" : const Color.fromARGB(115, 26, 26, 26),

          "widgetParticulars1" : const Color.fromARGB(255, 26, 26, 26),
          "widgetParticulars2" : const Color.fromARGB(255, 230, 186, 241),

          "coinCounterBorder" : const Color.fromARGB(210, 19, 19, 19),
          "coinCounterText" : const Color.fromARGB(210, 34, 34, 34),

          "gameplayText1" : const Color.fromARGB(255, 6, 9, 175),
          "gameplayWordFound1" : const Color.fromARGB(255, 250, 93, 2),
          "gameplayWordFound2" : const Color.fromARGB(255, 173, 10, 10),
          "gameplayTileShadow1" : const Color.fromARGB(255, 34, 5, 139),
          "gameplayEmptyTileFill1" : Color.fromARGB(255,156,224,255),
          "gameplayEmptyTileFill2" : Color.fromARGB(239, 217, 255, 255),
          "gameplayEmptyTileBorder1" : Color.fromARGB(239, 137, 241, 255),
          "gameplayEmptyTileBorder2" : Color.fromARGB(236, 16, 14, 126),          
          "gameplayDeadTileFill1" : const Color.fromARGB(255, 0, 0, 0),
          "gameplayDeadTileFill2" : const Color.fromARGB(255, 87, 87, 87),
          "scoreboardAnimationBorder1" : const Color.fromARGB(255, 240, 227, 118),
          "scoreboardAnimationBorder2" : const Color.fromARGB(255, 253, 154, 147),          


      },
      "dark" : {
          "bg1" : const Color.fromARGB(255, 55, 116, 173),
          "bg2" : const Color.fromARGB(255, 38, 9, 92),

          "appBarText" : const Color.fromARGB(230, 240, 240, 240),
          "drawerBg": const Color.fromARGB(255, 31, 31, 31),

          "inputFieldBgColor" : const Color.fromARGB(199, 17, 3, 138),
          "inputFieldBorderColor" : const Color.fromARGB(255, 35, 56, 236),
          "inputFieldTextColor" : const Color.fromARGB(255, 238, 238, 238),

          "navigationButtonBg1" : const Color.fromARGB(255, 133, 164, 218),
          "navigationButtonBg2" : const Color.fromARGB(255, 13, 22, 138),
          "navigationButtonBg3" : const Color.fromARGB(255, 5, 12, 26),

          "navigationButtonText1" : const Color.fromARGB(255, 0, 4, 59),
          "navigationButtonText2" : Colors.white,
          "navigationButtonText3" : Colors.white,
          
          "dialogBg1" : const Color.fromARGB(255, 2, 75, 134),
          "dialogBg2" : const Color.fromARGB(255, 2, 26, 134),
          "dialogText" : const Color.fromARGB(255, 235, 235, 235),

          "text1" : const Color.fromARGB(255, 224, 224, 224),
          "text2" : const Color.fromARGB(255, 209, 209, 209),
          "text3" : const Color.fromARGB(255, 13, 6, 110),
          "text4" : const Color.fromARGB(255, 20, 20, 20),
          "text5" : const Color.fromARGB(255, 44, 44, 44),

          "widget1" : const Color.fromARGB(255, 167, 228, 223),
          "widget2" : const Color.fromARGB(246, 49, 68, 151),

          "widgetText1" : const Color.fromARGB(255, 24, 24, 24),
          "widgetText2" : const Color.fromARGB(232, 241, 241, 241),      

          "widgetShadow1" : const Color.fromARGB(174, 31, 31, 31),
          "widgetShadow2" : const Color.fromARGB(232, 26, 26, 26),

          "widgetParticulars1" : const Color.fromARGB(255, 4, 15, 173),
          "widgetParticulars2" : const Color.fromARGB(255, 143, 197, 241),          


          "coinCounterBorder" : const Color.fromARGB(211, 236, 236, 236),
          "coinCounterText" : const Color.fromARGB(211, 236, 236, 236),

          "gameplayText1" : const Color.fromARGB(255, 79, 197, 252),
          "gameplayWordFound1" : const Color.fromARGB(255, 255, 102, 13),
          "gameplayWordFound2" : const Color.fromARGB(255, 250, 231, 57),
          "gameplayTileShadow1" : const Color.fromARGB(255, 74, 249, 255),
          "gameplayEmptyTileFill1" : Color.fromARGB(255,156,224,255),
          "gameplayEmptyTileFill2" : Color.fromARGB(239, 217, 255, 255),
          "gameplayEmptyTileBorder1" : Color.fromARGB(239, 137, 241, 255),
          "gameplayEmptyTileBorder2" : Color.fromARGB(236, 16, 14, 126),          
          "gameplayDeadTileFill1" : const Color.fromARGB(255, 0, 0, 0),
          "gameplayDeadTileFill2" : const Color.fromARGB(255, 87, 87, 87),
          "scoreboardAnimationBorder1" : const Color.fromARGB(255, 240, 227, 118),
          "scoreboardAnimationBorder2" : const Color.fromARGB(255, 253, 154, 147),            
      },
      "nature" : {
          "bg1" : const Color.fromARGB(255, 55, 116, 173),
          "bg2" : const Color.fromARGB(255, 38, 9, 92),

          "appBarText" : const Color.fromARGB(230, 240, 240, 240),
          "drawerBg": const Color.fromARGB(255, 155, 247, 193),

          "inputFieldBgColor" : const Color.fromARGB(199, 17, 3, 138),
          "inputFieldBorderColor" : const Color.fromARGB(255, 35, 56, 236),
          "inputFieldTextColor" : const Color.fromARGB(255, 238, 238, 238),

          "navigationButtonBg1" : const Color.fromARGB(255, 133, 164, 218),
          "navigationButtonBg2" : const Color.fromARGB(255, 13, 22, 138),
          "navigationButtonBg3" : const Color.fromARGB(255, 5, 12, 26),

          "navigationButtonText1" : const Color.fromARGB(255, 0, 4, 59),
          "navigationButtonText2" : Colors.white,
          "navigationButtonText3" : Colors.white,
          
          "dialogBg1" : const Color.fromARGB(255, 2, 75, 134),
          "dialogBg2" : const Color.fromARGB(255, 2, 26, 134),
          "dialogText" : const Color.fromARGB(255, 235, 235, 235),

          "text1" : const Color.fromARGB(255, 224, 224, 224),
          "text2" : const Color.fromARGB(255, 209, 209, 209),
          "text3" : const Color.fromARGB(255, 13, 6, 110),
          "text4" : const Color.fromARGB(255, 20, 20, 20),
          "text5" : const Color.fromARGB(255, 44, 44, 44),

          "widget1" : const Color.fromARGB(255, 167, 228, 223),
          "widget2" : const Color.fromARGB(246, 49, 68, 151),

          "widgetText1" : const Color.fromARGB(255, 24, 24, 24),
          "widgetText2" : const Color.fromARGB(232, 241, 241, 241),      

          "widgetShadow1" : const Color.fromARGB(174, 31, 31, 31),
          "widgetShadow2" : const Color.fromARGB(232, 26, 26, 26),

          "widgetParticulars1" : const Color.fromARGB(255, 4, 15, 173),
          "widgetParticulars2" : const Color.fromARGB(255, 143, 197, 241),          


          "coinCounterBorder" : const Color.fromARGB(211, 236, 236, 236),
          "coinCounterText" : const Color.fromARGB(211, 236, 236, 236),

          "gameplayText1" : const Color.fromARGB(255, 79, 197, 252),
          "gameplayWordFound1" : const Color.fromARGB(255, 255, 102, 13),
          "gameplayWordFound2" : const Color.fromARGB(255, 250, 231, 57),
          "gameplayTileShadow1" : const Color.fromARGB(255, 74, 249, 255),
          "gameplayEmptyTileFill1" : Color.fromARGB(255,156,224,255),
          "gameplayEmptyTileFill2" : Color.fromARGB(239, 217, 255, 255),
          "gameplayEmptyTileBorder1" : Color.fromARGB(239, 137, 241, 255),
          "gameplayEmptyTileBorder2" : Color.fromARGB(236, 16, 14, 126),          
          "gameplayDeadTileFill1" : const Color.fromARGB(255, 0, 0, 0),
          "gameplayDeadTileFill2" : const Color.fromARGB(255, 87, 87, 87),
          "scoreboardAnimationBorder1" : const Color.fromARGB(255, 240, 227, 118),
          "scoreboardAnimationBorder2" : const Color.fromARGB(255, 253, 154, 147),             
      },
      "techno" : {
          "bg1" : const Color.fromARGB(255, 55, 116, 173),
          "bg2" : const Color.fromARGB(255, 38, 9, 92),

          "appBarText" : const Color.fromARGB(230, 240, 240, 240),
          "drawerBg": const Color.fromARGB(255, 32, 32, 32),

          "inputFieldBgColor" : const Color.fromARGB(199, 17, 3, 138),
          "inputFieldBorderColor" : const Color.fromARGB(255, 35, 56, 236),
          "inputFieldTextColor" : const Color.fromARGB(255, 238, 238, 238),

          "navigationButtonBg1" : const Color.fromARGB(255, 133, 164, 218),
          "navigationButtonBg2" : const Color.fromARGB(255, 13, 22, 138),
          "navigationButtonBg3" : const Color.fromARGB(255, 5, 12, 26),

          "navigationButtonText1" : const Color.fromARGB(255, 0, 4, 59),
          "navigationButtonText2" : Colors.white,
          "navigationButtonText3" : Colors.white,
          
          "dialogBg1" : const Color.fromARGB(255, 2, 75, 134),
          "dialogBg2" : const Color.fromARGB(255, 2, 26, 134),
          "dialogText" : const Color.fromARGB(255, 235, 235, 235),

          "text1" : const Color.fromARGB(255, 224, 224, 224),
          "text2" : const Color.fromARGB(255, 209, 209, 209),
          "text3" : const Color.fromARGB(255, 13, 6, 110),
          "text4" : const Color.fromARGB(255, 20, 20, 20),
          "text5" : const Color.fromARGB(255, 44, 44, 44),

          "widget1" : const Color.fromARGB(255, 167, 228, 223),
          "widget2" : const Color.fromARGB(246, 49, 68, 151),

          "widgetText1" : const Color.fromARGB(255, 24, 24, 24),
          "widgetText2" : const Color.fromARGB(232, 241, 241, 241),      

          "widgetShadow1" : const Color.fromARGB(174, 31, 31, 31),
          "widgetShadow2" : const Color.fromARGB(232, 26, 26, 26),

          "widgetParticulars1" : const Color.fromARGB(255, 4, 15, 173),
          "widgetParticulars2" : const Color.fromARGB(255, 143, 197, 241),          


          "coinCounterBorder" : const Color.fromARGB(211, 236, 236, 236),
          "coinCounterText" : const Color.fromARGB(211, 236, 236, 236),

          "gameplayText1" : const Color.fromARGB(255, 79, 197, 252),
          "gameplayWordFound1" : const Color.fromARGB(255, 255, 102, 13),
          "gameplayWordFound2" : const Color.fromARGB(255, 250, 231, 57),
          "gameplayTileShadow1" : const Color.fromARGB(255, 74, 249, 255),
          "gameplayEmptyTileFill1" : Color.fromARGB(255,156,224,255),
          "gameplayEmptyTileFill2" : Color.fromARGB(239, 217, 255, 255),
          "gameplayEmptyTileBorder1" : Color.fromARGB(239, 137, 241, 255),
          "gameplayEmptyTileBorder2" : Color.fromARGB(236, 16, 14, 126),          
          "gameplayDeadTileFill1" : const Color.fromARGB(255, 0, 0, 0),
          "gameplayDeadTileFill2" : const Color.fromARGB(255, 87, 87, 87),
          "scoreboardAnimationBorder1" : const Color.fromARGB(255, 240, 227, 118),
          "scoreboardAnimationBorder2" : const Color.fromARGB(255, 253, 154, 147),
      },
      "beach" : {
          "bg1" : const Color.fromARGB(255, 55, 116, 173),
          "bg2" : const Color.fromARGB(255, 38, 9, 92),

          "appBarText" : const Color.fromARGB(230, 240, 240, 240),
          "drawerBg": const Color.fromARGB(255, 7, 13, 92),

          "inputFieldBgColor" : const Color.fromARGB(199, 17, 3, 138),
          "inputFieldBorderColor" : const Color.fromARGB(255, 35, 56, 236),
          "inputFieldTextColor" : const Color.fromARGB(255, 238, 238, 238),

          "navigationButtonBg1" : const Color.fromARGB(255, 133, 164, 218),
          "navigationButtonBg2" : const Color.fromARGB(255, 13, 22, 138),
          "navigationButtonBg3" : const Color.fromARGB(255, 5, 12, 26),

          "navigationButtonText1" : const Color.fromARGB(255, 0, 4, 59),
          "navigationButtonText2" : Colors.white,
          "navigationButtonText3" : Colors.white,
          
          "dialogBg1" : const Color.fromARGB(255, 2, 75, 134),
          "dialogBg2" : const Color.fromARGB(255, 2, 26, 134),
          "dialogText" : const Color.fromARGB(255, 235, 235, 235),

          "text1" : const Color.fromARGB(255, 224, 224, 224),
          "text2" : const Color.fromARGB(255, 209, 209, 209),
          "text3" : const Color.fromARGB(255, 13, 6, 110),
          "text4" : const Color.fromARGB(255, 20, 20, 20),
          "text5" : const Color.fromARGB(255, 44, 44, 44),

          "widget1" : const Color.fromARGB(255, 167, 228, 223),
          "widget2" : const Color.fromARGB(246, 49, 68, 151),

          "widgetText1" : const Color.fromARGB(255, 24, 24, 24),
          "widgetText2" : const Color.fromARGB(232, 241, 241, 241),      

          "widgetShadow1" : const Color.fromARGB(174, 31, 31, 31),
          "widgetShadow2" : const Color.fromARGB(232, 26, 26, 26),

          "widgetParticulars1" : const Color.fromARGB(255, 4, 15, 173),
          "widgetParticulars2" : const Color.fromARGB(255, 143, 197, 241),          


          "coinCounterBorder" : const Color.fromARGB(211, 236, 236, 236),
          "coinCounterText" : const Color.fromARGB(211, 236, 236, 236),

          "gameplayText1" : const Color.fromARGB(255, 79, 197, 252),
          "gameplayWordFound1" : const Color.fromARGB(255, 255, 102, 13),
          "gameplayWordFound2" : const Color.fromARGB(255, 250, 231, 57),
          "gameplayTileShadow1" : const Color.fromARGB(255, 74, 249, 255),
          "gameplayEmptyTileFill1" : Color.fromARGB(255,156,224,255),
          "gameplayEmptyTileFill2" : Color.fromARGB(239, 217, 255, 255),
          "gameplayEmptyTileBorder1" : Color.fromARGB(239, 137, 241, 255),
          "gameplayEmptyTileBorder2" : Color.fromARGB(236, 16, 14, 126),          
          "gameplayDeadTileFill1" : const Color.fromARGB(255, 0, 0, 0),
          "gameplayDeadTileFill2" : const Color.fromARGB(255, 87, 87, 87),
          "scoreboardAnimationBorder1" : const Color.fromARGB(255, 240, 227, 118),
          "scoreboardAnimationBorder2" : const Color.fromARGB(255, 253, 154, 147),
      },
  };
}

typedef GoogleFontFunction = TextStyle Function({TextStyle? textStyle});
