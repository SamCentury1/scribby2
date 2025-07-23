
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/painters/bonus_painters.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/painters/painters.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/painters/scoreboard_painters.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/painters/stop_watch_painters.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/painters/tile_painters.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/painters/tutorial_painters.dart';

class MainCanvasPainter extends CustomPainter {
  final GamePlayState gamePlayState;
  final ColorPalette palette;
  MainCanvasPainter({
    required this.gamePlayState,
    required this.palette,
  });
   
  @override  
  void paint(Canvas canvas, Size size) {

    Paint backgroundPaint = Paint()
    ..shader = ui.Gradient.linear(
      Offset.zero,
      Offset(size.width,size.height),
      [
        palette.bg1,
        palette.bg2
        // const ui.Color.fromARGB(255, 55, 116, 173),
        // const ui.Color.fromARGB(255, 38, 9, 92)
      ],
    );


      // Rect canvasRect = Rect.fromCenter(center: canvasCenter,w,h);
    // canvas.drawRect(canvasRect, backgroundPaint);
    canvas.drawPaint(backgroundPaint);


    // Painters().drawPlayArea(canvas,gamePlayState);
    // Painters().drawGamePlayElements(canvas,size,gamePlayState);

    ScoreboardPainters().drawScoreboardArea(canvas,gamePlayState,palette);
    Painters().drawCountDown(canvas,gamePlayState, palette);
    Painters().paintPerkCounts(canvas,gamePlayState);


    // Painters().drawBonusArea(canvas,gamePlayState,palette);

    BonusPainters().drawBonusArea(canvas,gamePlayState);

    Painters().displayRandomLetters(canvas,size,gamePlayState);

    StopWatchPainters().drawStopWatch(canvas, gamePlayState,palette);

    TilePainters().drawTileSwapAnimation(canvas,gamePlayState);

    Painters().drawBoardTiles(canvas,size,gamePlayState,);

    Painters().animateExplodingEmptyTile(canvas,gamePlayState,palette);

    Painters().displayReserveLetters(canvas,size,gamePlayState,);


    Painters().drawDraggedTileDroppedOnBoard(canvas,gamePlayState,palette);
    
    // this is the glow effect that applies to all tiles available for swapping
    TilePainters().drawSwappingTileShadow(canvas,gamePlayState);
    
    TilePainters().drawExplodingTile(canvas,gamePlayState);

    Painters().drawWordFoundTiles(canvas,gamePlayState);

    Painters().drawTileAnimatingDownToPosition(canvas,gamePlayState);    
    // drawPauseOverlay(canvas, size, gamePlayState);

    Painters().drawNewPointsAnimation(canvas,gamePlayState, palette);
    // Painters().drawMenuItemChargeAnimations(canvas,gamePlayState);

    // if a tile menu is open, draw it over other elements
    TilePainters().drawTileMenu(canvas, gamePlayState);

    // draw the hamburger menu
    // Painters().drawMenuButton(canvas,gamePlayState);

    // Painters().drawTileMenuBuyMoreModal(canvas,gamePlayState);
    Painters().paintGameOverOverlay(canvas,size,gamePlayState);

    if (gamePlayState.isTutorial) {
      TutorialPainters().paintTutorialPainters(canvas,gamePlayState, palette);
    }


    
  }
  @override
  bool shouldRepaint(MainCanvasPainter oldDelegate) => true;
  @override
  bool shouldRebuildSemantics(MainCanvasPainter oldDelegate) => false;  
}



