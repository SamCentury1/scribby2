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
      // GameHistoryPageView(settings: settings, palette: palette,),
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
                        // BottomNavigationBarItem(icon: Icon(Icons.query_stats), label: 'History', ),
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

