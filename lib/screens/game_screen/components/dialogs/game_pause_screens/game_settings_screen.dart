import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/components/dialog_widget.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/play_area/decorations/decorations.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';
import 'package:scribby_flutter_v2/styles/styles.dart';
// import 'package:scribby_flutter_v2/utils/states.dart';

class GameSettings extends StatelessWidget {
  const GameSettings({super.key});

  @override
  Widget build(BuildContext context) {
    // final settings = context.watch<SettingsController>();

    late ColorPalette palette =
        Provider.of<ColorPalette>(context, listen: false);

    late GamePlayState gamePlayState = Provider.of<GamePlayState>(context, listen: false);
    late SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);
    // late SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);

    return Consumer<SettingsController>(
      builder: (context, settings, child) {
        return DialogWidget(
            key,
            Helpers().translateText(gamePlayState.currentLanguage, "Settings", settingsState),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    textHeading(
                      palette, 
                      Helpers().translateText(gamePlayState.currentLanguage, "Parameters",settingsState),
                      gamePlayState.tileSize*0.4
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(gamePlayState.tileSize*0.2),
                        ),                        
                        
                        color: palette.optionButtonBgColor2,
                        child: Container(
                          decoration: Decorations().getTileDecoration(gamePlayState.tileSize, palette, 1, 1),
                          height: (gamePlayState.tileSize * 1),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: (gamePlayState.tileSize*0.2)),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    Helpers().translateText(gamePlayState.currentLanguage, "Sound On",settingsState),
                                    
                                    style: TextStyle(
                                        fontSize: (gamePlayState.tileSize*0.35), 
                                        color: palette.fullTileTextColor
                                      ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: ValueListenableBuilder<bool>(
                                    valueListenable: settings.soundsOn,
                                    builder: (context, soundsOn, child) => IconButton(
                                        onPressed: () {
                                            settings.toggleSoundsOn();
                                            late Map<String,dynamic> userMap = settings.userData.value as Map<String,dynamic>;
                                            FirestoreMethods().updateParameters( userMap['uid'] ,'soundOn', !soundsOn);
                                        },
                                        icon: soundsOn
                                            ?  Icon(Icons.volume_up, size: (gamePlayState.tileSize*0.4) ,)
                                            :  Icon(Icons.volume_off, size: (gamePlayState.tileSize*0.4) ),
                                        color: palette.fullTileTextColor
                                        // color: soundsOn
                                        // ? const Color.fromRGBO(44, 222, 253, 1)
                                        // : const Color.fromRGBO(49, 49, 49, 1),
                                        ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    textHeading(
                      palette,
                      Helpers().translateText(gamePlayState.currentLanguage, "Scoring",settingsState),
                      gamePlayState.tileSize*0.4
                    ),
                    
                    textSubHeading(
                      palette, 
                      Helpers().translateText(gamePlayState.currentLanguage, "Letter Values",settingsState),
                      gamePlayState.tileSize*0.35
                    ),
                    textContainer(
                      palette,
                      Helpers().translateText(gamePlayState.currentLanguage,
                        "All letters have a predetermined value. When a word is found the score is tabulated according to the value of each letter in the word",
                        settingsState
                      ),
                      gamePlayState.tileSize*0.30
                    ),
                    const SizedBox(
                      height: 15,
                    ),                      
                    Wrap(
                      direction: Axis.horizontal,
                      children: [
                        for (dynamic item in gamePlayState.alphabetState)
                          SizedBox(
                              width: gamePlayState.tileSize*0.8,
                              height: gamePlayState.tileSize*0.8,
                              // color: Colors.amber,
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: scrabbleTile(
                                    item['letter'], item['points'], 30, 0.65),
                              ))
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),                    
                    textSubHeading(
                      palette, 
                      Helpers().translateText(gamePlayState.currentLanguage,"Multipliers - Word Lengths",settingsState),gamePlayState.tileSize*0.35),
                    textContainer(palette,
                      Helpers().translateText(gamePlayState.currentLanguage,
                        "To arrive to a total score for the turn, first, each word is multiplied by the Word Length Multiplier.",settingsState),
                        gamePlayState.tileSize*0.30
                      ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Table(
                        // border: TableBorder.all(),
                        columnWidths: const <int, TableColumnWidth>{
                          0: FlexColumnWidth(3),
                          1: FlexColumnWidth(),
                          2: FlexColumnWidth(),
                          3: FlexColumnWidth(),
                          4: FlexColumnWidth(),
                        },
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: <TableRow>[
                          TableRow(children: <Widget>[
                            Align(
                                alignment: Alignment.centerLeft,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    Helpers().translateText(gamePlayState.currentLanguage,"Word Length",settingsState),
                                      style: TextStyle(
                                          fontSize: (gamePlayState.tileSize*0.35),
                                          color: palette.textColor2)),
                                )),
                            Center(
                                child: Text(
                              "3",
                              style: TextStyle(
                                  fontSize: (gamePlayState.tileSize*0.30), color: palette.textColor2),
                            )),
                            Center(
                                child: Text(
                              "4",
                              style: TextStyle(
                                  fontSize: (gamePlayState.tileSize*0.30), color: palette.textColor2),
                            )),
                            Center(
                                child: Text(
                              "5",
                              style: TextStyle(
                                  fontSize: (gamePlayState.tileSize*0.30), color: palette.textColor2),
                            )),
                            Center(
                                child: Text(
                              "6",
                              style: TextStyle(
                                  fontSize: (gamePlayState.tileSize*0.30), color: palette.textColor2),
                            )),
                          ]),
                          TableRow(children: <Widget>[
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  Helpers().translateText(gamePlayState.currentLanguage,"Multiplier",settingsState),
                                    style: TextStyle(
                                        fontSize: (gamePlayState.tileSize*0.30),
                                        color: palette.textColor2))),
                            Center(
                                child: Text(
                              "1x",
                              style: TextStyle(
                                  fontSize: (gamePlayState.tileSize*0.30), color: palette.textColor2),
                            )),
                            Center(
                                child: Text(
                              "1x",
                              style: TextStyle(
                                  fontSize: (gamePlayState.tileSize*0.30), color: palette.textColor2),
                            )),
                            Center(
                                child: Text(
                              "2x",
                              style: TextStyle(
                                  fontSize: (gamePlayState.tileSize*0.30), color: palette.textColor2),
                            )),
                            Center(
                                child: Text(
                              "3x",
                              style: TextStyle(
                                  fontSize: (gamePlayState.tileSize*0.30), color: palette.textColor2),
                            )),
                          ]),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    textSubHeading(
                      palette,
                      Helpers().translateText(gamePlayState.currentLanguage, "Multipliers - Streaks",settingsState),gamePlayState.tileSize*0.35),
                    textContainer(
                      palette,
                      Helpers().translateText(gamePlayState.currentLanguage,
                        "The streak is defined by the number of consecutive turns where at least one word was found",settingsState),gamePlayState.tileSize*0.30),
                    const SizedBox(
                      height: 20,
                    ),
                    textSubHeading(
                      palette,
                      Helpers().translateText(gamePlayState.currentLanguage, "Multipliers - Crosswords",settingsState),gamePlayState.tileSize*0.35),
                    textContainer(
                      palette,
                      Helpers().translateText(gamePlayState.currentLanguage,
                        "If multiple words are found, at least one in a row, and one in a column - then a crossword as been found.",settingsState),
                        gamePlayState.tileSize*0.30
                    ),
                    textContainer(
                      palette,
                      Helpers().translateText(gamePlayState.currentLanguage,
                        "The multiplier for crosswords will always be 2x",settingsState),
                        gamePlayState.tileSize*0.30
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    textSubHeading(
                      palette,
                      Helpers().translateText(gamePlayState.currentLanguage, "Multipliers - Word Count",settingsState),
                      gamePlayState.tileSize*0.35
                    ),
                    textContainer(
                      palette,
                      Helpers().translateText(gamePlayState.currentLanguage,
                        "The final score is multiplied by the number of words that were found",settingsState),
                        gamePlayState.tileSize*0.30
                    ),
                  ],
                ),
              ),
            ),
            null);
      },
    );
  }
}

Widget textHeading(ColorPalette palette, String text, double fontSize) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Text(
      text,
      style: TextStyle(fontSize: fontSize, color: palette.textColor2),
    ),
  );
}

Widget textSubHeading(ColorPalette palette, String text, double fontSize) {
  return Container(
    margin: const EdgeInsets.all(4.0),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: palette.textColor2),
      ),
    ),
  );
}

Widget textContainer(ColorPalette palette, String text, double fontSize) {
  return Container(
    margin: const EdgeInsets.all(4.0),
    child: Text(
      text,
      style: TextStyle(fontSize: fontSize, color: palette.textColor3),
    ),
  );
}
