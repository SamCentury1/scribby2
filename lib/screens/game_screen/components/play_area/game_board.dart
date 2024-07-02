import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/play_area/decorations/new_points.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/play_area/random_letters/random_letter_1.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/play_area/random_letters/random_letter_2.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/play_area/random_letters/timer_widget.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/play_area/reserves/reserve_tile.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/play_area/tiles/main_tile_container.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/play_area/tiles/travelling_tile.dart';

class GameBoard extends StatefulWidget {
  final AnimationController wordFoundController;
  const GameBoard({super.key, required this.wordFoundController});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> with TickerProviderStateMixin {
  late AnimationState animationState;
  late GamePlayState gamePlayState;

  /// WORD FOUND CONTROLLER
  // late AnimationController wordFoundController;
  late Animation<Color?> wordFoundColor1;
  late Animation<Color?> wordFoundColor2;
  late Animation<Color?> wordFoundColor3;
  late Animation<Color?> wordFoundColor4;   
  late Animation<Color?> wordFoundColor5;
  late Animation<Color?> wordFoundColor6;

  late Animation<double> wordFoundSize1;
  late Animation<double> wordFoundSize2;
  late Animation<double> wordFoundSize3;
  late Animation<double> wordFoundSize4;   
  late Animation<double> wordFoundSize5;
  late Animation<double> wordFoundSize6;

  late Animation<double> wordFoundEmptySize1;
  late Animation<double> wordFoundEmptySize2;
  late Animation<double> wordFoundEmptySize3;
  late Animation<double> wordFoundEmptySize4;   
  late Animation<double> wordFoundEmptySize5;
  late Animation<double> wordFoundEmptySize6;  

  /// WORD FOUND --- HIDE EMPTY TILE DURING WORD FOUND ANIMATION THEN DISPLAY

  /// TILE TAPPED CONTROLLER
  late AnimationController tileTappedController;
  late AnimationController tileTappedExitController;
  

  /// TILE DROPPED CONTROLLER
  late AnimationController tileDroppedController;

  /// TIMER ANIMATION CONTROLLER
  late AnimationController timerController;
  late Animation timerAnimation;

  /// KILL TILE CONTROLLER
  late AnimationController killTileController;
  late Animation<double> killTileAnimation;



  @override
  void initState() {
    super.initState();
    animationState = Provider.of<AnimationState>(context,listen: false);
    gamePlayState = Provider.of<GamePlayState>(context,listen: false);
    animationState.addListener(handleAnimationStateChange);
    initializeAnimations(gamePlayState);
    

  }

  void initializeAnimations(GamePlayState gamePlayState) {

    const int duration = 2500;
    const int delay = 99;

    Color color_0 = Colors.transparent;
    Color color_1 = Colors.red;
    Color color_2 = Colors.yellow;
    List<Color> colors = [color_0,color_1,color_2];

    List<TweenSequenceItem<Color?>> wordFoundColorSequence1 = getWordFoundColorSequence(0, colors, duration, delay);
    wordFoundColor1 = TweenSequence<Color?>(wordFoundColorSequence1).animate(widget.wordFoundController);

    List<TweenSequenceItem<Color?>> wordFoundColorSequence2 = getWordFoundColorSequence(1, colors, duration, delay);
    wordFoundColor2 = TweenSequence<Color?>(wordFoundColorSequence2).animate(widget.wordFoundController);

    List<TweenSequenceItem<Color?>> wordFoundColorSequence3 = getWordFoundColorSequence(2, colors, duration, delay);
    wordFoundColor3 = TweenSequence<Color?>(wordFoundColorSequence3).animate(widget.wordFoundController);

    List<TweenSequenceItem<Color?>> wordFoundColorSequence4 = getWordFoundColorSequence(3, colors, duration, delay);
    wordFoundColor4 = TweenSequence<Color?>(wordFoundColorSequence4).animate(widget.wordFoundController);

    List<TweenSequenceItem<Color?>> wordFoundColorSequence5 = getWordFoundColorSequence(4, colors, duration, delay);
    wordFoundColor5 = TweenSequence<Color?>(wordFoundColorSequence5).animate(widget.wordFoundController);

    List<TweenSequenceItem<Color?>> wordFoundColorSequence6 = getWordFoundColorSequence(5, colors, duration, delay);
    wordFoundColor6 = TweenSequence<Color?>(wordFoundColorSequence6).animate(widget.wordFoundController);   

    List<TweenSequenceItem<double>> wordFoundSizeSequence1 = getWordFoundSizeSequence(0, duration, delay);
    wordFoundSize1 = TweenSequence<double>(wordFoundSizeSequence1).animate(widget.wordFoundController);

    List<TweenSequenceItem<double>> wordFoundSizeSequence2 = getWordFoundSizeSequence(1, duration, delay);
    wordFoundSize2 = TweenSequence<double>(wordFoundSizeSequence2).animate(widget.wordFoundController);

    List<TweenSequenceItem<double>> wordFoundSizeSequence3 = getWordFoundSizeSequence(2, duration, delay);
    wordFoundSize3 = TweenSequence<double>(wordFoundSizeSequence3).animate(widget.wordFoundController);

    List<TweenSequenceItem<double>> wordFoundSizeSequence4 = getWordFoundSizeSequence(3, duration, delay);
    wordFoundSize4 = TweenSequence<double>(wordFoundSizeSequence4).animate(widget.wordFoundController);

    List<TweenSequenceItem<double>> wordFoundSizeSequence5 = getWordFoundSizeSequence(4, duration, delay);
    wordFoundSize5 = TweenSequence<double>(wordFoundSizeSequence5).animate(widget.wordFoundController);

    List<TweenSequenceItem<double>> wordFoundSizeSequence6 = getWordFoundSizeSequence(5, duration, delay);
    wordFoundSize6 = TweenSequence<double>(wordFoundSizeSequence6).animate(widget.wordFoundController);

    List<TweenSequenceItem<double>> wordFoundEmptySizeSequence1 = getWordFoundEmptyTileSizeSequence(0, duration, delay);
    wordFoundEmptySize1 = TweenSequence<double>(wordFoundEmptySizeSequence1).animate(widget.wordFoundController);

    List<TweenSequenceItem<double>> wordFoundEmptySizeSequence2 = getWordFoundEmptyTileSizeSequence(1, duration, delay);
    wordFoundEmptySize2 = TweenSequence<double>(wordFoundEmptySizeSequence2).animate(widget.wordFoundController);

    List<TweenSequenceItem<double>> wordFoundEmptySizeSequence3 = getWordFoundEmptyTileSizeSequence(2, duration, delay);
    wordFoundEmptySize3 = TweenSequence<double>(wordFoundEmptySizeSequence3).animate(widget.wordFoundController);

    List<TweenSequenceItem<double>> wordFoundEmptySizeSequence4 = getWordFoundEmptyTileSizeSequence(3, duration, delay);
    wordFoundEmptySize4 = TweenSequence<double>(wordFoundEmptySizeSequence4).animate(widget.wordFoundController);

    List<TweenSequenceItem<double>> wordFoundEmptySizeSequence5 = getWordFoundEmptyTileSizeSequence(4, duration, delay);
    wordFoundEmptySize5 = TweenSequence<double>(wordFoundEmptySizeSequence5).animate(widget.wordFoundController);

    List<TweenSequenceItem<double>> wordFoundEmptySizeSequence6 = getWordFoundEmptyTileSizeSequence(5, duration, delay);
    wordFoundEmptySize6 = TweenSequence<double>(wordFoundEmptySizeSequence6).animate(widget.wordFoundController);                            




    timerController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync:this
    );
    List<TweenSequenceItem<double>> tweenSequence =  [
      TweenSequenceItem(tween: Tween(begin:0.0, end:1.0,), weight: 50),
      TweenSequenceItem(tween: Tween(begin:1.0, end:0.0,), weight: 50),     
    ];
    timerAnimation = TweenSequence(tweenSequence).animate(timerController);


    late int tileTappedDuration = 280;
    tileTappedController = AnimationController(
      duration: Duration(milliseconds: tileTappedDuration),
      vsync: this
    );

    tileTappedExitController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this
    );




    tileDroppedController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync:this
    );

    killTileController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync:this
    );
    killTileAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(killTileController);    


    killTileController.addListener(() {
      if (killTileController.isAnimating) {
        if (tileTappedController.isAnimating) {
          tileTappedController.forward(from: 1.0);
          tileTappedExitController.forward(from: 1.0);
          killTileController.forward(from: 1.0);
        }
        if (gamePlayState.isGamePaused) {
          print("you tried pausing while the tile was in the process of getting killed");
          gamePlayState.countDownController.pause();
          killTileController.forward(from: 1.0);
          animationState.setShouldRunTimerAnimation(false);
        }
      }

      
    });



  }



  void handleAnimationStateChange() {
    if (animationState.shouldRunWordFoundAnimation) {
      executeWordFoundAnimation();
    }


    if (animationState.shouldRunTimerAnimation) {
      executeTimerAnimation();
    }

    if (animationState.shouldRunTileTappedAnimation) {
      executeTileTappedAnimations();
    }

    if (animationState.shouldRunTileDroppedAnimation) {
      executeTileDroppedAnimations();
    }

    if (animationState.shouldRunKillTileAnimation) {
      executeKillTileAnimation();
    }


  }

  void executeWordFoundAnimation() {
    widget.wordFoundController.reset();
    widget.wordFoundController.forward();
  }

  void executeTimerAnimation() {
    timerController.reset();
    timerController.repeat();
  }

  void executeTileTappedAnimations() {
    tileTappedController.reset();
    tileTappedController.forward();

    tileTappedExitController.reset();
    tileTappedExitController.forward();
  }

  void executeTileDroppedAnimations() {
    tileDroppedController.reset();
    tileDroppedController.forward();
  }

  void executeKillTileAnimation() {
    killTileController.reset();
    killTileController.forward();
  }




  @override
  void dispose() {
    // wordFoundController.dispose();
    timerController.dispose();
    tileTappedController.dispose();
    tileTappedExitController.dispose();
    tileDroppedController.dispose();
    killTileController.dispose();
    animationState.removeListener(handleAnimationStateChange);
    super.dispose();
  }

  List<Widget> getBoardTiles(
    GamePlayState gamePlayState, 
    AnimationState animationState, 
    List<Animation<Color?>> colorAnimations, 
    List<Animation<double>> sizeAnimations,
    List<Animation<double>> sizeAnimations2,
    Animation<double> killTileAnimation,
    ) {

    Map<int,dynamic> orders =  Helpers().getTileAnimationOrder(gamePlayState);

    List<Widget> elements = List.generate(36, (index) {
        List<int> uniqueIds = Helpers().getUniqueValidIds(gamePlayState.validIds);
        int idIndex = uniqueIds.indexOf(index);
        if (index == gamePlayState.droppedTileIndex) {
          return const SizedBox();
        } else {
          int order = 0;
          if (idIndex > -1) {
            order = orders[index];
          }
          return MainTileContainer(
            index: index, 
            wordFoundController: widget.wordFoundController, 
            tileTappedController: tileTappedController,
            tileTappedExitController: tileTappedExitController,
            tileDroppedController: tileDroppedController,
            wordFoundColorAnimation: colorAnimations[order],
            wordFoundSizeAnimation: sizeAnimations[order],
            wordFoundSizeAnimation2: sizeAnimations2[order],
            killTileAnimation: killTileAnimation,
          );
        }        
    });



    if (gamePlayState.droppedTileIndex >= 0 ) {
      elements.removeAt(gamePlayState.droppedTileIndex);
      Widget newWidget = MainTileContainer(
        index: gamePlayState.droppedTileIndex, 
        wordFoundController: widget.wordFoundController,
        tileTappedController: tileTappedController,
        tileTappedExitController: tileTappedExitController,
        tileDroppedController: tileDroppedController,
        wordFoundColorAnimation: colorAnimations[0],
        wordFoundSizeAnimation: sizeAnimations[0],
        wordFoundSizeAnimation2: sizeAnimations2[0],
        killTileAnimation: killTileAnimation,
      );
      elements.add(newWidget);
    }



    // Widget mainTile = RandomLetter1(tileSize: tileSize);
    Widget mainTile = RandomLetter1(tileTappedController: tileTappedController,);
    Widget secondaryTile = RandomLetter2(tileTappedController: tileTappedController,);



    Widget decorationTileEnter = SizedBox();
    Widget newPointsWidget = SizedBox();

    for (Map<dynamic,dynamic> reserveTileObject in gamePlayState.reserveTiles) {
      int reserveTileId = reserveTileObject['id'];
      Widget reserveTile = ReserveTile(index: reserveTileId);
      elements.add(reserveTile);
    }

    if (gamePlayState.selectedTileIndex >= 0 || animationState.shouldRunTileTappedAnimation) {
      decorationTileEnter = TravellingTile(element: "tile", tileTappedController: tileTappedController,);
    }    
    if (gamePlayState.selectedReserveIndex >= 0) {
      decorationTileEnter = TravellingTile(element: "reserve", tileTappedController: tileTappedController,);
    }

    late Offset coords = Offset.zero;
    if (gamePlayState.validIds.isNotEmpty) {
      Map<dynamic,dynamic> tileObject = gamePlayState.tileState.firstWhere((element) => element['index']==gamePlayState.validIds[0]['id']);
      int row = int.parse(tileObject['tileId'].split("_")[0]);
      int col = int.parse(tileObject['tileId'].split("_")[1]);

      double tileSize = gamePlayState.tileSize;
      double top = ((tileSize * 1.5) + ((tileSize) / 2)) + ((row - 1) * tileSize);
      double left = (col - 1) * tileSize;
      coords = Offset(left,top); 
    }
    newPointsWidget = NewPoints(wordFoundController: widget.wordFoundController, coords: coords);


    Widget timerWidget = TimerWidget(timerController: timerController, timerAnimation: timerAnimation,);
    elements.insert(0, timerWidget);

    elements.add(decorationTileEnter);
    elements.add(secondaryTile);
    elements.add(mainTile);
    elements.add(newPointsWidget);

    return elements;
  }


  @override
  Widget build(BuildContext context) {




    return Consumer<GamePlayState>(
      builder: (context, gamePlayState, child) {
        late AnimationState animationState = Provider.of<AnimationState>(context, listen: false);
        List<Animation<Color?>> colorAnimations = [wordFoundColor1,wordFoundColor2,wordFoundColor3,wordFoundColor4,wordFoundColor5,wordFoundColor6];
        List<Animation<double>> sizeAnimations = [wordFoundSize1,wordFoundSize2,wordFoundSize3,wordFoundSize4,wordFoundSize5,wordFoundSize6];
        List<Animation<double>> sizeAnimations2 = [wordFoundEmptySize1,wordFoundEmptySize2,wordFoundEmptySize3,wordFoundEmptySize4,wordFoundEmptySize5,wordFoundEmptySize6];
        List<Widget> elements = getBoardTiles(
          gamePlayState, 
          animationState, 
          colorAnimations, 
          sizeAnimations, 
          sizeAnimations2,
          killTileAnimation,
        );
        return Stack(
          children: elements,
        );

      },
    );
  }
}

List<TweenSequenceItem<Color?>> getWordFoundColorSequence(int index, List<Color> colors, int duration, int delay) {
  double delayIncrement = delay/duration;
  double delayWeight = 0.01 +  (delayIncrement*60) * index;
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
List<TweenSequenceItem<double>> getWordFoundSizeSequence(int index, int duration, int delay) {
  double delayIncrement = delay/duration;
  double delayWeight = 0.01 +  (delayIncrement*50) * index; 
  double middleWeight = 50.0;
  double middleWeightGap = 10.0;
  double endWeight = 100.0 - (delayWeight + middleWeight+middleWeightGap);
  List<TweenSequenceItem<double>> res =  [
    TweenSequenceItem(tween: Tween(begin:1.0, end:1.0,), weight: delayWeight),
    TweenSequenceItem(tween: Tween(begin:1.0, end:0.8,), weight: middleWeight/3),
    TweenSequenceItem(tween: Tween(begin:0.8, end:1.0,), weight: middleWeight/6),
    TweenSequenceItem(tween: Tween(begin:1.0, end:0.8,), weight: middleWeight/6),
    TweenSequenceItem(tween: Tween(begin:0.8, end:1.0,), weight: middleWeight/6), 
    TweenSequenceItem(tween: Tween(begin:1.0, end:1.0,), weight: middleWeight/6),
    TweenSequenceItem(tween: Tween(begin:1.0, end:1.0,), weight: middleWeight/6),        


    TweenSequenceItem(tween: Tween(begin:1.0, end:0.0,), weight: middleWeightGap),    
    TweenSequenceItem(tween: Tween(begin:0.0, end: 0.0,), weight: endWeight),           
  ];
  return res; 
}    

List<TweenSequenceItem<double>> getWordFoundEmptyTileSizeSequence(int index, int duration, int delay) {
  double delayIncrement = delay/duration;
  double delayWeight = 0.01 +  (delayIncrement*50) * index; 
  double middleWeight = 70.0;
  double middleWeightGap = 10.0;
  double endWeight = 100.0 - (delayWeight + middleWeight + middleWeightGap);
  List<TweenSequenceItem<double>> res =  [
    TweenSequenceItem(tween: Tween(begin:0.0, end:0.0,), weight: delayWeight),
    TweenSequenceItem(tween: Tween(begin:0.0, end:0.0,), weight: middleWeight),
    TweenSequenceItem(tween: Tween(begin:0.0, end:1.0,), weight: middleWeightGap),
    TweenSequenceItem(tween: Tween(begin:1.0, end: 1.0,), weight: endWeight),           
  ];
  return res; 
}    



