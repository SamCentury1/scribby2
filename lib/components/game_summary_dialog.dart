import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';

class GameSummaryDialog extends StatefulWidget {
  final Map<String,dynamic> gameData;
  const GameSummaryDialog({
    super.key,
    required this.gameData,
  });

  @override
  State<GameSummaryDialog> createState() => _GameSummaryDialogState();
}

class _GameSummaryDialogState extends State<GameSummaryDialog> {

  late SettingsController settings;
  late ColorPalette palette;
  late String uid;
  late double scalor = 1.0;
  String formattedDate = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    settings = Provider.of<SettingsController>(context, listen: false);
    palette = Provider.of<ColorPalette>(context, listen: false);
    scalor = Helpers().getScalor(settings);

    DateTime dateTime = DateTime.parse(widget.gameData["createdAt"]);
    formattedDate = DateFormat('MMM. d').format(dateTime);

    Map<String,dynamic> userData = settings.userData.value as Map<String,dynamic>;
    uid = userData["uid"];

    // print(widget.gameData["gameParameters"]["puzzleId"]);
    // String? puzzleId = widget.gameData["gameParameters"]["puzzleId"];
    // Future<Map<String,dynamic>> puzzleDocument = FirestoreMethods().getDailyPuzzleObject(puzzleId);    


  }  
  @override
  Widget build(BuildContext context) {
    

      return FutureBuilder(
        future: FirestoreMethods().getDailyPuzzleObject(widget.gameData["gameParameters"]["puzzleId"]),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return Dialog(child: SizedBox(width: 50, height: 50, child: CircularProgressIndicator()));
          } else if (asyncSnapshot.hasError) {
            return Text("Error: ${asyncSnapshot.error}");
          } else if (asyncSnapshot.hasData) {
            final puzzle = asyncSnapshot.data!;
            print("HERE IS THE PUZZLE FROM THE DB");
            print(puzzle);

         

            late Table tableRes = getRankingTable(puzzle["data"],uid, puzzle["gameType"] ,palette,scalor);
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
                  padding: EdgeInsets.fromLTRB(12.0*scalor,12.0*scalor,12.0*scalor,22.0*scalor),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
            
                      Text(
                        "Daily Puzzle $formattedDate (${puzzle["difficulty"]})",
                        style: palette.mainAppFont(
                          textStyle: TextStyle(
                            color: palette.widgetText1,
                            fontSize: 22*scalor,
                          )
                        ),
                      ),

                      Divider(),
                      
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          color: palette.widget1
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Objective: ",
                                  style: palette.mainAppFont(
                                    textStyle: TextStyle(
                                      color: palette.widgetText1,
                                      fontSize: 18*scalor,
                                    )
                                  ),                                
                                ),
                              ),
                              Helpers().getGameObjectiveString(
                                puzzle["gameType"],
                                puzzle["duration"],
                                puzzle["target"],
                                puzzle["timeToPlace"],
                                palette,
                                16 *scalor
                              ),

                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 12 * scalor,),


                      Text(
                        "Ranking",
                        style: palette.mainAppFont(
                          textStyle: TextStyle(
                            color: palette.widgetText1,
                            fontSize: 22*scalor,
                          )
                        ),
                      ),


                      tableRes                      
            
                    ]
                  ),
                )
              ),
            );
          } else {
            return Text("No data");
          }
        }
      );    
  }
}


TableRow playerRankingRow(Map<String,dynamic> rowData, String gameType, String uid, ColorPalette palette, double scalor) {

  String scoreValue = rowData["score"].toString();

  if (gameType == "classic" || gameType == "timed-move") {
    scoreValue = rowData["score"].toString();
  } else if (gameType == "sprint") {
    scoreValue = Helpers().formatDuration(rowData["score"]);
  } 

  bool isUser = rowData["uid"]==uid;

  late TableRow res = TableRow(
    children: [
      SizedBox(
        child: Text(
          // string,
          // index.toString(),
          "${rowData["rank"]}.",
          style: TextStyle(
            color: palette.text1,
            fontSize: 18 * scalor,
            fontWeight: isUser ? FontWeight.w800 : FontWeight.normal 
          ),
        ),  
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          // string,
          rowData["username"],
          style: TextStyle(
            color: palette.text1,
            fontSize: 18 * scalor,
            fontWeight: isUser ? FontWeight.w800 : FontWeight.normal        
          ),
        ),            
      ),
      Align(
        alignment: Alignment.centerRight,
        child: Text(
          // string,
          scoreValue,
          style: TextStyle(
            color: palette.text1,
            fontSize: 18 * scalor,
            fontWeight: isUser ? FontWeight.w800 : FontWeight.normal        
          ),
        ),            
      ),     
    ]
  );
  return res;
}


List<dynamic> getRankingSubset(List<dynamic> _rankingData, String uid,) {
  
  List<dynamic> res = [];
  Map<String,dynamic> rankObject = _rankingData.firstWhere((e)=>e["uid"]==uid,orElse: ()=> <String,dynamic>{});
  int rankObjectIndex = _rankingData.indexOf(rankObject);

  int under = rankObjectIndex-5 < 0 ? 0 : rankObjectIndex-5;
  int over = rankObjectIndex+5 > _rankingData.length ? _rankingData.length : rankObjectIndex+5;


  for (int i=under ; i< over; i++) {
    Map<String,dynamic> rank = _rankingData[i];
    rank["rank"] = i+1;
    res.add(rank);
  }

  return res;
}

Table getRankingTable(List<dynamic> rankingData, String uid, String gameType,  ColorPalette palette, double scalor) {
  List<dynamic> _rankingData = fakeRanking(rankingData,gameType);
  Map<String,dynamic> rankObject = _rankingData.firstWhere((e)=>e["uid"]==uid,orElse: ()=> <String,dynamic>{});
  int rankObjectIndex = _rankingData.indexOf(rankObject);

  List<dynamic> rankingSubset = getRankingSubset(_rankingData, uid);
  print("""
RANKING SUBSET
""");
  for (dynamic item in rankingSubset) {
    print(item);
  }

  late Table tableRes = Table(
    columnWidths: const <int, TableColumnWidth>{
      0: FlexColumnWidth(2),
      1: FlexColumnWidth(4),
      2: FlexColumnWidth(3),
    },
    defaultVerticalAlignment:TableCellVerticalAlignment.middle,
    // children: [
    //   playerRankingRow({},palette,scalor),
    //   playerRankingRow({},palette,scalor),
    //   playerRankingRow({},palette,scalor),
    //   playerRankingRow({},palette,scalor),
    // ],
    children: rankingSubset.map((e)=>playerRankingRow(e, gameType, uid, palette, scalor),).toList(),
    // children: [
      // for (int i = (rankObjectIndex-2); i < (rankObjectIndex+4); i++)
      //   playerRankingRow((i+1),_rankingData[i], palette, scalor),
    // ],
  );
  return tableRes; 
}

List<dynamic> fakeRanking(List<dynamic> actualRanking, String gameType) {
  Random random = Random();
  List<dynamic> res = List<dynamic>.from(actualRanking);
  for (int i=0; i<100; i++) {
    res.add({"uid": "abcdefghaijklmnopqrstuvwxyz$i","username":"user-$i","score":random.nextInt(150)});
  }
  if (gameType=="sprint") {
    res.sort((a, b) => a["score"].compareTo(b["score"]));
  } else if (gameType=="classic") {
    res.sort((a, b) => b["score"].compareTo(a["score"]));
  }
  return res;
}