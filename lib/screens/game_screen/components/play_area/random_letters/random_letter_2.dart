
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/game_logic_2.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/play_area/decorations/decorations.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class RandomLetter2 extends StatefulWidget {
  final AnimationController tileTappedController;
  const RandomLetter2({
    super.key,
    required this.tileTappedController
  });

  @override
  State<RandomLetter2> createState() => _RandomLetter2State();
}

class _RandomLetter2State extends State<RandomLetter2> with SingleTickerProviderStateMixin {

  late AnimationState animationState;
  late Animation<double> topPositionAnimation;
  late Animation<double> leftPositionAnimation;
  late Animation<double> tileSizeAnimation;
  
  @override
  void initState() {
    super.initState();
    initializeAnimations();
    animationState = Provider.of<AnimationState>(context, listen: false);
  }  

  void initializeAnimations() {
    GamePlayState gamePlayState = context.read<GamePlayState>();
    final double tileSize = gamePlayState.tileSize; 

    final curvedAnimation = CurvedAnimation(
      parent: widget.tileTappedController,
      curve: Curves.easeOut,
    );

    topPositionAnimation = Tween<double>(
      begin: tileSize,
      end: (((tileSize)+((tileSize*0.1)/2))-(tileSize*0.1))/2,
    ).animate(curvedAnimation); 

    leftPositionAnimation = Tween<double>(
      begin: (tileSize)*5,
      end:  (tileSize)*4.5,
    ).animate(curvedAnimation);     

    tileSizeAnimation = Tween<double>(
      begin: tileSize*0.1,
      end: tileSize,
    ).animate(curvedAnimation);    

    widget.tileTappedController.forward(from: 1.0);           
  }

  @override
  Widget build(BuildContext context) {
    late ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
    return AnimatedBuilder(
      animation: widget.tileTappedController,
      builder: (context,child) {
        return Consumer<GamePlayState>(
          builder: (context,gamePlayState,child) {
            String letter = GameLogic().displayRandomLetters(gamePlayState.randomLetterList,1);
            int shade = GameLogic().displayRandomLetterStyle(gamePlayState.randomShadeList,1);
            int angle = GameLogic().displayRandomLetterStyle(gamePlayState.randomAngleList,1);            
            return Positioned(
              top: topPositionAnimation.value,
              left: leftPositionAnimation.value,
              child: Center(
                child: Container(
                  width: tileSizeAnimation.value,
                  height: tileSizeAnimation.value,
                  child: Stack(
                    children: [          
                      Positioned(
                        top:(tileSizeAnimation.value*0.05), // to center, equals to (tileSize-tileSize*0.9)/2
                        left: (tileSizeAnimation.value*0.05), // to center, equals to (tileSize-tileSize*0.9)/2
                        
                        child: Container(
                          width: tileSizeAnimation.value*0.9,
                          height: tileSizeAnimation.value*0.9,
                          // decoration: body == "" ? Decorations().getEmptyTileDecoration() : Decorations().getTileDecoration(),
                          decoration: Decorations().getTileDecoration(tileSizeAnimation.value*0.9,palette,shade,angle),
                          child: Center(
                            child: Text(
                              letter,
                              style: TextStyle(
                                fontSize: tileSizeAnimation.value*0.9*0.5, 
                                color: palette.fullTileTextColor, // Color.fromRGBO(64, 64, 64, 1),
                              ),
                            ),
                          ),
                        ),
                      ),                  
                    ],
                  ),
                  // child: TileWidgetLayout(
                  //   tileSize: tileSizeAnimation.value,
                  //   // body: gamePlayState.randomLetterList[gamePlayState.randomLetterList.length-1],
                  //   body: letter,
                  //   decoration: Decorations().getTileDecoration(gamePlayState.tileSize,palette,shade,angle),
                  // ),
                ),
              )
            );
          }
        );
      }
    );
  }
}
//     return Container(
//       width: tileSize,
//       height: tileSize,
//       child: Stack(
//         children: [          
//           Positioned(
//             top:(tileSize*0.05), // to center, equals to (tileSize-tileSize*0.9)/2
//             left: (tileSize*0.05), // to center, equals to (tileSize-tileSize*0.9)/2
            
//             child: Container(
//               width: tileSize*0.9,
//               height: tileSize*0.9,
//               // decoration: body == "" ? Decorations().getEmptyTileDecoration() : Decorations().getTileDecoration(),
//               decoration: decoration,
//               child: Center(
//                 child: Text(
//                   body,
//                   style: TextStyle(
//                     fontSize: tileSize*0.9*0.5, 
//                     color: palette.fullTileTextColor, // Color.fromRGBO(64, 64, 64, 1),
//                   ),
//                 ),
//               ),
//             ),
//           ),                  
//         ],
//       ),
//     );
