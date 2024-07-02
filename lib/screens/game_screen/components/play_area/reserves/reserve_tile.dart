import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/game_logic_2.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/play_area/decorations/decorations.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/play_area/reserves/draggable_tile.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class ReserveTile extends StatefulWidget {
  final int index;
  const ReserveTile({super.key, required this.index});

  @override
  State<ReserveTile> createState() => _ReserveTileState();
}

class _ReserveTileState extends State<ReserveTile> with SingleTickerProviderStateMixin {

  late AnimationState animationState;

  late AnimationController reserveTileTappedExitController;
  late Animation<double> reserveTileTappedExitAnimation;

  @override
  void initState() {
    super.initState();
    initializeAnimations();
    animationState = Provider.of<AnimationState>(context, listen: false);
    animationState.addListener(handleAnimationStateChange);
  }

  void initializeAnimations() {
    reserveTileTappedExitController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this
    );

    reserveTileTappedExitAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0, 
    ).animate(reserveTileTappedExitController);
  }

  void handleAnimationStateChange() {
    if (animationState.shouldRunTileTappedAnimation) {
      executeAnimations();
    }
  }

  void executeAnimations() {
    reserveTileTappedExitController.reset();
    reserveTileTappedExitController.forward();
  }

  double shouldDisplayLeavingReserveTile(int index, Animation animation, AnimationState animationState, GamePlayState gamePlayState) {
    double res = 1.0;
    if (animationState.shouldRunTileTappedAnimation) {
      final Map<String,dynamic> reserveObject = gamePlayState.reserveTiles.firstWhere((element) => element['id'] == widget.index);
      // print(reserveObject);

      if (reserveObject['id'] == gamePlayState.selectedReserveIndex) {
        res = 1.0 * animation.value;
      } else {
      }
    }
    return res;
  }
  double shouldDisplayEmptyReserveTile(String body, int index, int selectedIndex) {
    double res = 0.0;
    if (body == "") {
      if (index == selectedIndex) {
        res = 0.0;
      } else {
        res = 1.0;
      }
    }
    return res;
  }

  double shouldDisplayPopulatedReserveTile(String body) {
    double res = 0.0;
    if (body != "") {
      res = 1.0;
    }
    return res;
  }  

  @override
  void dispose() {
    animationState.removeListener(handleAnimationStateChange);
    reserveTileTappedExitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late AnimationState animationState = Provider.of<AnimationState>(context, listen: false);
    late ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
    return Consumer<GamePlayState>(
      builder: (context,gamePlayState,child) {
        final Map<String,dynamic> reserveObject = gamePlayState.reserveTiles.firstWhere((element) => element['id'] == widget.index);
        final double tileSize = gamePlayState.tileSize;
        final double top = tileSize*8.1;
        final double left =  (tileSize*6 - tileSize*0.8*5)/2 + (tileSize*0.8*widget.index);
        return Positioned(
          top: top,
          left: left,
          child: Container(
            width: tileSize*0.8,
            height: tileSize*0.8, 
            // color: Colors.red,
            child: Center(
              child: Container(
                width: tileSize*0.75,
                height: tileSize*0.75,
                child : Stack(
                  children: [



                    AnimatedBuilder(
                      animation: reserveTileTappedExitController,
                      builder: (context,child) {

                        double tileSizeAnim = tileSize*0.75 * shouldDisplayLeavingReserveTile(widget.index,reserveTileTappedExitAnimation, animationState ,gamePlayState);
                        double top = (tileSize*0.75 - tileSizeAnim)/2;
                        double left = (tileSize*0.75 - tileSizeAnim)/2;
                        return Positioned(
                          top: top,
                          left: left,
                          child: IgnorePointer(
                            ignoring: animationState.shouldRunTileTappedAnimation,
                            child: Container(
                              width: tileSizeAnim,
                              height: tileSizeAnim,
                              // color: Colors.blue,
                              decoration: Decorations().getEmptyReserveDecoration(tileSizeAnim,palette),
                              child: Center(
                                child: SizedBox(),
                              ),
                            ),
                          ) 
                        );
                      }
                    ),
                    Draggable(
                      // data: reserveObject["body"] == "" ? const SizedBox() : draggedTile(reserveObject["body"],Colors.red, 0),
                      data: DraggableTile(reserveObject:reserveObject,),//draggedTile(reserveObject["body"],Colors.red, 0),
                      // feedback: reserveObject["body"] =="" ? const SizedBox() : DraggableTile(reserveObject:reserveObject,),
                      feedback: DraggableTile(reserveObject:reserveObject,),
                      childWhenDragging: DraggableTile(
                        reserveObject: {
                          "id":reserveObject["id"],
                          "body": "", 
                          "shade": reserveObject['shade'], 
                          'angle':reserveObject['angle'] 
                        },
                      ),
                          // reserveObject["body"] == ""
                          //     ? DraggableTile(reserveObject:reserveObject,)
                          //     : DraggableTile(reserveObject: {"id":reserveObject["id"],"body": ""},),
                      child: DraggableTile(reserveObject:reserveObject,), 
                  
                      onDragStarted: () {
                          gamePlayState.setDraggedReserveTile(reserveObject);
                      },
                      onDraggableCanceled: (Velocity velocity, Offset offset) {
                        gamePlayState.setDraggedReserveTile({}); 
                      },
                      onDragEnd: (details) {
                        // Future.delayed(const Duration(milliseconds: 500), () {
                          
                        // });
          
                      },
                    ),

                    IgnorePointer(
                      ignoring: reserveObject["body"] != "" || animationState.shouldRunTileTappedAnimation || shouldIgnoreTap(widget.index,gamePlayState),
                      child: GestureDetector(
                        onTapDown: (details) => GameLogic().reserveTapDownBehavior(gamePlayState, animationState, widget.index),
                        onTapUp: (details) => GameLogic().reserveTapUpBehavior(context, gamePlayState, animationState,widget.index),
                        onTapCancel: () => GameLogic().reserveTapCancelBehavior(gamePlayState),
                        child: Container(
                          width: tileSize*0.75 * shouldDisplayEmptyReserveTile(reserveObject["body"], widget.index, gamePlayState.selectedReserveIndex),
                          height: tileSize*0.75,
                          // decoration: Decorations().getEmptyReserveDecoration(gamePlayState.tileSize*0.75,palette),
                          decoration: BoxDecoration(
                            color: Colors.transparent
                          ),
                        ),
                      ),
                    ),




                  ],
                )                     
              ),
            ),    
          )
        );
      }
    );
  }
}


bool shouldIgnoreTap(int index, GamePlayState gamePlayState) {
  late bool res = true;
  if (gamePlayState.selectedReserveIndex > -1) {
    if (gamePlayState.selectedReserveIndex == index) {
      res = false;
    } else {
      res = true;
    }
  } else {
    if (gamePlayState.selectedTileIndex > -1) {
      res = true;
    } else {
      res = false;
    }
  }
  if (gamePlayState.draggedReserveTile.isNotEmpty) {
    res = true;
  }  
  return res;
}