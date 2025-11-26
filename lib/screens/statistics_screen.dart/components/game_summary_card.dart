import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/components/word_definition_modal.dart';
import 'package:scribby_flutter_v2/functions/gestures.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';
import 'package:intl/intl.dart';

class GameSummaryCard extends StatelessWidget {
  final Map<String,dynamic> gameData;
  final ColorPalette palette;
  const GameSummaryCard({
    super.key,
    required this.gameData,
    required this.palette
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsController>(
      builder: (context,settings,child) {

        print("""
=-=-=--==-=--=-=-=-=
${gameData}
-==--=-=-=-=-=-==-=--=
""");



        DateTime dateTime = DateTime.parse(gameData["createdAt"]);

        // Format it to something readable
        String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
        String gameType = Helpers().formatWord(gameData["gameParameters"]["gameType"]);

        late int rows = 6;
        late int columns = 6;
        if (gameData["gameParameters"]["boardAxis"]==null) {
          rows = gameData["gameParameters"]["rows"];
          columns = gameData["gameParameters"]["columns"];
        } else {
          rows = gameData["gameParameters"]["boardAxis"];
          columns = gameData["gameParameters"]["boardAxis"];
        }
        final double scalor = Helpers().getScalor(settings);
        return SizedBox(
          width: double.infinity,
          // height: 80*scalor,

          child: Padding(
            padding: EdgeInsets.all(8.0*scalor),
            child:Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: palette.widgetShadow1,
                    offset: Offset(0.0,10.0*scalor), 
                    blurStyle: BlurStyle.normal, 
                    blurRadius: 20.0*scalor, 
                    spreadRadius: 2.0*scalor,
                  )
                ]
              ),              
              child: ClipRRect(
                
                borderRadius: BorderRadius.all(Radius.circular(12.0*scalor)),
                child: ExpansionTile(
                  clipBehavior: Clip.antiAlias,
                  backgroundColor: palette.widget2,
                  collapsedBackgroundColor: palette.widget2,
                  title: Text(
                    Helpers().getTitleString(gameData["gameParameters"]),
                    style: TextStyle(
                      color: palette.widgetText2,
                      fontSize: 22 * scalor,
              
                    ),
                  ),
              

                  showTrailingIcon: true,
                  subtitle: Text(formattedDate,style: TextStyle(fontSize: 14*scalor, color: palette.widgetText2),),
              
              
              
              
                  childrenPadding: EdgeInsets.all(4.0*scalor),
                  children: <Widget>[
              
                    Divider(),

              
                    RowItem(
                      palette: palette, 
                      icon1: Icons.gamepad, 
                      label1: "Board" , 
                      data1: "${rows}x$columns", 
                      icon2: Icons.ads_click, 
                      label2: "Turns", 
                      data2:gameData["turns"].toString(),
                    ),
                              
                    Divider(),
              

                    RowItem(
                      palette: palette, 
                      icon1: Icons.bolt, 
                      label1: "Longest Streak" , 
                      data1: gameData["streak"].toString(), 
                      icon2: Icons.close, 
                      label2: "Cross Words", 
                      data2: gameData["crosswords"].toString(),
                    ),

                    Divider(),              
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Icon(Icons.star,color:palette.widgetText2)
                        ),
              
                        Expanded(
                          flex: 9,
                          child: Text("Biggest Turn: ${gameData["biggestTurn"]} Points ",style: TextStyle(color: palette.widgetText2),)
                        ),
                                                            
                      ],
                    ),
                    Divider(),
              
         
                    Row(
                      children: [
              
                        Expanded(
                          flex: 2,
                          child: Container(
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Icon(Icons.list,color: palette.widgetText2)
                                ),
              
                                Expanded(
                                  flex: 3,
                                  child: Text("Unique Words",style: TextStyle(color: palette.widgetText2),)
                                ),
              
                                Expanded(
                                  flex: 1,
                                  child: Text(gameData["uniqueWords"].length.toString(),style: TextStyle(color: palette.widgetText2),)
                                ),
                              ],
                            ),
                          )
                        ),
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () {
                              openViewWordsSummary(context,gameData,scalor);
                            },
                            child: Text("View words",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              decorationColor: palette.widgetText2,
                              color: palette.widgetText2
                            ),),
                          )
                        )
                                                        
                      ],
                    ),
              
              
                    gameData["gameResultData"]!= null && gameData["gameResultData"]["badges"].isNotEmpty ?
                    Column(
                      children: [
              
                        Divider(),
                        Row(
                          children: [
              
                            Expanded(
                              flex: 2,
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Icon(Icons.emoji_events,color: palette.widgetText2)
                                    ),
              
                                    Expanded(
                                      flex: 3,
                                      child: Text("Badges Earned",style: TextStyle(color: palette.widgetText2),)
                                    ),
              
                                    Expanded(
                                      flex: 1,
                                      child: Text(gameData["gameResultData"]["badges"].length.toString(),style: TextStyle(color: palette.widgetText2),)
                                    ),
                                  ],
                                ),
                              )
                            ),
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () {
                                  openViewWordsSummary(context,gameData,scalor);
                                },
                                child: SizedBox()
                              )
                            )
                                                            
                          ],
                        ),
                      ],
                    )
                    : SizedBox(),               
              
              
                  ]
                ),
              ),
            )
          ),
        );
      }
    );
  }
}


// String getTitleString(Map<String,dynamic> gameData) {
//   String res = "";
//   String gameType = gameData["gameParameters"]["gameType"];
//   String formattedGameType = Helpers().formatWord(gameType);

//   if (gameData["gameParameters"]["puzzleId"] != null) {
//     res = "Daily Puzzle";
//   }

//   else if (gameType == "classic" || gameType == "timed-move") {
//     res = "${gameData["gameParameters"]["durationInMinutes"]} Minute $formattedGameType";
//   } else if (gameType == "sprint") {
//     res = "${gameData['gameParameters']['target'].toString()} Point $formattedGameType";
//   } else if (gameType == "tutorial") {
//     res = "Tutorial";
//   }
//   return res;
// }

List<Widget> getTargetSection(double scalor, Map<String,dynamic> gameParameters) {

  String gameType = gameParameters["gameType"];

  Icon icon = Icon(Icons.timer, size: 15*scalor,color:Colors.black);
  String data = "";


  if (gameType == "classic" || gameType == "timed-move") {
    icon = Icon(Icons.timer, size: 15*scalor,color:Colors.black);
    data = Helpers().formatDuration((gameParameters["durationInMinutes"]*60));
  } else if (gameType == "sprint") {
    icon = Icon(Icons.album_outlined, size: 15*scalor,color:Colors.black);
    data = gameParameters["target"].toString();
  } else if (gameType=="tutorial") {
    data = gameParameters["target"].toString();
  }


  List<Widget> res = [
    Container(
      width: 15 * scalor,
      height: 15 * scalor,
      child: CircleAvatar(
        backgroundColor: const Color.fromARGB(255, 230, 230, 230),
        child: icon
      )
    ),
    Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.0 * scalor),
        child: Text(
          data,
          style: TextStyle(
            fontSize: 16*scalor
          ),
        )
      ),
    ),                           
  ];
  return res;
}

// String getScoreValue(Map<String,dynamic> gameData) {

//   String gameType = gameData["gameParameters"]["gameType"];
//   String res = "";

//   if (gameType == "classic" || gameType == "timed-move") {
//     res = gameData["score"].toString();
//   } else if (gameType == "sprint") {
//     res = Helpers().formatDuration(gameData["durationSeconds"]);
//   } else if (gameType=="tutorial"){
//     res = gameData["score"].toString();
//   }
//   return res;
// }

Future<void> openViewWordsSummary(BuildContext context, Map<String, dynamic> gameData, double scalor) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
      List<dynamic> uniqueWords = gameData["uniqueWords"];
      // List<dynamic> uniqueWords =  List.generate(100, (v) => "WORD");
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
          padding: const EdgeInsets.all(16),
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Words Summary',
                style: palette.mainAppFont(
                  textStyle: TextStyle(
                    fontSize: 22*scalor, 
                    fontWeight: FontWeight.bold,
                    color: palette.text1,
                  ),
                )
              ),
              Text(
                'Tap each word to view the definition',
                style: TextStyle(
                  fontSize: 16*scalor,
                  fontStyle: FontStyle.italic,
                  color: palette.text1,
                ),
              ),              
              SizedBox(
                height: 16*scalor,
              ),
              // Add bounded height here
              SizedBox(
                height: 300*scalor, // You can adjust this height as needed
                child: SingleChildScrollView(
                  child: Builder(
                    builder: (context) {
                  
                      List<Widget> items = [];
                      for (int i=0; i<uniqueWords.length; i++) {
                        Widget wordItem = Padding(
                          padding: EdgeInsets.all(4.0 * scalor),
                          child: Container(
                            // height: 30 *scalor ,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(8.0*scalor)),
                              color: palette.widget2
                            ),
                            child: GestureDetector( 
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal:  8.0 * scalor),
                                child: Text(
                                  uniqueWords[i],
                                  style: palette.mainAppFont(
                                    textStyle: TextStyle(
                                      color: palette.widgetText2,
                                      fontSize: 18.0 * scalor
                                    )
                                  ),
                                ),
                              ),
                              onTap: () {
                                // print("get definition of ${uniqueWords[i]}");
                                Gestures().openViewDefinitionDialog(context, uniqueWords[i]);
                              },
                            ),
                          ),
                        );
                        items.add(wordItem);                      
                      }
                      return Wrap(
                        children: items,
                      );
                    }
                  ),
                ),
                // child: ListView.builder(
                //   shrinkWrap: true,
                //   itemCount: uniqueWords.length,
                //   itemBuilder: (BuildContext context, int index) {
                //     return Padding(
                //       padding: EdgeInsets.all(4.0 * scalor),
                //       child: Container(
                //         height: 30 *scalor ,
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.all(Radius.circular(8.0*scalor)),
                //           color: const Color.fromARGB(92, 171, 191, 255),
                //         ),
                //         child: ListTile( 
                //           minVerticalPadding: 0.0,
                //           contentPadding: EdgeInsets.fromLTRB(12.0*scalor, 2.0,0.0,0.0),
                //           minTileHeight: 10.0 * scalor,
                //           title: Text(uniqueWords[index]),
                //           onTap: () {
                //             // print("get definition of ${uniqueWords[index]}");
                //             openViewSummaryDialog(context, uniqueWords[index]);
                //           },
                //         ),
                //       ),
                //     );
                //   },
                // ),
              ),
            ],
          ),
        ),
      );
    },
  );
}


class RowItem extends StatelessWidget {
  final ColorPalette palette;
  final IconData icon1;
  final String label1;
  final String data1;
  final IconData icon2;
  final String label2;
  final String data2;
  const RowItem({
    super.key,
    required this.palette,
    required this.icon1,
    required this.label1,
    required this.data1,
    required this.icon2,
    required this.label2,
    required this.data2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Icon(icon1,color:palette.widgetText2)
                ),

                Expanded(
                  flex: 3,
                  child: Text(label1,style: TextStyle(color: palette.widgetText2),)
                ),

                Expanded(
                  flex: 1,
                  child: Text(data1,style: TextStyle(color: palette.widgetText2),)
                ),                                                            
              ],
            ),
          )
        ),

        Expanded(
          flex: 1,
          child: Container(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Icon(icon2,color:palette.widgetText2)
                ),

                Expanded(
                  flex: 3,
                  child: Text(label2,style: TextStyle(color: palette.widgetText2),)
                ),

                Expanded(
                  flex: 1,
                  child: Text(data2.toString(),style: TextStyle(color: palette.widgetText2),)
                ),                                                            
              ],
            ),
          )
        ),                      
      ],
    );
  }
}
