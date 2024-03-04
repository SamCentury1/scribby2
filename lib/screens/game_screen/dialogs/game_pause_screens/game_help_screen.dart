import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/components/dialog_widget.dart';
import 'package:scribby_flutter_v2/functions/game_logic.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';
import 'package:scribby_flutter_v2/utils/states.dart';

class GameHelpScreen extends StatefulWidget {
  const GameHelpScreen({super.key});

  @override
  State<GameHelpScreen> createState() => _GameHelpScreenState();
}

class _GameHelpScreenState extends State<GameHelpScreen> {
  Key? get key => null;

  late ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
  late SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);
  // late SettingsController settings = Provider.of<SettingsController>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    return Consumer<GamePlayState>(
      builder: (context, gamePlayState, child) {
        return DialogWidget(
            key,
            Helpers().translateText(gamePlayState.currentLanguage, "Instructions"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _instructionsHeading(palette, "Objective",gamePlayState.currentLanguage, settingsState.sizeFactor),
                    _instructionsText(palette,
                        "The objective of the game is to create words with the randomly generated letters.",
                        gamePlayState.currentLanguage,
                        false,
                        settingsState.sizeFactor),
                    _instructionsHeading(palette, "Demo",gamePlayState.currentLanguage, settingsState.sizeFactor),
                    _instructionsText(palette,
                        "The two letters at the top are randomly generated. The center letter letter_01 gets placed next",
                        gamePlayState.currentLanguage,
                        true,
                        settingsState.sizeFactor),
                    DemoBoardState(demoBoardState: demoBoardState_1, language: gamePlayState.currentLanguage),
                    _instructionsText(palette,
                        "When the letter letter_01 is placed inside the board, the letter to the right letter_02 will become the center letter and a new random letter will be generated and take its spot",
                        gamePlayState.currentLanguage,
                        true,
                        settingsState.sizeFactor),
                    _instructionsText(palette,
                        "A new letter letter_03 is randomly generated to be place after the next letter letter_02 is placed.",
                        gamePlayState.currentLanguage,
                        true,
                        settingsState.sizeFactor),
                    DemoBoardState(demoBoardState: demoBoardState_2, language: gamePlayState.currentLanguage),
                    _instructionsText(palette,
                        "Place your letters strategically to create words. In this case, we see the letter_04 coming after the letter_03",
                        gamePlayState.currentLanguage,
                        true,
                        settingsState.sizeFactor),
                    DemoBoardState(demoBoardState: demoBoardState_3, language: gamePlayState.currentLanguage),
                    _instructionsText(palette,
                        "The letter_03 is placed below the letter_02 so the letter_04 can be placed between the letter_01 and the letter_02 and create the word WORD",
                        gamePlayState.currentLanguage,
                        true,
                        settingsState.sizeFactor),
                    DemoBoardState(demoBoardState: demoBoardState_4, language: gamePlayState.currentLanguage),
                    _instructionsText(palette,
                        "The letter_04 is placed in between the letter_01 and letter_02. The letters animate and you are granted points for the letters.",
                        gamePlayState.currentLanguage,
                        true,
                        settingsState.sizeFactor),
                    _instructionsHeading(palette,
                        "Swipe to 'Settings' to understand how points are allocated",gamePlayState.currentLanguage, settingsState.sizeFactor),
                    DemoBoardState(demoBoardState: demoBoardState_5, language: gamePlayState.currentLanguage),
                    _instructionsText(palette,
                        "After an animation plays, the letters from the word WORD will disappear from the board and the spaces will become available for new letters",
                        gamePlayState.currentLanguage,
                        true,
                        settingsState.sizeFactor),
                    DemoBoardState(demoBoardState: demoBoardState_6, language: gamePlayState.currentLanguage),
                    _instructionsText(palette,
                        "The spaces become available for the new letters to be placed",
                        gamePlayState.currentLanguage,
                        false,
                        settingsState.sizeFactor)
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
  final List<Map<String, dynamic>> demoBoardState;
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


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          SizedBox(
            // height: 70,
            // width: 200,
            width: MediaQuery.of(context).size.width*0.6,
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
                      width: MediaQuery.of(context).size.width*0.18,
                      height: MediaQuery.of(context).size.width*0.18,
                      // height: 70,
                      // width: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: palette.tileBgColor,
                      ),
                      child: Center(
                        child: Text(
                          GameLogic()
                              .displayDemoTileLetter(widget.demoBoardState, "0_0", widget.language),
                          style: TextStyle(
                              fontSize: (42 * settingsState.sizeFactor), color: palette.tileTextColor),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width*0.13,
                      height: MediaQuery.of(context).size.width*0.13,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: palette.tileBgColor,
                      ),
                      child: Center(
                        child: Text(
                          GameLogic()
                              .displayDemoTileLetter(widget.demoBoardState, "0_1", widget.language),
                          style: TextStyle(
                              fontSize: (26 * settingsState.sizeFactor), color: palette.tileTextColor),
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
          Container(
            // width: 200,
            // height: 170,
            margin: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            child: Column(
              children: [
                for (var i = 0; i < 3; i++)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var j = 0; j < 3; j++)
                        Center(
                          child: Container(
                              width: MediaQuery.of(context).size.width*0.13,
                              height: MediaQuery.of(context).size.width*0.13,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: GameLogic().displayDemoTileLetter(
                                        widget.demoBoardState, 
                                        "${(i + 1).toString()}_${(j + 1).toString()}", 
                                        widget.language
                                      ) == ""
                                        ? palette.tileBgColor
                                        : const Color.fromRGBO(0, 0, 0, 0),
                                    width: 2,
                                  ),
                                  color: GameLogic().displayDemoTileLetter(
                                              widget.demoBoardState,
                                              "${(i + 1).toString()}_${(j + 1).toString()}",
                                              widget.language) ==
                                          ""
                                      ? const Color.fromRGBO(0, 0, 0, 0)
                                      : GameLogic().getTileState(
                                                  widget.demoBoardState,
                                                  "${(i + 1).toString()}_${(j + 1).toString()}")[
                                              "active"]
                                          ? palette.screenBackgroundColor
                                          : palette.tileBgColor,
                                  borderRadius: BorderRadius.circular(10.0)),
                              margin: const EdgeInsets.all(2.0),
                              child: Center(
                                  child: Text(
                                GameLogic().displayDemoTileLetter(
                                    widget.demoBoardState,
                                    "${(i + 1).toString()}_${(j + 1).toString()}",
                                    widget.language),
                                style: TextStyle(
                                  fontSize: (22 * settingsState.sizeFactor),
                                  color: GameLogic().getTileState(
                                              widget.demoBoardState,
                                              "${(i + 1).toString()}_${(j + 1).toString()}")[
                                          "active"]
                                      ? palette.tileBgColor
                                      : palette.tileTextColor,
                                ),
                              ))),
                        )
                    ],
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _instructionsHeading(ColorPalette palette, String body, String language, double sizeFactor) {
  String res = "";
  res = Helpers().translateText(language, body);
  return Container(
    margin: const EdgeInsets.all(4.0),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        res,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: (20 * sizeFactor),
            color: palette.textColor2),
      ),
    ),
  );
}

Widget _instructionsText(ColorPalette palette, String body, String language, bool dynamicValue, double sizeFactor) {
  String res = "";
  if (dynamicValue) {
    res = Helpers().translateDemoSequence(language, body);
  } else {
    res = Helpers().translateText(language, body);
  }
  return Container(
    margin: const EdgeInsets.all(4.0),
    child: Text(
      res,
      style: TextStyle(fontSize: (18*sizeFactor), color: palette.textColor2),
    ),
  );
}
