import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';

class GameOverDataSection extends StatefulWidget {
  const GameOverDataSection({super.key});

  @override
  State<GameOverDataSection> createState() => _GameOverDataSectionState();
}

class _GameOverDataSectionState extends State<GameOverDataSection> {

  late SettingsController settings;
  late GamePlayState gamePlayState;
  late ColorPalette palette;
  late double scalor = 1.0;
  late double fontSize = 22.0; 
  late int score = 0;
  late int uniqueWords = 0;
  late int turns = 0;
  late int streak = 0;
  late int crosswords = 0;
  late int biggestTurn = 0;
  late String duration = "";  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    settings = Provider.of<SettingsController>(context,listen: false);
    gamePlayState = Provider.of<GamePlayState>(context,listen: false);
    palette = Provider.of<ColorPalette>(context, listen: false);
    scalor = Helpers().getScalor(settings);

    fontSize = 22.0 * scalor;
    // final String gameType = Helpers().capitalize(gamePlayState.gameParameters["gameType"]) ;
    score = Helpers().calculateScore(gamePlayState);
    uniqueWords = Helpers().countUniqueWords(gamePlayState);
    turns = Helpers().countTurns(gamePlayState);
    streak = Helpers().getLongestStreak(gamePlayState);
    crosswords = Helpers().countCrosswords(gamePlayState);
    biggestTurn = Helpers().getBiggestTurn(gamePlayState);
    duration = Helpers().formatDuration(gamePlayState.duration.inSeconds);    
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(33, 255, 255, 255),
          borderRadius: BorderRadius.all(Radius.circular(12.0*scalor)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
          
            summaryItem(Icons.gamepad, "Game Type", Helpers().capitalize(gamePlayState.gameParameters["gameType"]??"classic"),fontSize,palette ),
            summaryItem(Icons.library_books, "Unique Words",uniqueWords ,fontSize,palette ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth:500,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal:10.0*scalor ),
                child: Divider(),
              ),
            ),
          
            gamePlayState.gameParameters["gameType"]=="sprint"
            ? summaryItem(Icons.score, "Score", score, fontSize,palette )
            : summaryItem(Icons.timer, "Duration", duration,fontSize,palette ),
          
            summaryItem(Icons.control_point_rounded, "Turns", turns,fontSize,palette ),
            summaryItem(Icons.bar_chart, "Level", gamePlayState.currentLevel,fontSize,palette ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth:500,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal:10.0*scalor ),
                child: Divider(),
              ),
            ),
          
            summaryItem(Icons.bolt, "Longest Streak", streak,fontSize,palette ),
            summaryItem(Icons.close, "Crosswords", crosswords,fontSize,palette ),
            summaryItem(Icons.star, "Biggest Turn", biggestTurn,fontSize,palette ),
          
          ],
        ),
      ),
    );
  }
}



Widget summaryItem(IconData icon, String body, dynamic value, double size, ColorPalette palette) {
  Widget res = ConstrainedBox(
    constraints: BoxConstraints(
      maxWidth: 400
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: size),
      child: Container(
        child: Row(
          children: [
            Expanded(
              flex:2, 
              child: Align(
                alignment: Alignment.centerLeft,
                child: Icon(icon,size: size,color: palette.text1)
              )
            ),
            Expanded(
              flex:5, 
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  body, 
                  style: TextStyle(
                      color: palette.text1,
                      fontSize: size
                  ),
                  // textAlign: TextAlign.start,
                ),
              )
            ),
            Expanded(
              flex:3, 
              child: Align(
                alignment: Alignment.centerRight, 
                child: Text(
                  value.toString(), 
                  style: TextStyle(
                    fontSize: size,
                    color: palette.text1,
                  ),
                )
              )
            ),
          ],
        ),
      ),
    ),
  );
  return res;
}
