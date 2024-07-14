import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/game_logic_2.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class TravellingTile extends StatefulWidget {
  final String element;
  final AnimationController tileTappedController;
  const TravellingTile({
    super.key, 
    required this.element,
    required this.tileTappedController
  });

  @override
  State<TravellingTile> createState() => _TravellingTileState();
}

class _TravellingTileState extends State<TravellingTile> with SingleTickerProviderStateMixin{

  late AnimationState animationState;
  late Animation<double> tileTappedProgressAnimation;
  late Animation<double> tileTappedProgressAnimationTop;
  late Animation<double> tileTappedProgressAnimationLeft;
  late Animation<double> tileTappedBoxShadowAnimation;
  late Animation<Color?> tileTappedGradientColor1Animation;
  late Animation<Color?> tileTappedGradientColor2Animation;
  late Animation<Color?> tileTappedBorderColorAnimation;


  @override
  void initState() {
    super.initState();
    initializeAnimations();
    animationState = Provider.of<AnimationState>(context, listen: false);
  }

  void initializeAnimations() {
    late GamePlayState gamePlayState = Provider.of<GamePlayState>(context, listen: false);
    late ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
    // late int duration = 0; 
    final double tileSize = gamePlayState.tileSize;

    late double topBegin = (((tileSize * 1.5) + (tileSize / 2)) - (tileSize * 1.3)) / 2;
    late double leftBegin = (((tileSize * 6) - (tileSize * 1.3)) / 2);
    late double tileSizeBegin = tileSize*1.3;
    
    late double topEnd = 0.0;
    late double leftEnd = 0.0;
    late double tileSizeEnd = 0.0;


    final List<Color> gradientColor1List = [
      palette.tileGradientShade1Color1,
      palette.tileGradientShade2Color1,
      palette.tileGradientShade3Color1,
      palette.tileGradientShade4Color1,
      palette.tileGradientShade5Color1,
    ];
    final List<Color> gradientColor2List = [
      palette.tileGradientShade1Color2,
      palette.tileGradientShade2Color2,
      palette.tileGradientShade3Color2,
      palette.tileGradientShade4Color2,
      palette.tileGradientShade5Color2,      
    ];
    final List<Color> reserveGradients = [
      palette.fullReserveGradientBackGroundColor1,
      palette.fullReserveGradientBackGroundColor2,
      palette.fullReserveGradientBackGroundColor3,
      palette.fullReserveGradientBackGroundColor4,
      palette.fullReserveGradientBackGroundColor5,      
    ];

    late Color borderColor;



    if (widget.element == 'tile') {
      final Map<dynamic,dynamic> tileObject = gamePlayState.tileState.firstWhere((element) => element['index'] == gamePlayState.selectedTileIndex);
      final int row = int.parse(tileObject['tileId'].split("_")[0]);
      final int col = int.parse(tileObject['tileId'].split("_")[1]);
      topEnd = ((tileSize * 1.5) + ((tileSize) / 2)) + ((row - 1) * tileSize) + (tileSize - tileSize*0.9)/2;
      leftEnd = (col - 1) * tileSize + (tileSize - tileSize*0.9)/2;      
      tileSizeEnd = tileSize*0.9;
      borderColor = palette.fullTileBorderColor;

    } else if (widget.element == 'reserve') {
      int index = gamePlayState.selectedReserveIndex;
      topEnd = tileSize * 8.1 + (tileSize*0.8-tileSize*0.75)/2;
      leftEnd = (tileSize*6 - tileSize*0.8*5)/2 + (tileSize*0.8*index) + ((tileSize*0.8-tileSize*0.75)/2);
      tileSizeEnd = tileSize*0.75;     
      borderColor = palette.fullReserveBorderColor;

    }

    final List<TweenSequenceItem<double>> tileTappedProgressAnimationTopSequence = [
      TweenSequenceItem<double>(
        tween: Tween(begin: topBegin,end: topEnd), 
        weight: 0.5
      ),
      TweenSequenceItem<double>(
        tween: Tween(begin: topEnd,end: topEnd), 
        weight: 0.5
      ),     
    ];
    tileTappedProgressAnimationTop = TweenSequence<double>(tileTappedProgressAnimationTopSequence)
    .animate(widget.tileTappedController);

    final List<TweenSequenceItem<double>> tileTappedProgressAnimationLeftSequence = [
      TweenSequenceItem<double>(
        tween: Tween(begin:leftBegin,end: leftEnd), 
        weight: 0.5
      ),
      TweenSequenceItem<double>(
        tween: Tween(begin: leftEnd,end: leftEnd), 
        weight: 0.5
      ),     
    ];
    tileTappedProgressAnimationLeft = TweenSequence<double>(tileTappedProgressAnimationLeftSequence)
    .animate(widget.tileTappedController);    

    final List<TweenSequenceItem<double>> tileTappedProgressSizeSequence = [
   
      TweenSequenceItem<double>(
        tween: Tween(begin:tileSizeBegin,end: tileSizeEnd), 
        weight: 0.50
      ),
      TweenSequenceItem<double>(
        tween: Tween(begin: tileSizeEnd,end: tileSizeEnd), 
        weight: 0.5
      ),     
    ];
    tileTappedProgressAnimation = TweenSequence<double>(tileTappedProgressSizeSequence)
    .animate(widget.tileTappedController);

    final List<TweenSequenceItem<double>> tileTappedBoxDecorationSequence = [
    
      TweenSequenceItem<double>(
        tween: Tween(begin:0.0,end: 0.0), 
        weight: 0.49
      ),
      TweenSequenceItem<double>(
        tween: Tween(begin: 1.0,end: 0.0), 
        weight: 0.5
      ),     
    ];
    tileTappedBoxShadowAnimation = TweenSequence<double>(tileTappedBoxDecorationSequence)
    .animate(widget.tileTappedController);

    final List<TweenSequenceItem<Color?>> tileTappedGradientColor1AnimationSequence = [
      
      TweenSequenceItem<Color?>(
        tween: ColorTween(
          begin:   gradientColor1List[gamePlayState.randomShadeList[gamePlayState.randomShadeList.length-2]],
          end: widget.element == 'reserve'
            // ? palette.fullReserveGradientBackGroundColor1 
            ? reserveGradients[gamePlayState.randomShadeList[gamePlayState.randomShadeList.length-2]]
            : gradientColor1List[gamePlayState.randomShadeList[gamePlayState.randomShadeList.length-2]]
        ), 
        weight: 0.50
      ),
      TweenSequenceItem<Color?>(
        tween: ColorTween(
          begin: widget.element == 'reserve'
            // ? palette.fullReserveGradientBackGroundColor1 
            ? reserveGradients[gamePlayState.randomShadeList[gamePlayState.randomShadeList.length-2]]
            : gradientColor1List[gamePlayState.randomShadeList[gamePlayState.randomShadeList.length-2]],
          end: widget.element == 'reserve'
            // ? palette.fullReserveGradientBackGroundColor1 
            ? reserveGradients[gamePlayState.randomShadeList[gamePlayState.randomShadeList.length-2]]
            : gradientColor1List[gamePlayState.randomShadeList[gamePlayState.randomShadeList.length-2]]
        ), 
        weight: 0.50
      ),        
    ];
    tileTappedGradientColor1Animation = TweenSequence<Color?>(tileTappedGradientColor1AnimationSequence)
    .animate(widget.tileTappedController);

    final List<TweenSequenceItem<Color?>> tileTappedGradientColor2AnimationSequence = [
      TweenSequenceItem<Color?>(
        tween: ColorTween(
          begin: gradientColor2List[gamePlayState.randomShadeList[gamePlayState.randomShadeList.length-2]],
          end: widget.element == 'reserve'
            // ? palette.fullReserveGradientBackGroundColor2
            ? reserveGradients[gamePlayState.randomAngleList[gamePlayState.randomAngleList.length-2]]
            : gradientColor2List[gamePlayState.randomShadeList[gamePlayState.randomShadeList.length-2]]
        ), 
        weight: 0.50
      ),  
      TweenSequenceItem<Color?>(
        tween: ColorTween(
          begin: widget.element == 'reserve'
            // ? palette.fullReserveGradientBackGroundColor2
            ? reserveGradients[gamePlayState.randomAngleList[gamePlayState.randomAngleList.length-2]]
            : gradientColor2List[gamePlayState.randomShadeList[gamePlayState.randomShadeList.length-2]],
          end: widget.element == 'reserve'
            // ? palette.fullReserveGradientBackGroundColor2
            ? reserveGradients[gamePlayState.randomAngleList[gamePlayState.randomAngleList.length-2]]
            : gradientColor2List[gamePlayState.randomShadeList[gamePlayState.randomShadeList.length-2]]
        ), 
        weight: 0.50
      ),        
    ];
    tileTappedGradientColor2Animation = TweenSequence<Color?>(tileTappedGradientColor2AnimationSequence)
    .animate(widget.tileTappedController);



    final List<TweenSequenceItem<Color?>> tileTappedBorderColorAnimationSequence = [
      TweenSequenceItem<Color?>(
        tween: ColorTween(
          begin:palette.fullTileBorderColor,
          end: borderColor
        ), 
        weight: 0.50
      ), 
      TweenSequenceItem<Color?>(
        tween: ColorTween(
          begin:borderColor,
          end: borderColor
        ), 
        weight: 0.50
      ),        
    ];
    tileTappedBorderColorAnimation = TweenSequence<Color?>(tileTappedBorderColorAnimationSequence)
    .animate(widget.tileTappedController);        

  }
  double showTempTileAnimation(AnimationState animationState, Animation animation) {
    double res = 0.0;
    if (animationState.shouldRunTileTappedAnimation) {
      res = animation.value;
    }
    // print(animation.value);
    // return 1.0;
    return res;
  }

  @override
  Widget build(BuildContext context) {



    final ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);

    return Consumer<GamePlayState>(
      builder: (context,gamePlayState,child) {
        // final String body = gamePlayState.randomLetterList[gamePlayState.randomLetterList.length-3];
        final String body = GameLogic().displayRandomLetters(gamePlayState.randomLetterList,3);
        final int angle = GameLogic().displayRandomLetterStyle(gamePlayState.randomAngleList,3);

        return AnimatedBuilder(
          animation: widget.tileTappedController,
          builder: (context,child) {
            return Positioned(
              top: tileTappedProgressAnimationTop.value,
              left: tileTappedProgressAnimationLeft.value,

              child: Stack(
                children: [
                  Container(
                    width: tileTappedProgressAnimation.value,
                    height: tileTappedProgressAnimation.value,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(showTempTileAnimation(animationState,tileTappedBoxShadowAnimation)), 
                          offset: Offset.zero, 
                          blurRadius:  7, 
                          spreadRadius: 5,
                        ),                      
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(gamePlayState.tileSize*0.2))                 
                    ),
                  ),                     
                  Container(
                    width: showTempTileAnimation(animationState,tileTappedProgressAnimation),
                    height: showTempTileAnimation(animationState,tileTappedProgressAnimation),
                    // decoration: Decorations().getTileDecoration(tileTappedProgressAnimation.value,palette),
                    decoration: getCustomTravellingTileStyle(
                      tileTappedProgressAnimation.value,
                      tileTappedGradientColor1Animation.value!,
                      tileTappedGradientColor2Animation.value!,                      
                      // gradientColor1List[shade],
                      // gradientColor2List[shade],
                      // palette.fullTileBorderColor,
                      tileTappedBorderColorAnimation.value!,
                      angle
                      // tileTappedGradientColor1Animation,
                      // tileTappedGradientColor2Animation,
                      // tileTappedBorderColorAnimation
                    ),
                    child: Center(
                      child: Text(
                        body,
                        style: TextStyle(
                          fontSize: tileTappedProgressAnimation.value*0.5,
                          color: palette.fullTileTextColor
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            );
          }
        );
      }
    );
  }
}


  BoxDecoration getCustomTravellingTileStyle(
    double tileSize, 
    Color gradient1, 
    Color gradient2, 
    Color borderColor,
    int angle
    // Animation borderColorAnimation, 
  ) {
    late Map<int,dynamic> angles = {
      0: {"begin": Alignment.bottomLeft, "end": Alignment.topRight,},
      1: {"begin": Alignment.bottomRight, "end": Alignment.topLeft,},
      2: {"begin": Alignment.topLeft, "end": Alignment.bottomRight,},
      3: {"begin": Alignment.topRight, "end": Alignment.bottomLeft,},
      4: {"begin": Alignment.topCenter, "end": Alignment.bottomCenter,},
    };

    return BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(tileSize*0.2)),
      gradient: LinearGradient(
        begin: angles[angle]['begin'],
        end: angles[angle]['end'],        
        // begin: Alignment.bottomLeft,
        // end: Alignment.topRight,
        colors: <Color>[
          gradient1,
          gradient2
        ],
      ),
      border: Border(
        bottom: BorderSide(
          color: borderColor,
          width: tileSize*0.03,
        ),
        left: BorderSide(
          color: borderColor,
          width: tileSize*0.03,
        )
      ),
      boxShadow:  <BoxShadow>[
        BoxShadow(
          color: Color.fromRGBO(15, 15, 15, 0.3),
          offset: Offset(0.0, 2.0),
          blurRadius: tileSize*0.04,
          spreadRadius: 1,
        )
      ]
    );
  }   