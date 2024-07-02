import 'package:flutter/material.dart';


class ColorPalette with ChangeNotifier {

  late Color _screenGradientBackgroundColor1 = Colors.transparent;
  Color get screenGradientBackgroundColor1 => _screenGradientBackgroundColor1;

  late Color _screenGradientBackgroundColor2 = Colors.transparent;
  Color get screenGradientBackgroundColor2 => _screenGradientBackgroundColor2;


  // FULL TILE
  late Color _fullTileGradientBackGroundColor1 = Colors.transparent;
  Color get fullTileGradientBackGroundColor1 => _fullTileGradientBackGroundColor1;  

  late Color _fullTileGradientBackGroundColor2 = Colors.transparent;
  Color get fullTileGradientBackGroundColor2 => _fullTileGradientBackGroundColor2; 

  late Color _fullTileTextColor = Colors.transparent;
  Color get fullTileTextColor => _fullTileTextColor;

  late Color _fullTileBorderColor = Colors.transparent;
  Color get fullTileBorderColor => _fullTileBorderColor;       

  late Color _emptyTileGradientBackGroundColor1 = Colors.transparent;
  Color get emptyTileGradientBackGroundColor1 => _emptyTileGradientBackGroundColor1;  

  late Color _emptyTileGradientBackGroundColor2 = Colors.transparent;
  Color get emptyTileGradientBackGroundColor2 => _emptyTileGradientBackGroundColor2;  

  late Color _emptyTileBorderColor = Colors.transparent;
  Color get emptyTileBorderColor => _emptyTileBorderColor;

  // RESERVE
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

  late Color _deadTileGradientBackGroundColor1 = Colors.transparent;
  Color get deadTileGradientBackGroundColor1 => _deadTileGradientBackGroundColor1;  

  late Color _deadTileGradientBackGroundColor2 = Colors.transparent;
  Color get deadTileGradientBackGroundColor2 => _deadTileGradientBackGroundColor2;   

  /// TRYING SOMETHING OUT WITH DIFFERENT SHADES
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


  //// NAVIGATION BAR FOR MODALS
  late Color _navigationBarColor = Colors.transparent;
  Color get navigationBarColor => _navigationBarColor;   

  late Color _navigationBarItemUnselected = Colors.transparent;
  Color get navigationBarItemUnselected => _navigationBarItemUnselected;   

  late Color _navigationBarItemSelected = Colors.transparent;
  Color get navigationBarItemSelected => _navigationBarItemSelected;       
  
          



//// ========================================================================
//// ======================== OLD STUFF ===================================== 
//// ========================================================================
  late Color _screenBackgroundColor = Colors.transparent;
  Color get screenBackgroundColor => _screenBackgroundColor;

  late Color _optionButtonBgColor = Colors.transparent;
  Color get optionButtonBgColor => _optionButtonBgColor;

  late Color _optionButtonBgColor2 = Colors.transparent;
  Color get optionButtonBgColor2 => _optionButtonBgColor2;

  late Color _optionButtonBgColor3 = Colors.transparent;
  Color get optionButtonBgColor3 => _optionButtonBgColor3;

  late Color _optionButtonTextColor = Colors.transparent;
  Color get optionButtonTextColor => _optionButtonTextColor;

  late Color _tileBgColor = Colors.transparent;
  Color get tileBgColor => _tileBgColor;

  late Color _tileBorderColor = Colors.transparent;
  Color get tileBorderColor => _tileBorderColor;

  late Color _tileTextColor = Colors.transparent;
  Color get tileTextColor => _tileTextColor;

  late Color _timerTextColor = Colors.transparent;
  Color get timerTextColor => _timerTextColor;

  late Color _bottomNavigationBarColor = Colors.transparent;
  Color get bottomNavigationBarColor => _bottomNavigationBarColor;

  late Color _bottomNavigationBarItemColor = Colors.transparent;
  Color get bottomNavigationBarItemColor => _bottomNavigationBarItemColor;

  late Color _modalBgColor = Colors.transparent;
  Color get modalBgColor => _modalBgColor;

  late Color _modalTextColor = Colors.transparent;
  Color get modalTextColor => _modalTextColor;

  late Color _modalNavigationBarBgColor = Colors.transparent;
  Color get modalNavigationBarBgColor => _modalNavigationBarBgColor;

  late Color _modalNavigationBarItemColor = Colors.transparent;
  Color get modalNavigationBarItemColor => _modalNavigationBarItemColor;

  late Color _textColor1 = Colors.transparent;
  Color get textColor1 => _textColor1;

  late Color _textColor2 = Colors.transparent;
  Color get textColor2 => _textColor2;

  late Color _textColor3 = Colors.transparent;
  Color get textColor3 => _textColor3;

  late Color _appBarColor = Colors.transparent;
  Color get appBarColor => _appBarColor;

  late Color _confettiColor1 = Colors.transparent;
  Color get confettiColor1 => _confettiColor1;

  late Color _confettiColor2 = Colors.transparent;
  Color get confettiColor2 => _confettiColor2;

  late Color _confettiColor3 = Colors.transparent;
  Color get confettiColor3 => _confettiColor3;

  late Color _confettiColor4 = Colors.transparent;
  Color get confettiColor4 => _confettiColor4;

  late Color _focusedTutorialTile = Colors.transparent;
  Color get focusedTutorialTile => _focusedTutorialTile;

  void getThemeColors(bool isDarkTheme) {
    switch (isDarkTheme) {
      case true:
        _screenGradientBackgroundColor1 = Color.fromARGB(255, 15, 8, 54);
        _screenGradientBackgroundColor2 = Color.fromARGB(255,55,11,160);

        _fullTileGradientBackGroundColor1 = Color.fromARGB(255,170,72,247);
        _fullTileGradientBackGroundColor2 = Color.fromARGB(255,205,52,240,);

        _fullTileTextColor = Color(0xffeabef6);
        _fullTileBorderColor = Color(0xffeabef6);

        _emptyTileGradientBackGroundColor1 = Color.fromARGB(255, 122, 36, 207);
        _emptyTileGradientBackGroundColor2 = Color.fromARGB(255, 119, 36, 204);
        _emptyTileBorderColor = Color.fromARGB(255, 119, 36, 204);

        _deadTileGradientBackGroundColor1 = Color.fromARGB(255, 145, 145, 145);
        _deadTileGradientBackGroundColor2 = Color.fromARGB(255, 75, 75, 75);

        /// RESERVES
        _fullReserveGradientBackGroundColor1 = Color.fromARGB(223, 118, 12, 160); 
        _fullReserveGradientBackGroundColor2 = Color.fromARGB(255, 169, 24, 182); 
        _fullReserveGradientBackGroundColor3 = Color.fromARGB(223, 118, 21, 156); 
        _fullReserveGradientBackGroundColor4 = Color.fromARGB(255, 143, 18, 155); 
        _fullReserveGradientBackGroundColor5 = Color.fromARGB(223, 101, 15, 134);                


        _fullReserveTextColor = Color(0xffeabef6); 
        _fullReserveBorderColor =  Color.fromARGB(255, 158, 67, 184);
        _emptyReserveGradientBackGroundColor1 = Color.fromARGB(200, 221, 171, 228);
        _emptyReserveGradientBackGroundColor2 = Color.fromARGB(232, 224, 206, 235);
        _emptyReserveBorderColor = Color.fromARGB(255, 105, 104, 104);


        /// MULTI COLOR TILES EXPERIMENT
        _tileGradientShade1Color1 = Color.fromARGB(255, 171, 91, 231);
        _tileGradientShade1Color2 = Color.fromARGB(255,205,52,240,);

        _tileGradientShade2Color1 = Color.fromARGB(255, 170, 88, 187);
        _tileGradientShade2Color2 = Color.fromARGB(255, 211, 98, 196);

        _tileGradientShade3Color1 = Color.fromARGB(255, 140, 90, 179);
        _tileGradientShade3Color2 = Color.fromARGB(255, 170, 60, 165);

        _tileGradientShade4Color1 = Color.fromARGB(255,170,72,247);
        _tileGradientShade4Color2 = Color.fromARGB(255, 168, 93, 162);

        _tileGradientShade5Color1 = Color.fromARGB(255, 178, 128, 216);
        _tileGradientShade5Color2 = Color.fromARGB(255, 193, 106, 212);

        _navigationBarColor = Color.fromARGB(255, 36, 36, 36);
        _navigationBarItemUnselected = Color.fromARGB(255, 199, 198, 198);
        _navigationBarItemSelected = Color.fromARGB(255, 235, 137, 255);


        ///  ================== OLD STUFF =========================
        _screenBackgroundColor = const Color.fromARGB(255, 15, 8, 54);
        // _screenBackgroundColor = const Color.fromRGBO(57, 10, 111, 1);
        _optionButtonBgColor = const Color.fromARGB(255, 66, 66, 66);
        _optionButtonBgColor2 = const Color.fromARGB(255, 43, 43, 43);
        _optionButtonBgColor3 = const Color.fromARGB(255, 27, 27, 27);
        _optionButtonTextColor = const Color.fromARGB(255, 209, 209, 209);
        _tileBgColor = const Color.fromARGB(255, 249, 181, 255);
        _tileBorderColor = const Color.fromARGB(255, 249, 181, 255);
        _tileTextColor = const Color.fromARGB(255, 39, 39, 39);
        _timerTextColor = const Color.fromARGB(255, 230, 228, 228);
        _bottomNavigationBarColor = const Color.fromARGB(255, 15, 8, 54);
        _bottomNavigationBarItemColor =const Color.fromARGB(255, 196, 196, 196);
        _modalBgColor = const Color.fromARGB(255, 56, 4, 124);
        _modalTextColor = const Color.fromARGB(255, 212, 211, 211);
        _modalNavigationBarBgColor = const Color.fromARGB(255, 78, 78, 78);
        _modalNavigationBarItemColor = const Color.fromARGB(255, 218, 218, 218);
        _textColor1 = const Color.fromARGB(255, 247, 247, 247);
        _textColor2 = const Color.fromARGB(255, 211, 211, 211);
        _textColor3 = const Color.fromARGB(255, 185, 184, 184);
        _appBarColor = const Color.fromARGB(255, 39, 39, 39);

        _confettiColor1 = const Color.fromARGB(255, 243, 104, 248);
        _confettiColor2 = const Color.fromARGB(255, 165, 242, 255);
        _confettiColor3 = const Color.fromARGB(255, 64, 52, 233);
        _confettiColor4 = const Color.fromARGB(255, 161, 59, 245);

        _focusedTutorialTile = Color.fromARGB(255, 255, 255, 255);
        break;
      case false:
        /// TILES
        _screenGradientBackgroundColor1 = Color.fromARGB(255, 138, 186, 231);
        _screenGradientBackgroundColor2 = Color.fromARGB(255, 200, 210, 231);

        _fullTileGradientBackGroundColor1 = Color.fromARGB(255, 25,113,247);
        _fullTileGradientBackGroundColor2 = Color.fromARGB(255,78,147,255);

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
        
        _fullReserveTextColor = Color.fromARGB(255, 175, 229, 254); 
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


        _navigationBarColor = Color.fromARGB(255, 25, 88, 204);
        _navigationBarItemUnselected = Color.fromARGB(255, 143, 141, 141);
        _navigationBarItemSelected = Color.fromARGB(255, 156, 215, 255);


        ///  ================== OLD STUFF =========================
        _screenBackgroundColor = const Color.fromRGBO(236, 242, 255,1);
        _optionButtonBgColor = const Color.fromRGBO(255, 255, 255, 1);
        _optionButtonBgColor2 = Color.fromARGB(255, 179, 195, 255);
        _optionButtonBgColor3 = Color.fromARGB(255, 138, 165, 255);
        _optionButtonTextColor = const Color.fromARGB(255, 46, 46, 46);
        _tileBgColor = const Color.fromARGB(255, 35, 42, 141);
        _tileBorderColor = const Color.fromARGB(255, 35, 42, 141);
        _tileTextColor = Color.fromARGB(255, 201, 199, 199);
        _timerTextColor = const Color.fromARGB(255, 34, 34, 34);
        _bottomNavigationBarColor = const Color.fromARGB(255, 186, 217, 231);
        _bottomNavigationBarItemColor = const Color.fromARGB(255, 3, 48, 143);
        _modalBgColor = const Color.fromARGB(255, 173, 228, 238);
        _modalTextColor = const Color.fromARGB(255, 99, 99, 99);
        _modalNavigationBarBgColor = Color.fromARGB(255, 184, 185, 187);
        _modalNavigationBarItemColor = const Color.fromARGB(255, 235, 235, 235);
        _textColor1 = const Color.fromARGB(255, 32, 32, 32);
        _textColor2 = const Color.fromARGB(255, 71, 71, 71);
        _textColor3 = const Color.fromARGB(255, 88, 88, 88);
        _appBarColor = const Color.fromRGBO(181, 199, 255, 1);

        _confettiColor1 = const Color.fromARGB(255, 41, 125, 252);
        _confettiColor2 = const Color.fromARGB(255, 100, 10, 10);
        _confettiColor3 = const Color.fromARGB(255, 43, 11, 102);
        _confettiColor4 = const Color.fromARGB(255, 120, 151, 207);

        _focusedTutorialTile = Color.fromARGB(255, 255, 255, 255);
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
  Color get dark_settingsScreenOptionColor1 => Color.fromARGB(255, 171, 91, 231);
  Color get dark_settingsScreenOptionColor2 => Color.fromARGB(255,205,52,240,);
  Color get dark_settingsScreenOptionColor3 => Color.fromARGB(255, 170, 88, 187);
  Color get dark_settingsScreenOptionColor4 => Color.fromARGB(255, 211, 98, 196);
  Color get dark_settingsScreenOptionTextColor => Color(0xffeabef6);



// light color theme
  Color get light_screenBackgroundColor1 => Color.fromARGB(255, 138, 186, 231); //const Color.fromRGBO(236, 242, 255,1);
  Color get light_screenBackgroundColor2 => Color.fromARGB(255, 200, 210, 231); //const Color.fromRGBO(236, 242, 255,1);
  Color get light_optionButtonBgColor => const Color.fromRGBO(255, 255, 255, 1);
  // Color get light_optionButtonBgColor2 => Color.fromARGB(255, 212, 222, 252);
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


