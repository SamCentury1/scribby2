import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/dialogs/game_pause_screens/game_help_screen.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/dialogs/game_pause_screens/game_quit_screen.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/dialogs/game_pause_screens/game_settings_screen.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/dialogs/game_pause_screens/game_summary_screen.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class GamePauseDialog extends StatefulWidget {
  const GamePauseDialog({
    super.key,
  });

  @override
  State<GamePauseDialog> createState() => _GamePauseDialogState();
}

class _GamePauseDialogState extends State<GamePauseDialog> {
  // final PageController _controller = PageController();
  // int currentPage = 0;
  // late double bottomNavHeight = 0;

  // @override
  // void initState() {
  //   super.initState();
  //   bottomNavHeight = Platform.isIOS ? 68 : 68;
  // }

  

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
    
  // }
  
  double getDialogWidth(double currentScreenWidth) {
    late double res = currentScreenWidth;
    if (currentScreenWidth > 500) {
      res = 500;
    }
    return res * 0.85;
  } 


  Widget displayPage(String pageName) {                    
    if (pageName == 'summary') {
      return GameSummaryScreen();
    } else if (pageName == 'help') {
      return GameHelpScreen();
    } else if (pageName == 'settings') {
      return GameSettings();
    } else if (pageName == 'quit') {
      return GameQuitScreen();
    } else {
      print("a problem occured");
      return GameSummaryScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);

    return Consumer<GamePlayState>(
      builder: (context, gamePlayState, child) {
        // gamePlayState.isGamePaused ? changeBackToZero() : null;
        return Dialog(
          insetPadding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(gamePlayState.tileSize*0.3),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(gamePlayState.tileSize*0.3),
            child: Container(
              // width: MediaQuery.of(context).size.width * 0.85,
              // width: getDialogWidth(MediaQuery.of(context).size.width),
              width: gamePlayState.tileSize*5,
              height: MediaQuery.of(context).size.height * 0.65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(gamePlayState.tileSize*0.3)),
                // color: palette.optionButtonBgColor
                // color: Colors.orange,
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: <Color>[
                    palette.optionButtonBgColor,
                    palette.optionButtonBgColor2,
                  ]
                )
                // color: Color.fromARGB(125, 71, 65, 65)
              ),
              child: Column(
                children: <Widget>[
                  // TextButton(onPressed: changeBackToZero, child: Text("change")),
                  // Expanded(
                  //   child: PageView(
                  //     // controller: gamePlayState.pageController,
                  //     controller: _controller,
                  //     onPageChanged: (index) {
                  //       setState(() {
                  //         currentPage = index;
                  //       });
                  //     },
                  //     children: const <Widget>[
                  //       GameSummaryScreen(),
                  //       GameHelpScreen(),
                  //       GameSettings(),
                  //       GameQuitScreen()
                  //     ],
                  //   ),
                  // ),
                  Expanded(child: displayPage(gamePlayState.pauseScreen)),
                  ClipRRect(
                    
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    child: Container(
                      // height: gamePlayState.tileSize*1.2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            palette.emptyTileGradientBackGroundColor1,
                            palette.emptyTileGradientBackGroundColor2,
                            // Colors.white,
                            // Colors.pink
                          ]
                        )
                      ),
                      // height: (58 * settingsState.sizeFactor),
                      // height: bottomNavHeight,
                      // height: double.maxFinite,
                      // height: gamePlayState.tileSize*,
                      // child: BottomNavigationBar(
                      //   currentIndex: currentPage,
                      //   onTap: (index) {
                      //     setState(() {
                      //       currentPage = index;
                      //       _controller.animateToPage(
                      //         index,
                      //         duration: const Duration(milliseconds: 300),
                      //         curve: Curves.ease,
                      //       );
                      
                      //     });
                      //   },
                      //   // type: BottomNavigationBarType.shifting,
                      //   type: BottomNavigationBarType.fixed,
                      //   // selectedItemColor: palette.navigationBarItemSelected,
                      //   // unselectedItemColor: palette.navigationBarItemUnselected,
                      //   // selectedFontSize: (12 * settingsState.sizeFactor),
                      //   // selectedFontSize: gamePlayState.tileSize*0.4,
                      //   showUnselectedLabels: false,
                      //   backgroundColor: Colors.transparent,   
                      //   selectedIconTheme: IconThemeData(color: Colors.white),                     
                      //   items: [
                      //     BottomNavigationBarItem(
                      //       icon: Icon(
                      //         Icons.gamepad,
                      //         size: (gamePlayState.tileSize*0.35),
                      //       ),
                      //       label: "",
                      //       // label: Helpers().translateText(gamePlayState.currentLanguage,'Summary'),
                      //       // backgroundColor: palette.navigationBarColor,
                      //     ),
                      //     BottomNavigationBarItem(
                      //       icon:  Icon(
                      //         Icons.help,
                      //         size: (gamePlayState.tileSize*0.35),
                      //       ),
                      //       label: "",
                      //       // label: Helpers().translateText(gamePlayState.currentLanguage,'Help'),
                      //       // backgroundColor: palette.navigationBarColor,
                      //     ),
                      //     BottomNavigationBarItem(
                      //       icon:  Icon(
                      //         Icons.settings,
                      //         size: (gamePlayState.tileSize*0.35),
                      //       ),
                      //       label: "",
                      //       // label: Helpers().translateText(gamePlayState.currentLanguage,'Settings'),
                      //       // backgroundColor: palette.navigationBarColor,
                      //     ),
                      //     BottomNavigationBarItem(
                      //       icon:  Icon(
                      //         Icons.exit_to_app,
                      //         size: (gamePlayState.tileSize*0.35),
                      //       ),
                      //       label: "",
                      //       // label: Helpers().translateText(gamePlayState.currentLanguage,'Quit'),
                      //       // backgroundColor: palette.navigationBarColor,
                      //     ),
                      //   ],
                      // ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

