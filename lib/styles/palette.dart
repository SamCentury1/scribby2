import 'package:flutter/material.dart';


class ColorPalette with ChangeNotifier {

  late Color _screenGradientBackgroundColor1 = Colors.transparent;
  Color get screenGradientBackgroundColor1 => _screenGradientBackgroundColor1;

  late Color _screenGradientBackgroundColor2 = Colors.transparent;
  Color get screenGradientBackgroundColor2 => _screenGradientBackgroundColor2;


  /// EMPTY TILES
  late Color _emptyTileGradientBackGroundColor1 = Colors.transparent;
  Color get emptyTileGradientBackGroundColor1 => _emptyTileGradientBackGroundColor1;  

  late Color _emptyTileGradientBackGroundColor2 = Colors.transparent;
  Color get emptyTileGradientBackGroundColor2 => _emptyTileGradientBackGroundColor2;  

  late Color _emptyTileBorderColor = Colors.transparent;
  Color get emptyTileBorderColor => _emptyTileBorderColor;

  // RESERVE TILES
  late Color _fullReserveGradientBackGroundColor1 = Colors.transparent;
  Color get fullReserveGradientBackGroundColor1 => _fullReserveGradientBackGroundColor1;  
  late Color _fullReserveGradientBackGroundColor2 = Colors.transparent;
  Color get fullReserveGradientBackGroundColor2 => _fullReserveGradientBackGroundColor2; 
  late Color _fullReserveGradientBackGroundColor3 = Colors.transparent;
  Color get fullReserveGradientBackGroundColor3 => _fullReserveGradientBackGroundColor3; 
   late Color _fullReserveGradientBackGroundColor4 = Colors.transparent;
  Color get fullReserveGradientBackGroundColor4 => _fullReserveGradientBackGroundColor4;
  late Color _fullReserveGradientBackGroundColor5 = Colors.transparent;
  Color get fullReserveGradientBackGroundColor5 => _fullReserveGradientBackGroundColor5;

  late Color _fullReserveTextColor = Colors.transparent;
  Color get fullReserveTextColor => _fullReserveTextColor;

  late Color _fullReserveBorderColor = Colors.transparent;
  Color get fullReserveBorderColor => _fullReserveBorderColor;       

  late Color _emptyReserveGradientBackGroundColor1 = Colors.transparent;
  Color get emptyReserveGradientBackGroundColor1 => _emptyReserveGradientBackGroundColor1;  
  late Color _emptyReserveGradientBackGroundColor2 = Colors.transparent;
  Color get emptyReserveGradientBackGroundColor2 => _emptyReserveGradientBackGroundColor2;  

  late Color _emptyReserveBorderColor = Colors.transparent;
  Color get emptyReserveBorderColor => _emptyReserveBorderColor;    


  /// DEAD TILES
  late Color _deadTileGradientBackGroundColor1 = Colors.transparent;
  Color get deadTileGradientBackGroundColor1 => _deadTileGradientBackGroundColor1;  

  late Color _deadTileGradientBackGroundColor2 = Colors.transparent;
  Color get deadTileGradientBackGroundColor2 => _deadTileGradientBackGroundColor2;   

  /// FULL TILES
  late Color _fullTileTextColor = Colors.transparent;
  Color get fullTileTextColor => _fullTileTextColor;

  late Color _fullTileBorderColor = Colors.transparent;
  Color get fullTileBorderColor => _fullTileBorderColor;  

  late Color _tileGradientShade1Color1 = Colors.transparent;
  Color get tileGradientShade1Color1 => _tileGradientShade1Color1; 

  late Color _tileGradientShade1Color2 = Colors.transparent;
  Color get tileGradientShade1Color2 => _tileGradientShade1Color2;   

  late Color _tileGradientShade2Color1 = Colors.transparent;
  Color get tileGradientShade2Color1 => _tileGradientShade2Color1; 

  late Color _tileGradientShade2Color2 = Colors.transparent;
  Color get tileGradientShade2Color2 => _tileGradientShade2Color2;   

  late Color _tileGradientShade3Color1 = Colors.transparent;
  Color get tileGradientShade3Color1 => _tileGradientShade3Color1; 

  late Color _tileGradientShade3Color2 = Colors.transparent;
  Color get tileGradientShade3Color2 => _tileGradientShade3Color2;   

  late Color _tileGradientShade4Color1 = Colors.transparent;
  Color get tileGradientShade4Color1 => _tileGradientShade4Color1; 

  late Color _tileGradientShade4Color2 = Colors.transparent;
  Color get tileGradientShade4Color2 => _tileGradientShade4Color2;   

  late Color _tileGradientShade5Color1 = Colors.transparent;
  Color get tileGradientShade5Color1 => _tileGradientShade5Color1; 

  late Color _tileGradientShade5Color2 = Colors.transparent;
  Color get tileGradientShade5Color2 => _tileGradientShade5Color2; 


  late Color _overlayText = const Color.fromARGB(255, 216, 215, 215);
  Color get overlayText => _overlayText;     


  /// TIMER WIDGET
  late Color _timerRingColor = Colors.transparent;
  Color get timerRingColor => _timerRingColor;  

  late Color _timerRingGradient1 = Colors.transparent;
  Color get timerRingGradient1 => _timerRingGradient1;    

  late Color _timerRingGradient2 = Colors.transparent;
  Color get timerRingGradient2 => _timerRingGradient2;   

  late Color _timerFillColor = Colors.transparent;
  Color get timerFillColor => _timerFillColor;  

  late Color _timerFillGradient1 = Colors.transparent;
  Color get timerFillGradient1 => _timerFillGradient1;    

  late Color _timerFillGradient2 = Colors.transparent;
  Color get timerFillGradient2 => _timerFillGradient2;      
          


  late Color _modalBgColor = Colors.transparent;
  Color get modalBgColor => _modalBgColor;

  late Color _modalTextColor = Colors.transparent;
  Color get modalTextColor => _modalTextColor;

  late Color _textColor1 = Colors.transparent;
  Color get textColor1 => _textColor1;

  late Color _textColor2 = Colors.transparent;
  Color get textColor2 => _textColor2;

  late Color _textColor3 = Colors.transparent;
  Color get textColor3 => _textColor3;

  // late Color _appBarColor = Colors.transparent;
  // Color get appBarColor => _appBarColor;

  late Color _confettiColor1 = Colors.transparent;
  Color get confettiColor1 => _confettiColor1;

  late Color _confettiColor2 = Colors.transparent;
  Color get confettiColor2 => _confettiColor2;

  late Color _confettiColor3 = Colors.transparent;
  Color get confettiColor3 => _confettiColor3;

  late Color _confettiColor4 = Colors.transparent;
  Color get confettiColor4 => _confettiColor4;


  void getThemeColors(bool isDarkTheme) {
    switch (isDarkTheme) {
      case true:
        _screenGradientBackgroundColor1 = Color.fromARGB(255, 15, 8, 54);
        _screenGradientBackgroundColor2 = Color.fromARGB(255, 38, 18, 85);

        _emptyTileGradientBackGroundColor1 = Color.fromARGB(255, 149, 171, 204);
        _emptyTileGradientBackGroundColor2 = Color.fromARGB(255, 99, 123, 230);
        _emptyTileBorderColor = Color.fromARGB(255, 209, 218, 238);        

        _deadTileGradientBackGroundColor1 = Color.fromARGB(255, 145, 145, 145);
        _deadTileGradientBackGroundColor2 = Color.fromARGB(255, 75, 75, 75);

        /// RESERVES
        _fullReserveGradientBackGroundColor1 = Color.fromARGB(255, 134, 134, 134); 
        _fullReserveGradientBackGroundColor2 = Color.fromARGB(255, 134, 134, 134); 
        _fullReserveGradientBackGroundColor3 = Color.fromARGB(255, 109, 109, 108); 
        _fullReserveGradientBackGroundColor4 = Color.fromARGB(255, 94, 94, 93); 
        _fullReserveGradientBackGroundColor5 = Color.fromARGB(255, 77, 77, 76);

        _timerRingColor = Colors.white;
        _timerRingGradient1 = Color.fromARGB(255, 149, 171, 204); 
        _timerRingGradient2 = Color.fromARGB(255, 99, 123, 230); 
        _timerFillColor = Colors.black;
        _timerFillGradient1 = Color.fromARGB(255, 241, 187, 135); 
        _timerFillGradient2 = Color.fromARGB(255, 248, 224, 158); 


        _fullTileTextColor = Color.fromARGB(255, 22, 22, 22);
        _fullTileBorderColor = Color.fromARGB(153, 34, 20, 3);        
        _fullReserveTextColor = Color.fromARGB(255, 22, 22, 22);
        _fullReserveBorderColor =  Color.fromARGB(255, 43, 43, 43);

        _emptyReserveBorderColor = Color.fromARGB(255, 105, 104, 104);

        _tileGradientShade1Color1 = Color.fromARGB(255, 235, 223, 177);
        _tileGradientShade1Color2 = Color.fromARGB(255, 231, 193, 142);

        _tileGradientShade2Color1 = Color.fromARGB(255, 228, 194, 132);
        _tileGradientShade2Color2 = Color.fromARGB(255, 255, 210, 126);

        _tileGradientShade3Color1 = Color.fromARGB(255, 238, 199, 147);
        _tileGradientShade3Color2 = Color.fromARGB(255, 231, 187, 136);

        _tileGradientShade4Color1 = Color.fromARGB(255, 241, 187, 135);
        _tileGradientShade4Color2 = Color.fromARGB(255, 248, 224, 158);

        _tileGradientShade5Color1 = Color.fromARGB(255, 235, 191, 134);
        _tileGradientShade5Color2 = Color.fromARGB(255, 223, 178, 142); 

        _modalBgColor = Color.fromARGB(255, 46, 46, 46);
        _modalTextColor = const Color.fromARGB(255, 212, 211, 211);        
        _textColor1 = const Color.fromARGB(255, 247, 247, 247);
        _textColor2 = const Color.fromARGB(255, 211, 211, 211);
        _textColor3 = const Color.fromARGB(255, 185, 184, 184);

        _confettiColor1 = const Color.fromARGB(255, 243, 104, 248);
        _confettiColor2 = const Color.fromARGB(255, 165, 242, 255);
        _confettiColor3 = const Color.fromARGB(255, 64, 52, 233);
        _confettiColor4 = const Color.fromARGB(255, 161, 59, 245);

        break;
      case false:
        /// TILES
        _screenGradientBackgroundColor1 = Color.fromARGB(255, 138, 186, 231);
        _screenGradientBackgroundColor2 = Color.fromARGB(255, 200, 210, 231);

        _fullTileTextColor = Color.fromARGB(255,175,207,254);
        _fullTileBorderColor = Color.fromARGB(255,172,205,254);

        _emptyTileGradientBackGroundColor1 = Color.fromARGB(255, 116, 208, 254);
        _emptyTileGradientBackGroundColor2 = Color.fromARGB(255, 113, 167, 255);
        
        _emptyTileBorderColor = Color.fromARGB(255, 113, 167, 255);

        _deadTileGradientBackGroundColor1 = Color.fromARGB(255, 66, 66, 66);
        _deadTileGradientBackGroundColor2 = Color.fromARGB(255, 43, 43, 43);

        /// RESERVES
        _fullReserveGradientBackGroundColor1 = Color.fromARGB(223, 6, 13, 48); 
        _fullReserveGradientBackGroundColor2 = Color.fromARGB(255, 0, 0, 0); 
        _fullReserveGradientBackGroundColor3 = Color.fromARGB(223, 4, 11, 46); 
        _fullReserveGradientBackGroundColor4 = Color.fromARGB(223, 18, 26, 63); 
        _fullReserveGradientBackGroundColor5 = Color.fromARGB(223, 3, 9, 32); 
        
        _fullReserveTextColor = Color.fromARGB(255, 211, 234, 245); 
        _fullReserveBorderColor = Color.fromARGB(255,172,205,254); 
        _emptyReserveGradientBackGroundColor1 = Color.fromARGB(255, 112, 113, 114);
        _emptyReserveGradientBackGroundColor2 = Color.fromARGB(232, 91, 92, 92);
        _emptyReserveBorderColor = Color.fromARGB(255, 105, 104, 104);

        /// MULTI COLOR TILES EXPERIMENT
        _tileGradientShade1Color1 = Color.fromARGB(225, 25, 66, 247);
        _tileGradientShade1Color2 = Color.fromARGB(255, 32, 65, 212); 

        _tileGradientShade2Color1 = Color.fromARGB(224, 40, 68, 194);
        _tileGradientShade2Color2 = Color.fromARGB(255, 55, 126, 192);

        _tileGradientShade3Color1 = Color.fromARGB(255, 26, 48, 143); 
        _tileGradientShade3Color2 = Color.fromARGB(224, 40, 68, 194);

        _tileGradientShade4Color1 = Color.fromARGB(223, 73, 96, 194);
        _tileGradientShade4Color2 = Color.fromARGB(223, 35, 54, 141);

        _tileGradientShade5Color1 = Color.fromARGB(223, 34, 57, 158);
        _tileGradientShade5Color2 = Color.fromARGB(255, 96, 141, 214);         
        _modalBgColor = const Color.fromARGB(255, 212, 211, 211);   
        _modalTextColor = Color.fromARGB(255, 46, 46, 46);       


        _timerRingColor = Colors.white;
        _timerRingGradient1 = Color.fromARGB(255, 116, 208, 254);
        _timerRingGradient2 = Color.fromARGB(255, 113, 167, 255);
        _timerFillColor = Colors.black;
        _timerFillGradient1 = Color.fromARGB(255, 26, 48, 143); 
        _timerFillGradient2 = Color.fromARGB(224, 40, 68, 194);


        _textColor1 = const Color.fromARGB(255, 32, 32, 32);
        _textColor2 = const Color.fromARGB(255, 71, 71, 71);
        _textColor3 = const Color.fromARGB(255, 88, 88, 88);
        // _appBarColor = const Color.fromRGBO(181, 199, 255, 1);

        _confettiColor1 = const Color.fromARGB(255, 41, 125, 252);
        _confettiColor2 = const Color.fromARGB(255, 100, 10, 10);
        _confettiColor3 = const Color.fromARGB(255, 43, 11, 102);
        _confettiColor4 = const Color.fromARGB(255, 120, 151, 207);

        break;
    }
    notifyListeners();
  }



  // dark color palette
  Color get dark_screenBackgroundColor1 => Color.fromARGB(255, 15, 8, 54);
  Color get dark_screenBackgroundColor2 => Color.fromARGB(255,55,11,160);
  Color get dark_optionButtonBgColor => const Color.fromARGB(255, 66, 66, 66);
  Color get dark_optionButtonBgColor2 => const Color.fromARGB(255, 43, 43, 43);
  Color get dark_textColor1 => const Color.fromARGB(255, 247, 247, 247);
  Color get dark_textColor2 => const Color.fromARGB(255, 211, 211, 211);
  Color get dark_appBarColor => const Color.fromARGB(255, 39, 39, 39);
  Color get dark_settingsScreenOptionColor1 => Color.fromARGB(255, 241, 187, 135);
  Color get dark_settingsScreenOptionColor2 => Color.fromARGB(255, 248, 224, 158);
  Color get dark_settingsScreenOptionColor3 => Color.fromARGB(255, 235, 191, 134);
  Color get dark_settingsScreenOptionColor4 => Color.fromARGB(255, 223, 178, 142);
  Color get dark_settingsScreenOptionTextColor => Color.fromARGB(255, 22, 22, 22);



// light color theme
  Color get light_screenBackgroundColor1 => Color.fromARGB(255, 138, 186, 231); 
  Color get light_screenBackgroundColor2 => Color.fromARGB(255, 200, 210, 231); 
  Color get light_optionButtonBgColor => const Color.fromRGBO(255, 255, 255, 1);
  Color get light_optionButtonBgColor2 => Color.fromARGB(255, 228, 233, 243);
  Color get light_textColor1 => const Color.fromARGB(255, 32, 32, 32);
  Color get light_textColor2 => const Color.fromARGB(255, 71, 71, 71);
  Color get light_appBarColor => const Color.fromRGBO(181, 199, 255, 1);

  Color get light_settingsScreenOptionColor3 => Color.fromARGB(225, 25, 66, 247);
  Color get light_settingsScreenOptionColor4 => Color.fromARGB(255, 32, 65, 212);
  Color get light_settingsScreenOptionColor1 => Color.fromARGB(224, 40, 68, 194);
  Color get light_settingsScreenOptionColor2 => Color.fromARGB(255, 55, 126, 192);
  Color get light_settingsScreenOptionTextColor => Color.fromARGB(255,175,207,254);








}


