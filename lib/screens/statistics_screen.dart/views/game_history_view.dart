import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/screens/statistics_screen.dart/components/game_summary_card.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';

class GameHistoryPageView extends StatefulWidget {
  final SettingsController settings; 
  final ColorPalette palette;
  const GameHistoryPageView({
    super.key,
    required this.settings,
    required this.palette
  });

  @override
  State<GameHistoryPageView> createState() => _GameHistoryPageViewState();
}

class _GameHistoryPageViewState extends State<GameHistoryPageView> {
  @override
  Widget build(BuildContext context) {

    final double scalor = Helpers().getScalor(widget.settings);

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0 * scalor),
        child: Builder(
          builder: (context) {
            if (widget.settings.userGameHistory.value.isEmpty) {
              return SizedBox(
                child: Text(
                  "No games played yet...",
                  style: widget.palette.counterFont(
                    textStyle: TextStyle(
                      fontSize: 22 * scalor,
                      color: widget.palette.text1,
                    ),
                  ) 
                ),
              );
            } else {
              return ListView.builder(
                itemCount: widget.settings.userGameHistory.value.length,
                itemBuilder: (BuildContext context, int index) {
                  return GameSummaryCard(gameData: widget.settings.userGameHistory.value[index],palette: widget.palette,);
                }
              );
            }
          }
        )
      ),
    );
  }
}
