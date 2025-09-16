import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';

class DailyPuzzleStatsSection extends StatefulWidget {
  final SettingsController settings;
  const DailyPuzzleStatsSection({
    super.key,
    required this.settings
  });

  @override
  State<DailyPuzzleStatsSection> createState() => _DailyPuzzleStatsSectionState();
}

class _DailyPuzzleStatsSectionState extends State<DailyPuzzleStatsSection> {

  // late SettingsController settings;
  late ColorPalette palette;
  late double scalor = 1.0;
  late List<dynamic> completedPuzzles = [];
  late int xpEarned = 0;
  late int streak = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // settings = Provider.of<SettingsController>(context, listen:false);
    palette = Provider.of<ColorPalette>(context, listen:false);
    scalor = Helpers().getScalor(widget.settings);


    // final Map<dynamic,dynamic> userData = widget.settings.userData.value as Map<dynamic,dynamic>;

    print("GAME HISTORY");

    // List<dynamic> gameHistory = userData["gameHistory"];
    List<dynamic> gameHistory = widget.settings.userGameHistory.value;
    completedPuzzles = [];

    for (dynamic game in gameHistory) {
      print(game);
      print("=========================");

      if(game["gameParameters"]["puzzleId"]!=null) {
        completedPuzzles.add(game);
        xpEarned = xpEarned + game["gameResultData"]["xp"] as int;
      }
    }

    print("???????????????????: $completedPuzzles");
    streak = calculateStreak(completedPuzzles);
  } 

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
    
        Expanded(
          flex: 1,
          child: Column(
            children: [
              Text(
                "Played",
                  style: palette.mainAppFont(
                    textStyle: TextStyle(
                      color: palette.text1,
                      fontSize: 18 * scalor
                    )
                  ),                                                
              ),
              Text(
                completedPuzzles.length.toString(),
                style: palette.mainAppFont(
                  textStyle: TextStyle(
                    color: palette.text1,
                    fontSize: 52 * scalor
                  )
                ),
              ),
            ]
          )
        ),
    
        Expanded(
          flex: 1,
          child: Column(
            children: [
              Text(
                "Streak",
                  style: palette.mainAppFont(
                    textStyle: TextStyle(
                      color: palette.text1,
                      fontSize: 18 * scalor
                    )
                  ),                                                
              ),
              Text(
                streak.toString(),
                style: palette.mainAppFont(
                  textStyle: TextStyle(
                    color: palette.text1,
                    fontSize: 52 * scalor
                  )
                ),
              ),
            ]
          )
        ),
    
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Text(
                "xpEarned",
                  style: palette.mainAppFont(
                    textStyle: TextStyle(
                      color: palette.text1,
                      fontSize: 18 * scalor
                    )
                  ),                                                
              ),
              Text(
                xpEarned.toString(),
                style: palette.mainAppFont(
                  textStyle: TextStyle(
                    color: palette.text1,
                    fontSize: 52 * scalor
                  )
                ),
              ),
            ]
          )
        ),                                                                               
      ],
    );

  }
}


int calculateStreak(List<dynamic> games) {

  if (games.isEmpty) return 0;

  // Extract unique dates (no time component)
  final completedDates = games
      .map((g) => DateTime(DateTime.parse(g["createdAt"]).year,DateTime.parse(g["createdAt"]).month,DateTime.parse(g["createdAt"]).day))
      .toSet();

  print("completedDates: $completedDates");
  final today = DateTime.now();
  final todayDate = DateTime(today.year, today.month, today.day);
  final yesterdayDate = todayDate.subtract(Duration(days: 1));

  // If no game was played yesterday, streak is zero
  if (!completedDates.contains(yesterdayDate)) {
    // Optional: add today if user already played today? No, streak still 0 until tomorrow
    return 1;
  }

  // Count consecutive days ending with yesterday
  int streak = 1;
  DateTime currentCheckDate = yesterdayDate.subtract(Duration(days: 1));

  while (completedDates.contains(currentCheckDate)) {
    streak++;
    currentCheckDate = currentCheckDate.subtract(Duration(days: 1));
  }

  // Add today if the user completed a game today
  if (completedDates.contains(todayDate)) {
    streak++;
  }



  return streak;
}
