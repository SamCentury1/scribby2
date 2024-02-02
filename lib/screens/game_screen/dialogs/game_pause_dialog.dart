// import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
// import 'package:scribby_flutter_v2/functions/game_logic.dart';
// import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
// import 'package:scribby_flutter_v2/providers/game_state.dart';
import 'package:scribby_flutter_v2/screens/game_screen/dialogs/game_pause_screens/game_help_screen.dart';
import 'package:scribby_flutter_v2/screens/game_screen/dialogs/game_pause_screens/game_quit_screen.dart';
import 'package:scribby_flutter_v2/screens/game_screen/dialogs/game_pause_screens/game_settings_screen.dart';
import 'package:scribby_flutter_v2/screens/game_screen/dialogs/game_pause_screens/game_summary_screen.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';
// import 'package:scribby_flutter_v2/settings/settings.dart';

class GamePauseDialog extends StatefulWidget {
  const GamePauseDialog({
    super.key,
  });

  @override
  State<GamePauseDialog> createState() => _GamePauseDialogState();
}

class _GamePauseDialogState extends State<GamePauseDialog> {
  final PageController _controller = PageController();
  // late GamePlayState gamePlayState;
  int currentPage = 0;

  // @override
  // void initState() {
  //   super.initState();
  //   // gamePlayState = Provider.of<GamePlayState>(context, listen: false);
  //   // gamePlayState.pageController.jumpToPage(0);
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              height: MediaQuery.of(context).size.height * 0.65,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                  color: palette.optionButtonBgColor
                  // color: Color.fromARGB(125, 71, 65, 65)
                  ),
              child: Column(
                children: <Widget>[
                  // TextButton(onPressed: changeBackToZero, child: Text("change")),
                  Expanded(
                    child: PageView(
                      // controller: gamePlayState.pageController,
                      controller: _controller,
                      onPageChanged: (index) {
                        setState(() {
                          currentPage = index;
                        });
                      },
                      children: const <Widget>[
                        GameSummaryScreen(),
                        GameHelpScreen(),
                        GameSettings(),
                        GameQuitScreen()
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    child: BottomNavigationBar(
                      currentIndex: currentPage,
                      onTap: (index) {
                        setState(() {
                          currentPage = index;
                          _controller.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                          // gamePlayState.pageController.animateToPage(
                          //   index,
                          //   duration: const Duration(milliseconds: 300),
                          //   curve: Curves.ease,
                          // );
                        });
                        // gamePlayState.pageController.jumpToPage(
                        //   index,
                        // );
                        // if (gamePlayState.pageController.hasClients) {
                        //   gamePlayState.pageController.jumpTo(
                        //     index.toDouble(),
                        //     // duration: const Duration(milliseconds: 300),
                        //     // curve: Curves.ease,
                        //   );
                        // }
                      },
                      type: BottomNavigationBarType.shifting,
                      // type: BottomNavigationBarType.fixed,
                      selectedItemColor: palette.tileBgColor,
                      unselectedItemColor: palette.optionButtonTextColor,
                      items: [
                        BottomNavigationBarItem(
                          icon: const Icon(
                            Icons.gamepad,
                          ),
                          label: Helpers().translateText(gamePlayState.currentLanguage,'Summary'),
                          backgroundColor: palette.optionButtonBgColor2,
                        ),
                        BottomNavigationBarItem(
                          icon: const Icon(
                            Icons.help,
                          ),
                          label: Helpers().translateText(gamePlayState.currentLanguage,'Help'),
                          backgroundColor: palette.optionButtonBgColor2,
                        ),
                        BottomNavigationBarItem(
                          icon: const Icon(
                            Icons.settings,
                          ),
                          label: Helpers().translateText(gamePlayState.currentLanguage,'Settings'),
                          backgroundColor: palette.optionButtonBgColor2,
                        ),
                        BottomNavigationBarItem(
                          icon: const Icon(
                            Icons.exit_to_app,
                          ),
                          label: Helpers().translateText(gamePlayState.currentLanguage,'Quit'),
                          backgroundColor: palette.optionButtonBgColor2,
                        ),
                      ],
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

