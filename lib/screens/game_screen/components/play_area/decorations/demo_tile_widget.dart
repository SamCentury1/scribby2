import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class DemoTileWidget extends StatelessWidget {
  final double tileSize;
  final String tileId;
  final List<Map<dynamic, dynamic>> demoBoardState;
  final String language;
  final ColorPalette palette;
  final double fontSize;
  const DemoTileWidget({
    super.key,
    required this.tileSize,
    required this.tileId,
    required this.demoBoardState,
    required this.language,
    required this.palette,
    required this.fontSize
  });

  @override
  Widget build(BuildContext context) {
    late SettingsState settingsState = Provider.of<SettingsState>(context,listen: false);
    String tileLetter = Helpers().displayDemoTileLetter(demoBoardState,tileId,language,settingsState.demoLetters);
    Map<dynamic,dynamic> tileState = Helpers().getTileState(demoBoardState, tileId);
    bool isActive = tileState["active"];
    
    // Color borderColor = getDemoTileBorderColor(tileLetter,palette);
    // Color tileBgColor = getDemoTileColor(tileLetter,palette,isActive);
    Color tileTextColor = Helpers().getDemoTileTextColor(tileLetter,palette,isActive);


    return Center(
      child: Container(
        width: tileSize,
        height: tileSize,
        decoration: Helpers().getBoxDecoration(tileSize,palette,tileLetter,tileState["active"]),
        child: Center(
          child: DefaultTextStyle(
            child: Text(
              tileLetter,
            ),
            style: TextStyle(
              fontSize: fontSize,
              color: tileTextColor,
            ),
          )
        )
      ),      
    );
  }
}