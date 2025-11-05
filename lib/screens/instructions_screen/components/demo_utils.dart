import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';

class DemoUtils {

  Canvas paintDemoTile(Canvas canvas,String tileId, Map<String,dynamic> boardState, Offset center, double tileSize,int elapsedTime, ColorPalette palette) {

    String body = boardState[tileId];

    double updatedTileSize = tileSize;
    
    if (boardState["wordFoundIds"].contains(tileId)) {
      double progress = getWordFoundTileEffect(elapsedTime,boardState["wordFoundIds"],tileId,);
      updatedTileSize = tileSize - (tileSize*0.2*progress);
    }  

    Rect randomLetter1Rect = Rect.fromCenter(center: center, width: updatedTileSize, height: updatedTileSize);
    RRect randomLetter1RRect = RRect.fromRectAndRadius(randomLetter1Rect, Radius.circular(updatedTileSize*0.15));

    Paint tilePaint = getTilePaint(boardState,tileId,updatedTileSize,center,elapsedTime,palette);
    canvas.drawRRect(randomLetter1RRect, tilePaint);
    Color textColor = getWordFoundColor(boardState,tileId,elapsedTime);
    drawDemoText(canvas,tileSize*0.65,body,center,textColor);
    return canvas;
  }

  Color getWordFoundColor(Map<String,dynamic> boardState, String tileId,int elapsedTime) {
    Color color = Color.fromARGB(248, 240, 240, 240);
    if (boardState["wordFoundIds"].contains(tileId)) {
      double progress = getWordFoundTileEffect(elapsedTime,boardState["wordFoundIds"],tileId,);
      color = Color.lerp(Colors.red, Colors.yellow, progress)??Colors.red;
    }
    return color; 
  }

  Paint getTilePaint(Map<String,dynamic> boardState, String tileId, double tileSize, Offset tileCenter, int elapsedTime,ColorPalette palette) {
      List<Offset> offsets = [
        Offset(tileCenter.dx-(tileSize/2), tileCenter.dy-(tileSize/2)),
        Offset(tileCenter.dx+(tileSize/2), tileCenter.dy+(tileSize/2))
      ];
      List<Color> emptyColors = [palette.gameplayEmptyTileFill1, palette.gameplayEmptyTileFill2];
      List<Color> fullColors = [palette.tileColor1, palette.tileColor2];
      List<Color> colors = boardState[tileId] == "" ? emptyColors : fullColors;
      Paint tilePaint = Paint();
      tilePaint.shader = ui.Gradient.linear(
        offsets[0],offsets[1],
        colors,
      );

      if (boardState["wordFoundIds"].contains(tileId)) {
        // double progress = getWordFoundTileEffect(elapsedTime,boardState["wordFoundIds"],tileId,);
        // Color color = Color.lerp(Colors.red, Colors.yellow, progress)??Colors.red;
        Color color = getWordFoundColor(boardState,tileId,elapsedTime);
        Paint wordFoundPaint = Paint();
        wordFoundPaint.color = color;
        wordFoundPaint.style = PaintingStyle.stroke;
        wordFoundPaint.strokeCap = StrokeCap.round;
        wordFoundPaint.strokeWidth = 2.0;

        tilePaint = wordFoundPaint;
      }
      return tilePaint;
  }


  TextPainter drawDemoText(Canvas canvas, double fontSize, String body, Offset center, Color color) {
    TextStyle textStyle = TextStyle(
      color: color, //const Color.fromARGB(248, 240, 240, 240),
      fontSize: fontSize,
    );
    TextSpan textSpan = TextSpan(
      text: body,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final position = Offset(center.dx - (textPainter.width/2), center.dy - (textPainter.height/2));
    textPainter.paint(canvas, position);
    return textPainter;
  }


  double getWordFoundTileEffect(int duration, List<String> tileIds, String tileId) {
    // int duration = gamePlayState.highlightEffectDuration.inMilliseconds;
    int totalTiles = tileIds.length;
    int tileIndex = tileIds.indexOf(tileId);
    if (totalTiles <= 0) return 0.05; // Prevent division by zero

    // Base frequency for a full cycle in 1000ms
    const double baseFrequency = 8 * pi / 100;
    
    // Assign a unique speed factor to each tile (between 0.8x and 1.2x speed variation)
    double speedFactor = 0.8 + (0 % totalTiles) * (0.05 / (totalTiles - 1));

    // Calculate frequency per tile
    double tileFrequency = baseFrequency * speedFactor;

    // Phase shift to ensure different wave offsets
    double phaseShift = (tileIndex % totalTiles) * (2 * pi / totalTiles);

    // Normalize sine wave to range 0.0 - 1.0
    double res = 0.4 + 0.3 * (sin(duration * tileFrequency + phaseShift) + 1);
    return res;
  }

  Offset getTransitionPosition(Offset origin, Offset destination, double progress) {

    final double deltaX = destination.dx - origin.dx;
    final double deltaY = destination.dy - origin.dy;

    final double dx = origin.dx + deltaX * progress;
    final double dy = origin.dy + deltaY * progress;

    final Offset position = Offset(dx,dy);
    return position;

  }

  double getTileSize(double tileSizeOrigin, double tileSizeDestination, double progress) {
    final double delta = tileSizeDestination-tileSizeOrigin;
    late double res = tileSizeOrigin + delta*progress;
    return res;
  }


}