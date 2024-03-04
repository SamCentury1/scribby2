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
    late ColorPalette palette = Provider.of<ColorPalette>(context, listen: true);
    late SettingsState settings = Provider.of<SettingsState>(context, listen: false);
    return Consumer<GamePlayState>(
      builder: (context, gamePlayState, child) {
        return displayWords
            ? ShowWordsView(
                palette: palette,
                // gamePlayState: gamePlayState,
                toggleDisplay: toggleDisplay,
                settingsState: settings,
              )
            : GameSummaryView(
                palette: palette,
                gamePlayState: gamePlayState,
                curentHighscore: Helpers().getCurrentHighScore(settings),
                settingsState: settings,
                toggleDisplay: toggleDisplay);
      },
    );
  }
}

class ShowWordsView extends StatefulWidget {
  final ColorPalette palette;
  final VoidCallback toggleDisplay;
  final SettingsState settingsState;
  const ShowWordsView({
    super.key,
    required this.palette,
    required this.toggleDisplay,
    required this.settingsState,
  });
  @override
  State<ShowWordsView> createState() => _ShowWordsViewState();
}

class _ShowWordsViewState extends State<ShowWordsView> {


  List<Map<String,dynamic>> summaryDataRefined(GamePlayState gamePlayState) {

    int count = 1;

    late List<Map<String,dynamic>> res  = [];
    for (int i=0; i<gamePlayState.gameSummaryLog.length; i++) {
      Map<String,dynamic> item = gamePlayState.gameSummaryLog[i];
      if (item['points'] > 0) {

        for (Map<String,dynamic> word in item['words']) {
          int totalScore = word['points'] * item['crossword'] * item['streak'] * item['count'];
          word['totalScore'] = totalScore;
          word['index'] = count;
          count++;
        }

        item['index'] = i;
        res.add(item);
      }
    }

    return res;
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<GamePlayState>(
      builder:(context, gamePlayState, child) {

        late List<Map<String,dynamic>> data = GameLogic().getPointsSummary(gamePlayState);

        // late List<Map<String,dynamic>> summary = GameLogic().getPointsSummary(gamePlayState);
        return SingleChildScrollView(
          child: Column(
            children: [

              data.isEmpty
                  ? Text(
                    Helpers().translateText(gamePlayState.currentLanguage,"No words found yet..."),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: SizedBox(
                        width: double.infinity,

                        child: Table(
                          columnWidths: const <int, TableColumnWidth>{
                            0: FlexColumnWidth(1),
                            1: FlexColumnWidth(7),
                            2: FlexColumnWidth(2),
                          },
                          border: TableBorder(horizontalInside: BorderSide(width: 0.5, color: widget.palette.textColor2, style: BorderStyle.solid)),                          
                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                          children: <TableRow>[
                            TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0 * widget.settingsState.sizeFactor),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "#",
                                      style: TextStyle(
                                        color: widget.palette.textColor2, 
                                        fontSize: (20 * widget.settingsState.sizeFactor),
                                      )
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    Helpers().translateText(gamePlayState.currentLanguage,"Word"),
                                    
                                    style: TextStyle(
                                      color: widget.palette.textColor2, 
                                      fontSize: (18 * widget.settingsState.sizeFactor)
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 8.0 * widget.settingsState.sizeFactor),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      Helpers().translateText(gamePlayState.currentLanguage,"Points"),
                                      style: TextStyle(
                                        color: widget.palette.textColor2, 
                                        fontSize: (18 * widget.settingsState.sizeFactor)
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ),
                              ]
                            ),
                            for (int i=0; i<data.length; i++)
                            Helpers().scoreSummaryTableRow2(i, widget.palette,data[i], context, gamePlayState.currentLanguage, widget.settingsState.sizeFactor),
                            // Helpers().scoreSummaryTableRow(i, widget.palette,summary[i], context, gamePlayState.currentLanguage, widget.settingsState.sizeFactor),
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
                        size: 20 * widget.settingsState.sizeFactor, 
                        color: widget.palette.textColor2),
                    SizedBox(
                      width: 10 * widget.settingsState.sizeFactor,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0 * widget.settingsState.sizeFactor),
                      child: Text(
                        Helpers().translateText(gamePlayState.currentLanguage, "Hide"),
                        style: TextStyle(
                          fontSize: (24 * widget.settingsState.sizeFactor),
                          color: widget.palette.textColor2,
                        ),
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
  final SettingsState settingsState;
  final VoidCallback toggleDisplay;
  const GameSummaryView(
      {super.key,
      required this.palette,
      required this.gamePlayState,
      required this.curentHighscore,
      required this.settingsState,
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
                    size: (22 * widget.settingsState.sizeFactor), color: widget.palette.textColor2),
                widget.palette,
                widget.settingsState.sizeFactor
                ),
            tableRowItem(
              Helpers().translateText(widget.gamePlayState.currentLanguage, "Duration",),
                GameLogic().formatTime(widget.gamePlayState.duration.inSeconds),
                Icon(Icons.timer, size: (22 * widget.settingsState.sizeFactor), color: widget.palette.textColor2),
                widget.palette,
                widget.settingsState.sizeFactor
                ),
            tableRowItem(
              Helpers().translateText(widget.gamePlayState.currentLanguage, "Level",),
                widget.gamePlayState.currentLevel.toString(),
                Icon(Icons.bar_chart,
                    size: (22 * widget.settingsState.sizeFactor), color: widget.palette.textColor2),
                widget.palette,
                widget.settingsState.sizeFactor
                ),
          ],
        ),
        const Expanded(child: SizedBox()),
        Text(
          Helpers().translateText(widget.gamePlayState.currentLanguage, "Summary",),
          style: TextStyle(
            color: widget.palette.textColor2, 
            fontSize: (24 * widget.settingsState.sizeFactor)
          ),
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
                Icon(Icons.bolt, size: (22*widget.settingsState.sizeFactor), color: widget.palette.textColor2),
                widget.palette,
                widget.settingsState.sizeFactor
                ),
            tableRowItem(
                Helpers().translateText(widget.gamePlayState.currentLanguage, "Cross Words",),
                (widget.gamePlayState.summaryData['crosswords'] ?? 0)
                    .toString(),
                Icon(Icons.close, size: (22*widget.settingsState.sizeFactor), color: widget.palette.textColor2),
                widget.palette,
                widget.settingsState.sizeFactor
                ),
            tableRowItem(
                Helpers().translateText(widget.gamePlayState.currentLanguage, "Most Points",),
                (widget.gamePlayState.summaryData['mostPoints'] ?? 0)
                    .toString(),
                Icon(Icons.star, size: (22*widget.settingsState.sizeFactor), color: widget.palette.textColor2),
                widget.palette,
                widget.settingsState.sizeFactor
                ),
            tableRowItem(
                Helpers().translateText(widget.gamePlayState.currentLanguage, "Most Words",),
                (widget.gamePlayState.summaryData['mostWords'] ?? 0).toString(),
                Icon(Icons.my_library_books,
                    size: (22*widget.settingsState.sizeFactor), color: widget.palette.textColor2),
                widget.palette,
                widget.settingsState.sizeFactor
                ),
          ],
        ),
        const Expanded(child: SizedBox()),
        widget.gamePlayState.summaryData.isEmpty
            ? const SizedBox()
            : InkWell(
                onTap: widget.toggleDisplay,
                child: Text(
                  Helpers().translateText(widget.gamePlayState.currentLanguage, "View points summary"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: (20 * widget.settingsState.sizeFactor),
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

TableRow tableRowItem( String textBody, String data, Icon icon, ColorPalette palette, double sizeFactor) {
  return TableRow(children: [
    Center(
      child: icon,
    ),
    Text(
      textBody,
      style: TextStyle(
        color: palette.textColor2, 
        fontSize: ( 20 * sizeFactor)
      ),
    ),
    Align(
      alignment: Alignment.centerRight,
      child: Text(
        data,
        style: TextStyle(
          color: palette.textColor2, 
          fontSize: (20 * sizeFactor)
        ),
        textAlign: TextAlign.right,
      ),
    ),
  ]);
}
