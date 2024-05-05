import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/components/draggable_tile.dart';
import 'package:scribby_flutter_v2/functions/game_logic.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';

class ReserveTiles extends StatefulWidget {
  const ReserveTiles({super.key});

  @override
  State<ReserveTiles> createState() => _ReserveTilesState();
}

class _ReserveTilesState extends State<ReserveTiles> {

  double getTileSize(double currentScreenWidth, double sizeFactor) {
    late double boardWidth = currentScreenWidth;
    if (currentScreenWidth > 500) {
      boardWidth = 500;
    }
    return (boardWidth/8)*sizeFactor;
  }

  
  @override
  Widget build(BuildContext context) {

    late SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);
        
    double tileSize = getTileSize(MediaQuery.of(context).size.width, settingsState.sizeFactor);

    return Consumer<GamePlayState>(
      builder: (context, gamePlayState, child) {
        return FittedBox(
          fit: BoxFit.scaleDown,
          child: SizedBox(
            width: Helpers().getScreenWidth(MediaQuery.of(context).size.width,settingsState.sizeFactor),
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (Map<String, dynamic> reserveLetter in gamePlayState.reserveTiles)
                    Stack(
                      children: [
                        Draggable(
                          data: reserveLetter["body"] == "" ? const SizedBox() : draggedTile(reserveLetter["body"],Colors.red, 0),
                          feedback: reserveLetter["body"] =="" ? const SizedBox() : DraggableTile(tileState:reserveLetter),
                          childWhenDragging:
                              reserveLetter["body"] == ""
                                  ? DraggableTile(tileState:reserveLetter)
                                  : DraggableTile(tileState: {"id":reserveLetter["id"],"body": ""}),
                          child: DraggableTile(tileState:reserveLetter), 
          
                          onDragStarted: () {
                              gamePlayState.setDraggedReserveTile(reserveLetter);
                          },
                          onDraggableCanceled: (Velocity velocity, Offset offset) {
                            gamePlayState.setDraggedReserveTile({}); 
                          },
                          onDragEnd: (details) {
                            gamePlayState.setDraggedReserveTile({});

                          },
                        ),
                        IgnorePointer(
                          ignoring: reserveLetter["body"] != "",
                          child: GestureDetector(
                            onTap: () {
                              GameLogic().placeIntoReserves(context,gamePlayState,reserveLetter);
                            },
                            child: Container(
                              width: tileSize,
                              height: tileSize,
                              color: Colors.transparent,
                            ),
                          ),
                        )
                      ],
                    )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
Widget draggedTile(String letter, Color color, double tileSize) {
  return Container(
    width: tileSize,
    height: tileSize,
    color: color,
    child: Center(
      child: Text(
        letter,
        style: const TextStyle(fontSize: 22, color: Colors.white),
      ),
    ),
  );
}

bool isTilePopulated(Map<String,dynamic> reserveLetter) {
  if (reserveLetter['body'] == "") {
    return true;
  } else {
    return false;
  }
}