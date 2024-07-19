import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class GameSummaryContent extends StatefulWidget {
  final GamePlayState gamePlayState;
  const GameSummaryContent(this.gamePlayState,
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

  @override
  Widget build(BuildContext context) {
    return Consumer<GamePlayState>(
      builder:(context, gamePlayState, child) {

        late List<Map<String,dynamic>> data = Helpers().getPointsSummary(gamePlayState.scoringLog);
        late ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
        late SettingsState settingsState = Provider.of<SettingsState>(context,listen: false);
        // late List<Map<String,dynamic>> data = [];

        // late List<Map<String,dynamic>> summary = GameLogic().getPointsSummary(gamePlayState);

        return Container(
          child: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    gamePlayState.tileSize*0.1,
                    gamePlayState.tileSize*0.1,
                    gamePlayState.tileSize*0.1,
                    gamePlayState.tileSize*1.0
                  ),
                
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                      
                            data.isEmpty
                                ? DefaultTextStyle(
                                  child: Text(
                                    Helpers().translateText(gamePlayState.currentLanguage,"No words found yet...",settingsState),
                                    ),
                                    style: TextStyle(color: palette.overlayText, fontSize: gamePlayState.tileSize*0.3),
                                    textAlign: TextAlign.center,
                                )
                                : Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: SizedBox(
                                      width: double.infinity,
                      
                                      child: Table(
                                        columnWidths: const <int, TableColumnWidth>{
                                          0: FlexColumnWidth(4),
                                          1: FlexColumnWidth(6),
                                          2: FlexColumnWidth(5),
                                          3: FlexColumnWidth(4),
                                        },
                                        border: TableBorder(horizontalInside: BorderSide(
                                          width: gamePlayState.tileSize*0.005, 
                                          color: widget.palette.overlayText, 
                                          style: BorderStyle.solid
                                          )
                                        ),                          
                                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                        children: <TableRow>[
                                          TableRow(
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: DefaultTextStyle(
                                                  child: Text( Helpers().translateText(gamePlayState.currentLanguage,"Turn",settingsState),),
                                                  style: Helpers().customTextStyle(widget.palette.overlayText, (gamePlayState.tileSize*0.3))
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: DefaultTextStyle(
                                                  child: Text(
                                                    Helpers().translateText(gamePlayState.currentLanguage,"Word",settingsState),
                                                  ),
                                                  style: Helpers().customTextStyle(widget.palette.overlayText, (gamePlayState.tileSize*0.3))
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: DefaultTextStyle(
                                                  child: Text(Helpers().translateText(gamePlayState.currentLanguage,"Bonus",settingsState),),
                                                  style: Helpers().customTextStyle(widget.palette.overlayText, (gamePlayState.tileSize*0.3))
                                                ),
                                              ),                                                                                                                              
                                              Padding(
                                                padding: EdgeInsets.only(right: gamePlayState.tileSize*0.15),
                                                child: Align(
                                                  alignment: Alignment.centerRight,
                                                  child: DefaultTextStyle(
                                                    child: Text(
                                                      Helpers().translateText(gamePlayState.currentLanguage,"Points",settingsState),
                                                      textAlign: TextAlign.right,
                                                    ),
                                                    style: Helpers().customTextStyle(widget.palette.overlayText, (gamePlayState.tileSize*0.3)),
                                                  ),
                                                ),
                                              ),
                                            ]
                                          ),
                                          for (int i=0; i<data.length; i++)
                                          Helpers().scoreSummaryTableRow2(i, widget.palette, data[i], context, gamePlayState.currentLanguage, gamePlayState.tileSize),
                                          // Helpers().scoreSummaryTableRow(i, widget.palette,summary[i], context, gamePlayState.currentLanguage, widget.settingsState.sizeFactor),
                                        ]
                                      ),                    
                                    ),
                                  ),
                          ],
                        ),
                      ),
                
                ),
              ),
              Positioned(
                // right: (settingsState.screenSizeData['width']-(gamePlayState.tileSize*6))/2,
                right: 0,
                left: 0,
                bottom: 0,
                child: Container(
                  width: gamePlayState.tileSize*6,
                  child: Center(
                    child: GestureDetector(
                      onTap: widget.toggleDisplay,
                      child: Container(
                        width: gamePlayState.tileSize*0.7,
                        height: gamePlayState.tileSize*0.7,  
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.all(Radius.circular(100.0))
                        ),
                        child: Icon(
                          Icons.arrow_upward, 
                          size: gamePlayState.tileSize*0.4,
                          color: palette.overlayText.withOpacity(0.5),
                        )  
                      ),
                    ),
                  ),
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

    late AnimationState animationState = Provider.of<AnimationState>(context,listen: false);

    final Map<String,dynamic> gameData = Helpers().getGameSummaryData(widget.gamePlayState.scoringLog);
    return Stack(
      children: [
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              widget.gamePlayState.tileSize*0.4, 
              widget.gamePlayState.tileSize*0.4,
              widget.gamePlayState.tileSize*0.4,
              widget.gamePlayState.tileSize*1.0,
            ),
            
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              DefaultTextStyle(
                child: Text(
                  Helpers().translateText(widget.gamePlayState.currentLanguage, "Summary",widget.settingsState),
                ),
                style: Helpers().customTextStyle(widget.palette.overlayText, widget.gamePlayState.tileSize*0.4),
              ),
              SizedBox(height: widget.gamePlayState.tileSize*0.5,),     
              Table(
                columnWidths: const <int, TableColumnWidth>{
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(5),
                  2: FlexColumnWidth(2),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: <TableRow>[
                  tableRowItem(
                    Helpers().translateText(widget.gamePlayState.currentLanguage, "Level",widget.settingsState),
                      widget.gamePlayState.currentLevel.toString(),
                      Icon(Icons.bar_chart,
                          size: (widget.gamePlayState.tileSize*0.3), color: widget.palette.overlayText),
                      widget.palette,
                      widget.settingsState.sizeFactor,
                      widget.gamePlayState.tileSize*0.3,
                      ), 
          
                  tableRowItem(
                    Helpers().translateText(widget.gamePlayState.currentLanguage, "Score",widget.settingsState),
                      gameData['points'].toString(),
                      Icon(Icons.emoji_events,
                          size: (widget.gamePlayState.tileSize*0.3), color: widget.palette.overlayText),
                      widget.palette,
                      widget.settingsState.sizeFactor,
                      widget.gamePlayState.tileSize*0.3,
                      ),
          
                  tableRowItem(
                    Helpers().translateText(widget.gamePlayState.currentLanguage, "Words",widget.settingsState),
                      gameData['uniqueWords'].length.toString(),
                      Icon(Icons.library_books,
                          size: (widget.gamePlayState.tileSize*0.3), color: widget.palette.overlayText),
                      widget.palette,
                      widget.settingsState.sizeFactor,
                      widget.gamePlayState.tileSize*0.3,
                      ),
          
                             
                ],
              ),
              Divider(thickness: widget.gamePlayState.tileSize*0.01,color: widget.palette.overlayText),
              Table(
                columnWidths: const <int, TableColumnWidth>{
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(5),
                  2: FlexColumnWidth(2),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: <TableRow>[
                  tableRowItem(
                    Helpers().translateText(widget.gamePlayState.currentLanguage, "Duration",widget.settingsState),
                      Helpers().formatTime(widget.gamePlayState.duration.inSeconds),
                      Icon(Icons.timer, size: (widget.gamePlayState.tileSize*0.3), color: widget.palette.overlayText),
                      
                      widget.palette,
                      widget.settingsState.sizeFactor,
                      widget.gamePlayState.tileSize*0.3,
                      ),
                  tableRowItem(
                    Helpers().translateText(widget.gamePlayState.currentLanguage, "Turns",widget.settingsState),
                      gameData['turns'].toString(),
                      Icon(Icons.touch_app,
                          size: (widget.gamePlayState.tileSize*0.3), color: widget.palette.overlayText),
                      widget.palette,
                      widget.settingsState.sizeFactor,
                      widget.gamePlayState.tileSize*0.3,
                      ),                    
                   
                ],
              ),
          
              Divider(thickness: widget.gamePlayState.tileSize*0.01,color: widget.palette.overlayText),
              Table(
                columnWidths: const <int, TableColumnWidth>{
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(5),
                  2: FlexColumnWidth(2),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: <TableRow>[
          
                  tableRowItem(
                      Helpers().translateText(widget.gamePlayState.currentLanguage, "Longest Streak",widget.settingsState),
                      gameData['longestStreak']
                          .toString(),
                      Icon(Icons.bolt, size: (widget.gamePlayState.tileSize*0.3), color: widget.palette.overlayText),
                      widget.palette,
                      widget.settingsState.sizeFactor,
                      widget.gamePlayState.tileSize*0.3,
                      ),
                  tableRowItem(
                      Helpers().translateText(widget.gamePlayState.currentLanguage, "Cross Words",widget.settingsState),
                      gameData['crosswords']
                          .toString(),
                      Icon(Icons.close, size: (widget.gamePlayState.tileSize*0.3), color: widget.palette.overlayText),
                      widget.palette,
                      widget.settingsState.sizeFactor,
                      widget.gamePlayState.tileSize*0.3,
                      ),
                  tableRowItem(
                      Helpers().translateText(widget.gamePlayState.currentLanguage, "Most Points",widget.settingsState),
                      gameData['mostPoints']
                          .toString(),
                      Icon(Icons.star, size: (widget.gamePlayState.tileSize*0.3), color: widget.palette.overlayText),
                      widget.palette,
                      widget.settingsState.sizeFactor,
                      widget.gamePlayState.tileSize*0.3,
                      ),
                  tableRowItem(
                      Helpers().translateText(widget.gamePlayState.currentLanguage, "Most Words",widget.settingsState),
                      gameData['mostWords'].toString(),
                      Icon(Icons.my_library_books,
                          size: (widget.gamePlayState.tileSize*0.3), color: widget.palette.overlayText),
                      widget.palette,
                      widget.settingsState.sizeFactor,
                      widget.gamePlayState.tileSize*0.3,
                      ),                
                ],
              ),                
              SizedBox(height: widget.gamePlayState.tileSize*0.2,),
              widget.gamePlayState.scoringLog.isEmpty
                  ? const SizedBox()
                  : GestureDetector(
                      onTap: widget.toggleDisplay,
                      child: DefaultTextStyle(
                        child: Text(
                          Helpers().translateText(widget.gamePlayState.currentLanguage, "View points summary",widget.settingsState),
                          textAlign: TextAlign.center,
                        ),
                        style: Helpers().customTextStyle(widget.palette.overlayText, (widget.gamePlayState.tileSize*0.3)),
                      ),
                    ),
              // const Expanded(child: SizedBox()),
            ]),
          ),
        ),     
      ],
    );
  }
}

 tableRowItem( String textBody, String data, Icon icon, ColorPalette palette, double sizeFactor, double fontSize) {
  return TableRow(
    children: [
    Padding(
      padding: EdgeInsets.all(fontSize*0.5),
      child: Center(
        child: icon,
      ),
    ),
    Padding(
      padding: EdgeInsets.all(fontSize*0.5),
      child: DefaultTextStyle(
        child: Text(
          textBody,
        ),
        style: Helpers().customTextStyle(palette.overlayText, fontSize),
      ),
    ),
    Padding(
      padding: EdgeInsets.all(fontSize*0.5),
      child: Align(
        alignment: Alignment.centerRight,
        child: DefaultTextStyle(
          child: Text(
            data,
            textAlign: TextAlign.right,
          ),
          style: Helpers().customTextStyle(palette.overlayText, fontSize),
        ),
      ),
    ),
  ]);
}


class GameSummaryScreen extends StatefulWidget {
  const GameSummaryScreen({
    super.key,
  });

  @override
  State<GameSummaryScreen> createState() => _GameSummaryScreenState();
}

class _GameSummaryScreenState extends State<GameSummaryScreen> {

  double getDialogWidth(double currentScreenWidth) {
    late double res = currentScreenWidth;
    if (currentScreenWidth > 500) {
      res = 500;
    }
    return res * 0.85;
  } 

  @override

  @override
  Widget build(BuildContext context) {
    final ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
    final SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);
    final AnimationState animationState = Provider.of<AnimationState>(context, listen: false);
    return Consumer<GamePlayState>(
      builder: (context, gamePlayState, child) {

        return Padding(
          padding: EdgeInsets.all(gamePlayState.tileSize*0.2),
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: gamePlayState.tileSize*0.2),
                child: Container(
                  height: gamePlayState.tileSize*1,
                  width: gamePlayState.tileSize*6,
                  child:FittedBox(
                      fit: BoxFit.scaleDown,
                      child: DefaultTextStyle(
                        child: Text(
                          Helpers().translateText(gamePlayState.currentLanguage, "Game Summary",settingsState), 
                        ),
                        style: Helpers().customTextStyle(palette.overlayText,gamePlayState.tileSize*0.5),
                      ),
                    ),                        
                  ),
              ),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: gamePlayState.tileSize*0.2),
                  child: Divider(
                    color: palette.overlayText,
                    height: 2,
                  ),
                ),
                Expanded(child: GameSummaryContent(gamePlayState)), 
          
              ],
            ),
        );        
      },
    );
  }
}

