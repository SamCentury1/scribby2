import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/game_logic.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/drawer/instructions_view.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/drawer/main_view.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/drawer/settings_view.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/drawer/shop_view.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/drawer/summary_view.dart';
import 'package:scribby_flutter_v2/screens/home_screen/home_screen.dart';

class GameScreenDrawer extends StatefulWidget {
  final ScaffoldState? scaffoldState;
  const GameScreenDrawer({super.key, required this.scaffoldState});

  @override
  State<GameScreenDrawer> createState() => _GameScreenDrawerState();
}

class _GameScreenDrawerState extends State<GameScreenDrawer> {
  bool showSettings = false;
  List<String> menuViews = ["summary","shop","instructions",];
  int? currentView = null ;

  double getLeftValue(int view, int? currentView) {
    double res  = MediaQuery.of(context).size.width * 0.8;
    if (currentView != null) {
      if (view == currentView ) {
        res = 0.0;//MediaQuery.of(context).size.width * 0.8;
      }
    }
    return res;
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    print('Game screen drawer');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(currentView);
    return Consumer<GamePlayState>(
      builder: (context, gamePlayState, child) {

        double left = currentView != null ? -MediaQuery.of(context).size.width * 0.8 : 0;

        return Drawer(
          backgroundColor: const Color.fromARGB(255, 61, 61, 61),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Stack(
            children: [
              // Main Menu
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                // left: showSettings ? -MediaQuery.of(context).size.width * 0.8 : 0,
                left: left,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height,
                  // child: _buildMainMenu(gamePlayState),
                  child: MainDrawerView(
                    navigateToSummary: ()  {
                      int index = menuViews.indexOf("summary");
                      currentView = index;      
                    },                    
                    // navigateToSettings: ()  {
                    //   int index = menuViews.indexOf("settings");
                    //   currentView = index;      
                    // },
                    navigateToShop: () {
                      int index = menuViews.indexOf("shop");
                      currentView = index;                           
                    },
                    navigateToInstructions: () {
                      int index = menuViews.indexOf("instructions");
                      currentView = index;                           
                    },
                    scaffoldState: widget.scaffoldState,

                  ),
                ),
              ),

              // Summary View
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                // left: showSettings ? 0 : MediaQuery.of(context).size.width * 0.8,
                left: getLeftValue(menuViews.indexOf("summary"),currentView),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: SummaryView(
                    onBack:() => setState(() {
                      currentView = null;
                    })
                  ),
                ),
              ),              


              // Settings View
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                // left: showSettings ? 0 : MediaQuery.of(context).size.width * 0.8,
                left: getLeftValue(menuViews.indexOf("shop"),currentView),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ShopView(
                    onBack:() => setState(() {
                      currentView = null;
                    })
                  ),
                ),
              ),
              // Settings View
              // AnimatedPositioned(
              //   duration: const Duration(milliseconds: 300),
              //   // left: showSettings ? 0 : MediaQuery.of(context).size.width * 0.8,
              //   left: getLeftValue(menuViews.indexOf("settings"),currentView),
              //   child: SizedBox(
              //     width: MediaQuery.of(context).size.width * 0.8,
              //     child: SettingsView(
              //       onBack:() => setState(() {
              //         currentView = null;
              //       })
              //     ),
              //   ),
              // ),

              // Settings View
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                // left: showSettings ? 0 : MediaQuery.of(context).size.width * 0.8,
                left: getLeftValue(menuViews.indexOf("instructions"),currentView),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: InstructionsView(
                    onBack:() => setState(() {
                      currentView = null;
                    })
                  ),

                ),
              ),                            
            ],
          ),
        );
      },
    );
  }
}
