// import 'package:circular_countdown_timer/custom_timer_painter.dart';
// import 'package:flutter/material.dart';
// import 'dart:math';

// import 'package:provider/provider.dart';
// import 'package:scribby_flutter_v2/providers/animation_state.dart';
// import 'package:scribby_flutter_v2/providers/game_play_state.dart';



// class CountDownTimer extends StatefulWidget {
//   const CountDownTimer({super.key});

//   @override
//   _CountDownTimerState createState() => _CountDownTimerState();
// }

// class _CountDownTimerState extends State<CountDownTimer> with TickerProviderStateMixin {
//   late AnimationState _animationState;
//   late GamePlayState _gamePlayState;
//   late AnimationController controller;
//   final Duration totalDuration = Duration(seconds: 10);


//   String get timerString {
//     // print(controller.value);
//     Duration duration = controller.duration!  * controller.value;
//     return '${totalDuration.inSeconds - duration.inSeconds}';
//   }

//   String getDuration(int totalDuration, int countdownDuration) {
//     return '${totalDuration - countdownDuration}';
//   }

//   @override
//   void initState() {
//     super.initState();
//     initializeAnimations();

//     _gamePlayState = Provider.of<GamePlayState>(context, listen: false);
//     _gamePlayState.addListener(_handleAnimationStateChange);

//     _animationState = Provider.of<AnimationState>(context, listen: false);
//     _animationState.addListener(_handleAnimationStateChange);


//   }

//   void initializeAnimations() {
//     controller = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 10),
//     );
//   }

//   void _runAnimations() {

//     if (_gamePlayState.isGamePaused) {
//       if (_gamePlayState.countdownDuration.inSeconds <= 10) {
//         controller.stop();
//       }
//     } else {
//       controller.reset();
//       controller.forward();
//     }
//     // if (_gamePlayState.countdownDuration.inSeconds) {
//     //   controller.stop();
//     // } else {
//       // if (controller.isAnimating) {
//       //   // controller.reset();
//       //   // controller.forward();
//       //   controller.stop();
//       // // }
//       // } else {
//       //   // controller.stop();
//       //   controller.reverse(from: controller.value == 0.0 ? 1.0 : controller.value);
//       // }    
//     // }

//   }

//   void _handleAnimationStateChange() {
//     if (_animationState.shouldRunAnimation) {
//       _runAnimations();
//     }

//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     ThemeData themeData = Theme.of(context);
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body:
//       Consumer<GamePlayState>(
//         builder: (context, gamePlayState, child) {

//         return AnimatedBuilder(
//             animation: controller,
//             builder: (context, child) {
//               return Stack(
//                 children: <Widget>[
//                   Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: <Widget>[
//                         Expanded(
//                           child: Align(
//                             alignment: FractionalOffset.center,
//                             child: AspectRatio(
//                               aspectRatio: 1.0,
//                               child: Stack(
//                                 children: <Widget>[
//                                   Positioned.fill(
//                                     child: CustomPaint(
//                                       painter: CustomTimerPainter(
//                                         animation: controller,
//                                         backgroundColor: const Color.fromARGB(255, 241, 94, 94),
//                                         color: Color.fromARGB(255, 226, 226, 226), // themeData.indicatorColor,
//                                       )
//                                     ),
//                                   ),
//                                   Align(
//                                     alignment: FractionalOffset.center,
//                                     child: Column( 
//                                       mainAxisAlignment:MainAxisAlignment.spaceEvenly,
//                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                       children: <Widget>[
//                                         Text(
//                                           // timerString,
//                                           getDuration(totalDuration.inSeconds, gamePlayState.countdownDuration.inSeconds),
//                                           // gamePlayState.countdownDuration.inSeconds.toString(),
//                                           style: TextStyle(
//                                               fontSize: 22.0,
//                                               color: Color.fromARGB(255, 255, 255, 255)),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               );
//             }
//           );
//         },
//       ),
//     );
//   }
// }


// class CustomTimerPainter extends CustomPainter {
//   CustomTimerPainter({
//     required this.animation,
//     required this.backgroundColor,
//     required this.color,
//   }) : super(repaint: animation);

//   final Animation<double> animation;
//   final Color backgroundColor, color;

//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()
//       ..color = backgroundColor
//       ..strokeWidth = 5.0
//       ..strokeCap = StrokeCap.butt
//       ..style = PaintingStyle.stroke;

//     canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
//     paint.color = color;
//     double progress = (1.0 - animation.value) * 2 * pi;
//     canvas.drawArc(Offset.zero & size, pi * 1.5, -progress, false, paint);
//   }

//   @override
//   bool shouldRepaint(CustomTimerPainter old) {
//     return animation.value != old.animation.value || color != old.color || backgroundColor != old.backgroundColor;
//   }
// }