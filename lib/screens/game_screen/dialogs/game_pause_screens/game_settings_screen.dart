import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/components/dialog_widget.dart';
// import 'package:scribby_flutter_v2/functions/game_logic.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
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

    late GamePlayState gamePlaySettings =
        Provider.of<GamePlayState>(context, listen: false);
    return Consumer<SettingsController>(
      builder: (context, settings, child) {
        return DialogWidget(
            key,
            "Settings",
            SingleChildScrollView(
              child: Column(
                children: [
                  // Align(
                  //   alignment: Alignment.centerLeft,
                  //   child: Text(
                  //     "Parameters",
                  //     style: TextStyle(fontSize: 22, color: palette.textColor2),
                  //   ),
                  // ),
                  textHeading(palette, "Parameters"),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Card(
                      color: palette.optionButtonBgColor2,
                      child: SizedBox(
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "Sound On",
                                  style: TextStyle(
                                      fontSize: 22, color: palette.textColor3),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: ValueListenableBuilder<bool>(
                                  valueListenable: settings.soundsOn,
                                  builder: (context, soundsOn, child) => IconButton(
                                      onPressed: () =>
                                          settings.toggleSoundsOn(),
                                      icon: soundsOn
                                          ? const Icon(Icons.volume_up)
                                          : const Icon(Icons.volume_off),
                                      color: palette.tileBgColor
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
                  textHeading(palette, "Scoring"),
                  // const Align(
                  //   alignment: Alignment.centerLeft,
                  //   child: Text(
                  //     "Scoring",
                  //     style: TextStyle(fontSize: 22),
                  //   ),
                  // ),
                  textSubHeading(palette, "Letter Values"),
                  // Container(
                  //   margin: const EdgeInsets.all(4.0),
                  //   child: const Align(
                  //     alignment: Alignment.centerLeft,
                  //     child: Text(
                  //       "Letter Values",
                  //       style: TextStyle(fontWeight: FontWeight.bold),
                  //     ),
                  //   ),
                  // ),
                  textContainer(palette,
                      "All letters have a predetermined value. When a word is found the score is tabulated according to the value of each letter in the word"),
                  // Container(
                  //   margin: const EdgeInsets.all(4.0),
                  //   child: const Text(
                  //       "All letters have a predetermined value. When a word is found the score is tabulated according to the value of each letter in the word"),
                  // ),
                  textContainer(palette,
                      "All letters have a predetermined value. When a word is found the score is tabulated according to the value of each letter in the word"),
                  // Container(
                  //   margin: const EdgeInsets.all(4.0),
                  //   child: const Text(
                  //       "All letters have a predetermined value. When a word is found the score is tabulated according to the value of each letter in the word"),
                  // ),

                  // LetterValuesTable(letters: widget.letters),
                  // const LetterValuesTable(),

                  Wrap(
                    direction: Axis.horizontal,
                    children: [
                      for (dynamic item in gamePlaySettings.alphabetState)
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
                  textSubHeading(palette, "Multipliers - Word Lengths"),
                  // Container(
                  //   margin: const EdgeInsets.all(4.0),
                  //   child: const Align(
                  //     alignment: Alignment.centerLeft,
                  //     child: Text(
                  //       "Multipliers - Word Lengths",
                  //       style: TextStyle(fontWeight: FontWeight.bold),
                  //     ),
                  //   ),
                  // ),
                  textContainer(palette,
                      "To arrive to a total score for the turn, first, each word is multiplied by the Word Length Multiplier."),
                  // Container(
                  //   margin: const EdgeInsets.all(4.0),
                  //   child: const Text(
                  //       "To arrive to a total score for the turn, first, each word is multiplied by the Word Length Multiplier."),
                  // ),

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
                              child: Text("Word Length",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: palette.textColor2))),
                          Center(
                              child: Text(
                            "3",
                            style: TextStyle(
                                fontSize: 18, color: palette.textColor2),
                          )),
                          Center(
                              child: Text(
                            "4",
                            style: TextStyle(
                                fontSize: 18, color: palette.textColor2),
                          )),
                          Center(
                              child: Text(
                            "5",
                            style: TextStyle(
                                fontSize: 18, color: palette.textColor2),
                          )),
                          Center(
                              child: Text(
                            "6",
                            style: TextStyle(
                                fontSize: 18, color: palette.textColor2),
                          )),
                        ]),
                        TableRow(children: <Widget>[
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Multiplier",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: palette.textColor2))),
                          Center(
                              child: Text(
                            "1x",
                            style: TextStyle(
                                fontSize: 18, color: palette.textColor2),
                          )),
                          Center(
                              child: Text(
                            "1x",
                            style: TextStyle(
                                fontSize: 18, color: palette.textColor2),
                          )),
                          Center(
                              child: Text(
                            "2x",
                            style: TextStyle(
                                fontSize: 18, color: palette.textColor2),
                          )),
                          Center(
                              child: Text(
                            "3x",
                            style: TextStyle(
                                fontSize: 18, color: palette.textColor2),
                          )),
                        ]),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  textSubHeading(palette, "Multipliers - Streaks"),
                  // Container(
                  //   margin: const EdgeInsets.all(4.0),
                  //   child: const Align(
                  //     alignment: Alignment.centerLeft,
                  //     child: Text(
                  //       "Multipliers - Streaks",
                  //       style: TextStyle(fontWeight: FontWeight.bold),
                  //     ),
                  //   ),
                  // ),
                  textContainer(palette,
                      "The streak is defined by the number of consecutive turns where at least one word was found"),
                  // Container(
                  //   margin: const EdgeInsets.all(4.0),
                  //   child: const Text(
                  //       "The streak is defined by the number of consecutive turns where at least one word was found"),
                  // ),

                  const SizedBox(
                    height: 20,
                  ),
                  textSubHeading(palette, "Multipliers - Crosswords"),
                  // Container(
                  //   margin: const EdgeInsets.all(4.0),
                  //   child: const Align(
                  //     alignment: Alignment.centerLeft,
                  //     child: Text(
                  //       "Multipliers - Crosswords",
                  //       style: TextStyle(fontWeight: FontWeight.bold),
                  //     ),
                  //   ),
                  // ),
                  textContainer(palette,
                      "If multiple words are found, at least one in a row, and one in a column - then a crossword as been found. "),
                  // Container(
                  //   margin: const EdgeInsets.all(4.0),
                  //   child: const Text(
                  //       "If multiple words are found, at least one in a row, and one in a column - then a crossword as been found. "),
                  // ),
                  textContainer(palette,
                      "The multiplier for crosswords will always be 2x"),
                  // Container(
                  //   margin: const EdgeInsets.all(4.0),
                  //   child: const Text(
                  //       "The multiplier for crosswords will always be 2x"),
                  // ),

                  const SizedBox(
                    height: 20,
                  ),

                  textSubHeading(palette, "Multipliers - Word Count"),
                  // Container(
                  //   margin: const EdgeInsets.all(4.0),
                  //   child: const Align(
                  //     alignment: Alignment.centerLeft,
                  //     child: Text(
                  //       "Multipliers - Word Count",
                  //       style: TextStyle(fontWeight: FontWeight.bold),
                  //     ),
                  //   ),
                  // ),
                  textContainer(palette,
                      "The final score is multiplied by the number of words that were found"),
                  // Container(
                  //   margin: const EdgeInsets.all(4.0),
                  //   child: const Text(
                  //       "The final score is multiplied by the number of words that were found"),
                  // ),
                ],
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

Widget textSubHeading(ColorPalette palette, String text) {
  return Container(
    margin: const EdgeInsets.all(4.0),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: palette.textColor2),
      ),
    ),
  );
}

Widget textContainer(ColorPalette palette, String text) {
  return Container(
    margin: const EdgeInsets.all(4.0),
    child: Text(
      text,
      style: TextStyle(fontSize: 18, color: palette.textColor3),
    ),
  );
}
