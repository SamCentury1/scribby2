import 'package:flutter/material.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/screens/instructions_screen/components/demo_utils.dart';

class DemoBoardPainter extends CustomPainter {
  final SettingsState settingsState;
  final int step;
  final int elapsedTime;
  final double tilePlacementProgress;
  DemoBoardPainter({
    required this.settingsState,
    required this.step,
    required this.elapsedTime,
    required this.tilePlacementProgress,
  });
   
  @override  
  void paint(Canvas canvas, Size size) {



    final Map<String,dynamic> boardState = settingsState.demoBoardState[step];
    // final double scalor = gamePlayState.scalor;
    
    Offset center = Offset(size.width/2,size.height/2);
    final double tileSize = size.width*0.15;

    final double randomLetter1SizeOrigin = tileSize*1.5;
    final double randomLetter2SizeOrigin = tileSize;

    final Offset randomLetter1PositionOrigin = Offset(center.dx, (tileSize*1.5)/2);
    final Offset randomLetter2PositionOrigin = Offset((center.dx + tileSize*1.5), (tileSize*1.5)/2);


  
    List<Map<String, String>> placedTiles = List<Map<String, String>>.from(boardState["placedTiles"]);


    late double randomLetter2Size = DemoUtils().getTileSize(0.0, randomLetter2SizeOrigin,tilePlacementProgress);

    final double tileSectionX = center.dx - ((tileSize*4)/2);
    final double tileSectionY = center.dy - ((tileSize*4)/2) + (tileSize/4);

    
    for (int i=0; i<4; i++) {
      for (int j=0; j<4; j++) {
        Offset tileCenter = Offset(tileSectionX+(i*tileSize)+(tileSize/2),tileSectionY+(j*tileSize)+(tileSize/2));
        late Offset tilePosition = tileCenter;
        late double actualTileSize = tileSize*0.9;
        final String tileId = "${j}_$i";

        if (placedTiles.isNotEmpty) {
          Map<String,String> placementData = placedTiles.firstWhere((e)=>e["destination"]==tileId,orElse:()=><String,String>{});
          if (placementData.isNotEmpty) {
            // actualTileSize = getTileSize(randomLetter1SizeOrigin, tileSize*0.9, tilePlacementProgress);
            // tilePosition = getTransitionPosition(randomLetter1PositionOrigin,tileCenter,tilePlacementProgress);
          } else {
            DemoUtils().paintDemoTile(canvas,"${j}_$i",boardState,tilePosition,actualTileSize,elapsedTime,);
          }
        } else {
          DemoUtils().paintDemoTile(canvas,"${j}_$i",boardState,tilePosition,actualTileSize,elapsedTime,);
        }

      }
    }

    final double reserveSectionX = center.dx - ((tileSize*0.5*3)/2);
    final double reserveSectionY = tileSectionY+(tileSize*4)+(tileSize/2);
    for (int i=0; i<3; i++) {
      final Offset reserveCenter = Offset(reserveSectionX+(i*tileSize*0.8),reserveSectionY);
      late Offset reservePosition = reserveCenter;
      late double actualTileSize = tileSize*0.75;
      final String tileId = "res_$i";
      if (placedTiles.isNotEmpty) {
        Map<String,String> placementData = placedTiles.firstWhere((e)=>e["destination"]==tileId,orElse:()=><String,String>{});
        if (placementData.isNotEmpty) {
          // actualTileSize = getTileSize(randomLetter1SizeOrigin, tileSize*0.75, tilePlacementProgress);
          // reservePosition = getTransitionPosition(randomLetter1PositionOrigin,reserveCenter,tilePlacementProgress);
        } else {
          DemoUtils().paintDemoTile(canvas,"res_$i",boardState,reservePosition,actualTileSize,elapsedTime,); 
        }
      } else {
        DemoUtils().paintDemoTile(canvas,"res_$i",boardState,reservePosition,actualTileSize,elapsedTime,);    
      }     
    }

    if (placedTiles.isNotEmpty) {      
      for (int i=0; i<placedTiles.length; i++) {
        String destinationTile = placedTiles[i]["destination"]!;
        String originTile = placedTiles[i]["origin"]!;

        late double targetSize = 0.0;
        late double originSize = 0.0;

        late Offset targetPosition = Offset.zero;
        late Offset originPosition = Offset.zero;
        
        List<String> destinationPieces = destinationTile.split("_");
        List<String> originPieces = originTile.split("_");

        if (destinationPieces[0] == "random") {
          if (destinationPieces[1]=="2") {
            targetPosition = randomLetter2PositionOrigin;
            targetSize = tileSize*1.0;
          } else if (destinationPieces[1]=="1") {
            targetPosition = randomLetter1PositionOrigin;
            targetSize = tileSize*1.5;
          } else {
            targetPosition = randomLetter2PositionOrigin;
            targetSize = tileSize;            
          }

          // paintDemoTile(canvas,"random_2",boardState,randomLetter2PositionOrigin,randomLetter2Size,elapsedTime,);
        } else if (destinationPieces[0] == "res") {
          int index = int.parse(destinationPieces[1]);
          targetPosition = Offset(reserveSectionX+(index*tileSize*0.8),reserveSectionY);
          targetSize = tileSize*0.75;
        } else {
          int row = int.parse(destinationPieces[0]);
          int col = int.parse(destinationPieces[1]);
          targetPosition = Offset(tileSectionX+(col*tileSize)+(tileSize/2),tileSectionY+(row*tileSize)+(tileSize/2));
          targetSize = tileSize * 0.9;
        }

        if (originPieces[0] == "random") {
          if (originPieces[1]=="2") {
            originPosition = randomLetter2PositionOrigin;
            originSize = tileSize*1.0;
          } else if (originPieces[1]=="1") {
            originPosition = randomLetter1PositionOrigin;
            originSize = tileSize*1.5;
          } else {
            originPosition = randomLetter2PositionOrigin;
            originSize = 0.0;            
          }
        } else if (originPieces[0] == "res") {
          int index = int.parse(originPieces[1]);
          originPosition = Offset(reserveSectionX+(index*tileSize*0.8),reserveSectionY);
          originSize = tileSize * 0.75;
        } else {
          // THIS SHOULD NEVER HAPPEN
          int row = int.parse(originPieces[0]);
          int col = int.parse(originPieces[1]);
          originPosition = Offset(tileSectionX+(col*tileSize)+(tileSize/2),tileSectionY+(row*tileSize)+(tileSize/2));
          originSize = 0.9;       
        }

        // print("in placed tile animation: ${placedTiles[i]} | origin size: $originSize, origin position: $originPosition || target size: $targetSize, target position $targetPosition");

        late double actualTileSize = DemoUtils().getTileSize(originSize, targetSize, tilePlacementProgress);
        late Offset actualPosition = DemoUtils().getTransitionPosition(originPosition,targetPosition,tilePlacementProgress);    
        DemoUtils().paintDemoTile(canvas,destinationTile,boardState,actualPosition,actualTileSize,elapsedTime,);   

      }
    } 

  }
  @override
  bool shouldRepaint(DemoBoardPainter oldDelegate) => true;
  @override
  bool shouldRebuildSemantics(DemoBoardPainter oldDelegate) => false;  
}
