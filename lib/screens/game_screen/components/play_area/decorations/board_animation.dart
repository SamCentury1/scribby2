import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/game_logic_2.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/play_area/decorations/decorations.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';


class BoardAnimation extends StatefulWidget {
  final AnimationController gameStartedController;
  const BoardAnimation({super.key, required this.gameStartedController});

  @override
  State<BoardAnimation> createState() => _BoardAnimationState();
}

class _BoardAnimationState extends State<BoardAnimation> {

  List<Widget> getStartAnimationBoard(GamePlayState gamePlayState, AnimationState animationState, AnimationController animationController) {

    late List<Widget> elements = [];
    StartAnimationRandomLetter1 randomLetter1 = StartAnimationRandomLetter1(startAnimationController:animationController,isStart: !gamePlayState.isGameOver,);
    StartAnimationRandomLetter2 randomLetter2 = StartAnimationRandomLetter2(startAnimationController:animationController,isStart: !gamePlayState.isGameOver,);
    StartAnimationTimer startAnimationTimer = StartAnimationTimer(startAnimationController: animationController,isStart: !gamePlayState.isGameOver,);
    elements.insert(0, startAnimationTimer);
    elements.insert(1, randomLetter1);
    elements.insert(2, randomLetter2);

    for (int i=0; i<36; i++) {
      Widget reserveTile = StartAnimationTile(isStart: !gamePlayState.isGameOver, id:i, index: i+3, animationController:animationController ,);
      elements.add(reserveTile);
    }        

    for (int i=0; i<5; i++) {
      Widget reserveTile = StartAnimationReserveTile(id:i, index: i+39, startAnimationController:animationController,isStart: !gamePlayState.isGameOver,);
      elements.add(reserveTile);
    }    
    return elements;
  }



  @override
  Widget build(BuildContext context) {
    // late AnimationState animationState = Provider.of<AnimationState>(context,listen: false);
    return Consumer<GamePlayState>(
      builder: (context,gamePlayState,child) {
        return Consumer<AnimationState>(
          builder: (context,animationState,child) {
            List<Widget> elements = getStartAnimationBoard(gamePlayState,animationState,widget.gameStartedController);
            return Stack(children: elements,);
          }
        );
      },
    );
  }
}








class StartAnimationTile extends StatefulWidget {
  final int id;
  final int index;
  final AnimationController animationController;
  final bool isStart;
  const StartAnimationTile({
    super.key,
    required this.id,
    required this.index,
    required this.animationController,
    required this.isStart
  });

  @override
  State<StartAnimationTile> createState() => _StartAnimationTileState();
}

class _StartAnimationTileState extends State<StartAnimationTile> with SingleTickerProviderStateMixin{

  late Animation<double> startAnimationSize;


  @override
  void initState() {
    super.initState();
    initializeAnimations(widget.animationController);
  }
  void initializeAnimations(AnimationController animationController) {
    final int order = animationOrder[widget.index] as int;
    List<TweenSequenceItem<double>> startAnimationSequence = getStartAnimationSequence(widget.isStart,order);
    startAnimationSize = TweenSequence<double>(startAnimationSequence)
    .animate(animationController);  
     
  }

  BoxDecoration getTileDecoration(bool isStart, bool isAlive,double tileSizeAnim, ColorPalette palette, int shade, int angle) {
    late BoxDecoration res = Decorations().getEmptyTileDecoration(tileSizeAnim,palette,shade,angle);
    if (isStart) {
      res = Decorations().getEmptyTileDecoration(tileSizeAnim,palette,shade,angle);
    } else {
      if (isAlive) {
        res = Decorations().getTileDecoration(tileSizeAnim,palette,shade,angle);
      } else {
        res = Decorations().getDeadTileDecoration(tileSizeAnim, 1.0,palette);
      }
    }
    return res;
  }
  

  @override
  Widget build(BuildContext context) {
    late ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
    return Consumer<GamePlayState>(


      builder: (context, gamePlayState, child) {
        final Map<dynamic,dynamic> tileObject = gamePlayState.tileState.firstWhere((element) => element['index'] == widget.id);
        final int row = int.parse(tileObject['tileId'].split("_")[0]);
        final int col = int.parse(tileObject['tileId'].split("_")[1]);
        final String body = tileObject["letter"];
        final bool isAlive = tileObject['alive'];
      //   final List<dynamic> validIds = gamePlayState.validIds.map((element) => element['id']).toList();
      //        
        final double tileSize = gamePlayState.tileSize;
        final double top = (tileSize * 2) + ((row - 1) * tileSize);
        final double left =  ((col - 1) * tileSize);
        return Positioned(
          top: top,
          left: left,
          child: Container(
            width: tileSize,
            height: tileSize, 
            // color: Colors.red,
            child: Center(
              child: Container(
                width: tileSize*0.9,
                height: tileSize*0.9,
                child : Stack(
                  children: [
                    AnimatedBuilder(
                      animation: widget.animationController,
                      builder: (context,child) {
                        double tileSizeAnim = tileSize*0.9 * startAnimationSize.value;
                        double top = (tileSize*0.9 - tileSizeAnim)/2;
                        double left = (tileSize*0.9 - tileSizeAnim)/2;
                        return Positioned(
                          top: top,
                          left: left,
                          child: Container(
                            width: tileSizeAnim,
                            height: tileSizeAnim,
                            // color: Colors.blue,
                            // decoration: widget.isStart ? Decorations().getEmptyTileDecoration(tileSizeAnim) : Decorations().getTileDecoration(tileSizeAnim) ,
                            decoration: getTileDecoration(widget.isStart, isAlive, tileSizeAnim*0.9,palette, tileObject['shade'], tileObject['angle']),
                            child: Center(
                              child: Text(
                                body,
                                style: TextStyle(
                                  fontSize: tileSizeAnim*0.9*0.5,
                                  color: palette.fullTileTextColor
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    )
                  ]
                )
              )
            ),
          ),
        );
      }      
    );
  }
}



class StartAnimationTimer extends StatefulWidget {
  final AnimationController startAnimationController;
  final bool isStart;
  const StartAnimationTimer({super.key, required this.startAnimationController, required this.isStart});

  @override
  State<StartAnimationTimer> createState() => _StartAnimationTimerState();
}

class _StartAnimationTimerState extends State<StartAnimationTimer> with SingleTickerProviderStateMixin {

  late Animation<double> startAnimation;

  @override
  void initState() {
    super.initState();
    initializeAnimations(widget.startAnimationController);
  }
  void initializeAnimations(AnimationController animationController) {
    List<TweenSequenceItem<double>> startAnimationSequence = getStartAnimationSequence(widget.isStart, 0);
    startAnimation = TweenSequence<double>(startAnimationSequence)
    .animate(animationController);    
  }

  @override
  Widget build(BuildContext context) {
    late ColorPalette palette = Provider.of<ColorPalette>(context,listen: false);
    return Consumer<GamePlayState>(
      builder: (context,gamePlayState,child) {

        double containerWidth = gamePlayState.tileSize*2;
        double diameter = gamePlayState.tileSize*1.5;

        return Container(
          width: containerWidth,
          height: containerWidth,
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: widget.startAnimationController,
                builder: (context,child) {
                  return Positioned(
                    top: (containerWidth-diameter)/2,
                    left: (containerWidth-diameter)/2,
                    child: Container(
                      width: diameter,
                      height: diameter,                  
                      child: CircularCountDownTimer(
                        duration: 5,
                        initialDuration:  0,
                        controller: gamePlayState.countDownController,
                        width: diameter,//gamePlayState.tileSize*2,
                        height: diameter,// gamePlayState.tileSize*2,// MediaQuery.of(context).size.height / 3,
                        // ringColor: Color.fromARGB(164, 36, 85, 190),
                        // ringGradient: LinearGradient(colors: [Colors.blue.withOpacity(startAnimation.value), Colors.orange.withOpacity(startAnimation.value)]),
                        // fillColor: Colors.transparent,
                        backgroundColor:Colors.transparent,

                        ringColor: palette.timerRingColor.withOpacity(startAnimation.value),
                        ringGradient: LinearGradient(
                          colors: [
                            palette.timerRingGradient1.withOpacity(startAnimation.value),
                            palette.timerRingGradient2.withOpacity(startAnimation.value),
                          ]
                        ),
                        fillColor: palette.timerFillColor.withOpacity(startAnimation.value),
                        fillGradient: LinearGradient(
                          colors: [
                            palette.timerFillGradient1.withOpacity(startAnimation.value),
                            palette.timerFillGradient1.withOpacity(startAnimation.value),
                          ]
                        ),                        
                        backgroundGradient: null,
                        strokeWidth: gamePlayState.tileSize*0.10,
                        strokeCap: StrokeCap.round,
                        textFormat: CountdownTextFormat.S,
                        isReverse: true,
                        isReverseAnimation: false,
                        isTimerTextShown: false,
                        autoStart: false,
                        onStart: (){
                          gamePlayState.countDownController.pause();
                        },
                        onChange: (String timeStamp) {},                            
                      ),
                    ),
                  );
                }
              ),
            ],
          ),            
        );
      }
    );
  }
}


class StartAnimationRandomLetter1 extends StatefulWidget {
  final AnimationController startAnimationController;
  final bool isStart;
  const StartAnimationRandomLetter1({
    super.key,
    required this.startAnimationController,
    required this.isStart
  });
  @override
  State<StartAnimationRandomLetter1> createState() => _StartAnimationRandomLetter1State();
}

class _StartAnimationRandomLetter1State extends State<StartAnimationRandomLetter1> with SingleTickerProviderStateMixin {
  late AnimationState animationState;
  late Animation<double> startAnimation; 
  
  @override
  void initState() {
    super.initState();
    initializeAnimations(widget.startAnimationController);
  }  

  void initializeAnimations(AnimationController animationController) {
    List<TweenSequenceItem<double>> startAnimationSequence = getStartAnimationSequence(widget.isStart, 1);
    startAnimation = TweenSequence<double>(startAnimationSequence)
    .animate(animationController);
  }  
  @override
  Widget build(BuildContext context) {

    late ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
    return AnimatedBuilder(
      animation: widget.startAnimationController,
      builder: (context,child) {
        return Consumer<GamePlayState>(
          builder: (context,gamePlayState,child) {
            String letter = GameLogic().displayRandomLetters(gamePlayState.randomLetterList,2);
            int shade = GameLogic().displayRandomLetterStyle(gamePlayState.randomShadeList,2);
            int angle = GameLogic().displayRandomLetterStyle(gamePlayState.randomAngleList,2);
            return Positioned(
              top: ((gamePlayState.tileSize*2)-(gamePlayState.tileSize*1.5*startAnimation.value))/2,
              left: ((gamePlayState.tileSize*6)-(gamePlayState.tileSize*1.5*startAnimation.value))/2,
              child: Container(
                width: gamePlayState.tileSize*1.5*startAnimation.value,
                height: gamePlayState.tileSize*1.5*startAnimation.value,
                child: Center(
                  child: Stack(
                    children: [          
                      Positioned(
                        top:(gamePlayState.tileSize*1.5*startAnimation.value*0.05), // to center, equals to (tileSize-tileSize*0.9)/2
                        left: (gamePlayState.tileSize*1.5*startAnimation.value*0.05), // to center, equals to (tileSize-tileSize*0.9)/2
                        
                        child: Container(
                          width: gamePlayState.tileSize*1.5*startAnimation.value*0.9,
                          height: gamePlayState.tileSize*1.5*startAnimation.value*0.9,
                          // decoration: body == "" ? Decorations().getEmptyTileDecoration() : Decorations().getTileDecoration(),
                          decoration: Decorations().getTileDecoration(gamePlayState.tileSize*1.5*0.9*startAnimation.value,palette,shade,angle),
                          child: Center(
                            child: Text(
                              letter,
                              style: TextStyle(
                                fontSize: gamePlayState.tileSize*1.5*startAnimation.value*0.9*0.5, 
                                color: palette.fullTileTextColor, // Color.fromRGBO(64, 64, 64, 1),
                              ),
                            ),
                          ),
                        ),
                      ),                  
                    ],
                  ),
                ),                
                // child: TileWidgetLayout(

                 
                //   tileSize: gamePlayState.tileSize*1.5*startAnimation.value,
                //   // body: gamePlayState.randomLetterList[gamePlayState.randomLetterList.length-2],
                //   body: letter,
                //   decoration: Decorations().getTileDecoration(gamePlayState.tileSize*startAnimation.value,palette,shade,angle),
                // ),
              )
            );
          }
        );
      }
    );    
  }
}



class StartAnimationRandomLetter2 extends StatefulWidget {
  final AnimationController startAnimationController;
  final bool isStart;  
  const StartAnimationRandomLetter2({
    super.key,
    required this.startAnimationController,
    required this.isStart,
  });

  @override
  State<StartAnimationRandomLetter2> createState() => _StartAnimationRandomLetter2State();
}

class _StartAnimationRandomLetter2State extends State<StartAnimationRandomLetter2> with SingleTickerProviderStateMixin {
  late Animation<double> startAnimation;
  @override
  void initState() {
    super.initState();
    initializeAnimations(widget.startAnimationController);
  }  

  void initializeAnimations(AnimationController animationController) {
    List<TweenSequenceItem<double>> startAnimationSequence = getStartAnimationSequence(widget.isStart, 2);
    startAnimation = TweenSequence<double>(startAnimationSequence)
    .animate(animationController);
  }

  @override
  Widget build(BuildContext context) {
    late ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
    return AnimatedBuilder(
      animation: widget.startAnimationController,
      builder: (context,child) {
        return Consumer<GamePlayState>(
          builder: (context,gamePlayState,child) {
            String letter = GameLogic().displayRandomLetters(gamePlayState.randomLetterList,1);
            int shade = GameLogic().displayRandomLetterStyle(gamePlayState.randomShadeList,1);
            int angle = GameLogic().displayRandomLetterStyle(gamePlayState.randomAngleList,1);
            return Positioned(
              top: ((gamePlayState.tileSize*2)-(gamePlayState.tileSize*1.05*startAnimation.value))/2,
              left: (gamePlayState.tileSize*4) + (((gamePlayState.tileSize*2)-(gamePlayState.tileSize*startAnimation.value))/2),
              child: Container(
                width: gamePlayState.tileSize*startAnimation.value,
                height: gamePlayState.tileSize*startAnimation.value,
                child: Center(
                  child: Container(
                    width: gamePlayState.tileSize*startAnimation.value,
                    height: gamePlayState.tileSize*startAnimation.value,
                    child: Stack(
                      children: [          
                        Positioned(
                          top:(gamePlayState.tileSize*startAnimation.value*0.05), // to center, equals to (tileSize-tileSize*0.9)/2
                          left: (gamePlayState.tileSize*startAnimation.value*0.05), // to center, equals to (tileSize-tileSize*0.9)/2
                          
                          child: Container(
                            width: gamePlayState.tileSize*startAnimation.value*0.9,
                            height: gamePlayState.tileSize*startAnimation.value*0.9,
                            // decoration: body == "" ? Decorations().getEmptyTileDecoration() : Decorations().getTileDecoration(),
                            decoration: Decorations().getTileDecoration(gamePlayState.tileSize*0.9*startAnimation.value,palette,shade,angle),
                            child: Center(
                              child: Text(
                                letter,
                                style: TextStyle(
                                  fontSize: gamePlayState.tileSize*startAnimation.value*0.9*0.5, 
                                  color: palette.fullTileTextColor, // Color.fromRGBO(64, 64, 64, 1),
                                ),
                              ),
                            ),
                          ),
                        ),                  
                      ],
                    ),
                  ),
                ),                 
                // child: TileWidgetLayout(
                //   // tileSize: widget.tileSize*1.5, 
                //   tileSize: gamePlayState.tileSize*startAnimation.value,
                //   // body: gamePlayState.randomLetterList[gamePlayState.randomLetterList.length-1],
                //   body: letter,
                //   decoration: Decorations().getTileDecoration(gamePlayState.tileSize*startAnimation.value,palette,shade,angle),
                // ),
              )
            );
          }
        );
      }
    );    
  }
}


class StartAnimationReserveTile extends StatefulWidget {
  final int id;
  final int index;
  final AnimationController startAnimationController;
  final bool isStart;  
  const StartAnimationReserveTile({
    super.key,
    required this.id,
    required this.index, 
    required this.startAnimationController,
    required this.isStart,
  });

  @override
  State<StartAnimationReserveTile> createState() => _StartAnimationReserveTileState();
}

class _StartAnimationReserveTileState extends State<StartAnimationReserveTile> with SingleTickerProviderStateMixin {

  late Animation<double> startAnimationSize;
  @override
  void initState() {
    super.initState();
    initializeAnimations(widget.startAnimationController);
  }  

  void initializeAnimations(AnimationController animationController) {
    // List<TweenSequenceItem<double>> startAnimationSequence = getStartAnimationSequence(widget.index);
    final int order = animationOrder[widget.index] as int;
    List<TweenSequenceItem<double>> startAnimationSequence = getStartAnimationSequence(widget.isStart, order);
    startAnimationSize = TweenSequence<double>(startAnimationSequence)
    .animate(animationController);
  }

  // BoxDecoration getBoxDecoration(String body, bool isStart, double tileSize, ColorPalette palette) {
  //   late BoxDecoration res = Decorations().getTileDecoration(tileSize,palette,0,0);
  //   if (isStart) {
  //     res = Decorations().getEmptyReserveDecoration(tileSize,palette);
  //   } else {
  //     if (body == "") {
  //       res = Decorations().getEmptyReserveDecoration(tileSize,palette);
  //     }
  //   }
  //   return res;
  // }

  @override
  Widget build(BuildContext context) {
    late ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
    return Consumer<GamePlayState>(
      builder: (context, gamePlayState, child) {
        final Map<String,dynamic> reserveObject = gamePlayState.reserveTiles.firstWhere((element) => element['id'] == widget.id);
        final String body = reserveObject['body'];
        final double tileSize = gamePlayState.tileSize;
        final double top = tileSize*8.1;
        final double left =  (tileSize*6 - tileSize*0.8*5)/2 + (tileSize*0.8*widget.id);
        final int shade = reserveObject['shade'];
        final int angle = reserveObject['angle'];
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
                      animation: widget.startAnimationController,
                      builder: (context,child) {
                        double tileSizeAnim = tileSize*0.75 * startAnimationSize.value;
                        double top = (tileSize*0.75 - tileSizeAnim)/2;
                        double left = (tileSize*0.75 - tileSizeAnim)/2;

                        // return Positioned(
                        //   top: top,
                        //   left: left,                          
                        //   child: TileWidgetLayout(                           
                        //     tileSize: tileSizeAnim,
                        //     body: body,
                        //     decoration: body == ""
                        //     ? Decorations().getEmptyReserveDecoration(tileSize*0.75*startAnimationSize.value,palette)
                        //     : Decorations().getFullReserveDecoration(tileSize*0.75*startAnimationSize.value,palette),
                        //   ),
                        // );
                        return Positioned(
                          top: top,
                          left: left,
                          child: Container(
                            width: tileSizeAnim,
                            height: tileSizeAnim,
                            // color: Colors.blue,
                            // decoration: getBoxDecoration(body, widget.isStart,tileSizeAnim,palette),
                            decoration: body == ""
                            ? Decorations().getEmptyReserveDecoration(tileSizeAnim,palette)
                            : Decorations().getFullReserveDecoration(tileSizeAnim,palette,shade,angle),                            
                            child: Center(
                              child: Text(
                                body,
                                style: TextStyle(
                                  fontSize: tileSizeAnim*0.9*0.4,
                                  color: palette.fullTileTextColor
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    )
                  ]
                )
              )
            ),
          ),
        );
      }
    );
  }
}

List<TweenSequenceItem<double>> getStartAnimationSequence(bool isStart, int index) {
  double delayWeight = 0.01 + (((index )/44) * 92);
  double mainWeight = 10;
  double endWeight = (100 - (delayWeight+mainWeight));
  double start = isStart ? 0.0 : 1.0;
  double end = isStart ? 1.0 : 0.0;

  List<TweenSequenceItem<double>> getStartAnimationSequence = [
    TweenSequenceItem(tween: Tween(begin: start, end: start,), weight: delayWeight),
    TweenSequenceItem(tween: Tween(begin: start, end: end,), weight: mainWeight),
    TweenSequenceItem(tween: Tween(begin: end, end: end,), weight: endWeight),
  ];


  return getStartAnimationSequence;
}


final Map<int,int> animationOrder = {
  0:0,
  1:1,
  2:2,
  3:8,
  4:7,
  5:6,
  6:5,
  7:4,
  8:3,
  9:9,
  10:10,
  11:11,
  12:12,
  13:13,
  14:14,
  15:20,
  16:19,
  17:18,
  18:17,
  19:16,
  20:15,
  21:21,
  22:22,
  23:23,
  24:24,
  25:25,
  26:26,
  27:32,
  28:31,
  29:30,
  30:29,
  31:28,
  32:27,
  33:33,
  34:34,
  35:35,
  36:36,
  37:37,
  38:38,
  39:43,
  40:42,
  41:41,
  42:40,
  43:39,
};

