import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class BonusItems extends StatefulWidget {
  final AnimationController wordFoundController;
  final AnimationController streakController;
  final AnimationController streakOutController;
  final AnimationController levelUpController;
  const BonusItems({
    super.key,
    required this.wordFoundController,
    required this.streakController,
    required this.streakOutController,
    required this.levelUpController,
  });

  @override
  State<BonusItems> createState() => _BonusItemsState();
}

class _BonusItemsState extends State<BonusItems> with TickerProviderStateMixin{

  // late Animation<double> multiWordAnimationPosition;
  late Animation<double> streakAnimationOpacity;
  late Animation<double> streakOutAnimationOpacity;
  late Animation<double> multiWordAnimationOpacity;
  late Animation<double> crossWordAnimationOpacity;

  late Animation<Offset> streakAnimationPosition;
  late Animation<Offset> streakOutAnimationPosition;
  late Animation<Offset> multiWordAnimationPosition;
  late Animation<Offset> crossWordAnimationPosition;

  late Animation<Color?> streakAnimationColor;
  late Animation<Color?> multiWordAnimationColor;
  late Animation<Color?> crossWordAnimationColor;


  late Animation<Offset> levelUpPositionAnimation;
  late Animation<double> levelUpOpacityAnimation;

  @override
  void initState() {
    super.initState();
    initializeAnimations();
  }


  void initializeAnimations() {

    late ColorPalette palette = Provider.of<ColorPalette>(context,listen: false);
    Color color_1 = Colors.red;
    Color color_2 = Colors.yellow;
    Color color_3 = palette.textColor2;

    List<TweenSequenceItem<Color?>> streakAnimationColorSequence = [
      TweenSequenceItem(tween: ColorTween(begin: color_3, end: color_1), weight: 20),
      TweenSequenceItem(tween: ColorTween(begin: color_2, end: color_1), weight: 10),
      TweenSequenceItem(tween: ColorTween(begin: color_1, end: color_2), weight: 10),
      TweenSequenceItem(tween: ColorTween(begin: color_2, end: color_1), weight: 10),
      TweenSequenceItem(tween: ColorTween(begin: color_1, end: color_3), weight: 50),      
    ];
    streakAnimationColor = TweenSequence<Color?>(streakAnimationColorSequence).animate(widget.wordFoundController);

    final List<TweenSequenceItem<Offset>> streakSlideSequence = [
      TweenSequenceItem<Offset>(tween: Tween<Offset>(begin: Offset(-1.0, 0.0),  end: Offset(0.0, 0.0),),   weight: 50),
      TweenSequenceItem<Offset>(tween: Tween<Offset>(begin: Offset(0.0, 0.0),  end: Offset(1.0, 0.0),),   weight: 50),
    ];    
    streakAnimationPosition = TweenSequence<Offset>(streakSlideSequence).animate(widget.streakController);

    List<TweenSequenceItem<double>> streakAnimationOpacitySequence = [

      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.0,  end: 1.0,),   weight: 30),
      // TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0,  end: 0.0,),   weight: 30),            
    ];
    streakAnimationOpacity = TweenSequence<double>(streakAnimationOpacitySequence).animate(widget.wordFoundController); 


    List<TweenSequenceItem<double>> streakOutAnimationOpacitySequence = [

      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.0,  end: 0.0,),   weight: 30),
      // TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0,  end: 0.0,),   weight: 30),            
    ];
    streakOutAnimationOpacity = TweenSequence<double>(streakOutAnimationOpacitySequence).animate(widget.streakOutController);     



    final List<TweenSequenceItem<Offset>> streakOutSlideSequence = [
      TweenSequenceItem<Offset>(tween: Tween<Offset>(begin: Offset(1.0, 0.0),  end: Offset(0.0, 0.0),),   weight: 50),
      TweenSequenceItem<Offset>(tween: Tween<Offset>(begin: Offset(0.0, 0.0),  end: Offset(-1.0, 0.0),),   weight: 50),
    ];    
    streakOutAnimationPosition = TweenSequence<Offset>(streakOutSlideSequence).animate(widget.streakOutController);


  
    List<TweenSequenceItem<Color?>> multiWordAnimationColorSequence = [
      TweenSequenceItem(tween: ColorTween(begin: color_2, end: color_1), weight: 10),
      TweenSequenceItem(tween: ColorTween(begin: color_1, end: color_2), weight: 10),
      TweenSequenceItem(tween: ColorTween(begin: color_2, end: color_1), weight: 10),
      TweenSequenceItem(tween: ColorTween(begin: color_1, end: color_2), weight: 10),
      TweenSequenceItem(tween: ColorTween(begin: color_2, end: color_1), weight: 10),
      TweenSequenceItem(tween: ColorTween(begin: color_1, end: color_2), weight: 10),
      TweenSequenceItem(tween: ColorTween(begin: color_2, end: color_1), weight: 10),
      TweenSequenceItem(tween: ColorTween(begin: color_1, end: color_2), weight: 10),
      TweenSequenceItem(tween: ColorTween(begin: color_2, end: color_1), weight: 10),
      TweenSequenceItem(tween: ColorTween(begin: color_1, end: color_2), weight: 10),      
    ];
    multiWordAnimationColor = TweenSequence<Color?>(multiWordAnimationColorSequence).animate(widget.wordFoundController);

    final List<TweenSequenceItem<Offset>> multiWordSlideSequence = [
      TweenSequenceItem<Offset>(tween: Tween<Offset>(begin: Offset(0.0, 1.5),  end: Offset(0.0, 1.5),),   weight: 00.1),
      TweenSequenceItem<Offset>(tween: Tween<Offset>(begin: Offset(0.0, 1.5),  end: Offset(0.0, 0.5),),   weight: 15),
      TweenSequenceItem<Offset>(tween: Tween<Offset>(begin: Offset(0.0, 0.5),  end: Offset(0.0, -0.5), ), weight: 30),
      TweenSequenceItem<Offset>(tween: Tween<Offset>(begin: Offset(0.0, -0.5), end: Offset(0.0, -1.5),),  weight: 15),
      TweenSequenceItem<Offset>(tween: Tween<Offset>(begin: Offset(0.0, -1.5),  end: Offset(0.0, -1.5),), weight: 40),
    ];    
    multiWordAnimationPosition = TweenSequence<Offset>(multiWordSlideSequence).animate(widget.wordFoundController);

    List<TweenSequenceItem<double>> multiWordAnimationOpacitySequence = [
      TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0,  end: 0.0,),   weight: 01),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0,  end: 1.0,),   weight: 15),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.0,  end: 1.0,),   weight: 30),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.0,  end: 0.0,),   weight: 15),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0,  end: 0.0,),   weight: 40),
      // TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0,  end: 0.0,),   weight: 30),            
    ];
    multiWordAnimationOpacity = TweenSequence<double>(multiWordAnimationOpacitySequence).animate(widget.wordFoundController);





    List<TweenSequenceItem<Color?>> crossWordAnimationColorSequence = [
      TweenSequenceItem(tween: ColorTween(begin: color_2, end: color_1), weight: 15),
      TweenSequenceItem(tween: ColorTween(begin: color_1, end: color_2), weight: 10),
      TweenSequenceItem(tween: ColorTween(begin: color_2, end: color_1), weight: 10),
      TweenSequenceItem(tween: ColorTween(begin: color_1, end: color_2), weight: 10),
      TweenSequenceItem(tween: ColorTween(begin: color_2, end: color_1), weight: 10),
      TweenSequenceItem(tween: ColorTween(begin: color_1, end: color_2), weight: 10),
      TweenSequenceItem(tween: ColorTween(begin: color_2, end: color_1), weight: 10),
      TweenSequenceItem(tween: ColorTween(begin: color_1, end: color_2), weight: 10),
      TweenSequenceItem(tween: ColorTween(begin: color_2, end: color_1), weight: 10),
      TweenSequenceItem(tween: ColorTween(begin: color_1, end: color_2), weight: 5),            
    ];
    crossWordAnimationColor = TweenSequence<Color?>(crossWordAnimationColorSequence).animate(widget.wordFoundController);

    final List<TweenSequenceItem<Offset>> crossWordSlideSequence = [
      TweenSequenceItem<Offset>(tween: Tween<Offset>(begin: Offset(0.0, 1.5),  end: Offset(0.0, 1.5),),   weight: 10),
      TweenSequenceItem<Offset>(tween: Tween<Offset>(begin: Offset(0.0, 1.5),  end: Offset(0.0, 0.5),),   weight: 15),
      TweenSequenceItem<Offset>(tween: Tween<Offset>(begin: Offset(0.0, 0.5),  end: Offset(0.0, -0.5), ), weight: 30),
      TweenSequenceItem<Offset>(tween: Tween<Offset>(begin: Offset(0.0, -0.5), end: Offset(0.0, -1.5),),  weight: 15),
      TweenSequenceItem<Offset>(tween: Tween<Offset>(begin: Offset(0.0, -1.5),  end: Offset(0.0, -1.5),), weight: 30),
    ];    
    crossWordAnimationPosition = TweenSequence<Offset>(crossWordSlideSequence).animate(widget.wordFoundController); 


    List<TweenSequenceItem<double>> crossWordAnimationOpacitySequence = [
      TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0,  end: 0.0,),   weight: 10),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0,  end: 1.0,),   weight: 15),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.0,  end: 1.0,),   weight: 30),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.0,  end: 0.0,),   weight: 15),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0,  end: 0.0,),   weight: 30),
      // TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0,  end: 0.0,),   weight: 30),            
    ];
    crossWordAnimationOpacity = TweenSequence<double>(crossWordAnimationOpacitySequence).animate(widget.wordFoundController);



    final List<TweenSequenceItem<Offset>> levelUpSlideSequence = [
      TweenSequenceItem<Offset>(tween: Tween<Offset>(begin: Offset(0.0, 1.5),  end: Offset(0.0, 1.5),),   weight: 50),
      TweenSequenceItem<Offset>(tween: Tween<Offset>(begin: Offset(0.0, 1.5),  end: Offset(0.0, 0.0),),   weight: 10),
      TweenSequenceItem<Offset>(tween: Tween<Offset>(begin: Offset(0.0, 0.0),  end: Offset(0.0, 0.0),),   weight: 20),
      TweenSequenceItem<Offset>(tween: Tween<Offset>(begin: Offset(0.0, 0.0),  end: Offset(0.0, -1.0),),   weight: 20),
    ];    
    levelUpPositionAnimation = TweenSequence<Offset>(levelUpSlideSequence).animate(widget.levelUpController); 
  
    List<TweenSequenceItem<double>> levelUpOpacitySequence = [
      TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0,  end: 0.0,),   weight: 50),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0,  end: 1.0,),   weight: 10),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.0,  end: 1.0,),   weight: 20),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.0,  end: 0.0,),   weight: 20),
      // TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0,  end: 0.0,),   weight: 30),            
    ];  
    levelUpOpacityAnimation = TweenSequence<double>(levelUpOpacitySequence).animate(widget.levelUpController);
  
  }




  @override
  Widget build(BuildContext context) {
    late ColorPalette palette = Provider.of<ColorPalette>(context,listen: false);
    late SettingsState settingsState = Provider.of<SettingsState>(context,listen: false);
    return Consumer<GamePlayState>(
      builder: (context,gamePlayState,child) {
        final double tileSize = gamePlayState.tileSize;
        late int streakPassed = 0;
        late int streak = 0;
        late int multiWord = 0;
        late int crossWord = 0;

        if (gamePlayState.scoringLog.length > 1) {
          streakPassed = gamePlayState.scoringLog[gamePlayState.scoringLog.length-2]['streak'];          
          streak = gamePlayState.scoringLog[gamePlayState.scoringLog.length-1]['streak'];
          multiWord = gamePlayState.scoringLog[gamePlayState.scoringLog.length-1]['words'];
          crossWord = gamePlayState.scoringLog[gamePlayState.scoringLog.length-1]['crossWord'];
        }

        return ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 500,
          ),
          child: AnimatedBuilder(
            animation: Listenable.merge([widget.wordFoundController, widget.streakController, widget.streakOutController, widget.levelUpController]),
            builder: (context,child) {
              return Container(
                width: tileSize*6,
                height: gamePlayState.tileSize*1,
                // color: Colors.green,
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(flex: 1, child: SizedBox()),
                        // bonusElement(streak, multiWordAnimationPosition),
                        streakItem(
                          streak == 0 ? streakPassed : streak, 
                          streak == 0 ? streakOutAnimationPosition : streakAnimationPosition,
                          streakAnimationColor, 
                          streak == 0 ? streakOutAnimationOpacity : streakAnimationOpacity,
                          tileSize,
                        ),
                        Expanded(flex: 6, child: SizedBox()),
                        bonusElement(
                          multiWord, 
                          multiWordAnimationPosition, 
                          multiWordAnimationColor, 
                          multiWordAnimationOpacity,
                          tileSize,
                          Icons.library_books,
                        ),
                        Expanded(flex: 3, child: SizedBox()),
                    
                        bonusElement(
                          crossWord, 
                          crossWordAnimationPosition, 
                          crossWordAnimationColor, 
                          crossWordAnimationOpacity,
                          tileSize,
                          Icons.close,
                        ),                    
                        // bonusElement(crossWord, crossWordAnimationPosition, crossWordAnimationColor, crossWordAnimationOpacity),
                        Expanded(flex: 3, child: SizedBox())
                      ],
                    ),
                    SlideTransition(
                      position: levelUpPositionAnimation,
                      child: Center(
                        child: Text(
                          "${Helpers().translateText(gamePlayState.currentLanguage, "Level", settingsState)} ${gamePlayState.currentLevel}",
                          
                          // "Level ${gamePlayState.currentLevel}",
                          style: TextStyle(
                            fontSize: tileSize*0.6,
                            color: palette.textColor2.withOpacity(levelUpOpacityAnimation.value)
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
          ),
        );
      }
    );
  }
}


double shouldShowElement(int value) {
  late double res = 0.0;
  if (value > 1) {
    res = 1.0;
  }
  return res;
}

Color getElementColor(int value, Animation colorAnimation, Animation<double> opacityAnimation) {
  late double shouldShowOpacity = shouldShowElement(value);
  late Color res = Colors.transparent;
  int red = colorAnimation.value.red;
  int green = colorAnimation.value.green;
  int blue = colorAnimation.value.blue;
  double op = opacityAnimation.value;
  res = Color.fromRGBO(
    red,
    green,
    blue,
    op * shouldShowOpacity
  );

  return res;
}

Widget bonusElement(
  int value, 
  Animation<Offset> positionAnimation, 
  Animation<Color?> colorAnimation, 
  Animation<double> opacityAnimation,
  double tileSize,
  IconData iconData,
  ) {
    return SlideTransition(
      position: positionAnimation,
      child: Container(
        child: Row(
          children: [
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: tileSize*0.4,
                fontStyle:FontStyle.italic,
                color: getElementColor(value, colorAnimation, opacityAnimation)
              ),
            ),
            Container(
              height: tileSize*0.4,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Icon(
                  iconData,
                  size: tileSize*0.30,
                  color: getElementColor(value, colorAnimation,opacityAnimation )
                )
              ),
            ),
          ],          
        ),
      ),
    );
}

Widget streakItem(
  int value, 
  Animation<Offset> positionAnimation, 
  Animation colorAnimation, 
  Animation<double> opacityAnimation,
  double tileSize,
  ) {

    late int red = colorAnimation.value.red;
    late int green =  colorAnimation.value.green;
    late int blue =  colorAnimation.value.blue;
    late double op =  value == 1 || value == 0 ? 0.0 : opacityAnimation.value;  

    late Color color = Color.fromRGBO(red,green,blue,op,);

    return SlideTransition(
      position: positionAnimation,
      child: Container(
        child: Row(
          children: [
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: tileSize*0.4,
                fontStyle:FontStyle.italic,
                color: color
              ),
            ),
            Container(
              height: tileSize*0.4,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Icon(
                  Icons.bolt,
                  size: tileSize*0.30,
                  color: color
                )
              ),
            ),
          ],          
        ),
      ),
    );  
}