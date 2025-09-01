import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/components/background_painter.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/functions/initializations.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
import 'package:scribby_flutter_v2/resources/storage_methods.dart';
import 'package:scribby_flutter_v2/screens/home_screen/home_screen.dart';
import 'package:scribby_flutter_v2/screens/shop_screen/components/shop_item.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';
import 'package:image_picker/image_picker.dart';

class DailyPuzzlesScreen extends StatefulWidget {
  const DailyPuzzlesScreen({super.key});

  @override
  State<DailyPuzzlesScreen> createState() => _DailyPuzzlesScreenState();
}

class _DailyPuzzlesScreenState extends State<DailyPuzzlesScreen> {


  late List<Map<String,dynamic>> availablePuzzles = [];
  late Map<String,dynamic> todayPuzzle = {};
  Random random = Random();

  
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    final now = DateTime.now().toUtc();
    final year = now.year.toString().padLeft(4, '0');
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    String dateString = '$year-$month-${day}T00:00:00.000Z';
    // String dateString = '$year-07-25T00:00:00.000Z';

    todayPuzzle = dailyPuzzles.firstWhere((e)=>e["date"]==dateString,orElse: ()=>{});
    print(dateString);

    // int todayPuzzleIndex = dailyPuzzles.indexOf(todayPuzzle);
    // availablePuzzles = dailyPuzzles.sublist(todayPuzzleIndex-4,todayPuzzleIndex-1);


    // print(availablePuzzles);
  }  

  @override
  Widget build(BuildContext context) {


    
    return Consumer<SettingsController>(
      builder: (context,settings,child) {

        // ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);



        late double scalor = 1.0;

        final Map<dynamic,dynamic> userData = settings.userData.value as Map<dynamic,dynamic>;

        GamePlayState gamePlayState = Provider.of<GamePlayState>(context, listen: false);
        


        return PopScope(
          canPop: true,
          child: Consumer<ColorPalette>(
            builder: (context,palette,child) {
              return SizedBox(
                // width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height,            
                child: SafeArea(
                  child: Stack(
                    children: [
                      Positioned(
                        // top: 1,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,//-MediaQuery.of(context).padding.top-MediaQuery.of(context).padding.bottom,
                          child: CustomPaint(
                            painter: GradientBackground(settings: settings, palette: palette, decorationData: []),
                          ),
                        ),
                      ),             
                      Scaffold(
                        backgroundColor: Colors.transparent,
                        onDrawerChanged: (var details) {},
                        appBar: AppBar(
                          backgroundColor: const Color.fromARGB(0, 49, 49, 49),
                          title: Text("Daily Puzzles", style: TextStyle(color: palette.text2, fontSize: 28*scalor),),
                          leading: IconButton(
                            icon: Icon(Icons.arrow_back, color: palette.text2),
                            onPressed: () => Navigator.of(context).pop(true),
                          ),
                        ),
              
                        body: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                        
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.0 * scalor),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    SizedBox(height: 50 * scalor,),

                                    Row(
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
                                                "5",
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
                                                "12",
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
                                                "XP Earned",
                                                  style: palette.mainAppFont(
                                                    textStyle: TextStyle(
                                                      color: palette.text1,
                                                      fontSize: 18 * scalor
                                                    )
                                                  ),                                                
                                              ),
                                              Text(
                                                "253",
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
                                    ),

                                    SizedBox(
                                      height: 50 * scalor,

                                    ),


                                    Row(
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
                                                                formatTitle(todayPuzzle),
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
                                                          todayPuzzle["gameType"],
                                                          todayPuzzle["duration"],
                                                          todayPuzzle["target"],
                                                          todayPuzzle["timeToPlace"],
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
                                                              
                                                              todayPuzzle["timeToPlace"]!=null?
                                                              paramWidget(Icons.timer, "${todayPuzzle['timeToPlace']}s", palette) : SizedBox(),
                                                          
                                                              todayPuzzle["target"] != null?
                                                              paramWidget(Icons.wifi_tethering, todayPuzzle["target"], palette) : SizedBox(),
                                                          
                                                              todayPuzzle["duration"] != null?
                                                              paramWidget(Icons.access_time, Helpers().formatDuration(todayPuzzle["duration"]*60), palette ):SizedBox(),
                                                  
                                                              paramWidget(Icons.window,  "${todayPuzzle['rows']} by ${todayPuzzle['columns']}", palette),
                                                  
                                                          
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
                                                                todayPuzzle["gameType"], 
                                                                todayPuzzle['duration'], 
                                                                todayPuzzle['target'], 
                                                                todayPuzzle['rows'], 
                                                                todayPuzzle['columns'], 
                                                                todayPuzzle['timeToPlace'],
                                                                todayPuzzle["uid"],
                                                                settings, 
                                                                MediaQuery.of(context), 
                                                                context
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
                                    ),



                                
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        // floatingActionButton: FloatingActionButton(
                        //   onPressed: () {
                        //     setState(() {
                        //       final year = '2025';
                        //       final month = (random.nextInt(11)+1).toString().padLeft(2, '0'); //now.month.toString().padLeft(2, '0');
                        //       final day = (random.nextInt(28)+1).toString().padLeft(2, '0'); //now.day.toString().padLeft(2, '0');
                        //       String dateString = '$year-$month-${day}T00:00:00.000Z';
                        //       print(dateString);
                        //       todayPuzzle = dailyPuzzles.firstWhere((e)=>e["date"]==dateString,orElse: ()=>{});                             
                        //     });
                        //   }
                        // ),
                      ),
                    ],
                  ),
                ),
              );
            }
          ),
        );
      }
    );
  }
}


Widget getDifficultyStars(double difficulty, ColorPalette palette) {

  List<Widget> stars = [];
  final double difficultyHalf = difficulty/2;
  final int floor = difficultyHalf.floor();
  late double remainder = 5;
  if (floor>0) {
    remainder = difficultyHalf%floor;
  } 

  print("floor: ${floor} | remainder: ${remainder}");

  for (int i=0; i<floor; i++) {
    stars.add(Icon(Icons.star,color:palette.widgetText1));
  }
  if (remainder>0) {
    stars.add(Icon(Icons.star_half_outlined, color:palette.widgetText1));
  }

  for (int i=0; i<(5-floor-1); i++) {
    stars.add(Icon(Icons.star_outline, color:palette.widgetText1));
  }

  if (remainder==0 && floor < 5) {
    stars.add(Icon(Icons.star_outline, color:palette.widgetText1));
  }


  Widget res = Row(
    children: stars,
  );
  return res;
}

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

String formatTitle(Map<String,dynamic> puzzleObject) {
  String res = "";
  var localeDate = DateTime.parse(puzzleObject["date"]);
  String dateWeekday = DateFormat.EEEE().format(localeDate);
  String dateMonth = DateFormat.MMM().format(localeDate);
  String dateDay = DateFormat.d().format(localeDate);
  return "$dateWeekday, $dateMonth. $dateDay";
}

// RichText getDescription(Map<String,dynamic> puzzleObject, ColorPalette palette) {
//   String bewareString = "";
//   String objectiveString = "";

//   List<TextSpan> texts = [
//     TextSpan(
//       text: "Objective: ", 
//       style: TextStyle(
//         fontWeight: FontWeight.bold, 
//         decoration: TextDecoration.underline,decorationThickness: 2,
//         shadows: [
//           Shadow(
//             color:  const Color.fromARGB(255, 255, 255, 255),
//             offset: Offset(0, -3),
//           )
//         ],
//         color: Colors.transparent, //palette.widgetText1,
//         decorationColor: palette.widgetText1

//       )
//     ),
//     TextSpan(text: objectiveString),
//   ];

//   if (puzzleObject["gameType"]=="classic") {
//     String durationFormatted = Helpers().formatDuration(puzzleObject["duration"]*60);
//     int mins = int.parse(durationFormatted.split(":")[0]);
//     String minutesText = mins > 1 ? "${mins.toString()} minutes" : "${mins.toString()} minute"; 
//     objectiveString = "\nScore as many points as you can within $minutesText. ";

//     String part1 = "\nScore ";
//     String part2 = "as many points ";
//     String part3 = "as you can ";
//     String part4 = "within $minutesText. ";
//     texts.add(TextSpan(text: part1,),);
//     texts.add(TextSpan(text: part2, style: TextStyle(fontWeight: FontWeight.bold)),);
//     texts.add(TextSpan(text: part3,),);
//     texts.add(TextSpan(text: part4, style: TextStyle(fontWeight: FontWeight.bold)),);

//   } else if (puzzleObject["gameType"]=="sprint") {
//     objectiveString = "\nReach ${puzzleObject["target"]} as quickly as possible. ";
//     String part1 = "\nReach ";
//     String part2 = "${puzzleObject["target"]} points ";
//     String part3 = "as ";
//     String part4 = "quickly ";
//     String part5 = "as possible. ";

//     texts.add(TextSpan(text: part1,),);
//     texts.add(TextSpan(text: part2, style: TextStyle(fontWeight: FontWeight.bold)),);
//     texts.add(TextSpan(text: part3,),);
//     texts.add(TextSpan(text: part4, style: TextStyle(fontWeight: FontWeight.bold)),);
//     texts.add(TextSpan(text: part5,),);
//   }


//   if (puzzleObject["timeToPlace"] != null) {
//     String bewareString1 = "You only have ";
//     String bewareString2 = "${puzzleObject["timeToPlace"]} seconds ";
//     String bewareString3 = "to make a move... ";
//     texts.add(TextSpan(text: "\nBeware! ", style: TextStyle(fontWeight: FontWeight.bold)),);
//     texts.add(TextSpan(text: bewareString1),);
//     texts.add(TextSpan(text: bewareString2, style: TextStyle(fontWeight: FontWeight.bold)),);
//     texts.add(TextSpan(text: bewareString3),);
//   }

//   var text = RichText(
//     text: TextSpan(
//       children: texts,
//       style: TextStyle(
//         fontSize: 18.0,
//         color: palette.widgetText1
//       )
//     )
//   );
//   return text;
// }

List<Map<String,dynamic>> dailyPuzzles = [
{'uid': '6d7487203a104d5eadb656e3d6392abf', 'date': '2025-01-01T00:00:00.000Z', 'gameType': 'sprint', 'target': 1100, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 2.0, 'xp': 5, 'coins': 600},
{'uid': 'b5e1ebbbfbba49d79edc14cd2dda93d6', 'date': '2025-01-02T00:00:00.000Z', 'gameType': 'sprint', 'target': 8000, 'targetType': null, 'timeToPlace': 5, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': null, 'difficulty': 6.0, 'xp': 10, 'coins': 800},
{'uid': 'f0bdef30893f4bb4893de37e22388347', 'date': '2025-01-03T00:00:00.000Z', 'gameType': 'sprint', 'target': 2500, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 2.0, 'xp': 5, 'coins': 700},
{'uid': '9395fe5f9ea34b5ab415b30834e52d70', 'date': '2025-01-04T00:00:00.000Z', 'gameType': 'sprint', 'target': 2300, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': null, 'difficulty': 1.0, 'xp': 3, 'coins': 700},
{'uid': '14a605d6e3b54a768011584b5a849228', 'date': '2025-01-05T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': 2, 'difficulty': 1.0, 'xp': 3, 'coins': 500},
{'uid': '6279189d633647b28978651f55381380', 'date': '2025-01-06T00:00:00.000Z', 'gameType': 'sprint', 'target': 7100, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': null, 'difficulty': 1.0, 'xp': 3, 'coins': 600},
{'uid': '19c619f4635e4a7fbaf5c286c17b138a', 'date': '2025-01-07T00:00:00.000Z', 'gameType': 'sprint', 'target': 7800, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': null, 'difficulty': 1.0, 'xp': 3, 'coins': 700},
{'uid': 'e81de0142b5f4398823c532aa154b0a4', 'date': '2025-01-08T00:00:00.000Z', 'gameType': 'sprint', 'target': 3900, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 2.0, 'xp': 5, 'coins': 600},
{'uid': 'f9d183ec2e20459bad4f87da86b0f510', 'date': '2025-01-09T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 4, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': 11, 'difficulty': 6.0, 'xp': 10, 'coins': 1000},
{'uid': '32d5cef62b6e4cba88e9f479b409eb4c', 'date': '2025-01-10T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 13, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 10, 'difficulty': 3.0, 'xp': 5, 'coins': 600},
{'uid': '637568a1d4bf4281886712f3694a2846', 'date': '2025-01-11T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 7, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': 2, 'difficulty': 7.0, 'xp': 15, 'coins': 900},
{'uid': '1f3d93aeaa1c4153b6a35b63a81cf577', 'date': '2025-01-12T00:00:00.000Z', 'gameType': 'sprint', 'target': 3000, 'targetType': null, 'timeToPlace': 8, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 7.0, 'xp': 15, 'coins': 1000},
{'uid': 'e1c9156ae80447cca9dc9a20b40c4d1c', 'date': '2025-01-13T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 6, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': 12, 'difficulty': 8.0, 'xp': 20, 'coins': 1000},
{'uid': 'a6a02c00b8334f4eafe6046d4c8b55e0', 'date': '2025-01-14T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 15, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': 11, 'difficulty': 0.0, 'xp': 3, 'coins': 600},
{'uid': '3e53883f0a4b4087b37c546099c9c9f8', 'date': '2025-01-15T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 4, 'rows': 8, 'columns': 8, 'duration': 13, 'difficulty': 3.0, 'xp': 5, 'coins': 600},
{'uid': '27644300297c4cdd8e7f290bab7ed812', 'date': '2025-01-16T00:00:00.000Z', 'gameType': 'sprint', 'target': 3300, 'targetType': null, 'timeToPlace': null, 'minWordLength': 4, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 6.0, 'xp': 10, 'coins': 900},
{'uid': 'a4fa0467bf014141aeb4c0fd2c7f205d', 'date': '2025-01-17T00:00:00.000Z', 'gameType': 'sprint', 'target': 3600, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': null, 'difficulty': 1.0, 'xp': 3, 'coins': 700},
{'uid': '435dcd57e20641c8a4a209b23d484019', 'date': '2025-01-18T00:00:00.000Z', 'gameType': 'sprint', 'target': 2600, 'targetType': null, 'timeToPlace': 15, 'minWordLength': 4, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 6.0, 'xp': 10, 'coins': 1000},
{'uid': 'e36b11249c304991bcf3cfaa6c7efa53', 'date': '2025-01-19T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 11, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': 13, 'difficulty': 5.0, 'xp': 5, 'coins': 800},
{'uid': '3616bb0c92ed4c93a0793eb247550d1c', 'date': '2025-01-20T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 14, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': 12, 'difficulty': 0.0, 'xp': 3, 'coins': 600},
{'uid': '9d280ef6f1994c649d6c328228a7ca17', 'date': '2025-01-21T00:00:00.000Z', 'gameType': 'sprint', 'target': 3300, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 0.0, 'xp': 3, 'coins': 600},
{'uid': '14092465d693483abbd47f1b864fe90b', 'date': '2025-01-22T00:00:00.000Z', 'gameType': 'sprint', 'target': 1500, 'targetType': null, 'timeToPlace': 10, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 6.0, 'xp': 10, 'coins': 900},
{'uid': 'd42cea7b940d4e74870da5cb9bc955bd', 'date': '2025-01-23T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': 13, 'difficulty': 3.0, 'xp': 5, 'coins': 700},
{'uid': 'dec6e45324a7460d92bb7be13f928b50', 'date': '2025-01-24T00:00:00.000Z', 'gameType': 'sprint', 'target': 5300, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 2.0, 'xp': 5, 'coins': 600},
{'uid': '04f04d01519a4901ad5be72464a5b02c', 'date': '2025-01-25T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 9, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': 12, 'difficulty': 3.0, 'xp': 5, 'coins': 700},
{'uid': '5f856e98ef8a4bacb275942b43997f3f', 'date': '2025-01-26T00:00:00.000Z', 'gameType': 'sprint', 'target': 9400, 'targetType': null, 'timeToPlace': 8, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 700},
{'uid': '3c263bd1ff534f5ca3e6fe78ff2dbab4', 'date': '2025-01-27T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': 15, 'difficulty': 3.0, 'xp': 5, 'coins': 600},
{'uid': 'c12fa6ab86014e3b923c950e051a80a9', 'date': '2025-01-28T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 3, 'difficulty': 2.0, 'xp': 5, 'coins': 700},
{'uid': 'c62fa346c200445aa167eba872a47431', 'date': '2025-01-29T00:00:00.000Z', 'gameType': 'sprint', 'target': 5200, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 0.0, 'xp': 3, 'coins': 500},
{'uid': '06ec98af19c44f90a7d8986cd3a32890', 'date': '2025-01-30T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 13, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': 9, 'difficulty': 4.0, 'xp': 5, 'coins': 700},
{'uid': '3b3e84f65fdc4763a44c78b02332a6fb', 'date': '2025-01-31T00:00:00.000Z', 'gameType': 'sprint', 'target': 7700, 'targetType': null, 'timeToPlace': 6, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 4.0, 'xp': 5, 'coins': 800},
{'uid': '1aa7a5d0648b424a963b18a452d20e80', 'date': '2025-02-01T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 3, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': 7, 'difficulty': 6.0, 'xp': 10, 'coins': 900},
{'uid': 'c76c2ead135a48478995993c15dee58a', 'date': '2025-02-02T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 12, 'difficulty': 2.0, 'xp': 5, 'coins': 700},
{'uid': '42da4ee9154b4025afb969f906094657', 'date': '2025-02-03T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 13, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': 9, 'difficulty': 4.0, 'xp': 5, 'coins': 700},
{'uid': 'e1c25e070eec4ef8b9fd2a4f5fcf321e', 'date': '2025-02-04T00:00:00.000Z', 'gameType': 'sprint', 'target': 3400, 'targetType': null, 'timeToPlace': 5, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 5.0, 'xp': 5, 'coins': 800},
{'uid': '644446bc4cf6490bbd9a347733c9ac3d', 'date': '2025-02-05T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 4, 'rows': 6, 'columns': 6, 'duration': 12, 'difficulty': 6.0, 'xp': 10, 'coins': 800},
{'uid': '35a37f84125a4977a4424cb21de6a97d', 'date': '2025-02-06T00:00:00.000Z', 'gameType': 'sprint', 'target': 6500, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 800},
{'uid': 'd41a65d5bdc340c9bc2fa5fd536f9101', 'date': '2025-02-07T00:00:00.000Z', 'gameType': 'sprint', 'target': 9600, 'targetType': null, 'timeToPlace': 8, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 700},
{'uid': 'ecce04ea294845d997829c2514b6fcd2', 'date': '2025-02-08T00:00:00.000Z', 'gameType': 'sprint', 'target': 8300, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 700},
{'uid': 'f3a4b70aa6be4ad0ac5bdf18b56f9b49', 'date': '2025-02-09T00:00:00.000Z', 'gameType': 'sprint', 'target': 4000, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 800},
{'uid': 'b6fa7d6b1a1c4f1fab10b90ad9b75e4b', 'date': '2025-02-10T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': 15, 'difficulty': 1.0, 'xp': 3, 'coins': 700},
{'uid': '9ecc8f5f0c734e49b44fc5a89cfc3ce7', 'date': '2025-02-11T00:00:00.000Z', 'gameType': 'sprint', 'target': 5200, 'targetType': null, 'timeToPlace': 9, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 6.0, 'xp': 10, 'coins': 800},
{'uid': 'ed004edc18204d3cabe0ed5c776e1e38', 'date': '2025-02-12T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': 11, 'difficulty': 0.0, 'xp': 3, 'coins': 600},
{'uid': 'cd1d1a2ef5ec42b59a598bd5e634b7fe', 'date': '2025-02-13T00:00:00.000Z', 'gameType': 'sprint', 'target': 1900, 'targetType': null, 'timeToPlace': 4, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 5.0, 'xp': 5, 'coins': 900},
{'uid': 'a55088c9aaca42c3af85281d8b9aa688', 'date': '2025-02-14T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': 7, 'difficulty': 0.0, 'xp': 3, 'coins': 600},
{'uid': 'dce0a94d5e8d4a7f9f03197dd1ab7e22', 'date': '2025-02-15T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 8, 'minWordLength': 4, 'rows': 7, 'columns': 7, 'duration': 13, 'difficulty': 8.0, 'xp': 20, 'coins': 1100},
{'uid': '295e69e016d947e2ac5592d13dbe37e4', 'date': '2025-02-16T00:00:00.000Z', 'gameType': 'sprint', 'target': 1100, 'targetType': null, 'timeToPlace': 12, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 4.0, 'xp': 5, 'coins': 800},
{'uid': '378e93b1f10f4e2cbecf45c921b99c9f', 'date': '2025-02-17T00:00:00.000Z', 'gameType': 'sprint', 'target': 8600, 'targetType': null, 'timeToPlace': null, 'minWordLength': 4, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 800},
{'uid': 'c88fb6a4339d45f49e0a24261aff6d4d', 'date': '2025-02-18T00:00:00.000Z', 'gameType': 'sprint', 'target': 3300, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 0.0, 'xp': 3, 'coins': 600},
{'uid': 'be76c666a9e54d908b4cf63e7dcf0447', 'date': '2025-02-19T00:00:00.000Z', 'gameType': 'sprint', 'target': 8700, 'targetType': null, 'timeToPlace': 5, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 7.0, 'xp': 15, 'coins': 900},
{'uid': '3fa025ef0f4142889eca64ffb646d4e2', 'date': '2025-02-20T00:00:00.000Z', 'gameType': 'sprint', 'target': 1800, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 0.0, 'xp': 3, 'coins': 600},
{'uid': '899dede378eb4feeac6c341b57581f64', 'date': '2025-02-21T00:00:00.000Z', 'gameType': 'sprint', 'target': 8200, 'targetType': null, 'timeToPlace': 14, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 0.0, 'xp': 3, 'coins': 500},
{'uid': '8ba4ae1050b34adbac5738bade693c4c', 'date': '2025-02-22T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': 12, 'difficulty': 1.0, 'xp': 3, 'coins': 500},
{'uid': '1ab201f767db4785a16bce3de9e86503', 'date': '2025-02-23T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': 10, 'difficulty': 0.0, 'xp': 3, 'coins': 600},
{'uid': '452fed306c39401885348e0670022075', 'date': '2025-02-24T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': 8, 'difficulty': 1.0, 'xp': 3, 'coins': 500},
{'uid': '486944e18fec4422b2d1d832101d0674', 'date': '2025-02-25T00:00:00.000Z', 'gameType': 'sprint', 'target': 7400, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 0.0, 'xp': 3, 'coins': 500},
{'uid': '2a99eb4dc6f44140bdcc5dfdc240fe71', 'date': '2025-02-26T00:00:00.000Z', 'gameType': 'sprint', 'target': 10000, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 0.0, 'xp': 3, 'coins': 600},
{'uid': '98ce72e606f34db194d51d491acf78e1', 'date': '2025-02-27T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 4, 'rows': 8, 'columns': 8, 'duration': 7, 'difficulty': 3.0, 'xp': 5, 'coins': 700},
{'uid': 'fdb5f2e52e7640d68e8b024c36b4a8c0', 'date': '2025-02-28T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 4, 'rows': 8, 'columns': 8, 'duration': 11, 'difficulty': 3.0, 'xp': 5, 'coins': 600},
{'uid': '5f4d9afad56848e68c70a1d9cbcd0c18', 'date': '2025-03-01T00:00:00.000Z', 'gameType': 'sprint', 'target': 3600, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 800},
{'uid': '56d87a6104434cd5a2f9eee452fc7360', 'date': '2025-03-02T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 8, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 6, 'difficulty': 6.0, 'xp': 10, 'coins': 800},
{'uid': '81802b5394244d7c8b836e249dd83a2d', 'date': '2025-03-03T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 3, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': 8, 'difficulty': 6.0, 'xp': 10, 'coins': 800},
{'uid': '72e48c8be01b49e4bccb4fbce5628def', 'date': '2025-03-04T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 10, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': 11, 'difficulty': 3.0, 'xp': 5, 'coins': 600},
{'uid': 'b774c2ea8b6c43ef92b92711a095bd11', 'date': '2025-03-05T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 13, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': 8, 'difficulty': 2.0, 'xp': 5, 'coins': 700},
{'uid': 'eefadd4dce1f492cb25b91a39038307e', 'date': '2025-03-06T00:00:00.000Z', 'gameType': 'sprint', 'target': 7300, 'targetType': null, 'timeToPlace': 13, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': null, 'difficulty': 2.0, 'xp': 5, 'coins': 700},
{'uid': '2f742e947ed6445b818e861323d52de0', 'date': '2025-03-07T00:00:00.000Z', 'gameType': 'sprint', 'target': 8900, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 800},
{'uid': '282238853123443c84abdd3f9aa779d0', 'date': '2025-03-08T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 13, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': 15, 'difficulty': 4.0, 'xp': 5, 'coins': 800},
{'uid': '627b050a958b421a9142503b8cfa5310', 'date': '2025-03-09T00:00:00.000Z', 'gameType': 'sprint', 'target': 4100, 'targetType': null, 'timeToPlace': 14, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 4.0, 'xp': 5, 'coins': 700},
{'uid': 'a3a4518c54394cc4800e69e4432c395e', 'date': '2025-03-10T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': 7, 'difficulty': 0.0, 'xp': 3, 'coins': 600},
{'uid': 'bdc1f0e2b27a41078cf26710c0ae9262', 'date': '2025-03-11T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': 12, 'difficulty': 3.0, 'xp': 5, 'coins': 700},
{'uid': '3a43ba74b76e4196a64b1545646bf010', 'date': '2025-03-12T00:00:00.000Z', 'gameType': 'sprint', 'target': 1000, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 800},
{'uid': 'eb3d17c92e304f2e9354fb9598c61d67', 'date': '2025-03-13T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': 10, 'difficulty': 3.0, 'xp': 5, 'coins': 800},
{'uid': '97aa2607cdc144b59eabae893887e52d', 'date': '2025-03-14T00:00:00.000Z', 'gameType': 'sprint', 'target': 7300, 'targetType': null, 'timeToPlace': 14, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': null, 'difficulty': 2.0, 'xp': 5, 'coins': 600},
{'uid': 'de13cabb83f6457bb3f0071827872420', 'date': '2025-03-15T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': 8, 'difficulty': 0.0, 'xp': 3, 'coins': 500},
{'uid': 'b414847f339e45f7809f307da108a2ee', 'date': '2025-03-16T00:00:00.000Z', 'gameType': 'sprint', 'target': 2900, 'targetType': null, 'timeToPlace': 12, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 1.0, 'xp': 3, 'coins': 700},
{'uid': '6e0b5c46c5aa40e888d1ee35448cb150', 'date': '2025-03-17T00:00:00.000Z', 'gameType': 'sprint', 'target': 9100, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 800},
{'uid': 'a23533cf350a44f9857dc96ca544b4b1', 'date': '2025-03-18T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 15, 'minWordLength': 4, 'rows': 8, 'columns': 8, 'duration': 6, 'difficulty': 3.0, 'xp': 5, 'coins': 600},
{'uid': '170ad6373f274aeaa952b2fca3ed9f48', 'date': '2025-03-19T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': 15, 'difficulty': 0.0, 'xp': 3, 'coins': 600},
{'uid': '5526160a60fd41dd861cde109616ec28', 'date': '2025-03-20T00:00:00.000Z', 'gameType': 'sprint', 'target': 8300, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 700},
{'uid': '2013081e34c3443bbb20275bb01bd464', 'date': '2025-03-21T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 13, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': 11, 'difficulty': 2.0, 'xp': 5, 'coins': 700},
{'uid': '3d2ba9b0731448358c45d169b9ded7d9', 'date': '2025-03-22T00:00:00.000Z', 'gameType': 'sprint', 'target': 1400, 'targetType': null, 'timeToPlace': 8, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 7.0, 'xp': 15, 'coins': 900},
{'uid': 'f47e07ab7fa7401dafc455160934f1c2', 'date': '2025-03-23T00:00:00.000Z', 'gameType': 'sprint', 'target': 3300, 'targetType': null, 'timeToPlace': 14, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 4.0, 'xp': 5, 'coins': 800},
{'uid': '857f0e6270134ef297a59aa94179eb36', 'date': '2025-03-24T00:00:00.000Z', 'gameType': 'sprint', 'target': 5400, 'targetType': null, 'timeToPlace': 8, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 7.0, 'xp': 15, 'coins': 1000},
{'uid': '0fa99a63df72459e84fede4e188fbea7', 'date': '2025-03-25T00:00:00.000Z', 'gameType': 'sprint', 'target': 2000, 'targetType': null, 'timeToPlace': 15, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 0.0, 'xp': 3, 'coins': 600},
{'uid': '541e0d0415b940a889d484553e65c291', 'date': '2025-03-26T00:00:00.000Z', 'gameType': 'sprint', 'target': 6800, 'targetType': null, 'timeToPlace': 3, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 6.0, 'xp': 10, 'coins': 1000},
{'uid': 'd9b2fc241a09470d88c0d456008faa08', 'date': '2025-03-27T00:00:00.000Z', 'gameType': 'sprint', 'target': 9800, 'targetType': null, 'timeToPlace': null, 'minWordLength': 4, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 700},
{'uid': 'd1fef9569f914d22b381acf98a17f73b', 'date': '2025-03-28T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': 2, 'difficulty': 0.0, 'xp': 3, 'coins': 600},
{'uid': '427de2e1c0634deba74f7b7c0b7e8ef4', 'date': '2025-03-29T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': 2, 'difficulty': 0.0, 'xp': 3, 'coins': 600},
{'uid': '0d97e369b1a04428ab31edc5281b4c2b', 'date': '2025-03-30T00:00:00.000Z', 'gameType': 'sprint', 'target': 7300, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 0.0, 'xp': 3, 'coins': 500},
{'uid': '1f8e8e8deae34105b3c95dd0ec87d932', 'date': '2025-03-31T00:00:00.000Z', 'gameType': 'sprint', 'target': 7900, 'targetType': null, 'timeToPlace': 15, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 0.0, 'xp': 3, 'coins': 600},
{'uid': 'cd27cff14cec4598901d2bccc12d5327', 'date': '2025-04-01T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 12, 'difficulty': 2.0, 'xp': 5, 'coins': 600},
{'uid': '972c2b48cf2342c5a86d306763c7cfb7', 'date': '2025-04-02T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': 3, 'difficulty': 1.0, 'xp': 3, 'coins': 500},
{'uid': '74eb7d95d2644405831f91507d5f50ed', 'date': '2025-04-03T00:00:00.000Z', 'gameType': 'sprint', 'target': 2200, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 600},
{'uid': '4739eeb02e4748d5b579b8a0d5406660', 'date': '2025-04-04T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 3, 'difficulty': 2.0, 'xp': 5, 'coins': 600},
{'uid': '1a3ea1a31b1b463d8c8e289b4d64a831', 'date': '2025-04-05T00:00:00.000Z', 'gameType': 'sprint', 'target': 6100, 'targetType': null, 'timeToPlace': 12, 'minWordLength': 4, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 5.0, 'xp': 5, 'coins': 700},
{'uid': 'c9250ec677774f13bc668470cbfd5864', 'date': '2025-04-06T00:00:00.000Z', 'gameType': 'sprint', 'target': 2400, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': null, 'difficulty': 1.0, 'xp': 3, 'coins': 700},
{'uid': '87c6e9bedbe2452eb003f9ac995269cc', 'date': '2025-04-07T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 4, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 11, 'difficulty': 7.0, 'xp': 15, 'coins': 1000},
{'uid': '57fe63bc7429489ca760c8bc147d399b', 'date': '2025-04-08T00:00:00.000Z', 'gameType': 'sprint', 'target': 7300, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 0.0, 'xp': 3, 'coins': 600},
{'uid': '40a427526a3044049ae8ab159a6e8e94', 'date': '2025-04-09T00:00:00.000Z', 'gameType': 'sprint', 'target': 3800, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 0.0, 'xp': 3, 'coins': 600},
{'uid': '2c2635d82bab46a7b94e5f6e9232892e', 'date': '2025-04-10T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 14, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': 11, 'difficulty': 0.0, 'xp': 3, 'coins': 500},
{'uid': '3be391b9f07f4d2bb3e6044aad874ff1', 'date': '2025-04-11T00:00:00.000Z', 'gameType': 'sprint', 'target': 2900, 'targetType': null, 'timeToPlace': 9, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': null, 'difficulty': 4.0, 'xp': 5, 'coins': 800},
{'uid': 'bd1dcdf032834a52892bf172ed9f4b0c', 'date': '2025-04-12T00:00:00.000Z', 'gameType': 'sprint', 'target': 9100, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': null, 'difficulty': 1.0, 'xp': 3, 'coins': 500},
{'uid': 'ca826c66d9c04fec92f9092c6781fafc', 'date': '2025-04-13T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': 5, 'difficulty': 3.0, 'xp': 5, 'coins': 800},
{'uid': '1110131a4e7b4abb8c9ce87ed823d0f4', 'date': '2025-04-14T00:00:00.000Z', 'gameType': 'sprint', 'target': 4900, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 700},
{'uid': '666dbe5bf3584392af41ed43b25c36da', 'date': '2025-04-15T00:00:00.000Z', 'gameType': 'sprint', 'target': 5000, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': null, 'difficulty': 1.0, 'xp': 3, 'coins': 600},
{'uid': 'b5cc512a5809498eb7db59cbb9056ea3', 'date': '2025-04-16T00:00:00.000Z', 'gameType': 'sprint', 'target': 6800, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 600},
{'uid': '52acde7f2e1c4f3c8a4a9bd80c9c69dc', 'date': '2025-04-17T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': 2, 'difficulty': 3.0, 'xp': 5, 'coins': 700},
{'uid': '96fe425c059f476ca5e1922c089d8bae', 'date': '2025-04-18T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 9, 'difficulty': 2.0, 'xp': 5, 'coins': 700},
{'uid': '886aeccbff28493ca5d2ba1a1367dc6f', 'date': '2025-04-19T00:00:00.000Z', 'gameType': 'sprint', 'target': 3200, 'targetType': null, 'timeToPlace': 4, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 5.0, 'xp': 5, 'coins': 800},
{'uid': '9635ab700a1440c0b1c3616f0fcd2e5b', 'date': '2025-04-20T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': 3, 'difficulty': 0.0, 'xp': 3, 'coins': 500},
{'uid': 'fe56ccfb117d437aaa629220726de0e4', 'date': '2025-04-21T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 6, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 9, 'difficulty': 7.0, 'xp': 15, 'coins': 1000},
{'uid': '124f1a7efe034ee88f21dd4a347f187b', 'date': '2025-04-22T00:00:00.000Z', 'gameType': 'sprint', 'target': 4800, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 2.0, 'xp': 5, 'coins': 600},
{'uid': '11587f043ffe4c36bfbd3c4b2f152154', 'date': '2025-04-23T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 13, 'difficulty': 2.0, 'xp': 5, 'coins': 600},
{'uid': '16f98981cc504311b50f580593a2747c', 'date': '2025-04-24T00:00:00.000Z', 'gameType': 'sprint', 'target': 5600, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 2.0, 'xp': 5, 'coins': 600},
{'uid': 'e61757809bab4b489e7ac5ef38733c84', 'date': '2025-04-25T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 4, 'rows': 6, 'columns': 6, 'duration': 10, 'difficulty': 6.0, 'xp': 10, 'coins': 1000},
{'uid': 'a9e250ed3ca44b2e80ea14633d2a2093', 'date': '2025-04-26T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': 3, 'difficulty': 1.0, 'xp': 3, 'coins': 600},
{'uid': '981ed1c53aac4ce1989fbed8e779d59a', 'date': '2025-04-27T00:00:00.000Z', 'gameType': 'sprint', 'target': 2500, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 0.0, 'xp': 3, 'coins': 500},
{'uid': '37537c19ec284d6c9a2861a657a3afa1', 'date': '2025-04-28T00:00:00.000Z', 'gameType': 'sprint', 'target': 5100, 'targetType': null, 'timeToPlace': 14, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 600},
{'uid': '2b2772533bb544a297cfb9902950ae7b', 'date': '2025-04-29T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 10, 'difficulty': 2.0, 'xp': 5, 'coins': 700},
{'uid': 'd42f4347b4384cbfbfc0b7837fc25cc2', 'date': '2025-04-30T00:00:00.000Z', 'gameType': 'sprint', 'target': 6200, 'targetType': null, 'timeToPlace': 13, 'minWordLength': 4, 'rows': 7, 'columns': 7, 'duration': null, 'difficulty': 5.0, 'xp': 5, 'coins': 800},
{'uid': '09c9607fd20f4e058202850a1b0528cb', 'date': '2025-05-01T00:00:00.000Z', 'gameType': 'sprint', 'target': 2700, 'targetType': null, 'timeToPlace': 9, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 5.0, 'xp': 5, 'coins': 700},
{'uid': '27bdaa489f764ccfa505149cff371695', 'date': '2025-05-02T00:00:00.000Z', 'gameType': 'sprint', 'target': 4100, 'targetType': null, 'timeToPlace': null, 'minWordLength': 4, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 6.0, 'xp': 10, 'coins': 1000},
{'uid': '5b21f128b2e74bf8814a07d0b71aa064', 'date': '2025-05-03T00:00:00.000Z', 'gameType': 'sprint', 'target': 2500, 'targetType': null, 'timeToPlace': 7, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 7.0, 'xp': 15, 'coins': 1000},
{'uid': 'bef0802203cb4afda580f677afc49f9f', 'date': '2025-05-04T00:00:00.000Z', 'gameType': 'sprint', 'target': 8700, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 2.0, 'xp': 5, 'coins': 600},
{'uid': 'b61827e6e78c41b8b4f00fba4002a29a', 'date': '2025-05-05T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 7, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': 2, 'difficulty': 4.0, 'xp': 5, 'coins': 700},
{'uid': '7c90b46303064303b8313ad79497ae51', 'date': '2025-05-06T00:00:00.000Z', 'gameType': 'sprint', 'target': 3300, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 600},
{'uid': '246c0f67f804487e832d0f802dbded66', 'date': '2025-05-07T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 7, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': 3, 'difficulty': 7.0, 'xp': 15, 'coins': 1000},
{'uid': '7660b0bf04264dd599b527ce3abef71f', 'date': '2025-05-08T00:00:00.000Z', 'gameType': 'sprint', 'target': 5900, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 2.0, 'xp': 5, 'coins': 600},
{'uid': '6209e6b3fa0d4bc59b9033383ddcf95d', 'date': '2025-05-09T00:00:00.000Z', 'gameType': 'sprint', 'target': 1300, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': null, 'difficulty': 1.0, 'xp': 3, 'coins': 700},
{'uid': '0208b6dfa5414fa2b7979fce879c2f0c', 'date': '2025-05-10T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': 13, 'difficulty': 0.0, 'xp': 3, 'coins': 500},
{'uid': 'd187514475fc4a0dad2dd02dde89f037', 'date': '2025-05-11T00:00:00.000Z', 'gameType': 'sprint', 'target': 4600, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 2.0, 'xp': 5, 'coins': 700},
{'uid': '6f4936709e1c49cd832c0793364f3364', 'date': '2025-05-12T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 13, 'minWordLength': 4, 'rows': 6, 'columns': 6, 'duration': 9, 'difficulty': 7.0, 'xp': 15, 'coins': 900},
{'uid': '216b84a8b3af46d58e66c6603ba20394', 'date': '2025-05-13T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 3, 'difficulty': 2.0, 'xp': 5, 'coins': 700},
{'uid': 'a26368912da34a11af8e18f27fac05a0', 'date': '2025-05-14T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 4, 'minWordLength': 4, 'rows': 7, 'columns': 7, 'duration': 2, 'difficulty': 10.0, 'xp': 50, 'coins': 1300},
{'uid': '0190b55fea8a4d4a96d8a5ae1d2c1646', 'date': '2025-05-15T00:00:00.000Z', 'gameType': 'sprint', 'target': 1200, 'targetType': null, 'timeToPlace': 10, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 6.0, 'xp': 10, 'coins': 1000},
{'uid': 'cf4d558fc964481684a3bc5a46e9eb01', 'date': '2025-05-16T00:00:00.000Z', 'gameType': 'sprint', 'target': 3700, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': null, 'difficulty': 1.0, 'xp': 3, 'coins': 500},
{'uid': '03c80c446b6f4052b816a15fdf79010f', 'date': '2025-05-17T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 9, 'difficulty': 2.0, 'xp': 5, 'coins': 600},
{'uid': '10d1ea2ebe9a455186627bb3de96be94', 'date': '2025-05-18T00:00:00.000Z', 'gameType': 'sprint', 'target': 1700, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 2.0, 'xp': 5, 'coins': 700},
{'uid': '3ff6f6906c8b4e0384b2c6b82251b441', 'date': '2025-05-19T00:00:00.000Z', 'gameType': 'sprint', 'target': 7700, 'targetType': null, 'timeToPlace': 11, 'minWordLength': 4, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 7.0, 'xp': 15, 'coins': 900},
{'uid': '128bc78d5ba9479493e92e85dfd47a5d', 'date': '2025-05-20T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 8, 'difficulty': 2.0, 'xp': 5, 'coins': 600},
{'uid': 'c9cae04323974fcaa1f1c42853ece25a', 'date': '2025-05-21T00:00:00.000Z', 'gameType': 'sprint', 'target': 6100, 'targetType': null, 'timeToPlace': 11, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 5.0, 'xp': 5, 'coins': 700},
{'uid': '01ad502260ed4ef586bf16f710d4c8a1', 'date': '2025-05-22T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 14, 'minWordLength': 4, 'rows': 6, 'columns': 6, 'duration': 15, 'difficulty': 6.0, 'xp': 10, 'coins': 800},
{'uid': 'ab7d91d2b19545558889de96fd912115', 'date': '2025-05-23T00:00:00.000Z', 'gameType': 'sprint', 'target': 5200, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 700},
{'uid': '77119ddbcee24099b9b52a73f70d3e92', 'date': '2025-05-24T00:00:00.000Z', 'gameType': 'sprint', 'target': 5900, 'targetType': null, 'timeToPlace': 8, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 700},
{'uid': 'dbf2b4e129de455e92484aceb327ecd6', 'date': '2025-05-25T00:00:00.000Z', 'gameType': 'sprint', 'target': 8200, 'targetType': null, 'timeToPlace': null, 'minWordLength': 4, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 700},
{'uid': '80227dec0315401f89a2c5692a03a8f8', 'date': '2025-05-26T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 7, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': 15, 'difficulty': 5.0, 'xp': 5, 'coins': 700},
{'uid': 'c072e118f8864e84b62c00cd9ead809b', 'date': '2025-05-27T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': 8, 'difficulty': 0.0, 'xp': 3, 'coins': 600},
{'uid': '21b844ee927a4a8a89d7324ffcdf2faf', 'date': '2025-05-28T00:00:00.000Z', 'gameType': 'sprint', 'target': 1200, 'targetType': null, 'timeToPlace': 4, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 7.0, 'xp': 15, 'coins': 900},
{'uid': 'af90a2a50c4e4c138e1aa11092d95af2', 'date': '2025-05-29T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 11, 'minWordLength': 4, 'rows': 8, 'columns': 8, 'duration': 13, 'difficulty': 5.0, 'xp': 5, 'coins': 700},
{'uid': '0370d74138a84f2a9f7b8fa448ea172b', 'date': '2025-05-30T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': 2, 'difficulty': 1.0, 'xp': 3, 'coins': 600},
{'uid': 'd7164e229bbc4963b5c29fd06e8e36ae', 'date': '2025-05-31T00:00:00.000Z', 'gameType': 'sprint', 'target': 7600, 'targetType': null, 'timeToPlace': 15, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': null, 'difficulty': 1.0, 'xp': 3, 'coins': 500},
{'uid': 'ce074c79ae1c4201a1af7f363ce28812', 'date': '2025-06-01T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': 5, 'difficulty': 0.0, 'xp': 3, 'coins': 600},
{'uid': '63370d1fbc43415698bbf3baef25b30e', 'date': '2025-06-02T00:00:00.000Z', 'gameType': 'sprint', 'target': 4800, 'targetType': null, 'timeToPlace': 5, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 8.0, 'xp': 20, 'coins': 1100},
{'uid': '76f41f9925b84ab384dc1a15207fd2aa', 'date': '2025-06-03T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 4, 'rows': 8, 'columns': 8, 'duration': 8, 'difficulty': 3.0, 'xp': 5, 'coins': 600},
{'uid': 'a1841c2c226a45b9bd3131715c326f6f', 'date': '2025-06-04T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 9, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': 10, 'difficulty': 4.0, 'xp': 5, 'coins': 800},
{'uid': 'ef4eb6d58753482b81c2cd7a11a81463', 'date': '2025-06-05T00:00:00.000Z', 'gameType': 'sprint', 'target': 5900, 'targetType': null, 'timeToPlace': 4, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 5.0, 'xp': 5, 'coins': 900},
{'uid': '9dbffb41e682467d9de0814457af5620', 'date': '2025-06-06T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 13, 'difficulty': 2.0, 'xp': 5, 'coins': 700},
{'uid': 'c8e892664adb4cff8345d690c960795e', 'date': '2025-06-07T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 3, 'minWordLength': 4, 'rows': 7, 'columns': 7, 'duration': 10, 'difficulty': 10, 'xp': 50, 'coins': 2000},
{'uid': '1b48efae3056482097735b7534d73185', 'date': '2025-06-08T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 6, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': 10, 'difficulty': 8.0, 'xp': 20, 'coins': 1100},
{'uid': 'a72e382ec74d4138a7e3be2bb2896e24', 'date': '2025-06-09T00:00:00.000Z', 'gameType': 'sprint', 'target': 2100, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 700},
{'uid': '5b2848df97c944a09dbc6b2c93d7f9f0', 'date': '2025-06-10T00:00:00.000Z', 'gameType': 'sprint', 'target': 5900, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 800},
{'uid': 'b8c6670c07ce49608d0a80597943d972', 'date': '2025-06-11T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 4, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 5, 'difficulty': 7.0, 'xp': 15, 'coins': 1000},
{'uid': '5129944e9be140dbb811cef478944935', 'date': '2025-06-12T00:00:00.000Z', 'gameType': 'sprint', 'target': 7200, 'targetType': null, 'timeToPlace': null, 'minWordLength': 4, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 600},
{'uid': '0b3ea9133a7a4c8a80c679e03951e104', 'date': '2025-06-13T00:00:00.000Z', 'gameType': 'sprint', 'target': 8700, 'targetType': null, 'timeToPlace': 5, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 7.0, 'xp': 15, 'coins': 900},
{'uid': '05831992b86a4a4eb4990a287dff8ea0', 'date': '2025-06-14T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': 12, 'difficulty': 0.0, 'xp': 3, 'coins': 600},
{'uid': '6154933f41f14fd6b0c550497ea80c3d', 'date': '2025-06-15T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 9, 'difficulty': 2.0, 'xp': 5, 'coins': 700},
{'uid': '5d23e03ecc64447ba4cfcccd39fdafe7', 'date': '2025-06-16T00:00:00.000Z', 'gameType': 'sprint', 'target': 5800, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 0.0, 'xp': 3, 'coins': 600},
{'uid': 'bf249bd8d7bf4582913bedeb79a8b340', 'date': '2025-06-17T00:00:00.000Z', 'gameType': 'sprint', 'target': 8000, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': null, 'difficulty': 1.0, 'xp': 3, 'coins': 700},
{'uid': 'e47d277d7065443d8842ec411549f13a', 'date': '2025-06-18T00:00:00.000Z', 'gameType': 'sprint', 'target': 7300, 'targetType': null, 'timeToPlace': 13, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 4.0, 'xp': 5, 'coins': 800},
{'uid': '45c9c27325834f49a5ab7b7d0aa998eb', 'date': '2025-06-19T00:00:00.000Z', 'gameType': 'sprint', 'target': 3900, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 2.0, 'xp': 5, 'coins': 600},
{'uid': '6a5b6b4a61804d0d842a609c22a2f326', 'date': '2025-06-20T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 10, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': 12, 'difficulty': 2.0, 'xp': 5, 'coins': 700},
{'uid': '677db6bbd58a4c4491ba87e2e4f3a8f6', 'date': '2025-06-21T00:00:00.000Z', 'gameType': 'sprint', 'target': 9800, 'targetType': null, 'timeToPlace': 11, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 700},
{'uid': '67b272648efc447e8ceb2c7fd28ca387', 'date': '2025-06-22T00:00:00.000Z', 'gameType': 'sprint', 'target': 1200, 'targetType': null, 'timeToPlace': 13, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': null, 'difficulty': 2.0, 'xp': 5, 'coins': 700},
{'uid': 'fa9ecb6cdb04414d99d01921745874d8', 'date': '2025-06-23T00:00:00.000Z', 'gameType': 'sprint', 'target': 2800, 'targetType': null, 'timeToPlace': 8, 'minWordLength': 4, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 9.0, 'xp': 30, 'coins': 1300},
{'uid': '1566227c764648559bb714304802c5b8', 'date': '2025-06-24T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 10, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': 6, 'difficulty': 2.0, 'xp': 5, 'coins': 600},
{'uid': '54d0d849643042b9bf6d6033ee5a7945', 'date': '2025-06-25T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': 2, 'difficulty': 1.0, 'xp': 3, 'coins': 500},
{'uid': '72e5114280fd4791ac5277e10881d82e', 'date': '2025-06-26T00:00:00.000Z', 'gameType': 'sprint', 'target': 5400, 'targetType': null, 'timeToPlace': 13, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 800},
{'uid': '5fdcdde1cc0b4fc2b578e06cd455f397', 'date': '2025-06-27T00:00:00.000Z', 'gameType': 'sprint', 'target': 3100, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': null, 'difficulty': 1.0, 'xp': 3, 'coins': 700},
{'uid': '5d58fb1967444c85b1a7e32609d5c574', 'date': '2025-06-28T00:00:00.000Z', 'gameType': 'sprint', 'target': 4100, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': null, 'difficulty': 1.0, 'xp': 3, 'coins': 700},
{'uid': 'fa2541aac64c4383b1bc32e72bac58f7', 'date': '2025-06-29T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 11, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 9, 'difficulty': 4.0, 'xp': 5, 'coins': 800},
{'uid': 'a91fa32404b34f2793493ad84baedc7a', 'date': '2025-06-30T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 4, 'rows': 8, 'columns': 8, 'duration': 11, 'difficulty': 3.0, 'xp': 5, 'coins': 700},
{'uid': 'c3f173b179d44018b3bdb33a1f4c5817', 'date': '2025-07-01T00:00:00.000Z', 'gameType': 'sprint', 'target': 2200, 'targetType': null, 'timeToPlace': 7, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 4.0, 'xp': 5, 'coins': 800},
{'uid': 'a3b17cf0e0824e9b8518bc928da599a6', 'date': '2025-07-02T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 4, 'rows': 8, 'columns': 8, 'duration': 11, 'difficulty': 3.0, 'xp': 5, 'coins': 600},
{'uid': '0a04b515629d4c0d8e9b6419751275a2', 'date': '2025-07-03T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 11, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': 12, 'difficulty': 5.0, 'xp': 5, 'coins': 800},
{'uid': 'a115263c903d47b6841d9e0aeef85c70', 'date': '2025-07-04T00:00:00.000Z', 'gameType': 'sprint', 'target': 1900, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 700},
{'uid': '5dce436e398c41b8927a2ae5302f5ce2', 'date': '2025-07-05T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': 2, 'difficulty': 0.0, 'xp': 3, 'coins': 500},
{'uid': 'a2be2a5fa77a410aa65d89962aac1aaf', 'date': '2025-07-06T00:00:00.000Z', 'gameType': 'sprint', 'target': 3100, 'targetType': null, 'timeToPlace': 9, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 6.0, 'xp': 10, 'coins': 800},
{'uid': '6aebffb5bb73453eb483b1beda0faa20', 'date': '2025-07-07T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 15, 'difficulty': 2.0, 'xp': 5, 'coins': 600},
{'uid': '5947826940dd427a8d1bfe167c872b2c', 'date': '2025-07-08T00:00:00.000Z', 'gameType': 'sprint', 'target': 6300, 'targetType': null, 'timeToPlace': null, 'minWordLength': 4, 'rows': 7, 'columns': 7, 'duration': null, 'difficulty': 4.0, 'xp': 5, 'coins': 700},
{'uid': '08985d3c7cc245e7a60451a4b2b3fd5a', 'date': '2025-07-09T00:00:00.000Z', 'gameType': 'sprint', 'target': 7800, 'targetType': null, 'timeToPlace': 3, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 8.0, 'xp': 20, 'coins': 1000},
{'uid': '75c6e97f8ab74ef88fab8f3d33138455', 'date': '2025-07-10T00:00:00.000Z', 'gameType': 'sprint', 'target': 8700, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 800},
{'uid': '9433e6d1ed5b4c24b544b9fcd8db8e6c', 'date': '2025-07-11T00:00:00.000Z', 'gameType': 'sprint', 'target': 9300, 'targetType': null, 'timeToPlace': 10, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 2.0, 'xp': 5, 'coins': 700},
{'uid': '10c6cf490d2041a7b7c8a398d6d49358', 'date': '2025-07-12T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 9, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': 2, 'difficulty': 6.0, 'xp': 10, 'coins': 1000},
{'uid': '86c30f5205bb45f1bc62ffeb29fb8b63', 'date': '2025-07-13T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 9, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': 11, 'difficulty': 3.0, 'xp': 5, 'coins': 600},
{'uid': '1127bcd12f234589bba4b18a966d3dda', 'date': '2025-07-14T00:00:00.000Z', 'gameType': 'sprint', 'target': 7900, 'targetType': null, 'timeToPlace': 13, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 1.0, 'xp': 3, 'coins': 500},
{'uid': '70cb63ddec3341ca91124a81c6f0166e', 'date': '2025-07-15T00:00:00.000Z', 'gameType': 'sprint', 'target': 7800, 'targetType': null, 'timeToPlace': 9, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 700},
{'uid': 'cc82c6c2f7ab4b5186e4ccce7f42d481', 'date': '2025-07-16T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': 12, 'difficulty': 3.0, 'xp': 5, 'coins': 800},
{'uid': '505bf6127c394d1482d98ed537e0b06e', 'date': '2025-07-17T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 3, 'difficulty': 2.0, 'xp': 5, 'coins': 700},
{'uid': '04b20f6876d744f6b235bb9372d792a0', 'date': '2025-07-18T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 8, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': 3, 'difficulty': 7.0, 'xp': 15, 'coins': 1000},
{'uid': '3f708cd41dfd4877ac4e1a0912733ff9', 'date': '2025-07-19T00:00:00.000Z', 'gameType': 'sprint', 'target': 8400, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': null, 'difficulty': 1.0, 'xp': 3, 'coins': 500},
{'uid': 'c24cc5e323954c8cb27245acd6bee254', 'date': '2025-07-20T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': 9, 'difficulty': 1.0, 'xp': 3, 'coins': 500},
{'uid': '0fd5ee1299c14d4f8941098124d9b943', 'date': '2025-07-21T00:00:00.000Z', 'gameType': 'sprint', 'target': 6900, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': null, 'difficulty': 1.0, 'xp': 3, 'coins': 700},
{'uid': '4096bf3aa27a45a7a7e0991072661538', 'date': '2025-07-22T00:00:00.000Z', 'gameType': 'sprint', 'target': 3000, 'targetType': null, 'timeToPlace': 10, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 2.0, 'xp': 5, 'coins': 700},
{'uid': '30317333c8494d6cbed2f05e041a7b54', 'date': '2025-07-23T00:00:00.000Z', 'gameType': 'sprint', 'target': 7600, 'targetType': null, 'timeToPlace': 13, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': null, 'difficulty': 2.0, 'xp': 5, 'coins': 600},
{'uid': 'c4f42034b6b840f3ab096f246e0d3d0c', 'date': '2025-07-24T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': 13, 'difficulty': 0.0, 'xp': 3, 'coins': 500},
{'uid': 'b577c948c937463191ad7c58f9734ecc', 'date': '2025-07-25T00:00:00.000Z', 'gameType': 'sprint', 'target': 5800, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 0.0, 'xp': 3, 'coins': 600},
{'uid': 'b87e046ab7594ccaa7ce7ecafe3b95da', 'date': '2025-07-26T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 11, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': 10, 'difficulty': 5.0, 'xp': 5, 'coins': 800},
{'uid': '004924ce79964576bd1d63aab43df698', 'date': '2025-07-27T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 9, 'difficulty': 2.0, 'xp': 5, 'coins': 700},
{'uid': '89008bf8b0864f22b91af59217d15df4', 'date': '2025-07-28T00:00:00.000Z', 'gameType': 'sprint', 'target': 2100, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 2.0, 'xp': 5, 'coins': 600},
{'uid': 'ec01a6d927614441b68a6443a59bf4b7', 'date': '2025-07-29T00:00:00.000Z', 'gameType': 'sprint', 'target': 7400, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 2.0, 'xp': 5, 'coins': 700},
{'uid': 'bbf1cdc5aeb94e2186236136d5d41028', 'date': '2025-07-30T00:00:00.000Z', 'gameType': 'sprint', 'target': 4100, 'targetType': null, 'timeToPlace': 7, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 7.0, 'xp': 15, 'coins': 900},
{'uid': '6b20acbd6cae4d68861bfc7d1035bfc2', 'date': '2025-07-31T00:00:00.000Z', 'gameType': 'sprint', 'target': 3600, 'targetType': null, 'timeToPlace': 13, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 4.0, 'xp': 5, 'coins': 800},
{'uid': 'd0e90a7c3c7b472a827042332c75d928', 'date': '2025-08-01T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': 2, 'difficulty': 1.0, 'xp': 3, 'coins': 600},
{'uid': 'e22e7c136dec47c9a86fc79194901815', 'date': '2025-08-02T00:00:00.000Z', 'gameType': 'sprint', 'target': 5800, 'targetType': null, 'timeToPlace': null, 'minWordLength': 4, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 6.0, 'xp': 10, 'coins': 1000},
{'uid': 'e28b8beb55224938b714bfb3c13f4b77', 'date': '2025-08-03T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 12, 'minWordLength': 4, 'rows': 6, 'columns': 6, 'duration': 8, 'difficulty': 7.0, 'xp': 15, 'coins': 1000},
{'uid': '05405065ff8a431ca0f80d110f0ef529', 'date': '2025-08-04T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 7, 'difficulty': 2.0, 'xp': 5, 'coins': 600},
{'uid': '023124771046433985428a55844d589b', 'date': '2025-08-05T00:00:00.000Z', 'gameType': 'sprint', 'target': 5000, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 700},
{'uid': '6c873d8e08e949b8bc9aa82aaee71a2e', 'date': '2025-08-06T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 9, 'difficulty': 2.0, 'xp': 5, 'coins': 700},
{'uid': 'fbe2980a5a914399b8f89d4ea4e4cc80', 'date': '2025-08-07T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 13, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': 7, 'difficulty': 2.0, 'xp': 5, 'coins': 700},
{'uid': 'af2ebe34c7ce49708c88f64bb9d82127', 'date': '2025-08-08T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 3, 'minWordLength': 4, 'rows': 6, 'columns': 6, 'duration': 8, 'difficulty': 10, 'xp': 50, 'coins': 1400},
{'uid': '9f9b2e5f829d456face6c8c1652276f7', 'date': '2025-08-09T00:00:00.000Z', 'gameType': 'sprint', 'target': 3000, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 600},
{'uid': 'a7ae139881c349c1b45426be13dc2d94', 'date': '2025-08-10T00:00:00.000Z', 'gameType': 'sprint', 'target': 1800, 'targetType': null, 'timeToPlace': 13, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 1.0, 'xp': 3, 'coins': 700},
{'uid': '7841c417f1c14eb79010c0aa64a3320b', 'date': '2025-08-11T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': 8, 'difficulty': 0.0, 'xp': 3, 'coins': 600},
{'uid': 'd75a9648e9b74eb3aadd8cfb1ab65554', 'date': '2025-08-12T00:00:00.000Z', 'gameType': 'sprint', 'target': 8700, 'targetType': null, 'timeToPlace': 9, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 700},
{'uid': 'f766c89adb2d4c95a387952636a4cf99', 'date': '2025-08-13T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 12, 'difficulty': 2.0, 'xp': 5, 'coins': 600},
{'uid': '61770578fff744a38013b53a0a6ab782', 'date': '2025-08-14T00:00:00.000Z', 'gameType': 'sprint', 'target': 6400, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 0.0, 'xp': 3, 'coins': 600},
{'uid': '655b26d281b747c99a9599f1134239d8', 'date': '2025-08-15T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': 2, 'difficulty': 0.0, 'xp': 3, 'coins': 500},
{'uid': 'cffda9edf8124c5aae13fb9f3cb6e000', 'date': '2025-08-16T00:00:00.000Z', 'gameType': 'sprint', 'target': 8200, 'targetType': null, 'timeToPlace': null, 'minWordLength': 4, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 6.0, 'xp': 10, 'coins': 800},
{'uid': 'e2e0e8b79fb646388fa891883b279d07', 'date': '2025-08-17T00:00:00.000Z', 'gameType': 'sprint', 'target': 4400, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 600},
{'uid': 'b3d71ce5e3ae410db32e080b74d86fe0', 'date': '2025-08-18T00:00:00.000Z', 'gameType': 'sprint', 'target': 9700, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 2.0, 'xp': 5, 'coins': 600},
{'uid': '73244671abee43dd9beb10d4c76f2f0c', 'date': '2025-08-19T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 5, 'difficulty': 2.0, 'xp': 5, 'coins': 700},
{'uid': '29ed5911c40347319747f770daf52e4f', 'date': '2025-08-20T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 10, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': 5, 'difficulty': 3.0, 'xp': 5, 'coins': 800},
{'uid': '12a3ab4c402c4b5e84216713e4cc7a07', 'date': '2025-08-21T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 7, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': 7, 'difficulty': 7.0, 'xp': 15, 'coins': 900},
{'uid': 'b9c169d97b29444d8f587b1f751f64ba', 'date': '2025-08-22T00:00:00.000Z', 'gameType': 'sprint', 'target': 2800, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 0.0, 'xp': 3, 'coins': 600},
{'uid': '33035e56d5d74d6296dd8c71d091cb5c', 'date': '2025-08-23T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 4, 'rows': 6, 'columns': 6, 'duration': 10, 'difficulty': 6.0, 'xp': 10, 'coins': 1000},
{'uid': '4b9c4a2bea594528bd92fcbf414d7fc7', 'date': '2025-08-24T00:00:00.000Z', 'gameType': 'sprint', 'target': 7200, 'targetType': null, 'timeToPlace': 12, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 600},
{'uid': 'b427ae5b8fca4197a7d6b6057ee66fb7', 'date': '2025-08-25T00:00:00.000Z', 'gameType': 'sprint', 'target': 5000, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 2.0, 'xp': 5, 'coins': 700},
{'uid': '60c8e887358443fe912ce7fdcdf75265', 'date': '2025-08-26T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 4, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': 6, 'difficulty': 6.0, 'xp': 10, 'coins': 1000},
{'uid': 'c5fe34d2b7cb4664bdd93c1780b926df', 'date': '2025-08-27T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 10, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 9, 'difficulty': 5.0, 'xp': 5, 'coins': 800},
{'uid': '9bf3ebd85f9d4e539b590a49952488ca', 'date': '2025-08-28T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 3, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 5, 'difficulty': 8.0, 'xp': 20, 'coins': 1100},
{'uid': 'af81822cec4f4d00b65dd15aa447b570', 'date': '2025-08-29T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 12, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': 12, 'difficulty': 5.0, 'xp': 5, 'coins': 800},
{'uid': '3186235fa1e74bb9bdbd910be21b8a0f', 'date': '2025-08-30T00:00:00.000Z', 'gameType': 'sprint', 'target': 9400, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 800},
{'uid': 'aff29eae571d417a828983ee051444cd', 'date': '2025-08-31T00:00:00.000Z', 'gameType': 'sprint', 'target': 3200, 'targetType': null, 'timeToPlace': 14, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 4.0, 'xp': 5, 'coins': 800},
{'uid': 'f8fd71ce3bc247ce9529746c1dac1bc7', 'date': '2025-09-01T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 4, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 12, 'difficulty': 7.0, 'xp': 15, 'coins': 900},
{'uid': '4fc8c661bcc942b3ba339af1c602e3ad', 'date': '2025-09-02T00:00:00.000Z', 'gameType': 'sprint', 'target': 4100, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 2.0, 'xp': 5, 'coins': 700},
{'uid': '9cade922526b443bb58cee17870886db', 'date': '2025-09-03T00:00:00.000Z', 'gameType': 'sprint', 'target': 3300, 'targetType': null, 'timeToPlace': 11, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 2.0, 'xp': 5, 'coins': 600},
{'uid': 'e4c541e439ae4fd281a5d423756f9909', 'date': '2025-09-04T00:00:00.000Z', 'gameType': 'sprint', 'target': 1300, 'targetType': null, 'timeToPlace': 3, 'minWordLength': 4, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 10, 'xp': 50, 'coins': 1600},
{'uid': 'a77ba74bcf994a1ab37bb8cf3f3d0bc0', 'date': '2025-09-05T00:00:00.000Z', 'gameType': 'sprint', 'target': 8300, 'targetType': null, 'timeToPlace': 8, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': null, 'difficulty': 4.0, 'xp': 5, 'coins': 700},
{'uid': 'b18c859fce7c460abefadf19e8f37b3a', 'date': '2025-09-06T00:00:00.000Z', 'gameType': 'sprint', 'target': 8300, 'targetType': null, 'timeToPlace': 15, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 0.0, 'xp': 3, 'coins': 600},
{'uid': '15d0451014f244908a77c11f978dcfa6', 'date': '2025-09-07T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': 9, 'difficulty': 1.0, 'xp': 3, 'coins': 500},
{'uid': '229dd4605a7f49828b2220d37bf521f5', 'date': '2025-09-08T00:00:00.000Z', 'gameType': 'sprint', 'target': 2000, 'targetType': null, 'timeToPlace': 5, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 7.0, 'xp': 15, 'coins': 1000},
{'uid': '6d8ce3120a454df6a633d7ef7b6737c3', 'date': '2025-09-09T00:00:00.000Z', 'gameType': 'sprint', 'target': 4600, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': null, 'difficulty': 1.0, 'xp': 3, 'coins': 600},
{'uid': 'c222603c8191446091a496b7183b6332', 'date': '2025-09-10T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 12, 'difficulty': 2.0, 'xp': 5, 'coins': 700},
{'uid': '005391e3a969459bbd5af8715dc76ad6', 'date': '2025-09-11T00:00:00.000Z', 'gameType': 'sprint', 'target': 9500, 'targetType': null, 'timeToPlace': null, 'minWordLength': 4, 'rows': 7, 'columns': 7, 'duration': null, 'difficulty': 4.0, 'xp': 5, 'coins': 800},
{'uid': '0523f6df5d3e4cd6bbeaa0458b6f72b1', 'date': '2025-09-12T00:00:00.000Z', 'gameType': 'sprint', 'target': 3600, 'targetType': null, 'timeToPlace': 14, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 700},
{'uid': '6c49f5e34d5a4b0f8bbe8d208d153488', 'date': '2025-09-13T00:00:00.000Z', 'gameType': 'sprint', 'target': 3400, 'targetType': null, 'timeToPlace': 8, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 6.0, 'xp': 10, 'coins': 800},
{'uid': '1d01951d81ab4f70a88ce91c2ee3d724', 'date': '2025-09-14T00:00:00.000Z', 'gameType': 'sprint', 'target': 7700, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': null, 'difficulty': 1.0, 'xp': 3, 'coins': 700},
{'uid': '6135bee1df4c4f799370762eb8e76dd9', 'date': '2025-09-15T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': 15, 'difficulty': 3.0, 'xp': 5, 'coins': 700},
{'uid': '562df815ed804128987597b6b73a8f74', 'date': '2025-09-16T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 11, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': 3, 'difficulty': 5.0, 'xp': 5, 'coins': 800},
{'uid': '8ecfb533d287454a8ad2c53965370fe8', 'date': '2025-09-17T00:00:00.000Z', 'gameType': 'sprint', 'target': 4800, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 700},
{'uid': 'c2509c2d6a6146919883a09055a39309', 'date': '2025-09-18T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 7, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': 3, 'difficulty': 7.0, 'xp': 15, 'coins': 1000},
{'uid': 'e52fd654c49e4d21b874a5cebe6c6d84', 'date': '2025-09-19T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 13, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 2, 'difficulty': 3.0, 'xp': 5, 'coins': 800},
{'uid': 'b7103cd4d56d43d9a0c2f10918f810ea', 'date': '2025-09-20T00:00:00.000Z', 'gameType': 'sprint', 'target': 3700, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 700},
{'uid': '0e0872a1621b4e55899fa374db46fec7', 'date': '2025-09-21T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 12, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': 11, 'difficulty': 1.0, 'xp': 3, 'coins': 500},
{'uid': '5b1a1a558e35479fb99c273be76f9b65', 'date': '2025-09-22T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 14, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 3, 'difficulty': 3.0, 'xp': 5, 'coins': 700},
{'uid': '599450cf3552498da784f24711a0af11', 'date': '2025-09-23T00:00:00.000Z', 'gameType': 'sprint', 'target': 3200, 'targetType': null, 'timeToPlace': 4, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 7.0, 'xp': 15, 'coins': 900},
{'uid': '171afad6f06346cdbc7c4f1f10922457', 'date': '2025-09-24T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 8, 'difficulty': 2.0, 'xp': 5, 'coins': 700},
{'uid': '8768b031ec1b47e294dcd1bad19b6001', 'date': '2025-09-25T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': 15, 'difficulty': 3.0, 'xp': 5, 'coins': 800},
{'uid': '56dce32adb4b493fa22c0efe1a866c6d', 'date': '2025-09-26T00:00:00.000Z', 'gameType': 'sprint', 'target': 2300, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 0.0, 'xp': 3, 'coins': 500},
{'uid': '959bb2ec4f0e448aa9512b97a0056d6e', 'date': '2025-09-27T00:00:00.000Z', 'gameType': 'sprint', 'target': 7600, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': null, 'difficulty': 1.0, 'xp': 3, 'coins': 600},
{'uid': '1bd1b2aa70fc47f6b15ffc1485894608', 'date': '2025-09-28T00:00:00.000Z', 'gameType': 'sprint', 'target': 8200, 'targetType': null, 'timeToPlace': 4, 'minWordLength': 4, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 9.0, 'xp': 30, 'coins': 1400},
{'uid': '1256a28260634f8c8b9571ade05ad0c4', 'date': '2025-09-29T00:00:00.000Z', 'gameType': 'sprint', 'target': 5400, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 800},
{'uid': '105e2910344a457487538ef2d0cf24f7', 'date': '2025-09-30T00:00:00.000Z', 'gameType': 'sprint', 'target': 6500, 'targetType': null, 'timeToPlace': 13, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 1.0, 'xp': 3, 'coins': 700},
{'uid': 'd9f62a2d94874f4e93c3defd980b207a', 'date': '2025-10-01T00:00:00.000Z', 'gameType': 'sprint', 'target': 6800, 'targetType': null, 'timeToPlace': 6, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 8.0, 'xp': 20, 'coins': 1100},
{'uid': 'a71bb15cd68f4467892a942dbe6c8b22', 'date': '2025-10-02T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 12, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 12, 'difficulty': 4.0, 'xp': 5, 'coins': 700},
{'uid': '21d3b874320c49b289211d94d1d6ef9f', 'date': '2025-10-03T00:00:00.000Z', 'gameType': 'sprint', 'target': 2500, 'targetType': null, 'timeToPlace': 9, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 5.0, 'xp': 5, 'coins': 700},
{'uid': '5c84d69d3b8d4b64bde6a961e7215322', 'date': '2025-10-04T00:00:00.000Z', 'gameType': 'sprint', 'target': 3500, 'targetType': null, 'timeToPlace': 8, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 7.0, 'xp': 15, 'coins': 1000},
{'uid': '3faf6e2ce26242d1918799b269c0fddb', 'date': '2025-10-05T00:00:00.000Z', 'gameType': 'sprint', 'target': 4300, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 0.0, 'xp': 3, 'coins': 500},
{'uid': '97bdf127b5b24251b2f2b6c931463928', 'date': '2025-10-06T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': 12, 'difficulty': 0.0, 'xp': 3, 'coins': 600},
{'uid': 'e72ccca6182f4e68923ddbe5e0c21ad9', 'date': '2025-10-07T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 9, 'difficulty': 2.0, 'xp': 5, 'coins': 600},
{'uid': '4da34baa702f49ddb1359b4cf2761de6', 'date': '2025-10-08T00:00:00.000Z', 'gameType': 'sprint', 'target': 3400, 'targetType': null, 'timeToPlace': 14, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 600},
{'uid': '2b471f93450f47eebd3d90b6cb669ba4', 'date': '2025-10-09T00:00:00.000Z', 'gameType': 'sprint', 'target': 3900, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 800},
{'uid': '169bfb36ca484e5da529ff71e9287917', 'date': '2025-10-10T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': 11, 'difficulty': 0.0, 'xp': 3, 'coins': 600},
{'uid': '2f28b3cb313f4ce0934196b92b8357c4', 'date': '2025-10-11T00:00:00.000Z', 'gameType': 'sprint', 'target': 3000, 'targetType': null, 'timeToPlace': 14, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 4.0, 'xp': 5, 'coins': 800},
{'uid': '55f226d6aee14aabac9ee320d204bc47', 'date': '2025-10-12T00:00:00.000Z', 'gameType': 'sprint', 'target': 9200, 'targetType': null, 'timeToPlace': 13, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 4.0, 'xp': 5, 'coins': 800},
{'uid': '1912b9d56ffa498484c477a6af0cb78b', 'date': '2025-10-13T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': 2, 'difficulty': 1.0, 'xp': 3, 'coins': 600},
{'uid': '2506ab9d506244b8a3cf447021e300be', 'date': '2025-10-14T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 8, 'difficulty': 2.0, 'xp': 5, 'coins': 700},
{'uid': 'dfb46a442238451a96e5f53f9aefe66b', 'date': '2025-10-15T00:00:00.000Z', 'gameType': 'sprint', 'target': 2000, 'targetType': null, 'timeToPlace': 6, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 7.0, 'xp': 15, 'coins': 1000},
{'uid': '4643c7298e7b4ac6847ea05e8d5f53c2', 'date': '2025-10-16T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 11, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 2, 'difficulty': 4.0, 'xp': 5, 'coins': 700},
{'uid': '286d89eb23094405aee9073f2520ae77', 'date': '2025-10-17T00:00:00.000Z', 'gameType': 'sprint', 'target': 5500, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 600},
{'uid': '6d8d02a0610a4f258bff8c8b61385b7a', 'date': '2025-10-18T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 7, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': 6, 'difficulty': 7.0, 'xp': 15, 'coins': 900},
{'uid': 'f7e6fa1a82b34dd5b4fe552f642f8dd9', 'date': '2025-10-19T00:00:00.000Z', 'gameType': 'sprint', 'target': 1700, 'targetType': null, 'timeToPlace': 11, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 2.0, 'xp': 5, 'coins': 600},
{'uid': '9e2e2a8a76ec4e5eafcb9dee0f671fc2', 'date': '2025-10-20T00:00:00.000Z', 'gameType': 'sprint', 'target': 2200, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 700},
{'uid': '46d7be6ccb1c45c8b27b194b33d102f9', 'date': '2025-10-21T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 12, 'difficulty': 2.0, 'xp': 5, 'coins': 600},
{'uid': 'a1df18cd1cd34e3a980403db99007744', 'date': '2025-10-22T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 7, 'difficulty': 2.0, 'xp': 5, 'coins': 600},
{'uid': '65c9a2f481df4294bf603b9cd04444d6', 'date': '2025-10-23T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 10, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 3, 'difficulty': 5.0, 'xp': 5, 'coins': 900},
{'uid': '610f26396f164c00a4454fc184571257', 'date': '2025-10-24T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 12, 'difficulty': 2.0, 'xp': 5, 'coins': 600},
{'uid': 'abcf1d7b77fd430fb2ef30eb82b22125', 'date': '2025-10-25T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 9, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': 5, 'difficulty': 3.0, 'xp': 5, 'coins': 800},
{'uid': 'ae31c0c3777d4f56bf96d54c7bda2dad', 'date': '2025-10-26T00:00:00.000Z', 'gameType': 'sprint', 'target': 8100, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 800},
{'uid': '8ff5e45dec35448f9197f3459c24fbab', 'date': '2025-10-27T00:00:00.000Z', 'gameType': 'sprint', 'target': 1400, 'targetType': null, 'timeToPlace': 5, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': null, 'difficulty': 6.0, 'xp': 10, 'coins': 900},
{'uid': 'dbe19278c7d245a4bccd735e9995e977', 'date': '2025-10-28T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 15, 'difficulty': 2.0, 'xp': 5, 'coins': 700},
{'uid': '53fada57ab6e4edb9125e4aa596bb6b3', 'date': '2025-10-29T00:00:00.000Z', 'gameType': 'sprint', 'target': 5700, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 2.0, 'xp': 5, 'coins': 700},
{'uid': '37f3a69a82704e879197c1be0353faca', 'date': '2025-10-30T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 8, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': 13, 'difficulty': 7.0, 'xp': 15, 'coins': 900},
{'uid': '13db94d73b9b410a92899ac5f9e55fb4', 'date': '2025-10-31T00:00:00.000Z', 'gameType': 'sprint', 'target': 5800, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': null, 'difficulty': 1.0, 'xp': 3, 'coins': 700},
{'uid': 'e26d29abdb684f1e9c96caab23a388be', 'date': '2025-11-01T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 13, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 9, 'difficulty': 3.0, 'xp': 5, 'coins': 800},
{'uid': '33d7ad4e88d74030909e6fa7b93fa159', 'date': '2025-11-02T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 13, 'difficulty': 2.0, 'xp': 5, 'coins': 700},
{'uid': 'f2a128b10cf44f1797b46703dd1f7af7', 'date': '2025-11-03T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': 3, 'difficulty': 0.0, 'xp': 3, 'coins': 600},
{'uid': '9a872cb41a2444d58de8b594f5f8a79f', 'date': '2025-11-04T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 4, 'rows': 6, 'columns': 6, 'duration': 2, 'difficulty': 6.0, 'xp': 10, 'coins': 800},
{'uid': '4305eb2e61dd483a8fde5d30bd7f1b5d', 'date': '2025-11-05T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 4, 'rows': 8, 'columns': 8, 'duration': 9, 'difficulty': 3.0, 'xp': 5, 'coins': 800},
{'uid': 'd05ed091ea504581bb603faa488f9727', 'date': '2025-11-06T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 10, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': 8, 'difficulty': 3.0, 'xp': 5, 'coins': 800},
{'uid': '05ef769851ec4e1a8a983821afd09b41', 'date': '2025-11-07T00:00:00.000Z', 'gameType': 'sprint', 'target': 7600, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 600},
{'uid': '8f1bd7a848614aa1b271dbf0e2374437', 'date': '2025-11-08T00:00:00.000Z', 'gameType': 'sprint', 'target': 6700, 'targetType': null, 'timeToPlace': 4, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': null, 'difficulty': 6.0, 'xp': 10, 'coins': 800},
{'uid': 'cbfaed32ab4b4652bbc953c5d55698ef', 'date': '2025-11-09T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': 2, 'difficulty': 0.0, 'xp': 3, 'coins': 500},
{'uid': 'f5e8278ac2784f0fbef47562fc38329c', 'date': '2025-11-10T00:00:00.000Z', 'gameType': 'sprint', 'target': 1300, 'targetType': null, 'timeToPlace': null, 'minWordLength': 4, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 600},
{'uid': 'fe23e1dbfbf04ef98105463f451d9a83', 'date': '2025-11-11T00:00:00.000Z', 'gameType': 'sprint', 'target': 9100, 'targetType': null, 'timeToPlace': 10, 'minWordLength': 4, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 6.0, 'xp': 10, 'coins': 1000},
{'uid': '43578743f56c406f9edccaf3a45ce824', 'date': '2025-11-12T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': 6, 'difficulty': 1.0, 'xp': 3, 'coins': 500},
{'uid': '04a4e794779a47a89632992df298ed54', 'date': '2025-11-13T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 3, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': 8, 'difficulty': 6.0, 'xp': 10, 'coins': 1000},
{'uid': 'b8e453d6bc1e4748bd43c59a7c81855d', 'date': '2025-11-14T00:00:00.000Z', 'gameType': 'sprint', 'target': 3700, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 800},
{'uid': 'd61a2ed0d1b64dc1975ecf68c2db12c0', 'date': '2025-11-15T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': 7, 'difficulty': 3.0, 'xp': 5, 'coins': 800},
{'uid': '48e207d95c95444c95fb56b3254fd3e6', 'date': '2025-11-16T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': 9, 'difficulty': 0.0, 'xp': 3, 'coins': 500},
{'uid': 'e1c8e61e8c50406787ab69693b914046', 'date': '2025-11-17T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 14, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': 2, 'difficulty': 4.0, 'xp': 5, 'coins': 800},
{'uid': '704ef977b9a8447c90e78da0ef359e13', 'date': '2025-11-18T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 4, 'rows': 7, 'columns': 7, 'duration': 12, 'difficulty': 4.0, 'xp': 5, 'coins': 800},
{'uid': '8f67ef6ad51f4efba68d8eab888d7d19', 'date': '2025-11-19T00:00:00.000Z', 'gameType': 'sprint', 'target': 5000, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': null, 'difficulty': 1.0, 'xp': 3, 'coins': 500},
{'uid': '08b712d3ddad4c7bb75a8e5d353f3104', 'date': '2025-11-20T00:00:00.000Z', 'gameType': 'sprint', 'target': 5600, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 2.0, 'xp': 5, 'coins': 700},
{'uid': 'e0de4feb2b2c4d869a8e8d46326e4c97', 'date': '2025-11-21T00:00:00.000Z', 'gameType': 'sprint', 'target': 4400, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 700},
{'uid': '1d3460cf46764751931ebc0a6f340992', 'date': '2025-11-22T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 13, 'minWordLength': 4, 'rows': 8, 'columns': 8, 'duration': 12, 'difficulty': 4.0, 'xp': 5, 'coins': 800},
{'uid': '9352edc5b7fe4447a049c66a1e26582d', 'date': '2025-11-23T00:00:00.000Z', 'gameType': 'sprint', 'target': 6700, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 0.0, 'xp': 3, 'coins': 600},
{'uid': '7a89eda8a318408da561c69e840f63e1', 'date': '2025-11-24T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 8, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': 10, 'difficulty': 3.0, 'xp': 5, 'coins': 700},
{'uid': 'b0dab6aa5c1a408ab213aa5b35488684', 'date': '2025-11-25T00:00:00.000Z', 'gameType': 'sprint', 'target': 8800, 'targetType': null, 'timeToPlace': 14, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 4.0, 'xp': 5, 'coins': 700},
{'uid': 'df4193d7e32b4e3aa1f6ae97d60254b9', 'date': '2025-11-26T00:00:00.000Z', 'gameType': 'sprint', 'target': 7000, 'targetType': null, 'timeToPlace': 12, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 1.0, 'xp': 3, 'coins': 600},
{'uid': 'e4e3e57c1ca24dddbbf09a596429568e', 'date': '2025-11-27T00:00:00.000Z', 'gameType': 'sprint', 'target': 6000, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 2.0, 'xp': 5, 'coins': 600},
{'uid': 'db01fcb5b17f432faf36dc16899a245e', 'date': '2025-11-28T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 9, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': 2, 'difficulty': 4.0, 'xp': 5, 'coins': 800},
{'uid': '807d16b7c9674025a6e7e85452437528', 'date': '2025-11-29T00:00:00.000Z', 'gameType': 'sprint', 'target': 4700, 'targetType': null, 'timeToPlace': 3, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 6.0, 'xp': 10, 'coins': 800},
{'uid': '90d66a643377434cb03cab9ea6b1e325', 'date': '2025-11-30T00:00:00.000Z', 'gameType': 'sprint', 'target': 5800, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 700},
{'uid': 'ee192eb32c534736b987c0261a8b292c', 'date': '2025-12-01T00:00:00.000Z', 'gameType': 'sprint', 'target': 6200, 'targetType': null, 'timeToPlace': 11, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 5.0, 'xp': 5, 'coins': 700},
{'uid': '485f3ff8870b420ca2f2e36062491cde', 'date': '2025-12-02T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': 2, 'difficulty': 1.0, 'xp': 3, 'coins': 700},
{'uid': '2ede4737853f4a4899e5ef19a0574d86', 'date': '2025-12-03T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 14, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': 13, 'difficulty': 2.0, 'xp': 5, 'coins': 700},
{'uid': '4f9937698d894f049a0c7d35d6438b29', 'date': '2025-12-04T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 4, 'minWordLength': 4, 'rows': 7, 'columns': 7, 'duration': 7, 'difficulty': 10.0, 'xp': 50, 'coins': 2000},
{'uid': '65ffb4a5bfdc44c3be37bae64b3d221e', 'date': '2025-12-05T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 2, 'difficulty': 2.0, 'xp': 5, 'coins': 600},
{'uid': 'fc4546d0b3e44ccf959baaf82eb28440', 'date': '2025-12-06T00:00:00.000Z', 'gameType': 'sprint', 'target': 6000, 'targetType': null, 'timeToPlace': 15, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 800},
{'uid': '378705aa5bda4d369618d8becf11ba47', 'date': '2025-12-07T00:00:00.000Z', 'gameType': 'sprint', 'target': 8800, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': null, 'difficulty': 1.0, 'xp': 3, 'coins': 600},
{'uid': '6723ffd0a3b04fa59df9d6706b59d29b', 'date': '2025-12-08T00:00:00.000Z', 'gameType': 'sprint', 'target': 5000, 'targetType': null, 'timeToPlace': 12, 'minWordLength': 4, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 7.0, 'xp': 15, 'coins': 1000},
{'uid': '82437381a32840a29fdebbdb0d49849c', 'date': '2025-12-09T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 6, 'minWordLength': 4, 'rows': 7, 'columns': 7, 'duration': 13, 'difficulty': 9.0, 'xp': 30, 'coins': 1300},
{'uid': 'df04bddae2a646608cffc5b4d1ef7a8c', 'date': '2025-12-10T00:00:00.000Z', 'gameType': 'sprint', 'target': 5700, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 0.0, 'xp': 3, 'coins': 600},
{'uid': '56cf556765a34b01af085107006dfbfc', 'date': '2025-12-11T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 7, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': 2, 'difficulty': 4.0, 'xp': 5, 'coins': 700},
{'uid': 'b026de68a4214d01b404e839cf7aca3f', 'date': '2025-12-12T00:00:00.000Z', 'gameType': 'sprint', 'target': 4100, 'targetType': null, 'timeToPlace': null, 'minWordLength': 4, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 800},
{'uid': '0079bb3cc5294dbe9a48dc69c43e2cce', 'date': '2025-12-13T00:00:00.000Z', 'gameType': 'sprint', 'target': 1400, 'targetType': null, 'timeToPlace': 10, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 2.0, 'xp': 5, 'coins': 700},
{'uid': '6a468f41d64e4dcda321c70c58efc0e3', 'date': '2025-12-14T00:00:00.000Z', 'gameType': 'sprint', 'target': 1800, 'targetType': null, 'timeToPlace': 13, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 700},
{'uid': 'defcf643612d4e4e8f906300ba6649dc', 'date': '2025-12-15T00:00:00.000Z', 'gameType': 'sprint', 'target': 9800, 'targetType': null, 'timeToPlace': 8, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 6.0, 'xp': 10, 'coins': 1000},
{'uid': 'd8f9a74d940d47919c4b701df53b2b58', 'date': '2025-12-16T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': 5, 'difficulty': 3.0, 'xp': 5, 'coins': 600},
{'uid': 'e6ef8e5a91fa46fab93018a44833106d', 'date': '2025-12-17T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': 10, 'difficulty': 2.0, 'xp': 5, 'coins': 600},
{'uid': '20b3101065fe4fd2bd1f86d4ac135b23', 'date': '2025-12-18T00:00:00.000Z', 'gameType': 'sprint', 'target': 1900, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': null, 'difficulty': 1.0, 'xp': 3, 'coins': 700},
{'uid': '081d4f41ce6c4acea61f84f43c830ed1', 'date': '2025-12-19T00:00:00.000Z', 'gameType': 'sprint', 'target': 5700, 'targetType': null, 'timeToPlace': 6, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 8.0, 'xp': 20, 'coins': 1100},
{'uid': '763718fe164449e0ab927a12be084e06', 'date': '2025-12-20T00:00:00.000Z', 'gameType': 'sprint', 'target': 2700, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': null, 'difficulty': 1.0, 'xp': 3, 'coins': 600},
{'uid': '9591e1cd0284491480411232aba46ddd', 'date': '2025-12-21T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 4, 'rows': 8, 'columns': 8, 'duration': 9, 'difficulty': 3.0, 'xp': 5, 'coins': 800},
{'uid': 'd1c292eb5652431d8f2fe06f448a76cc', 'date': '2025-12-22T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': 2, 'difficulty': 1.0, 'xp': 3, 'coins': 600},
{'uid': '170bcda927f8412798ed9afcedae140a', 'date': '2025-12-23T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': 2, 'difficulty': 0.0, 'xp': 3, 'coins': 500},
{'uid': '823bec43b6aa4049aca4a58f8fc17675', 'date': '2025-12-24T00:00:00.000Z', 'gameType': 'sprint', 'target': 4500, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 6, 'columns': 6, 'duration': null, 'difficulty': 2.0, 'xp': 5, 'coins': 700},
{'uid': 'a3e1f9b453204aeaa14dd5fb264c935f', 'date': '2025-12-25T00:00:00.000Z', 'gameType': 'sprint', 'target': 8600, 'targetType': null, 'timeToPlace': 8, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 600},
{'uid': '1cc7e7f81f82422795cd70867208caac', 'date': '2025-12-26T00:00:00.000Z', 'gameType': 'sprint', 'target': 6200, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 0.0, 'xp': 3, 'coins': 600},
{'uid': '90dd6cf564014b4396329f7f59326eb5', 'date': '2025-12-27T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': null, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': 9, 'difficulty': 0.0, 'xp': 3, 'coins': 600},
{'uid': 'eb6d905c108849a08fda9a1f45ad5f78', 'date': '2025-12-28T00:00:00.000Z', 'gameType': 'classic', 'target': null, 'targetType': null, 'timeToPlace': 4, 'minWordLength': 3, 'rows': 7, 'columns': 7, 'duration': 12, 'difficulty': 6.0, 'xp': 10, 'coins': 1000},
{'uid': 'c339d85fbe8c4e57a5d5405fef4d6909', 'date': '2025-12-29T00:00:00.000Z', 'gameType': 'sprint', 'target': 7400, 'targetType': null, 'timeToPlace': 9, 'minWordLength': 3, 'rows': 5, 'columns': 5, 'duration': null, 'difficulty': 6.0, 'xp': 10, 'coins': 900},
{'uid': '4e8af5693e5540819b532ea7f254ab84', 'date': '2025-12-30T00:00:00.000Z', 'gameType': 'sprint', 'target': 5500, 'targetType': null, 'timeToPlace': 9, 'minWordLength': 3, 'rows': 8, 'columns': 8, 'duration': null, 'difficulty': 3.0, 'xp': 5, 'coins': 600},
];