
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/screens/statistics_screen.dart/components/badge_painters.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';

class AchievementsPageView extends StatefulWidget {
  final SettingsController settings; 
  final ColorPalette palette;
  const AchievementsPageView({
    super.key,
    required this.settings,
    required this.palette
  });

  @override
  State<AchievementsPageView> createState() => _AchievementsPageViewState();
}

class _AchievementsPageViewState extends State<AchievementsPageView> {
  @override
  Widget build(BuildContext context) {

    final double scalor = Helpers().getScalor(widget.settings);

    // List<dynamic> badges = widget.settings.achievementData.value.where((e)=>e["completed"]==true).toList();
    List<dynamic> badges = widget.settings.achievementData.value.toList();

    print("yooo we here in the achievements page view: ${widget.settings.achievementData.value}");

    return Builder(
      builder: (context) {
        
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0 * scalor),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Builder(
                    builder: (context) {
                      List<Widget> badgeWidgets = [];
                      for (int i=0; i<badges.length; i++) {
                        if (badges[i]["type"]=="inGame" && badges[i]["target"]=="crosswords") {
                          
                          Widget badgeWidget = Padding(
                            padding: EdgeInsets.all(4.0*scalor),
                            child: SizedBox(
                              width: 75,
                              height: 75,
                              child: BadgeWidget( badgeData: badges[i], scalor: scalor,),
                              // child: CustomPaint(
                              //   painter: BadgePainter(badgeData: badges[i]),
                              // )
                            ),
                          );
                          badgeWidgets.add(badgeWidget);
                        }
                      }
                      if (badgeWidgets.isNotEmpty) {
                        return Column(
                          children: [
                            Text(
                              "Crosswords",
                              style: widget.palette.mainAppFont(
                                textStyle:  TextStyle(
                                  color: widget.palette.text1,
                                  fontSize: 22*scalor
                                ),
                              ),
                            ),                      
                            Wrap(
                              children: badgeWidgets,
                            ),
                          ],
                        );
                      }
                      return SizedBox();
                    },
                  ),
                  SizedBox(height: 40*scalor,),
                  Builder(
                    builder: (context) {
                      Color bg2 = widget.palette.bg2;
                      List<Widget> badgeWidgets = [];
                      for (int i=0; i<badges.length; i++) {
                        if (badges[i]["type"]=="inGame" && badges[i]["target"]=="words") {
                          Widget badgeWidget = Padding(
                            padding: EdgeInsets.all(4.0*scalor),
                              child: Padding(
                                padding: EdgeInsets.all(4.0*scalor),
                                child: SizedBox(
                                  width: 75,
                                  height: 75,
                                  child: BadgeWidget( badgeData: badges[i], scalor: scalor,),
                                ),
                              ),
                            // ),
                          );
                          badgeWidgets.add(badgeWidget);
                        }
                      }
                      if (badgeWidgets.isNotEmpty) {
                        return Column(
                          children: [
                            Text(
                              "Multi-Word Turns",
                              style: widget.palette.mainAppFont(
                                textStyle:  TextStyle(
                                  color: widget.palette.text1,
                                  fontSize: 22*scalor
                                ),
                              ),
                            ),                        
                            Wrap(
                              children: badgeWidgets,
                            ),
                          ],
                        );
                      } 
                      return SizedBox();
                    },
                  ),
                  SizedBox(height: 40*scalor,),
        
                  Builder(
                    builder: (context) {
                      List<Widget> badgeWidgets = [];
                      for (int i=0; i<badges.length; i++) {
                        if (badges[i]["type"]=="inGame" && badges[i]["target"]=="streak") {
                          Widget badgeWidget = Padding(
                            padding: EdgeInsets.all(4.0*scalor),
                            child: SizedBox(
                              width: 75,
                              height: 75,
                              child: BadgeWidget( badgeData: badges[i], scalor: scalor,),
                            ),
                          );
                          badgeWidgets.add(badgeWidget);
                        }
                      }
                      if (badgeWidgets.isNotEmpty) {
                        return Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(4.0*scalor),
                              child: Text(
                                "Streaks",
                                style: widget.palette.mainAppFont(
                                  textStyle:  TextStyle(
                                    color: widget.palette.text1,
                                    fontSize: 22*scalor
                                  ),
                                ),
                              ),
                            ),                      
                            Wrap(
                              children: badgeWidgets,
                            ),
                          ],
                        );
                      }
                      return SizedBox();
                    },
                  ),
        
                  SizedBox(height: 40*scalor,),
        
                  Builder(
                    builder: (context) {
                      List<Widget> badgeWidgets = [];
                      for (int i=0; i<badges.length; i++) {
                        if (badges[i]["type"]=="global" && badges[i]["target"]=="words") {
                          Widget badgeWidget = Padding(
                            padding: EdgeInsets.all(4.0*scalor),
                            child: SizedBox(
                              width: 75,
                              height: 75,
                              child: BadgeWidget( badgeData: badges[i], scalor: scalor,),
                            ),
                          );
                          badgeWidgets.add(badgeWidget);
                        }
                      }
                      if (badgeWidgets.isNotEmpty) {
                        return Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(4.0*scalor),
                              child: Text(
                                "Total Words Found",
                                style: widget.palette.mainAppFont(
                                  textStyle:  TextStyle(
                                    color: widget.palette.text1,
                                    fontSize: 22*scalor
                                  ),
                                ),
                              ),
                            ),                      
                            Wrap(
                              children: badgeWidgets,
                            ),
                          ],
                        );
                      }
                      return SizedBox();
                    },
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


class BadgeWidget extends StatelessWidget {
  final Map<String,dynamic> badgeData;
  final double scalor;
  const BadgeWidget({
    super.key,
    required this.badgeData,
    required this.scalor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openBadgeDialog(context,badgeData,scalor),
      child: CustomPaint(
        painter: BadgePainter(badgeData: badgeData),
      ),
    );
  }
}

Future<void> openBadgeDialog(BuildContext context, Map<String,dynamic> badgeData,double scalor) async {
  return showDialog(
    context: context, 
    builder:(context) {


      final ColorPalette palette = Provider.of<ColorPalette>(context,listen: false);


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

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0 * scalor),
                child: Row(
                  children: [
                
                    Text(
                      badgeData["name"],
                      style: palette.mainAppFont(
                        textStyle: TextStyle(
                          color: palette.dialogText,
                          fontSize: 24 * scalor
                        )
                      ),
                
                    ),
                    Expanded(child: SizedBox(),),
                
                    Text(
                      "${badgeData["xp"]}",
                      style: palette.mainAppFont(
                        textStyle: TextStyle(
                          color: palette.dialogText,
                          fontSize: 24 * scalor
                        )
                      ),
                
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 30*scalor,
                      height: 30*scalor,
                      child: Image.asset("assets/images/xp_image.png")
                    ),                  
                  ],
                ),
              ),
              
              badgeData["dateCompleted"] == null ? 
              Text(
                "Badge not earned yet...",
                style: palette.mainAppFont(
                  textStyle: TextStyle(
                    color: palette.dialogText,
                    fontSize: 20 * scalor
                  )
                ),                
              ) :
              Text(
                "Badge earned ${Helpers().formatDate(badgeData["dateCompleted"])}",
                style: palette.mainAppFont(
                  textStyle: TextStyle(
                    color: palette.dialogText,
                    fontSize: 20 * scalor
                  )
                ),                
              ),

              SizedBox(
                width: 300 * scalor,
                height: 300 * scalor,

                child: CustomPaint(
                  painter: BadgePainter(
                    badgeData: badgeData
                  ),
                ),
              )

            ],
          ),
        ),
      );
    },                  
  );
}