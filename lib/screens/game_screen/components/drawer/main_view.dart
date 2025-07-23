import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/functions/initializations.dart';
import 'package:scribby_flutter_v2/providers/ad_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
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
        String gameType = gamePlayState.gameParameters["gameType"];
        final double scalor = Helpers().getScalor(settings);
        return SingleChildScrollView(
          child: Column(
            // Important: Remove any padding from the ListView.
            // padding: EdgeInsets.zero,
            key: const ValueKey('mainMenu'),
            crossAxisAlignment: CrossAxisAlignment.start,                
            children: [
          
              Container(
                height: 200*scalor,
                child: Center(
                  child: Text("SCRIBBY!"),
                ),
              ),
          
              Divider(thickness: 1.0*scalor, color: Colors.grey,),

              

              Padding(
                padding: EdgeInsets.all(12.0*scalor),
                child: Table(
                  columnWidths: {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(4),
                    2: FlexColumnWidth(4),
                  },
                  children: [
                    gameSummaryRow(Icons.emoji_events, "Game Type",gameType,scalor),
                    timeStringWidget(gamePlayState,scalor),
                    gameSummaryRow(Icons.numbers, "Turn",currentTurn,scalor),
                    gameSummaryRow(Icons.score, "Score",currentScore,scalor),
                    
                    gameSummaryRow(Icons.list, "Words",countWords,scalor),                    
                  ],
                ),
              ),

              Divider(thickness: 1.0, color: Colors.grey,),

              SizedBox(
                height: 80*scalor,
                child: Padding(
                  padding: EdgeInsets.all(8.0*scalor),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(9.0*scalor))
                    ),
                  
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(22.0*scalor,4.0*scalor,4.0*scalor,4.0*scalor),
                          child: settings.soundsOn.value
                          ? Text("Sound On", style: TextStyle(fontSize: 18 * scalor),)
                          : Text("Sound Off", style: TextStyle(fontSize: 18 * scalor),)
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0*scalor,0.0*scalor,22.0*scalor,0.0*scalor),
                          child: IconButton(
                            onPressed: () {
                              settings.toggleSoundOn();
                            }, 
                            icon: settings.soundsOn.value 
                            ? Icon(Icons.volume_up,color: Colors.blue,size: 30 * scalor,) 
                            : Icon(Icons.volume_mute, size: 30 * scalor),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),

     
          

              // Divider(thickness: 1.0, color: Colors.grey,),
          
              ListTile(
                minTileHeight: 10.0,
                leading: Icon(Icons.summarize, color: Colors.white, size: 30 * scalor,),
                title: Text("Summary", style: TextStyle(color: Colors.white, fontSize: 18.0 * scalor)),
                onTap: navigateToSummary,
              ),
              ListTile(
                minTileHeight: 10.0,
                leading: Icon(Icons.shopping_cart, color: Colors.white, size: 30 * scalor),
                title: Text("Shop", style: TextStyle(color: Colors.white, fontSize: 18.0 * scalor)),
                onTap: navigateToShop,
              ),
              // ListTile(
              //   leading: Icon(Icons.settings, color: Colors.white,),
              //   title: const Text("Settings", style: TextStyle(color: Colors.white)),
              //   onTap: navigateToSettings,
              // ),
              ListTile(
                minTileHeight: 10.0,
                leading: Icon(Icons.help, color: Colors.white, size: 30 * scalor),
                title: Text("Instructions", style: TextStyle(color: Colors.white, fontSize: 18.0 * scalor)),
                onTap: navigateToInstructions,
              ),   
              ListTile(
                minTileHeight: 10.0,
                leading: Icon(Icons.home, color: Colors.white, size: 30 * scalor),
                title: Text("Quit Game", style: TextStyle(color: Colors.white, fontSize: 18.0 * scalor)),
                onTap: () => openQuitGameDialog(context,gamePlayState),
              ),

              ListTile(
                minTileHeight: 10.0,
                leading: Icon(Icons.refresh, color: Colors.white, size: 30 * scalor),
                title: Text("Restart Game", style: TextStyle(color: Colors.white, fontSize: 18.0 * scalor)),
                onTap: () => openRestartGameDialog(context,settings,gamePlayState,scaffoldState),
              ),                                                         
            ]
          ),
        );
      }
    );
  }
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
      getTableRowCell(alignment: Alignment.center, widget: Icon(icon,color: Colors.white, size: 25*scalor,),scalor: scalor),
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
        body: "All your progress will be saved",
        action: () => Initializations().terminateGame(context, gamePlayState),
      );
    }
  );
}


Future<void> openRestartGameDialog(BuildContext context, SettingsController settings, GamePlayState gamePlayState, ScaffoldState? scaffoldState) async {

void onPressRestart(BuildContext context, SettingsController settings, GamePlayState gamePlayState, ScaffoldState? scaffoldState) {
  

  Map<String,dynamic> gameParameters = Map<String,dynamic>.from(gamePlayState.gameParameters);

  gamePlayState.refreshAllData();
  gamePlayState.setGameParameters(gameParameters);

  MediaQueryData mediaQuery = gameParameters["mediaQueryData"];

  Initializations().initializeTime(gamePlayState,gameParameters["gameType"], gameParameters["durationInMinutes"], gameParameters["timeToPlace"]);
  Initializations().initializeTileData(gamePlayState, gameParameters["rows"], gameParameters["columns"]);
  Initializations().initializeElementSizes(gamePlayState, mediaQuery);
  Initializations().initializeElementPositions(gamePlayState, mediaQuery);
  Initializations().initializeGame(settings,gamePlayState);

  scaffoldState?.closeDrawer();
  
  Navigator.of(context).pop();
         

  }


  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return NavigationDialog(
        title: "Restart Game", 
        body: "All progress will be lost", 
        action: () => onPressRestart(context,settings, gamePlayState,scaffoldState)
      );
    }
  );
}

