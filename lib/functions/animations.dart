import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scribby_flutter_v2/functions/animation_utils.dart';
import 'package:scribby_flutter_v2/functions/game_logic.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';

class Animations extends ChangeNotifier {

  void startTapDownAnimation(GamePlayState gamePlayState, int key) {
    print("starting tap down animation for $key");

    // gamePlayState.setIsLongPress(false);

    const String animationType = "tap-down";
    Map<String,dynamic> animationDurationData = gamePlayState.animationLengths.firstWhere((e)=>e["type"]==animationType);

    Map<String,dynamic> tappedObject = gamePlayState.tileData.firstWhere((e)=>e["key"]==key,orElse: ()=>{});
    if (tappedObject.isEmpty) {
      tappedObject = gamePlayState.reserveTileData.firstWhere((e)=>e["key"]==key,orElse: ()=>{});
    }

    List<Map<String,dynamic>> animationData = gamePlayState.animationData;
    Map<String,dynamic> animationObjectTarget = animationData.firstWhere((e)=>e["key"]==key,orElse:()=>{});
    // if (animationObjectTarget.isEmpty) {
    //   animationObjectTarget = {"key": tappedObject["key"], "progress": 0.0, "type": "tap-down"};
    //   animationData.add(animationObjectTarget);
    // }

    if (animationObjectTarget.isNotEmpty) {
      // final int animationObjectIndex = gamePlayState.animationData.indexOf(animationObjectTarget);
      print("currently there is an animation at ${animationObjectTarget["key"]} of type ${animationObjectTarget["type"]}");
      
    } else {
      animationObjectTarget = {"key": tappedObject["key"], "progress": 0.0, "type": animationType};
      animationData.add(animationObjectTarget);

      int target = animationDurationData["stops"];
      int count = 0;
      // timerLogic(gamePlayState,animationObjectTarget,count,target,animationDurationData["interval"]);
      Timer.periodic(Duration(milliseconds: animationDurationData["interval"]), (Timer timer) {
        if (count == target) {
          timer.cancel();
          final int animationObjectIndex = gamePlayState.animationData.indexOf(animationObjectTarget);
          if (animationObjectIndex>=0) {
            try {

            } catch (e) {
              print("error caught in startTapDownAnimation() => $e");
            }
          }
          print("tap down animation finished!@");
        } else {
          final int animationObjectIndex = gamePlayState.animationData.indexOf(animationObjectTarget);
          if (animationObjectIndex<0) {
            timer.cancel();
            // print("tap down animation interupted for key $key, tap release animation should play ");
            // print("------------------------------");
          } else if (gamePlayState.isTutorial) {
            timer.cancel();
          }else {
            count++;
            final double progress = double.parse((count/target).toStringAsFixed(2));
            gamePlayState.animationData[animationObjectIndex].update("progress", (v) => progress);
          }
        }
        gamePlayState.setAnimationData(gamePlayState.animationData);
      });
      
    }

  }


  void removeTapDownAnimationObjectWhenDraggingToOtherTile(GamePlayState gamePlayState, int key) {
    List<Map<String,dynamic>> animationData = gamePlayState.animationData;
    List<Map<String,dynamic>> currentAnimation = animationData.where((e) => e["key"]==key).toList();

    if (currentAnimation.isEmpty) {
      print("PROBLEM: no animations with key $key in removeTapDownAnimationObjectWhenDraggingToOtherTile");
    }

    else if (currentAnimation.length>1) {
      print("PROBLEM: more than one animation with key $key are playing");
    }

    else if (currentAnimation.length == 1) {
      print("there is only one animation of this kind - start tap cancel animation");
      Map<String,dynamic> animationObject = currentAnimation[0];
      startTapCancelAnimation(gamePlayState, key, animationObject["progress"]);
      int animationObjectIndex = gamePlayState.animationData.indexOf(animationObject);
      gamePlayState.animationData.removeAt(animationObjectIndex);

      // notifyListeners();
      // gamePlayState.setAnimationData(animationData);
    }
    gamePlayState.setAnimationData(animationData);

  }


  void removeTapDownAnimationWhenReleased(GamePlayState gamePlayState, int key, ) {
    List<Map<String,dynamic>> animationData = gamePlayState.animationData;
    List<Map<String,dynamic>> currentAnimation = animationData.where((e) => e["key"]==key && e["type"]=="tap-down").toList();

    if (currentAnimation.isEmpty) {
      print("PROBLEM: no animations with key $key in removeTapDownAnimationWhenReleased");
    }

    else if (currentAnimation.length>1) {
      print("PROBLEM: more than one animation with key $key are playing");

    }

    else {
      int animationObjectIndex = animationData.indexOf(currentAnimation[0]);
      animationData.removeAt(animationObjectIndex);
      gamePlayState.setAnimationData(animationData);
    }

  }




  /// 
  void startTapReleaseAnimation(GamePlayState gamePlayState, int key) {

    print("calling startTapReleaseAnimation");

    // look for existing animation
    const String animationType = "tap-up";
    Map<String,dynamic> animationDurationData = gamePlayState.animationLengths.firstWhere((e)=>e["type"]==animationType);

    List<Map<String,dynamic>> animationData = gamePlayState.animationData;
    Map<String,dynamic> existingAnimationObject = animationData.firstWhere((e)=>e["key"]==key,orElse: ()=>{});
    late Map<String,dynamic> animationObject = {};

    late int target = animationDurationData["stops"];
    late int count = 0;

    if (existingAnimationObject.isNotEmpty) {
      final double progress = existingAnimationObject["progress"];
      count = (progress*target).round();
      animationObject = existingAnimationObject;

    } else {
      
      late Map<String,dynamic> tappedObject = gamePlayState.tileData.firstWhere((e)=>e["key"]==key,orElse: ()=>{});
      if (tappedObject.isEmpty) {
        tappedObject = gamePlayState.reserveTileData.firstWhere((e)=>e["key"]==key,orElse: ()=>{});
      }

      // List<Map<String,dynamic>> explosionData = Helpers().getParticleData(tappedObject["center"]);
      Map<String,dynamic> locationData = AnimationUtils().getTileDropSourceData(gamePlayState);

      animationObject = {
        "key": tappedObject["key"], 
        "progress": 0.0,
        "body": tappedObject["body"],
        "type": animationType, 
        "locationData":locationData,
        // "explosionData":explosionData,
      };
      if (tappedObject.isNotEmpty) {
        animationData.add(animationObject);
      }
    }

    
    Timer.periodic(Duration(milliseconds: animationDurationData["interval"]), (Timer timer) {
      if (gamePlayState.isGamePaused) {
        timer.cancel();
      } else {
        if (count == target) {
          timer.cancel();
          final int animationObjectIndex = animationData.indexOf(animationObject);
          // gamePlayState.startStopWatch();
          if (animationObjectIndex>=0) {
            try {
              animationData.removeAt(animationObjectIndex);
            } catch (e) {
              print("error caught in startTapUpAnimation() => $e");
            }
          }
        } else {
          final int animationObjectIndex = animationData.indexOf(animationObject);
          if (animationObjectIndex<0) {
            timer.cancel();
          } else {
            count++;
            final double progress = double.parse((count/target).toStringAsFixed(2));
            animationData[animationObjectIndex].update("progress", (v) => progress);
          }
        }
      }
      gamePlayState.setAnimationData(animationData);
    });
    // timerLogic(gamePlayState,animationObject,count,target,animationDurationData["interval"]);
  }



  void startTapCancelAnimation(GamePlayState gamePlayState, int key, double progress) {

    const String animationType = "tap-cancel";
    List<Map<String,dynamic>> animationData = gamePlayState.animationData;
    Map<String,dynamic> animationDurationData = gamePlayState.animationLengths.firstWhere((e)=>e["type"]==animationType);
    
    Map<String,dynamic> tappedObject = gamePlayState.tileData.firstWhere((e)=>e["key"]==key,orElse: ()=>{});
    if (tappedObject.isEmpty) {
      tappedObject = gamePlayState.reserveTileData.firstWhere((e)=>e["key"]==key,orElse: ()=>{});
    }

    print("launching cancel");

    int target = animationDurationData["stops"];
    int count = ((1.0-progress)*target).round();

    Map<String,dynamic> existingAnimationObject = gamePlayState.animationData.firstWhere((e)=>e["key"]==key&&e["type"]==animationType,orElse: ()=>{});
    late Map<String,dynamic> animationObject = {};
    if (existingAnimationObject.isNotEmpty) {

      final double progress = existingAnimationObject["progress"];
      count = (progress*target).round();      
      animationObject = existingAnimationObject;
    } else {
      double progressAtStart = double.parse((count/target).toStringAsFixed(2));      
      animationObject = {"key": tappedObject["key"], "progress": progressAtStart, "type": animationType};

      if (tappedObject.isNotEmpty) {
        animationData.add(animationObject);
      }
    }


    

  
    timerLogic(gamePlayState,animationObject,count,target,animationDurationData["interval"]);
  }  


  void startWordFoundAnimation(GamePlayState gamePlayState, ColorPalette palette, int turn) {
    
    const String animationType = "word-found";
    Map<String,dynamic> turnData = gamePlayState.scoreSummary.firstWhere((e)=>e["turn"]==turn,orElse: ()=>{});
    Map<String,dynamic> animationDurationData = gamePlayState.animationLengths.firstWhere((e)=>e["type"]==animationType);

    int target = animationDurationData["stops"];
    List<Map<String,dynamic>> animationParameters = AnimationUtils().generateWordFoundAnimationData(gamePlayState, palette ,turn,target);
    // GameLogic().updateTilesFromActiveToInactive(gamePlayState: gamePlayState, turnData: turnData);

    List<Map<String,dynamic>> animationData = gamePlayState.animationData;

    for (int i=0;i<turnData["ids"].length;i++) {

      int key = turnData["ids"][i]["id"];
      String body = turnData["ids"][i]["body"];

      List<Map<String,dynamic>> otherAnimations = animationData.where((e)=>e["key"]==key&&e["type"]!=animationType).toList();
      for (int j=0;j<otherAnimations.length;j++) {
        Map<String,dynamic> otherAnimation = otherAnimations[j];
        final int otherAnimationIndex = animationData.indexOf(otherAnimation);
        animationData.removeAt(otherAnimationIndex);        
      }


      Map<String,dynamic> existingAnimationObject = animationData.firstWhere( (e)=>
        e["key"]==key&&
        [animationType,"undo"].contains(e["type"]),
        orElse: ()=>{}
      );
      
      late Map<String,dynamic> animationObject = {};

      late int count = 0;

      if (existingAnimationObject.isNotEmpty) {
        final double progress = existingAnimationObject["progress"];
        count = (progress*target).round();
        animationObject = existingAnimationObject;

      } else {
        
        late Map<String,dynamic> tileObject = gamePlayState.tileData.firstWhere((e)=>e["key"]==key,orElse: ()=>{});
        Map<String,dynamic> animationParametersObject = animationParameters.firstWhere((e)=>e["key"]==key,orElse: ()=>{});
        animationObject = {
          "key": key, 
          "progress": 0.0, 
          "type": animationType,
          "turn": turn,
          "body": body, 
          "parameters": animationParametersObject
        };

        if (tileObject.isNotEmpty) {
          animationData.add(animationObject);
        }
      }

      // timerLogic(gamePlayState,animationObject,count,target,animationDurationData["interval"]);
      Timer.periodic(Duration(milliseconds: animationDurationData["interval"]), (Timer timer) {
        if (gamePlayState.isGamePaused) {
          timer.cancel();
        } else {
          if (count == target) {
            timer.cancel();
            final int animationObjectIndex = animationData.indexOf(animationObject);
            if (animationObjectIndex>=0) {
              try {
                animationData.removeAt(animationObjectIndex);
                // gamePlayState.startStopWatch();
              } catch (e) {
                print("error caught in startWordFoundAnimation() => $e");
              }
            }
          } else {
            final int animationObjectIndex = animationData.indexOf(animationObject);
            if (animationObjectIndex<0) {
              timer.cancel();
            } else {
              count++;
              final double progress = double.parse((count/target).toStringAsFixed(2));
              animationData[animationObjectIndex].update("progress", (v) => progress);
            }
          }
        }
        gamePlayState.setAnimationData(animationData);
      });


      
    }

  }


  void removeFreezeAndSwapAnimationsFromPreWordFound(GamePlayState gamePlayState, int turn) {
    Map<String,dynamic> turnData = gamePlayState.scoreSummary.firstWhere((e)=>e["turn"]==turn,orElse: ()=>{});

    for (int i=0;i<turnData["ids"].length;i++) {
      int id = turnData["ids"][i]["id"];
      List<Map<String,dynamic>> existingOptionAnimations = gamePlayState.animationData.where(
        (e)=>e["key"]==id
        && e["type"]=="tile-freeze"
        || e["key"]==id 
        && e["type"]=="tile-swap"
      ).toList();
      for (int j=0; j<existingOptionAnimations.length; j++) {
        Map<String,dynamic> existingOptionAnimationObject = existingOptionAnimations[j];

        if (existingOptionAnimationObject["type"]=="tile-swap") {
        //   // only for the target tile!
          if (existingOptionAnimationObject["targetKey"] != id) {
            Map<String,dynamic> targetAnimation = gamePlayState.animationData.firstWhere(
              (e)=>e["key"]==existingOptionAnimationObject["targetKey"],
              orElse: ()=>{}
            );
            int targetAnimationIndex = gamePlayState.animationData.indexOf(targetAnimation);
            print("removed: $targetAnimation");        
            gamePlayState.animationData.removeAt(targetAnimationIndex); 
          }
        }
        int existingOptionAnimationIndex = gamePlayState.animationData.indexOf(existingOptionAnimationObject);
        print("removed $existingOptionAnimationObject");
        gamePlayState.animationData.removeAt(existingOptionAnimationIndex);
      }
    }
  }



  void startPreWordFoundAnimation(GamePlayState gamePlayState, ColorPalette palette, int turn) {

    const String animationType = "pre-word-found";
    Map<String,dynamic> turnData = gamePlayState.scoreSummary.firstWhere((e)=>e["turn"]==turn,orElse: ()=>{});
    String moveType = gamePlayState.scoreSummary.last["moveData"]["type"]; //"tap-up";
    Map<String,dynamic> animationDurationData = AnimationUtils().getAnimationDuration(gamePlayState,moveType); //gamePlayState.animationLengths.firstWhere((e)=>e["type"]==moveType);


    int target = animationDurationData["stops"];

    // int tileTappedKey = turnData["tileTapped"]["key"];

    removeFreezeAndSwapAnimationsFromPreWordFound(gamePlayState,turn);


    List<Map<String,dynamic>> allIds = AnimationUtils().getAllIdsInPreFoundWordAnimation(gamePlayState,turn);
    print(allIds);
    
    for (int i=0;i<allIds.length;i++) {

      int key = allIds[i]["id"];

      Map<String,dynamic> existingAnimationObject = gamePlayState.animationData.firstWhere((e)=>e["key"]==key&&e["type"]==animationType,orElse: ()=>{});

      // if (key != tileTappedKey) {
        late Map<String,dynamic> animationObject = {};
        int count = 0;
        if (existingAnimationObject.isNotEmpty) {
          final double progress = existingAnimationObject["progress"];
          count = (progress*target).round();
          animationObject = existingAnimationObject;

        } else {
          String body = allIds[i]["body"];
          late Map<String,dynamic> tileObject = gamePlayState.tileData.firstWhere((e)=>e["key"]==key,orElse: ()=>{});
          // String? moveType = turnData["moveType"];
          late Map<String,dynamic> moveData = turnData["moveData"];
          animationObject = {
            "key": key, 
            "progress": 0.0, 
            "type": animationType, 
            "body": body,
            "turn": turn,
            "moveData": moveData,
          };
          if (tileObject.isNotEmpty) {
            gamePlayState.animationData.add(animationObject);
          }
        }

        timerLogic2(
          gamePlayState,
          animationObject,
          count,
          target,
          animationDurationData["interval"], 
          ()=>GameLogic().executeWordFoundAnimations(gamePlayState, palette, turn)
          );

        // timerLogic(gamePlayState,animationObject,count,target,animationDurationData["interval"]);
    }
  }


  void startTileDroppedAnimation(GamePlayState gamePlayState, int sourceKey, int targetKey, Offset dropLocation) {
    const String animationType = "tile-drop";
    Map<String,dynamic> animationDurationData = gamePlayState.animationLengths.firstWhere((e)=>e["type"]==animationType);


    int target = animationDurationData["stops"];
    int sourceCount = 0;
    int targetCount = 0;
    Map<String,dynamic> animationParameters = {"sourceKey":sourceKey,"targetKey":targetKey,"dropLocation":dropLocation};


    /// ==================== SOURCE TILE =====================================
    /// Get the source tile from the reserves
    Map<String,dynamic> sourceTileObject = gamePlayState.reserveTileData.firstWhere((e)=>e["key"]==sourceKey,orElse: () => {},);
    String sourceTileBody = sourceTileObject["body"];

    // look for an existing "drop-tile" animation impacting this tile
    Map<String,dynamic> sourceAnimationObject = gamePlayState.animationData.firstWhere((e)=>e["key"]==sourceKey&&e["type"]==animationType,orElse: ()=>{});
    late Map<String,dynamic> actualSourceAnimationObject = {};

    if (sourceAnimationObject.isNotEmpty) {
      final double progress = sourceAnimationObject["progress"];
      sourceCount = (progress*target).round();
      actualSourceAnimationObject = sourceAnimationObject;  

    } else {

      actualSourceAnimationObject = {
        "key": sourceKey, 
        "progress": 0.0, 
        "type": animationType, 
        "parameters": animationParameters,
        "tileObject": sourceTileObject,
      };
      if (sourceTileObject.isNotEmpty) {
        gamePlayState.animationData.add(actualSourceAnimationObject);
      }      
    }

    // timerLogic(gamePlayState,actualSourceAnimationObject,sourceCount,target,animationDurationData["interval"]);
    Timer.periodic(Duration(milliseconds: animationDurationData["interval"]), (Timer timer) {
      if (gamePlayState.isGamePaused) {
        timer.cancel();
      } else {
        if (sourceCount == target) {
          timer.cancel();
          final int animationObjectIndex = gamePlayState.animationData.indexOf(actualSourceAnimationObject);
          if (animationObjectIndex>=0) {
            try {
              gamePlayState.animationData.removeAt(animationObjectIndex);
              
            } catch (e) {
              print("error caught in startTapCancelAnimation() => $e");
            }
          }
        } else {
          final int animationObjectIndex = gamePlayState.animationData.indexOf(actualSourceAnimationObject);
          if (animationObjectIndex<0) {
            timer.cancel();
          } else {

            sourceCount++;
            final double progress = double.parse((sourceCount/target).toStringAsFixed(2));
            gamePlayState.animationData[animationObjectIndex].update("progress", (v) => progress);
          }
        }
        gamePlayState.setAnimationData(gamePlayState.animationData);
      }
    });

    
    /// ===========================================================================

    /// ==================== TARGET TILE =====================================
    Map<String,dynamic> targetTileObject = gamePlayState.tileData.firstWhere((e)=>e["key"]==targetKey,orElse: () => {},);
    Map<String,dynamic> targetAnimationObject = gamePlayState.animationData.firstWhere((e)=>e["key"]==targetKey&&e["type"]==animationType,orElse: ()=>{});

    late Map<String,dynamic> actualTargetAnimationObject = {};
    if (targetAnimationObject.isNotEmpty) {
      final double progress = targetAnimationObject["progress"];
      targetCount = (progress*target).round();   
      actualTargetAnimationObject = targetAnimationObject;

    } else {
      double tileWidth = gamePlayState.elementSizes["tileSize"].width*0.8;
      Size reserveTileSize = Size(tileWidth,tileWidth);
      Map<String,dynamic> locationData = {"location": dropLocation, "size": reserveTileSize};
      // List<Map<String,dynamic>> explosionData = Helpers().getParticleData(targetTileObject["center"]);

      actualTargetAnimationObject = {
        "key": targetKey, 
        "progress": 0.0, 
        "type": animationType, 
        "parameters": animationParameters,
        "tileObject":targetTileObject,
        "body": sourceTileBody,
        "locationData": locationData,
        // "explosionData": explosionData
      };
      if (targetTileObject.isNotEmpty) {
        gamePlayState.animationData.add(actualTargetAnimationObject);
      }            
    }

    timerLogic(gamePlayState,actualTargetAnimationObject,targetCount,target,animationDurationData["interval"]);
    // Timer.periodic(Duration(milliseconds: animationDurationData["interval"]), (Timer timer) {
    //   if (gamePlayState.isGamePaused) {
    //     timer.cancel();      
    //   } else {
    //     if (targetCount == target) {
    //       timer.cancel();
    //       final int animationObjectIndex = gamePlayState.animationData.indexOf(actualTargetAnimationObject);
    //       if (animationObjectIndex>=0) {
    //         try {
    //           gamePlayState.animationData.removeAt(animationObjectIndex);
    //         } catch (e) {
    //           print("error caught in startTapCancelAnimation() => $e");
    //         }
    //       }
    //     } else {
    //       final int animationObjectIndex = gamePlayState.animationData.indexOf(actualTargetAnimationObject);
    //       if (animationObjectIndex<0) {
    //         timer.cancel();
    //       } else {
    //         targetCount++;
    //         final double progress = double.parse((targetCount/target).toStringAsFixed(2));
    //         gamePlayState.animationData[animationObjectIndex].update("progress", (v) => progress);
    //       }
    //     }
    //     gamePlayState.setAnimationData(gamePlayState.animationData);
    //   }
    // });
  /// ===========================================================================
  }


  void startScoreboardCountAnimation(GamePlayState gamePlayState,int turn, String key) {

    const String animationType = "score-count";
    // Map<String,dynamic> animationDurationData = gamePlayState.animationLengths.firstWhere((e)=>e["type"]==animationType);


    late int previousScore = 0;
    // late int newScore = 0;

    late int runningScore = previousScore;

    late Map<String,dynamic> lastTurn =  gamePlayState.scoreSummary.firstWhere((e)=>e["turn"]==turn,orElse: ()=>{});
    final int pointsScoredLastTurn = lastTurn["score"] as int;

    Map<String,dynamic> animationProperties = AnimationUtils().getScoreCountAnimationDuration(pointsScoredLastTurn,750,5500);
    int target = animationProperties["target"];
    int increment = animationProperties["increment"];
    int interval = animationProperties["interval"];
    int duration = animationProperties["duration"];

    previousScore = Helpers().getPreviousScore(gamePlayState, turn);

    // newScore = previousScore + lastTurn["score"] as int;


    int count = 0;

    late Map<String,dynamic> actualAnimation = {}; 
    Map<String,dynamic> existingAnimationObject = gamePlayState.animationData.firstWhere(
      (e)=>e["type"]=="score-count" && e["key"]==key,
      orElse:()=>{}
    );

    List<Map<String,dynamic>> otherCountAnimations = gamePlayState.animationData.where((e)=>e["type"]=="score-count").toList();

    for (int i=0; i<otherCountAnimations.length;i++) {
      if (otherCountAnimations[i]["key"]!=key) {
        // remove anim
        int animationIndex = gamePlayState.animationData.indexOf(otherCountAnimations[i]);
        gamePlayState.animationData.removeAt(animationIndex);
      }
    }
  
    if (existingAnimationObject.isNotEmpty) {
      final double progress = existingAnimationObject["progress"];
      count = (progress*target).round();
      runningScore = previousScore + (lastTurn["score"] * progress).round() as int;
      actualAnimation = existingAnimationObject;   
    }  else {
      // List<double> oscillatingColorData = Helpers().generateWave(numPoints: target, amplitude: 0.5, frequency: 2.0, phaseShift: 0.0);
      // print(oscillatingColorData);

      actualAnimation = {
        "key": key, 
        "type":animationType, 
        "turn":turn, 
        "progress":0.0, 
        "body": runningScore,
        "duration": duration,
      };
      gamePlayState.animationData.add(actualAnimation);
    }

    


    Timer.periodic(Duration(milliseconds: interval), (Timer timer) {
      if (gamePlayState.isGamePaused) {
        timer.cancel();      
      } else {
        if (count == target) {
          timer.cancel();
          final int animationObjectIndex = gamePlayState.animationData.indexOf(actualAnimation);
          if (animationObjectIndex>=0) {
            try {
              gamePlayState.animationData.removeAt(animationObjectIndex);
              startScoreboardHighlightAnimation(gamePlayState);
            } catch (e) {
              print("error caught in startScoreCountAnimation() => $e");
            }
          }
        } else {
          final int animationObjectIndex = gamePlayState.animationData.indexOf(actualAnimation);
          if (animationObjectIndex<0) {
            timer.cancel();
          } else {
            count++;
            runningScore = runningScore + increment;
            // runningScore ++;
            final double progress = double.parse((count/target).toStringAsFixed(2));
            gamePlayState.animationData[animationObjectIndex].update("progress", (v) => progress);
            gamePlayState.animationData[animationObjectIndex].update("body", (v) => runningScore);
          }
        }
        gamePlayState.setAnimationData(gamePlayState.animationData);
      }
    });

  }


  void startScoreboardHighlightAnimation(GamePlayState gamePlayState) {
    const String animationType = "score-highlight";
    Map<String,dynamic> animationDurationData = gamePlayState.animationLengths.firstWhere((e)=>e["type"]==animationType);

    int target = animationDurationData["stops"];
    int count = 0;

    late Map<String,dynamic> actualAnimation = {}; 
    Map<String,dynamic> existingAnimationObject = gamePlayState.animationData.firstWhere((e)=>e["type"]=="score-highlight",orElse:()=>{});

    if (existingAnimationObject.isNotEmpty) {
      final double progress = existingAnimationObject["progress"];
      count = (progress*target).round();
      actualAnimation = existingAnimationObject;      
    }  else {
      actualAnimation = {"key": null, "type":animationType, "progress":0.0, "animation": {} };
      gamePlayState.animationData.add(actualAnimation);
    }


    timerLogic(gamePlayState,actualAnimation,count,target,animationDurationData["interval"]);
  }



  void startScoreboardPlusNPoints(GamePlayState gamePlayState, int turn) {
    const String animationType = "score-points";
    Map<String,dynamic> animationDurationData = gamePlayState.animationLengths.firstWhere((e)=>e["type"]==animationType);

    int stops = animationDurationData["stops"];
    int interval = animationDurationData["interval"];
    Random random = Random();
    double tileWidth = gamePlayState.elementSizes["tileSize"].width;
    int count = 0;
    late Map<String,dynamic> lastTurn =  gamePlayState.scoreSummary.firstWhere((e)=>e["turn"]==turn,orElse: ()=>{});


    int durationMs = interval*stops*lastTurn["validStrings"].length as int;


    double animDuration = double.parse((durationMs/lastTurn["validStrings"].length).toStringAsFixed(2));
    double durationAdjustment = (animDuration + (lastTurn["validStrings"].length-1) * (animDuration/2))/durationMs;
    double adjustedTotalDuration = double.parse((durationMs * durationAdjustment).toStringAsFixed(2));
    double adjustedTarget = adjustedTotalDuration/interval;
    

    int target = adjustedTarget.round();    
    late List<Map<String,dynamic>> scorePointsAnimations = gamePlayState.animationData.where((e)=>e["type"]==animationType).toList();

    late Map<String,dynamic> actualAnimation = {};

    late String animationKey = "${turn}_score_points";
    Map<String,dynamic> existingAnimationObject = scorePointsAnimations.firstWhere((e)=>e["key"]==animationKey,orElse:()=>{});
    List<Map<String,dynamic>> scoreObjects = [];


    for (int i=0; i<lastTurn["validStrings"].length; i++) {
      Map<String,dynamic> stringData = lastTurn["validStrings"][i];
      String key = stringData["key"];
      int points = stringData["score"];
      double randomXOffset = (random.nextDouble() * (tileWidth) * -1);
      Map<String,dynamic> scoreObject = {"key":key, "body": points, "xOffset":randomXOffset};
      scoreObjects.add(scoreObject);

    }
    if (existingAnimationObject.isNotEmpty) {
      final double progress = existingAnimationObject["progress"];
      count = (progress*target).round();
      actualAnimation = existingAnimationObject;
    }  else {
      actualAnimation = {"key": animationKey, "type":animationType, "turn": turn, "progress":0.0, "animation": scoreObjects };
      gamePlayState.animationData.add(actualAnimation);
    }
    timerLogic(gamePlayState,actualAnimation,count,target, interval );

  }

  void startNewPointsScoredAnimation(GamePlayState gamePlayState, int turn, String key) {
    const String animationType = "new-points";
    Map<String,dynamic> animationDurationData = gamePlayState.animationLengths.firstWhere((e)=>e["type"]==animationType);

    int target = animationDurationData["stops"];
    int count = 0;
    late int pointsScoredLastTurn = 0;


    // List<Map<String,dynamic>> newPointsScoredAnimations = gamePlayState.animationData.where((e)=> e]);



    late Map<String,dynamic> actualAnimation = {};
    
    Map<String,dynamic> existingAnimationObject = gamePlayState.animationData.firstWhere(
      (e)=> e["key"]==key, orElse:()=>{}
    );

    if (existingAnimationObject.isNotEmpty) {
      final double progress = existingAnimationObject["progress"];
      print("there is an existing animation: $key => progress: $progress");
      count = (progress*target).round();
      actualAnimation = existingAnimationObject;      
    }  else {
            
      late Map<String,dynamic> lastTurn =  gamePlayState.scoreSummary.firstWhere((e)=>e["turn"]==turn,orElse: ()=>{});
      if (lastTurn.isNotEmpty) {
        pointsScoredLastTurn =  lastTurn["score"] as int;
      }
      actualAnimation = {
        "key": "${turn}_new_points", 
        "type":animationType, 
        "turn":turn, 
        "progress":0.0, 
        "body": pointsScoredLastTurn,
        "tile": lastTurn["tileTapped"],
        "animation": {}
      };
      gamePlayState.animationData.add(actualAnimation);
    }
    timerLogic(gamePlayState,actualAnimation,count,target,animationDurationData["interval"]);
  }



  void startKillTileAnimation(GamePlayState gamePlayState, int key) {
    print("launching kill tile animation");
    const String animationType = "kill-tile";
    Map<String,dynamic> animationDurationData = gamePlayState.animationLengths.firstWhere((e)=>e["type"]==animationType);

    int target = animationDurationData["stops"];
    int count = 0;

    late Map<String,dynamic> actualAnimation = {}; 
    Map<String,dynamic> existingAnimationObject = gamePlayState.animationData.firstWhere((e)=>e["type"]==animationType,orElse:()=>{});

    if (existingAnimationObject.isNotEmpty) {
      // int existingAnimationIndex = gamePlayState.animationData.indexOf(existingAnimationObject);
      // gamePlayState.animationData.removeAt(existingAnimationIndex);
      final double progress = existingAnimationObject["progress"];
      count = (progress*target).round();
      actualAnimation = existingAnimationObject;      
    }  else {

      actualAnimation = {"key": key, "type":animationType, "progress":0.0, "animation": {} };
      gamePlayState.animationData.add(actualAnimation);
    }
    timerLogic(gamePlayState,actualAnimation,count,target,animationDurationData["interval"]);
  }  

  void startBonusAnimations(GamePlayState gamePlayState, int turn) {
    const String animationType = "bonus";
    Map<String,dynamic> animationDurationData = gamePlayState.animationLengths.firstWhere((e)=>e["type"]==animationType);
    int stops = animationDurationData["stops"];
    int interval = animationDurationData["interval"];

    late Map<String,dynamic> lastTurn =  gamePlayState.scoreSummary.firstWhere((e)=>e["turn"]==turn,orElse: ()=>{});

    late List<Map<String,dynamic>> multiplierData = [];
    lastTurn["multipliers"].forEach((key,value) {
      if (value>1) {
        multiplierData.add({"key":key,"value":value});
      }
    });


    for (int i=0; i<multiplierData.length;i++) {

      final Map<String,dynamic> multiplierObject = multiplierData[i];
      final String key = multiplierObject["key"];
      final int value = multiplierObject["value"];
      

      int target = stops;
      int count = 0;

      late Map<String,dynamic> actualAnimation = {}; 
      Map<String,dynamic> existingAnimationObject = gamePlayState.animationData.firstWhere(
        (e)=>e["type"]==animationType && e["key"]=="${key}_${turn}",
        orElse:()=>{}
      );
      

      if (existingAnimationObject.isNotEmpty) {
        final double progress = existingAnimationObject["progress"];
        count = (progress*target).round();
        // count = 0;
        actualAnimation = existingAnimationObject;
        int animationIndex = gamePlayState.animationData.indexOf(existingAnimationObject);
        if (animationIndex > 0) {
          gamePlayState.animationData.removeAt(animationIndex);
          actualAnimation = {"key": "${key}_${turn}", "type":animationType, "turn":turn, "progress":progress, "animation": {"bonus":key, "body":value}};
          gamePlayState.animationData.add(actualAnimation);
        }
      }  else {
        actualAnimation = {"key": "${key}_${turn}", "type":animationType, "turn":turn, "progress":0.0, "animation": {"bonus":key, "body":value}};
        gamePlayState.animationData.add(actualAnimation);
      }

      const int delayFactor = 400;
      late int delay = i * delayFactor;
      // if(key=="streak") {delay=0;} else if (key=="words") {delay=300;} else if (key=="cross") {delay=600;}
      Future.delayed(Duration(milliseconds: delay), () {
        timerLogic(gamePlayState,actualAnimation,count,target,interval);
      });
    }
    // lastTurn["multipliers"].forEach((key,value) {
    //   if (value > 1) {

    //     int target = stops;
    //     int count = 0;

    //     late Map<String,dynamic> actualAnimation = {}; 
    //     Map<String,dynamic> existingAnimationObject = gamePlayState.animationData.firstWhere(
    //       (e)=>e["type"]==animationType && e["key"]=="${key}_${turn}",
    //       orElse:()=>{}
    //     );
        

    //     if (existingAnimationObject.isNotEmpty) {
    //       final double progress = existingAnimationObject["progress"];
    //       count = (progress*target).round();
    //       // count = 0;
    //       actualAnimation = existingAnimationObject;
    //       int animationIndex = gamePlayState.animationData.indexOf(existingAnimationObject);
    //       if (animationIndex > 0) {
    //         gamePlayState.animationData.removeAt(animationIndex);
    //         actualAnimation = {"key": "${key}_${turn}", "type":animationType, "turn":turn, "progress":progress, "animation": {"bonus":key, "body":value}};
    //         gamePlayState.animationData.add(actualAnimation);
    //       }
    //     }  else {
    //       actualAnimation = {"key": "${key}_${turn}", "type":animationType, "turn":turn, "progress":0.0, "animation": {"bonus":key, "body":value}};
    //       gamePlayState.animationData.add(actualAnimation);
    //     }

    //     const int delayFactor = 400;
    //     late int delay = i * delayFactor;
    //     if(key=="streak") {delay=0;} else if (key=="words") {delay=300;} else if (key=="cross") {delay=600;}
    //     Future.delayed(Duration(milliseconds: delay), () {
    //       timerLogic(gamePlayState,actualAnimation,count,target,interval);
    //     });

    //   }
    // });
            
  }

  // void startAddPerksAnimation2(GamePlayState gamePlayState, int key) {
  //   print("launching startAddPerksAnimation2 animation");
  //   const String animationType = "add-perks";
  //   Map<String,dynamic> animationDurationData = gamePlayState.animationLengths.firstWhere((e)=>e["type"]==animationType);

  //   int target = animationDurationData["stops"];
  //   int count = 0;

  //   late Map<String,dynamic> actualAnimation = {}; 
  //   Map<String,dynamic> existingAnimationObject = gamePlayState.animationData.firstWhere((e)=>e["type"]==animationType,orElse:()=>{});

  //   if (existingAnimationObject.isNotEmpty) {
  //     // int existingAnimationIndex = gamePlayState.animationData.indexOf(existingAnimationObject);
  //     // gamePlayState.animationData.removeAt(existingAnimationIndex);
  //     final double progress = existingAnimationObject["progress"];
  //     count = (progress*target).round();
  //     actualAnimation = existingAnimationObject;      
  //   }  else {

  //     actualAnimation = {"key": key, "type":animationType, "progress":0.0, "animation": {} };
  //     gamePlayState.animationData.add(actualAnimation);
  //   }
  //   timerLogic(gamePlayState,actualAnimation,count,target,animationDurationData["interval"]);
  // }  


  void startLevelUpAnimation(GamePlayState gamePlayState,) {
    const String animationType = "level-up";
    Map<String,dynamic> animationDurationData = gamePlayState.animationLengths.firstWhere((e)=>e["type"]==animationType);
    int stops = animationDurationData["stops"];
    int interval = animationDurationData["interval"];

    int target = stops;
    int count = 0;

    int body = gamePlayState.currentLevel;

    late Map<String,dynamic> actualAnimation = {}; 
    Map<String,dynamic> existingAnimationObject = gamePlayState.animationData.firstWhere(
      (e)=>e["type"]==animationType && e["key"]==animationType,
      orElse:()=>{}
    );

    if (existingAnimationObject.isNotEmpty) {
      final double progress = existingAnimationObject["progress"];
      count = (progress*target).round();
      actualAnimation = existingAnimationObject;      
    }  else {
      actualAnimation = {"key": animationType, "type":animationType,"progress":0.0, "body": body};
      gamePlayState.animationData.add(actualAnimation);
    }
    timerLogic(gamePlayState,actualAnimation,count,target,interval);
  }

  void startTileFreezeAnimation(GamePlayState gamePlayState,int key) {
    const String animationType = "tile-freeze";
    Map<String,dynamic> animationDurationData = gamePlayState.animationLengths.firstWhere((e)=>e["type"]==animationType);
    int stops = animationDurationData["stops"];
    int interval = animationDurationData["interval"];

    int target = stops;
    int count = 0;
    Map<String,dynamic> tileObject = gamePlayState.tileData.firstWhere(
      (e)=>e["key"]==key,
      orElse:()=>{}
    );

    String body = "";
    if (tileObject.isNotEmpty) {
      body = tileObject["body"];
    }

    late Map<String,dynamic> actualAnimation = {}; 
    
    Map<String,dynamic> existingAnimationObject = gamePlayState.animationData.firstWhere(
      (e)=>e["type"]==animationType && e["key"]==key,
      orElse:()=>{}
    );

    if (existingAnimationObject.isNotEmpty) {
      final double progress = existingAnimationObject["progress"];
      body = existingAnimationObject["body"];
      count = (progress*target).round();
      actualAnimation = existingAnimationObject;      
    }  else {
      actualAnimation = {"key": key, "type":animationType,"body":body, "progress":0.0,};
      gamePlayState.animationData.add(actualAnimation);
    }
    timerLogic(gamePlayState,actualAnimation,count,target,interval);
  }      

  void startTileExplodeAnimation(GamePlayState gamePlayState,int key) {
    const String animationType = "tile-explode";
    Map<String,dynamic> animationDurationData = gamePlayState.animationLengths.firstWhere((e)=>e["type"]==animationType);
    int stops = animationDurationData["stops"];
    int interval = animationDurationData["interval"];
    Size tileSize = gamePlayState.elementSizes["tileSize"];

    int target = stops;
    int count = 0;

    late Map<String,dynamic> actualAnimation = {}; 
    Map<String,dynamic> existingAnimationObject = gamePlayState.animationData.firstWhere(
      (e)=>e["type"]==animationType && e["key"]==key,
      orElse:()=>{}
    );

    late List<Map<String,dynamic>> explosionData = [];
    late Map<String,dynamic> tileObject = gamePlayState.tileData.firstWhere((e)=>e["key"]==key,orElse: ()=>{});
    if (tileObject.isNotEmpty) {
      explosionData = AnimationUtils().getParticleData(tileObject["center"], tileSize);
    } 


    if (existingAnimationObject.isNotEmpty) {
      final double progress = existingAnimationObject["progress"];
      count = (progress*target).round();
      actualAnimation = existingAnimationObject;      
    }  else {
      String tileType = tileObject["active"] ? "board":"dead";
      actualAnimation = {"key": key, "type":animationType,"progress":0.0, "tileType": tileType, "explosionData": explosionData};
      gamePlayState.animationData.add(actualAnimation);
    }
    timerLogic(gamePlayState,actualAnimation,count,target,interval);
  }      

  void startTileSwapAnimation(GamePlayState gamePlayState,int turn, int key, int targetKey) {
    const String animationType = "tile-swap";
    Map<String,dynamic> animationDurationData = gamePlayState.animationLengths.firstWhere((e)=>e["type"]==animationType);
    int stops = animationDurationData["stops"];
    int interval = animationDurationData["interval"];

    int target = stops;
    int count = 0;

    late Map<String,dynamic> actualAnimation = {}; 
    Map<String,dynamic> existingAnimationObject = gamePlayState.animationData.firstWhere(
      (e)=>e["type"]==animationType 
      && e["turn"]==turn
      && e["key"]==key,
      orElse:()=>{}
    );

    if (existingAnimationObject.isNotEmpty) {
      final double progress = existingAnimationObject["progress"];
      count = (progress*target).round();
      actualAnimation = existingAnimationObject;      
    }  else {
      actualAnimation = {"key": key, "turn":turn, "type":animationType, "progress":0.0, "targetKey":targetKey};
      gamePlayState.animationData.add(actualAnimation);
    }


    timerLogic(gamePlayState,actualAnimation,count,target,interval);


  }        





  void startGameOverOverlayAnimation(GamePlayState gamePlayState) {
    print("launching game over animation");
    const String animationType = "game-over";
    Map<String,dynamic> animationDurationData = gamePlayState.animationLengths.firstWhere((e)=>e["type"]==animationType);

    int target = animationDurationData["stops"];
    int count = 0;

    late Map<String,dynamic> actualAnimation = {}; 
    Map<String,dynamic> existingAnimationObject = gamePlayState.animationData.firstWhere((e)=>e["type"]==animationType,orElse:()=>{});

    if (existingAnimationObject.isNotEmpty) {
      final double progress = existingAnimationObject["progress"];
      count = (progress*target).round();
      actualAnimation = existingAnimationObject;      
    }  else {
      actualAnimation = {"key": null, "type":animationType, "progress":0.0, "animation": {} };
      gamePlayState.animationData.add(actualAnimation);
    }

    Timer.periodic(Duration(milliseconds: animationDurationData["interval"]), (Timer timer) {
      if (gamePlayState.isGamePaused) {
        timer.cancel();      
      } else {
        if (count == target) {
          timer.cancel();

          
          final int animationObjectIndex = gamePlayState.animationData.indexOf(actualAnimation);
          if (animationObjectIndex>=0) {
            try {
              // gamePlayState.animationData.removeAt(animationObjectIndex);
            } catch (e) {
              print("error caught in startGameOverOverlayAnimation() => $e");
            }
          }
        } else {
          final int animationObjectIndex = gamePlayState.animationData.indexOf(actualAnimation);
          if (animationObjectIndex<0) {
            timer.cancel();
          } else {
            count++;
            final double progress = double.parse((count/target).toStringAsFixed(2));
            gamePlayState.animationData[animationObjectIndex].update("progress", (v) => progress);
          }
        }
        gamePlayState.setAnimationData(gamePlayState.animationData);
      }
    });
  }

  void startTileMenuControlAnimation(GamePlayState gamePlayState, String key, int turn, int tilekey, bool open, Map<String,dynamic>? tileData) {
    print("launching tile menu open animation at key $tilekey | open? $open");
    const String animationType = "tile-menu";
    Map<String,dynamic> animationDurationData = gamePlayState.animationLengths.firstWhere((e)=>e["type"]==animationType);

    int target = animationDurationData["stops"];
    int interval = animationDurationData["interval"];
    int count = 0;

    late Map<String,dynamic> actualAnimation = {}; 
    Map<String,dynamic> existingAnimationObject = gamePlayState.animationData.firstWhere((e)=>e["type"]==animationType,orElse:()=>{});

    if (existingAnimationObject.isNotEmpty) {

      late double progress = existingAnimationObject["progress"];
      
      if (existingAnimationObject["animation"]["open"]==true && open==false) {
        // reverse the animation - keep the same progress but change the open bool value to false
        progress = 1.0-existingAnimationObject["progress"];

        int animationIndex = gamePlayState.animationData.indexOf(existingAnimationObject);
        gamePlayState.animationData.removeAt(animationIndex);
        // create a new instance of the animation to avoid a duplication bug
        actualAnimation = {"key": key, "turn":turn, "type":animationType, "progress":progress, "animation": {"open":open, "tile":tileData} };
        gamePlayState.animationData.add(actualAnimation);
      } else {
        actualAnimation = existingAnimationObject;
      }

      count = (progress*target).round();

    }  else {
      actualAnimation = {"key": key,"turn":turn, "type":animationType, "progress":0.0, "animation": {"open":open,"tile":tileData} };
      gamePlayState.animationData.add(actualAnimation);
    }


    timerLogic(gamePlayState,actualAnimation,count,target,interval);

  }

  // void startMenuItemChargeAnimation(GamePlayState gamePlayState,String key, Map<String,dynamic> chargeData) {
  //   const String animationType = "menu-charge";
  //   Map<String,dynamic> animationDurationData = gamePlayState.animationLengths.firstWhere((e)=>e["type"]==animationType);

  //   int target = animationDurationData["stops"];
  //   int interval = animationDurationData["interval"];

  //   int count = 0;

  //   late Map<String,dynamic> actualAnimation = {}; 
  //   Map<String,dynamic> existingAnimationObject = gamePlayState.animationData.firstWhere(
  //     (e)=>e["type"]==animationType
  //     && e["key"]==key,
  //     orElse:()=>{}); 

  //   if (existingAnimationObject.isNotEmpty) {
  //     final double progress = existingAnimationObject["progress"];
  //     count = (progress*target).round();
  //     actualAnimation = existingAnimationObject;      
  //   }  else {
  //     actualAnimation = {"key": key, "type":animationType, "progress":0.0, "animation": {"data":chargeData} };
  //     gamePlayState.animationData.add(actualAnimation);
  //   }

  //   timerLogic(gamePlayState,actualAnimation,count,target,interval);
  // }


  void startStopwatchRewindAnimation(GamePlayState gamePlayState) {
    const String animationType = "stopwatch-rewind";
    Map<String,dynamic> animationDurationData = gamePlayState.animationLengths.firstWhere((e)=>e["type"]==animationType);

    int target = animationDurationData["stops"];
    int interval = animationDurationData["interval"];
    int count = 0;

    late Map<String,dynamic> actualAnimation = {}; 
    Map<String,dynamic> existingAnimationObject = gamePlayState.animationData.firstWhere((e)=>e["type"]==animationType,orElse:()=>{});

    if (existingAnimationObject.isNotEmpty) {
      final double progress = existingAnimationObject["progress"];
      count = (progress*target).round();
      actualAnimation = existingAnimationObject;      
    }  else {
      actualAnimation = {"key": null, "type":animationType, "progress":0.0, "animation": {} };
      gamePlayState.animationData.add(actualAnimation);
    }

    timerLogic(gamePlayState,actualAnimation,count,target,interval);
  }

  void startUndoAnimation(GamePlayState gamePlayState, int turn) {
    const String animationType = "undo";
    Map<String,dynamic> animationDurationData = gamePlayState.animationLengths.firstWhere((e)=>e["type"]==animationType);
    int target = animationDurationData["stops"];
    int interval = animationDurationData["interval"];
    int count = 0;
    Map<String,dynamic> turnData = gamePlayState.scoreSummary.firstWhere((e)=>e["turn"]==turn,orElse: ()=>{});
    List<Map<String,dynamic>> animationData = gamePlayState.animationData;
    print(" IN UNDO ANIMATION FUNC: $turn | ${turnData} | ");
    // print("RANDOM LETTER -1 : ${gamePlayState.randomLetterData[gamePlayState.randomLetterData.length-1]}");
    // print("RANDOM LETTER -2 : ${gamePlayState.randomLetterData[gamePlayState.randomLetterData.length-2]}");
    // print("RANDOM LETTER -3 : ${gamePlayState.randomLetterData[gamePlayState.randomLetterData.length-3]}");

    Map<String,dynamic> randomLetter3 = gamePlayState.randomLetterData[gamePlayState.randomLetterData.length-1];


    Map<String,dynamic> targetTile = turnData["tileTapped"];
    Map<String,dynamic>? randomLetterObject = null;
    Offset? destination = null;


    final double randomLetterCenterY = gamePlayState.elementPositions["randomLettersCenter"].dy;
    final double randomLetter1CenterX = gamePlayState.elementPositions["randomLettersCenter"].dx;
    final Offset randomLetter1Center = Offset(randomLetter1CenterX,randomLetterCenterY);

    List<Map<String,dynamic>> affectedIds = [];
    bool didScore = turnData["score"]>0;
    List<int> focusIds = [];
    if (turnData["moveData"]["data"]["target"]!=null) {
      focusIds.add(turnData["moveData"]["data"]["target"]["key"]);
    }
    if (turnData["moveData"]["data"]["souce"]!=null) {
      focusIds.add(turnData["moveData"]["data"]["source"]["key"]);
    }    
    // if (turnData["score"]>0) {
    //   affectedIds = turnData["ids"];
    //   Map<String,dynamic> targetIdObject = affectedIds.firstWhere((e)=>e["id"]==targetTile["key"],orElse: ()=>{});
    //   if (targetIdObject.isNotEmpty) {
    //     targetIdObject.update("body", (v)=>"");
    //   }
    //   // for (int i=0;i<turnData["ids"];i++) {
    //   //   Map<String,dynamic> affectedId = turnData["ids"]
    //   // }
    // } else {

    //   if (turnData["moveData"]["type"]=="placed") {
    //     affectedIds.add({"id": targetTile["key"],"body":targetTile["body"]});
    //     destination = randomLetter1Center;
    //   } else if (turnData["moveData"]["type"]=="dropped") {
    //     Map<String,dynamic> reserveTile = turnData["moveData"]["data"]["source"];
    //     print("startUndoAnimation: $reserveTile");
    //     affectedIds.add({"id": targetTile["key"],"body":targetTile["body"]});
    //     affectedIds.add({"id": reserveTile["key"],"body":targetTile["body"]});
    //     Map<String,dynamic> reserveObject = gamePlayState.reserveTileData.firstWhere((e)=>e["key"]==reserveTile["key"]);

    //     destination = reserveObject["center"];
    //   }
    // }

    if (turnData["moveData"]["type"]=="placed") {
      
      if (didScore) {
        affectedIds = turnData["ids"];
        Map<String,dynamic> targetIdObject = affectedIds.firstWhere((e)=>e["id"]==targetTile["key"],orElse: ()=>{});
        if (targetIdObject.isNotEmpty) {
          targetIdObject.update("body", (v)=>"");
        }
      } else {
        affectedIds.add({"id": targetTile["key"],"body":targetTile["body"]});
        destination = randomLetter1Center;        
      }

    } else if (turnData["moveData"]["type"]=="dropped") {
      Map<String,dynamic> reserveTile = turnData["moveData"]["data"]["source"];
      Map<String,dynamic> reserveObject = gamePlayState.reserveTileData.firstWhere((e)=>e["key"]==reserveTile["key"]);
      if (didScore) {
        affectedIds = turnData["ids"];
        Map<String,dynamic> targetIdObject = affectedIds.firstWhere((e)=>e["id"]==targetTile["key"],orElse: ()=>{});
        if (targetIdObject.isNotEmpty) {
          affectedIds.add({"id": reserveTile["key"],"body":targetIdObject["body"]});
          targetIdObject.update("body", (v)=>"");
          // destination = reserveObject["center"];   
        }
      } else {
        affectedIds.add({"id": targetTile["key"],"body":targetTile["body"]});
        affectedIds.add({"id": reserveTile["key"],"body":targetTile["body"]});
        
        destination = reserveObject["center"];        
      }
    } else if (turnData["moveData"]["type"]=="explode") {
      print("turn data: ${turnData["moveData"]["data"]["target"]}");
      affectedIds.add({"id": turnData["moveData"]["data"]["target"]["key"],"body":turnData["moveData"]["data"]["target"]["body"]});
    } else if (turnData["moveData"]["type"]=="swap") {
      Map<String,dynamic> sourceIdObject = {"id": turnData["moveData"]["data"]["source"]["key"],"body":turnData["moveData"]["data"]["target"]["body"]};
      Map<String,dynamic> targetIdObject = {"id": turnData["moveData"]["data"]["target"]["key"],"body":turnData["moveData"]["data"]["source"]["body"]};
      if (didScore) {
        affectedIds = turnData["ids"];
        List<dynamic> uniqueIds = turnData["ids"].map((product) => product['id'] as int).toList();
        if (!uniqueIds.contains(turnData["moveData"]["data"]["source"]["key"])) {
          affectedIds.add(sourceIdObject);
        }
        if (!uniqueIds.contains(turnData["moveData"]["data"]["target"]["key"])) {
          affectedIds.add(targetIdObject);
        }
        // affectedIds = turn
      } else {
        affectedIds.add(sourceIdObject);
        affectedIds.add(targetIdObject);
      }
    } else if (turnData["moveData"]["type"]=="freeze") {
      print("freeze ${turnData["moveData"]}");
      // affectedIds.add({"id": turnData["moveData"]["data"]["target"]["key"],"body":turnData["moveData"]["data"]["target"]["body"]});
      if (didScore) {
        affectedIds = turnData["ids"];
      } else {
        affectedIds.add({"id": turnData["moveData"]["data"]["target"]["key"],"body":turnData["moveData"]["data"]["target"]["body"]});
      }
      
    }

    print("AFFECTED IDS: $affectedIds");


    
    for (int i=0; i<affectedIds.length; i++) {

      if (affectedIds[i]["id"] != null && affectedIds[i]["body"] != null) {
        int key = affectedIds[i]["id"];
        String body = affectedIds[i]["body"];
        if (turnData["score"]>0 && targetTile["key"]==key) {
          body = "";
        }
        bool isFocusTile = false;
        if (focusIds.contains(key)) {
          isFocusTile = true;
        }
        List<Map<String,dynamic>> otherAnimations = animationData.where((e)=>e["key"]==key&&e["type"]!=animationType).toList();
        for (int j=0;j<otherAnimations.length;j++) {
          Map<String,dynamic> otherAnimation = otherAnimations[j];
          final int otherAnimationIndex = animationData.indexOf(otherAnimation);
          animationData.removeAt(otherAnimationIndex);        
        }
        Map<String,dynamic> existingAnimationObject = animationData.firstWhere( (e)=>
          e["key"]==key&&
          [animationType,"undo"].contains(e["type"]),
          orElse: ()=>{}
        );
        
        late Map<String,dynamic> animationObject = {};

        late int count = 0;

        if (existingAnimationObject.isNotEmpty) {
          final double progress = existingAnimationObject["progress"];
          count = (progress*target).round();
          animationObject = existingAnimationObject;

        } else {
          List<Map<String,dynamic>> allTiles = gamePlayState.tileData+gamePlayState.reserveTileData;
          late Map<String,dynamic> tileObject = allTiles.firstWhere((e)=>e["key"]==key,orElse: ()=>{});

          // Map<String,dynamic> animationParametersObject = animationParameters.firstWhere((e)=>e["key"]==key,orElse: ()=>{});
          animationObject = {
            "key": key, 
            "progress": 0.0, 
            "type": "undo",
            "turn": turn,
            "body": body, 
            "parameters": {
              "moveType": turnData["moveData"]["type"], 
              "destination":destination, 
              "didScore":didScore,
              "isFocusTile":isFocusTile,
              "randomLetter3":randomLetter3
            }
          };

          if (tileObject.isNotEmpty) {
            animationData.add(animationObject);
          }
        }
        timerLogic(gamePlayState, animationObject, count, target, animationDurationData["interval"]);
      }
    }
    // late Map<String,dynamic> actualAnimation = {}; 
    // Map<String,dynamic> existingAnimationObject = gamePlayState.animationData.firstWhere( (e) => 
    //   e["type"]==animationType &&
    //   e["key"]==key,
    //   orElse:()=>{}
    // );

    // if (existingAnimationObject.isNotEmpty) {
    //   final double progress = existingAnimationObject["progress"];
    //   count = (progress*target).round();
    //   actualAnimation = existingAnimationObject;      
    // }  else {
    //   actualAnimation = {"key": null, "type":animationType, "progress":0.0, "animation": {} };
    //   gamePlayState.animationData.add(actualAnimation);
    // }

    // timerLogic(gamePlayState,actualAnimation,count,target,interval);
  }



  void startAddPerksAnimation(GamePlayState gamePlayState, String key, Map<String,dynamic> itemData) {

    try {
      const String animationType = "add-perks";
      Map<String,dynamic> animationDurationData = gamePlayState.animationLengths.firstWhere((e)=>e["type"]==animationType);
      // late int previousScore = 0;
      // late int runningScore = previousScore;

      print("""
    PERK ANIMATION":
    key: $key |
    ${itemData}
  """);

      final int numbersToIncrement = itemData["reward"] as int;
      // int increment = 1;
      int interval = animationDurationData["interval"];
      // int target = (interval/15).round()*numbersToIncrement;
      int target = animationDurationData["interval"]*animationDurationData["stops"];
      // int duration = numbersToIncrement*interval;
      int count = 0;
      // previousScore = 0;

      // newScore = previousScore + lastTurn["score"] as int;


      late List<Map<String,dynamic>> addPerksAnimations = gamePlayState.animationData.where((e)=>e["type"]==animationType).toList();

      late Map<String,dynamic> actualAnimation = {};

      late String animationKey = "add-${key}";
      Map<String,dynamic> existingAnimationObject = addPerksAnimations.firstWhere((e)=>e["key"]==animationKey,orElse:()=>{});
      List<Map<String,dynamic>> plusOneObjects = [];

      Random random = Random();
      double tileSize = gamePlayState.elementSizes["tileSize"].width;
      for (int i=0; i<numbersToIncrement; i++) {
        double randomXOffset = (random.nextDouble() * (tileSize) * -1);
        Map<String,dynamic> plusOneObject = {"key":key, "body": 1, "xOffset":randomXOffset};
        plusOneObjects.add(plusOneObject);

      }
      if (existingAnimationObject.isNotEmpty) {
        final double progress = existingAnimationObject["progress"];
        count = (progress*target).round();
        actualAnimation = existingAnimationObject;
      }  else {
        actualAnimation = {"key": animationKey, "type":animationType, "perk": key, "progress":0.0, "animation": plusOneObjects };
        gamePlayState.animationData.add(actualAnimation);
      }

      print("PLUS ONE OBJECTS: $plusOneObjects");


      timerLogic(gamePlayState,actualAnimation,count,target, interval );

    } catch (e,s) {
      debugPrint("error in **executeUndoSwapAnimation** | ${e.toString()} | $s");
    } 


    // List<Map<String,dynamic>> otherCountAnimations = gamePlayState.animationData.where((e)=>e["type"]==animationType).toList();

    // for (int i=0; i<otherCountAnimations.length;i++) {
    //   if (otherCountAnimations[i]["key"]!=key) {
    //     // remove anim
    //     int animationIndex = gamePlayState.animationData.indexOf(otherCountAnimations[i]);
    //     gamePlayState.animationData.removeAt(animationIndex);
    //   }
    // }
  
    // if (existingAnimationObject.isNotEmpty) {
    //   final double progress = existingAnimationObject["progress"];
    //   count = (progress*target).round();
    //   runningScore = previousScore + (numbersToIncrement * progress).round();
    //   actualAnimation = existingAnimationObject;   
    // }  else {
    //   // List<double> oscillatingColorData = Helpers().generateWave(numPoints: target, amplitude: 0.5, frequency: 2.0, phaseShift: 0.0);
    //   // print(oscillatingColorData);

    //   actualAnimation = {
    //     "key": key, 
    //     "type":animationType, 
    //     "progress":0.0, 
    //     "animation": {"data":itemData,"body":runningScore,"duration":duration}
    //   };
    //   gamePlayState.animationData.add(actualAnimation);
    // }

    // Timer.periodic(Duration(milliseconds: 15), (Timer timer) {
    //   if (gamePlayState.isGamePaused) {
    //     timer.cancel();      
    //   } else {
    //     // if (count == target) {
    //     if (runningScore == numbersToIncrement) {
    //       timer.cancel();
    //       final int animationObjectIndex = gamePlayState.animationData.indexOf(actualAnimation);
    //       if (animationObjectIndex>=0) {
    //         try {
    //           gamePlayState.animationData.removeAt(animationObjectIndex);
    //         } catch (e) {
    //           print("error caught in startAddPerksAnimation() => $e");
    //         }
    //       }
    //     } else {
    //       final int animationObjectIndex = gamePlayState.animationData.indexOf(actualAnimation);
    //       if (animationObjectIndex<0) {
    //         timer.cancel();
    //       } else {
    //         count++;
    //         if (count % (500/15).round()*numbersToIncrement == 0) {
    //           runningScore = runningScore + increment;
    //         }
    //         final double progress = double.parse((count/target).toStringAsFixed(2));
    //         gamePlayState.animationData[animationObjectIndex].update("progress", (v) => progress);
    //         gamePlayState.animationData[animationObjectIndex]["animation"].update("body", (v) => runningScore);
    //       }
    //     }
    //     gamePlayState.setAnimationData(gamePlayState.animationData);
    //   }
    // });

  }



  void startTutorialMessageFadeAnimation(GamePlayState gamePlayState, String key) {
    String animationType = "tutorial-message-fade";
    Map<String,dynamic> animationDurationData = gamePlayState.animationLengths.firstWhere((e)=>e["type"]==animationType);

    int target = animationDurationData["stops"];
    int interval = animationDurationData["interval"];
    int count = 0;

    late Map<String,dynamic> actualAnimation = {}; 
    Map<String,dynamic> existingAnimationObject = gamePlayState.animationData.firstWhere(
      (e)=>e["type"]==animationType && e["key"]==key,
      orElse:()=>{}
    );

    if (existingAnimationObject.isNotEmpty) {
      final double progress = existingAnimationObject["progress"];
      count = (progress*target).round();
      actualAnimation = existingAnimationObject;      
    }  else {
      actualAnimation = {"key": key, "type":animationType, "progress":0.0, "animation": {} };
      gamePlayState.animationData.add(actualAnimation);
    }

    timerLogic(gamePlayState,actualAnimation,count,target,interval);

  }

  void timerLogic2(GamePlayState gamePlayState, Map<String,dynamic> actualAnimation, int count, int target, int durationMs, Function onEnd) {
    Timer.periodic(Duration(milliseconds: durationMs), (Timer timer) {
      if (gamePlayState.isGamePaused) {
        timer.cancel();      
      } else {
        if (count == target) {
          timer.cancel();
          final int animationObjectIndex = gamePlayState.animationData.indexOf(actualAnimation);
          if (animationObjectIndex>=0) {
            try {
              gamePlayState.animationData.removeAt(animationObjectIndex);
              onEnd();
            } catch (e) {
              print("error caught in animation() => $e");
            }
          }
        } else {
          final int animationObjectIndex = gamePlayState.animationData.indexOf(actualAnimation);
          if (animationObjectIndex<0) {
            timer.cancel();
          } else {
            count++;
            final double progress = double.parse((count/target).toStringAsFixed(2));
            gamePlayState.animationData[animationObjectIndex].update("progress", (v) => progress);
          }
        }
        gamePlayState.setAnimationData(gamePlayState.animationData);
      }
    });
  }



  void timerLogic(GamePlayState gamePlayState, Map<String,dynamic> actualAnimation, int count, int target, int durationMs) {
    Timer.periodic(Duration(milliseconds: durationMs), (Timer timer) {
      if (gamePlayState.isGamePaused) {
        timer.cancel();      
      } else {
        if (count == target) {
          timer.cancel();
          final int animationObjectIndex = gamePlayState.animationData.indexOf(actualAnimation);
          if (animationObjectIndex>=0) {
            try {
              gamePlayState.animationData.removeAt(animationObjectIndex);
            } catch (e) {
              print("error caught in animation() => $e");
            }
          }
        } else {
          final int animationObjectIndex = gamePlayState.animationData.indexOf(actualAnimation);
          if (animationObjectIndex<0) {
            timer.cancel();
          } else {
            count++;
            final double progress = double.parse((count/target).toStringAsFixed(2));
            gamePlayState.animationData[animationObjectIndex].update("progress", (v) => progress);
          }
        }
        gamePlayState.setAnimationData(gamePlayState.animationData);
      }
    });
  }



  void startGameOverScreenCountAnimation(GamePlayState gamePlayState) {
    
    const String animationType = "game-over-count";
    // Map<String,dynamic> animationDurationData = gamePlayState.animationLengths.firstWhere((e)=>e["type"]==animationType);


    int scored = Helpers().calculateScore(gamePlayState);

    late bool shouldRemoveAnimation = false;

    late int scoreBody = 0;
    late double progress = 0.0;
    late int target = 0;
    late int increment = 0;
    late int interval = 0;
    late int animationDuration = 0;
    late double highlightAnimationProgress1 = 0.0;
    late double highlightAnimationProgress2 = 0.0;

    int count = 0;

    if (scored > 0) {
      Map<String,dynamic> animationProperties = AnimationUtils().getScoreCountAnimationDuration(scored,600,2000);
      target = animationProperties["target"];
      increment = animationProperties["increment"];
      interval = animationProperties["interval"];
      animationDuration =  animationProperties["duration"];
    }   

    late Map<String,dynamic> actualAnimation = {}; 
    Map<String,dynamic> existingAnimationObject = gamePlayState.animationData.firstWhere(
      (e)=>e["type"]==animationType,
      orElse:()=>{}
    );

    if (existingAnimationObject.isNotEmpty) {
      final double progress = existingAnimationObject["progress"];
      count = (progress*target).round();
      actualAnimation = existingAnimationObject;      
    }  else {
      actualAnimation = {
        "key": "game-over-count", 
        "type":animationType, 
        "progress":0.0, 
        "scoreBody":scoreBody, 
        "highlight1":highlightAnimationProgress1,
        "highlight2": highlightAnimationProgress2,
        "duration": animationDuration,
      };
      if (scored>0) {
        gamePlayState.animationData.add(actualAnimation);
      }
    }


    void startHighlightAnimation2() {
      int count = 0;
      int target = 40;
      Timer.periodic(Duration(milliseconds: 17), (Timer t) {
        if (count == target) {
          t.cancel();
          shouldRemoveAnimation = true;
        } else {
          final int animationObjectIndex = gamePlayState.animationData.indexOf(actualAnimation);
          if (animationObjectIndex<0) {
            t.cancel();
          } else {
            count++;
            highlightAnimationProgress2 = double.parse((count/target).toStringAsFixed(2));
            gamePlayState.animationData[animationObjectIndex].update("highlight2", (v) => highlightAnimationProgress2);
          }            
        }
        gamePlayState.setAnimationData(gamePlayState.animationData);
      });
    }

    void startHighlightAnimation1() {
      int count = 0;
      int target = 40;
      Timer.periodic(Duration(milliseconds: 17), (Timer t) {
        if (count == target) {
          t.cancel();
        } else {
          if (count == (target/3).round()) {
            startHighlightAnimation2();
          }

          final int animationObjectIndex = gamePlayState.animationData.indexOf(actualAnimation);
          if (animationObjectIndex<0) {
            t.cancel();
          } else {
            count++;
            highlightAnimationProgress1 = double.parse((count/target).toStringAsFixed(2));
            gamePlayState.animationData[animationObjectIndex].update("highlight1", (v) => highlightAnimationProgress1);
          }           
        }
        gamePlayState.setAnimationData(gamePlayState.animationData);
      });
    }    




    // void startTimer() {
    Timer.periodic(Duration(milliseconds: interval), (Timer t) {
      if (scoreBody>=target*increment) {
        t.cancel();
        startHighlightAnimation1();
        if (shouldRemoveAnimation) {
          final int animationObjectIndex = gamePlayState.animationData.indexOf(actualAnimation);
          if (animationObjectIndex>=0) {
            try {
              gamePlayState.animationData.removeAt(animationObjectIndex);
            } catch (e) {
              print("error caught in animation() => $e");
            }
          }                
        }
      } else {

        final int animationObjectIndex = gamePlayState.animationData.indexOf(actualAnimation);
        if (animationObjectIndex<0) {
          t.cancel();
        } else {
          scoreBody = scoreBody + increment;
          progress = double.parse((scoreBody/(target*increment)).toStringAsFixed(2));
          gamePlayState.animationData[animationObjectIndex].update("progress", (v) => progress);
          gamePlayState.animationData[animationObjectIndex].update("scoreBody", (v) => scoreBody);
        }        
      }
      gamePlayState.setAnimationData(gamePlayState.animationData);
    });
    // }



   




  }
 





}

