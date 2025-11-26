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

class TutorialDialog extends StatefulWidget {
  final MediaQueryData mediaQueryData;
  const TutorialDialog({super.key, required this.mediaQueryData});

  @override
  State<TutorialDialog> createState() => _TutorialDialogState();
}

class _TutorialDialogState extends State<TutorialDialog> {

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

  final int initialDurationItem = 9; // 10 minutes
  final int initialPointsItem = 7;
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

    

    durationController = FixedExtentScrollController(initialItem: initialDurationItem);
    pointsController = FixedExtentScrollController(initialItem: initialPointsItem);
    gridRowController = FixedExtentScrollController(initialItem: initialGridItem);
    gridColumnController = FixedExtentScrollController(initialItem: initialGridItem);
    timesToPlaceController = FixedExtentScrollController(initialItem: initialTimeToPlaceItem);

    // int? item = null;
    // timesToPlace.insert(0,item);
    // print("timesToPlace: $timesToPlace | ${timesToPlace}");

    durationInMinutes = timesInMinutes[initialDurationItem]; 
    targetPoints = pointTargets[initialPointsItem]; 
    gridAxis = gridTargets[initialGridItem]; 
    timeToPlace = timesToPlace[initialTimeToPlaceItem];     

    if (gameTypeChoice == "classic") {
      targetPoints = null;
    }

    if (gameTypeChoice == "sprint") {
      durationInMinutes = null;
    }



  }



  @override
  Widget build(BuildContext context) {
    // final _style = Theme.of(context).textTheme.displaySmall;


    // SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);
    ColorPalette palette = Provider.of<ColorPalette>(context);
    SettingsController settings = Provider.of<SettingsController>(context, listen: false);
    final double scalor = Helpers().getScalor(settings);
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
                      "Learn to Play!",
                      style: palette.mainAppFont(
                        textStyle: TextStyle(
                          color: palette.text1,
                          fontSize: 32*scalor
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10*scalor,),

                  Text(
                    "Play through this simple walkthrough to learn how to be a great Scribby player",
                    style: palette.mainAppFont(
                      textStyle: TextStyle(
                        color: palette.text2,
                        fontSize: 22*scalor
                      ),
                    ),                    
                  ),

                  SizedBox(height: 10*scalor,),
                  

                  
                  
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
                          "Play Tutorial",
                          style: GoogleFonts.lilitaOne(
                            // color: Colors.white,
                            // color: palette.text1,
                            fontSize: 22*scalor
                          ),),
                      )
                    ),
                  ),

                ],
              ),
            ),
          ),


         


        );
      }
    );  
  }
}

