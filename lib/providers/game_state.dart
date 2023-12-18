
// import 'dart:async';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';

// class GameState with ChangeNotifier {

//   bool _isGamePaused = true;
//   bool get isGamePaused => _isGamePaused;

//   void setIsGamePaused(bool value, int page) {
//     _isGamePaused = value;
//     if (value != true) {
//       Future.delayed(const Duration(milliseconds: 300), () {
//         _pageController.jumpToPage(0);
//       });
//     } else {
//       Future.delayed(const Duration(milliseconds: 0), () {
//         _pageController.jumpToPage(page);
//       });      
//     }
//     notifyListeners();
//   }

//   bool _isGameStarted = false;
//   bool get isGameStarted => _isGameStarted;

//   void setIsGameStarted(bool value) {
//     _isGameStarted = value;
//     notifyListeners();
//   }

//   late PageController _pageController = PageController();
//   PageController get pageController => _pageController;

//   void setPageController(PageController value) {
//     _pageController = value;
//     notifyListeners();
//   }



//   Duration _duration = Duration();
//   Timer? _timer;
//   // bool _isPaused = false;

//   Duration get duration => _duration;
//   Timer get timer => _timer!;


//   // bool get isPaused => _isPaused;

//   // TimerProvider() {
//   //   startTimer();
//   // }

//   void addTick() {
//     if (!_isGamePaused) {
//       const int addSeconds = 1;
//       final int seconds = _duration.inSeconds + addSeconds;
//       _duration = Duration(seconds: seconds);
//       notifyListeners();
//     }
//   }

//   void stopTimer() {
//     _timer?.cancel();
//   }

//   void restartGame() {
//     _timer?.cancel();
//     _isGamePaused = true;
//     _isGameStarted = false;
//     _duration = Duration();
//     _pageController.jumpToPage(0);

//     notifyListeners();

//   }  

//   void startTimer() {
//     _timer?.cancel();
//     _timer = Timer.periodic(Duration(seconds: 1), (_) => addTick());
//   }

//   void resetTimer() {
//     _duration = const Duration(); // Resetting the duration to 0
//     notifyListeners();
//   }


//   void pauseTimer() {
//     _isGamePaused = true;
//   }

//   void resumeTimer() {
//     _isGamePaused = false;
//   }

//   void endGame() {
//     _isGamePaused = true;
//     _isGameStarted = false;
//     _duration = const Duration();
//     _timer?.cancel();
//     // _timer = null;
//     // notifyListeners();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }
// }
