import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/components/dialog_widget.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
// import 'package:scribby_flutter_v2/functions/game_logic.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
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

    return Consumer<SettingsController>(
      builder: (context, settings, child) {
        return DialogWidget(
            key,
            Helpers().translateText(gamePlayState.currentLanguage, "Settings"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    textHeading(
                      palette, 
                      Helpers().translateText(gamePlayState.currentLanguage, "Parameters"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Card(
                        color: palette.optionButtonBgColor2,
                        child: SizedBox(
                          height: (50 * settingsState.sizeFactor),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: (8.0*settingsState.sizeFactor)),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    Helpers().translateText(gamePlayState.currentLanguage, "Sound On",),
                                    
                                    style: TextStyle(
                                        fontSize: (20 * settingsState.sizeFactor), 
                                        color: palette.textColor2
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
                                            ?  Icon(Icons.volume_up, size: (22*settingsState.sizeFactor) ,)
                                            :  Icon(Icons.volume_off, size: (22*settingsState.sizeFactor) ),
                                        color: palette.textColor2
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
                      Helpers().translateText(gamePlayState.currentLanguage, "Scoring"),
                    ),
                    
                    textSubHeading(
                      palette, 
                      Helpers().translateText(gamePlayState.currentLanguage, "Letter Values"),
                      settingsState.sizeFactor
                    ),
                    textContainer(
                      palette,
                      Helpers().translateText(gamePlayState.currentLanguage,
                        "All letters have a predetermined value. When a word is found the score is tabulated according to the value of each letter in the word",
                      ),
                      settingsState.sizeFactor
                    ),
                      
                    Wrap(
                      direction: Axis.horizontal,
                      children: [
                        for (dynamic item in gamePlayState.alphabetState)
                          SizedBox(
                              width: 45,
                              height: 45,
                              // color: Colors.amber,
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: scrabbleTile(
                                    item['letter'], item['points'], 30, 0.65),
                              ))
                      ],
                    ),
                    textSubHeading(
                      palette, 
                      Helpers().translateText(gamePlayState.currentLanguage,"Multipliers - Word Lengths"),settingsState.sizeFactor),
                    textContainer(palette,
                      Helpers().translateText(gamePlayState.currentLanguage,
                        "To arrive to a total score for the turn, first, each word is multiplied by the Word Length Multiplier."),
                        settingsState.sizeFactor
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
                                    Helpers().translateText(gamePlayState.currentLanguage,"Word Length",),
                                      style: TextStyle(
                                          fontSize: (18 * settingsState.sizeFactor),
                                          color: palette.textColor2)),
                                )),
                            Center(
                                child: Text(
                              "3",
                              style: TextStyle(
                                  fontSize: (18 * settingsState.sizeFactor), color: palette.textColor2),
                            )),
                            Center(
                                child: Text(
                              "4",
                              style: TextStyle(
                                  fontSize: (18 * settingsState.sizeFactor), color: palette.textColor2),
                            )),
                            Center(
                                child: Text(
                              "5",
                              style: TextStyle(
                                  fontSize: (18 * settingsState.sizeFactor), color: palette.textColor2),
                            )),
                            Center(
                                child: Text(
                              "6",
                              style: TextStyle(
                                  fontSize: (18 * settingsState.sizeFactor), color: palette.textColor2),
                            )),
                          ]),
                          TableRow(children: <Widget>[
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  Helpers().translateText(gamePlayState.currentLanguage,"Multiplier",),
                                    style: TextStyle(
                                        fontSize: (18 * settingsState.sizeFactor),
                                        color: palette.textColor2))),
                            Center(
                                child: Text(
                              "1x",
                              style: TextStyle(
                                  fontSize: (18 * settingsState.sizeFactor), color: palette.textColor2),
                            )),
                            Center(
                                child: Text(
                              "1x",
                              style: TextStyle(
                                  fontSize: (18 * settingsState.sizeFactor), color: palette.textColor2),
                            )),
                            Center(
                                child: Text(
                              "2x",
                              style: TextStyle(
                                  fontSize: (18 * settingsState.sizeFactor), color: palette.textColor2),
                            )),
                            Center(
                                child: Text(
                              "3x",
                              style: TextStyle(
                                  fontSize: (18 * settingsState.sizeFactor), color: palette.textColor2),
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
                      Helpers().translateText(gamePlayState.currentLanguage, "Multipliers - Streaks"),settingsState.sizeFactor),
                    textContainer(
                      palette,
                      Helpers().translateText(gamePlayState.currentLanguage,
                        "The streak is defined by the number of consecutive turns where at least one word was found"),settingsState.sizeFactor),
                    const SizedBox(
                      height: 20,
                    ),
                    textSubHeading(
                      palette,
                      Helpers().translateText(gamePlayState.currentLanguage, "Multipliers - Crosswords"),settingsState.sizeFactor),
                    textContainer(
                      palette,
                      Helpers().translateText(gamePlayState.currentLanguage,
                        "If multiple words are found, at least one in a row, and one in a column - then a crossword as been found."),
                        settingsState.sizeFactor
                    ),
                    textContainer(
                      palette,
                      Helpers().translateText(gamePlayState.currentLanguage,
                        "The multiplier for crosswords will always be 2x"),
                        settingsState.sizeFactor
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    textSubHeading(
                      palette,
                      Helpers().translateText(gamePlayState.currentLanguage, "Multipliers - Word Count"),
                      settingsState.sizeFactor
                    ),
                    textContainer(
                      palette,
                      Helpers().translateText(gamePlayState.currentLanguage,
                        "The final score is multiplied by the number of words that were found"),
                        settingsState.sizeFactor
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

Widget textHeading(ColorPalette palette, String text) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Text(
      text,
      style: TextStyle(fontSize: 22, color: palette.textColor2),
    ),
  );
}

Widget textSubHeading(ColorPalette palette, String text, double sizeFactor) {
  return Container(
    margin: const EdgeInsets.all(4.0),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
            fontSize: (20 * sizeFactor),
            fontWeight: FontWeight.bold,
            color: palette.textColor2),
      ),
    ),
  );
}

Widget textContainer(ColorPalette palette, String text, double sizeFactor) {
  return Container(
    margin: const EdgeInsets.all(4.0),
    child: Text(
      text,
      style: TextStyle(fontSize: (18 * sizeFactor), color: palette.textColor3),
    ),
  );
}
