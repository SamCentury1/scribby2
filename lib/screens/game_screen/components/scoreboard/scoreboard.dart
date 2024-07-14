import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class Scoreboard extends StatefulWidget {
  final AnimationController wordFoundController;
  final AnimationController gameStartedController;
  final Animation<double> gameStartedOpacityAnimation;
  const Scoreboard({
    super.key,
    required this.wordFoundController,
    required this.gameStartedController,
    required this.gameStartedOpacityAnimation
  });

  @override
  State<Scoreboard> createState() => _ScoreboardState();
}

class _ScoreboardState extends State<Scoreboard> with SingleTickerProviderStateMixin {


  late AnimationState animationState;
  late Animation<Color?> wordFoundColorAnimation1;
  late Animation<Color?> wordFoundColorAnimation2;

  late Animation<Color?> borderColorAnimation;
  late Animation<Color?> textColorAnimation;
  late Animation<double> scaleAnimation;


  @override
  void initState() {
    super.initState();
    animationState = Provider.of<AnimationState>(context, listen:false);
    initializeAnimations();
  }

  void initializeAnimations() {

    late ColorPalette palette = Provider.of<ColorPalette>(context,listen: false);

    Color color_0 = Colors.transparent;
    Color color_1 = Colors.red;
    Color color_2 = Colors.yellow;
    Color color_4 = palette.textColor2;


    List<TweenSequenceItem<Color?>> wordFoundColorSequence1 = [
      TweenSequenceItem(tween: ColorTween(begin: color_4, end: color_1,), weight: 05),
      TweenSequenceItem(tween: ColorTween(begin: color_1, end: color_2,), weight: 05),
      TweenSequenceItem(tween: ColorTween(begin: color_2, end: color_4,), weight: 30),
      TweenSequenceItem(tween: ColorTween(begin: color_4, end: color_0,), weight: 10),
      TweenSequenceItem(tween: ColorTween(begin: color_0, end: color_0,), weight: 50),     
    ];
    wordFoundColorAnimation1 = TweenSequence<Color?>(wordFoundColorSequence1).animate(widget.wordFoundController);    

// =========================================================================


    /// SCALE
    final List<TweenSequenceItem<double>> scaleTweenSequence = [
      TweenSequenceItem<double>(tween: Tween(begin: 1.0,end: 1.0,),weight: 20),
      TweenSequenceItem<double>(tween: Tween(begin: 1.0,end: 1.0,),weight: 20),
      TweenSequenceItem<double>(tween: Tween(begin: 1.0,end: 1.0,),weight: 20),
      TweenSequenceItem<double>(tween: Tween(begin: 1.1,end: 1.1,),weight: 20),
      TweenSequenceItem<double>(tween: Tween(begin: 1.1,end: 1.0,),weight: 20),
    ];
    scaleAnimation = TweenSequence<double>(scaleTweenSequence).animate(CurvedAnimation(
      parent: widget.wordFoundController,
      curve: Curves.easeInOut,
    ));


    /// BORDER COLOR
    final List<TweenSequenceItem<Color?>> scoreBorderTweenSequence = [
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_0,end: color_0), weight: 50),
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_0,end: color_4), weight: 10),
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_1,end: color_2), weight: 10),
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_2,end: color_1), weight: 10),
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_1,end: color_4), weight: 20),
    ];
    borderColorAnimation = TweenSequence<Color?>(scoreBorderTweenSequence).animate(widget.wordFoundController);    


    /// TEXT COLOR
    final List<TweenSequenceItem<Color?>> scoreTextTweenSequence = [
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_0,end: color_0), weight: 50),
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_0,end: color_4), weight: 10),
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_1,end: color_2), weight: 15),
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_2,end: color_1), weight: 10),
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_1,end: color_4), weight: 15),
    ];
    textColorAnimation = TweenSequence<Color?>(scoreTextTweenSequence).animate(widget.wordFoundController);


  }

  Color getComponentColor(Animation gameStartedAnimation, Animation wordFoundAnimation) {
    Color res = Colors.transparent;
    int red = wordFoundAnimation.value!.red;
    int green = wordFoundAnimation.value!.green;
    int blue = wordFoundAnimation.value!.blue;
    double op = wordFoundAnimation.value!.opacity;
    double opacity = gameStartedAnimation.value *op;
    res = Color.fromRGBO(red,green,blue,opacity);
    return res;      
  }

  double getContainerWidth(GamePlayState gamePlayState) {
    late double res = 0; 
    if (MediaQuery.of(context).size.width > 500) {
      res = gamePlayState.tileSize*6;
    } else {
      res = MediaQuery.of(context).size.width;
    }
    return res;
  }


  @override
  Widget build(BuildContext context) {

    /// SCOREBOARD SECTION
    return Consumer<GamePlayState>(
      builder: (context,gamePlayState,child) {
        final double tileSize = gamePlayState.tileSize;
        late int previousScore = 0;
        late int previousWords = 0;

        if (gamePlayState.scoringLog.length >1) {
          previousScore = gamePlayState.scoringLog[gamePlayState.scoringLog.length-2]['cumulativePoints'];
          previousWords = gamePlayState.scoringLog[gamePlayState.scoringLog.length-2]['cumulativeWords'];
        }

        final int currentScore = gamePlayState.scoringLog[gamePlayState.scoringLog.length-1]['cumulativePoints'];
        final int currentWords = gamePlayState.scoringLog[gamePlayState.scoringLog.length-1]['cumulativeWords'];
        return AnimatedBuilder(
          animation: Listenable.merge([widget.gameStartedController,widget.wordFoundController]),
          builder: (context,child) {
            return ConstrainedBox(
              constraints: const BoxConstraints(
                // maxHeight: 50,
                maxWidth: 500,
              ),
              child: Stack(
                children: [

                  /// SECOND
                  Container(
                    // width: double.infinity,
                    width: getContainerWidth(gamePlayState),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Counter(),
                        // NewNPoints(),
                        // Text("caca"),
                        SizedBox(width: 10,),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: getComponentColor(widget.gameStartedOpacityAnimation,wordFoundColorAnimation1),
                              width: tileSize*0.04
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(tileSize*0.10))
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 5,),
                              Icon(
                                Icons.star, 
                                size: (tileSize*0.40).roundToDouble(), 
                                // color: Color.fromRGBO(186, 209, 228, widget.gameStartedOpacityAnimation.value),
                                color: getComponentColor(widget.gameStartedOpacityAnimation,wordFoundColorAnimation1),
                              ),
                              SizedBox(width: 10,),

                              Text(
                                previousScore.toString(),
                                style: TextStyle(
                                  fontSize: (tileSize*0.40).roundToDouble(), 
                                  // color: Color.fromRGBO(186, 209, 228, widget.gameStartedOpacityAnimation.value),
                                  color: getComponentColor(widget.gameStartedOpacityAnimation,wordFoundColorAnimation1),
                                ) 
                              ),
                              SizedBox(width: 5,),
                            ],
                          ),
                        ),

                        
                        Expanded(child: SizedBox(),),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: getComponentColor(widget.gameStartedOpacityAnimation,wordFoundColorAnimation1),
                              width: tileSize*0.04
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(tileSize*0.10))
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 5,),
                              Text(
                                previousWords.toString(),
                                style: TextStyle(
                                  fontSize: (tileSize*0.40).roundToDouble(),
                                  color: getComponentColor(widget.gameStartedOpacityAnimation,wordFoundColorAnimation1),
                                )
                              ),
                              SizedBox(width: 10,),
                              Icon(
                                Icons.library_books, 
                                size: (tileSize*0.40).roundToDouble(),
                                color: getComponentColor(widget.gameStartedOpacityAnimation,wordFoundColorAnimation1),
                              ),
                              SizedBox(width: 5,),
                            ],
                          ),
                        ),
                        SizedBox(width: 10,),
                      ]
                    ),
                  ),

                  

                  /// FIRST
                  Container(
                    // height: 50,
                    width: getContainerWidth(gamePlayState),
                    // color: Colors.green,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 10,),
                        Transform.scale(
                          scale: scaleAnimation.value,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: getComponentColor(widget.gameStartedOpacityAnimation,borderColorAnimation),
                                width: tileSize*0.04
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(tileSize*0.10))
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 5,),
                                Icon(
                                  Icons.star, 
                                  size: (tileSize*0.40).roundToDouble(), 
                                  color: getComponentColor(widget.gameStartedOpacityAnimation,textColorAnimation),
                                ),
                                SizedBox(width: 10,),
                          
                                Text(
                                  currentScore.toString(),
                                  style: TextStyle(
                                    fontSize: (tileSize*0.40).roundToDouble(), 
                                    color: getComponentColor(widget.gameStartedOpacityAnimation,textColorAnimation),
                                  ) 
                                ),
                                SizedBox(width: 5,),
                              ],
                            ),
                          ),
                        ),
                        Expanded(child: SizedBox(),),
                        Transform.scale(
                          scale: scaleAnimation.value,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                // color: Color.fromRGBO(186, 209, 228, widget.gameStartedOpacityAnimation.value), 
                                // color: Colors.transparent,
                                color: getComponentColor(widget.gameStartedOpacityAnimation,borderColorAnimation),
                                width: tileSize*0.04
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(tileSize*0.10))
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 5,),
                                Text(
                                  currentWords.toString(),
                                  style: TextStyle(
                                    fontSize: (tileSize*0.40).roundToDouble(),
                                    // color: Color.fromRGBO(186, 209, 228, widget.gameStartedOpacityAnimation.value),
                                    color: getComponentColor(widget.gameStartedOpacityAnimation,textColorAnimation),
                                  )
                                ),
                                SizedBox(width: 10,),
                                Icon(
                                  Icons.library_books, 
                                  size: (tileSize*0.40).roundToDouble(),
                                  // color: Color.fromRGBO(186, 209, 228, widget.gameStartedOpacityAnimation.value),
                                  color: getComponentColor(widget.gameStartedOpacityAnimation,textColorAnimation),
                                ),
                                SizedBox(width: 5,),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                      ]
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