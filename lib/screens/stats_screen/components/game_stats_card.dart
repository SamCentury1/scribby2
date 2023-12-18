// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:scribby_flutter_v2/functions/game_logic.dart';
// import 'package:scribby_flutter_v2/settings/settings.dart';
// import 'package:scribby_flutter_v2/styles/palette.dart';

// class GameStatsCard extends StatefulWidget {
//   final int index;
//   final Map<String,dynamic> gameData;
//   final SettingsController settings;
//   final Palette palette;
//   const GameStatsCard({
//     super.key,
//     required this.index,
//     required this.gameData,
//     required this.settings,
//     required this.palette,
//   });

//   @override
//   State<GameStatsCard> createState() => _GameStatsCardState();
// }

// class _GameStatsCardState extends State<GameStatsCard> {

//   late String gameDateText;
//   late String durationText;

//   @override
//   void initState() {
//     super.initState();
//     gameDateText = DateFormat.yMMMd().format(DateTime.parse(widget.gameData['timeStamp']),);
//     durationText = getDurationText(widget.gameData["duration"].toString());
//     // print(gameDateText);
//   }


//   String getDurationText(data) {
//     int res = int.parse(data);

//     late String min;
//     late String sec;

//     double minutes = res / 60;
//     int minutesText = minutes.floor();
//     int secondsLeft = res % 60;
//     if (minutesText < 10 ) {
//       min = "0$minutesText";
//     } else {
//       min = minutesText.toString();
//     }

//     if (secondsLeft < 10) {
//       sec = "0$secondsLeft";
//     } else {
//       sec = secondsLeft.toString();
//     }
//     // print("$min : $sec");
//     return "$min:$sec";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Card(
//         // color: GameLogic().getColor(widget.settings.darkTheme.value, widget.palette, "option_button_bg"),

//         child: ListTile(
//           leading: Text(
//             "${(widget.index+1).toString()}.",
//             style: TextStyle(
//               fontSize: 18,
//               color: GameLogic().getColor(widget.settings.darkTheme.value, widget.palette, "timer_text"),
//             ),
//           ),
//           title: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "${widget.gameData['points']}",
//                 style: TextStyle(
//                   fontSize: 22,
//                   color: GameLogic().getColor(widget.settings.darkTheme.value, widget.palette, "timer_text"),
//                 ),
//               ),
//               Row(
//                 children: [
//                   Icon(
//                     Icons.timer,
//                     size: 16,
//                     color: GameLogic().getColor(widget.settings.darkTheme.value, widget.palette, "timer_text"),
//                   ),
//                   SizedBox(width: 10,),
//                   Text(
//                     // "${widget.gameData['duration']}",
//                     getDurationText(widget.gameData["duration"].toString()),
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: GameLogic().getColor(widget.settings.darkTheme.value, widget.palette, "timer_text"),
//                     ),
//                   ),              
//                 ],
//               ),
//               Row(
//                 children: [
//                   Icon(
//                     Icons.book_online,
//                     size: 16,
//                     color: GameLogic().getColor(widget.settings.darkTheme.value, widget.palette, "timer_text"),
//                   ),
//                   SizedBox(width: 10,),
//                   Text(
//                     // "${widget.gameData['duration']}",
//                     "${widget.gameData['uniqueWords']} words",
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: GameLogic().getColor(widget.settings.darkTheme.value, widget.palette, "timer_text"),
//                     ),
//                   ),              
//                 ],
//               ),              
//             ],
//           ),
//           trailing: Text(
//             "${DateFormat.yMMMd().format(DateTime.parse(widget.gameData['timeStamp']))}",
//             style: TextStyle(
//               fontSize: 14,
//               color: GameLogic().getColor(widget.settings.darkTheme.value, widget.palette, "timer_text"),
//             ),            
//           ),
//         ),
    
//       ),
//     );
//   }
// }