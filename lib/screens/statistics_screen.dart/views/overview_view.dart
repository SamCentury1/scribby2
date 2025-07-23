import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/screens/statistics_screen.dart/components/game_summary_card.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';

class OverviewView extends StatefulWidget {
  final SettingsController settings; 
  final ColorPalette palette;
  const OverviewView({
    super.key,
    required this.settings,
    required this.palette
  });

  @override
  State<OverviewView> createState() => _OverviewViewState();
}

class _OverviewViewState extends State<OverviewView> {
  @override
  Widget build(BuildContext context) {

    final double scalor = Helpers().getScalor(widget.settings);

    final Map<String,dynamic> userData = widget.settings.userData.value as Map<String,dynamic>;
    final int xp = widget.settings.xp.value;
    final String rankKey = userData["rank"];
    final Map<dynamic,dynamic> rankObject = widget.settings.rankData.value.firstWhere((e)=>e["key"]==rankKey,orElse: ()=>{});
    late int rank = 1;
    late int level = 1;
    if (rankObject.isNotEmpty) {
      level = rankObject["level"];
      rank = rankObject["rank"];
    }

    print("rankKey: $rankKey | level: $level | rank: $rank");

    List<String> allUniqueWords = Helpers().getAllUniqueWords(widget.settings);
    int totalPointsScored = Helpers().getAllPointsScored(widget.settings);
    String createdAt = Helpers().formatDate(userData["createdAt"]);
    // print(widget.settings.userGameHistory.value[2]);


    String rankText = "Level $level ${Helpers().translateRankTitle(rank, userData['language'])}";

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0 * scalor),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30 * scalor,),
              Text(
                "Overview",
                style: widget.palette.mainAppFont(
                  textStyle: TextStyle(
                    fontSize: 22*scalor,
                    color: widget.palette.text1
                  ),
                ),
              ),
          
          
          
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Player Since:",
                  style: widget.palette.mainAppFont(
                    textStyle: TextStyle(
                      fontSize: 26 * scalor,
                      color: widget.palette.text1
                    ),

                  ) 
                ),
              ),
          
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  // userData["createdAt"] == null ? "2025-02-11" : userData["createdAt"].toString(),
                  createdAt,
                  style: widget.palette.mainAppFont(
                    textStyle: TextStyle(
                      fontSize: 36 * scalor,
                      color: widget.palette.text1
                    ),
                  )
                ),
              ),             
          
              SizedBox(height: 20 * scalor,),
              Divider(thickness: 1.0 * scalor,),
              SizedBox(height: 20 * scalor,),
          
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.grade,size: 28 * scalor, color: widget.palette.text1,),
                  // SizedBox(width: 20*scalor,),
                  Padding(
                    padding: EdgeInsets.all(8.0*scalor),
                    child: Text(
                      rankText,
                      style: widget.palette.mainAppFont(
                        textStyle: TextStyle(
                          fontSize: 28 * scalor,
                          color: widget.palette.text1,
                        ),
                      ) 
                    ),
                  ),
          
                  Icon(Icons.grade,size: 28 * scalor, color: widget.palette.text1,),
                  
                ],
              ),
              
          
             
          
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.all(8.0 * scalor),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8.0*scalor)),
                          border: Border.all(width: 2.0 * scalor, color: widget.palette.text1)
                        ),
                        child: Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 12.0*scalor),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: 30*scalor,
                                height: 30*scalor,
                                child: Image.asset("assets/images/coin_image.png")
                              ),
                              SizedBox(width: 10,),
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    widget.settings.coins.value.toString(),
                                    // "231242223432",
                                    style: widget.palette.counterFont(
                                      textStyle: TextStyle(
                                        color: widget.palette.text1,
                                        fontSize: 32 * scalor
                                      ),
                                    )
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ),
          
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.all(8.0 * scalor),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8.0*scalor)),
                          border: Border.all(width: 2.0 * scalor, color: widget.palette.text1)
                        ),
                        child: Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 12.0*scalor),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: 30*scalor,
                                height: 30*scalor,
                                child: Image.asset("assets/images/xp_image.png")
                              ),
                              SizedBox(width: 10,),
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    widget.settings.xp.value.toString(),
                                    // "231242223432",
                                    style: widget.palette.counterFont(
                                      textStyle: TextStyle(
                                        color: widget.palette.text1,
                                        fontSize: 32 * scalor
                                      ),
                                    )
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ),
                ],
              ),
          
              SizedBox(height: 20 * scalor,),
              Divider(thickness: 1.0 * scalor,),
              SizedBox(height: 20 * scalor,),
          
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Games Played",
                  style: widget.palette.mainAppFont(
                    textStyle: TextStyle(
                      fontSize: 26 * scalor,
                      color: widget.palette.text1,
                    ),
                  ) 
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.settings.userGameHistory.value.length.toString(),
                  style: widget.palette.counterFont(
                    textStyle: TextStyle(
                      fontSize: 36 * scalor,
                      color: widget.palette.text1,
                    ),
                  ) 
                ),
              ),
          
              SizedBox(height: 20 * scalor,),
          
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Points Scored",
                  style: widget.palette.mainAppFont(
                    textStyle: TextStyle(
                      fontSize: 26 * scalor,
                      color: widget.palette.text1,
                    ),
                  ) 
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  totalPointsScored.toString(),
                  style: widget.palette.counterFont(
                    textStyle: TextStyle(
                      fontSize: 36 * scalor,
                      color: widget.palette.text1,
                    ),
                  ) 
                ),
              ),
          
              SizedBox(height: 20 * scalor,),
          
          
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Unique Words Found",
                  style: widget.palette.mainAppFont(
                    textStyle: TextStyle(
                      fontSize: 26 * scalor,
                      color: widget.palette.text1,
                    ),
                  ) 
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  allUniqueWords.length.toString(),
                  style: widget.palette.counterFont(
                    textStyle: TextStyle(
                      fontSize: 36 * scalor,
                      color: widget.palette.text1,
                    ),
                  ) 
                ),
              ),
          
              SizedBox(height: 20 * scalor,)   
              
                       
            ],
          ),
        )
        
      ),
    );
  }
}
