import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';

class DailyPuzzleRankingWidget extends StatefulWidget {
  final String gameType;
  final List<dynamic> ranking;
  final SettingsController settings;
  const DailyPuzzleRankingWidget({
    super.key,
    required this.gameType,
    required this.ranking,
    required this.settings,
  });

  @override
  State<DailyPuzzleRankingWidget> createState() => _DailyPuzzleRankingWidgetState();
}

class _DailyPuzzleRankingWidgetState extends State<DailyPuzzleRankingWidget> {

  late ColorPalette palette;
  late Map<String,dynamic> userData;
  late double scalor = 1.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    palette = Provider.of<ColorPalette>(context, listen: false);
    userData = widget.settings.userData.value as Map<String,dynamic>;
    scalor = Helpers().getScalor(widget.settings);
    // List<String> puzzleIdPieces = widget.gameData["puzzleId"].split("-"); 
    // final DateTime dateTime  = DateTime(int.parse(puzzleIdPieces[0]),int.parse(puzzleIdPieces[1]),int.parse(puzzleIdPieces[2]));
    // formattedDate = DateFormat('MMM. d').format(dateTime);

  }


  @override
  Widget build(BuildContext context) {
            late Table tableRes = getRankingTable(widget.ranking,userData["uid"],widget.gameType ,palette,scalor);
            return Container(
              child: Padding(
                padding: EdgeInsets.fromLTRB(12.0*scalor,12.0*scalor,12.0*scalor,22.0*scalor),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                        
                    // Text(
                    //   "Daily Puzzle $formattedDate (${puzzle["difficulty"]})",
                    //   style: palette.mainAppFont(
                    //     textStyle: TextStyle(
                    //       color: palette.widgetText1,
                    //       fontSize: 22*scalor,
                    //     )
                    //   ),
                    // ),
            
                    // Divider(),
                    
                    // Container(
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    //     color: palette.widget1,
                    //     boxShadow: [
                    //       BoxShadow(color: palette.widgetShadow2,offset: Offset(0.0,10.0), spreadRadius: 4.0, blurRadius: 14.0)
                    //     ]                        
                    //   ),
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: Column(
                    //       children: [
                    //         Align(
                    //           alignment: Alignment.centerLeft,
                    //           child: Text(
                    //             "Objective: ",
                    //             style: palette.mainAppFont(
                    //               textStyle: TextStyle(
                    //                 color: palette.widgetText1,
                    //                 fontSize: 18*scalor,
                    //               )
                    //             ),                                
                    //           ),
                    //         ),
                    //         Helpers().getGameObjectiveString(
                    //           puzzle["gameType"],
                    //           puzzle["duration"],
                    //           puzzle["target"],
                    //           puzzle["timeToPlace"],
                    //           palette,
                    //           16 *scalor
                    //         ),
            
                    //       ],
                    //     ),
                    //   ),
                    // ),
            
                    // SizedBox(height: 12 * scalor,),

            
                    Expanded(child: Container(
                      decoration: BoxDecoration(                      
                        color: palette.widget1,
                        borderRadius: BorderRadius.all(Radius.circular(12.0*scalor)),
                        boxShadow: [
                          BoxShadow(color: palette.widgetShadow1,offset: Offset(0.0,10.0), spreadRadius: 4.0, blurRadius: 14.0)
                        ]
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0*scalor),
                            child: Text(
                              "Ranking",
                              style: GoogleFonts.lilitaOne(
                                textStyle: TextStyle(
                                  fontSize: 32.0 * scalor,
                                  color: palette.text1
                                )
                              ),
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0*scalor),
                                    child:  tableRes,
                                  ),
                                ],
                              ),
                            ),
                          ),                          
                        ],
                      ))
                    )                      
                        
                  ]
                ),
              )
            );
  }
}



Table getRankingTable(List<dynamic> rankingData, String uid, String gameType, ColorPalette palette, double scalor) {
  // List<dynamic> _rankingData = fakeRanking(rankingData,gameType);
  Map<String,dynamic> rankObject = rankingData.firstWhere((e)=>e["uid"]==uid,orElse: ()=> <String,dynamic>{});
  int rankObjectIndex = rankingData.indexOf(rankObject);


  List<dynamic> rankingSubset = getRankingSubset(rankingData, gameType, uid);

  late Table tableRes = Table(

    columnWidths: const <int, TableColumnWidth>{
      0: FlexColumnWidth(1),
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
            fontSize: 14 * scalor,
            fontWeight: isUser ? FontWeight.w800 : FontWeight.normal 
          ),
        ),  
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            // string,
            rowData["username"],
            style: TextStyle(
              color: palette.text1,
              fontSize: 14 * scalor,
              fontWeight: isUser ? FontWeight.w800 : FontWeight.normal        
            ),
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
            fontSize: 14 * scalor,
            fontWeight: isUser ? FontWeight.w800 : FontWeight.normal        
          ),
        ),            
      ),     
    ]
  );
  return res;
}


List<dynamic> getRankingSubset(List<dynamic> _rankingData, String gameType, String uid,) {
  
  List<dynamic> res = [];
  Map<String,dynamic> rankObject = _rankingData.firstWhere((e)=>e["uid"]==uid,orElse: ()=> <String,dynamic>{});
  // int rankObjectIndex = _rankingData.indexOf(rankObject);
  // print("found rank object: $rankObject");

  // int under = rankObjectIndex-5 < 0 ? 0 : rankObjectIndex-5;
  // int over = rankObjectIndex+5 > _rankingData.length ? _rankingData.length : rankObjectIndex+5;
  if (gameType=="sprint") {
    _rankingData.sort((a, b) => a["score"].compareTo(b["score"]));
  } else if (gameType=="classic") {
    _rankingData.sort((a, b) => b["score"].compareTo(a["score"]));
  }


  int rankObjectIndex = _rankingData.indexOf(rankObject);

  if (_rankingData.length > 10) {
    List<int> ranksToAdd = ranksToAddAround(_rankingData,rankObjectIndex,5,10);
    // print("ranks to add : ${ranksToAdd}");
    int numAbove = ranksToAdd[0];
    int numBelow = ranksToAdd[1];
    for (int i=rankObjectIndex-numAbove ; i<rankObjectIndex+numBelow; i++) {
      Map<String,dynamic> rank = _rankingData[i];
      rank["rank"] = i+1;
      res.add(rank);
    }
  } else {
    for (int i=0; i< _rankingData.length; i++) {
      Map<String,dynamic> rank = _rankingData[i];
      rank["rank"] = i+1;
      res.add(rank);
    }
  }

  return res;
}

List<int> ranksToAddAround(List<dynamic> ranks, int rank, int defaultAbove, int defaultBelow) {
  int ranksAbove = defaultAbove;
  int ranksBelow = defaultBelow;
  try {
    if (rank-defaultAbove<0) {
      ranksAbove = rank;
      ranksBelow = (defaultBelow+(defaultAbove+rank));
    } else if (rank+defaultBelow>ranks.length) {
      ranksAbove = defaultAbove + ((rank+defaultBelow)-(ranks.length-1));
      ranksBelow = ranks.length-1-rank;
    } else {
      ranksAbove = defaultAbove;
      ranksBelow = defaultBelow;
    }
  }
  catch(e,s) {
    print("error at ranksToAddAround: $e | stack: $s");
  }
  return [ranksAbove,ranksBelow];
}
