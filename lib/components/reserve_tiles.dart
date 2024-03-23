import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/audio/audio_controller.dart';
import 'package:scribby_flutter_v2/components/draggable_tile.dart';
import 'package:scribby_flutter_v2/functions/game_logic.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';

class ReserveTiles extends StatefulWidget {
  const ReserveTiles({super.key});

  @override
  State<ReserveTiles> createState() => _ReserveTilesState();
}

class _ReserveTilesState extends State<ReserveTiles> {


  
  @override
  Widget build(BuildContext context) {

    late SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);
    // late AnimationState animationState = Provider.of<AnimationState>(context, listen: false);
    // late AudioController audioController = Provider.of<AudioController>(context, listen: false);
        
    double tileSize = ((MediaQuery.of(context).size.width ) /8) * settingsState.sizeFactor;

    return Consumer<GamePlayState>(
      builder: (context, gamePlayState, child) {
        return FittedBox(
          fit: BoxFit.scaleDown,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * settingsState.sizeFactor,
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (Map<String, dynamic> reserveLetter in gamePlayState.reserveTiles)
                    Stack(
                      children: [
                        Draggable(
                          data: reserveLetter["body"] == "" ? const SizedBox() : draggedTile(reserveLetter["body"],Colors.red, 0), // draggedTile(reserveLetter["body"], Colors.red),
                          feedback: reserveLetter["body"] =="" ? const SizedBox() : DraggableTile(tileState:reserveLetter), // draggedTile(reserveLetter["body"], const Color.fromARGB(255, 73, 54, 244)),
                          childWhenDragging:
                              reserveLetter["body"] == ""
                                  ? DraggableTile(tileState:reserveLetter)
                                  : DraggableTile(tileState: {"id":reserveLetter["id"],"body": ""}),
                          child: DraggableTile(tileState:reserveLetter), //draggedTile(reserveLetter["body"], Colors.black),
          
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