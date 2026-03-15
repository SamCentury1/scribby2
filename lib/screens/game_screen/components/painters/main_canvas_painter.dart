
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/painters/bonus_painters.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/painters/painters.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/painters/perks_bar_painters.dart';
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

    final Rect rect = Offset.zero & size;
    final Paint backgroundPaint = Paint()
      ..shader = RadialGradient(
        colors: [palette.bg1, palette.bg2],
        center: Alignment(0.0,0.24), // You can also use Alignment.topLeft, etc.
        radius: 0.9,              // Relative to the shorter side of the rect
      ).createShader(rect);

    canvas.drawRect(rect, backgroundPaint); // Or drawCircle, drawRRect, etc.

      // Rect canvasRect = Rect.fromCenter(center: canvasCenter,w,h);
    // canvas.drawRect(canvasRect, backgroundPaint);
    // canvas.drawPaint(backgroundPaint);


    // Painters().drawPlayArea(canvas,gamePlayState);
    // Painters().drawGamePlayElements(canvas,size,gamePlayState);

    ScoreboardPainters().drawScoreboardArea(canvas,gamePlayState,palette);
    Painters().drawCountDown(canvas,gamePlayState, palette);
    // Painters().paintPerkCounts(canvas,gamePlayState);
    PerksBarPainters().drawPerksArea(canvas,gamePlayState,palette);


    // Painters().drawAnimationDataOnScreen(canvas,gamePlayState,palette); // shows the animation object

    BonusPainters().drawBonusArea(canvas,gamePlayState,palette);

    Painters().displayRandomLetters(canvas,size,gamePlayState,palette);

    StopWatchPainters().drawStopWatch(canvas, gamePlayState,palette);

    TilePainters().drawTileSwapAnimation(canvas,gamePlayState,palette);

    Painters().drawBoardTiles(canvas,size,gamePlayState,palette);

    Painters().animateExplodingEmptyTile(canvas,gamePlayState,palette);

    Painters().displayReserveLetters(canvas,size,gamePlayState,palette);


    Painters().drawDraggedTileDroppedOnBoard(canvas,gamePlayState,palette);
    
    // this is the glow effect that applies to all tiles available for swapping
    // TilePainters().drawSwappingTileShadow(canvas,gamePlayState);
    TilePainters().highlightTilesOpenForPerk(canvas,gamePlayState);
    
    TilePainters().drawExplodingTile(canvas,gamePlayState, palette);

    Painters().drawWordFoundTiles(canvas,gamePlayState,palette);

    Painters().drawUndoAnimation(canvas,gamePlayState,palette);
    Painters().drawTileAnimatingDownToPosition(canvas,gamePlayState,palette);    
    // drawPauseOverlay(canvas, size, gamePlayState);

    Painters().drawNewPointsAnimation(canvas,gamePlayState, palette);
    // Painters().drawMenuItemChargeAnimations(canvas,gamePlayState);

    // // if a tile menu is open, draw it over other elements
    // TilePainters().drawTileMenu(canvas, gamePlayState);

    // draw the hamburger menu
    // Painters().drawMenuButton(canvas,gamePlayState);

    // Painters().drawTileMenuBuyMoreModal(canvas,gamePlayState);
    Painters().paintGameOverOverlay(canvas,size,gamePlayState,palette);


    if (gamePlayState.isTutorial) {
      TutorialPainters().paintTutorialPainters(canvas,gamePlayState, palette);
    }


    
  }
  @override
  bool shouldRepaint(MainCanvasPainter oldDelegate) => true;
  @override
  bool shouldRebuildSemantics(MainCanvasPainter oldDelegate) => false;  
}



