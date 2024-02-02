// import 'package:expansion_tile_card/expansion_tile_card.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/components/dialog_widget.dart';
import 'package:scribby_flutter_v2/functions/game_logic.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
// import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
// import 'package:scribby_flutter_v2/screens/game_screen/dialogs/game_pause_screens/game_settings_screen.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';
// import 'package:scribby_flutter_v2/providers/game_state.dart';
// import 'package:scribby_flutter_v2/styles/buttons.dart';

class GameSummaryScreen extends StatelessWidget {
  const GameSummaryScreen({super.key});

  @override
  Key? get key => null;

  @override
  Widget build(BuildContext context) {
    return Consumer<GamePlayState>(builder: (context, gamePlayState, child) {
      return DialogWidget(
          key, 
          Helpers().translateText(gamePlayState.currentLanguage, "Game Summary"), 
          GameSummaryContent(gamePlayState), 
          null
        );
    });
  }
}

class GameSummaryContent extends StatefulWidget {
  final GamePlayState gamePlayState;
  // final GameState gameState;
  const GameSummaryContent(this.gamePlayState,
      // this.gameState,
      {super.key});

  @override
  State<GameSummaryContent> createState() => _GameSummaryContentState();
}

class _GameSummaryContentState extends State<GameSummaryContent> {
  late bool displayWords;

  @override
  void initState() {
    super.initState();
    displayWords = false;
  }

  void toggleDisplay() {
    setState(() {
      displayWords = !displayWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    late ColorPalette palette =
        Provider.of<ColorPalette>(context, listen: true);

    late SettingsState settings =
        Provider.of<SettingsState>(context, listen: false);
    return Consumer<GamePlayState>(
      builder: (context, gamePlayState, child) {
        return displayWords
            ? ShowWordsView(
                palette: palette,
                // gamePlayState: gamePlayState,
                toggleDisplay: toggleDisplay,
              )
            : GameSummaryView(
                palette: palette,
                gamePlayState: gamePlayState,
                curentHighscore: Helpers().getCurrentHighScore(settings),
                toggleDisplay: toggleDisplay);
      },
    );
  }
}

class ShowWordsView extends StatefulWidget {
  final ColorPalette palette;
  // final GamePlayState gamePlayState;
  final VoidCallback toggleDisplay;

  const ShowWordsView(
      {super.key,
      required this.palette,
      // required this.gamePlayState,
      required this.toggleDisplay});

  @override
  State<ShowWordsView> createState() => _ShowWordsViewState();
}

class _ShowWordsViewState extends State<ShowWordsView> {
  // late bool displayWords;


  

  @override
  Widget build(BuildContext context) {
    return Consumer<GamePlayState>(
      builder:(context, gamePlayState, child) {
        late List<Map<String,dynamic>> summary = GameLogic().getPointsSummary(gamePlayState);
        return SingleChildScrollView(
          child: Column(
            children: [
              // const SizedBox(
              //   height: 20,
              // ),
              gamePlayState.summaryData.isEmpty
                  ? Text(
                    Helpers().translateText(gamePlayState.currentLanguage,"No words found yet..."),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity,

                        child: Table(
                          columnWidths: const <int, TableColumnWidth>{
                            0: FlexColumnWidth(1),
                            1: FlexColumnWidth(7),
                            2: FlexColumnWidth(2),
                          },
                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                          children: <TableRow>[
                            TableRow(
                              children: [
                                Center(
                                  child: Text(
                                    "#",
                                    style: TextStyle(color: widget.palette.textColor2, fontSize: 20),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    Helpers().translateText(gamePlayState.currentLanguage,"Word"),
                                    
                                    style: TextStyle(color: widget.palette.textColor2, fontSize: 18),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    Helpers().translateText(gamePlayState.currentLanguage,"Points"),
                                    style: TextStyle(color: widget.palette.textColor2, fontSize: 18),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ]
                            ),
                            for (int i=0; i<summary.length; i++)
                            Helpers().scoreSummaryTableRow(i, widget.palette,summary[i], context),
                          ]
                        ),                    
                      ),
                    ),
              InkWell(
                onTap: widget.toggleDisplay,
                child: Row(
                  children: [
                    const Expanded(flex: 1, child: SizedBox()),
                    Icon(Icons.arrow_upward,
                        size: 20, color: widget.palette.textColor2),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      Helpers().translateText(gamePlayState.currentLanguage, "Hide"),
                      style: TextStyle(
                        fontSize: 24,
                        color: widget.palette.textColor2,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}





class GameSummaryView extends StatefulWidget {
  final ColorPalette palette;
  final GamePlayState gamePlayState;
  final int curentHighscore;
  final VoidCallback toggleDisplay;
  const GameSummaryView(
      {super.key,
      required this.palette,
      required this.gamePlayState,
      required this.curentHighscore,
      required this.toggleDisplay});

  @override
  State<GameSummaryView> createState() => _GameSummaryViewState();
}

class _GameSummaryViewState extends State<GameSummaryView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(children: [
        const Expanded(child: SizedBox()),
        Table(
          columnWidths: const <int, TableColumnWidth>{
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(5),
            2: FlexColumnWidth(2),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: <TableRow>[
            tableRowItem(
              Helpers().translateText(widget.gamePlayState.currentLanguage, "Score",),
                // widget.gamePlayState.currentLevel.toString(),
                (widget.gamePlayState.summaryData['points'] ?? 0).toString(),
                Icon(Icons.emoji_events,
                    size: 22, color: widget.palette.textColor2),
                widget.palette),
            tableRowItem(
              Helpers().translateText(widget.gamePlayState.currentLanguage, "Duration",),
                GameLogic().formatTime(widget.gamePlayState.duration.inSeconds),
                Icon(Icons.timer, size: 22, color: widget.palette.textColor2),
                widget.palette),
            tableRowItem(
              Helpers().translateText(widget.gamePlayState.currentLanguage, "Level",),
                widget.gamePlayState.currentLevel.toString(),
                Icon(Icons.bar_chart,
                    size: 22, color: widget.palette.textColor2),
                widget.palette),
          ],
        ),
        const Expanded(child: SizedBox()),
        Text(
          Helpers().translateText(widget.gamePlayState.currentLanguage, "Summary",),
          style: TextStyle(color: widget.palette.textColor2, fontSize: 24),
        ),
        Table(
          columnWidths: const <int, TableColumnWidth>{
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(5),
            2: FlexColumnWidth(2),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: <TableRow>[
            tableRowItem(
                Helpers().translateText(widget.gamePlayState.currentLanguage, "Longest Streak",),
                (widget.gamePlayState.summaryData['longestStreak'] ?? 0)
                    .toString(),
                Icon(Icons.bolt, size: 22, color: widget.palette.textColor2),
                widget.palette),
            tableRowItem(
                Helpers().translateText(widget.gamePlayState.currentLanguage, "Cross Words",),
                (widget.gamePlayState.summaryData['crosswords'] ?? 0)
                    .toString(),
                Icon(Icons.close, size: 22, color: widget.palette.textColor2),
                widget.palette),
            tableRowItem(
                Helpers().translateText(widget.gamePlayState.currentLanguage, "Most Points",),
                (widget.gamePlayState.summaryData['mostPoints'] ?? 0)
                    .toString(),
                Icon(Icons.star, size: 22, color: widget.palette.textColor2),
                widget.palette),
            tableRowItem(
                Helpers().translateText(widget.gamePlayState.currentLanguage, "Most Words",),
                (widget.gamePlayState.summaryData['mostWords'] ?? 0).toString(),
                Icon(Icons.my_library_books,
                    size: 22, color: widget.palette.textColor2),
                widget.palette),
          ],
        ),
        const Expanded(child: SizedBox()),
        widget.gamePlayState.summaryData.isEmpty
            ? const SizedBox()
            : InkWell(
                onTap: widget.toggleDisplay,
                child: Text(
                  Helpers().translateText(widget.gamePlayState.currentLanguage, "View points summary"),
                    style: TextStyle(
                        fontSize: 20,
                        color: widget.palette.textColor3,
                        fontStyle: FontStyle.italic
                    ),
                ),
                // child: Text.rich(
                //   TextSpan(
                //     text: 'View all ',
                //     style: TextStyle(
                //         fontSize: 20,
                //         color: widget.palette.textColor3,
                //         fontStyle: FontStyle.italic),
                //     children: <TextSpan>[
                //       TextSpan(
                //           text: widget
                //               .gamePlayState.summaryData['uniqueWords'].length
                //               .toString(),
                //           style: TextStyle(
                //               decoration: TextDecoration.underline,
                //               decorationColor: widget.palette.textColor3,
                //               decorationThickness: 1.0)),
                //       const TextSpan(text: ' words'),
                //     ],
                //   ),
                // ),
              ),
        const Expanded(child: SizedBox()),
      ]),
    );
  }
}

TableRow tableRowItem( String textBody, String data, Icon icon, ColorPalette palette) {
  return TableRow(children: [
    Center(
      child: icon,
    ),
    Text(
      textBody,
      style: TextStyle(color: palette.textColor2, fontSize: 20),
    ),
    Align(
      alignment: Alignment.centerRight,
      child: Text(
        data,
        style: TextStyle(color: palette.textColor2, fontSize: 20),
        textAlign: TextAlign.right,
      ),
    ),
  ]);
}
