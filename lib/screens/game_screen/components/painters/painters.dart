// import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scribby_flutter_v2/functions/animation_utils.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/functions/styling_utils.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/painters/tile_painters.dart';

class Painters {

  Canvas drawBonusArea(Canvas canvas, GamePlayState gamePlayState, ColorPalette palette) {
    Offset bonusCenter = gamePlayState.elementPositions["bonusCenter"];
    // Size tileSize = gamePlayState.elementSizes["tileSize"];

    final List<Map<String,dynamic>> animationData = gamePlayState.animationData;

    String content = '''''';
    for (int i=0; i<animationData.length;i++) {

      String body = "${animationData[i]["key"]} - ${animationData[i]["type"]} - progress: ${animationData[i]["progress"]} \n";
      content = content + (body);
      
    }

    if (gamePlayState.isTutorial) {
      content = content + "\n \n \n";
      int currentTurn = gamePlayState.tutorialData["currentTurn"];
      List<Map<String,dynamic>> steps = gamePlayState.tutorialData["steps"];
      Map<String,dynamic> step = steps.firstWhere((e)=>e["step"]==currentTurn,orElse: ()=>{});
      if (step.isNotEmpty) {
        step.forEach((k,v)  {
          String body = "----  $k : $v  ---- \n"  ;
          content = content+body;
        });
      }
    }


    // Helpers().displayText(canvas, content, gamePlayState, bonusCenter, tileSize);

    TextStyle textStyle = TextStyle(
      color: palette.gameplayText1, //const Color.fromARGB(190, 123, 191, 255),
      fontSize: 14* gamePlayState.scalor,
    );
    TextSpan textSpan = TextSpan(
      text: content,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final position = Offset(bonusCenter.dx - (textPainter.width/2), bonusCenter.dy - (textPainter.height/2));
    textPainter.paint(canvas, position);
    // return textPainter;     
    return canvas;
  }


  // Canvas drawPlayArea(Canvas canvas, GamePlayState gamePlayState) {
  //     // Size playAreaSize = gamePlayState.elementSizes["playAreaSize"];
  //     Size effectiveAreaSize = gamePlayState.elementSizes["effectiveSize"];
  //     // Size safeArea = gamePlayState.elementSizes["playAreaSize"];
  //     Offset screenCenter = gamePlayState.elementPositions["screenCenter"];
  //     Offset effectiveCenter = gamePlayState.elementPositions["effectiveCenter"];

  //     Paint playAreaPaint = Paint()
  //     ..color = ui.Color.fromARGB(255, 255, 0, 0)
  //     ..strokeCap = StrokeCap.round
  //     ..style = PaintingStyle.stroke
  //     ..strokeWidth = 2.0;

  //     Paint playAreaPaint2 = Paint()
  //     ..color = ui.Color.fromARGB(255, 139, 255, 7)
  //     ..strokeCap = StrokeCap.round
  //     ..style = PaintingStyle.stroke
  //     ..strokeWidth = 2.0;      

  //     // final double gap = 68.9523; 
  //     // final double updatedY = effectiveCenter.dy-44.5;
  //     // Offset updatedCenter = Offset(effectiveCenter.dx,updatedY);

  //     Rect playAreaRect = Rect.fromCenter(center: effectiveCenter, width: effectiveAreaSize.width, height: effectiveAreaSize.height);
  //     canvas.drawRect(playAreaRect, playAreaPaint);


  //     canvas.drawCircle(screenCenter, 1.0, playAreaPaint);

  //     canvas.drawCircle(effectiveCenter, 1.0, playAreaPaint2);

  //     return canvas;

  // }


  // Canvas drawGamePlayElements(Canvas canvas, Size size, GamePlayState gamePlayState) {

    // // final Size safeAreaSize = gamePlayState.elementSizes["safeArea"];
    // final Size scoreboardSize = gamePlayState.elementSizes["scoreboard"];
    // final Size screenSizeSize = gamePlayState.elementSizes["screenSize"];
    // final Size playAreaSize = gamePlayState.elementSizes["effectiveSize"];
    // final Size gapSpaceSize = gamePlayState.elementSizes["gapSpace"];
    // final Size randomLettersSize = gamePlayState.elementSizes["randomLetters"];
    // final Size boardSize = gamePlayState.elementSizes["board"];
    // final Size reserveLettersSize = gamePlayState.elementSizes["reserveLetters"];
    // final Size tileSize = gamePlayState.elementSizes["tileSize"];
    // final Size bonusSize = gamePlayState.elementSizes["bonus"];

    // late double playAreaHorizontalGap = ((size.width-playAreaSize.width)/2)+(safeAreaSize.height);
    // late double playAreaVerticalGap = (size.height-playAreaSize.height)/2;

    // late double centerX = size.width/2;
    // late double gapHeight = gapSpaceSize.height/3;



    
    // // -------- safe area ----------------------
    // Paint safeAreaPaint = Paint()
    // ..color = Colors.black;

    // // Rect safeAreaRect = Rect.fromCenter(center: safeAreaCenter, width: scoreboardSize.width, height: scoreboardSize.height);
    // Offset playAreaCenter = gamePlayState.elementPositions["screenCenter"];
    // Rect safeAreaRect = Rect.fromCenter(center:playAreaCenter,width:playAreaSize.width,height:playAreaSize.height);
    // canvas.drawRect(safeAreaRect, safeAreaPaint);
    // // ----------------------------------------------    

    
    // // Rect safeAreaRect = Rect.fromCenter(center: safeAreaCenter, width: scoreboardSize.width, height: scoreboardSize.height);
    // Rect safeAreaRect = Rect.fromLTWH(0.0,0.0,safeAreaSize.width,safeAreaSize.height);
    // canvas.drawRect(safeAreaRect, safeAreaPaint);
    // ----------------------------------------------


    // // -------- scoreboard ----------------------
    // Paint scoreboardPaint = Paint()
    // ..color = const ui.Color.fromARGB(164, 121, 85, 72);

    // // Offset scoreboardCenter = Offset(centerX, (playAreaVerticalGap+ (scoreboardSize.height/2)));
    // Offset scoreboardCenter = gamePlayState.elementPositions["scoreboard"];
    // Rect scoreboardRect = Rect.fromCenter(center: scoreboardCenter, width: scoreboardSize.width, height: scoreboardSize.height);
    // canvas.drawRect(scoreboardRect, scoreboardPaint);
    // // ----------------------------------------------

    // // -------- gap 1 ----------------------
    // Paint gap1Paint = Paint()
    // ..color = const ui.Color.fromARGB(179, 245, 189, 33);
    // playAreaVerticalGap = playAreaVerticalGap + (safeAreaSize.height/2) + scoreboardSize.height;
    // Offset gapCenter1 = Offset(centerX,(playAreaVerticalGap+((gapHeight)/2)));
    // Rect gap1Rect = Rect.fromCenter(center: gapCenter1, width: gapSpaceSize.width, height: gapHeight);
    // canvas.drawRect(gap1Rect, gap1Paint);
    // // ----------------------------------------------

    // // -------- bonus ----------------------
    // Paint bonusSectionPaint = Paint()
    // ..color = const ui.Color.fromARGB(141, 124, 235, 50);
    // playAreaVerticalGap = playAreaVerticalGap + (gapHeight);
    // // Offset bonusCenter = Offset(centerX,(playAreaVerticalGap+(bonusSize.height/2)));
    // Offset bonusCenter = gamePlayState.elementPositions["bonus"];
    // Rect bonusRect = Rect.fromCenter(center: bonusCenter, width: bonusSize.width, height: bonusSize.height);
    // canvas.drawRect(bonusRect, bonusSectionPaint);
    // // ----------------------------------------------
    
    // // -------- gap 2 ----------------------
    // Paint gap2Paint = Paint()
    // ..color = const ui.Color.fromARGB(110, 203, 62, 231); 
    // playAreaVerticalGap = playAreaVerticalGap + bonusSize.height;
    // Offset gapCenter2 = Offset(centerX,(playAreaVerticalGap+((gapHeight)/2)));
    // Rect gap2Rect = Rect.fromCenter(center: gapCenter2, width: gapSpaceSize.width, height: gapHeight);
    // canvas.drawRect(gap2Rect, gap2Paint);
    // // ----------------------------------------------
    
    // // // -------- random letters ----------------------
    // Paint randomLettersSectionPaint = Paint()
    // ..color = const ui.Color.fromARGB(146, 55, 190, 224);
    // playAreaVerticalGap = playAreaVerticalGap + (gapHeight);
    // // Offset randomLettersSectionCenter = Offset(centerX,(playAreaVerticalGap+(randomLettersSize.height/2)));
    // Offset randomLettersSectionCenter = gamePlayState.elementPositions["randomLetters"];
    // Rect randomLetterSectionRect = Rect.fromCenter(center: randomLettersSectionCenter, width: randomLettersSize.width, height: randomLettersSize.height);
    // canvas.drawRect(randomLetterSectionRect, randomLettersSectionPaint);
    // // // ----------------------------------------------

    // // // -------- board ----------------------
    // Paint boardPaint = Paint()
    // ..color = const ui.Color.fromARGB(162, 1, 45, 75);  
    // playAreaVerticalGap = playAreaVerticalGap + randomLettersSize.height;
    // // Offset boardCenter = Offset(centerX, playAreaVerticalGap+ (boardSize.height/2));
    // Offset boardCenter = gamePlayState.elementPositions["board"];
    // Rect boardRect = Rect.fromCenter(center: boardCenter, width: boardSize.width, height: boardSize.height);
    // canvas.drawRect(boardRect, boardPaint);
    // // // ----------------------------------------------

    // // // -------- gap 3 ----------------------
    // // Paint gap3Paint = Paint()
    // // ..color = const ui.Color.fromARGB(255, 70, 252, 54);
    // // playAreaVerticalGap = playAreaVerticalGap + boardSize.height;
    // // Offset gapCenter3 = Offset(centerX,(playAreaVerticalGap+((gapHeight)/2)));
    // // Rect gap3Rect = Rect.fromCenter(center: gapCenter3, width: gapSpaceSize.width, height: gapHeight);
    // // canvas.drawRect(gap3Rect, gap3Paint);
    // // // ----------------------------------------------

    // // // -------- reserves ----------------------
    // Paint reservesSectionPaint = Paint()
    // ..color = const Color.fromARGB(255, 184, 15, 15);
    // playAreaVerticalGap = playAreaVerticalGap + boardSize.height;
    // // Offset reserveLettersCenter = Offset(centerX, playAreaVerticalGap+ (reserveLettersSize.height/2));
    // Offset reserveLettersCenter = gamePlayState.elementPositions["reserveLetters"];
    // Rect reserveLettersRect = Rect.fromCenter(center: reserveLettersCenter, width: reserveLettersSize.width, height: reserveLettersSize.height);
    // canvas.drawRect(reserveLettersRect, reservesSectionPaint);
    // // // ----------------------------------------------

    // // -------- gap 4 ----------------------
    // Paint gap4Paint = Paint()
    // ..color = const ui.Color.fromARGB(255, 13, 158, 86);
    // playAreaVerticalGap = playAreaVerticalGap + (reserveLettersSize.height);
    // Offset gapCenter4 = Offset(centerX,(playAreaVerticalGap+((gapHeight)/2)));
    // Rect gap4Rect = Rect.fromCenter(center: gapCenter4, width: gapSpaceSize.width, height: gapHeight);
    // canvas.drawRect(gap4Rect, gap4Paint);
    // // ----------------------------------------------



    // return canvas;

  // }


  Canvas drawTileAnimatingDownToPosition(Canvas canvas, GamePlayState gamePlayState, ColorPalette palette) {
    final Size tileSize = gamePlayState.elementSizes["tileSize"];


    List<Map<String,dynamic>> tapReleaseAnimations = gamePlayState.animationData.where((e)=>e["type"]=='tap-up').toList();

    for (int i=0; i<tapReleaseAnimations.length; i++) {
      final int key = tapReleaseAnimations[i]["key"];

      final Offset sourceLocation = tapReleaseAnimations[i]["locationData"]["location"];
      final Size sourceSize = tapReleaseAnimations[i]["locationData"]["size"];
      

      if (tapReleaseAnimations[i]["type"]=='tap-up') {
        Map<String,dynamic> tileObject = gamePlayState.tileData.firstWhere((e)=>e["key"]==key,orElse: ()=>{});
        if (tileObject.isEmpty) {
          tileObject = gamePlayState.reserveTileData.firstWhere((e)=>e["key"]==key,orElse: ()=>{});
        }
        if (tileObject.isNotEmpty) {

          String body = tapReleaseAnimations[i]["body"];

          Offset tileCenter = tileObject["center"];
          final Map<String,dynamic> sourceDecoration = tileObject["decorationData"];

          final double progress = tapReleaseAnimations[i]["progress"];

          // late double reducedFactor = (0.5 * progress);
          // final double newTileWidth = (sourceSize.width) - ((sourceSize.width-tileSize.width)*progress);
          // Size newTileSize = Size(newTileWidth,newTileWidth);

          // Offset randomLetterCenter = gamePlayState.elementPositions["randomLetters"];
          
          late double distanceX = tileCenter.dx-sourceLocation.dx;
          late double distanceY = tileCenter.dy-sourceLocation.dy;

          late double currentX = sourceLocation.dx+(distanceX*progress);
          late double currentY = sourceLocation.dy+(distanceY*progress);

          final Offset newTileCenter = Offset(currentX,currentY);
          if (tileObject["type"]=="board") {
            final double newTileWidth = (sourceSize.width) - ((sourceSize.width-tileSize.width)*progress);
            Size newTileSize = Size(newTileWidth,newTileWidth);            
            // TilePainters().drawTile(canvas,newTileCenter,gamePlayState,body,newTileSize);  
            TilePainters().paintAnimatingTile(canvas, newTileCenter, gamePlayState, body, newTileSize, progress,'random','board-full',sourceDecoration,palette);       
          } else {
            final double newTileWidth = (sourceSize.width) - ((sourceSize.width-tileSize.width*0.8)*progress);
            Size newTileSize = Size(newTileWidth,newTileWidth);            
            // drawReserveTile(canvas, newTileCenter, gamePlayState, body, newTileSize);
            TilePainters().paintAnimatingTile(canvas, newTileCenter, gamePlayState, body, newTileSize, progress,'random','reserve-full',sourceDecoration,palette);  
          }
        }
      }
    }
    return canvas;
  }

  // queries the drag-drop animations, and animates the objects on the canvas
  Canvas drawDraggedTileDroppedOnBoard(Canvas canvas, GamePlayState gamePlayState, ColorPalette palette) {
    // query the "tile-drop" animations. For each tile-drop event, there should be two
    List<Map<String,dynamic>> dropAnimations = gamePlayState.animationData.where((e)=>e["type"]=="tile-drop").toList();

    // get the tile size
    Size tileSize = gamePlayState.elementSizes["tileSize"];
    Size reserveSize = Size(tileSize.width*0.8,tileSize.width*0.8);
    

    // iterate through them
    for (int i=0;i<dropAnimations.length;i++) {

      // get the animation object      
      Map<String,dynamic> animationObject = dropAnimations[i];
      // the animation object saves the tileObject data, get that
      Map<String,dynamic> tileObject = animationObject["tileObject"];
      Map<String,dynamic> decorationData = tileObject["decorationData"];
      // get the progress of the animation
      final double progress = animationObject["progress"];

      // check whether the tile to animate is the source (reserve) or target (board)
      if (tileObject["type"]=="board") {
        // the animation should contain location data about where it's being dropped from
        final Offset dropLocation = animationObject["locationData"]["location"];
        final Size dropSize = animationObject["locationData"]["size"];
        // get the center of the board tile being dropped into
        final Offset tileCenter = tileObject["center"]; 
        // get the letter being dropped
        final String body = animationObject["body"];

        // calculate the coordinates of the tile at the given progress
        late double distanceX = tileCenter.dx-dropLocation.dx;
        late double distanceY = tileCenter.dy-dropLocation.dy;
        late double currentX = dropLocation.dx+(distanceX*progress);
        late double currentY = dropLocation.dy+(distanceY*progress);        
        final Offset newTileCenter = Offset(currentX,currentY);
        // get the tile size at it animates;
        final double newTileWidth = (dropSize.width) - ((dropSize.width-tileSize.width)*progress);
        Size newTileSize = Size(newTileWidth,newTileWidth);
        //get the color


        // draw the tile          
        // TilePainters().drawTile(canvas,newTileCenter,gamePlayState,body,newTileSize);
        
        // paintEmptyTileExplosion(canvas,gamePlayState,animationObject,tileCenter);
        paintEmptyTileExitAnimation(canvas, gamePlayState,palette, tileObject, animationObject, tileCenter);
        TilePainters().paintAnimatingTile(canvas, newTileCenter, gamePlayState, body, newTileSize, progress,'reserve-full','board-full',decorationData, palette);
      } else {
        // the reserve tile keeps the same center the whole animation
        final Offset reserveTileCenter = tileObject["center"];
        // the body should be empty
        final String body = tileObject["body"];
        final String styleType = body=="" ? "reserve-empty" : "reserve-full";
        // the tile grows from nothing to its size
        final double originalWidth = 0.0;

        final double newTileWidth = (originalWidth) - ((originalWidth-reserveSize.width)*progress);
        final Size newTileSize = Size(newTileWidth,newTileWidth);
        // draw the tile
        // drawReserveTile(canvas, reserveTileCenter, gamePlayState, body, newTileSize);
        TilePainters().drawTile2(canvas, reserveTileCenter, body, newTileSize,styleType,decorationData,palette);
      }
    }
    return canvas;
  }

  Canvas drawBoardTiles(Canvas canvas, Size size,  GamePlayState gamePlayState, ColorPalette palette) {

    final Size tileSize = gamePlayState.elementSizes["tileSize"];


    for (int i=0; i<gamePlayState.tileData.length; i++) {
      Map<String,dynamic> tileObject = gamePlayState.tileData[i];
      Offset tileCenter = tileObject["center"];
      Map<String,dynamic> decorationData = tileObject["decorationData"];
      List<Map<String,dynamic>> animationObjects = gamePlayState.animationData.where((e) => e["key"]==tileObject["key"]).toList();
      if (animationObjects.isEmpty) {
        if (!tileObject["active"]) {
          TilePainters().drawTile2(canvas,tileCenter,tileObject["body"],tileSize,'dead',decorationData,palette);
        } else {
          if (tileObject["type"]=="board" && tileObject["frozen"]) {
            TilePainters().drawTile2(canvas,tileCenter,tileObject["body"],tileSize,'board-frozen',decorationData, palette);
          } else {
            String styleType = tileObject["body"]==""?"board-empty":"board-full";
            TilePainters().drawTile2(canvas,tileCenter,tileObject["body"],tileSize,styleType,decorationData, palette);
          }
          
        }        
      }
    }
    
    for (int i=0; i<gamePlayState.tileData.length; i++) {
      Map<String,dynamic> tileObject = gamePlayState.tileData[i];
      Offset tileCenter = tileObject["center"];
      Map<String,dynamic> decorationData = tileObject["decorationData"];

      Map<String,dynamic> animationObject = gamePlayState.animationData.firstWhere((e) => e["key"]==tileObject["key"],orElse:()=>{});
      // List<Map<String,dynamic>> animationObjects = gamePlayState.animationData.where((e) => e["key"]==tileObject["key"]).toList();
      if (animationObject.isNotEmpty) {

        final double progress = animationObject["progress"];

        String animationType = animationObject["type"];
        if (animationType == 'tap-down') {
          final double reduction = 0.8;
          late double reducedFactor = (1.0-reduction) * progress;
          final double newTileWidth = tileSize.width - (reducedFactor*tileSize.width);
          Size newTileSize = Size(newTileWidth,newTileWidth);
          // String styleType = animationObject["body"]==""?"board-empty":"board-full";
          TilePainters().drawTile2(canvas,tileCenter,tileObject["body"],newTileSize,"board-empty",decorationData,palette);
        } else if (animationType=='tap-up') {
          
  
        } else if (animationType=="tap-cancel") {
          final double reduction = 0.8;
          late double reducedFactor = (1.0-reduction) * (1-progress);
          final double newTileWidth = tileSize.width - (reducedFactor*tileSize.width);
          Size newTileSize = Size(newTileWidth,newTileWidth);
          TilePainters().drawTile2(canvas,tileCenter,tileObject["body"],newTileSize,"board-empty",decorationData,palette);        
        } else if (animationType=="pre-word-found") {
          Map<String,dynamic> turnData = gamePlayState.scoreSummary.firstWhere((e)=>e["turn"]==animationObject["turn"],orElse: ()=>{});
          if (turnData.isNotEmpty) {
            if (turnData["moveData"]["type"]=="freeze") {
              int frozenTileKey = turnData["moveData"]["data"]["target"]["key"];
              if (tileObject["key"]==frozenTileKey) {
                List<Map<String,dynamic>> ids = turnData["ids"];
                var frozenTile = ids.firstWhere((e)=>e["id"]==frozenTileKey, orElse: ()=>{});
                String frozenTileBody="";
                if (frozenTile.isNotEmpty) {                  
                  frozenTileBody = frozenTile["body"];
                }
                TilePainters().paintAnimatingTile(canvas, tileCenter, gamePlayState, frozenTileBody, tileSize, progress,'board-frozen','board-full',decorationData,palette);
              } else {
                // String styleType = tileObject["body"]==""?"board-empty":"board-full";
                TilePainters().drawTile2(canvas,tileCenter,animationObject["body"],tileSize,'board-full',decorationData,palette);
              }
            }

            else if (turnData["moveData"]["type"]=="swap") {
              

              int sourceKey = turnData["moveData"]["data"]["source"]["key"];
              int targetKey = turnData["moveData"]["data"]["target"]["key"];

              Offset sourceTilePosition = turnData["moveData"]["data"]["source"]["center"];
              Offset targetTilePosition = turnData["moveData"]["data"]["target"]["center"];

              Map<String,dynamic> sourceObject = gamePlayState.tileData.firstWhere((e)=>e["key"]==sourceKey,orElse: ()=>{});
              Map<String,dynamic> targetObject = gamePlayState.tileData.firstWhere((e)=>e["key"]==targetKey,orElse: ()=>{});
              Map<String,dynamic> sourceDecoration = sourceObject["decorationData"];
              Map<String,dynamic> targetDecoration = targetObject["decorationData"];

              // print("???????????????? $sourceDecoration | $targetDecoration");
              Offset updatedCenter = tileCenter;
              String updatedBody = tileObject["body"];
              late Size updatedSize = tileSize;
              Map<String,dynamic> updatedDecoration = decorationData;
              String styleType = animationObject["body"]==""?"board-empty":"board-full";


              if (tileObject["key"] == sourceKey) {
                double sourceX = sourceTilePosition.dx + (targetTilePosition.dx-sourceTilePosition.dx)*progress;
                double sourceY = sourceTilePosition.dy + (targetTilePosition.dy-sourceTilePosition.dy)*progress;
                // double sourceX = sourceTilePosition.dx; 
                // double sourceY = sourceTilePosition.dy;
                // if (progress > 0.5) {
                //   sourceX = targetTilePosition.dx;
                //   sourceY = targetTilePosition.dy;
                // }
                updatedDecoration = targetDecoration;
                updatedCenter = Offset(sourceX,sourceY);
                updatedBody = turnData["moveData"]["data"]["source"]["body"];
                updatedSize =  AnimationUtils().getSwappedTileSize(gamePlayState,animationObject);
                print("source at progress: $progress size: $updatedSize | pos: $updatedCenter");
              }

              else if (tileObject["key"] == targetKey) {
                double targetX = targetTilePosition.dx + (sourceTilePosition.dx-targetTilePosition.dx)*progress;
                double targetY = targetTilePosition.dy + (sourceTilePosition.dy-targetTilePosition.dy)*progress;
                // double targetX = targetTilePosition.dx; 
                // double targetY = targetTilePosition.dy;
                // if (progress > 0.5) {
                //   targetX = sourceTilePosition.dx;
                //   targetY = sourceTilePosition.dy;
                // }
                updatedDecoration = sourceDecoration;         
                updatedCenter = Offset(targetX,targetY);
                updatedBody = turnData["moveData"]["data"]["target"]["body"];
                updatedSize = AnimationUtils().getSwappedTileSize(gamePlayState,animationObject);
                print("target at progress: $progress size: $updatedSize | pos: $updatedCenter");
              } else {
                updatedBody = animationObject["body"]; 
              }

              

              
              TilePainters().drawTile2(canvas,updatedCenter,updatedBody,updatedSize,styleType,updatedDecoration,palette);  

            }
            else {
              // String styleType = tileObject["body"]==""?"board-empty":"board-full";
              TilePainters().drawTile2(canvas,tileCenter,animationObject["body"],tileSize,'board-full',decorationData,palette);
            }
          }


        } else if (animationType=="tile-drop") {
          // do nothing, there's another animation handling this
        } else if (animationType=="kill-tile") {
          TilePainters().paintAnimatingTile(canvas, tileCenter, gamePlayState, "", tileSize, progress,'board-empty','dead',decorationData,palette); 
        } else if (animationType=="tile-freeze") {
          if (tileObject["frozen"]) {
            TilePainters().paintAnimatingTile(canvas, tileCenter, gamePlayState, tileObject["body"], tileSize, progress,'board-full','board-frozen',decorationData,palette);
          } else {
            TilePainters().paintAnimatingTile(canvas, tileCenter, gamePlayState, tileObject["body"], tileSize, progress,'board-frozen','board-full',decorationData,palette);
          }
        } else if (animationType == "undo") {

        }
      } else {

      }


    }

    return canvas;
  }

  Canvas displayReserveLetters(Canvas canvas, Size size,  GamePlayState gamePlayState, ColorPalette palette) {
    // final Size playAreaSize = gamePlayState.elementSizes["playAreaSize"];
    for (int i=0; i<gamePlayState.reserveTileData.length; i++) {
      Map<String,dynamic> reserveTileObject = gamePlayState.reserveTileData[i];
      final Offset tileCenter = reserveTileObject["center"];
      Map<String,dynamic> decorationData = reserveTileObject["decorationData"];
      // final double tileSize = Helpers().getReserveTileSize(playAreaSize, gamePlayState.reserveTileData.length);
      final Size tileSize = Size(gamePlayState.elementSizes["tileSize"].width*0.8,gamePlayState.elementSizes["tileSize"].height*0.8);

      Map<String,dynamic> animationObject = gamePlayState.animationData.firstWhere((e) => e["key"]==reserveTileObject["key"],orElse:()=>{});

      if (animationObject.isNotEmpty) {
        final double progress = animationObject["progress"];

        String animationType = animationObject["type"];
        if (animationType == 'tap-down') {
          final double reduction = 0.8;
          late double reducedFactor = (1.0-reduction) * progress;
          final double newTileWidth = tileSize.width - (reducedFactor*tileSize.width);
          Size newTileSize = Size(newTileWidth,newTileWidth);
          TilePainters().drawTile2(canvas,tileCenter,reserveTileObject["body"],newTileSize,'reserve-empty',decorationData,palette);
        } else if (animationType=='tap-up') {
          
     
        } else if (animationType=="tap-cancel") {
          final double reduction = 0.8;
          late double reducedFactor = (1.0-reduction) * (1-progress);
          final double newTileWidth = tileSize.width - (reducedFactor*tileSize.width);
          Size newTileSize = Size(newTileWidth,newTileWidth);
          TilePainters().drawTile2(canvas,tileCenter,reserveTileObject["body"],newTileSize,'reserve-empty',decorationData,palette);

        } else if (animationType=="pre-word-found") {
          String styleType = reserveTileObject["body"]==""?"board-empty":"board-full";
          TilePainters().drawTile2(canvas,tileCenter,animationObject["body"],tileSize,styleType,decorationData,palette);
        }  else if (animationType=="undo") {

        }   
      } else {
        String styleType = reserveTileObject["body"]==""?"reserve-empty":"reserve-full";
        if (gamePlayState.draggedElementData == null) {

          TilePainters().drawTile2(canvas,tileCenter,reserveTileObject["body"],tileSize,styleType,decorationData,palette);
        } else {
          if (gamePlayState.draggedElementData!["key"]==reserveTileObject["key"]) {
            Offset updatedCenter = gamePlayState.draggedElementData!["location"];
            TilePainters().drawTile2(canvas,updatedCenter,reserveTileObject["body"],tileSize,styleType,decorationData,palette);
          } else {
            TilePainters().drawTile2(canvas,tileCenter,reserveTileObject["body"],tileSize,styleType,decorationData,palette);
          }
        }


        
      }
    }
    return canvas;
  }

  Canvas displayRandomLetters(Canvas canvas, Size size,  GamePlayState gamePlayState, ColorPalette palette) {

    final Size tileSize = gamePlayState.elementSizes["tileSize"];

    // final double randomLetterCenterY = ((size.height-playAreaSize.height)/2) + scoreboardSize.height+((gapSpaceSize.height/3)*2)+bonusSize.height+(randomLettersSize.height/2);
    final double randomLetterCenterY = gamePlayState.elementPositions["randomLettersCenter"].dy;
    final double randomLetter1CenterX = gamePlayState.elementPositions["randomLettersCenter"].dx;
    final Offset randomLetter1Center = Offset(randomLetter1CenterX,randomLetterCenterY);


    // final double boardWidth = tileSize.width * Helpers().getNumAxis(gamePlayState.tileData)[0];
    final double boardWidth = gamePlayState.elementSizes["playAreaSize"].width;
    final double randomLetter2CenterX =  ((gamePlayState.elementSizes["screenSize"].width-boardWidth)/2) + (boardWidth/2) + (boardWidth/2)/2;
    final Offset randomLetter2Center = Offset(randomLetter2CenterX,randomLetterCenterY);

    final Map<String,dynamic> randomLetter1Object = gamePlayState.randomLetterData[gamePlayState.randomLetterData.length-2];
    final Map<String,dynamic> randomLetter2Object = gamePlayState.randomLetterData[gamePlayState.randomLetterData.length-1];

    final Map<String,dynamic> randomLetter1Decoration = randomLetter1Object["decorationData"];
    final Map<String,dynamic> randomLetter2Decoration = randomLetter2Object["decorationData"];

    final String randomLetter1 = randomLetter1Object["body"];
    final String randomLetter2 = randomLetter2Object["body"];

    List<Map<String,dynamic>> tapReleaseAnimations = gamePlayState.animationData.where((e)=>e["type"]=="tap-up").toList();
    List<Map<String,dynamic>> undoAnimations = gamePlayState.animationData.where((e)=>e["type"]=="undo").toList();
    List<Map<String,dynamic>> allTiles = gamePlayState.tileData+gamePlayState.reserveTileData;



    if (tapReleaseAnimations.isNotEmpty) {

      if (tapReleaseAnimations.length >= 2) {

        final double progress =  tapReleaseAnimations.last["progress"];


        final double animatedWidth2 = tileSize.width*progress;
        final Size animatedSize2 = Size(animatedWidth2,animatedWidth2);
        TilePainters().drawTile2(canvas,randomLetter2Center,randomLetter2,animatedSize2,'random',randomLetter2Decoration,palette);
        final double dx1 = randomLetter2CenterX + ((randomLetter1CenterX-randomLetter2CenterX)*progress);
        final double dy1 = randomLetterCenterY;
        final Offset animatedCenter1 = Offset(dx1,dy1);
        final double animatedWidth1 = (tileSize.width*1.5)*progress;
        final Size animatedSize1 = Size(animatedWidth1,animatedWidth1);
        TilePainters().drawTile2(canvas, animatedCenter1,randomLetter1, animatedSize1,'random',randomLetter1Decoration,palette);
        


      } else {

        final double progress = tapReleaseAnimations.last["progress"];
        final double animatedWidth2 = tileSize.width*progress;
        final Size animatedSize2 = Size(animatedWidth2,animatedWidth2);
        TilePainters().drawTile2(canvas,randomLetter2Center,randomLetter2,animatedSize2,'random',randomLetter2Decoration,palette);

        final double dx1 = randomLetter2CenterX + ((randomLetter1CenterX-randomLetter2CenterX)*progress);
        final double dy1 = randomLetterCenterY;
        final Offset animatedCenter1 = Offset(dx1,dy1);
        final double animatedWidth1 = tileSize.width+(((tileSize.width*1.5)-tileSize.width)*progress);
        final Size animatedSize1 = Size(animatedWidth1,animatedWidth1);
        TilePainters().drawTile2(canvas, animatedCenter1,randomLetter1, animatedSize1,'random',randomLetter1Decoration,palette);
      }
    } else if (undoAnimations.isNotEmpty) {
        if (undoAnimations.last["parameters"]["moveType"]=="placed") {

          final double progress = undoAnimations.last["progress"];
          final String randomLetter3 = undoAnimations.last["parameters"]["randomLetter3"]["body"];

          if (undoAnimations.last["parameters"]["didScore"]==false) {
            // print("random letter 3: ${undoAnimations.last["parameters"]["randomLetter3"]}");

            final double animatedWidth2 = tileSize.width*(1-progress);
            final Size animatedSize2 = Size(animatedWidth2,animatedWidth2);
            TilePainters().drawTile2(canvas,randomLetter2Center,randomLetter3,animatedSize2,'random',randomLetter2Decoration,palette);

            

            final double dx1 = randomLetter1CenterX + ((randomLetter2CenterX-randomLetter1CenterX)*progress);
            final double dy1 = randomLetterCenterY;
            final Offset animatedCenter1 = Offset(dx1,dy1);
            final double animatedWidth1 = (tileSize.width*1.5)+ (tileSize.width-(tileSize.width*1.5))*(progress);
            final Size animatedSize1 = Size(animatedWidth1,animatedWidth1);
            TilePainters().drawTile2(canvas, animatedCenter1,randomLetter2, animatedSize1,'random',randomLetter2Decoration,palette);      
          } else {
            


            final double animatedWidthBig = tileSize.width*1.5 * progress;
            final Size animatedSizeBig = Size(animatedWidthBig,animatedWidthBig);
            TilePainters().drawTile2(canvas, randomLetter1Center,randomLetter1, animatedSizeBig,'random',randomLetter1Decoration,palette);   

            final double animatedWidth2 = tileSize.width*(1-progress);
            final Size animatedSize2 = Size(animatedWidth2,animatedWidth2);
            TilePainters().drawTile2(canvas,randomLetter2Center,randomLetter3,animatedSize2,'random',randomLetter2Decoration,palette);

            final double dx1 = randomLetter1CenterX + ((randomLetter2CenterX-randomLetter1CenterX)*progress);
            final double dy1 = randomLetterCenterY;
            final Offset animatedCenter1 = Offset(dx1,dy1);
            final double animatedWidth1 = (tileSize.width*1.5)+ (tileSize.width-(tileSize.width*1.5))*(progress);
            final Size animatedSize1 = Size(animatedWidth1,animatedWidth1);
            TilePainters().drawTile2(canvas, animatedCenter1,randomLetter2, animatedSize1,'random',randomLetter2Decoration,palette);      
                           

          }
        } else {
          TilePainters().drawTile2(canvas,randomLetter1Center,randomLetter1,Size(tileSize.width*1.5,tileSize.height*1.5),'random',randomLetter1Decoration,palette);
          TilePainters().drawTile2(canvas,randomLetter2Center,randomLetter2,Size(tileSize.width,tileSize.height),'random',randomLetter2Decoration,palette);             
        }

        // Map<String,dynamic> undoAnimation = undoAnimations.firstWhere((e)=>e["body"]=="",orElse: ()=>{});
        // Map<String,dynamic> sourceTile = allTiles.firstWhere((e)=>e["key"]==undoAnimation["key"],orElse: ()=>{});

        // late double sizeFactor = 0.0;
        // late double animatedWidth1 = tileSize.width;
        // late Size animatedSize1 = Size(animatedWidth1,animatedWidth1);


        // Offset updatedCenter = randomLetter1Center;
    
        // if (sourceTile.isNotEmpty) {
        //   print("undoAnimation: ${sourceTile}");

        //   if (sourceTile["type"]=="board") {
        //     sizeFactor = 1.0;
        //   } else if (sourceTile["type"]=="reserve") {
        //     sizeFactor = 0.9;
        //   }

        //   final double dx1 = sourceTile["center"].dx + ((randomLetter1CenterX-sourceTile["center"].dx)*undoAnimation["progress"]);
        //   final double dy1 = sourceTile["center"].dy + ((randomLetterCenterY-sourceTile["center"].dy)*undoAnimation["progress"]);
        //   updatedCenter = Offset(dx1,dy1);          
        //   // animatedWidth1 = (tileSize.width) + (((tileSize.width*1.5)-(tileSize.width))*undoAnimation["progress"]);
        //   animatedWidth1 = (tileSize.width*sizeFactor) + (((tileSize.width*1.5)-(tileSize.width))*undoAnimation["progress"]);
        //   animatedSize1 = Size(animatedWidth1,animatedWidth1);              
          
        // } 
        // // print("undoAnimation: ${undoAnimation["key"]}");
        // if (undoAnimation["parameters"]["moveType"]=="dropped") {


        //   TilePainters().drawTile2(canvas,randomLetter1Center,randomLetter1,Size(tileSize.width*1.5,tileSize.height*1.5),'random',randomLetter1Decoration);
        //   TilePainters().drawTile2(canvas,randomLetter2Center,randomLetter2,Size(tileSize.width,tileSize.height),'random',randomLetter2Decoration);
        // } else {
        //   // final double animatedWidth1 = (tileSize.width*1.5)*undoAnimation["progress"];
        //   // final Size animatedSize1 = Size(animatedWidth1,animatedWidth1);
        //   TilePainters().drawTile2(canvas,updatedCenter,randomLetter1,animatedSize1,'random',randomLetter1Decoration);

        //   final double animatedWidth2 = tileSize.width + ((tileSize.width*1.5)-tileSize.width)*(1-undoAnimation["progress"]); //tileSize.width+(((tileSize.width*1.5)-tileSize.width)*undoAnimation["progress"]);
        //   final Size animatedSize2 = Size(animatedWidth2,animatedWidth2);
        //   final double dx2 = randomLetter2CenterX + ((randomLetter1CenterX-randomLetter2CenterX)*(1-undoAnimation["progress"]));
        //   final double dy2 = randomLetterCenterY;
        //   final Offset animatedCenter2 = Offset(dx2,dy2);        
        //   TilePainters().drawTile2(canvas,animatedCenter2,randomLetter2,animatedSize2,'random',randomLetter2Decoration);
        // }

    } else {
      // TilePainters().drawTile(canvas,randomLetter1Center,gamePlayState,randomLetter1,Size(tileSize.width*1.5,tileSize.height*1.5));
      // TilePainters().drawRandomTile(canvas,randomLetter1Center,gamePlayState,randomLetter1,Size(tileSize.width*1.5,tileSize.height*1.5));
      TilePainters().drawTile2(canvas,randomLetter1Center,randomLetter1,Size(tileSize.width*1.5,tileSize.height*1.5),'random',randomLetter1Decoration,palette);
      // TilePainters().drawTile(canvas,randomLetter2Center,gamePlayState,randomLetter2,Size(tileSize.width,tileSize.height)); 
      // TilePainters().drawRandomTile(canvas,randomLetter2Center,gamePlayState,randomLetter2,Size(tileSize.width,tileSize.height));    
      TilePainters().drawTile2(canvas,randomLetter2Center,randomLetter2,Size(tileSize.width,tileSize.height),'random',randomLetter2Decoration,palette);
    }

    return canvas;
  }


  Canvas animateExplodingEmptyTile(Canvas canvas, GamePlayState gamePlayState, ColorPalette palette) {
    for (int i=0;i<gamePlayState.animationData.length;i++) {
      if (gamePlayState.animationData[i]["type"]=="tap-up") {
        int animatedTileId = gamePlayState.animationData[i]["key"];

        late Map<String,dynamic> animatedTile = gamePlayState.tileData.firstWhere((e)=>e["key"]==animatedTileId,orElse: ()=>{});
        if (animatedTile.isEmpty) {
          animatedTile = gamePlayState.reserveTileData.firstWhere((e)=>e["key"]==animatedTileId,orElse: ()=>{});
        }

        if (animatedTile.isNotEmpty) {
          Offset animatedTileCenter = animatedTile["center"];
          // paintEmptyTileExplosion(canvas,gamePlayState,gamePlayState.animationData[i],animatedTileCenter);
          paintEmptyTileExitAnimation(canvas,gamePlayState,palette,animatedTile, gamePlayState.animationData[i], animatedTileCenter);
        }


      }
    }

    return canvas;
  }



  Canvas paintEmptyTileExitAnimation(Canvas canvas, GamePlayState gamePlayState,ColorPalette palette, Map<String,dynamic> tileObject, Map<String,dynamic> animationObject, Offset center) {

    final double progress = animationObject["progress"];
    final Size tileSize = gamePlayState.elementSizes["tileSize"];
    final String tileType = tileObject["type"];
    final Map<String,dynamic> decorationData = tileObject["decorationData"];
    final double actualTileWidth =  tileType=="board"?tileSize.width*0.8:tileSize.width*0.6;
    final double updatedTileWidth = actualTileWidth*(1.0-progress);
    final Size updatedTileSize = Size(updatedTileWidth,updatedTileWidth);

    TilePainters().paintAnimatingTile(canvas, center, gamePlayState, "", updatedTileSize,progress,"$tileType-empty","$tileType-empty",decorationData,palette);

    final int hlRed = (palette.gameplayTileShadow1.r * 255).floor();
    final int hlGreen = (palette.gameplayTileShadow1.g * 255).floor();
    final int hlBlue = (palette.gameplayTileShadow1.b * 255).floor();


    Paint highlightPaint = Paint()
    ..color= Color.fromRGBO(hlRed, hlGreen, hlBlue, 0.7*(1.0-progress))
    ..style=PaintingStyle.stroke
    ..strokeCap=StrokeCap.round
    ..strokeWidth= (3.0*gamePlayState.scalor)  * (1.0-progress);

    Paint highlightShadowPaint = Paint()
    ..color=Color.fromRGBO(hlRed, hlGreen, hlBlue, (1.0-progress))
    ..style=PaintingStyle.stroke
    ..strokeCap=StrokeCap.round
    ..strokeWidth= (5.0*gamePlayState.scalor) 
    ..maskFilter = MaskFilter.blur(BlurStyle.outer, 2.0 + (3.0*progress));

    final double hightlightRectSizeStart = actualTileWidth*0.9;
    final double highlightRectSizeEnd = actualTileWidth*1.3;
    final double actualHighlightSize = hightlightRectSizeStart+((highlightRectSizeEnd-hightlightRectSizeStart)*progress); 
    Rect highlightRect = Rect.fromCenter(center: center, width: actualHighlightSize, height: actualHighlightSize);
    RRect highlightRRect = RRect.fromRectAndRadius(highlightRect, Radius.circular(actualHighlightSize*0.2));
    canvas.drawRRect(highlightRRect,highlightShadowPaint);
    canvas.drawRRect(highlightRRect,highlightPaint);
    
    
    return canvas;
  }


  Canvas drawWordFoundTiles(Canvas canvas, GamePlayState gamePlayState, ColorPalette palette) {

    Size tileSize = gamePlayState.elementSizes["tileSize"];
    String animationType = "word-found";
    Map<String,dynamic> animationDurationData = gamePlayState.animationLengths.firstWhere((e)=>e["type"]==animationType);

    List<Map<String,dynamic>> wordFoundAnimations = gamePlayState.animationData.where((e)=>e["type"]==animationType).toList();
    
    for (int i=0; i<wordFoundAnimations.length; i++) {

      final Map<String,dynamic> animationObject = wordFoundAnimations[i];
      final int key = animationObject["key"];
      final double progress = animationObject["progress"];
      final int progressIndex = (progress*(animationDurationData["stops"]-1)).round();
      final String body = animationObject["body"];


      Map<String,dynamic> animationParameters = animationObject["parameters"];

      Map<String,dynamic> sections = animationParameters["sections"];
      double startDelaySectionStart = sections["startDelaySection"];
      // double highlightSectionStart = startDelaySectionStart + sections["highlightSection"];
      double oscillatingSectionStart = startDelaySectionStart + sections["oscillatingSection"]; 
      double convergeSectionStart = oscillatingSectionStart + sections["convergeSection"]; 
      double hiddenSectionStart = convergeSectionStart + sections["hiddenSection"]; 
      double endSectionStart = hiddenSectionStart + sections["endSection"]; 
      // double endDelaySectionStart = endSectionStart + sections["endDelaySection"];



      List<double> sizeValues = animationParameters["sizeData"];
      List<Offset> coords = animationParameters["coords"];
      List<int> colorRange = animationParameters["color"];
      List<double> opacityValues = animationParameters["opacity"];
      // List<Map<String,dynamic>> explosionData = animationParameters["explosionData"];

      // final List<double> wave = animationObject["wave"];
      Map<String,dynamic> tileObject = gamePlayState.tileData.firstWhere((e)=>e["key"]==key, orElse: ()=>{},);
      Offset tileCenter = coords[progressIndex];
      // final double reductionFactor = 0.2;



      // print(sizeFactor);
      final double updatedTileWidth = sizeValues[progressIndex] *0.8;
      final Size updatedTilesize = Size(updatedTileWidth,updatedTileWidth);

      Paint tilePaint = Paint()
      ..color = Color(colorRange[progressIndex])
      ..strokeCap = StrokeCap.round
      ..strokeWidth = tileSize.width * 0.05
      ..style=PaintingStyle.stroke;

      Rect rect = Rect.fromCenter(center: tileCenter, width: updatedTileWidth, height: updatedTileWidth);
      RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(updatedTilesize.width*0.1));



      // Helpers().displayText(canvas, body, gamePlayState, tileCenter,updatedTilesize);

      final double minTileSize = gamePlayState.minimumTileSize;
      final double minFontSize = gamePlayState.minimumFontSize;
      late double fontSize = double.parse( ((minFontSize/minTileSize)*updatedTilesize.width).toStringAsFixed(2));

      TextStyle textStyle = palette.tileFont(
        textStyle: TextStyle(
          color: Color(colorRange[progressIndex]),
          fontSize: fontSize,
        ),
      );
      // TextStyle textStyle = GoogleFonts.akayaKanadaka(
      //   color: Color(colorRange[progressIndex]),
      //   fontSize: fontSize,
      // );
      TextSpan textSpan = TextSpan(
        text: body,
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      final position = Offset(tileCenter.dx - (textPainter.width/2), tileCenter.dy - (textPainter.height/2));


      
      if (progress<convergeSectionStart) {
        canvas.drawRRect(rrect, tilePaint);
        textPainter.paint(canvas, position); 
      }

      if (progress > hiddenSectionStart) {
        // TilePainters().drawTile(canvas, tileCenter, gamePlayState, "", Size(sizeValues[progressIndex],sizeValues[progressIndex]));
        // TilePainters().drawTile2(canvas, tileCenter, gamePlayState, "", tileSize,'board');
        TilePainters().drawWordFoundAnimatingTile(canvas, tileCenter, gamePlayState, "", tileSize,'board-empty',opacityValues[progressIndex],tileObject["decorationData"],palette);
      }
      
      

    }

    return canvas;
  }



  Canvas drawNewPointsAnimation(Canvas canvas,GamePlayState gamePlayState, ColorPalette palette) {
    List<Map<String,dynamic>> newPointsAnimations = gamePlayState.animationData.where((e)=>e["type"]=="new-points").toList();

    int rows = gamePlayState.gameParameters["rows"];// Helpers().getNumAxis(gamePlayState.tileData)[0];
    int cols = gamePlayState.gameParameters["columns"];// Helpers().getNumAxis(gamePlayState.tileData)[1];
    Size tileSize = gamePlayState.elementSizes["tileSize"];

    // // elevation animation details TODO: UPDATE TO DYNAMIC VALUE
    // List<Map<String,dynamic>> opacityAnimationDetails = [
    //   {"source": 0.0, "target": 1.0, "duration": 0.15},
    //   {"source": 1.0, "target": 1.0, "duration": 0.70},
    //   {"source": 1.0, "target": 0.0, "duration": 0.15},
    // ];

    // OPACITY
    List<Map<String,dynamic>> opacityProgressDetails = [
      {"source": 0.0, "target": 1.0, "duration": 0.10},
      {"source": 1.0, "target": 1.0, "duration": 0.60},
      {"source": 1.0, "target": 0.0, "duration": 0.30},
    ];    
    // POSITION Y
    List<Map<String,dynamic>> yPositionProgressDetails = [
      {"source": 0.00, "target": 0.50, "duration": 0.70},
      {"source": 0.50, "target": 0.80, "duration": 0.30},
    ];

    // SIZE
    List<Map<String,dynamic>> sizeProgressDetails = [
      {"source": 0.50, "target": 1.10, "duration": 0.10},
      {"source": 1.10, "target": 0.95, "duration": 0.075},
      {"source": 0.95, "target": 1.05, "duration": 0.05},
      {"source": 1.05, "target": 1.00, "duration": 0.025},
      {"source": 1.00, "target": 1.00, "duration": 0.75},
    ];    

    // COLOR
    Color colorRes = Colors.transparent;
    Color yellow = palette.gameplayWordFound1; //const ui.Color.fromARGB(255, 238, 178, 14);
    Color red = palette.gameplayWordFound2; //const ui.Color.fromARGB(255, 238, 24, 9);
    Color baseColor = palette.newPointsShadow; //const Color.fromARGB(153, 241, 241, 241);

    List<Map<String,dynamic>> colorSequence = [
      {"source": yellow, "target": red, "duration": 0.2},
      {"source": red, "target": yellow, "duration": 0.1},
      {"source": yellow, "target": red, "duration": 0.1},
      {"source": red, "target": yellow, "duration": 0.1},
      {"source": yellow, "target": red, "duration": 0.1},
      {"source": red, "target": yellow, "duration": 0.1},
      {"source": yellow, "target": red, "duration": 0.1},                        
      {"source": red, "target": yellow, "duration": 0.2},
    ];
      

    for (int i=0; i<newPointsAnimations.length; i++) {
      Map<String,dynamic> newPointsAnimation = newPointsAnimations[i];

      double progress = newPointsAnimation["progress"];
      int body = newPointsAnimation["body"];
      Map<String,dynamic> tile = newPointsAnimation["tile"];

      // double getOpacityValue = AnimationUtils().getAnimationTransition(progress,opacityAnimationDetails);     
      
      int horizontalFactor = 1;
      int verticalFactor = 1;
      double positionX = 0;
      double positionY = 0;

      if (tile.isNotEmpty) {
        if (tile["row"] >= rows/2) {
          verticalFactor = -1;
        } 
        if (tile["column"] >= cols/2) {
          horizontalFactor = -1;
        }

        positionX = tile["center"].dx + (tileSize.width*horizontalFactor);
        // positionY = tile["center"].dy + (tileSize.height*verticalFactor) - ((tileSize.height)*progress);  
        positionY = tile["center"].dy + (tileSize.height*verticalFactor);        
      } else {
        positionX = gamePlayState.elementPositions["boardCenter"].dx;
        // positionY = gamePlayState.elementPositions["boardCenter"].dy- ((tileSize.height)*progress);
        positionY = gamePlayState.elementPositions["boardCenter"].dy- (tileSize.height*1.5);
      }


      // POSITION Y
      late double yPositionProgress = AnimationUtils().getAnimationTransition(progress,yPositionProgressDetails);
      late double updatedY = positionY - ((tileSize.width) * yPositionProgress);
      late Offset updatedCenter = Offset(positionX,updatedY);
      
      // SIZE
      late double sizeProgress =  AnimationUtils().getAnimationTransition(progress,sizeProgressDetails);
      late double updatedFontSize = (tileSize.width*1.0) * sizeProgress;

      // COLOR
      colorRes = StylingUtils().getColorLerp(colorSequence,progress);

      // OPACITY

      late double opacityProgress = AnimationUtils().getAnimationTransition(progress,opacityProgressDetails);



      final int mainR = (colorRes.r * 255).floor();
      final int mainG = (colorRes.g * 255).floor();
      final int mainB = (colorRes.b * 255).floor();

      final Color mainColor = ui.Color.fromRGBO(mainR, mainG, mainB, opacityProgress);

      TextStyle textStyle = GoogleFonts.bangers( 
        textStyle: TextStyle(
          color: mainColor, //const Color.fromARGB(190, 123, 191, 255),
          fontSize: updatedFontSize,
        )
      );
      TextSpan textSpan = TextSpan(
        text: "+${body.toString()}",
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();


      // OUTLINE

      // Shadow pass — paint before outline and fill
      // final shadowPaint = Paint()
      //   ..color = Colors.black.withOpacity(opacityProgress * 0.6)
      //   ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4);      

      // canvas.saveLayer(null, Paint());
      // final shadowTextStyle = TextStyle(
      //   fontSize: updatedFontSize,
      //   foreground: shadowPaint,
      // );
      // final shadowTextSpan = TextSpan(
      //   text: "+${body.toString()}",
      //   style: shadowTextStyle,
      // );
      // final shadowPainter = TextPainter(
      //   text: shadowTextSpan,
      //   textDirection: TextDirection.ltr,
      // );
      // shadowPainter.layout();
      // final shadowOffset = updatedCenter + Offset.zero; // shift for shadow direction
      // shadowPainter.paint(canvas, shadowOffset);
      // canvas.restore();      

      final int r = (palette.newPointsShadow.r * 255).floor();
      final int g = (palette.newPointsShadow.g * 255).floor();
      final int b = (palette.newPointsShadow.b * 255).floor();

      TextStyle outlineTextStyle = GoogleFonts.bangers(
        textStyle: TextStyle(
          fontSize: updatedFontSize,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = tileSize.width*0.10
            ..color = ui.Color.fromRGBO(r, g, b, opacityProgress)
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2*opacityProgress),
      
        ),
      );
      canvas.saveLayer(null, Paint());
      TextSpan outlineTextSpan = TextSpan(
        text: "+${body.toString()}",
        style: outlineTextStyle,
      );
      final outlineTextPainter = TextPainter(
        text: outlineTextSpan,
        textDirection: TextDirection.ltr,
      );
      outlineTextPainter.layout();      
      canvas.restore(); 

      final position = Offset(updatedCenter.dx - (textPainter.width/2), updatedCenter.dy - (textPainter.height/2));
      outlineTextPainter.paint(canvas, position);
      textPainter.paint(canvas, position);


      // Rect rect = Rect.fromCenter(center: position, width: tileSize.width, height: tileSize.height);

      // canvas.drawRect(rect,paint); 
    }
    return canvas;
  }


  Canvas paintGameOverOverlay(Canvas canvas, Size size, GamePlayState gamePlayState) {

    if (gamePlayState.isGameOver) {

      Map<String,dynamic> animationObject = gamePlayState.animationData.firstWhere((e)=>e["type"]=="game-over",orElse: ()=>{});

      final bool didAchieveObjective = gamePlayState.gameResultData['didAchieveObjective'];
      String body = didAchieveObjective ? "Mission Accomplished" : "Game Over";

      if (animationObject.isNotEmpty) {
        double progress = animationObject["progress"];
        

        Rect overlayRect = Rect.fromLTWH(0.0,0.0,size.width,size.height);
        Paint overlayPaint = Paint()
        ..color = ui.Color.fromRGBO(0, 0, 0, progress);
        
        Paint overlayBlurPaint = Paint()
        ..color = ui.Color.fromRGBO(155, 193, 255, progress)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 100.0);


        canvas.drawRect(overlayRect,overlayPaint);
        canvas.drawRect(overlayRect, overlayBlurPaint);


        TextStyle textStyle = TextStyle(
          color:ui.Color.fromRGBO(243, 249, 255, 1.0 * progress),
          fontSize: 48* gamePlayState.scalor,

        );
        TextSpan textSpan = TextSpan(
          text: body,
          style: GoogleFonts.lilitaOne(
            textStyle: textStyle
          ),
        );
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
        );
        textPainter.layout(maxWidth: size.width * 0.8);
        final position = Offset(size.width/2 - (textPainter.width/2), size.height/2 - (textPainter.height/2));
        textPainter.paint(canvas, position);        
      }

    }
    return canvas;
  }


  Canvas drawCountDown(Canvas canvas, GamePlayState gamePlayState, ColorPalette palette) {

    String durationString = "";
    if (gamePlayState.countDownDuration != null) {
      durationString = Helpers().formatDuration(gamePlayState.countDownDuration!.inSeconds);
    } else {
      durationString = Helpers().formatDuration(gamePlayState.duration.inSeconds);
    }

    final Size tileSize = gamePlayState.elementSizes["tileSize"];


    Size effectiveSize = gamePlayState.elementSizes["effectiveSize"];
    Offset effectiveCenter = gamePlayState.elementPositions["effectiveCenter"];

    Offset appBarCenter = gamePlayState.elementPositions["appBarCenter"];

    
    TextStyle textStyle = TextStyle(
      color: palette.gameplayText1, //const Color.fromARGB(224, 176, 230, 255),
      fontSize: 22 * gamePlayState.scalor, 

    );
    TextSpan textSpan = TextSpan(
      text: durationString,
      style: textStyle,
    );

    final TextPainter textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();    

    double updatedCenterY = effectiveCenter.dy-(effectiveSize.height/2) + ((textPainter.height*1.5)/2);
    // double updatedCenterY = 500;


    // double textContainerRightEdgeX = scoreboardRightEdgeX-10;
    double textContainerLeftEdgeX = 80* gamePlayState.scalor; //textContainerRightEdgeX-(textPainter.width*1.5);
    double textContainerCenterX = textContainerLeftEdgeX + textPainter.width/2; //((textContainerRightEdgeX-textContainerLeftEdgeX)/2);
    Offset textContainerCenter = Offset(textContainerCenterX,updatedCenterY);
    
    Offset textCenter = Offset((textContainerCenter.dx - (textPainter.width/2))+((textPainter.height*0.5)/2), textContainerCenter.dy - (textPainter.height/2));  
    // Offset textCenter = Offset((textContainerCenter.dx - (textPainter.width/2))+((textPainter.height*0.5)/2), appBarCenter.dy - (textPainter.height/2));  
    textPainter.paint(canvas, textCenter);





    return canvas;
  }


  Canvas paintPerkCounts(Canvas canvas, GamePlayState gamePlayState) {
    Size tileSize = gamePlayState.elementSizes["tileSize"];
    Size scoreboardSize = gamePlayState.elementSizes["scoreboardAreaSize"];

    Offset scoreboardCenter = gamePlayState.elementPositions["scoreboardCenter"];
    final double scoreboardBottomY = scoreboardCenter.dy+(scoreboardSize.height/2) + (18 * gamePlayState.scalor);
    final double scoreboardLeftX = scoreboardCenter.dx-(scoreboardSize.width*0.9/2) + (18 * gamePlayState.scalor);

    final Color itemColor = Colors.white;
    Paint itemPaint = Paint()
    ..color = itemColor;

    double itemDiameter = 36 * gamePlayState.scalor;//tileSize.width*0.6;

    for (int i=0; i<gamePlayState.tileMenuOptions.length;i++) {
      Map<String,dynamic> tileMenuOption = gamePlayState.tileMenuOptions[i];
      double positionX = scoreboardLeftX; //scoreboardCenter.dx + ((i-1) * itemDiameter*2);
      double positionY = scoreboardBottomY + (i * itemDiameter);
      Offset position = Offset(positionX,positionY);
      String icon = tileMenuOption["item"];
      int count = tileMenuOption["count"];

      Map<String,dynamic> perkAnimation = gamePlayState.animationData.firstWhere((e)=>e["key"]==icon,orElse: ()=>{});

      late double opacity = 1.0;

      if (perkAnimation.isNotEmpty) {

        List<Map<String,dynamic>> animationDetails = [];
        for (int j=0; j<count; j++) {
          Map<String,dynamic> object1 ={"source": 1.0, "target": 0.4, "duration": 1/(count*2)};
          Map<String,dynamic> object2 ={"source": 0.4, "target": 1.0, "duration": 1/(count*2)};
          animationDetails.add(object1);
          animationDetails.add(object2);
        }
        opacity = AnimationUtils().getAnimationTransition(perkAnimation["progress"],animationDetails);          
        count = perkAnimation["animation"]["body"];    
      }
      TilePainters().drawOptionIcon(canvas, position, icon, Size(itemDiameter,itemDiameter), 1.0, itemColor);


      TextStyle textStyle = TextStyle(
        color: ui.Color.fromRGBO(255, 255, 255, opacity),
        fontSize: 18 * gamePlayState.scalor ,
        shadows: perkAnimation.isNotEmpty ? [
          Shadow(color: Colors.white,offset: Offset.zero, blurRadius: 22.0 * opacity,)
        ] : []
      );
      TextSpan textSpan = TextSpan(
        text: count.toString(),
        style: textStyle,
      );
  
      final TextPainter textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      Offset textPosition = Offset(positionX + itemDiameter*0.4, positionY + itemDiameter*0.2);
      textPainter.paint(canvas, textPosition);      


    }


    return canvas;
  }


  Canvas drawUndoAnimation(Canvas canvas, GamePlayState gamePlayState, ColorPalette palette) {

    List<Map<String,dynamic>> undoAnimations = gamePlayState.animationData.where((e)=>e["type"]=="undo").toList();

    for (int i=0; i<undoAnimations.length; i++) {

      // general data
      final Size tileSize = gamePlayState.elementSizes["tileSize"];
      final double randomLetterCenterY = gamePlayState.elementPositions["randomLettersCenter"].dy;
      final double randomLetter1CenterX = gamePlayState.elementPositions["randomLettersCenter"].dx;

      // animation object data
      Map<String,dynamic> undoAnimation = undoAnimations[i];
      String undoType = undoAnimation["parameters"]["moveType"];
      bool didScore = undoAnimation["parameters"]["didScore"];
      double progress = undoAnimation["progress"];
      int tileKey = undoAnimation["key"];
      String body = undoAnimation["body"];
      bool isFocusTile = undoAnimation["parameters"]["isFocusTile"];

      // tile object data
      Map<String,dynamic> tileElement = Helpers().getTileElement(gamePlayState,tileKey);
      Offset tileCenter = tileElement["center"];
      Map<String,dynamic> decorationData = tileElement["decorationData"];

      if (tileElement.isNotEmpty) {

        // =============== PLACED ===============================
        if (undoType == "placed") {

          // DID SCORE
          if (didScore) {
            // IS FOCUS TILE
            if (isFocusTile) {
              // do not animate the tile
              TilePainters().drawTile2(canvas, tileCenter, body, tileSize, 'board-empty', decorationData,palette);
            }
            // IS NOT FOCUS TILE
            else {
              // animate from empty to full
              // TilePainters().paintAnimatingTile(canvas, tileCenter, gamePlayState, body, tileSize, progress, 'board-empty', 'board-full', decorationData);

              double updatedProgressEmpty = progress > 0.5 ? 1.0 : (progress)*2;
              double emptyTileWidth = tileSize.width * (1-updatedProgressEmpty);
              Size emptyTileSize = Size(emptyTileWidth,emptyTileWidth);
              TilePainters().drawTile2(canvas, tileCenter, body, emptyTileSize, 'board-empty', decorationData,palette);

              double updatedProgressNew = progress < 0.5 ? 0.0 : (progress-0.5)*2;
              double newTileWidth = tileSize.width*updatedProgressNew;
              Size newTileSize = Size(newTileWidth,newTileWidth);
              TilePainters().drawTile2(canvas, tileCenter, body, newTileSize, 'board-full', decorationData,palette);                   
            }
          }
          // DID NOT SCORE
          else {
            // animate the focus tile going back to the random letter position
            late double updatedX = tileCenter.dx;
            late double updatedY = tileCenter.dy;
            late Offset updatedPosition = Offset(updatedX,updatedY);
            late double updatedWidth = tileSize.width;
            late Size updatedSize = Size(updatedWidth,updatedWidth);
            // late String tileType = tileElement["type"]=="board" ? "board-full" : "reserve-full";
            late String tileType = "${tileElement["type"]}-full";
            late double tileWidth = tileElement["type"]=="board" ? tileSize.width : tileSize.width*0.8;


            updatedX = tileCenter.dx + ((randomLetter1CenterX - tileCenter.dx) * progress);
            updatedY = tileCenter.dy + ((randomLetterCenterY - tileCenter.dy) * progress);
            updatedWidth = tileWidth + (((tileSize.width*1.5)-tileWidth)*progress);  

            updatedPosition = Offset(updatedX,updatedY);
            updatedSize = Size(updatedWidth,updatedWidth);

            // animate the empty tile rising to position
            double emptyTileWidth = tileWidth*progress;
            Size emptyTileSize = Size(emptyTileWidth,emptyTileWidth);
            late String emptyTileType = "${tileElement["type"]}-empty";


            // animate the empty tile first so it appears under the focus tile
            TilePainters().drawTile2(canvas, tileCenter, body, emptyTileSize, emptyTileType, decorationData,palette);            
            TilePainters().drawTile2(canvas, updatedPosition, body, updatedSize, tileType, decorationData,palette);
          }

        }
        // =============== DROPPED ===============================
        else if (undoType == "dropped") {

          



          // DID SCORE
          if (didScore) {

            
            
            // IS FOCUS TILE
            if (isFocusTile) {
              // TilePainters().paintAnimatingTile(canvas, tileCenter, gamePlayState, body, tileSize, progress, 'board-empty', 'board-full', decorationData);
              TilePainters().drawTile2(canvas, tileCenter, body, tileSize, 'board-empty', decorationData,palette);
            }
            // IS NOT FOCUS TILE
            else {
              if (tileElement["type"]=="reserve") {
                double reserveTileSize = tileSize.width*0.8;
                // Size updatedSize = Size(reserveTileSize,reserveTileSize);

                double updatedProgressEmpty = progress > 0.5 ? 1.0 : (progress)*2;
                double emptyTileWidth = reserveTileSize * (1-updatedProgressEmpty);
                Size emptyTileSize = Size(emptyTileWidth,emptyTileWidth);
                TilePainters().drawTile2(canvas, tileCenter, body, emptyTileSize, 'reserve-empty', decorationData,palette);

                double updatedProgressNew = progress < 0.5 ? 0.0 : (progress-0.5)*2;
                double newTileWidth = reserveTileSize*updatedProgressNew;
                Size newTileSize = Size(newTileWidth,newTileWidth);
                TilePainters().drawTile2(canvas, tileCenter, body, newTileSize, 'reserve-full', decorationData,palette);                   
                // TilePainters().paintAnimatingTile(canvas, tileCenter, gamePlayState, body, updatedSize, progress, 'reserve-empty', 'reserve-full', decorationData,palette);
              } else {

                double updatedProgressEmpty = progress > 0.5 ? 1.0 : (progress)*2;
                double emptyTileWidth = tileSize.width * (1-updatedProgressEmpty);
                Size emptyTileSize = Size(emptyTileWidth,emptyTileWidth);
                TilePainters().drawTile2(canvas, tileCenter, body, emptyTileSize, 'board-empty', decorationData,palette);

                double updatedProgressNew = progress < 0.5 ? 0.0 : (progress-0.5)*2;
                double newTileWidth = tileSize.width*updatedProgressNew;
                Size newTileSize = Size(newTileWidth,newTileWidth);
                TilePainters().drawTile2(canvas, tileCenter, body, newTileSize, 'board-full', decorationData,palette);                 
                // TilePainters().paintAnimatingTile(canvas, tileCenter, gamePlayState, body, tileSize, progress, 'board-empty', 'board-full', decorationData,palette);
              }

            }

          }

          // DID NOT SCORE
          else {
            Offset destination = undoAnimation["parameters"]["destination"];
            late double updatedX = tileCenter.dx;
            late double updatedY = tileCenter.dy;
            late Offset updatedPosition = Offset(updatedX,updatedY);
            late double updatedWidth = tileSize.width;
            late Size updatedSize = Size(updatedWidth,updatedWidth);

            if (tileElement["type"]=="board") {
              double emptyBoardTileWidth = tileSize.width*(progress);
              Size emptyBoardTileSize = Size(emptyBoardTileWidth,emptyBoardTileWidth);
              TilePainters().drawTile2(canvas, tileCenter, body, emptyBoardTileSize, "board-empty", decorationData,palette);

              double emptyReserveTileWidth = tileSize.width*0.8*(1-progress);
              Size emptyReserveTileSize = Size(emptyReserveTileWidth,emptyReserveTileWidth);
              TilePainters().drawTile2(canvas, destination, body, emptyReserveTileSize, "reserve-empty", decorationData,palette);              

              updatedX = tileCenter.dx + (destination.dx-tileCenter.dx)*progress;
              updatedY = tileCenter.dy + (destination.dy-tileCenter.dy)*progress;
              updatedPosition = Offset(updatedX,updatedY);
              updatedWidth = tileSize.width + ((tileSize.width*0.8)-tileSize.width)*progress;
              updatedSize = Size(updatedWidth,updatedWidth);
              TilePainters().drawTile2(canvas, updatedPosition, body, updatedSize, "reserve-full", decorationData,palette);
            }


                                    
          }

        }
        // =============== EXPLODE ===============================
        else if (undoType == "explode") {
          // TilePainters().paintAnimatingTile(canvas, tileCenter, gamePlayState, body, tileSize, progress, 'board-empty', 'board-full', decorationData,palette);
        double updatedProgressEmpty = progress > 0.5 ? 1.0 : (progress)*2;
        double emptyTileWidth = tileSize.width * (1-updatedProgressEmpty);
        Size emptyTileSize = Size(emptyTileWidth,emptyTileWidth);
        TilePainters().drawTile2(canvas, tileCenter, body, emptyTileSize, 'board-empty', decorationData,palette);

        double updatedProgressNew = progress < 0.5 ? 0.0 : (progress-0.5)*2;
        double newTileWidth = tileSize.width*updatedProgressNew;
        Size newTileSize = Size(newTileWidth,newTileWidth);
        TilePainters().drawTile2(canvas, tileCenter, body, newTileSize, 'board-full', decorationData,palette);             
        }
        // =============== FREEZE ===============================
        else if (undoType == "freeze") {
          bool frozen = tileElement["frozen"]; // false = thawing | true = freezing
          

          // DID SCORE
          if (didScore) {
            // IS FOCUS TILE
            String tileStyle = 'board-full';
            if (isFocusTile) {
              // TilePainters().paintAnimatingTile(canvas, tileCenter, gamePlayState, body, tileSize, progress, 'board-empty', 'board-frozen', decorationData,palette);
              tileStyle = 'board-frozen';
            }
            // IS NOT FOCUS TILE
            else {
              // TilePainters().paintAnimatingTile(canvas, tileCenter, gamePlayState, body, tileSize, progress, 'board-empty', 'board-full', decorationData,palette);
            }

            

            double updatedProgressEmpty = progress > 0.5 ? 1.0 : (progress)*2;
            double emptyTileWidth = tileSize.width * (1-updatedProgressEmpty);
            Size emptyTileSize = Size(emptyTileWidth,emptyTileWidth);
            TilePainters().drawTile2(canvas, tileCenter, body, emptyTileSize, 'board-empty', decorationData,palette);

            double updatedProgressNew = progress < 0.5 ? 0.0 : (progress-0.5)*2;
            double newTileWidth = tileSize.width*updatedProgressNew;
            Size newTileSize = Size(newTileWidth,newTileWidth);
            TilePainters().drawTile2(canvas, tileCenter, body, newTileSize, tileStyle, decorationData,palette);               
          } 
          // DID NOT SCORE
          else {
            if (frozen) {
              TilePainters().paintAnimatingTile(canvas, tileCenter, gamePlayState, body, tileSize, progress, 'board-full', 'board-frozen', decorationData,palette);
            } else {
              TilePainters().paintAnimatingTile(canvas, tileCenter, gamePlayState, body, tileSize, progress, 'board-frozen', 'board-full', decorationData,palette);
            }
          }
          
        }
        // =============== SWAP ===============================
        else if (undoType == "swap") {

          // DID SCORE
          if (didScore) {
            // // IS FOCUS TILE
            if (isFocusTile) {
              body = tileElement["body"];
            }
            double updatedProgressEmpty = progress > 0.5 ? 1.0 : (progress)*2;
            double emptyTileWidth = tileSize.width * (1-updatedProgressEmpty);
            Size emptyTileSize = Size(emptyTileWidth,emptyTileWidth);
            TilePainters().drawTile2(canvas, tileCenter, body, emptyTileSize, 'board-empty', decorationData,palette);

            double updatedProgressNew = progress < 0.5 ? 0.0 : (progress-0.5)*2;
            double newTileWidth = tileSize.width*updatedProgressNew;
            Size newTileSize = Size(newTileWidth,newTileWidth);
            TilePainters().drawTile2(canvas, tileCenter, body, newTileSize, 'board-full', decorationData,palette);            
          }

          // DID NOT SCORE
          else {

          }
        }     
        
      }


      



    }

    return canvas;
  }
  



}