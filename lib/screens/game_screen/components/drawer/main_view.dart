import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/functions/initializations.dart';
import 'package:scribby_flutter_v2/providers/ad_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/drawer/navigation_dialog.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';

class MainDrawerView extends StatelessWidget {
  final VoidCallback navigateToSummary;
  // final VoidCallback navigateToSettings;
  final VoidCallback navigateToShop;
  final VoidCallback navigateToInstructions;
  final ScaffoldState? scaffoldState;
  const MainDrawerView({
    super.key,
    required this.navigateToSummary,
    // required this.navigateToSettings,
    required this.navigateToShop,
    required this.navigateToInstructions,
    required this.scaffoldState,
  });

  @override
  Widget build(BuildContext context) {




    return  Consumer<GamePlayState>(
      builder: (context,gamePlayState,child) {

        SettingsController settings = Provider.of<SettingsController>(context,listen: false);
        ColorPalette palette = Provider.of<ColorPalette>(context,listen: false);
        // AdState adState = Provider.of<AdState>(context,listen: false);

        // String durationString = Helpers().formatDuration(gamePlayState.duration.inSeconds); 
        // String timeLeftString = gamePlayState.countDownDuration==null ? "" : Helpers().formatDuration(gamePlayState.countDownDuration!.inSeconds);
        // int? target = gamePlayState.gameParameters["target"];
        int currentScore = getCurrentScore(gamePlayState);
        int countWords = getNumberOfWords(gamePlayState);
        // int highestStreak = getHighestValue(gamePlayState,"streak");
        // int highestMultiWord = getHighestValue(gamePlayState,"words");
        // int numberOfCrossWords = getNumberOfCrossWords(gamePlayState);  
        int currentTurn = getCurrentTurn(gamePlayState);
        String gameType = Helpers().capitalize(gamePlayState.gameParameters["gameType"]);
        final double scalor = Helpers().getScalor(settings);
        TextStyle listTileTextStyle = getListTileTextStyle(palette,scalor);
        String puzzleTitle = Helpers().getTitleString(gamePlayState.gameParameters);

        String timeString = getTimeString(gamePlayState,scalor);

        return SingleChildScrollView(
          child: Column(
            // Important: Remove any padding from the ListView.
            // padding: EdgeInsets.zero,
            key: const ValueKey('mainMenu'),
            crossAxisAlignment: CrossAxisAlignment.start,                
            children: [
              SizedBox(
                height: 60 * scalor,
              ),
              Container(
                height: 200*scalor,
                child: Center(
                  child: SizedBox(
                    child: Center(
                      child: Image.asset('assets/images/scribby_label_1.png'),
                    ),
                  )
                ),
              ),
          
              Divider(thickness: 1.0*scalor, color: Colors.grey,),

              

              Padding(
                padding: EdgeInsets.all(12.0*scalor),

                child: Column(
                  children: [
                    Text(
                      puzzleTitle,
                      style: palette.mainAppFont(
                        textStyle: TextStyle(
                          color: palette.text1,
                          fontSize: 22 * scalor
                        )
                      ),
                    ),
                    Helpers().getGameObjectiveString(
                      gamePlayState.gameParameters["gameType"],
                      gamePlayState.gameParameters["durationInMinutes"],
                      gamePlayState.gameParameters["target"],
                      gamePlayState.gameParameters["timeToPlace"],
                      palette,
                      18 * scalor,
                    ),
                    SizedBox(height: 20 * scalor,),
                    getGameParameterWidget(
                      palette,
                      scalor,
                      Icons.timer,
                      gameType == "Classic" ? "Time Left" : "Duration",
                      timeString
                    ),

                    getGameParameterWidget(
                      palette,
                      scalor,
                      Icons.star,
                      "Score",
                      currentScore.toString(),
                    ), 

                    getGameParameterWidget(
                      palette,
                      scalor,
                      Icons.fingerprint,
                      "Moves",
                      currentTurn.toString(),
                    ),                                        
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       flex: 1,
                    //       child: Icon(Icons.timer, color: palette.text1,size: 18 *scalor,),
                    //     ),

                    //     Expanded(
                    //       flex: 4,
                    //       child: Text(
                    //         gameType == "Classic" ? "Time Left" : "Duration",
                    //         style: listTileTextStyle,
                    //       ),
                    //     ), 

                    //     Expanded(
                    //       flex: 2,
                    //       child: Text(
                    //         timeString,
                    //         style: listTileTextStyle,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
                // child: Table(
                //   columnWidths: {
                //     0: FlexColumnWidth(1),
                //     1: FlexColumnWidth(4),
                //     2: FlexColumnWidth(4),
                //   },
                //   children: [
                //     gameSummaryRow(Icons.emoji_events, "Game Type",gameType,scalor),
                //     timeStringWidget(gamePlayState,scalor),
                //     gameSummaryRow(Icons.numbers, "Turn",currentTurn,scalor),
                //     gameSummaryRow(Icons.score, "Score",currentScore,scalor),
                    
                //     gameSummaryRow(Icons.list, "Words",countWords,scalor),                    
                //   ],
                // ),
              ),

              Divider(thickness: 1.0, color: Colors.grey,),

              SizedBox(
                height: 80*scalor,
                child: Padding(
                  padding: EdgeInsets.all(8.0*scalor),
                  child: Card(
                    color: palette.widget2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(9.0*scalor))
                    ),
                  
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(22.0*scalor,4.0*scalor,4.0*scalor,4.0*scalor),
                          child: settings.soundsOn.value
                          ? soundControlText("Sound On",palette,scalor)  //Text("Sound On", style: TextStyle(fontSize: 18 * scalor),)
                          : soundControlText("Sound Off",palette,scalor) // Text("Sound Off", style: TextStyle(fontSize: 18 * scalor),)
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0*scalor,0.0*scalor,22.0*scalor,0.0*scalor),
                          child: IconButton(
                            onPressed: () {
                              settings.toggleSoundOn();
                            }, 
                            icon: settings.soundsOn.value 
                            ? Icon(Icons.volume_up,   color: palette.widgetText2, size: 30 * scalor,) 
                            : Icon(Icons.volume_off, color: palette.widgetText2, size: 30 * scalor),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              ListTile(
                minTileHeight: 10.0,
                leading: Icon(Icons.summarize, color: palette.text1, size: 26 * scalor,),
                title: Text("Summary", style: listTileTextStyle),
                onTap: navigateToSummary,
              ),
              ListTile(
                minTileHeight: 10.0,
                leading: Icon(Icons.shopping_cart, color: palette.text1, size: 26 * scalor),
                title: Text("Shop", style: listTileTextStyle),
                onTap: navigateToShop,
              ),
              ListTile(
                minTileHeight: 10.0,
                leading: Icon(Icons.help, color: palette.text1, size: 26 * scalor),
                title: Text("Instructions", style: listTileTextStyle),
                onTap: navigateToInstructions,
              ),   
              ListTile(
                minTileHeight: 10.0,
                leading: Icon(Icons.home, color: palette.text1, size: 26 * scalor),
                title: Text("Quit Game", style: listTileTextStyle),
                onTap: () => openQuitGameDialog(context,gamePlayState),
              ),

              ListTile(
                minTileHeight: 10.0,
                leading: Icon(Icons.refresh, color: palette.text1, size: 26 * scalor),
                title: Text("Restart Game", style: listTileTextStyle),
                onTap: () => openRestartGameDialog(context,settings,gamePlayState,scaffoldState),
              ),                                                         
            ]
          ),
        );
      }
    );
  }
}

Text soundControlText(String body, ColorPalette palette, double scalor) {
  return Text(
    body, 
    style: palette.mainAppFont(
      textStyle: TextStyle(
        color: palette.widgetText2,
        fontSize: 18 * scalor
      ),
    ),
  );
}

TableRow timeStringWidget(GamePlayState gamePlayState, double scalor) {
  TableRow res = TableRow();
  if (gamePlayState.countDownDuration==null) {
    String durationString = Helpers().formatDuration(gamePlayState.duration.inSeconds); 
    res = gameSummaryRow(Icons.timer_rounded, "Duration",durationString,scalor);
  } else {
    String timeLeftString =  Helpers().formatDuration(gamePlayState.countDownDuration!.inSeconds);
    res = gameSummaryRow(Icons.timer_rounded, "Time Left",timeLeftString,scalor);
  }
  return res;
}

String getTimeString(GamePlayState gamePlayState, double scalor) {
  String res = "";
  if (gamePlayState.countDownDuration==null) {
    res = Helpers().formatDuration(gamePlayState.duration.inSeconds); 
  } else {
    res = Helpers().formatDuration(gamePlayState.countDownDuration!.inSeconds);
  }
  return res;  
}


int getCurrentTurn(GamePlayState gamePlayState) {
  int res = gamePlayState.scoreSummary.isNotEmpty ? gamePlayState.scoreSummary.last["turn"] : 0 ;
  return res;
}
int getCurrentScore(GamePlayState gamePlayState){
  int currentScore = 0;
  for (int i=0; i<gamePlayState.scoreSummary.length; i++) {
    currentScore = currentScore+gamePlayState.scoreSummary[i]["score"] as int;
  }
  return currentScore;
}
int getNumberOfWords(GamePlayState gamePlayState){
  int count = 0;
  for (int i=0; i<gamePlayState.scoreSummary.length; i++) {
    count = count+gamePlayState.scoreSummary[i]["validStrings"].length as int;
  }
  return count;
}

int getHighestValue(GamePlayState gamePlayState,String metric) {
  int highestVal = 0;
  for (int i=0; i<gamePlayState.scoreSummary.length; i++) {
    int val = gamePlayState.scoreSummary[i]["multipliers"][metric];
    if (val > highestVal) {
      highestVal = val;
    }
  }
  return highestVal;
}

int getNumberOfCrossWords(GamePlayState gamePlayState) {
  int count = 0;
  for (int i=0; i<gamePlayState.scoreSummary.length; i++) {
    if (gamePlayState.scoreSummary[i]["multipliers"]["cross"]>1) {
      count++;
    }
  }
  return count;  
}


TableRow gameSummaryRow(IconData icon, String body, dynamic data, double scalor) {

  TextStyle textStyle = TextStyle(
    color: Colors.white,
    fontSize: 18*scalor
  );


  return TableRow(
    decoration: BoxDecoration(
      
      // color: Colors.red,
      
    ),
    children: [
      // SizedBox(child: Padding(
      //   padding: const EdgeInsets.symmetric(vertical: 8.0),
      //   child: Align(alignment: Alignment.center, child: Icon(icon,color: Colors.white, size: 30*scalor,)),
      // ),),
      getTableRowCell(alignment: Alignment.center, widget: Icon(icon,color: Colors.white, size: 22*scalor,),scalor: scalor),
      getTableRowCell(alignment: Alignment.centerLeft, widget: Text(body,style: textStyle),scalor: scalor),
      getTableRowCell(alignment: Alignment.centerRight, widget: Text("${data}",style: textStyle),scalor:scalor ),
      // SizedBox(child: Align(alignment: Alignment.centerLeft,  child: Text(body,style: textStyle)),),
      // SizedBox(child: Align(alignment: Alignment.centerRight, child: Text("${data}",style: textStyle)),),
    ]
  );
}

Widget getTableRowCell({required Alignment alignment, required Widget widget, required double scalor}) {
      return SizedBox(
        child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0 * scalor),
        child: Align(
          alignment: alignment,
          child: widget
          ),
      ),);

} 


Widget tileItem(String body, IconData iconData, Function function) {
  return ListTile(
    leading: Icon(
      iconData,
      color: Colors.white,
    ),
    title: Text(
      body,
      style: TextStyle(
        color: Colors.white
      ),
    ),
    onTap: () {function();}
  );
}

Future<void> openQuitGameDialog(BuildContext context, GamePlayState gamePlayState) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return NavigationDialog(
        title: "Quit Game",
        body: "Your game will be recorded",
        action: () => Initializations().terminateGame(context, gamePlayState),
      );
    }
  );
}


TextStyle getListTileTextStyle(ColorPalette palette, double scalor) {
  return palette.mainAppFont(
    textStyle: TextStyle(
      color: palette.text1, 
      fontSize: 18.0 * scalor
    )
  );
}

Widget getGameParameterWidget(ColorPalette palette, double scalor, IconData iconData, String parameter, String body) {
  return Row(
    children: [
      Expanded(
        flex: 1,
        child: Icon(iconData, color: palette.text1,size: 18 *scalor,),
      ),

      Expanded(
        flex: 4,
        child: Text(
          parameter,
          style: palette.mainAppFont(
            textStyle: TextStyle(
              color: palette.text1, 
              fontSize: 18.0 * scalor
            )
          ),
        ),
      ), 

      Expanded(
        flex: 2,
        child: Text(
          body,
          style: palette.mainAppFont(
            textStyle: TextStyle(
              color: palette.text1, 
              fontSize: 18.0 * scalor
            )
          ),
        ),
      ),
    ],
  );  
}

Future<void> openRestartGameDialog(BuildContext context, SettingsController settings, GamePlayState gamePlayState, ScaffoldState? scaffoldState) async {

void onPressRestart(BuildContext context, SettingsController settings, GamePlayState gamePlayState, ScaffoldState? scaffoldState, ColorPalette palette) {
  

  Map<String,dynamic> gameParameters = Map<String,dynamic>.from(gamePlayState.gameParameters);

  gamePlayState.refreshAllData();
  gamePlayState.setGameParameters(gameParameters);

  MediaQueryData mediaQuery = gameParameters["mediaQueryData"];

  Initializations().initializeTime(gamePlayState,gameParameters["gameType"], gameParameters["durationInMinutes"], gameParameters["timeToPlace"]);
  Initializations().initializeTileData(gamePlayState, gameParameters["rows"], gameParameters["columns"]);
  Initializations().initializeElementSizes(gamePlayState, mediaQuery);
  Initializations().initializeElementPositions(gamePlayState, mediaQuery);
  Initializations().initializeGame(settings,gamePlayState,palette);

  scaffoldState?.closeDrawer();
  
  Navigator.of(context).pop();
         

  }


  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      ColorPalette palette = Provider.of<ColorPalette>(context,listen: false);
      return NavigationDialog(
        title: "Restart Game", 
        body: "All progress will be lost", 
        action: () => onPressRestart(context,settings, gamePlayState,scaffoldState,palette)
      );
    }
  );
}

