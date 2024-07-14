import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';
class GameOverScreenOverlay extends StatelessWidget {
  const GameOverScreenOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    late SettingsState settingsState =Provider.of<SettingsState>(context, listen: false);
    late ColorPalette palette =Provider.of<ColorPalette>(context, listen: false);
    return Consumer<GamePlayState>(
      builder: (context, gamePlayState, child) {
        final List<Map<String,dynamic>> data = gamePlayState.endOfGameData['wordSummary'];
        return Consumer<AnimationState>(
          builder: (context,animationState,child) {
            return AnimatedOpacity(
              opacity: animationState.shouldShowGameOverScreenOverlay ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: IgnorePointer(
                ignoring: !animationState.shouldShowGameOverScreenOverlay,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: Container(
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(gamePlayState.tileSize*0.2),
                      child: Column(
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Container(
                              height: gamePlayState.tileSize*1,
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
                          SizedBox(height: gamePlayState.tileSize*0.2,),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: gamePlayState.tileSize*0.1),
                            child: SizedBox(
                              width: double.infinity,
              
                              child: Table(
                                columnWidths: const <int, TableColumnWidth>{
                                  0: FlexColumnWidth(4),
                                  1: FlexColumnWidth(6),
                                  2: FlexColumnWidth(5),
                                  3: FlexColumnWidth(4),
                                },
                                border: TableBorder(bottom: BorderSide(
                                  width: gamePlayState.tileSize*0.005, 
                                  color: palette.overlayText, 
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
                                          style: Helpers().customTextStyle(palette.overlayText, (gamePlayState.tileSize*0.3))
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: DefaultTextStyle(
                                          child: Text(
                                            Helpers().translateText(gamePlayState.currentLanguage,"Word",settingsState),
                                          ),
                                          style: Helpers().customTextStyle(palette.overlayText, (gamePlayState.tileSize*0.3))
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: DefaultTextStyle(
                                          child: Text(Helpers().translateText(gamePlayState.currentLanguage,"Bonus",settingsState),),
                                          style: Helpers().customTextStyle(palette.overlayText, (gamePlayState.tileSize*0.3))
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
                                            style: Helpers().customTextStyle(palette.overlayText, (gamePlayState.tileSize*0.3)),
                                          ),
                                        ),
                                      ),
                                    ]
                                  ),                
                                ]
                              ),                    
                            ),
                          ),                          
                          Expanded(
                            child: Stack(
                              children: [
                                Positioned(
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
                                          Padding(
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
                                                  color: palette.overlayText, 
                                                  style: BorderStyle.solid
                                                  )
                                                ),                          
                                                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                                children: <TableRow>[
                                                  for (int i=0; i<data.length; i++)
                                                  Helpers().scoreSummaryTableRow2(i, palette, data[i], context, gamePlayState.currentLanguage, gamePlayState.tileSize),
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
                                  bottom: 0,
                                  right: 0,
                                  left: 0,
                                  child: Container(
                                    width: gamePlayState.tileSize*6,
                                    child: Center(
                                      child: GestureDetector(
                                        onTap: () => animationState.setShouldShowGameOverScreenOverlay(false) ,
                                        child: Container(
                                          width: gamePlayState.tileSize*0.7,
                                          height: gamePlayState.tileSize*0.7,  
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.2),
                                            borderRadius: BorderRadius.all(Radius.circular(100.0))
                                          ),
                                          child: Icon(
                                            Icons.close, 
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
                          ), 
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        );
      },
    );
  }
}
