import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/functions/initializations.dart';
import 'package:scribby_flutter_v2/providers/ad_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/screens/game_screen/game_screen.dart';
// import 'package:scribby_flutter_v2/screens/temp_screen.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';

class NewGameDialog extends StatefulWidget {
  final MediaQueryData mediaQueryData;
  const NewGameDialog({super.key, required this.mediaQueryData});

  @override
  State<NewGameDialog> createState() => _NewGameDialogState();
}

class _NewGameDialogState extends State<NewGameDialog> {

  TextEditingController gameTypeController = TextEditingController();
  String gameTypeChoice = "classic";
  int rowValue = 6;
  int colValue = 6;
  // int? target = null;
  String? targetType = null;
  List<int> timesInMinutes = [1,2,3,4,5,6,7,8,9,10,15,20,30,40,50,60]; //List.generate(59, (e)=>e+1).toList();
  List<int> pointTargets = List.generate(20, (e)=>500 + (e*500)).toList();
  List<int> gridTargets = List.generate(4, (e)=>5 + e).toList();
  List<int?> timesToPlace = [null,3,4,5,6,7,8,9,10,11,12];

  late int durationIndex = 9; // 10 minutes
  late int targetPointsIndex = 7;
  final int initialGridItem = 1; // 8 by 8 grid
  final int initialTimeToPlaceItem = 0; // 8 by 8 grid

  FixedExtentScrollController? durationController;
  FixedExtentScrollController? pointsController;
  FixedExtentScrollController? gridRowController;
  FixedExtentScrollController? gridColumnController;
  FixedExtentScrollController? timesToPlaceController;

  int? durationInMinutes = null;
  int? targetPoints = null;
  int? gridAxis = null;
  int? timeToPlace = null;
  Map<String,dynamic> gameTypeInfo = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    

    durationController = FixedExtentScrollController(initialItem: durationIndex);
    pointsController = FixedExtentScrollController(initialItem: targetPointsIndex);
    gridRowController = FixedExtentScrollController(initialItem: initialGridItem);
    gridColumnController = FixedExtentScrollController(initialItem: initialGridItem);
    timesToPlaceController = FixedExtentScrollController(initialItem: initialTimeToPlaceItem);

    // int? item = null;
    // timesToPlace.insert(0,item);
    // print("timesToPlace: $timesToPlace | ${timesToPlace}");

    durationInMinutes = timesInMinutes[durationIndex]; 
    targetPoints = pointTargets[targetPointsIndex]; 
    gridAxis = gridTargets[initialGridItem]; 
    timeToPlace = timesToPlace[initialTimeToPlaceItem];     

    if (gameTypeChoice == "classic") {
      targetPoints = null;
    }

    if (gameTypeChoice == "sprint") {
      durationInMinutes = null;
    }



  }

  void generateRandomGame() {
    Random random = Random();

    // game type
    int gameTypeChoiceIndex = random.nextInt(2);
    

    // duration (can be null)
    int randomTimesInMinutesIndex = random.nextInt(timesInMinutes.length);
    


    // target (can be null)
    int pointsTargetIndex = random.nextInt(pointTargets.length);
    
    

    // time to move (can be null)
    int timeToPlaceIndexRaw = random.nextInt(timesToPlace.length*2);
    int timeToPlaceIndex = timeToPlaceIndexRaw;
    if (timeToPlaceIndexRaw>timesToPlace.length-1) {
      timeToPlaceIndex = 0;
    }
    timesToPlaceController!.animateToItem(timeToPlaceIndex,duration: Duration(milliseconds: 200), curve: Curves.decelerate);

    // rows 
    int randomRowIndex = random.nextInt(gridTargets.length);
    gridRowController!.animateToItem(randomRowIndex,duration: Duration(milliseconds: 200), curve: Curves.decelerate);

    // cols
    int randomColumnIndex = random.nextInt(gridTargets.length);
    gridColumnController!.animateToItem(randomColumnIndex,duration: Duration(milliseconds: 200), curve: Curves.decelerate);


    setState(() {
      // game type
      gameTypeChoice = ["classic","sprint"][gameTypeChoiceIndex];

      // game duration
      durationIndex = randomTimesInMinutesIndex;
      durationInMinutes = timesInMinutes[durationIndex];
      if (gameTypeChoice=='sprint') {
        durationInMinutes = null;
      } else {
        durationController!.animateToItem(durationIndex,duration: Duration(milliseconds: 200), curve: Curves.decelerate);
      }
      
      // target
      targetPointsIndex = pointsTargetIndex;
      targetPoints = pointTargets[targetPointsIndex];
      if (gameTypeChoice=='classic') {
        targetPoints = null;
      } else {
        pointsController!.animateToItem(targetPointsIndex,duration: Duration(milliseconds: 200), curve: Curves.decelerate);
      }

      print("generateRandomGame() durationInMinutes: $durationInMinutes");

      // time to place
      timeToPlace = timesToPlace[timeToPlaceIndex];

      // grid values
      rowValue = gridTargets[randomRowIndex];
      colValue = gridTargets[randomColumnIndex];

    });

  }



  @override
  Widget build(BuildContext context) {
    // final _style = Theme.of(context).textTheme.displaySmall;


    // SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);
    ColorPalette palette = Provider.of<ColorPalette>(context);
    SettingsController settings = Provider.of<SettingsController>(context, listen: false);
    final double scalor = Helpers().getScalor(settings);
    Map<String,dynamic> userData = settings.userData.value as Map<String,dynamic>;
    bool showTutorialButton = false;
    if (!userData["parameters"]["tutorialComplete"]) {
      showTutorialButton = true;
    }
    // AdState adState = Provider.of<AdState>(context, listen: false);
    gameTypeInfo = settings.gameInfoData.value.firstWhere((e) => e["name"]==gameTypeChoice, orElse: () => {});




    final double widgetHeight = 40*scalor;
    return Consumer<GamePlayState>(
      builder: (context,gamePlayState,child) {
        return Dialog(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0*scalor))),
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                radius: 0.6*scalor,
                colors: [palette.dialogBg1,palette.dialogBg2]
              ),
              borderRadius: BorderRadius.all(Radius.circular(12.0*scalor))
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(12.0*scalor,4.0*scalor,12.0*scalor,4.0*scalor),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0*scalor),
                    child: Text(
                      "New Game!",
                      style: palette.mainAppFont(
                        textStyle: TextStyle(
                          color: palette.text1,
                          fontSize: 32*scalor
                        ),
                      ),
                    ),
                  ),
                  
                  SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
              
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                "Game Type:",
                                style: GoogleFonts.lilitaOne(
                                  color: palette.text1,
                                  fontSize: 22*scalor
                                ),
                              )
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                height: widgetHeight,
                                decoration: BoxDecoration(
                                  border: Border.all(color: palette.text2),
                                  borderRadius: BorderRadius.all(Radius.circular(8.0*scalor)),
                                  color: Colors.transparent
                                ),
                                child: Center(
                                  child: DropdownButton(
                                    iconEnabledColor: const Color.fromARGB(0, 0, 0, 0),
                                    underline: Divider(color: Colors.transparent,),
                                    alignment: Alignment.center,
                                    value: gameTypeChoice,
                                    items: [
                                      DropdownMenuItem(value: "classic",child: Text("Classic",style: TextStyle(color: palette.text1),)),
                                      // DropdownMenuItem(value: "timed-move",child: Text("Timed-Move",style: TextStyle(color: palette.widgetText1),)), 
                                      DropdownMenuItem(value: "sprint",child: Text("Sprint",style: TextStyle(color: palette.text1),)), 
                                      // DropdownMenuItem(value: "arcade",child: Text("Arcade",style: TextStyle(color: palette.widgetText1),)),                          
                                    ],
                                    dropdownColor: palette.widget1,
                                    borderRadius: BorderRadius.all(Radius.circular(12.0*scalor)),
                                    style: GoogleFonts.lilitaOne(
                                      color: palette.text1,
                                      fontSize: 18*scalor,
                                  
                                    ),
                                    
                                    onChanged: (dynamic value) {
                                      setState(() {
                                        gameTypeChoice = value;
                                        if (value == 'sprint') {
                                          durationInMinutes = null;
                                          targetPoints = pointTargets[targetPointsIndex]; 
                                          print("change this up: $targetPoints");
                                        }
                                        if (gameTypeChoice == "classic") {
                                          durationInMinutes = timesInMinutes[durationIndex];
                                          targetPoints = null;
                                        }
                                      });              
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                  
                  
                        gameTypeInfo.isEmpty
                         ? SizedBox()
                         : Padding(
                           padding: EdgeInsets.all(8.0*scalor),
                           child: Text(
                            gameTypeInfo["description"],
                            style: GoogleFonts.permanentMarker(
                              color: palette.text1,
                              fontSize: 20*scalor,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w400
                            ),
                                                   ),
                         ),
                        // Text(""),
                            
                        SizedBox(height: 22*scalor,),
                            
                        // gameTypeChoice == "classic" || gameTypeChoice == "timed-move" ?
                            
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                "Duration:",
                                style: GoogleFonts.lilitaOne(
                                  color: gameTypeChoice == "classic" ? palette.text1 : palette.text1.withAlpha(150),
                                  fontSize: 22*scalor
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                height: widgetHeight,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: gameTypeChoice == "classic" ? palette.text2 : palette.text2.withAlpha(150) 
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(8.0*scalor))
                                ),
                                child:ListWheelScrollView.useDelegate(
                                  
                                  physics: gameTypeChoice == "classic" ? FixedExtentScrollPhysics() : NeverScrollableScrollPhysics(),
                                  controller: durationController,
                                  itemExtent: widgetHeight*0.6 ,
                                  perspective: 0.0001,
                                  childDelegate: ListWheelChildLoopingListDelegate(
                                    children: getListOfGameDurations(timesInMinutes,scalor,palette,gameTypeChoice)
                                  ),
                                  onSelectedItemChanged: (dynamic value) {
                                    int updatedValue = timesInMinutes[value];
                                    setState(() {
                                      durationInMinutes = updatedValue;
                                    });
                                  },
                                  
                                )
                                
                              ),
                            ),
                          ],
                        ),
                            
                        SizedBox(height: 22*scalor,),
                            
                    
                        // if (gameTypeChoice == "sprint") 
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                "Target: ",
                                style: GoogleFonts.lilitaOne(
                                  color: gameTypeChoice == "sprint" ? palette.text1 : palette.text1.withOpacity(0.5),
                                  fontSize: 22*scalor
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                height: widgetHeight,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: gameTypeChoice == "classic" ? palette.text2.withAlpha(150) : palette.text2
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(8.0*scalor))
                                ),
                                child: ListWheelScrollView.useDelegate(
                                  
                                  physics: gameTypeChoice == "classic" ? NeverScrollableScrollPhysics() : FixedExtentScrollPhysics(),
                                  controller: pointsController,
                                  itemExtent: widgetHeight*0.6 ,
                                  perspective: 0.0001,
                                  childDelegate: ListWheelChildLoopingListDelegate(
                                    children: getListOfPointTargets(pointTargets,scalor,palette,gameTypeChoice)
                                  ),
                                  onSelectedItemChanged: (dynamic value) {
                                    // int updatedValue = ;
                                    setState(() {
                                      targetPoints = pointTargets[value];
                                    });
                                  },
                                ) 

                                // Center(
                                //   child: Text(
                                //     "Unlimited",
                                //     style: GoogleFonts.lilitaOne(
                                //       color:  gameTypeChoice == "sprint" ? palette.text1 : palette.text1.withOpacity(0.5),
                                //       fontSize: 22*scalor
                                //     ),
                                //   )
                                // )
                              ),
                            ),
                          ],
                        ),
                            
                        
                        SizedBox(height: 22*scalor,),
                            
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                "Time to Move: ",
                                style: GoogleFonts.lilitaOne(
                                  color: palette.text1,
                                  fontSize: 22*scalor
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                height: widgetHeight,
                                decoration: BoxDecoration(
                                  border: Border.all(color: palette.text2),
                                  borderRadius: BorderRadius.all(Radius.circular(8.0*scalor))
                                ),
                                child: ListWheelScrollView.useDelegate(
                                  
                                  physics: FixedExtentScrollPhysics(),
                                  controller: timesToPlaceController,
                                  itemExtent: widgetHeight*0.6 ,
                                  perspective: 0.0001,
                                  childDelegate: ListWheelChildLoopingListDelegate(
                                    children: getListOfTimesToPlace(timesToPlace,scalor,palette)
                                  ),
                                  onSelectedItemChanged: (dynamic value) {
                                    // int updatedValue = ;
                                    setState(() {
                                      timeToPlace = timesToPlace[value];
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                                                    
                        
                        // SizedBox(height: 22*scalor,),


                          
                  
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       flex: 3,
                        //       child: Text(
                        //         "Board: ",
                        //         style: GoogleFonts.lilitaOne(
                        //           color: palette.text1,
                        //           fontSize: 22*scalor
                        //         ),
                        //       ),
                        //     ),
                        //     Expanded(
                        //       flex: 3,
                        //       child: Container(
                        //         height: widgetHeight,
                        //         decoration: BoxDecoration(
                        //           border: Border.all(color: palette.text2),
                        //           borderRadius: BorderRadius.all(Radius.circular(8.0*scalor))
                        //         ),
                        //         child: ListWheelScrollView.useDelegate(
                                  
                        //           physics: FixedExtentScrollPhysics(),
                        //           controller: gridController,
                        //           itemExtent: widgetHeight*0.6 ,
                        //           perspective: 0.0001,
                        //           childDelegate: ListWheelChildLoopingListDelegate(
                        //             children: getListOfGrids(gridTargets,scalor,palette)
                        //           ),
                        //           onSelectedItemChanged: (dynamic value) {
                        //             // int updatedValue = ;
                        //             setState(() {
                        //               gridAxis = gridTargets[value];
                        //             });
                        //           },
                        //         )
                        //       ),
                        //     ),
                        //   ],
                        // ),

                        SizedBox(height: 22*scalor,),

                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                "Board: ",
                                style: GoogleFonts.lilitaOne(
                                  color: palette.text1,
                                  fontSize: 22*scalor
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: widgetHeight,
                                decoration: BoxDecoration(
                                  border: Border.all(color: palette.text2),
                                  borderRadius: BorderRadius.all(Radius.circular(8.0*scalor))
                                ),
                                child: ListWheelScrollView.useDelegate(
                                  
                                  physics: FixedExtentScrollPhysics(),
                                  controller: gridRowController,
                                  itemExtent: widgetHeight*0.6 ,
                                  perspective: 0.0001,
                                  childDelegate: ListWheelChildLoopingListDelegate(
                                    children: getListOfAxisNumbers(gridTargets,scalor,palette)
                                  ),
                                  onSelectedItemChanged: (dynamic value) {
                                    // int updatedValue = ;
                                    setState(() {
                                      rowValue = gridTargets[value];
                                      // gridAxis = gridTargets[value];
                                    });
                                  },
                                )
                              ),
                            ),

                            Expanded(
                              flex: 1,
                              child: Center(
                                child: Text(
                                  "by",
                                  style: GoogleFonts.lilitaOne(
                                    color: palette.text1,
                                    fontSize: 22*scalor
                                  ),
                                ),
                              ),
                            ),                            

                            Expanded(
                              flex: 1,
                              child: Container(
                                height: widgetHeight,
                                decoration: BoxDecoration(
                                  border: Border.all(color: palette.text2),
                                  borderRadius: BorderRadius.all(Radius.circular(8.0*scalor))
                                ),
                                child: ListWheelScrollView.useDelegate(
                                  
                                  physics: FixedExtentScrollPhysics(),
                                  controller: gridColumnController,
                                  itemExtent: widgetHeight*0.6 ,
                                  perspective: 0.0001,
                                  childDelegate: ListWheelChildLoopingListDelegate(
                                    children: getListOfAxisNumbers(gridTargets,scalor,palette)
                                  ),
                                  onSelectedItemChanged: (dynamic value) {
                                    // int updatedValue = ;
                                    setState(() {
                                      // gridAxis = gridTargets[value];
                                      colValue = gridTargets[value];
                                    });
                                  },
                                )
                              ),
                            ),                            
                          ],
                        ),                        
                  

                        Builder(
                          builder: (context) {
                            if (showTutorialButton) {
                              return Column(
                                children: [
                                  SizedBox(height: 22*scalor,),
                                  Divider(thickness: 1.0,color: const Color.fromARGB(155, 158, 158, 158),),
                                  Padding(
                                    padding: EdgeInsets.all(8.0*scalor),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: palette.widget2,
                                        foregroundColor: palette.widgetText2,
                                        minimumSize: Size(0.0, 0.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(8))
                                        )
                                      ),
                                      onPressed: () {        
                                        Initializations().startGame(
                                          gamePlayState,
                                          "tutorial",
                                          null,
                                          null,
                                          gridTargets[1],
                                          gridTargets[1],
                                          null,
                                          null,
                                          settings,
                                          widget.mediaQueryData,
                                          context,
                                          palette,
                                        );
                                      },
                                      
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(8.0*scalor,4.0*scalor,8.0*scalor,4.0*scalor),
                                        child: Text(
                                          "Tutorial",
                                          style: GoogleFonts.lilitaOne(
                                            // color: Colors.white,
                                            // color: palette.text1,
                                            fontSize: 22*scalor
                                          ),),
                                      )
                                    ),
                                  ),                             
                                ],
                              );
                            } else {
                              return SizedBox();
                            }
                          }
                        ),
                        Divider(thickness: 1.0,color: palette.text2),
                        
                    
                        // Text("Preview"),
                            
                        // Container(
                        //   // color: Colors.amber,
                        //   // width: 250,
                        //   child: getGridPreview(rowValue, colValue, 250),
                        // )
                  
              
                      ],
                    ),
                  ),
                  Row(
                    
                    children: [
                        Expanded(child:SizedBox()),
                        // Padding(
                          // padding: EdgeInsets.all(8.0*scalor),
                          ElevatedButton(
                            
                            style: ElevatedButton.styleFrom(

                              backgroundColor: palette.widget2,
                              foregroundColor: palette.widgetText2,
                              minimumSize: Size(0.0, 0.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8*scalor))
                              )
                            ),
                            // onPressed: () => Navigator.of(context).pop(),
                            onPressed: generateRandomGame,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(8.0*scalor,4.0*scalor,8.0*scalor,4.0*scalor),
                              child: Text(
                                "Randomize",
                                style: GoogleFonts.lilitaOne(
                                  // color: Colors.white,
                                  fontSize: 22*scalor
                                ),),
                            )
                          ),
                        // ),              
                        
                          SizedBox(width: 10*scalor,),
                        // Padding(
                        //   padding: EdgeInsets.symmetric(horizontal: 8.0*scalor),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: palette.widget1,
                              foregroundColor: palette.widgetText1,
                              minimumSize: Size(0.0, 0.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8*scalor))
                              )
                            ),
                            onPressed: () {        
                              print("d: $durationInMinutes | p: $targetPoints | g: $gridAxis"); 
                              // print("user: ${settings.userData.value}");                 
                              print("""
********************************************************************
      gameTypeChoice: ---------- $gameTypeChoice
      durationInMinutes: ------- $durationInMinutes
      targetPoints: ------------ $targetPoints
      timeToPlace: ------------- $timeToPlace
      board: ------------------- $rowValue by $colValue
********************************************************************
                                """);
                              Initializations().startGame(
                                gamePlayState, 
                                gameTypeChoice,
                                durationInMinutes, 
                                targetPoints, 
                                rowValue,
                                colValue,
                                timeToPlace, 
                                null, 
                                settings,
                                widget.mediaQueryData,
                                context,
                                palette
                              );
                            },
                            
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(8.0*scalor,4.0*scalor,8.0*scalor,4.0*scalor),
                              child: Text(
                                "Start!",
                                style: GoogleFonts.lilitaOne(
                                  // color: Colors.white,
                                  fontSize: 22*scalor
                                ),),
                            )
                          ),
                        // ),                       
                    ],
                  )                
                ],
              ),
            ),
          ),


         


        );
      }
    );  
  }
}



List<Widget> getListOfGameDurations(List<int>durations,double scalor, ColorPalette palette, String gameType) {
  List<Widget> res  = [];
  for (int i=0; i<durations.length; i++) {
    int duration = durations[i];
    String text = gameType == "classic" ? "${duration}:00" : "Unlimited";
    Widget widget = Container(
      width: 100*scalor,
      height: 40*scalor,
      decoration: BoxDecoration(
        // border: Border.all(color: Colors.black,width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(5.0*scalor))
      ),
      child: Center(child: Text(
        text,
        style: GoogleFonts.lilitaOne(
          fontSize: 18*scalor,
          color: gameType == "classic" ? palette.text1 : palette.text1.withAlpha(150)
        )
      )),
    );
    res.add(widget);
  }
  return res;
}


List<Widget> getListOfPointTargets(List<int>points, double scalor, ColorPalette palette, String gameType) {
  List<Widget> res  = [];
  for (int i=0; i<points.length; i++) {
    int target = points[i];
    String text = gameType == "classic" ? "None" : "${target}";
    Widget widget = Container(
      width: 100*scalor,
      height: 40*scalor,
      decoration: BoxDecoration(
        // border: Border.all(color: Colors.black,width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(5.0*scalor))
      ),
      child: Center(child: Text(
        text,
        style: GoogleFonts.lilitaOne(
          fontSize: 18*scalor,
          color: gameType == "classic" ? palette.text1.withAlpha(150) :  palette.text1 
        )
      )),
    );
    res.add(widget);
  }
  return res;
}

List<Widget> getListOfTimesToPlace(List<int?>times, double scalor, ColorPalette palette) {
  List<Widget> res  = [];
  for (int i=0; i<times.length; i++) {
    int? timeToPlace = times[i];
    
    String text = timeToPlace != null ? "${timeToPlace} seconds" : "Unlimited";
    Widget widget = Container(
      width: 100*scalor,
      height: 40*scalor,
      decoration: BoxDecoration(
        // border: Border.all(color: Colors.black,width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(5.0*scalor))
      ),
      child: Center(child: Text(
        text,
        style: GoogleFonts.lilitaOne(
          fontSize: 18*scalor,
          color: palette.text1
        )
      )),
    );
    res.add(widget);
  }
  return res;
}


// List<Widget> getListOfGrids(List<int> grids, double scalor, ColorPalette palette) {
//   List<Widget> res  = [];
//   for (int i=0; i<grids.length; i++) {
//     // int target = points[i];
//     int grid = grids[i];
//     String text = "$grid by $grid";
//     Widget widget = Container(
//       width: 100*scalor,
//       height: 40*scalor,
//       decoration: BoxDecoration(
//         // border: Border.all(color: Colors.black,width: 1.0),
//         borderRadius: BorderRadius.all(Radius.circular(5.0*scalor))
//       ),
//       child: Center(child: Text(
//         text,
//         style: GoogleFonts.lilitaOne(
//           fontSize: 18*scalor,
//           color: palette.text1
//         )
//       )),
//     );
//     res.add(widget);
//   }
//   return res;
// }


List<Widget> getListOfAxisNumbers(List<int> grids, double scalor, ColorPalette palette) {
  List<Widget> res  = [];
  for (int i=0; i<grids.length; i++) {
    // int target = points[i];
    int grid = grids[i];
    String text = "$grid";
    Widget widget = Container(
      // width: 100*scalor,
      height: 40*scalor,
      decoration: BoxDecoration(
        // border: Border.all(color: Colors.black,width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(5.0*scalor))
      ),
      child: Center(child: Text(
        text,
        style: GoogleFonts.lilitaOne(
          fontSize: 18*scalor,
          color: palette.text1
        )
      )),
    );
    res.add(widget);
  }
  return res;
}


// Map<String,dynamic> generateRandomGameObject(List<int> timesInMinutes, List<int> pointTargets, List<int> gridTargets, List<int> timesToPlace,) {
//   Random random = Random();
//   Map<String,dynamic> res = {};

//   List<String> gameTypeChoices = ["classic", "sprint"];
//   int gameTypeChoiceIndex = random.nextInt(gameTypeChoices.length);
//   String gameType = gameTypeChoices[gameTypeChoiceIndex];

//   int rows = gridTargets[random.nextInt(gridTargets.length)];
//   int columns = gridTargets[random.nextInt(gridTargets.length)];
//   int? targetPoints = null;
//   int? duration = null;
//   int? timeToPlace = null;

//   if (gameType == 'classic') {
//     duration = timesInMinutes[random.nextInt(timesInMinutes.length)];
//   }

//   if (gameType == 'sprint') {
//     targetPoints = pointTargets[random.nextInt(pointTargets.length)];
//   }

//   print("generateRandomGameObject: $pointTargets");

//   res = {
//       "gameType":gameType,
//       "target":targetPoints,
//       "targetType": null,
//       "rows":rows,
//       "columns":columns,
//       "durationInMinutes":duration,
//       "timeToPlace": timeToPlace,
//   };

//   return res;
// }


// List<Widget> getListOfScrollableNumbers(int minNumber, int maxNumber) {
//   List<Widget> res  = [];
//   for (int i=minNumber; i<maxNumber; i++) {
//     Widget widget = Container(
//       // width: 40,
//       // height: 40,
//       decoration: BoxDecoration(
//         // border: Border.all(color: Colors.black,width: 1.0),
//         borderRadius: BorderRadius.all(Radius.circular(5.0))
//       ),
//       child: Center(child: Text(
//         i.toString(),
//         style: TextStyle(
//           fontWeight: FontWeight.bold
//         ),
//       )),
//     );
//     res.add(widget);
//   }
//   return res;
// }


// Widget getGridPreview(int rows, int cols, double canvasWidth) {
//   // int maxBetweenRowsAndColunns = max(rows, cols);
//   // final double tileSize = canvasWidth/maxBetweenRowsAndColunns;
//   final double tileSize = 20;
//   List<Widget> rowWidgets = [];
//   for (int i=0; i<rows; i++) {
//     List<Widget> colWidgets = [];
//     for (int j=0; j<cols; j++) {
//       Widget tile = Padding(
//         padding: const EdgeInsets.all(1.0),
//         child: Container(
//           width: tileSize,
//           height: tileSize,
//           color: Colors.grey,
//         ),
//       );
//       colWidgets.add(tile);
//     }
//     Row rowWidget = Row(mainAxisAlignment: MainAxisAlignment.center, children: colWidgets,);
//     rowWidgets.add(rowWidget);
//   }
//   Column res = Column(mainAxisAlignment: MainAxisAlignment.center, children: rowWidgets,);
//   // Widget res = Column(children: rowWidgets,)
//   return res;
// }

