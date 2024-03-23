import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/audio/audio_controller.dart';
import 'package:scribby_flutter_v2/components/draggable_tile.dart';
import 'package:scribby_flutter_v2/components/new_points_animation.dart';
import 'package:scribby_flutter_v2/components/tile.dart';
import 'package:scribby_flutter_v2/components/tile_widget.dart';
import 'package:scribby_flutter_v2/functions/game_logic.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/utils/states.dart';

class Board extends StatefulWidget {
  const Board({super.key});

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  
  late SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);
  late AnimationState animationState = Provider.of<AnimationState>(context, listen: false);
  late AudioController audioController = Provider.of<AudioController>(context, listen: false);


  @override
  Widget build(BuildContext context) {
    return Consumer<GamePlayState>(
      builder: (context,gamePlayState,children) {
        return Stack(
          children: [
            Center(
              child: SizedBox(
                height:(MediaQuery.of(context).size.width ) * settingsState.sizeFactor,
                width:(MediaQuery.of(context).size.width ) * settingsState.sizeFactor, //330,
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 6,
                  children: List.generate(36, (i) {
                    return TileWidget(
                      index: i, 
                      // tileSize: ((MediaQuery.of(context).size.width )/7) * settingsState.sizeFactor,
                    );
                  }),
                ),
              ),
            ),
            const NewPointsAnimation()
          ],
        );
      }
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