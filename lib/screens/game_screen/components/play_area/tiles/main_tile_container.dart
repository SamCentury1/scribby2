import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/game_logic_2.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/play_area/decorations/decorations.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class MainTileContainer extends StatefulWidget {
  final int index;
  final AnimationController wordFoundController;
  final AnimationController tileTappedController;
  final AnimationController tileTappedExitController;
  final AnimationController tileDroppedController;
  final Animation<Color?> wordFoundColorAnimation;
  final Animation<double> wordFoundSizeAnimation;
  final Animation<double> wordFoundSizeAnimation2;
  final Animation<double> killTileAnimation;
  const MainTileContainer({
    super.key, 
    required this.index,
    required this.wordFoundController,
    required this.tileTappedController,
    required this.tileTappedExitController,
    required this.tileDroppedController,
    required this.wordFoundColorAnimation,
    required this.wordFoundSizeAnimation,
    required this.wordFoundSizeAnimation2,
    required this.killTileAnimation,
  });

  @override
  State<MainTileContainer> createState() => _MainTileContainerState();
}

class _MainTileContainerState extends State<MainTileContainer> with TickerProviderStateMixin{

  late AnimationState animationState;
  late GamePlayState gamePlayState;
  late Animation<double> tileTappedHideEmptyTileAnimation;
  late Animation<double> reserveTileDroppedAnimation;
  late Animation<double> killTileAnimation;


  @override
  void initState() {
    super.initState();
    gamePlayState = Provider.of<GamePlayState>(context, listen: false);
    animationState = Provider.of<AnimationState>(context, listen: false);
    initializeAnimations(gamePlayState, widget.wordFoundController);
  }



  void initializeAnimations(GamePlayState gamePlayState, AnimationController wordFoundController) {

    tileTappedHideEmptyTileAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(widget.tileTappedExitController);

    List<TweenSequenceItem<double>> reserveTileDroppedSequence = [
      TweenSequenceItem(tween: Tween(begin: 0.8, end: 1.0), weight: 0.4,),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 0.6,),
    ];
    reserveTileDroppedAnimation = TweenSequence<double>(reserveTileDroppedSequence).animate(widget.tileDroppedController);
  }

  double shouldDisplayEmptyTile(String body, int index, GamePlayState gamePlayState, AnimationState animationState) {
    double res = 0.0;
    int selectedIndex = gamePlayState.selectedTileIndex;
    List<dynamic> validIds = gamePlayState.validIds.map((e) => e['id']).toList();
    
    if (body == "") {
      if (validIds.contains(widget.index)) {
        res = 1.0;
      } 
      if (index == selectedIndex) {
        if (animationState.shouldRunTileTappedAnimation) {
          res = 0.0;
        } else {
          res = 0.8;
        }
      } else {
        res = 1.0;
      }
    }
    return res;
  }

  /// DISPLAYS THE TILE GETTING SMALLER WHILE THE TILETAPPEDANIMATION PLAYS
  double shouldDisplayLeavingTile(int index, Animation tapAnimation, Animation wordAnimation, AnimationState animationState, GamePlayState gamePlayState) {
    double res = 1.0;
    if (animationState.shouldRunTileTappedAnimation) {
      final Map<dynamic,dynamic> tileObject = gamePlayState.tileState.firstWhere((element) => element['index'] == widget.index);
      if (tileObject['index'] == gamePlayState.selectedTileIndex) {
        res = 1.0 * tapAnimation.value;
      } 
    } 
    if (widget.wordFoundController.isAnimating) {
      List<dynamic> validIds = gamePlayState.validIds.map((e) => e['id']).toList();
      if (validIds.contains(index)) {
        res = 1.0 * (wordAnimation.value);
      }
    }
    return res;
  }



  double shouldDisplayPopulatedTile(String body) {
    double res = 0.0;
    if (body != "") {
      res = 1.0;
    }
    return res;
  }


  double shouldDisplayDroppedTile(String body, int index, GamePlayState gamePlayState, AnimationState animationState) {
    double res = 0.0;
    if (animationState.shouldRunTileDroppedAnimation) {
      if (index == gamePlayState.droppedTileIndex) {
        res = 1.0 ;
      }
    }
    return res;
  }  

  BoxDecoration shouldDisplayDroppedTileBoxDecoration(String body, int index, GamePlayState gamePlayState, AnimationState animationState) {
    BoxDecoration res = BoxDecoration(color: Colors.transparent);
    if (animationState.shouldRunTileDroppedAnimation) {
      if (index == gamePlayState.droppedTileIndex) {
        res = BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(reserveTileDroppedAnimation.value), 
              offset: Offset.zero, 
              blurRadius: 7, 
              spreadRadius: 5
            ),
          ]
        );
      }
    }
    return res;
  }    

  /// SHOWN DURING THE WORDFOUNDANIMATION
  double shouldDisplayConsumeTile(GamePlayState gamePlayState, AnimationState animationState, Animation animation) {
    double res = 0.0;
    List<dynamic> validIds = gamePlayState.validIds.map((e) => e['id']).toList();
    
    if (widget.wordFoundController.isAnimating) {
      if (validIds.contains(widget.index)) {
        res = 1.0;
      } else {
        res = 0.0;
      }
    } else {
      res = 0.0;
    }
    return res * (animation.value);
  }    


  double shouldDisplayDeadTile(int index, Animation animation, GamePlayState gamePlayState, bool isAlive) {
    late double res = 0.0;
    if (!isAlive) {

      if (gamePlayState.killedTileIndex == index) {
        res = 1.0* (animation.value);
      } else {
        res = 1.0;
      }
    }
    return res;
  }
  double shouldDisplayStartAnimationTile(AnimationState animationState, GamePlayState gamePlayState) {
    return 1.0; 
  }


  @override
  Widget build(BuildContext context) {

    final ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);

    return Consumer<GamePlayState>(
      builder: (context, gamePlayState, child) {

        final double tileSize = gamePlayState.tileSize;
        final Map<dynamic,dynamic> tileObject = gamePlayState.tileState.firstWhere((element) => element['index'] == widget.index);
        final int row = int.parse(tileObject['tileId'].split("_")[0]);
        final int col = int.parse(tileObject['tileId'].split("_")[1]);
        final String body = tileObject["letter"];
        return Positioned(
          top: ((tileSize * 1.5) + ((tileSize) / 2)) + ((row - 1) * tileSize),
          left: (col - 1) * tileSize,
          child: Container(
            width: tileSize,
            height: tileSize,
            child: Stack(
              children: [
                // SMALL ANIMATION PLAYED WHEN A USER DROPS THE TILE
                Positioned(
                  top: 0,
                  left: 0,
                  child: AnimatedBuilder(
                    animation: widget.tileDroppedController,
                    builder: (context, child) {
                      String dropBody = "";
                      if (gamePlayState.draggedReserveTile.isNotEmpty) {
                        dropBody = gamePlayState.draggedReserveTile['body'];
                      }
                      return Container(
                        width: tileSize*  shouldDisplayDroppedTile(body, widget.index, gamePlayState, animationState) ,
                        height: tileSize * shouldDisplayDroppedTile(body, widget.index, gamePlayState, animationState),
                        // color: Colors.pink.withOpacity(reserveTileDroppedAnimation.value),
                        decoration: shouldDisplayDroppedTileBoxDecoration(body, widget.index, gamePlayState, animationState),
                        child: Center(
                          child: Text(dropBody),
                        ),
                      );
                    }
                  ) 
                ),   

                /// DECORATIVE TILE THAT LEAVES WHEN TAPPED
                AnimatedBuilder(
                  animation: Listenable.merge([widget.tileTappedController,widget.wordFoundController]) ,
                  builder: (context,child) {

                    double tileSizeAnim = tileSize*0.9 * shouldDisplayLeavingTile(
                      widget.index,
                      tileTappedHideEmptyTileAnimation,
                      widget.wordFoundSizeAnimation2,
                      animationState ,
                      gamePlayState
                    ); 
                    double top = (tileSize*0.9 - tileSizeAnim*0.9)/2;
                    double left = (tileSize*0.9 - tileSizeAnim*0.9)/2;
                    return Positioned(
                      // duration: const Duration(milliseconds: 100),
                      top: top,
                      left: left,
                      child: IgnorePointer(
                        // ignoring: animationState.shouldRunTileTappedAnimation,
                        ignoring: false,
                        child: Container(
                          width: tileSizeAnim,
                          height: tileSizeAnim,
                          decoration: Decorations().getEmptyTileDecoration(tileSizeAnim*0.9,palette,tileObject['shade'],tileObject['angle']),
                          child: Center(
                            child: Text(""),
                          ),
                        ),
                      ) 
                    );
                  }
                ),

                /// EMPTY TILE WIDGET
                Builder(
                  builder: (context) {
                    double tileSizeAnim = tileSize*0.9 * shouldDisplayEmptyTile(body,widget.index, gamePlayState, animationState);
                    return Positioned(
                      top: (tileSize - tileSizeAnim)/2,
                      left: (tileSize - tileSizeAnim)/2,
                      child: IgnorePointer(
                        ignoring: animationState.shouldRunTileTappedAnimation || shouldIgnoreTap(widget.index, gamePlayState),
                        // ignoring: false,
                        child: GestureDetector(
                          onTapDown: (details) => GameLogic().tileTapDownBehavior(gamePlayState,animationState,widget.index),
                          onTapUp: (details) => GameLogic().tileTapUpBehavior(context, gamePlayState, animationState,widget.index),
                          onTapCancel: () => GameLogic().tileTapCancelBehavior(gamePlayState),
                          child: Container(
                            width: tileSizeAnim,
                            height: tileSizeAnim,
                            color: Colors.transparent,
                            child: Center(
                              child: Text(body),
                            ),
                          )
                        ),
                      ),
                    );
                  }
                ), 
                /// CONTAINER FOR ACCEPTING THE DROPPED TILE
                Positioned(
                  top: (tileSize - tileSize*0.9)/2,
                  left: (tileSize - tileSize*0.9)/2,
                  child: IgnorePointer(
                    ignoring: gamePlayState.draggedReserveTile.isEmpty,
                    child: DragTarget(
                      onAcceptWithDetails: (details) {
                        GameLogic().dropDraggedTileBehavior(context, gamePlayState,animationState,widget.index);
                      }, 
                      builder: (BuildContext context, List<dynamic> accepted, List<dynamic> rejected) {
                        return Container(
                          width: tileSize*0.9,
                          height: tileSize*0.9,
                        );
                      }
                    ),
                  )
                ),

                // DEAD TILE
                AnimatedBuilder(
                  animation: widget.killTileAnimation,
                  builder: (context,child) {
                    bool isAlive = tileObject['alive'];
                    double deadTileOpacity = shouldDisplayDeadTile(widget.index,widget.killTileAnimation, gamePlayState,isAlive);
                    return Positioned(
                      top: 0,
                      left: 0,
                      child: IgnorePointer(
                        ignoring: isAlive,
                        child: Container(
                          width: tileSize,
                          height: tileSize,
                          child: Center(
                            child: Container(
                              width: tileSize*0.9,
                              height: tileSize*0.9,
                              decoration: Decorations().getDeadTileDecoration(tileSize,deadTileOpacity,palette),
                              child: Text(""),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                ), 

                // POPULATED TILE WIDGET

                Container(
                  width: tileSize * shouldDisplayPopulatedTile(body),
                  height: tileSize * shouldDisplayPopulatedTile(body),
                  child: Stack(
                    children: [          
                      Positioned(
                        top:(tileSize * shouldDisplayPopulatedTile(body)*0.05), // to center, equals to (tileSize-tileSize*0.9)/2
                        left: (tileSize * shouldDisplayPopulatedTile(body)*0.05), // to center, equals to (tileSize-tileSize*0.9)/2
                        
                        child: Container(
                          width: tileSize * shouldDisplayPopulatedTile(body)*0.9,
                          height: tileSize * shouldDisplayPopulatedTile(body)*0.9,
                          // decoration: body == "" ? Decorations().getEmptyTileDecoration() : Decorations().getTileDecoration(),
                          decoration: Decorations().getTileDecoration(tileSize * shouldDisplayPopulatedTile(body)*0.9,palette,tileObject['shade'],tileObject['angle']),
                          child: Center(
                            child: Text(
                              body,
                              style: TextStyle(
                                fontSize: tileSize * shouldDisplayPopulatedTile(body)*0.9*0.5, 
                                color: palette.fullTileTextColor, // Color.fromRGBO(64, 64, 64, 1),
                              ),
                            ),
                          ),
                        ),
                      ),                  
                    ],
                  ),
                ),                 

                  // TileWidgetLayout(
                  //   tileSize: tileSize * shouldDisplayPopulatedTile(body),
                  //   body: body,
                  //   // decoration: Decorations().getTileDecoration(gamePlayState.tileSize,palette,tileObject['shade'],tileObject['angle']),
                  //   decoration: Decorations().getTileDecoration(tileSize*0.9,palette,tileObject['shade'],tileObject['angle']),
                  // ),                
                // Positioned(
                //   top: (tileSize - tileSize*0.9)/2,
                //   left: (tileSize - tileSize*0.9)/2,
                //   child: TileWidgetLayout(
                //     tileSize: tileSize*0.9 * shouldDisplayPopulatedTile(body),
                //     body: body,
                //     decoration: Decorations().getTileDecoration(gamePlayState.tileSize,palette),

                //   ),
                  // child: Container(
                  //   width: tileSize*0.9 * shouldDisplayPopulatedTile(body),
                  //   height: tileSize*0.9 * shouldDisplayPopulatedTile(body),
                  //   decoration: Decorations().getTileDecoration(gamePlayState.tileSize,palette),
                  //   child: Center(
                  //     child: Text(
                  //       body,
                  //       style: TextStyle(
                  //         fontSize: tileSize*0.9*0.4,
                  //         color: palette.fullTileTextColor
                  //       ),
                  //     ),
                  //   ),
                  // ) 
                // ),  

                // / WORD FOUND ANIMATION
                Consumer<AnimationState>(
                  builder: (context,animationState, child) {
                    late String alternateBody =getFoundWordBody(gamePlayState, widget.index);
                    return AnimatedBuilder(
                      animation: widget.wordFoundController,
                      builder: (context,child) {
                        double tileSizeAnim = tileSize*0.9 * shouldDisplayConsumeTile(gamePlayState,animationState,widget.wordFoundSizeAnimation);
                        return Positioned(
                          top: (tileSize - tileSizeAnim)/2,
                          left: (tileSize - tileSizeAnim)/2,
                          child: Container(
                            width: tileSizeAnim.roundToDouble(),
                            height: tileSizeAnim.roundToDouble(),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular((tileSizeAnim*0.20).roundToDouble())),
                              border: Border.all(
                                color: widget.wordFoundColorAnimation.value as Color,
                                width: (tileSizeAnim*0.07).roundToDouble()
                              )
                            ),
                            child: Center(
                              child: Text(
                                alternateBody,
                                style: TextStyle(
                                  fontSize: (tileSizeAnim*0.4)*widget.wordFoundSizeAnimation.value,
                                  color: widget.wordFoundColorAnimation.value,
                                ),
                              ),
                            ),
                          ) 
                        );
                      }
                    );
                  }
                ),    
              ],
            ),
          )
        );
      }
    );
  }
}

String getFoundWordBody(GamePlayState gamePlayState, int index) {
  List<dynamic> validIds = gamePlayState.validIds.map((e) => e['id']).toList();
  late String res = "";
  if (validIds.contains(index)) {
    res = gamePlayState.validIds.firstWhere((element) => element['id'] == index)['body'];
  }
  return res;
}


List<TweenSequenceItem<Color?>> getWordFoundColorSequence(int index, List<Color> colors, int duration, int delay) {
  double delayIncrement = delay/duration;
  double delayWeight = 0.01 +  (delayIncrement*100) * index; 
  double middleWeight = 60.0;
  double endWeight = 100.0 - (delayWeight + middleWeight);

  List<TweenSequenceItem<Color?>> res =  [
    TweenSequenceItem(tween: ColorTween(begin: colors[1], end: colors[1],), weight: delayWeight),

    TweenSequenceItem(tween: ColorTween(begin: colors[1], end: colors[2],), weight: 15.0),
    TweenSequenceItem(tween: ColorTween(begin: colors[2], end: colors[1],), weight: 15.0),
    TweenSequenceItem(tween: ColorTween(begin: colors[1], end: colors[2],), weight: 15.0),      
    TweenSequenceItem(tween: ColorTween(begin: colors[2], end: colors[1],), weight: 15.0),

    TweenSequenceItem(tween: ColorTween(begin: colors[1], end: colors[0],), weight: endWeight),
                  
  ];
  return res; 
}

bool shouldIgnoreTap(int index, GamePlayState gamePlayState) {
  late bool res = true;
  if (gamePlayState.selectedTileIndex > -1) {
    if (gamePlayState.selectedTileIndex == index) {
   
      res = false;
    } else {
      res = true;
    }
  } else {
    if (gamePlayState.selectedReserveIndex > -1) {
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