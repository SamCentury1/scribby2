// import 'package:flutter/material.dart';
// import 'package:scribby_flutter_v2/functions/game_logic_2.dart';
// import 'package:scribby_flutter_v2/functions/helpers.dart';
// import 'package:scribby_flutter_v2/providers/animation_state.dart';
// import 'package:scribby_flutter_v2/providers/game_play_state.dart';
// import 'package:scribby_flutter_v2/screens/game_over_screen/game_over_screen.dart';
// import 'package:scribby_flutter_v2/settings/settings.dart';
// import 'package:scribby_flutter_v2/styles/palette.dart';

// Future<void> quitGameDialog(
//   BuildContext context, 
//   ColorPalette palette, 
//   GamePlayState gamePlayState, 
//   AnimationState animationState, 
//   SettingsController settings
  
//   ) {
  
//   return showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       print("show quit game dialog");
//       return AlertDialog(
//         backgroundColor: palette.optionButtonBgColor,
//         title: Text(
//           Helpers().translateText(gamePlayState.currentLanguage, "Quit Game"),
//           style: TextStyle(fontSize: gamePlayState.tileSize*0.40, color: palette.textColor2),
//         ),
//         content: Text(
//           Helpers().translateText(gamePlayState.currentLanguage, "Are you sure you want to quit the game?",),
//           style: TextStyle(fontSize: gamePlayState.tileSize*0.35, color: palette.textColor2),
//         ),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () {
//               // GameLogic().executeGameOver(gamePlayState, context);

//               GameLogic().executeGameOver(gamePlayState, context);

//               gamePlayState.countDownController.pause();
//               gamePlayState.setDidUserQuitGame(true);
//               animationState.setShouldRunTimerAnimation(false);
              
              
//               gamePlayState.setIsGameOver(true);

              
//               Future.delayed(const Duration(milliseconds: 1500), () {
//                 // animationState.setShouldRunGameEndedAnimation(true);
//                 gamePlayState.endGame();
//                 gamePlayState.setTileState(settings.initialTileState.value as List<Map<String,dynamic>>);
//                 Navigator.of(context).pushReplacement(
//                     MaterialPageRoute(builder: (context) => const GameOverScreen())
//                   );        
//                 });       
                 
//             },
//             child: Text(
//               Helpers().translateText(gamePlayState.currentLanguage, "Yes",),
//               style: TextStyle(color: palette.textColor2, fontSize: gamePlayState.tileSize*0.3),
//             )
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: Text(
//               Helpers().translateText(gamePlayState.currentLanguage, "Cancel",),
//               style: TextStyle(color: palette.textColor2, fontSize: gamePlayState.tileSize*0.3),
//             )
//           ),
//         ],
//       );
//     }
//   );
// }

