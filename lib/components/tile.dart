// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:scribby_flutter_v2/functions/game_logic.dart';

// import 'package:scribby_flutter_v2/providers/animation_state.dart';
// import 'package:scribby_flutter_v2/providers/game_play_state.dart';
// import 'package:scribby_flutter_v2/providers/settings_state.dart';
// import 'package:scribby_flutter_v2/settings/settings.dart';
// import 'package:scribby_flutter_v2/styles/palette.dart';
// import 'package:scribby_flutter_v2/utils/states.dart';

// class Tile extends StatefulWidget {
//   // final bool selectedTile;
//   // final Map<String,dynamic> tileState;
//   // final int row;
//   // final int column;
//   final int index;
//   final double tileSize;

//   const Tile({
//     super.key,
//     // required this.selectedTile,
//     // required this.tileState,
//     // required this.row,
//     // required this.column,
//     required this.index,
//     required this.tileSize
//   });

//   @override
//   State<Tile> createState() => _TileState();
// }

// class _TileState extends State<Tile> with TickerProviderStateMixin {
//   late AnimationState _animationState;
//   // late GamePlayState _gamePlayState;

//   late AnimationController _letterBorderColorController2;
//   late Animation<Color?> _letterBorderColorAnimation2;

//   late AnimationController _letterPlacedFontSizeController;
//   // late Animation<double> _letterPlacedFontSizeAnimation;

//   // late AnimationController _letterPlacedBgColorController;
//   // late Animation<Color?> _letterPlacedBgColorAnimation;

//   late AnimationController _tileSizeController;
//   late Animation<double> _tileSizeAnimation;


//   late AnimationController _tilePressedSizeController;
//   late Animation<double> _tilePressedSizeAnimation; 

//     late AnimationController _tilePressedOutSizeController;
//   late Animation<double> _tilePressedOutSizeAnimation;  

//   late AnimationController _letterTextColorController;
//   late Animation<Color?> _letterTextColorAnimation;

//   late ColorPalette palette;
//   late SettingsState settingsState;
  
//   // late Map<String,dynamic> tileState;

//   @override
//   void initState() {
//     super.initState();
//     palette = Provider.of<ColorPalette>(context, listen: false);
//     settingsState = Provider.of<SettingsState>(context, listen: false);
    
    
//     initializeAnimations(palette, settingsState, widget.tileSize);
//     _animationState = Provider.of<AnimationState>(context, listen: false);
//     // _gamePlayState = Provider.of<GamePlayState>(context, listen: false);
//     _animationState.addListener(_handleAnimationStateChange);
//     // _gamePlayState.addListener(_handleAnimationStateChange);
//   }

//   void _handleAnimationStateChange() {
//     // for when a word is found
//     if (_animationState.shouldRunWordAnimation) {
//       _runAnimations();
//     }


//     if (_animationState.shouldRunTilePressedAnimation) {
//       _runTilePressedAnimation();
//     }

//     if (_animationState.shouldRunAnimation) {
//       _runTilePressedOutAnimation();
//     }

//   }

//   void _runTilePressedAnimation() {
//     _tilePressedSizeController.reset();
//     _tilePressedSizeController.forward();
//   }

//   void _runTilePressedOutAnimation() {
//     _tilePressedOutSizeController.reset();
//     _tilePressedOutSizeController.forward();
//   }

//   void _runAnimations() {
//     // reset animations
//     _letterBorderColorController2.reset();
//     _tileSizeController.reset();
//     _letterPlacedFontSizeController.reset();
//     _letterTextColorController.reset();
//     // execute animations
//     _letterBorderColorController2.forward();
//     _tileSizeController.forward();
//     _letterPlacedFontSizeController.forward();
//     _letterTextColorController.forward();
//   }

//   void initializeAnimations(ColorPalette palette, SettingsState settingsState, double tileSize) {

//     Color color_1 = const Color.fromARGB(244, 255, 220, 24);
//     Color color_2 = const Color.fromARGB(244, 224, 32, 32);
//     // WHEN CLICKED, MAKE THE FONT SIZE GO FROM 0 TO 22 OR WHATEVER
//     _letterPlacedFontSizeController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     );

//     _letterBorderColorController2 = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     );
//     // Create a sequence of colors with their respective durations
//     final List<TweenSequenceItem<Color?>> colorTweenSequenceItems = [
//       TweenSequenceItem<Color?>(tween: ColorTween(begin:palette.tileBorderColor,),weight: 10,),
//       TweenSequenceItem<Color?>(tween: ColorTween(begin: color_1,end: color_2,),weight: 10,),
//       TweenSequenceItem<Color?>(tween: ColorTween(begin: color_2,end: color_1,),weight: 10,),
//       TweenSequenceItem<Color?>(tween: ColorTween(begin: color_1,end: color_2,),weight: 10,),
//       TweenSequenceItem<Color?>(tween: ColorTween(begin: color_2,end: color_1,),weight: 10,),
//       TweenSequenceItem<Color?>(tween: ColorTween(begin: color_1,end: Colors.transparent,),weight: 10,),
//       TweenSequenceItem<Color?>(tween: ColorTween(begin: Colors.transparent,end:palette.tileBorderColor,),weight: 40,),
//     ];

//     _letterBorderColorAnimation2 = TweenSequence<Color?>(
//       colorTweenSequenceItems,
//     ).animate(_letterBorderColorController2);


//     _letterTextColorController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     );
//     // Create a sequence of colors with their respective durations
//     final List<TweenSequenceItem<Color?>> textColorTweenSequenceItems = [
//       TweenSequenceItem<Color?>(tween: ColorTween(begin: palette.tileTextColor,end: color_1,),weight: 10,),
//       TweenSequenceItem<Color?>(tween: ColorTween(begin: color_1,end: color_2,),weight: 10,),
//       TweenSequenceItem<Color?>(tween: ColorTween(begin: color_2,end: color_1,),weight: 10,),
//       TweenSequenceItem<Color?>(tween: ColorTween(begin: color_1,end: color_2,),weight: 10,),
//       TweenSequenceItem<Color?>(tween: ColorTween(begin: color_2,end: color_1,),weight: 10,),
//       TweenSequenceItem<Color?>(tween: ColorTween(begin: color_1,end: const Color.fromARGB(0, 0, 0, 0),),weight: 10,),
//       TweenSequenceItem<Color?>(tween: ColorTween(begin: Colors.transparent, end: Colors.transparent,),weight: 40,),
//     ];

//     _letterTextColorAnimation = TweenSequence<Color?>(
//       textColorTweenSequenceItems,
//     ).animate(_letterTextColorController);

//     _tileSizeController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     );

//     final List<TweenSequenceItem<double>> tileSizeTweenSequence = [
//       TweenSequenceItem(tween: Tween(begin: tileSize, end: tileSize),weight: 50,),
//       TweenSequenceItem(tween: Tween(begin: tileSize, end: 0),weight: 10,),
//       TweenSequenceItem(tween: Tween(begin: 0, end: 0),weight: 20,),
//       TweenSequenceItem(tween: Tween(begin: 0, end: tileSize),weight: 20,),
//     ];

//     _tileSizeAnimation = TweenSequence<double>(
//       tileSizeTweenSequence,
//     ).animate(_tileSizeController);


//     _tilePressedSizeController = AnimationController(
//     vsync: this, duration: const Duration(milliseconds: 100));

//     _tilePressedSizeAnimation = Tween<double>(
//       // streakSlideEnterTweenSequence
//       begin:  1.0,
//       end: 0.7,
//     ).animate(_tilePressedSizeController);  


//     _tilePressedOutSizeController = AnimationController(
//     vsync: this, duration: const Duration(milliseconds: 350));


//     final List<TweenSequenceItem<double>> tilePressedOutSizeTweenSequence = [
//       TweenSequenceItem(tween: Tween(begin: 0.7, end: 1.1),weight: 25,),
//       TweenSequenceItem(tween: Tween(begin: 1.1, end: 0.9),weight: 25,),
//       TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.05),weight: 25,),
//       TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0),weight: 25,),      
//     ];  

//     _tilePressedOutSizeAnimation = TweenSequence<double>(
//       tilePressedOutSizeTweenSequence,
//     ).animate(_tilePressedOutSizeController);     
//   }

//   @override
//   void dispose() {
//     _animationState.removeListener(_handleAnimationStateChange);
//     _letterBorderColorController2.dispose();
//     _tileSizeController.dispose();
//     _letterTextColorController.dispose();
//     _tilePressedSizeController.dispose();
//     _letterPlacedFontSizeController.dispose();
//     super.dispose();
//   }

//   Map<String, dynamic> findTileState(GamePlayState gamePlayState, int index) {
//     Map<String, dynamic> tileState = {};
//     String tileKey = tileKeys[index];
//     tileState = GameLogic().getTileState(gamePlayState.visualTileState, tileKey);
//     return tileState;
//   }

//   Color colorTileBg(
//       Map<String, dynamic> tileObject, bool darkTheme, ColorPalette palette) {
//     late Color color = const Color.fromRGBO(0, 0, 0, 0);
//     if (tileObject["active"]) {
//       color = const Color.fromRGBO(0, 0, 0, 0);
//     } else {
//       if (tileObject["letter"] == "") {
//         if (tileObject["alive"]) {
//           color = const Color.fromRGBO(0, 0, 0, 0);
//         } else {
//           color = const Color.fromARGB(134, 87, 87, 87);
//         }
//       } else {
//         color = palette.tileBgColor;
//       }
//     }
//     return color;
//   }

//   double getTileSize(Animation animation, double size, Map<String,dynamic> tileState, GamePlayState gamePlayState, Animation pressedSizeFactor, Animation pressedOutSizeFactor) {
//     double res = size;

//     if (gamePlayState.isTileTapped == null) {
//       if (tileState["active"]) {
//         res = _tileSizeAnimation.value;
//       } else {
//         if (tileState['tileId'] == gamePlayState.pressedTile) {
//           res = size*pressedOutSizeFactor.value;
//         }
//       }
//     } else {
//       String pressedTileId = tileKeys[gamePlayState.isTileTapped];
//       if (pressedTileId == tileState['tileId']) {
//         res = size*pressedSizeFactor.value * pressedOutSizeFactor.value;
//       }
//     }
//     return res;
//   }

//   Color colorTileBorder(Map<String, dynamic> tileObject, bool darkTheme,
//       ColorPalette palette, Color? animatedColor) {
//     late Color color = const Color.fromRGBO(0, 0, 0, 0);
//     if (tileObject["active"]) {
//       color = animatedColor!;
//     } else {
//       if (tileObject["alive"]) {
//         color = palette.tileBorderColor; //const Color.fromRGBO(202, 176, 228, 1);
//       } else {
//         color = const Color.fromRGBO(0, 0, 0, 0);
//       }
//     }
//     return color;
//   }

//   TextStyle getTileTextStyle(Map<String, dynamic> tileState, double sizeFactor, Animation animation, ColorPalette palette) {

//     final double fontSize = tileState["letter"] == "" ? 0 : (26 * settingsState.sizeFactor);
//     final Color color = tileState["active"] ? animation.value ?? palette.tileTextColor : palette.tileTextColor;

//     return GoogleFonts.roboto(
//       fontSize: fontSize,
//       color: color,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final SettingsController settings = Provider.of<SettingsController>(context, listen: false);
//     final ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
//     final SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);        

//     return Consumer<GamePlayState>(
//       builder: (context, gamePlayState, child) {
//         late Map<String, dynamic> tileState = findTileState(gamePlayState, widget.index);
        

//         return AnimatedBuilder(
//           animation: Listenable.merge([_letterBorderColorAnimation2,_tilePressedSizeAnimation, _tilePressedOutSizeAnimation]),
//           builder: (context, child) {

//             final double tileSize = getTileSize(
//               _tileSizeAnimation, 
//               widget.tileSize, 
//               tileState, 
//               gamePlayState, 
//               _tilePressedSizeAnimation,
//               _tilePressedOutSizeAnimation
//             );

//             return Center(
//               child: Padding(
//                 padding:  EdgeInsets.all(2.0 * settingsState.sizeFactor),
//                 child: Container(
//                   width: tileSize,
//                   height: tileSize, 
//                     decoration: BoxDecoration(
//                       color: colorTileBg( tileState, settings.darkTheme.value, palette),
//                       border: Border.all(
//                         color: colorTileBorder(
//                           tileState,
//                           settings.darkTheme.value,
//                           palette,
//                           _letterBorderColorAnimation2.value
//                         ),
//                         width: (3 * settingsState.sizeFactor)
//                       ),
//                       borderRadius: BorderRadius.all(Radius.circular(10* settingsState.sizeFactor)),
//                     ),
//                     child: Center(
//                       child: AnimatedDefaultTextStyle(
//                         duration: const Duration(milliseconds: 200),
//                         style: getTileTextStyle(tileState, settingsState.sizeFactor,_letterTextColorAnimation,palette),
//                         child: Text(tileState["letter"]),
//                       ),
//                     )),
//               ),
//             );
//           }
//         );
//       },
//     );
//   }
// }
