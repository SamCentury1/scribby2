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

  late double scalor = 1.0;
  late Map<String,dynamic> userData = {};
  late List<String> allUniqueWords = [];
  late int totalPointsScored = 0;
  late String createdAt = "";
  late String rankText = "";
  late List<dynamic> gameHistory = [];
  late int xp = 0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
      
        userData = widget.settings.userData.value as Map<String,dynamic>;
        scalor = Helpers().getScalor(widget.settings);
        late String rankKey  = userData["rank"];
        Map<String,dynamic> rankObject = widget.settings.rankData.value.firstWhere((e)=>e["key"]==rankKey,orElse: ()=><String,dynamic>{});
        if (rankObject.isNotEmpty) {
          rankText = "Level ${rankObject['level']} ${Helpers().translateRankTitle(rankObject['rank'], userData['language'])}";
        }

        allUniqueWords = Helpers().getAllUniqueWords(widget.settings);
        totalPointsScored = Helpers().getAllPointsScored(widget.settings);
        createdAt = Helpers().formatDate(userData["createdAt"]);
        gameHistory = Helpers().getGameHistory(widget.settings);
        xp = userData["xp"];
      });
    });
    

  }

  @override
  Widget build(BuildContext context) {




    // final int xp = widget.settings.xp.value;



    // List<String> allUniqueWords = Helpers().getAllUniqueWords(widget.settings);
    // int totalPointsScored = Helpers().getAllPointsScored(widget.settings);
    // String createdAt = Helpers().formatDate(userData["createdAt"]);
    // String rankText = "Level $level ${Helpers().translateRankTitle(rank, userData['language'])}";

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
                                    userData["coins"].toString(),
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
                                    // widget.settings.xp.value.toString(),
                                    xp.toString(),
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
                  gameHistory.length.toString(),
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
