// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:scribby_flutter_v2/components/daily_puzzle_ranking_future.dart';
// import 'package:scribby_flutter_v2/functions/helpers.dart';
// import 'package:scribby_flutter_v2/providers/game_play_state.dart';
// import 'package:scribby_flutter_v2/providers/palette_state.dart';
// import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
// import 'package:scribby_flutter_v2/resources/storage_methods.dart';
// import 'package:scribby_flutter_v2/settings/settings.dart';

// class DailyPuzzleRankingSection extends StatefulWidget {
//   final Map<String,dynamic> gameData;
//   const DailyPuzzleRankingSection({
//     required this.gameData,
//     super.key,
//   });

//   @override
//   State<DailyPuzzleRankingSection> createState() => _DailyPuzzleRankingSectionState();
// }

// class _DailyPuzzleRankingSectionState extends State<DailyPuzzleRankingSection> {

//   late SettingsController settings;
//   late GamePlayState gamePlayState;
//   late ColorPalette palette;
//   late double scalor = 1.0;

//   late Map<dynamic,dynamic> puzzleObject = {};


//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     settings = Provider.of<SettingsController>(context,listen: false);
//     gamePlayState = Provider.of<GamePlayState>(context,listen: false);
//     palette = Provider.of<ColorPalette>(context, listen: false);
//     scalor = Helpers().getScalor(settings);

//     // puzzleObject = StorageMethods().getSpecificPuzzle(settings,widget.a);
//     print("===================== puzzleObject ====================");
//     print(puzzleObject);
//     print("=================================================");

//     // loadDailyPuzzles(settings);
//   }


//   String formatTitle(Map<dynamic,dynamic> puzzleObject) {
//     String res = "";
//     var localeDate = DateTime.parse(puzzleObject["date"]);
//     String dateWeekday = DateFormat.EEEE().format(localeDate);
//     String dateMonth = DateFormat.MMM().format(localeDate);
//     String dateDay = DateFormat.d().format(localeDate);
//     return "$dateWeekday, $dateMonth. $dateDay (${puzzleObject["difficulty"]})";
//   }


//   @override
//   Widget build(BuildContext context) {
//       return DailyPuzzleRankingFuture(gameData: widget.gameData);
//   }
// }

