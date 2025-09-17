import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/functions/initializations.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/screens/statistics_screen.dart/components/game_summary_card.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';

class DailyPuzzleCard extends StatefulWidget {
  final Map<dynamic,dynamic> puzzleObject;
  final MediaQueryData mediaQueryData;
  const DailyPuzzleCard({
    super.key,
    required this.puzzleObject,
    required this.mediaQueryData,
  });

  @override
  State<DailyPuzzleCard> createState() => _DailyPuzzleCardState();
}

class _DailyPuzzleCardState extends State<DailyPuzzleCard> {

  late SettingsController settings;
  late GamePlayState gamePlayState;
  late ColorPalette palette;
  late double scalor = 1.0;
  late List<dynamic> puzzlesPlayed = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState(); 
    settings = Provider.of<SettingsController>(context, listen: false);
    gamePlayState = Provider.of<GamePlayState>(context, listen: false);
    palette = Provider.of<ColorPalette>(context, listen: false);
    scalor = Helpers().getScalor(settings);
    WidgetsBinding.instance.addPostFrameCallback((_) {

      puzzlesPlayed = settings.userGameHistory.value
        .where((e)=>e["gameParameters"]["puzzleId"]!=null)
        .map((e)=>e["gameParameters"]["puzzleId"])
        .toList();


      print("level name: ${widget.puzzleObject}");
      if (puzzlesPlayed.contains(widget.puzzleObject["levelName"])) {
        // didPlayPuzzle = true;
        print("this was played");
      }
    });
    

    
  }

  @override
  Widget build(BuildContext context) {
    if (widget.puzzleObject.isNotEmpty) {

      List<dynamic> gameHistory = settings.userGameHistory.value;
      Map<String,dynamic> matchingPuzzleObjects = settings.userGameHistory.value.firstWhere(
        (e)=>e["gameParameters"]["puzzleId"]==widget.puzzleObject["levelName"],
        orElse: ()=><String,dynamic>{}
      );
      // Map<String,dynamic> matchingPuzzleObjects2 = {};
      // late String score = "";
      // if (matchingPuzzleObjects.isNotEmpty) {
      //   matchingPuzzleObjects2 =;
      // }


      if (puzzlesPlayed.contains(widget.puzzleObject["levelName"])) {
        return GameSummaryCard(gameData: matchingPuzzleObjects, palette: palette);
      } else {
        return Row(
          children: [
            Expanded(
              flex: 2,
              child: SizedBox(
                // height: 200 * scalor,
                child: Padding(
                  padding: EdgeInsets.all(4.0*scalor),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(9.0*scalor))
                    ),
                    elevation: 10.0,
                    shadowColor: const Color.fromARGB(255, 65, 65, 65),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [palette.widget1, palette.widget1],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          // stops: [0.5,0.99]
                        ),

                        borderRadius: BorderRadius.circular(9.0*scalor),
                      ),
                      child: Padding(
                        padding:  EdgeInsets.all(16.0*scalor),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    formatTitle(widget.puzzleObject),
                                    style: palette.mainAppFont(
                                      textStyle: TextStyle(
                                        fontSize: 22* scalor,
                                        color: palette.widgetText1
                                      )
                                    ),
                                  ),
                                ),
                      
                                // getDifficultyStars(todayPuzzle["difficulty"],palette)
                              ],
                            ),
                      
                            SizedBox(height: 15,),
                            Helpers().getGameObjectiveString(
                              widget.puzzleObject["gameType"],
                              widget.puzzleObject["duration"],
                              widget.puzzleObject["target"],
                              widget.puzzleObject["timeToPlace"],
                              palette
                            ),
                            // getDescription(todayPuzzle,palette),
                            SizedBox(height: 15,),
                            SizedBox(
                              width: double.infinity,
                              child: Wrap(
                                spacing: 3.0,
                                alignment: WrapAlignment.start,
                                runAlignment: WrapAlignment.start,
                                children: [
                                  
                                  widget.puzzleObject["timeToPlace"]!=null?
                                  paramWidget(Icons.timer, "${widget.puzzleObject['timeToPlace']}s", palette) : SizedBox(),
                              
                                  widget.puzzleObject["target"] != null?
                                  paramWidget(Icons.wifi_tethering, widget.puzzleObject["target"], palette) : SizedBox(),
                              
                                  widget.puzzleObject["duration"] != null?
                                  paramWidget(Icons.access_time, Helpers().formatDuration(widget.puzzleObject["duration"]*60), palette ):SizedBox(),
                      
                                  paramWidget(Icons.window,  "${widget.puzzleObject['rows']} by ${widget.puzzleObject['columns']}", palette),
                      
                              
                                ],
                              ),
                            ),
                      
                            SizedBox(height: 2,),
                      
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0)
                                  ),
                                  foregroundColor: palette.navigationButtonText2,
                                  backgroundColor: palette.navigationButtonBg2,
                                ),
                                onPressed: () {
                                  Initializations().startGame(
                                    gamePlayState, 
                                    widget.puzzleObject["gameType"], 
                                    widget.puzzleObject['duration'], 
                                    widget.puzzleObject['target'], 
                                    widget.puzzleObject['rows'], 
                                    widget.puzzleObject['columns'], 
                                    widget.puzzleObject['timeToPlace'],
                                    widget.puzzleObject["levelName"],
                                    settings,   
                                    widget.mediaQueryData, 
                                    context,
                                    palette
                                  );

                                }, 
                                child: Text(
                                  "Play!",
                                  style: palette.mainAppFont(
                                    textStyle: TextStyle(
                                      // color: palette.navigationButtonText1
                                    )
                                  ),
                                )
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }
    } else {
      return SizedBox();
    }

  }
}

// Widget getDifficultyStars(double difficulty, ColorPalette palette) {

//   List<Widget> stars = [];
//   final double difficultyHalf = difficulty/2;
//   final int floor = difficultyHalf.floor();
//   late double remainder = 5;
//   if (floor>0) {
//     remainder = difficultyHalf%floor;
//   } 

//   print("floor: ${floor} | remainder: ${remainder}");

//   for (int i=0; i<floor; i++) {
//     stars.add(Icon(Icons.star,color:palette.widgetText1));
//   }
//   if (remainder>0) {
//     stars.add(Icon(Icons.star_half_outlined, color:palette.widgetText1));
//   }

//   for (int i=0; i<(5-floor-1); i++) {
//     stars.add(Icon(Icons.star_outline, color:palette.widgetText1));
//   }

//   if (remainder==0 && floor < 5) {
//     stars.add(Icon(Icons.star_outline, color:palette.widgetText1));
//   }


//   Widget res = Row(
//     children: stars,
//   );
//   return res;
// }

Widget paramWidget(IconData icon, dynamic value, ColorPalette palette) {
  Widget res = SizedBox();

  res = Padding(
    padding: EdgeInsets.all(2.0),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        color: const Color.fromARGB(255, 171, 181, 228), // palette.widget2,
        // border: Border.all(width: 1.0, color: Colors.black)
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(88, 22, 22, 22),
            offset: Offset(0.0, 2.0),
            spreadRadius: 2.0,
            blurRadius: 2.0
          )
        ]
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(6.0,2.0,6.0,2.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Color.fromARGB(255, 51, 51, 51),// palette.widgetText2,
            ),
            SizedBox(width: 10,),
            Text(
              "$value",
              style: palette.mainAppFont(
                textStyle: TextStyle(
                  color: palette.widgetText2,
                )
              ),
            )
          ],
        ),
      ),
    ),
  );
  return res;
}

String formatTitle(Map<dynamic,dynamic> puzzleObject) {
  String res = "";
  var localeDate = DateTime.parse(puzzleObject["date"]);
  String dateWeekday = DateFormat.EEEE().format(localeDate);
  String dateMonth = DateFormat.MMM().format(localeDate);
  String dateDay = DateFormat.d().format(localeDate);
  return "$dateWeekday, $dateMonth. $dateDay (${puzzleObject["difficulty"]})";
}
