import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/audio/audio_controller.dart';
import 'package:scribby_flutter_v2/functions/game_logic.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';
import 'package:scribby_flutter_v2/utils/states.dart';

class TileWidget extends StatefulWidget {
  final int index;
  // final double tileSize;
  const TileWidget({
    super.key,
    required this.index, 
    // required this.tileSize
  });

  @override
  State<TileWidget> createState() => _TileWidgetState();
}

class _TileWidgetState extends State<TileWidget> with TickerProviderStateMixin{

  late AnimationState _animationState;
  // late ColorPalette palette;
  // late SettingsState settingsState;
  late AnimationController wordFoundAnimationController;

  late Animation<Color?> logicalTileBorderColor;


  late Animation<Color?> visualTileBorderColor;
  late Animation<Color?> visualTileTextColor;
  late Animation<double> visualTileBorderSize;

  late AnimationController tapDownController;
  late Animation<double> logicalTileSizeOnTap;



  @override
  void initState() {
    super.initState();
    // palette = Provider.of<ColorPalette>(context, listen: false);
    // settingsState = Provider.of<SettingsState>(context, listen: false);
    // final double tileSize = settingsState.screenSizeData["width"]/8;
    
    initializeWordFoundAnimations();
    initializeTapDownAnimations();
    _animationState = Provider.of<AnimationState>(context, listen: false);
    // _gamePlayState = Provider.of<GamePlayState>(context, listen: false);
    _animationState.addListener(_handleAnimationStateChange);
    // _gamePlayState.addListener(_handleAnimationStateChange);
  }

  void initializeWordFoundAnimations() {
    final ColorPalette palette = context.read<ColorPalette>();
    final SettingsState settingsState = context.read<SettingsState>();
    late GamePlayState gamePlayState = context.read<GamePlayState>();
    // final double tileSize = settingsState.screenSizeData["width"]/6;

    wordFoundAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    Color color_0 = Colors.transparent;
    Color color_1 = const Color.fromARGB(244, 255, 220, 24);
    Color color_2 = const Color.fromARGB(244, 224, 32, 32);

    final List<TweenSequenceItem<Color?>> logicalBorderColorSequence = [
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_0,end:color_0,),weight: 0.9,),
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_0,end:palette.tileBorderColor,),weight: 0.1,),
    ];
    logicalTileBorderColor = TweenSequence<Color?>(
      logicalBorderColorSequence,
    ).animate(wordFoundAnimationController);    



    final List<TweenSequenceItem<Color?>> colorTweenSequenceItems = [
      TweenSequenceItem<Color?>(tween: ColorTween(begin:palette.tileBorderColor,),weight: 10,),
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_1,end: color_2,),weight: 10,),
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_2,end: color_1,),weight: 10,),
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_1,end: color_2,),weight: 10,),
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_2,end: color_1,),weight: 10,),
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_1,end: color_2,),weight: 10,),
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_2,end: color_1,),weight: 10,),      
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_1,end: color_0,),weight: 10,),
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_0,end: color_0,),weight: 20,),
    ];
    visualTileBorderColor = TweenSequence<Color?>(
      colorTweenSequenceItems,
    ).animate(wordFoundAnimationController);

    final List<TweenSequenceItem<Color?>> textColorTweenSequenceItems = [
      TweenSequenceItem<Color?>(tween: ColorTween(begin: palette.tileTextColor,end: color_1,),weight: 10,),
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_1,end: color_2,),weight: 10,),
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_2,end: color_1,),weight: 10,),
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_1,end: color_2,),weight: 10,),
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_2,end: color_1,),weight: 10,),
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_1,end: color_2,),weight: 10,),
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_2,end: color_1,),weight: 10,),      
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_1,end: color_0),weight: 10,),
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_0, end: color_0,),weight: 20,),
    ];

    visualTileTextColor = TweenSequence<Color?>(
      textColorTweenSequenceItems,
    ).animate(wordFoundAnimationController);    


    final List<TweenSequenceItem<double>> tileSizeTweenSequence = [
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0),weight: 50,),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0),weight: 10,),
      TweenSequenceItem(tween: Tween(begin: 0, end: 0),weight: 20,),
      TweenSequenceItem(tween: Tween(begin: 0, end: 1.0),weight: 20,),
    ];
    visualTileBorderSize = TweenSequence<double>(
      tileSizeTweenSequence,
    ).animate(wordFoundAnimationController);

    wordFoundAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        gamePlayState.setValidIds([]);
        wordFoundAnimationController.reset();
      }
    });
  }


  void initializeTapDownAnimations() {

    tapDownController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );


    final List<TweenSequenceItem<double>> logicalTileSizeOnTapSequence = [
      TweenSequenceItem<double>(tween: Tween(begin: 1.0,end: 0.7,),weight: 1.0,),
    ];
    logicalTileSizeOnTap = TweenSequence<double>(
      logicalTileSizeOnTapSequence,
    ).animate(tapDownController);

  }

  void _handleAnimationStateChange() {
    // late GamePlayState gamePlayState = context.read<GamePlayState>();
    // for when a word is found
    if (_animationState.shouldRunWordAnimation) {
      _runAnimations();
    }

    if (_animationState.shouldRunTilePressedAnimation) {
      _runTapDownAnimation();
    }

    // if (wordFoundAnimationController.status == AnimationStatus.completed) {
    //   gamePlayState.setValidIds([]);
    // }

    // if (wordFoundAnimationController.status == AnimationStatus.dismissed) {
    //   gamePlayState.setValidIds([]);
    // }       



    // if (_animationState.shouldRunTilePressedAnimation) {
    //   _runTilePressedAnimation();
    // }

    // if (_animationState.shouldRunAnimation) {
    //   _runTilePressedOutAnimation();
    // }



  }

  void _runAnimations() {

    final GamePlayState gamePlayState = context.read<GamePlayState>();
    List<dynamic> idsArray = gamePlayState.validIds.map((e) => e['index']).toList();
    int order = idsArray.indexOf(widget.index);

    Future.delayed(Duration(milliseconds: (order*60)),() {
      wordFoundAnimationController.reset();
      wordFoundAnimationController.forward();
    });
  }

  void _runTapDownAnimation() {
    tapDownController.reset();
    tapDownController.forward();
  }




  @override
  Widget build(BuildContext context) {

    late SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);
    late ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
    final double tileSize = settingsState.screenSizeData["width"]/6;
    // print(tileSize);
    // late AnimationState animationState = Provider.of<AnimationState>(context, listen: false);
    late AudioController audioController = Provider.of<AudioController>(context, listen: false);


    return Consumer<GamePlayState>(
      builder: (context, gamePlayState, child) {

        final Map<String,dynamic> tileObject = Helpers().getTileObject(gamePlayState,widget.index);

        // final List<Map<String,dynamic>> validIds = gamePlayState.validIds;

        final Map<String,dynamic> visualTileObject = getVisualTileObject(gamePlayState, widget.index);

        return AnimatedBuilder(
          animation: Listenable.merge([visualTileBorderColor,visualTileBorderSize,visualTileTextColor,logicalTileBorderColor,logicalTileSizeOnTap]), 
          builder:(context, child) {
            return Stack(
              children: [

                Center(
                  child: Padding(
                    padding: EdgeInsets.all(3.0*settingsState.sizeFactor),
                    child: SizedBox(
                      // width: tileSize*logicalTileSizeOnTap.value,
                      // height: tileSize*logicalTileSizeOnTap.value,
                      // width: 50,
                      // height: 50,                  
                      child: GestureDetector(


                        onTapDown: (details) {
                          GameLogic().tapDownBehavior(gamePlayState, _animationState, widget.index);
                        }, 

                        onTapUp: (details) {
                          _animationState.setShouldRunTilePressedAnimation(false);
                          gamePlayState.setSelectedTileIndex(-1);
                          GameLogic().pressTile(context,widget.index,gamePlayState); 
                          
                        },

                        onTapCancel: () {
                          _animationState.setShouldRunTilePressedAnimation(false);
                          gamePlayState.setSelectedTileIndex(-1);
                          gamePlayState.setPressedTile("");
                        },
                       
                        child: Container(
                          // width: tileSize* logicalTileSizeOnTap.value,
                          // height: tileSize* logicalTileSizeOnTap.value,   
                          width: getLogicalTileSize(tileSize,logicalTileSizeOnTap,gamePlayState,widget.index),
                          height: getLogicalTileSize(tileSize,logicalTileSizeOnTap,gamePlayState,widget.index),                                                       
                          decoration: BoxDecoration(
                            color: getLogicalTileColor(tileObject, palette),
                            border: Border.all(
                              width: (3 * settingsState.sizeFactor ),
                              color: getLogicalTileBorderColor(tileObject,visualTileObject,palette,logicalTileBorderColor,gamePlayState,widget.index),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10* settingsState.sizeFactor)),
                          ),
                          child: Center(
                            child: DefaultTextStyle(
                              style: getLogicalTileTextStyle(tileObject, settingsState.sizeFactor,visualTileTextColor,palette, settingsState),
                              child: Text(tileObject["letter"]),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Center(
                  child: IgnorePointer(
                    ignoring: !isInWord(gamePlayState, widget.index),
                    child: Padding(
                      padding: EdgeInsets.all(3.0*settingsState.sizeFactor),
                      child: Container(
                        width: getVisualTileSize(gamePlayState,tileSize, visualTileBorderSize),
                        height: getVisualTileSize(gamePlayState,tileSize, visualTileBorderSize),
                        // width: 20,
                        // height: 20,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                          // color: Color.fromARGB(255, 201, 116, 116),
                          border: Border.all(
                            width: (3 * settingsState.sizeFactor),
                            color: getVisualTileColor(gamePlayState,visualTileBorderColor, widget.index) ,
                          ),
                          color: Colors.transparent, //getVisualTileColor(gamePlayState,visualTileBorderColor, widget.index) ,
                          // color:  Colors.red,
                        ),
                        child: Center(
                          // child: Text(
                            
                            child: DefaultTextStyle(
                              style: getVisualTileTextStyle(visualTileObject, settingsState.sizeFactor,visualTileTextColor,palette, settingsState),
                              child: Text(
                                getVisualTileLetter(gamePlayState, widget.index),
                              ),
                              // fontSize: getTileWidgetSize(
                              //   26*settingsState.sizeFactor,
                              //   gamePlayState,
                              //   visualTileBorderSize
                              // ),
                              // color: const Color.fromARGB(255, 245, 245, 245)
                            ),
                          // )
                        ),                                               
                      ),
                    ),
                  ),
                ),
                IgnorePointer(
                  ignoring: gamePlayState.draggedReserveTile.isEmpty, //true,//!isDragged(gamePlayState),
                  child: DragTarget(
                    onAcceptWithDetails: (details) {
                      GameLogic().dropTile(context,widget.index,gamePlayState,audioController);
                    }, 
                    builder: (BuildContext context, List<dynamic> accepted, List<dynamic> rejected) {
                      return draggedTile(
                        {}.isEmpty ? "" : "", 
                        Colors.transparent, 
                        ((MediaQuery.of(context).size.width)  / 7) * settingsState.sizeFactor );
                  }),
                ),

                
              ],
            );
          },
        );
      },
    );
  }
}



/// ===================== HELPERS ==================================

bool isInWord(GamePlayState gamePlayState, int index) {
  List<dynamic> allIds = gamePlayState.validIds.map((e) => e['index']).toList();
  // List<int> allIds = [];
  // for (Map<String,dynamic> item in gamePlayState.validIds) {
  //   allIds.add(item['id']);
  // }
  if (allIds.contains(index)){
    return true;
  } else {
    return false;
  }
}

Color getLogicalTileBorderColor(
  Map<String, dynamic> tileState,
  Map<String, dynamic> visualTile,
  ColorPalette palette,
  Animation tileBorderColorAnimation, 
  GamePlayState gamePlayState,
  int index,
  ) {

  Color res = palette.tileBorderColor;
  
  if (visualTile.isNotEmpty) {
    if (isInWord(gamePlayState, index)) {
      if (tileState['letter'] == "") {
        res = tileBorderColorAnimation.value;
      }
    }
  }
  if (!tileState['alive']) {
    res = Colors.transparent;
  }  
  
  return res;
}


TextStyle getLogicalTileTextStyle(Map<String, dynamic> tileState, double sizeFactor, Animation animation, ColorPalette palette, SettingsState settingsState) {

  final double fontSize = tileState["letter"] == "" ? 0 : (26 * settingsState.sizeFactor);
  final Color color = tileState["active"] ? animation.value ?? palette.tileTextColor : palette.tileTextColor;

  return GoogleFonts.roboto(
    fontSize: fontSize,
    color: color,
  );
}  
Color getLogicalTileColor(Map<String, dynamic> tileObject, ColorPalette palette) {
  late Color color = const Color.fromRGBO(0, 0, 0, 0);
    if (tileObject["letter"] != "") {
      color = palette.tileBgColor;
    } else {
      if (tileObject["alive"]) {
        color = const Color.fromRGBO(0, 0, 0, 0);
      } else {
        color = const Color.fromARGB(134, 87, 87, 87);
      }
    }
  return color;
}

double getLogicalTileSize(double originalSize, Animation onTapAnimation, GamePlayState gamePlayState, int index) {
  late double res = originalSize;
  if (gamePlayState.selectedTileIndex == index) {
    res = originalSize * onTapAnimation.value;
    // res = 20;
  }
  return res;
}


TextStyle getVisualTileTextStyle(Map<String, dynamic> visualTileState, double sizeFactor, Animation animation, ColorPalette palette, SettingsState settingsState) {
  late double fontSize = 0;
  late Color color = Colors.transparent;
  if (visualTileState.isNotEmpty) {
    fontSize = 26*settingsState.sizeFactor;
    color = animation.value;
  }
  return GoogleFonts.roboto(
    fontSize: fontSize,
    color: color,
  );
}

double getVisualTileSize(GamePlayState gamePlayState, double tileSize, Animation tileSizeFoundWord,) {
  late double res = tileSize;
  if (gamePlayState.selectedTileIndex >= -1) {
    res =  res*tileSizeFoundWord.value;
  }
  return res;
}

Color getVisualTileColor(GamePlayState gamePlayState, Animation animation, int index) {
  Color res = Colors.transparent;
  if (isInWord(gamePlayState, index)) {
    // res = Colors.red[200];
    res = animation.value;
  }
  return res;
}

String getVisualTileLetter(GamePlayState gamePlayState, int index) {
  String res = "";
  if (isInWord(gamePlayState,index)) {
    res = gamePlayState.validIds.firstWhere((element) => element['index'] == index)['content'];
  } else {
    res = "";
  }
  return res;
}

double getTileWidgetSize(double originalSize, GamePlayState gamePlayState , Animation sizeAnimation) {
  late double res = originalSize;
  if (gamePlayState.selectedTileIndex >= -1) {
    res = res *sizeAnimation.value;
  }
  return res;    
}

Map<String,dynamic> getVisualTileObject(GamePlayState gamePlayState, int index) {
  late Map<String,dynamic> res = {};
  if (isInWord(gamePlayState, index)) { 
    res = gamePlayState.validIds.firstWhere((element) => element["index"] == index);
  }
  return res;
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

bool isDragged(GamePlayState gamePlayState) {
  if (gamePlayState.draggedReserveTile['body'] != "") {
    return true;
  } else {
    return false;
  }
}