import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/game_logic.dart';

import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class Tile extends StatefulWidget {
  // final bool selectedTile;
  // final Map<String,dynamic> tileState;
  final int row;
  final int column;

  const Tile({
    super.key,
    // required this.selectedTile,
    // required this.tileState,
    required this.row,
    required this.column,
  });

  @override
  State<Tile> createState() => _TileState();
}

class _TileState extends State<Tile> with TickerProviderStateMixin {
  late AnimationState _animationState;
  // late GamePlayState _gamePlayState;

  late AnimationController _letterBorderColorController2;
  late Animation<Color?> _letterBorderColorAnimation2;

  late AnimationController _letterPlacedFontSizeController;
  // late Animation<double> _letterPlacedFontSizeAnimation;

  // late AnimationController _letterPlacedBgColorController;
  // late Animation<Color?> _letterPlacedBgColorAnimation;

  late AnimationController _tileSizeController;
  late Animation<double> _tileSizeAnimation;

  late AnimationController _letterTextColorController;
  late Animation<Color?> _letterTextColorAnimation;

  late ColorPalette palette;
  // late Map<String,dynamic> tileState;

  @override
  void initState() {
    super.initState();
    palette = Provider.of<ColorPalette>(context, listen: false);
    initializeAnimations(palette);
    _animationState = Provider.of<AnimationState>(context, listen: false);
    // _gamePlayState = Provider.of<GamePlayState>(context, listen: false);
    _animationState.addListener(_handleAnimationStateChange);
    // _gamePlayState.addListener(_handleAnimationStateChange);
  }

  void _handleAnimationStateChange() {
    // for when a word is found
    if (_animationState.shouldRunWordAnimation) {
      _runAnimations();
    }

    // if (_gamePlayState.isGamePaused) {
    //   _letterBorderColorController2.reset();
    //   _tileSizeController.reset();
    //   _letterPlacedFontSizeController.reset();
    //   _letterTextColorController.reset();
    // }
  }

  // void _animationListener() {
  //   if (_letterBorderColorController2.status == AnimationStatus.completed) {
  //     _letterBorderColorController2.reset();
  //     _tileSizeController.reset();
  //     _letterPlacedFontSizeController.reset();
  //     _letterTextColorController.reset();
  //   }
  // }

  void _runAnimations() {
    // reset animations
    _letterBorderColorController2.reset();
    _tileSizeController.reset();
    _letterPlacedFontSizeController.reset();
    _letterTextColorController.reset();
    // execute animations
    _letterBorderColorController2.forward();
    _tileSizeController.forward();
    _letterPlacedFontSizeController.forward();
    _letterTextColorController.forward();
  }

  void initializeAnimations(ColorPalette palette) {
    // WHEN CLICKED, MAKE THE FONT SIZE GO FROM 0 TO 22 OR WHATEVER
    _letterPlacedFontSizeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // final List<TweenSequenceItem<double>> fontSizeTweenSequence = [
    //   TweenSequenceItem(
    //     tween: Tween(begin: 22, end: 22),
    //     weight: 60,
    //   ),
    //   TweenSequenceItem(
    //     tween: Tween(begin: 22, end: 0),
    //     weight: 10,
    //   ),
    //   TweenSequenceItem(
    //     tween: Tween(begin: 0, end: 0),
    //     weight: 30,
    //   ),

    // ];

    // _letterPlacedFontSizeAnimation = TweenSequence<double>(
    //   fontSizeTweenSequence,
    // ).animate(_letterPlacedFontSizeController);

    _letterBorderColorController2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    // Create a sequence of colors with their respective durations
    final List<TweenSequenceItem<Color?>> colorTweenSequenceItems = [
      TweenSequenceItem<Color?>(
        tween: ColorTween(
          begin:
              palette.tileBorderColor, //const Color.fromRGBO(202, 176, 228, 1),
          end: const Color.fromARGB(244, 255, 220, 24),
        ),
        weight: 10,
      ),
      TweenSequenceItem<Color?>(
        tween: ColorTween(
          begin: const Color.fromARGB(244, 255, 220, 24),
          end: const Color.fromARGB(244, 224, 32, 32),
        ),
        weight: 10,
      ),
      TweenSequenceItem<Color?>(
        tween: ColorTween(
          begin: const Color.fromARGB(244, 224, 32, 32),
          end: const Color.fromARGB(244, 255, 220, 24),
        ),
        weight: 10,
      ),
      TweenSequenceItem<Color?>(
        tween: ColorTween(
          begin: const Color.fromARGB(244, 255, 220, 24),
          end: const Color.fromARGB(244, 224, 32, 32),
        ),
        weight: 10,
      ),
      TweenSequenceItem<Color?>(
        tween: ColorTween(
          begin: const Color.fromARGB(244, 224, 32, 32),
          end: const Color.fromARGB(244, 255, 220, 24),
        ),
        weight: 10,
      ),
      TweenSequenceItem<Color?>(
        tween: ColorTween(
          begin: const Color.fromARGB(244, 255, 220, 24),
          end: const Color.fromARGB(0, 0, 0, 0),
        ),
        weight: 10,
      ),
      TweenSequenceItem<Color?>(
        tween: ColorTween(
          begin: const Color.fromARGB(0, 0, 0, 0),
          end:
              palette.tileBorderColor, //const Color.fromRGBO(202, 176, 228, 1),
        ),
        weight: 40,
      ),
    ];

    _letterBorderColorAnimation2 = TweenSequence<Color?>(
      colorTweenSequenceItems,
    ).animate(_letterBorderColorController2);

    // _letterPlacedBgColorController = AnimationController(
    //   vsync: this,
    //   duration: const Duration(milliseconds: 200)
    // );

    // _letterPlacedBgColorAnimation = Tween<Color?>(
    //   // streakSlideEnterTweenSequence
    //   begin: const Color.fromARGB(0, 0, 0, 0),
    //   end: const Color.fromRGBO(202, 176, 228, 1),
    // ).animate(_letterPlacedBgColorController);

    _letterTextColorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    // Create a sequence of colors with their respective durations
    final List<TweenSequenceItem<Color?>> textColorTweenSequenceItems = [
      TweenSequenceItem<Color?>(
        tween: ColorTween(
          begin: palette.tileTextColor,
          end: const Color.fromARGB(244, 255, 220, 24),
        ),
        weight: 10,
      ),
      TweenSequenceItem<Color?>(
        tween: ColorTween(
          begin: const Color.fromARGB(244, 255, 220, 24),
          end: const Color.fromARGB(244, 224, 32, 32),
        ),
        weight: 10,
      ),
      TweenSequenceItem<Color?>(
        tween: ColorTween(
          begin: const Color.fromARGB(244, 224, 32, 32),
          end: const Color.fromARGB(244, 255, 220, 24),
        ),
        weight: 10,
      ),
      TweenSequenceItem<Color?>(
        tween: ColorTween(
          begin: const Color.fromARGB(244, 255, 220, 24),
          end: const Color.fromARGB(244, 224, 32, 32),
        ),
        weight: 10,
      ),
      TweenSequenceItem<Color?>(
        tween: ColorTween(
          begin: const Color.fromARGB(244, 224, 32, 32),
          end: const Color.fromARGB(244, 255, 220, 24),
        ),
        weight: 10,
      ),
      TweenSequenceItem<Color?>(
        tween: ColorTween(
          begin: const Color.fromARGB(244, 255, 220, 24),
          end: const Color.fromARGB(0, 0, 0, 0),
        ),
        weight: 10,
      ),
      TweenSequenceItem<Color?>(
        tween: ColorTween(
          begin: const Color.fromARGB(0, 0, 0, 0),
          end: const Color.fromARGB(0, 0, 0, 0),
        ),
        weight: 40,
      ),
    ];

    _letterTextColorAnimation = TweenSequence<Color?>(
      textColorTweenSequenceItems,
    ).animate(_letterTextColorController);

    _tileSizeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    final List<TweenSequenceItem<double>> tileSizeTweenSequence = [
      TweenSequenceItem(
        tween: Tween(begin: 50, end: 50),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 50, end: 0),
        weight: 10,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0, end: 0),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0, end: 50),
        weight: 20,
      ),
    ];

    _tileSizeAnimation = TweenSequence<double>(
      tileSizeTweenSequence,
    ).animate(_tileSizeController);
  }

  @override
  void dispose() {
    _animationState.removeListener(_handleAnimationStateChange);
    _letterBorderColorController2.dispose();
    _tileSizeController.dispose();
    _letterTextColorController.dispose();
    super.dispose();
  }

  Map<String, dynamic> findTileState(state) {
    Map<String, dynamic> tileState = {};
    tileState = GameLogic().getTileState(state.visualTileState,
        "${(widget.row).toString()}_${(widget.column).toString()}");
    return tileState;
  }

  Color colorTileBg(
      Map<String, dynamic> tileObject, bool darkTheme, ColorPalette palette) {
    late Color color = const Color.fromRGBO(0, 0, 0, 0);
    if (tileObject["active"]) {
      color = const Color.fromRGBO(0, 0, 0, 0);
    } else {
      if (tileObject["letter"] == "") {
        if (tileObject["alive"]) {
          color = const Color.fromRGBO(0, 0, 0, 0);
        } else {
          color = const Color.fromARGB(134, 87, 87, 87);
        }
      } else {
        // color = GameLogic().getColor(darkTheme, palette, "tile_bg");
        color = palette.tileBgColor;
      }
    }
    return color;
  }

  Color colorTileBorder(Map<String, dynamic> tileObject, bool darkTheme,
      ColorPalette palette, Color? animatedColor) {
    late Color color = const Color.fromRGBO(0, 0, 0, 0);
    if (tileObject["active"]) {
      color = animatedColor!;
    } else {
      if (tileObject["alive"]) {
        color =
            palette.tileBorderColor; //const Color.fromRGBO(202, 176, 228, 1);
      } else {
        color = const Color.fromRGBO(0, 0, 0, 0);
      }
    }
    return color;
  }

  @override
  Widget build(BuildContext context) {
    final SettingsController settings =
        Provider.of<SettingsController>(context, listen: false);
    // final Palette palette = Provider.of<Palette>(context, listen: false);
    final ColorPalette palette =
        Provider.of<ColorPalette>(context, listen: false);

    return Consumer<GamePlayState>(
      builder: (context, gamePlayState, child) {
        // final Map<String, dynamic> tileState = GameLogic().getTileState(gamePlayState.visualTileState,"${(widget.row+1).toString()}_${(widget.column+1).toString()}" );
        late Map<String, dynamic> tileState = findTileState(gamePlayState);

        return AnimatedBuilder(
            animation: _letterBorderColorAnimation2,
            builder: (context, child) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                      width: tileState["active"]
                          ? _tileSizeAnimation.value
                          : 50, // widget.tileState["active"] ? _tileSizeAnimation.value : 50,
                      height: tileState["active"]
                          ? _tileSizeAnimation.value
                          : 50, // widget.tileState["active"] ? _tileSizeAnimation.value : 50,
                      decoration: BoxDecoration(
                        // color:  widget.tileState["active"] ?  Color.fromRGBO(0, 0, 0, 0) : widget.tileState["letter"] == "" ? Color.fromRGBO(0, 0, 0, 0)  : Color.fromRGBO(202, 176, 228, 1),
                        // color:  tileState["active"] ?  Color.fromRGBO(0, 0, 0, 0) : tileState["letter"] == "" ? Color.fromRGBO(0, 0, 0, 0)  : Color.fromRGBO(202, 176, 228, 1),
                        color: colorTileBg(
                            tileState, settings.darkTheme.value, palette),
                        border: Border.all(
                            // color: widget.tileState["active"] ?  _letterBorderColorAnimation2.value ?? Color.fromRGBO(202, 176, 228, 1) : Color.fromRGBO(202, 176, 228, 1),
                            // color: tileState["active"] ?  _letterBorderColorAnimation2.value ?? Color.fromRGBO(202, 176, 228, 1) : Color.fromRGBO(202, 176, 228, 1),
                            color: colorTileBorder(
                                tileState,
                                settings.darkTheme.value,
                                palette,
                                _letterBorderColorAnimation2.value),
                            width: 3),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            // fontSize: GameLogic().getFontSize(widget.selectedTile, widget.tileState, _letterPlacedFontSizeAnimation.value),
                            // fontSize: widget.tileState["letter"] == "" ? 0 : 26 ,
                            fontSize: tileState["letter"] == "" ? 0 : 26,
                            // color: widget.tileState["active"] ?  _letterTextColorAnimation.value ?? Color.fromRGBO(0, 0, 0, 1) : Color.fromRGBO(0, 0, 0, 1),
                            color: tileState["active"]
                                ? _letterTextColorAnimation.value ??
                                    const Color.fromRGBO(0, 0, 0, 1)
                                : const Color.fromRGBO(0, 0, 0, 1),
                          ),
                          child: Text(
                              //widget.tileState["letter"],
                              tileState["letter"]
                              // style: TextStyle(
                              // fontSize: 22,
                              // color: widget.tileState["active"] ?  _letterBorderColorAnimation2.value ?? Color.fromRGBO(0, 0, 0, 1) : Color.fromRGBO(0, 0, 0, 1),
                              // ),
                              ),
                        ),
                      )),
                ),
              );
            });
      },
    );
  }
}
