import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/components/background_painter.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/screens/statistics_screen.dart/components/badge_painters.dart';
import 'package:scribby_flutter_v2/screens/statistics_screen.dart/components/game_summary_card.dart';
import 'package:scribby_flutter_v2/screens/statistics_screen.dart/views/badges_view.dart';
import 'package:scribby_flutter_v2/screens/statistics_screen.dart/views/game_history_view.dart';
import 'package:scribby_flutter_v2/screens/statistics_screen.dart/views/overview_view.dart';
import 'package:scribby_flutter_v2/screens/instructions_screen/components/instructions_column.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';



class StatsPageView extends StatefulWidget {
  const StatsPageView({super.key});

  @override
  State<StatsPageView> createState() => _StatsPageViewState();
}

class _StatsPageViewState extends State<StatsPageView> {

  int _selectedIndex = 0;
  // static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  late SettingsController settings;
  late ColorPalette palette;
  late List<Widget> _widgetOptions = [];

  

  late PageController controller;



  void _onItemTapped(int index) {

    setState(() {
      controller.animateToPage(
        index,
        duration: Duration(milliseconds: 300), // or any duration you prefer
        curve: Curves.decelerate
      );
    });
    // print("animate to index: ${index} " );
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    settings = Provider.of<SettingsController>(context, listen: false);
    palette = Provider.of<ColorPalette>(context, listen: false);
    controller = PageController();

    _widgetOptions = [
      OverviewView(settings: settings, palette:palette),
      GameHistoryPageView(settings: settings, palette: palette,),
      AchievementsPageView(settings: settings, palette: palette,),
    ];
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsController>(
      builder: (context,settings,child) {

        ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);

        late double scalor = 1.0;
        final double menuPositionTop = MediaQuery.of(context).padding.top-5;
        return PopScope(
          canPop: true,
          child: SizedBox(
            // width: MediaQuery.of(context).size.width,
            // height: MediaQuery.of(context).size.height,            
            child: SafeArea(
              child: Stack(
                children: [
                  Positioned(
                    // top: 1,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,//-MediaQuery.of(context).padding.top-MediaQuery.of(context).padding.bottom,
                      child: CustomPaint(
                        painter: GradientBackground(settings: settings, palette: palette, decorationData: []),
                      ),
                    ),
                  ),             
                  Scaffold(
                    backgroundColor: Colors.transparent,
                    onDrawerChanged: (var details) {},
                    appBar: AppBar(
                      backgroundColor: const Color.fromARGB(0, 49, 49, 49),
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back, color: palette.appBarText,),
                        onPressed: () => Navigator.of(context).pop(true),
                      ),

                      title: Text(
                        "Stats",
                        style: palette.mainAppFont(
                          textStyle: TextStyle(
                            color: palette.appBarText,
                            fontSize: 36*scalor,
                          ),                        
                        )
                      )
                    ),

                    body: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: PageView(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        controller: controller,
                        onPageChanged: _onPageChanged,
                        children:_widgetOptions,
                      ),
                    ),
                    bottomNavigationBar: BottomNavigationBar(
                      items: const <BottomNavigationBarItem>[
                        BottomNavigationBarItem(icon: Icon(Icons.summarize), label: 'Overview',),
                        BottomNavigationBarItem(icon: Icon(Icons.query_stats), label: 'History', ),
                        BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: 'Badges'),
                      ],
                      selectedItemColor: palette.text2,
                      unselectedItemColor: palette.text2.withAlpha(140),
                      currentIndex: _selectedIndex,
                      // selectedItemColor: palette.text1,
                      onTap: _onItemTapped,
                      backgroundColor: Colors.transparent,
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



// class GameHistoryPageView extends StatefulWidget {
//   final SettingsController settings; 
//   final ColorPalette palette;
//   const GameHistoryPageView({
//     super.key,
//     required this.settings,
//     required this.palette
//   });

//   @override
//   State<GameHistoryPageView> createState() => _GameHistoryPageViewState();
// }

// class _GameHistoryPageViewState extends State<GameHistoryPageView> {
//   @override
//   Widget build(BuildContext context) {

//     final double scalor = Helpers().getScalor(widget.settings);

//     return SizedBox(
//       height: MediaQuery.of(context).size.height,
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 12.0 * scalor),
//         child: ListView.builder(
//           itemCount: widget.settings.userGameHistory.value.length,
//           itemBuilder: (BuildContext context, int index) {
//             return GameSummaryCard(gameData: widget.settings.userGameHistory.value[index],palette: widget.palette,);
//           }
//         )
//       ),
//     );
//   }
// }



// class AchievementsPageView extends StatefulWidget {
//   final SettingsController settings; 
//   final ColorPalette palette;
//   const AchievementsPageView({
//     super.key,
//     required this.settings,
//     required this.palette
//   });

//   @override
//   State<AchievementsPageView> createState() => _AchievementsPageViewState();
// }

// class _AchievementsPageViewState extends State<AchievementsPageView> {
//   @override
//   Widget build(BuildContext context) {

//     final double scalor = Helpers().getScalor(widget.settings);

//     List<dynamic> badges = widget.settings.achievementData.value.where((e)=>e["completed"]==true).toList();

//     print("yooo we here in the achievements page view: ${widget.settings.achievementData.value}");

//     return SizedBox(
//       height: MediaQuery.of(context).size.height,
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 12.0 * scalor),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Builder(
//                 builder: (context) {
//                   List<Widget> badgeWidgets = [];
//                   for (int i=0; i<badges.length; i++) {
//                     if (badges[i]["type"]=="inGame" && badges[i]["target"]=="crosswords") {
//                       Widget badgeWidget = Padding(
//                         padding: EdgeInsets.all(4.0*scalor),
//                         child: SizedBox(
//                           width: 100,
//                           height: 100,
//                           child: CustomPaint(
//                             painter: BadgePainter(badgeData: badges[i]),
//                           )
//                         ),
//                       );
//                       badgeWidgets.add(badgeWidget);
//                     }
//                   }
//                   if (badgeWidgets.isNotEmpty) {
//                     return Column(
//                       children: [
//                         Text(
//                           "Crosswords",
//                           style: GoogleFonts.luckiestGuy(
//                             color: widget.palette.text1,
//                             fontSize: 22*scalor
//                           ),
//                         ),                      
//                         Wrap(
//                           children: badgeWidgets,
//                         ),
//                       ],
//                     );
//                   }
//                   return SizedBox();
//                 },
//               ),
//               SizedBox(height: 40*scalor,),
//               Builder(
//                 builder: (context) {
//                   Color bg2 = widget.palette.bg2;
//                   List<Widget> badgeWidgets = [];
//                   for (int i=0; i<badges.length; i++) {
//                     if (badges[i]["type"]=="inGame" && badges[i]["target"]=="words") {
//                       Widget badgeWidget = Padding(
//                         padding: EdgeInsets.all(4.0*scalor),
//                         // child: Container(
//                         //   decoration: BoxDecoration(
//                         //     gradient: LinearGradient(
//                         //       begin: Alignment.topCenter,
//                         //       end: Alignment.bottomCenter,
//                         //       colors: [
//                         //         const Color.fromARGB(38, 255, 255, 255),
//                         //         const Color.fromARGB(132, 64, 50, 255)
//                         //         // widget.palette.bg1,
//                         //         // Color.fromRGBO(bg2.r.floor(), bg2.g.floor(), bg2.b.floor(), 0.3),
//                         //       ],
//                         //     ),
//                         //     borderRadius: BorderRadius.all(Radius.circular(12.0*scalor)),
//                         //     boxShadow: [
//                         //       BoxShadow(
//                         //         color: const Color.fromARGB(85, 0, 0, 0),
//                         //         offset: Offset(0.0, 5.0*scalor),
//                         //         blurRadius: 5.0*scalor,
//                         //         spreadRadius: 1.0*scalor
//                         //       )
//                         //     ]
//                         //   ),
//                           child: Padding(
//                             padding: EdgeInsets.all(4.0*scalor),
//                             child: SizedBox(
//                               width: 100,
//                               height: 100,
//                               child: CustomPaint(
//                                 painter: BadgePainter(badgeData: badges[i]),
//                               )
//                             ),
//                           ),
//                         // ),
//                       );
//                       badgeWidgets.add(badgeWidget);
//                     }
//                   }
//                   if (badgeWidgets.isNotEmpty) {
//                     return Column(
//                       children: [
//                         Text(
//                           "Multi-Word Turns",
//                           style: GoogleFonts.luckiestGuy(
//                             color: widget.palette.text1,
//                             fontSize: 22*scalor
//                           ),
//                         ),                        
//                         Wrap(
//                           children: badgeWidgets,
//                         ),
//                       ],
//                     );
//                   } 
//                   return SizedBox();
//                 },
//               ),
//               SizedBox(height: 40*scalor,),

//               Builder(
//                 builder: (context) {
//                   List<Widget> badgeWidgets = [];
//                   for (int i=0; i<badges.length; i++) {
//                     if (badges[i]["type"]=="inGame" && badges[i]["target"]=="streak") {
//                       Widget badgeWidget = Padding(
//                         padding: EdgeInsets.all(4.0*scalor),
//                         child: SizedBox(
//                           width: 100,
//                           height: 100,
//                           child: CustomPaint(
//                             painter: BadgePainter(badgeData: badges[i]),
//                           )
//                         ),
//                       );
//                       badgeWidgets.add(badgeWidget);
//                     }
//                   }
//                   if (badgeWidgets.isNotEmpty) {
//                     return Column(
//                       children: [
//                         Text(
//                           "Streaks",
//                           style: GoogleFonts.luckiestGuy(
//                             color: widget.palette.text1,
//                             fontSize: 22*scalor
//                           ),
//                         ),                      
//                         Wrap(
//                           children: badgeWidgets,
//                         ),
//                       ],
//                     );
//                   }
//                   return SizedBox();
//                 },
//               ),


//               Builder(
//                 builder: (context) {
//                   List<Widget> badgeWidgets = [];
//                   for (int i=0; i<badges.length; i++) {
//                     if (badges[i]["type"]=="global" && badges[i]["target"]=="words") {
//                       Widget badgeWidget = Padding(
//                         padding: EdgeInsets.all(4.0*scalor),
//                         child: SizedBox(
//                           width: 100,
//                           height: 100,
//                           child: CustomPaint(
//                             painter: BadgePainter(badgeData: badges[i]),
//                           )
//                         ),
//                       );
//                       badgeWidgets.add(badgeWidget);
//                     }
//                   }
//                   if (badgeWidgets.isNotEmpty) {
//                     return Column(
//                       children: [
//                         Text(
//                           "Total Words Found",
//                           style: GoogleFonts.luckiestGuy(
//                             color: widget.palette.text1,
//                             fontSize: 22*scalor
//                           ),
//                         ),                      
//                         Wrap(
//                           children: badgeWidgets,
//                         ),
//                       ],
//                     );
//                   }
//                   return SizedBox();
//                 },
//               ),              
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
















