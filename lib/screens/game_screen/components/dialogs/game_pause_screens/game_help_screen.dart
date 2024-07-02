import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/components/dialog_widget.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/play_area/decorations/decorations.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';
// import 'package:scribby_flutter_v2/utils/states.dart';

class GameHelpScreen extends StatefulWidget {
  const GameHelpScreen({super.key});

  @override
  State<GameHelpScreen> createState() => _GameHelpScreenState();
}

class _GameHelpScreenState extends State<GameHelpScreen> {
  Key? get key => null;

  late ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
  late SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);



  @override
  Widget build(BuildContext context) {
    return Consumer<GamePlayState>(
      builder: (context, gamePlayState, child) {
        return DialogWidget(
            key,
            Helpers().translateText(gamePlayState.currentLanguage, "Instructions",settingsState),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _instructionsHeading(palette, "Objective",gamePlayState.currentLanguage, gamePlayState.tileSize*0.35,settingsState),
                    _instructionsText(palette,
                        "The objective of the game is to create words with the randomly generated letters.",
                        gamePlayState.currentLanguage,
                        false,
                        gamePlayState.tileSize*0.30,
                        settingsState.demoLetters,
                        settingsState),
                    _instructionsHeading(palette, "Demo",gamePlayState.currentLanguage, gamePlayState.tileSize*0.35,settingsState),
                    _instructionsText(palette,
                        "The two letters at the top are randomly generated. The center letter letter_01 gets placed next",
                        gamePlayState.currentLanguage,
                        true,
                        gamePlayState.tileSize*0.30,
                        settingsState.demoLetters,
                        settingsState),
                    DemoBoardState(demoBoardState: settingsState.demoStates['demoBoardState1'], language: gamePlayState.currentLanguage),
                    _instructionsText(palette,
                        "When the letter letter_01 is placed inside the board, the letter to the right letter_02 will become the center letter and a new random letter will be generated and take its spot",
                        gamePlayState.currentLanguage,
                        true,
                        gamePlayState.tileSize*0.30,
                        settingsState.demoLetters,
                        settingsState),
                    _instructionsText(palette,
                        "A new letter letter_03 is randomly generated to be place after the next letter letter_02 is placed.",
                        gamePlayState.currentLanguage,
                        true,
                        gamePlayState.tileSize*0.30,
                        settingsState.demoLetters,
                        settingsState),
                    DemoBoardState(demoBoardState: settingsState.demoStates['demoBoardState2'], language: gamePlayState.currentLanguage),
                    _instructionsText(palette,
                        "Place your letters strategically to create words. In this case, we see the letter_04 coming after the letter_03",
                        gamePlayState.currentLanguage,
                        true,
                        gamePlayState.tileSize*0.30,
                        settingsState.demoLetters,
                        settingsState),
                    DemoBoardState(demoBoardState: settingsState.demoStates['demoBoardState3'], language: gamePlayState.currentLanguage),
                    _instructionsText(palette,
                        "The letter_03 is placed below the letter_02 so the letter_04 can be placed between the letter_01 and the letter_02 and create the word WORD",
                        gamePlayState.currentLanguage,
                        true,
                        gamePlayState.tileSize*0.30,
                        settingsState.demoLetters,
                        settingsState),
                    DemoBoardState(demoBoardState: settingsState.demoStates['demoBoardState4'], language: gamePlayState.currentLanguage),
                    _instructionsText(palette,
                        "The letter_04 is placed in between the letter_01 and letter_02. The letters animate and you are granted points for the letters.",
                        gamePlayState.currentLanguage,
                        true,
                        gamePlayState.tileSize*0.30,
                        settingsState.demoLetters,
                        settingsState),
                    // _instructionsHeading(palette,
                    //     "Swipe to 'Settings' to understand how points are allocated",gamePlayState.currentLanguage, gamePlayState.tileSize*0.35),
                    DemoBoardState(demoBoardState: settingsState.demoStates['demoBoardState5'], language: gamePlayState.currentLanguage),
                    _instructionsText(palette,
                        "After an animation plays, the letters from the word WORD will disappear from the board and the spaces will become available for new letters",
                        gamePlayState.currentLanguage,
                        true,
                        gamePlayState.tileSize*0.30,
                        settingsState.demoLetters,
                        settingsState),
                    DemoBoardState(demoBoardState: settingsState.demoStates['demoBoardState6'], language: gamePlayState.currentLanguage),
                    _instructionsText(palette,
                        "The spaces become available for the new letters to be placed",
                        gamePlayState.currentLanguage,
                        false,
                        gamePlayState.tileSize*0.30,
                        settingsState.demoLetters,
                        settingsState)
                  ],
                ),
              ),
            ),
          null
        );        
      },

    );
  }
}

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

  // double getTileSize(double currentScreenWidth , double sizeFactor) {
  //   double res = currentScreenWidth;
  //   if (currentScreenWidth > 500) {
  //     res = 500;
  //   }
  //   return (res / 5) * sizeFactor;
  // }  


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
                        child: Text(
                          randomLetter1,
                          style: TextStyle(
                              fontSize: (gamePlayState.tileSize*0.4), color: palette.fullTileBorderColor),
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
                        child: Text(
                          randomLetter2,
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

Widget _instructionsHeading(ColorPalette palette, String body, String language, double fontSize,SettingsState settingsState) {
  String res = "";
  res = Helpers().translateText(language, body,settingsState);
  return Container(
    margin: const EdgeInsets.all(4.0),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        res,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
            color: palette.textColor2),
      ),
    ),
  );
}

Widget _instructionsText(ColorPalette palette, String body, String language, bool dynamicValue, double fontSize, Map<dynamic,dynamic> translateDemoSequence,SettingsState settingsState) {
  String res = "";
  if (dynamicValue) {
    res = Helpers().translateDemoSequence(language, body, translateDemoSequence,settingsState);
  } else {
    res = Helpers().translateText(language, body,settingsState);
  }
  return Container(
    margin: const EdgeInsets.all(4.0),
    child: Text(
      res,
      style: TextStyle(fontSize: fontSize, color: palette.textColor2),
    ),
  );
}


Color getDemoTileBorderColor(String tileLetter,  ColorPalette palette) {
  late Color res = Colors.transparent;
  if (tileLetter == "") {
    res = palette.tileBgColor;
  }
  return res;
}

// Color getDemoTileColor(String tileLetter, ColorPalette palette, bool isActive) {

//   late Color res = Colors.transparent;
//   if (tileLetter != "") {
//     if (isActive) {
//       res = palette.screenBackgroundColor;
//     } else {
//       res = palette.tileBgColor;
//     }
//   }
//   return res;
// }
Color getDemoTileTextColor(String tileLetter, ColorPalette palette, bool isActive) {
  late Color res = palette.fullTileTextColor;
  if (isActive) {
    res = palette.tileBgColor;
  }
  return res;
}

BoxDecoration getBoxDecoration(double tileSize, ColorPalette palette, String tileLetter, bool active) {
  BoxDecoration res = Decorations().getTileDecoration(tileSize, palette, 1, 1);
  if (tileLetter == "" ) {
    res = Decorations().getEmptyTileDecoration(tileSize, palette,0,1);
  } else {
    if (active) {
      res = BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(tileSize*0.2)),
        border: Border.all(
          color: palette.tileBgColor,
          width: tileSize*0.04
        )
      );
    }
  }
  return res;
}


class DemoTileWidget extends StatelessWidget {
  final double tileSize;
  final String tileId;
  final List<Map<dynamic, dynamic>> demoBoardState;
  final String language;
  final ColorPalette palette;
  final double fontSize;
  const DemoTileWidget({
    super.key,
    required this.tileSize,
    required this.tileId,
    required this.demoBoardState,
    required this.language,
    required this.palette,
    required this.fontSize
  });

  @override
  Widget build(BuildContext context) {
    late SettingsState settingsState = Provider.of<SettingsState>(context,listen: false);
    String tileLetter = Helpers().displayDemoTileLetter(demoBoardState,tileId,language,settingsState.demoLetters);
    Map<dynamic,dynamic> tileState = Helpers().getTileState(demoBoardState, tileId);
    bool isActive = tileState["active"];
    
    // Color borderColor = getDemoTileBorderColor(tileLetter,palette);
    // Color tileBgColor = getDemoTileColor(tileLetter,palette,isActive);
    Color tileTextColor = getDemoTileTextColor(tileLetter,palette,isActive);


    return Center(
      child: Container(
        width: tileSize,
        height: tileSize,
        // decoration: BoxDecoration(
        //   border: Border.all(color:borderColor,width: 2,),
        //   color: tileBgColor,
        //   borderRadius: BorderRadius.circular(tileSize*0.2)
        // ),
        // margin: const EdgeInsets.all(2.0),
        decoration: getBoxDecoration(tileSize,palette,tileLetter,tileState["active"]),
        child: Center(
          child: Text(
            tileLetter,
            style: TextStyle(
              fontSize: fontSize,
              color: tileTextColor,
            ),
          )
        )
      ),      
    );
  }
}