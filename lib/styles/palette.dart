import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:scribby_flutter_v2/settings/settings.dart';

class Palette {
  /// ===================== LIGHT PALETTE ==================================
  /// Admin Screens
  Color get lightScreenBgColor => const Color.fromARGB(255, 231, 216, 255);
  Color get lightOptionButtonBgColor =>
      const Color.fromARGB(255, 209, 209, 209);
  Color get lightOptionButtonTextColor => const Color.fromARGB(255, 45, 0, 117);

  /// Game Screen
  Color get lightTileBgColor => const Color.fromARGB(255, 117, 13, 187);
  Color get lightTileBorderColor => const Color.fromARGB(255, 117, 13, 187);
  Color get lightTileTextColor => const Color.fromARGB(255, 249, 181, 255);
  Color get lightTimerTextColor => const Color.fromARGB(255, 211, 211, 211);

  Color get lightBottomNavigationBarColor =>
      const Color.fromARGB(255, 75, 3, 117);
  Color get lightBottomNavigationBarItemColor =>
      const Color.fromARGB(255, 204, 204, 204);

  Color get lightModalBgColor => const Color.fromARGB(255, 37, 1, 85);
  Color get lightModalTextColor => const Color.fromARGB(255, 212, 211, 211);

  Color get lightModalNavigationBarBgColor =>
      const Color.fromARGB(255, 78, 78, 78);
  Color get lightModalNavigationBarItemColor =>
      const Color.fromARGB(255, 253, 214, 40);

  /// ===================== DARK PALETTE ==================================
  /// Admin Screens
  Color get darkScreenBgColor => const Color.fromARGB(255, 15, 8, 54);
  Color get darkOptionButtonBgColor => const Color.fromARGB(255, 66, 66, 66);
  Color get darkOptionButtonTextColor =>
      const Color.fromARGB(255, 209, 209, 209);

  /// Game Screen
  Color get darkTileBgColor => const Color.fromARGB(255, 249, 181, 255);
  Color get darkTileBorderColor => const Color.fromARGB(255, 249, 181, 255);
  Color get darkTileTextColor => const Color.fromARGB(255, 117, 13, 187);
  Color get darkTimerTextColor => const Color.fromARGB(255, 230, 228, 228);

  Color get darkBottomNavigationBarColor =>
      const Color.fromARGB(255, 63, 3, 97);
  Color get darkBottomNavigationBarItemColor =>
      const Color.fromARGB(255, 253, 214, 40);

  Color get darkModalBgColor => const Color.fromARGB(255, 56, 4, 124);
  Color get darkModalTextColor => const Color.fromARGB(255, 212, 211, 211);

  Color get darkModalNavigationBarBgColor =>
      const Color.fromARGB(255, 78, 78, 78);
  Color get darkModalNavigationBarItemColor =>
      const Color.fromARGB(255, 218, 218, 218);

  /// =============================
}

class ColorPalette with ChangeNotifier {
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

  void getThemeColors(bool isDarkTheme) {
    switch (isDarkTheme) {
      case true:
        _screenBackgroundColor = const Color.fromARGB(255, 15, 8, 54);
        _optionButtonBgColor = const Color.fromARGB(255, 66, 66, 66);
        _optionButtonBgColor2 = const Color.fromARGB(255, 43, 43, 43);
        _optionButtonBgColor3 = const Color.fromARGB(255, 27, 27, 27);
        _optionButtonTextColor = const Color.fromARGB(255, 209, 209, 209);
        _tileBgColor = const Color.fromARGB(255, 249, 181, 255);
        _tileBorderColor = const Color.fromARGB(255, 249, 181, 255);
        _tileTextColor = const Color.fromARGB(255, 39, 39, 39);
        _timerTextColor = const Color.fromARGB(255, 230, 228, 228);
        _bottomNavigationBarColor = const Color.fromARGB(255, 15, 8, 54);
        _bottomNavigationBarItemColor =
            const Color.fromARGB(255, 196, 196, 196);
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
        break;
      case false:
        _screenBackgroundColor = const Color.fromARGB(255, 186, 217, 231);
        _optionButtonBgColor = const Color.fromARGB(255, 209, 209, 209);
        _optionButtonBgColor2 = const Color.fromARGB(255, 228, 227, 227);
        _optionButtonBgColor3 = const Color.fromARGB(255, 209, 209, 209);
        _optionButtonTextColor = const Color.fromARGB(255, 46, 46, 46);
        _tileBgColor = const Color.fromARGB(255, 35, 42, 141);
        _tileBorderColor = const Color.fromARGB(255, 35, 42, 141);
        _tileTextColor = const Color.fromARGB(255, 235, 235, 235);
        _timerTextColor = const Color.fromARGB(255, 34, 34, 34);
        _bottomNavigationBarColor = const Color.fromARGB(255, 186, 217, 231);
        _bottomNavigationBarItemColor = const Color.fromARGB(255, 3, 48, 143);
        _modalBgColor = const Color.fromARGB(255, 173, 228, 238);
        _modalTextColor = const Color.fromARGB(255, 99, 99, 99);
        _modalNavigationBarBgColor = const Color.fromARGB(255, 96, 105, 121);
        _modalNavigationBarItemColor = const Color.fromARGB(255, 235, 235, 235);
        _textColor1 = const Color.fromARGB(255, 32, 32, 32);
        _textColor2 = const Color.fromARGB(255, 71, 71, 71);
        _textColor3 = const Color.fromARGB(255, 88, 88, 88);
        _appBarColor = const Color.fromARGB(255, 165, 165, 165);

        _confettiColor1 = const Color.fromARGB(255, 41, 125, 252);
        _confettiColor2 = const Color.fromARGB(255, 100, 10, 10);
        _confettiColor3 = const Color.fromARGB(255, 43, 11, 102);
        _confettiColor4 = const Color.fromARGB(255, 120, 151, 207);
        break;
    }
    notifyListeners();
  }
}



// class LightPalette {


//   /// ===================== LIGHT PALETTE ==================================
//   /// Admin Screens
//   Color get screenBgColor => Color.fromARGB(255, 231, 216, 255);
//   Color get optionButtonBgColor => Color.fromARGB(255, 209, 209, 209);
//   Color get optionButtonTextColor => Color.fromARGB(255, 45, 0, 117);

//   /// Game Screen
//   Color get tileBgColor => Color.fromARGB(255, 117, 13, 187);
//   Color get tileBorderColor => Color.fromARGB(255, 117, 13, 187);
//   Color get tileTextColor => Color.fromARGB(255, 249, 181, 255);
//   Color get timerTextColor => Color.fromARGB(255, 211, 211, 211);

//   Color get bottomNavigationBarColor => Color.fromARGB(255, 75, 3, 117);
//   Color get bottomNavigationBarItemColor => Color.fromARGB(255, 204, 204, 204);

//   Color get modalBgColor => Color.fromARGB(255, 37, 1, 85);
//   Color get modalTextColor => Color.fromARGB(255, 212, 211, 211);

//   Color get modalNavigationBarBgColor => Color.fromARGB(255, 78, 78, 78);
//   Color get modalNavigationBarItemColor => Color.fromARGB(255, 253, 214, 40);
    
// }


// class DarkPalette {
//   Color get screenBgColor => Color.fromARGB(255, 15, 8, 54);
//   Color get optionButtonBgColor => Color.fromARGB(255, 66, 66, 66);
//   Color get optionButtonTextColor => Color.fromARGB(255, 209, 209, 209);

//   /// Game Screen
//   Color get tileBgColor => Color.fromARGB(255, 249, 181, 255);
//   Color get tileBorderColor => Color.fromARGB(255, 249, 181, 255);
//   Color get tileTextColor => Color.fromARGB(255, 117, 13, 187);
//   Color get timerTextColor => Color.fromARGB(255, 230, 228, 228);

//   Color get bottomNavigationBarColor => Color.fromARGB(255, 75, 3, 117);
//   Color get bottomNavigationBarItemColor => Color.fromARGB(255, 253, 214, 40);

//   Color get modalBgColor => Color.fromARGB(255, 56, 4, 124);
//   Color get modalTextColor => Color.fromARGB(255, 212, 211, 211);

//   Color get modalNavigationBarBgColor => Color.fromARGB(255, 78, 78, 78);
//   Color get modalNavigationBarItemColor => Color.fromARGB(255, 218, 218, 218);
  
// }
