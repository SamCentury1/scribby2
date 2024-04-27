import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class DraggableTile extends StatelessWidget {
  final Map<String, dynamic> tileState;
  const DraggableTile({super.key, required this.tileState});

  Color colorTileBg(Map<String, dynamic> tileObject, ColorPalette palette) {
    late Color color = const Color.fromRGBO(0, 0, 0, 0);
    if (tileObject["body"] == "") {
      color = Colors.transparent;
    } else {
      // color = palette.tileBgColor;
      color = Color.fromRGBO(
        palette.tileBgColor.red,
        palette.tileBgColor.green,
        palette.tileBgColor.blue,
        1.0
      );
    }
    return color;
  }

  Color colorTileBorder(Map<String, dynamic> tileObject, ColorPalette palette) {
    late Color color = const Color.fromRGBO(0, 0, 0, 0);

    if (tileObject["body"] == "") {
      // color = palette.tileBgColor;
      color = Color.fromRGBO(
        palette.tileBgColor.red,
        palette.tileBgColor.green,
        palette.tileBgColor.blue,
        1.0
      );
    } else {
      color = const Color.fromRGBO(0, 0, 0, 0);
    }
    return color;
  }
  double getTileSize(double currentScreenWidth, double sizeFactor) {
    late double boardWidth = currentScreenWidth;
    if (currentScreenWidth > 500) {
      boardWidth = 500;
    }
    return (boardWidth/8)*sizeFactor;
  }
  @override
  Widget build(BuildContext context) {
    final ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
    final SettingsState settingsState = Provider.of(context, listen: false);
    // double tileSize = ((MediaQuery.of(context).size.width ) /8) * settingsState.sizeFactor;
    double tileSize = getTileSize(MediaQuery.of(context).size.width, settingsState.sizeFactor);
    return Consumer<GamePlayState>(
      builder: (context, gamePlayState, child) {
        return Center(
          child: Padding(
            padding:  EdgeInsets.all(2.0 * settingsState.sizeFactor),
            child: Container(
                width: tileSize,
                height: tileSize,
                
                decoration: BoxDecoration(
                  color: colorTileBg(tileState, palette),
                  border: Border.all(
                      color: colorTileBorder(tileState, palette), width: (3*settingsState.sizeFactor)),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: tileState["body"] == "" ? 0 : (26*settingsState.sizeFactor),
                      color: tileState["body"] == ""
                          ? Colors.transparent
                          : palette.tileTextColor,
                    ),
                    child: Text(tileState["body"]),
                  ),
                )),
          ),
        );
      },
    );
  }
}
