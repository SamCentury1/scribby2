import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/functions/initializations.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/screens/game_screen/game_screen.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';

class GameFailedSection extends StatefulWidget {
  const GameFailedSection({super.key});

  @override
  State<GameFailedSection> createState() => _GameFailedSectionState();
}

class _GameFailedSectionState extends State<GameFailedSection> {

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
  late int target = 0;
  late int gap = 0;
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
    target =  gamePlayState.gameParameters['target'];
    gap = target-score;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        // decoration: BoxDecoration(
        //   color: const Color.fromARGB(33, 255, 255, 255),
        //   borderRadius: BorderRadius.all(Radius.circular(12.0*scalor)),
        // ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
              Text(
                "You came $gap points short of reaching the objective!",
                style: palette.mainAppFont(
                  textStyle: TextStyle(
                    fontSize: 32 * scalor,
                    color: palette.text1
                  )
                ),
                textAlign: TextAlign.center,
              ),

              Text(
                "You'll get it next time...",
                style: palette.mainAppFont(
                  textStyle: TextStyle(
                    fontSize: 22 * scalor,
                    color: palette.text1
                  )
                ),
                textAlign: TextAlign.center,
              ),

              Padding(
                padding: EdgeInsets.symmetric(vertical: 2.0*scalor),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: palette.navigationButtonBg3, //const Color.fromARGB(255, 220, 220, 223),
                      foregroundColor: palette.navigationButtonText3, // const Color.fromARGB(255, 44, 34, 185),
                      textStyle: palette.mainAppFont(
                        textStyle: TextStyle(
                          fontSize: 24 * scalor
                        )
                      ),                                    
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8*scalor)),
                      ),
                      minimumSize: Size(200*scalor,50*scalor)
                    ),                          
                    onPressed: () {

                      try {
                        Map<String,dynamic> gameParameters = Map<String,dynamic>.from(gamePlayState.gameParameters);
                        gamePlayState.refreshAllData2();
                        Initializations().startGame(
                          gamePlayState, 
                          gameParameters['gameType'],
                          gameParameters['durationInMinutes'], 
                          gameParameters['target'], 
                          gameParameters['rows'],
                          gameParameters['columns'],
                          gameParameters['timeToPlace'], 
                          gameParameters['puzzleId'], 
                          settings,
                          gameParameters['mediaQueryData'],
                          context,
                          palette
                        );
                    //  when restarting a daily puzzle -> when restarted game gets scored it is not scored as a daily puzzle
                      } catch (e,s) {
                        Helpers().printError('restarting game in game failed section', e, s);
                      }                      
                    }, 
                    child: Text("Try Again?")
                  ),
                ),
              ), 
          
          ],
        ),
      ),
    );
  }
}



