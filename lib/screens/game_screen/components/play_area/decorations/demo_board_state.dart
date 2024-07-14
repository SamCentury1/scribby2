import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/play_area/decorations/decorations.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/play_area/decorations/demo_tile_widget.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class DemoBoardState extends StatefulWidget {
  final List<Map<dynamic, dynamic>> demoBoardState;
  final String language;
  const DemoBoardState({
    super.key,
    required this.demoBoardState,
    required this.language,
  });

  @override
  State<DemoBoardState> createState() => _DemoBoardStateState();
}

class _DemoBoardStateState extends State<DemoBoardState> {
  late ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
  late SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);
  late GamePlayState gamePlayState = Provider.of<GamePlayState>(context, listen: false);

  final Map<int,dynamic> tileIds = {
    0: "1_1",
    1: "1_2",
    2: "1_3",
    3: "2_1",
    4: "2_2",
    5: "2_3",
    6: "3_1",
    7: "3_2",
    8: "3_3",                            
  };

  @override
  Widget build(BuildContext context) {

    // late double tileSize = getTileSize(MediaQuery.of(context).size.width, settingsState.sizeFactor);
    
    late String randomLetter1 = Helpers().displayDemoTileLetter(widget.demoBoardState, "0_0", widget.language, settingsState.demoLetters);
    late String randomLetter2 = Helpers().displayDemoTileLetter(widget.demoBoardState, "0_1", widget.language, settingsState.demoLetters);


    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            
            // width: 200,
            // width: MediaQuery.of(context).size.width*0.6,
            child: Row(
              children: [
                const Expanded(
                  flex: 1,
                  child: Center(),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Container(
                      width: gamePlayState.tileSize*1,
                      height: gamePlayState.tileSize*1,
                      decoration: Decorations().getTileDecoration(gamePlayState.tileSize*1, palette, 1, 1),
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(gamePlayState.tileSize*1*0.2),
                      //   color: palette.tileBgColor,
                      // ),
                      child: Center(
                        child: DefaultTextStyle(
                          child: Text(
                            randomLetter1,
                          ),
                          style: TextStyle(
                              fontSize: (gamePlayState.tileSize*0.4), color: palette.fullTileTextColor),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Container(
                      width: gamePlayState.tileSize*0.8,
                      height: gamePlayState.tileSize*0.8,
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(gamePlayState.tileSize*0.8*0.2),
                      //   color: palette.tileBgColor,
                      // ),
                      decoration: Decorations().getTileDecoration(gamePlayState.tileSize*0.8, palette, 1, 1),
                      child: Center(
                        child: DefaultTextStyle(
                          child: Text(
                            randomLetter2,
                          ),
                          style: TextStyle(
                              fontSize: (gamePlayState.tileSize*0.35), color: palette.fullTileTextColor),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            // width:(gamePlayState.tileSize*0.75)*3.1,
            width: gamePlayState.tileSize*0.85*3,
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: List.generate(9, (i) {
                return DemoTileWidget(
                  // tileSize: getTileSize(MediaQuery.of(context).size.width, settingsState.sizeFactor), 
                  tileSize: gamePlayState.tileSize*0.8,
                  tileId: tileIds[i], 
                  demoBoardState: widget.demoBoardState, 
                  language: widget.language, 
                  palette: palette, 
                  fontSize: gamePlayState.tileSize*0.3
                );
              }),
            ),            

          ),
        ],
      ),
    );
  }
}