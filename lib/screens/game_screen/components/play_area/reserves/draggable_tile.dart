import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/play_area/decorations/decorations.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class DraggableTile extends StatefulWidget {
  final Map<String,dynamic> reserveObject;
  const DraggableTile({super.key, required this.reserveObject});

  @override
  State<DraggableTile> createState() => _DraggableTileState();
}

class _DraggableTileState extends State<DraggableTile> {



  double shouldDisplayPopulatedReserveTile(Map<String,dynamic> reserveObject, AnimationState animationState, GamePlayState gamePlayState) {
    String body = reserveObject['body'];
    double res = 0.0;

    if (body != "") {
      if (animationState.shouldRunTileDroppedAnimation) {
        if (reserveObject['id'] == gamePlayState.draggedReserveTile['id']) {
          res = 0.0;
        } else {
          res = 1.0;
        }
      } else {
        res = 1.0;
      }
    }
    return res;
  }  



  @override
  Widget build(BuildContext context) {
    late AnimationState animationState = Provider.of<AnimationState>(context,listen: false);
    late ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
    return Consumer<GamePlayState>(
      builder: (context, gamePlayState, child) {

        // final Map<String,dynamic> reserveObject = gamePlayState.reserveTiles.firstWhere((element) => element['id']==gamePlayState.selectedReserveIndex);
        final String body = widget.reserveObject['body'];
        final int shade = widget.reserveObject['shade'];
        final int angle = widget.reserveObject['angle'];

        return Container(
          width: gamePlayState.tileSize*0.75 * shouldDisplayPopulatedReserveTile(widget.reserveObject,animationState,gamePlayState),
          height: gamePlayState.tileSize*0.75 * shouldDisplayPopulatedReserveTile(widget.reserveObject,animationState,gamePlayState),
          decoration: Decorations().getFullReserveDecoration(gamePlayState.tileSize*0.75,palette,shade,angle),
          child: Center(
            child: DefaultTextStyle(
              style: TextStyle(
                color: palette.fullTileTextColor,
                fontSize: (gamePlayState.tileSize*0.75)*0.5
              ),
              child: Text(body),
            )
          ),
        );
      },
    );
  }
}