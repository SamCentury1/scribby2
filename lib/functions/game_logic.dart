import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/audio/audio_controller.dart';
import 'package:scribby_flutter_v2/audio/audio_service.dart';
import 'package:scribby_flutter_v2/audio/sounds.dart';
import 'package:scribby_flutter_v2/functions/animation_utils.dart';
import 'package:scribby_flutter_v2/functions/animations.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/functions/styling_utils.dart';
import 'package:scribby_flutter_v2/providers/ad_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
import 'package:scribby_flutter_v2/screens/game_over_screen/game_over_screen.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';

class GameLogic extends ChangeNotifier {

  void executeMove(
    BuildContext context, 
    PointerUpEvent details, 
    GamePlayState gamePlayState, 
    ColorPalette palette, 
    Map<String,dynamic> pointedElement, 
    AudioController audioController) {


    late Map<String,dynamic> moveData = {};
    if (gamePlayState.draggedElementData != null) {
      print("dragged element data: ${gamePlayState.draggedElementData}");
      moveData = {"type":"dropped","data":{"target":pointedElement,"source":gamePlayState.draggedElementData}};
      executeTileDroppedLogic(gamePlayState,pointedElement,details);
    } else {
      print("@@@@@ tile is tapped");
      executeTileTappedLogic(gamePlayState,pointedElement,palette);
      moveData = {"type":"placed","data":{"target":pointedElement,"source":null}};
    }

    audioController.playSfx(SfxType.tileTap);

    
    // now check if words have been found
    executeFoundWordLogic(gamePlayState,palette, moveData, context, audioController);

    // check if the user should level up
    checkLevelUp(gamePlayState);

    // check if the tile tapped was the last one and if no words were found then it's game over!
    checkGameOver(gamePlayState,context);

    executeTutorialStep(gamePlayState,context);


    // Helpers().closeTileMenu(gamePlayState);   
  }


  void getElementTappedDown( GamePlayState gamePlayState, PointerDownEvent details) {
    Offset location = details.localPosition;

    Map<String,dynamic> tappedElement = Helpers().getPointerElement(gamePlayState,location);

    if (tappedElement.isEmpty && !gamePlayState.isPointerDown) {
      gamePlayState.setTappedDownElement(null);
    } else {
      gamePlayState.setTappedDownElement(tappedElement);
    }

  }


  void generateNewRandomLetter(GamePlayState gamePlayState,ColorPalette palette) {

    Random random = Random();
    String newLetter = "";

    try {
      if (gamePlayState.isTutorial) {
        int turn = gamePlayState.tutorialData["currentTurn"];
        List<Map<String,dynamic>> steps = gamePlayState.tutorialData["steps"];
        Map<String,dynamic> tutorialStep = steps.firstWhere((e)=>e["step"]==turn,orElse: ()=>{});
        if (tutorialStep.isNotEmpty) {
          newLetter = tutorialStep["newLetter"];
        }
      } else {

        List<Map<String,dynamic>> alphabetReal = gamePlayState.alphabet;
        String letterType = Helpers().getNextLetterType(alphabetReal);

        // print("letter type: $letterType");


        String previousLetter = gamePlayState.randomLetterData.last["body"];
        List<String> availableLetters = [];
        List<Map<String,dynamic>> availableLetterObjects = [];
        
        // List<String> availableVowels = [];
        // List<String> availableConsonents = [];
        // List<String> randomLetterHistory = gamePlayState.randomLetterData.map((e)=>e["body"] as String).toList().reversed.toList();
        // List<String> reversedOrder = randomLetterHistory.reversed.toList();
        // randomLetterHistory.reversed;
        // print(randomLetterHistory);
        // List<Map<String,dynamic>> probabilityObjects = [];
        // for (int i=0; i<alphabetReal.length; i++) {
        //   Map<String,dynamic> letterObject = alphabetReal[i];
        //   int turnsAgo = randomLetterHistory.indexOf(letterObject['letter']);

        //   Map<String,dynamic> letterObject2 = Map<String,dynamic>.from(letterObject);
        //   letterObject2['turnsAgo'] = turnsAgo < 0 ? randomLetterHistory.length : turnsAgo;
        //   probabilityObjects.add(letterObject2);

        //   // print("letter: ${letterObject['letter']} | index: ${letterIndex}");
        // }
        for (Map<String, dynamic> randomLetterObject in alphabetReal) {
          
          // int turnsAgo = randomLetterHistory.indexOf(randomLetterObject['letter']);
          // int countOtherLetters = probabilityObjects
          //     .where((e) => e["type"] == letterType)
          //     .map<int>((e) => e["count"] as int)
          //     .fold(0, (prev, element) => prev + element);

          // int sumOtherTurnsAgo = probabilityObjects
          //     .where((e) => e["type"] == letterType)
          //     .map<int>((e) => e["turnsAgo"] as int)
          //     .fold(0, (prev, element) => prev + element);

          
          // print("letter: ${randomLetterObject['letter']} | last picked: ${turnsAgo} | count: ${randomLetterObject['count']} total: $countOtherLetters | turnsAgo: ${randomLetterObject['turnsAgo']} | $sumOtherTurnsAgo");


          // double prob = randomLetterObject['count'] / countOtherLetters;
          // double turnsAgoProb = randomLetterObject['turnsAgo']/sumOtherTurnsAgo;
          // print("prob: $prob");

          // final int adjustedCount = (prob * 10).round() * (turnsAgoProb *100).round();

          // print("letter: ${randomLetterObject['letter']} | countProb: $prob | turnsAgoProb | $turnsAgoProb | $adjustedCount");

          
          // if (randomLetterObject["type"] == letterType && randomLetterObject["letter"] != previousLetter && randomLetterObject['count']>0) {
          //   // Map<String,dynamic> availableLetterObjectCopy = Map<String,dynamic>.from(randomLetterObject);
          //   // availableLetterObjectCopy['probability'] = 
          //   // availableLetterObjects.add(randomLetterObject);
          //   print(randomLetterObject);
          //   availableLetters.add(randomLetterObject["letter"]);
          // }
          if (randomLetterObject['count']>0) {
            for (var i = 0; i < randomLetterObject["count"]; i++) {
            // for (var i = 0; i < adjustedCount; i++) {
              if (randomLetterObject["type"] == letterType && randomLetterObject["letter"] != previousLetter) {
                availableLetters.add(randomLetterObject["letter"]);
              }
            }
          }
        }
        // print("available letters: $availableLetters");

        int availableLettersCount = availableLetters.length;
        print("available letters: $availableLetters");
        int randomIndex = random.nextInt(availableLettersCount);
        String randomLetter = availableLetters[randomIndex];

        List<Map<String, dynamic>> newRandomLetterState = [];
        for (Map<String, dynamic> randomLetterObject in alphabetReal) {
          if (randomLetterObject["letter"] == randomLetter) {
            randomLetterObject.update("count", (value) => randomLetterObject["count"] - 1);
            randomLetterObject.update("inPlay", (value) => randomLetterObject["inPlay"] + 1);
          }
          newRandomLetterState.add(randomLetterObject);
        }
        // List<String> alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",];
        // List<String> alphabet = ["A","A","A","A","A","A","B","B","B","B","B","B","B","B","B",];
        // int randomIndex = random.nextInt(alphabet.length);    
        // newLetter = alphabet[randomIndex];
        newLetter = randomLetter;
      }
      Map<String,dynamic> decorationObject = StylingUtils().generateNewTileStyle(gamePlayState,random);
      decorationObject["gradientOffset"] = random.nextInt(4);
      Map<String,dynamic> randomLetterObject = {"body":newLetter,"decorationData": decorationObject};
      gamePlayState.setRandomLetterData([ ...gamePlayState.randomLetterData,randomLetterObject]);      
      updateDecorationData(gamePlayState,random,palette);
    } catch (e,t) {
      debugPrint("""
        error running generateNewRandomLetter
        error: $e
        stacktrace: $t
      """);
    }
    

  }

  void executeUndoSwapAnimation(GamePlayState gamePlayState, Map<String,dynamic> previousTurn) {
    try {

      Map<String,dynamic> sourceTile = previousTurn["moveData"]["data"]["source"];
      Map<String,dynamic> targetTile = previousTurn["moveData"]["data"]["target"];
      int turn = previousTurn["turn"]; //gamePlayState.scoreSummary.last["turn"];

      gamePlayState.highlightEffectTimer.cancel();

      int sourceTileKey = sourceTile["key"];
      int targetTileKey = targetTile["key"];

      Map<String,dynamic> sourceTileObject = gamePlayState.tileData.firstWhere((e)=>e["key"]==sourceTileKey,orElse: ()=>{});
      Map<String,dynamic> targetTileObject = gamePlayState.tileData.firstWhere((e)=>e["key"]==targetTileKey,orElse: ()=>{});

      if (sourceTileObject.isNotEmpty && targetTileObject.isNotEmpty) {
        String sourceTileBody = sourceTile["body"];
        String targetTileBody = targetTile["body"];

        Map<String,dynamic> sourceTileDecoration = sourceTileObject["decorationData"];
        Map<String,dynamic> targetTileDecoration = targetTileObject["decorationData"];

        sourceTileObject.update("body", (v)=>sourceTileBody);
        targetTileObject.update("body", (v)=>targetTileBody);

        sourceTileObject.update("decorationData", (v)=>targetTileDecoration);
        targetTileObject.update("decorationData", (v)=>sourceTileDecoration);    

      }    

      // String sourceTileBody = sourceTile["body"];
      // String targetTileBody = targetTile["body"];

      // bool sourceTileActive = sourceTile["active"];
      // bool targetTileActive = targetTile["active"];

      // Map<String,dynamic> sourceTileDecoration = sourceTile["decorationData"];
      // Map<String,dynamic> targetTileDecoration = targetTile["decorationData"];

      // sourceTile.update("body", (v)=>sourceTileBody);
      // targetTile.update("body", (v)=>targetTileBody);

      // sourceTile.update("active", (v)=>targetTileActive);
      // targetTile.update("active", (v)=>sourceTileActive);  

      // sourceTile.update("decorationData", (v)=>targetTileDecoration);
      // targetTile.update("decorationData", (v)=>sourceTileDecoration);    

      // sourceTile.update("source", (v)=>false);



      Animations().startTileSwapAnimation(gamePlayState,turn,sourceTileKey,targetTileKey);
      Animations().startTileSwapAnimation(gamePlayState,turn,targetTileKey,sourceTileKey);

      // Map<String,dynamic> moveData = {
      //   "type": "swap",
      //   "data": {
      //     "source": {"key":sourceTileKey,"body":sourceTileBody,"center":sourceTile["center"]},
      //     "target": {"key":targetTileKey,"body":tappedTileBody,"center":targetTile["center"]}
      //   }
      // };

      // chargeMenuItem(gamePlayState,"undo",-1);
      restartTimer(gamePlayState,"tile-swap"); 
      // executeFoundWordLogic(gamePlayState,palette, moveData);
      // executeTutorialStep(gamePlayState,context);
    // }
      gamePlayState.setTileData(gamePlayState.tileData);
    } catch (e,s) {
      debugPrint("error in **executeUndoSwapAnimation** | ${e.toString()} | $s");
    } 
  
  }

  void executeSwap(GamePlayState gamePlayState, ColorPalette palette, BuildContext context, Map<String,dynamic> pointedElement, AudioController audioController) {
    Map<String,dynamic> swappingTile = Helpers().getSwappingTile(gamePlayState);
    int turn = gamePlayState.scoreSummary.last["turn"];
    bool pointedElementFrozen = pointedElement["frozen"];
    bool pointedElementActive = pointedElement["active"];

    // Helpers().restartTimer(gamePlayState);    
    
    if (swappingTile.isNotEmpty && !pointedElementFrozen && pointedElementActive && swappingTile["key"] != pointedElement["key"]) {

      gamePlayState.highlightEffectTimer.cancel();

      int swappingTileKey = swappingTile["key"];
      int tappedTileKey = pointedElement["key"];

      String swappingTileBody = swappingTile["body"];
      String tappedTileBody = pointedElement["body"];

      bool swappingTileActive = swappingTile["active"];
      bool tappedTileActive = pointedElement["active"];

      Map<String,dynamic> swappingTileDecoration = swappingTile["decorationData"];
      Map<String,dynamic> tappedTileDecoration = pointedElement["decorationData"];

      swappingTile.update("body", (v)=>tappedTileBody);
      pointedElement.update("body", (v)=>swappingTileBody);

      swappingTile.update("active", (v)=>tappedTileActive);
      pointedElement.update("active", (v)=>swappingTileActive);  

      swappingTile.update("decorationData", (v)=>tappedTileDecoration);
      pointedElement.update("decorationData", (v)=>swappingTileDecoration);    

      swappingTile.update("swapping", (v)=>false);

      print("just finished swapping");

      Animations().startTileSwapAnimation(gamePlayState,turn,swappingTileKey,tappedTileKey);
      Animations().startTileSwapAnimation(gamePlayState,turn,tappedTileKey,swappingTileKey);

      Map<String,dynamic> moveData = {
        "type": "swap",
        "data": {
          "source": {"key":swappingTileKey,"body":swappingTileBody,"center":swappingTile["center"]},
          "target": {"key":tappedTileKey,"body":tappedTileBody,"center":pointedElement["center"]}
        }
      };



      chargeMenuItem(gamePlayState,"swap",-1);
      restartTimer(gamePlayState,"tile-swap"); 
      executeFoundWordLogic(gamePlayState,palette, moveData, context, audioController);
      executeTutorialStep(gamePlayState,context);
    }
    gamePlayState.setTileData(gamePlayState.tileData);
  }

  // when a perk is selected on the bar - if it's the und button - do that. 
  // else, highlight the available tiles for a perk
  void executePerkSelectedBehaviour(BuildContext context, GamePlayState gamePlayState) {
    try {
      Map<String,dynamic> selectedPerkObject = gamePlayState.tileMenuOptions.firstWhere((e)=>e["open"]==true,orElse: ()=>{});
      if (selectedPerkObject.isNotEmpty) {
        print(" SELECTED PERK OBJECT: ${selectedPerkObject} ");



        String perkType = selectedPerkObject["item"];
        int perkCount = selectedPerkObject["count"];

        if (perkCount<=0) {
          print("do not start highlight effect");
          
          // gamePlayState.highlightEffectTimer.cancel();
          openTileMenuBuyMoreModal(gamePlayState,selectedPerkObject);
          cancelPerk(gamePlayState);
        } else {
          if (perkType == "undo") {
            // undo function
            print("perkCount: ${perkCount}",);
            executeUndoPerk(gamePlayState);
            if (gamePlayState.isTutorial) {
              executeTutorialStep(gamePlayState,context);
            }

          } else {
            // highlight all cells that can be selected
            
            gamePlayState.startHighlightEffectTimer();
            

          }
        }
      }
    } catch (e, s) {
      print("ERROR IN **executePerkSelectedBehaviour** | ${e.toString()} | $s");
    }
  }

  void executePerk(BuildContext context, GamePlayState gamePlayState, ColorPalette palette, int tileKey, AudioController audioController) {
    
    Map<String,dynamic> selectedTileObject = gamePlayState.tileData.firstWhere((e)=>e["key"]==tileKey,orElse: ()=>{});
    Map<String,dynamic> perkOpen = gamePlayState.tileMenuOptions.firstWhere((e)=>e["open"]==true,orElse: ()=>{});
    if (perkOpen.isNotEmpty && selectedTileObject.isNotEmpty) {
      print("perk: ${perkOpen} | ");
      String perk = perkOpen["item"];
      if (perk == "explode") {

        // logic that would prevent a tutorial tile to be exploded
        bool preventExplosion = false;
        if (gamePlayState.isTutorial) {
          Map<String,dynamic> tutorialStep = Helpers().getTutorialStepObject(gamePlayState);
          if (tutorialStep["focusTile"] != tileKey) {
            preventExplosion = true;
          }
        }
        if (selectedTileObject["body"]==""&&selectedTileObject["active"]) {
          preventExplosion = true;
        }

        if (preventExplosion) {
          cancelPerk(gamePlayState);
        } else {
          
          Animations().startTileExplodeAnimation(gamePlayState,tileKey,);
          // audioController.playSfx(SfxType.glassBreak,settingsState);
          // context.read<AudioController>().playSfx(SfxType.glassBreak);
          // audioController.playSfx(SfxType.glassBreak);
          context.read<AudioService>().play("assets/audio/sfx/glass_break_1.wav");

          restartTimer(gamePlayState,"tile-explode");
          String explodedTileBody =selectedTileObject["body"];
          Map<String,dynamic> alphabetObject = gamePlayState.alphabet.firstWhere((e)=>e["letter"]==explodedTileBody,orElse: ()=>{});
          if (alphabetObject.isNotEmpty) {
            alphabetObject.update("count", (v)=>v+1);
            alphabetObject.update("inPlay", (v)=>v-1);
          }

          selectedTileObject.update("body", (v) => "");
          selectedTileObject.update("active", (v) => true);
          selectedTileObject.update("frozen", (v)=> false);
          executeTutorialStep(gamePlayState,context);
          chargeMenuItem(gamePlayState,perk,-1);       
          perkOpen.update("open", (v)=>false);
          gamePlayState.highlightEffectTimer.cancel();
          Map<String,dynamic> moveData = {
            "type": "explode",
            "data": {"target":selectedTileObject,"body":explodedTileBody}
          };
          executeFoundWordLogic(gamePlayState, palette, moveData, context, audioController);
        }
      } else if (perk=="freeze") {

        bool preventFreeze = false;
        if (gamePlayState.isTutorial) {
          Map<String,dynamic> tutorialStep = Helpers().getTutorialStepObject(gamePlayState);
          if (tutorialStep["focusTile"] != tileKey) {
            preventFreeze = true;
          }
        }
        if (selectedTileObject["body"]==""&&selectedTileObject["active"]) {
          preventFreeze = true;
        }        
        if (preventFreeze) {
          cancelPerk(gamePlayState);
        } else {        
          Animations().startTileFreezeAnimation(gamePlayState,tileKey);
          Map<String,dynamic> moveData = {};
          if (selectedTileObject["frozen"]) {
            selectedTileObject.update("frozen", (v) => false);
            moveData = {
              "type":"freeze",
              "data": {"target":selectedTileObject,"thaw":true}
            };
            // executeFoundWordLogic(gamePlayState,palette, moveData);
          } else {
            selectedTileObject.update("frozen", (v) => true);
            moveData = {
              "type":"freeze",
              "data": {"target":selectedTileObject,"thaw":false}
            };            
            chargeMenuItem(gamePlayState,"freeze",-1);           
          }
          executeFoundWordLogic(gamePlayState, palette, moveData, context, audioController);
          executeTutorialStep(gamePlayState,context);  
          restartTimer(gamePlayState,"tile-freeze");  
          perkOpen.update("open", (v)=>false);
          gamePlayState.highlightEffectTimer.cancel();   
        }        
      } else if (perk == "swap") {
        // print("selected swap. is source tile selected?");
        Map<String,dynamic> swappingTileObject = gamePlayState.tileData.firstWhere((e)=>e["swapping"]==true,orElse: ()=>{});

        bool preventSwap = false;
        if (gamePlayState.isTutorial) {
          Map<String,dynamic> tutorialStep = Helpers().getTutorialStepObject(gamePlayState);
          if (tutorialStep["focusTile"] != tileKey || tutorialStep["targetKey"] != tileKey) {
            preventSwap = true;
          }
        }
        if (selectedTileObject["body"]==""&&selectedTileObject["active"]) {
          preventSwap = true;
        }  

        if (selectedTileObject["body"]!=""&&selectedTileObject["active"]) {
          if (swappingTileObject.isEmpty) {
            // print("source tile NOT selected => selected : ${selectedTileObject["key"]}");
            selectedTileObject.update("swapping", (v) => true);
            executeTutorialStep(gamePlayState,context);
          } else {
            if (swappingTileObject["key"]!=tileKey) {
              // print("source tile is selected as ${swappingTileObject["key"]} - target tile selected as ${tileKey}");
              executeSwap(gamePlayState, palette, context, selectedTileObject, audioController);
              
            } else {
              // cancelSwap(gamePlayState);
              cancelPerk(gamePlayState);
              cancelSwap(gamePlayState);
            }
            // cancelPerk(gamePlayState);
            perkOpen.update("open", (v)=>false);
          }
        } else {
          cancelPerk(gamePlayState);
          cancelSwap(gamePlayState);
        }


      }
    } else {
      
      cancelPerk(gamePlayState);
    }

  }

  void executeUndoPerk(GamePlayState gamePlayState) {
    // get the previous turn state

    try {
      if (gamePlayState.scoreSummary.isNotEmpty) {
        Map<String,dynamic> previousTurnData = gamePlayState.scoreSummary.last;


        List<String> randomLetters = [];
        for (int i=0; i<gamePlayState.randomLetterData.length; i++) {
          randomLetters.add(gamePlayState.randomLetterData[i]["body"]);
        }

        previousTurnData.forEach((key,value) {
          print("$key | $value");
        });
        print("""
        ================ LAST TURN =====================
        ${previousTurnData}
        {randomLetters}
        ================================================

        """);

        String moveType = previousTurnData["moveData"]["type"];
        if (moveType=="swap") {
          print("hello ?? swap???: $previousTurnData");
          Map<String,dynamic> sourceTile = previousTurnData["moveData"]["data"]["source"];
          Map<String,dynamic> targetTile = previousTurnData["moveData"]["data"]["target"];
          
          if (previousTurnData["score"]>0) {
            for (int i=0;i<previousTurnData["ids"].length; i++) {
              int tileKey = previousTurnData["ids"][i]["id"];
              String tileBody = previousTurnData["ids"][i]["body"];
              Map<String,dynamic> targetTile = gamePlayState.tileData.firstWhere((e)=>e["key"]==tileKey,orElse: ()=>{});
              targetTile.update("body",(v)=> tileBody);
            }
            Animations().startUndoAnimation(gamePlayState,previousTurnData["turn"]);
          } 

          if (previousTurnData["score"]==0) {
            executeUndoSwapAnimation(gamePlayState, previousTurnData);
          }

          Map<String,dynamic> sourceTileObject = gamePlayState.tileData.firstWhere((e)=>e["key"]==sourceTile["key"],orElse:()=>{});
          Map<String,dynamic> targetTileObject = gamePlayState.tileData.firstWhere((e)=>e["key"]==targetTile["key"],orElse:()=>{});
          
          if (sourceTileObject.isNotEmpty && targetTileObject.isNotEmpty) {

            String sourceBody = sourceTile["body"];
            String targetBody = targetTile["body"];
            sourceTileObject.update("body", (v) => sourceBody);
            targetTileObject.update("body", (v) => targetBody);
          }
        
          chargeMenuItem(gamePlayState, "swap", 1);
          chargeMenuItem(gamePlayState, "undo", -1);
          
        } else if (moveType=="freeze") {
          Map<String,dynamic> frozenTileObject = previousTurnData["moveData"]["data"]["target"];
          bool thaw = previousTurnData["moveData"]["data"]["thaw"];
          Map<String,dynamic> tileObject = gamePlayState.tileData.firstWhere((e)=>e["key"]==frozenTileObject["key"],orElse:()=>{});
          if (previousTurnData["score"]>0) {
            for (int i=0;i<previousTurnData["ids"].length; i++) {
              int tileKey = previousTurnData["ids"][i]["id"];
              String tileBody = previousTurnData["ids"][i]["body"];
              Map<String,dynamic> targetTile = gamePlayState.tileData.firstWhere((e)=>e["key"]==tileKey,orElse: ()=>{});
              targetTile.update("body",(v)=> tileBody);
              if (tileKey==frozenTileObject["key"]) {
                targetTile.update("frozen", (v)=>true);
              }
            }
          } else {
            if (tileObject.isNotEmpty) {
              tileObject.update("frozen", (v)=>thaw);
            }
          }
          Animations().startUndoAnimation(gamePlayState,previousTurnData["turn"]);
          if (!tileObject["frozen"]) {
            chargeMenuItem(gamePlayState, "freeze", 1);
          }
          
        } else if (moveType=="explode") {
          Map<String,dynamic> explodedTileObject = previousTurnData["moveData"]["data"]["target"];
          String body = previousTurnData["moveData"]["data"]["body"];
          Map<String,dynamic> tileObject = gamePlayState.tileData.firstWhere((e)=>e["key"]==explodedTileObject["key"],orElse:()=>{});
          if (tileObject.isNotEmpty) {
            tileObject.update("body", (v)=>body);
          }
          print("yo execute this shit");
          Animations().startUndoAnimation(gamePlayState,previousTurnData["turn"]);
          chargeMenuItem(gamePlayState, "explode", 1);
        } else if (moveType=="placed") {
          String tileType = previousTurnData["moveData"]["data"]["target"]["type"];
          int tilePlacedId = previousTurnData["moveData"]["data"]["target"]["key"];
          Map<String,dynamic> tileObject = {};
          if (tileType == "board") {
            tileObject = gamePlayState.tileData.firstWhere((e)=>e["key"]==tilePlacedId,orElse:()=>{});
          } else if (tileType=="reserve") {
            tileObject = gamePlayState.reserveTileData.firstWhere((e)=>e["key"]==tilePlacedId,orElse:()=>{});
          }
          if (tileObject.isNotEmpty) {
            if (previousTurnData["score"]>0) {
              for (int i=0;i<previousTurnData["ids"].length; i++) {
                int tileKey = previousTurnData["ids"][i]["id"];
                String tileBody = previousTurnData["ids"][i]["body"];
                Map<String,dynamic> targetTile = gamePlayState.tileData.firstWhere((e)=>e["key"]==tileKey,orElse: ()=>{});
                targetTile.update("body",(v)=> tileBody);
              }
            } 
            Animations().startUndoAnimation(gamePlayState,previousTurnData["turn"]);
            if (tileObject.isNotEmpty) {
              tileObject.update("body", (v) => "");
            }
            chargeMenuItem(gamePlayState, "undo", -1);
            int lastLetterIndex = gamePlayState.randomLetterData.indexOf(gamePlayState.randomLetterData.last);
            gamePlayState.randomLetterData.removeAt(lastLetterIndex);        
          }
        } else if (moveType=="dropped") {
          // String tileType = previousTurnData["moveData"]["data"]["type"];
          print("IN EXECUTE UNDO PERK: => move data = : ${previousTurnData["moveData"]}");
          int tilePlacedId = previousTurnData["moveData"]["data"]["target"]["key"];
          Map<String,dynamic> tileObject = gamePlayState.tileData.firstWhere((e)=>e["key"]==tilePlacedId,orElse:()=>{});


          int sourceTileId = previousTurnData["moveData"]["data"]["source"]["key"];
          Map<String,dynamic> reserveTileObject = gamePlayState.reserveTileData.firstWhere((e)=>e["key"]==sourceTileId,orElse:()=>{});
          if (tileObject.isNotEmpty) {
            String tileBody = tileObject["body"];


    
            if (previousTurnData["score"]>0) {
              for (int i=0;i<previousTurnData["ids"].length; i++) {
                int tileKey = previousTurnData["ids"][i]["id"];
                String tileBody = previousTurnData["ids"][i]["body"];
                Map<String,dynamic> targetTile = gamePlayState.tileData.firstWhere((e)=>e["key"]==tileKey,orElse: ()=>{});
                if (reserveTileObject.isNotEmpty) {
                  if (tileKey == tilePlacedId) {
                    targetTile = reserveTileObject;
                  }
                }
                targetTile.update("body",(v)=> tileBody);
              }
            } else {
              if (reserveTileObject.isNotEmpty) {
                print("re populate the reserve tile with body: $tileBody");
                print("reserveTileObject: $reserveTileObject");
                reserveTileObject.update("body", (v) => tileBody);
              }   
            }


            Animations().startUndoAnimation(gamePlayState,previousTurnData["turn"]);

            tileObject.update("body", (v) => "");
            


            chargeMenuItem(gamePlayState, "undo", -1);
     
          }
        
        }
        int lastTurnIndex = gamePlayState.scoreSummary.indexOf(previousTurnData);
        gamePlayState.scoreSummary.removeAt(lastTurnIndex);        
        Map<String,dynamic> undoObject = gamePlayState.tileMenuOptions.firstWhere((e)=>e["item"]=="undo",orElse: ()=>{});
        undoObject.update("open", (v) => false);
        undoObject.update("selected", (v) => false);
      } else {
        print("cancel the perk!!");
        cancelPerk(gamePlayState);
      }
    } catch (e, s) {
      print("ERROR IN **executeUndoPerk** | ${e.toString()} | $s");
    }
  }


  // void executeOpenTileMenu(GamePlayState gamePlayState, Map<String,dynamic> pointedTile) {
  //   int key = pointedTile["key"];
  //   Map<String,dynamic> openMenuTile = gamePlayState.tileData.firstWhere((e)=>e["key"]==key,orElse: ()=>{});
  //   print("executeOpenTileMenu : $openMenuTile");
  //   if (openMenuTile.isNotEmpty) {
  //     openMenuTile.update("menuOpen", (v)=> true);
  //     if (openMenuTile["active"]) {

  //       if (openMenuTile["frozen"]) {
  //         openMenuTile.update("menuData", (v) => getOpenMenuTileData(gamePlayState,["freeze"]));          
  //       } else {
  //         openMenuTile.update("menuData", (v) => getOpenMenuTileData(gamePlayState,["swap","explode","freeze"])   
  //         );
  //       } 

  //     } else {
  //       openMenuTile.update("menuData", (v) => getOpenMenuTileData(gamePlayState,["explode"]) 
  //       );        
  //     }

  //     // if (gamePlayState.isTutorial) {
  //     //   int turn = gamePlayState.tutorialData["currentTurn"];
  //     //   gamePlayState.tutorialData.update("currentTurn", (v)=>turn+1);
  //     // }
  //   }
  //   int turn  = gamePlayState.scoreSummary.last["turn"];
  //   Animations().startTileMenuControlAnimation(gamePlayState,"${turn}_$key",turn, key, true,openMenuTile);
  //   gamePlayState.setOpenMenuTile(openMenuTile);

  //   getMenuItemPositionData(gamePlayState);
  // }

  bool getMenuItemAvailability(GamePlayState gamePlayState, String item) {
    Map<String,dynamic> menuItem = gamePlayState.tileMenuOptions.firstWhere((e)=>e["item"]==item,orElse: ()=>{});
    late bool res = false; 

    print(" getMenuItemAvailability - ${gamePlayState.tileMenuBuyMoreModalData}");
    if (menuItem.isNotEmpty) {
      if (menuItem["count"]>0) {
        res = true;
      }
    }
    return res;
  }

  List<Map<String,dynamic>> getOpenMenuTileData(GamePlayState gamePlayState, List<String> items) {
    late List<Map<String,dynamic>> res = [];
    for (int i=0; i<items.length; i++) {
      String item = items[i];
      Map<String,dynamic> option = {
        "option": item,  
        "path": null, 
        "selected":true , 
        "available":getMenuItemAvailability(gamePlayState,item)
      };
      res.add(option);
    }

    if (items.length == 1 && items.first == "freeze") {
      res = [{
        "option": items.first,  
        "path": null, 
        "selected":true , 
        "available":true
      }];     
    }
    return res;
  } 

  // void executeCloseTileMenu(GamePlayState gamePlayState) {
  //   Map<String,dynamic>? openMenuTile = gamePlayState.openMenuTile;
  //   int turn = gamePlayState.scoreSummary.last["turn"];

    
  //   if (openMenuTile != null) {
  //     print("this has been called!");
  //     var deepCopyMenuTile = Map<String,dynamic>.from(openMenuTile);
  //     int openMenuTileKey = deepCopyMenuTile["key"];
  //     Animations().startTileMenuControlAnimation(gamePlayState,"${turn}_$openMenuTileKey", turn, openMenuTileKey, false,deepCopyMenuTile);
      
  //     openMenuTile.update("menuOpen", (v)=> false);
  //     openMenuTile.update("menuData", (v)=> null);


  //     gamePlayState.startHighlightEffectTimer();
      
  //   }

  //   gamePlayState.setOpenMenuTile(null);
    
    
  // }

  // void executeOpenMenuTapRelease(GamePlayState gamePlayState, ColorPalette palette, BuildContext context, PointerEvent details,) {
  //   Map<String,dynamic>? openMenuTile = gamePlayState.openMenuTile;
  //   if (openMenuTile != null) {
      
  //     Map<String,dynamic> optionSelected = {};

  //     for (int i=0; i<openMenuTile["menuData"].length; i++) {
  //       if (openMenuTile["menuData"][i]["path"].contains(details!.localPosition)) {
  //         optionSelected = openMenuTile["menuData"][i];
  //       }
  //     }

  //     if (optionSelected.isNotEmpty) {

  //       if (optionSelected["available"]) {
  //         optionSelected.update("selected", (v) => true);

  //         if (optionSelected["option"]=="swap") {
  //           openMenuTile.update("swapping", (v) => true);
  //           executeTutorialStep(gamePlayState,context);  
  //         }

  //         if (optionSelected["option"]=="freeze") {
  //           Animations().startTileFreezeAnimation(gamePlayState,openMenuTile["key"]);
  //           if (openMenuTile["frozen"]) {
  //             openMenuTile.update("frozen", (v) => false);
  //             Map<String,dynamic> moveData = {
  //               "type":"freeze",
  //               "data": openMenuTile
  //             };
  //             executeFoundWordLogic(gamePlayState,palette, moveData);
  //           } else {
  //             openMenuTile.update("frozen", (v) => true);
  //             chargeMenuItem(gamePlayState,"freeze");           
  //           }
  //           executeTutorialStep(gamePlayState,context);  
  //           restartTimer(gamePlayState,"tile-freeze"); 
  //         }

  //         if (optionSelected["option"]=="explode") {
  //           chargeMenuItem(gamePlayState,"explode");
  //           Animations().startTileExplodeAnimation(gamePlayState,openMenuTile["key"],);
  //           restartTimer(gamePlayState,"tile-explode"); 
            
  //           openMenuTile.update("body", (v) => "");
  //           openMenuTile.update("active", (v) => true);

  //           executeTutorialStep(gamePlayState,context);        
  //         }
  //       } else {
  //         print("you do not have this perk!");
  //         openTileMenuBuyMoreModal(gamePlayState,optionSelected);
  //       }
  //     } else {

  //     }

  //     executeCloseTileMenu(gamePlayState);
      
  //   }
  // }


  void openTileMenuBuyMoreModal(GamePlayState gamePlayState, Map<String,dynamic> optionSelected) {
    print("***openTileMenuBuyMoreModal");
    try {
      gamePlayState.setIsGamePaused(true);
      print("optionSelected => $optionSelected");
      String item = optionSelected["item"];
      String menuBuyMoreMessage = Helpers().getMenuBuyMoreMessage(item);
      List<Map<String,dynamic>> options = [
        {"key":0, "reward": 5, "cost":1, "costItem":"ad"},
        {"key":1, "reward": 3, "cost": 2000, "costItem":"coins"},
        // {"key":2, "reward": 5, "cost": 10, "costItem":"ruby"},
        // {"key":3, "reward": 10, "cost": 30, "costItem":"jade"},
      ];
      gamePlayState.tileMenuBuyMoreModalData.update("tile", (v)=>null);
      gamePlayState.tileMenuBuyMoreModalData.update("open", (v)=>true);
      gamePlayState.tileMenuBuyMoreModalData.update("item", (v)=>item);
      gamePlayState.tileMenuBuyMoreModalData.update("message", (v)=>menuBuyMoreMessage);
      gamePlayState.tileMenuBuyMoreModalData.update("options", (v)=>options);

      gamePlayState.setTileMenuBuyMoreModalData(gamePlayState.tileMenuBuyMoreModalData);
      print("in the openTileMenuBuyMoreModal function: ${gamePlayState.tileMenuBuyMoreModalData}");
    } catch (e, s) {
      print("ERROR IN **openTileMenuBuyMoreModal** | ${e.toString()} | $s");
    }
  }

  void chargeMenuItem(GamePlayState gamePlayState, String type, int amount) {
    Map<String,dynamic> itemObject = gamePlayState.tileMenuOptions.firstWhere((e)=>e["item"]==type,orElse: ()=>{});
    if (itemObject.isNotEmpty) {
      int count = itemObject["count"];
      if (count > 0) {
        itemObject.update("count", (v)=>count + amount);
      }
    }
    gamePlayState.setTileMenuOptions(gamePlayState.tileMenuOptions);
  }

  /// logic that executes whether the tile is a reserve or a board
  void executeTileTappedLogic(GamePlayState gamePlayState, Map<String,dynamic> tileObject, ColorPalette palette) {

    try {
      // get the element key
      int key = tileObject["key"];
      // start by releasing the tap-down animation
      Animations().removeTapDownAnimationWhenReleased(gamePlayState,key);

      // check if the tile is already animating
      Map<String,dynamic> animationObject = gamePlayState.animationData.firstWhere((e)=>e["key"]==tileObject["key"],orElse: ()=>{});

      if (animationObject.isEmpty) {    

        // pause the stop watch element if it is part of the game parameters
        gamePlayState.pauseStopWatchTimer();

        // generate a new random letter
        generateNewRandomLetter(gamePlayState,palette);


        // get the new letter body
        String newLetter = gamePlayState.randomLetterData[gamePlayState.randomLetterData.length-3]["body"];
        // print("new letter: $newLetter");
        Map<String,dynamic> newLetterDecoration = gamePlayState.randomLetterData[gamePlayState.randomLetterData.length-3]["decorationData"];

        // update the body of the tile element
        tileObject.update("body", (v) => newLetter);
        tileObject.update("decorationData", (v) => newLetterDecoration);

        // launch the tap release animation
        Animations().startTapReleaseAnimation(gamePlayState,key);
        
        // update the gamePlayState for the 
        if (tileObject["type"]=="board") {
          gamePlayState.setTileData(gamePlayState.tileData);
        } else {
          gamePlayState.setReserveTileData(gamePlayState.reserveTileData);
        }

        restartTimer(gamePlayState,"tap-up");   
      }
    } catch (e, s) {
      print("ERROR IN **executeTileTappedLogic** | ${e.toString()} | $s");
    }
  }

  void executeTileDroppedLogic(GamePlayState gamePlayState, Map<String,dynamic> tileObject, PointerUpEvent details ) {

    // pause the stop watch element if it is part of the game parameters
    gamePlayState.pauseStopWatchTimer();
    // check if there is an animation playing on the tile we want to release on
    Map<String,dynamic> animationObject = gamePlayState.animationData.firstWhere((e)=>e["key"]==tileObject["key"],orElse: ()=>{});

    // prevent dropping in a tile that is animating
    if (animationObject.isEmpty) {

      print("executing drop");

      // get the objects of the dragged element and the destination obj
      Map<String,dynamic> draggedObject = gamePlayState.reserveTileData.firstWhere((e)=>e["key"]==gamePlayState.draggedElementData!["key"],orElse: ()=>{});


      // check that we are in a tutorial. If yes, validate the move - otherwise ignore

      if (draggedObject.isNotEmpty) {

        // get the dragged object body
        String draggedLetter = draggedObject["body"];
        Map<String,dynamic> decorationData = draggedObject["decorationData"];

        // start the tile drop animation
        Animations().startTileDroppedAnimation(gamePlayState,draggedObject["key"],tileObject["key"],details.localPosition);

        // update the bodies
        draggedObject.update("body",(v)=>"");
        
        tileObject.update("body",(v)=>draggedLetter);
        tileObject.update("decorationData", (v)=>decorationData);



        // get the tile animation duration for the delay value
        // Map<String,dynamic> animationDurationData = gamePlayState.animationLengths.firstWhere((e)=>e["type"]=="tile-drop",orElse: ()=>{});
        // Future.delayed(Duration(milliseconds: (animationDurationData["stops"]*animationDurationData["interval"])), () {
        //   gamePlayState.startStopWatch();
        // });  
        restartTimer(gamePlayState,"tile-drop");       
      }      
    }
  }

  void executeTutorialStep(GamePlayState gamePlayState,BuildContext context) {
    if (gamePlayState.isTutorial) {

      print("NNEEEEEXXXXTTTTT ---------");
      int turn = gamePlayState.tutorialData["currentTurn"];
      
      int newTurn = turn+1;

      List<Map<String,dynamic>> steps = gamePlayState.tutorialData["steps"];

      Map<String,dynamic> step = steps.firstWhere((e)=>e["step"]==turn,orElse: () => {});
      Map<String,dynamic> nextStep = steps.firstWhere((e)=>e["step"]==newTurn,orElse: () => {});

      if (step.isNotEmpty) {
        print("in execute tutorial step function. step is : ${step}");
        if (nextStep.isNotEmpty) {
          if (nextStep["shouldStartCountDown"]) {
            // gamePlayState.startCountDown();
            print("restart stopwatch timer bro");
            gamePlayState.setStopWatchLimit(6 * 1000);
            gamePlayState.startStopWatch();
          }
        }

        if (step["shouldStartCountDown"]) {
          gamePlayState.pauseStopWatchTimer();
        }

        late int delay = step["delay"];
        
        gamePlayState.highlightEffectTimer.cancel();
        Future.delayed(Duration(milliseconds: delay), () {
          gamePlayState.tutorialData.update("currentTurn", (v)=>newTurn);
          gamePlayState.setTutorialData(gamePlayState.tutorialData);
          gamePlayState.startHighlightEffectTimer();
          Animations().startTutorialMessageFadeAnimation(gamePlayState,"tutorial_message_fade");
        });


        // if (step["moveType"]=="finish") {

        //   print("message at game over => ${step["message"]}");
        //   gamePlayState.gameResultData.update("didCompleteGame", (v)=> true);
        //   gamePlayState.gameResultData.update("didAchieveObjective", (v)=> true);
        //   gamePlayState.gameResultData.update("reward", (v)=> 2000);
        //   gamePlayState.gameResultData.update("xp", (v)=> 5);
        //   executeGameOverLogic(context,gamePlayState);        
        // } 
      }
    
    }
  }

  

  void executeFoundWordLogic(GamePlayState gamePlayState, ColorPalette palette, Map<String,dynamic> moveData, BuildContext context, AudioController audioController) {

    validateStrings(gamePlayState,moveData);

    String gameType = gamePlayState.gameParameters["gameType"];
    bool isTimeToPlace = gamePlayState.gameParameters["timeToPlace"]!=null;

    if (gamePlayState.scoreSummary.last["score"]>0) {
      // checks whether it was a "tap-up" or a "drag" or something;
      String type = gamePlayState.scoreSummary.last["moveData"]["type"]; 
      
      Map<String,dynamic> animationDurationData = AnimationUtils().getAnimationDuration(gamePlayState, type);

      // gets the score from last turn
      int scoreTurn = gamePlayState.scoreSummary.last["turn"];

      Animations().startPreWordFoundAnimation(gamePlayState,palette, scoreTurn);
      // context.read<AudioController>().playSfx(SfxType.wordFound);
      audioController.playSfx(SfxType.wordFound);
      

      late  int duration = 300; // DEFAULT but ideally, this should be updated below
      if (animationDurationData.isNotEmpty) {
        duration = (animationDurationData["stops"]*animationDurationData["interval"]);
      } 


      Future.delayed(Duration(milliseconds: duration), () {
        // // animates the word tiles flashing and what not
        if (isTimeToPlace) {
          gamePlayState.startStopWatch();
        }

      });
      // clears the board of letters that were in the found word function
      updateBoardAfterFoundWord(gamePlayState: gamePlayState);
    }
    // updates the board
    updateBoardAfterFoundWord(gamePlayState: gamePlayState);     
  }


  void executeWordFoundAnimations(GamePlayState gamePlayState, ColorPalette palette, int scoreTurn) {
    // animates the word tiles flashing and what not
    Animations().startWordFoundAnimation(gamePlayState, palette, scoreTurn);
    // animates the scoreboard counting and flashing
    Animations().startScoreboardCountAnimation(gamePlayState,scoreTurn,"${scoreTurn}_count");
    // animates the little +10, +20, elements flying in and out of view next to the scoreboard (for each word)
    Animations().startScoreboardPlusNPoints(gamePlayState,scoreTurn);
    // animates 2x streak, 4x words bonus items if there are any
    Animations().startBonusAnimations(gamePlayState,scoreTurn);
    // animates the +50 text over the play area board (for the turn)
    Animations().startNewPointsScoredAnimation(gamePlayState,scoreTurn,"${scoreTurn}_new_points");    
  }


  void executePauseDialogPopScope(GamePlayState gamePlayState, ColorPalette palette) {
    for (int i=0;i<gamePlayState.animationData.length;i++) {
      String type = gamePlayState.animationData[i]["type"];
      // double progress = gamePlayState.animationData[i]["progress"];
      if (type=="tap-up") {
        int key = gamePlayState.animationData[i]["key"];
        Animations().startTapReleaseAnimation(gamePlayState,key);
      }
      if (type=="tap-cancel") {
        int key = gamePlayState.animationData[i]["key"];
        double progress = gamePlayState.animationData[i]["progress"];
        Animations().startTapCancelAnimation(gamePlayState,key,progress);
      }

      if (type=="word-found") {
        int turn = gamePlayState.animationData[i]["turn"];
        Animations().startWordFoundAnimation(gamePlayState, palette, turn);
      }

      if (type=="tile-drop") {
        Map<String,dynamic> parameters = gamePlayState.animationData[i]["parameters"];
        int sourceKey = parameters["sourceKey"];
        int targetKey = parameters["targetKey"];
        Offset dropLocation = parameters["dropLocation"];
        Animations().startTileDroppedAnimation(gamePlayState,sourceKey,targetKey,dropLocation);
      }
      if (type=="pre-word-found") {
        print("pause scope for tile ${gamePlayState.animationData[i]["key"]}");
        // int key = gamePlayState.animationData[i]["key"];
        int turn = gamePlayState.animationData[i]["turn"];
        Animations().startPreWordFoundAnimation(gamePlayState,palette, turn);        
      }

      if (type=="score-count") {
        int turn = gamePlayState.animationData[i]["turn"];
        String key = gamePlayState.animationData[i]["key"];
        Animations().startScoreboardCountAnimation(gamePlayState, turn, key);
      }

      if (type=="score-highlight") {
        Animations().startScoreboardHighlightAnimation(gamePlayState);
      }  

      if (type=="kill-tile") {
        int key = gamePlayState.animationData[i]["key"];
        Animations().startKillTileAnimation(gamePlayState,key);
      }        

      if (type=="score-points") {
        int turn = gamePlayState.animationData[i]["turn"];
        Animations().startScoreboardPlusNPoints(gamePlayState,turn);
      }  

      if (type=="new-points") {

        int turn = gamePlayState.animationData[i]["turn"];
        String key = gamePlayState.animationData[i]["key"];
        print("restart animation for this guy ${key}");
        Animations().startNewPointsScoredAnimation(gamePlayState,turn,key);
      }        

      if (type=="game-over") {
        Animations().startGameOverOverlayAnimation(gamePlayState);
      }

      if (type=="bonus") {
        int turn = gamePlayState.animationData[i]["turn"];
        Animations().startBonusAnimations(gamePlayState,turn);
      }

      if (type=="level-up") {
        Animations().startLevelUpAnimation(gamePlayState);
      }  

      if (type=="tile-menu") {
        int turn = gamePlayState.animationData[i]["turn"];
        // print("tile menu key: ${gamePlayState.animationData[i]["key"]}");
        String key = gamePlayState.animationData[i]["key"];
        bool open = gamePlayState.animationData[i]["animation"]["open"];
        Map<String,dynamic>? tile = gamePlayState.animationData[i]["animation"]["tile"];
        Animations().startTileMenuControlAnimation(gamePlayState,key,turn,tile?["key"], open,tile);
      }        

      if (type=="tile-freeze") {
        int key = gamePlayState.animationData[i]["key"];
        Animations().startTileFreezeAnimation(gamePlayState,key);
      }   

      if (type=="tile-swap") {
        int turn = gamePlayState.animationData[i]["turn"];
        int key = gamePlayState.animationData[i]["key"];
        int targetKey = gamePlayState.animationData[i]["targetKey"];
        Animations().startTileSwapAnimation(gamePlayState,turn,key,targetKey);
      }   

      if (type=="tile-explode") {
        int key = gamePlayState.animationData[i]["key"];
        Animations().startTileExplodeAnimation(gamePlayState,key);
      }     

      if (type=="stopwatch-rewind") {
        Animations().startStopwatchRewindAnimation(gamePlayState);
      }  
      if (type=="undo") {
        int turn = gamePlayState.animationData[i]["turn"];
        Animations().startUndoAnimation(gamePlayState, turn);
      } 

      if (type =="add-perks") {
        int turn = gamePlayState.animationData[i]["turn"];
        // Animations().startAddPerksAnimation(gamePlayState, key, itemData)
      }


      // if (type=="menu-charge") {
      //   String key = gamePlayState.animationData[i]["key"];
      //   Map<String,dynamic> costData = gamePlayState.animationData[i]["animation"]["data"];
      //   Animations().startMenuItemChargeAnimation(gamePlayState,key,costData);
      // }                                    
    }
  }


  void getMenuItemPositionData(GamePlayState gamePlayState) {

    if (gamePlayState.openMenuTile != null) {
      Map<String,dynamic> openMenuTile = gamePlayState.openMenuTile!;
      List<Map<String,dynamic>> menuOptions = gamePlayState.openMenuTile!["menuData"];
      int numCols = gamePlayState.gameParameters["columns"];  // Helpers().getNumberAxis(gamePlayState, 'column');
      Size tileSize = gamePlayState.elementSizes["tileSize"];
      
      Offset tileCenter = openMenuTile["center"];
      double positionY = tileCenter.dy-(tileSize.height*1.2);
      final double menuWidth = menuOptions.length*tileSize.width;
      late double menuCenterX = tileCenter.dx;
      if (openMenuTile["column"] == 1) {
        late double leftWall = tileCenter.dx-(tileSize.width/2);
        menuCenterX = leftWall+(menuWidth/2);
      }

      else if (openMenuTile["column"]==numCols) {
        late double rightWall = tileCenter.dx+(tileSize.width/2);
        menuCenterX = rightWall-(menuWidth/2);        
      }

      else {
        menuCenterX = tileCenter.dx;
      }

      double positionX = menuCenterX;
      double factorX = menuOptions.length/2;
      for (int i=0; i<menuOptions.length; i++) {
        double optionX = positionX + (((i-factorX)*tileSize.width)+tileSize.width/2);
        Offset optionPosition =  Offset(optionX,positionY);

        Path optionPath = Path();
        optionPath.moveTo(optionPosition.dx- (tileSize.width*0.8/2), optionPosition.dy- (tileSize.height*0.8/2));
        optionPath.lineTo(optionPosition.dx+ (tileSize.width*0.8/2), optionPosition.dy- (tileSize.height*0.8/2));
        optionPath.lineTo(optionPosition.dx+ (tileSize.width*0.8/2), optionPosition.dy+ (tileSize.height*0.8/2));
        optionPath.lineTo(optionPosition.dx- (tileSize.width*0.8/2), optionPosition.dy+ (tileSize.height*0.8/2));
        optionPath.lineTo(optionPosition.dx- (tileSize.width*0.8/2), optionPosition.dy- (tileSize.height*0.8/2));
        optionPath.close();

        gamePlayState.openMenuTile!["menuData"][i]["path"] = optionPath;
        gamePlayState.openMenuTile!["menuData"][i]["center"] = optionPosition;
        gamePlayState.setOpenMenuTile(gamePlayState.openMenuTile!);
      }
    }
  }


  void closeTileMenuBuyMoreModal(GamePlayState gamePlayState, ColorPalette palette, int? optionKey) {
    Map<String,dynamic> tileMenuBuyMoreModalData = gamePlayState.tileMenuBuyMoreModalData;
    print("** tileMenuBuyMoreModalData $tileMenuBuyMoreModalData");
    
    String item = tileMenuBuyMoreModalData["item"];

    // print(tileMenuBuyMoreModalData["options"]);
    List<Map<String,dynamic>> options = tileMenuBuyMoreModalData["options"];


    var optionSelected = options.firstWhere((e)=>e["key"] == optionKey,orElse:() => {});
    if (optionSelected.isNotEmpty) {
      int reward = optionSelected["reward"];

      if (optionSelected["costItem"]=="ad") {
        print("launch ad!");
        // launch ad
        Map<String,dynamic> itemObject = gamePlayState.tileMenuOptions.firstWhere((e)=>e["item"]==item,orElse: ()=>{});
        if (itemObject.isNotEmpty) {
          itemObject.update("count", (v)=>reward);
        }        
      } else {
        Map<String,dynamic> itemObject = gamePlayState.tileMenuOptions.firstWhere((e)=>e["item"]==item,orElse: ()=>{});
        if (itemObject.isNotEmpty) {
          itemObject.update("count", (v)=>reward);
        }

        Animations().startAddPerksAnimation(gamePlayState,item,optionSelected);

      }
    }

    gamePlayState.tileMenuBuyMoreModalData.update("tile", (v)=>null);
    gamePlayState.tileMenuBuyMoreModalData.update("open", (v)=>false);
    gamePlayState.tileMenuBuyMoreModalData.update("item", (v)=>null);
    gamePlayState.tileMenuBuyMoreModalData.update("message", (v)=>"");
    gamePlayState.tileMenuBuyMoreModalData.update("options", (v)=>[]);
    gamePlayState.setTileMenuBuyMoreModalData(gamePlayState.tileMenuBuyMoreModalData);

    // print("openMenuTile => ${gamePlayState.openMenuTile}");

    gamePlayState.setIsGamePaused(false);
    GameLogic().executePauseDialogPopScope(gamePlayState,palette);
  }  


  // void getStringCombinations(GamePlayState gamePlayState) {
    
  //   int rows = Helpers().getNumberAxis(gamePlayState, 'row');
  //   int cols = Helpers().getNumberAxis(gamePlayState, 'column');

  //   // horizontal words JUST ONE ROW
  //   List<List<int>> res = [];
  //   for (int a=0;a<rows;a++) {
  //     for (int i=3; i<cols+1; i++) {
  //       int numCombinations = (cols-i)+1;
  //       for (int j=0;j<numCombinations;j++) {
  //         List<int> ids = [];
  //         for (int k=1;k<i+1; k++) {
  //           int val =  k+j;
  //           Map<String,dynamic> correspondingObject = gamePlayState.tileData.firstWhere((e)=> e["row"]==(a+1) && e["column"]==val,orElse: ()=>{});
  //           if(correspondingObject.isNotEmpty){
  //             int key= correspondingObject["key"];
  //             ids.add(key);
  //           } else {
  //             print("there was an error at row ${(a+1)} col $val");
  //           }
  //         }
  //         res.add(ids);
  //       }
  //     }
  //   }

  //   // // vertical
  //   for (int a=0;a<cols;a++) {
  //     for (int i=3; i<rows+1; i++) {
  //       int numCombinations = (rows-i)+1;
  //       for (int j=0;j<numCombinations;j++) {
  //         List<int> ids = [];
  //         for (int k=1;k<i+1; k++) {
  //           int val = k+j;
  //           Map<String,dynamic> correspondingObject = gamePlayState.tileData.firstWhere((e)=> e["column"]==(a+1) && e["row"]==val,orElse: ()=>{});
  //           if(correspondingObject.isNotEmpty){
  //             int key= correspondingObject["key"];
  //             ids.add(key);
  //           } else {
  //             print("there was an error at row ${(a+1)} col $val");
  //           }            
  //           // ids.add(val);
  //         }
  //         res.add(ids);
  //       }
  //     }
  //   }

  //   gamePlayState.setValidIdCombinations(res);
  // }

  void validateStrings(GamePlayState gamePlayState, Map<String,dynamic>? moveData) {
    print("-------- EXECUTING VALIDATE STRING ----------------");
    try {
      final Box wordBox = Hive.box('wordBox');
      late List<String> dictionary = List<String>.from(wordBox.get('words_english', defaultValue: []));


      if (gamePlayState.isTutorial) {
        dictionary = gamePlayState.tutorialData["dictionary"];
      }


      List<List<int>> validIdCombinations = gamePlayState.validIdCombinations;
      // List<String> dictionary = gamePlayState.dictionary;
      List<Map<String,dynamic>> tileData = gamePlayState.tileData;
      List<Map<String,dynamic>> animationData = gamePlayState.animationData;


      List<Map<String,dynamic>> validStrings = [];
      List<int> uniqueIds = [];
      List<Map<String,dynamic>> ids = [];
      int totalScore = 0;
      int turn = gamePlayState.scoreSummary.length;


      for (int i=0; i<validIdCombinations.length;i++) {

        List<int> idsInString = validIdCombinations[i];
        String word = "";
        for (int j=0; j<idsInString.length; j++) {          
          Map<String,dynamic> validTileObject = tileData.firstWhere((e)=>e["key"]==idsInString[j],orElse: ()=>{});
          if (validTileObject.isNotEmpty) {
            String letter = validTileObject["body"] == "" ? "-" : validTileObject["body"];
            if (!validTileObject["active"] || validTileObject["frozen"]) {
              letter = "-";
            }
            word = word+letter;
          }
        }

        
        

        if (dictionary.contains(word)) {

          int score = 0;
          int wordLength = word.length;
          for (int k=0; k<wordLength; k++) {
            Map<String,dynamic> letterObject = gamePlayState.alphabet.firstWhere((e)=>e["letter"]==word[k],orElse:()=>{});
            if (letterObject.isNotEmpty) {
              score = score + letterObject["points"] as int;
            }
          }
          totalScore = totalScore + (score * (wordLength-2)); ;
          String key = "${turn}_${validStrings.length}";
          validStrings.add({"key":key, "word":word,"ids":idsInString, "score":score});
        }
      }

      
      
      for (int i=0; i<validStrings.length; i++) {
        for (int j=0; j<validStrings[i]["ids"].length;j++) {
          if (!uniqueIds.contains(validStrings[i]["ids"][j])) {
            uniqueIds.add(validStrings[i]["ids"][j]);
          }
        }
      }
  


      for (int i=0;i<uniqueIds.length;i++) {
        int key = uniqueIds[i];
        Map<String,dynamic> letterObject = gamePlayState.tileData.firstWhere((e)=>e["key"]==key,orElse: ()=>{});
        String body = "";
        if (letterObject.isNotEmpty) {
          body = letterObject["body"];
        }
        ids.add({"id":key,"body":body});

        Map<String,dynamic> alphabetObject = gamePlayState.alphabet.firstWhere((e)=>e["letter"]==body,orElse: ()=>{});
        if (alphabetObject.isNotEmpty) {
          int inPlay = alphabetObject['inPlay'];
          int letterCount = alphabetObject['count'];   
          alphabetObject.update('inPlay', (value) => inPlay-1);
          alphabetObject.update('count', (value) => letterCount+1);
        }
      }

      // check if the turn was a tap or a drag
      Map<String,dynamic>? targetTile = gamePlayState.focusedElement;
      if (gamePlayState.draggedElementData != null) {
        Map<String,dynamic>? draggedElementData = gamePlayState.draggedElementData;
        Offset location = draggedElementData?["location"];
        Map<String,dynamic> pointerElement = Helpers().getPointerElement(gamePlayState,location);
        targetTile = pointerElement;
      }

      // targetTile = tileObject;

      int streakMultiplier = Helpers().getStreakMultiplier(gamePlayState,validStrings.length); //
      int crossWordMultiplier = Helpers().getCrossWordMultiplier(gamePlayState, ids);
      int multiWordMultiplier = validStrings.length;


      Map<String,dynamic> turnObject = {
        "turn": turn,
        "multipliers": {"streak": streakMultiplier, "cross": crossWordMultiplier, "words": multiWordMultiplier}, 
        "score": totalScore * (streakMultiplier * crossWordMultiplier * multiWordMultiplier),  
        "validStrings": validStrings, 
        "ids": ids, 
        "tileTapped": targetTile,
        "moveData":moveData,
      };
      gamePlayState.setscoreSummary([...gamePlayState.scoreSummary,turnObject]);
    } catch (e, s) {
      print("ERROR IN **validateStrings** | ${e.toString()} | $s");
    }
  }


  void recalibrateAlphabet(GamePlayState gamePlayState) {
    print("start recalibrate");
  }


  void updateBoardAfterFoundWord({required GamePlayState gamePlayState}) {

    Map<String,dynamic> turnData = gamePlayState.scoreSummary.last;
    for (int i=0;i<turnData["ids"].length; i++) {
      int key = turnData["ids"][i]["id"];
      Map<String,dynamic> tileObject = gamePlayState.tileData.firstWhere((e)=>e["key"]==key,orElse:()=>{});
      tileObject.update("body", (v)=>"");
    }
    gamePlayState.setTileData(gamePlayState.tileData);


  }

  void killSpot(GamePlayState gamePlayState) {

    List<Map<String,dynamic>> openCandidates = Helpers().getOpenTiles(gamePlayState);

    if (openCandidates.isNotEmpty) {

      int tileIndex = -1;
      if (gamePlayState.isTutorial) {
        int turn = gamePlayState.tutorialData["currentTurn"];
        List<Map<String,dynamic>> steps = gamePlayState.tutorialData["steps"];
        Map<String,dynamic> step = steps.firstWhere((e)=>e["step"]==turn,orElse: ()=>{});    
        if (step.isNotEmpty) {          
          int? killTileKey = step["targetKey"];
          if (killTileKey != null) {
            tileIndex = killTileKey;
          }
        }    
      } else {
        Random random = Random();
        tileIndex = random.nextInt(openCandidates.length);
      }

      Map<String,dynamic> tileObject = openCandidates[tileIndex];
      tileObject.update("active", (v) => false);
      Animations().startKillTileAnimation(gamePlayState,tileObject["key"]);

      validateStrings(gamePlayState, {"type":"kill","tiles":[tileObject["key"]]},);

      gamePlayState.restartStopWatchTimer();

      gamePlayState.setTileData(gamePlayState.tileData);


    } else {
      // in theory this should not happen because the game over logic should execute before getting to this point
      print("game over!");
    }
  }

  void checkLevelUp(GamePlayState gamePlayState) {
    late int score = 0;
    if (gamePlayState.scoreSummary.isNotEmpty) {
      late int val = 0;
      for (int i=0;i<gamePlayState.scoreSummary.length;i++) {
        val = val + gamePlayState.scoreSummary[i]["score"] as int;
      }
      score = val;
    }

    int currentLevel = gamePlayState.currentLevel;

    Map<String,dynamic> levelObject = gamePlayState.levelData.firstWhere((e)=> e["start"]<=score&&e["end"]>score,orElse: ()=>{});
    int correspondingLevel = levelObject["key"];

    Map<String,dynamic> previousLevel = gamePlayState.scoreSummary.last;
    if (previousLevel["validStrings"].isNotEmpty) {

    }
      
    if (currentLevel != correspondingLevel) {

      
      Map<String,dynamic> tapReleaseDelay = gamePlayState.animationLengths.firstWhere((e)=>e["type"]=="tap-up",orElse: ()=>{});
      if (tapReleaseDelay.isNotEmpty) {        

        Map<String,dynamic> previousLevel = gamePlayState.scoreSummary.last;
        if (previousLevel["validStrings"].isNotEmpty) {
          int delayMs = tapReleaseDelay["stops"]*tapReleaseDelay["interval"] + 1000;

          gamePlayState.setCurrentLevel(gamePlayState.currentLevel+1);
          Future.delayed(Duration(milliseconds: delayMs), () {
            Animations().startLevelUpAnimation(gamePlayState);
          });
        }        
      }
    } 
    


  }

  void checkGameOver(GamePlayState gamePlayState, BuildContext context) {

    if (!gamePlayState.isGameOver && !gamePlayState.isTutorial) {

      late bool didCompleteGame = false;
      late bool didAchieveObjective = false;
      late int reward = 100;
      late int xp = 5;
      // final String gameType = gamePlayState.gameParameters["gameType"];
      List<Map<String,dynamic>> openCandidates = Helpers().getOpenTiles(gamePlayState);


      String? puzzleId = gamePlayState.gameParameters["puzzleId"];
      // print('PUZZLE ID: ${puzzleId}');


      if (openCandidates.isEmpty) {
        print("*** game over due to lack of empty tiles! ***");


        gamePlayState.pauseStopWatchTimer();
        gamePlayState.pauseTimer();

        didAchieveObjective=false;
        reward = 100;
        xp = 0;

        gamePlayState.gameResultData.update("didCompleteGame", (v)=> didCompleteGame);
        gamePlayState.gameResultData.update("didAchieveObjective", (v)=> didAchieveObjective);
        gamePlayState.gameResultData.update("reward", (v)=> reward);
        gamePlayState.gameResultData.update("xp", (v)=> xp);
        executeGameOverLogic(context,gamePlayState);

      } else {
        if (gamePlayState.gameParameters["gameType"]=='classic') {

          print("CHECK GAME OVER: IN CLASSIC: ${gamePlayState.countDownDuration} | ${gamePlayState.stopWatchDuration}");

          if (gamePlayState.countDownDuration != null) {
            if (gamePlayState.countDownDuration!.inSeconds <= 0) {

              print("*** game over due to lack of time left! ***");

              didCompleteGame = true;
              didAchieveObjective = true;
              reward = 2000;
              xp = 5;            

              gamePlayState.gameResultData.update("didCompleteGame", (v)=> didCompleteGame);
              gamePlayState.gameResultData.update("didAchieveObjective", (v)=> didAchieveObjective);
              gamePlayState.gameResultData.update("reward", (v)=> reward);
              gamePlayState.gameResultData.update("xp", (v)=> xp);
              print("xp in checkGameOver => $xp | ${gamePlayState.gameResultData}");
              executeGameOverLogic(context,gamePlayState);

            }
          }
        }


        if (gamePlayState.gameParameters["gameType"]=='sprint') {

          print("GAME PARAMS: ${gamePlayState.gameParameters}");
          print("CHECK GAME OVER: IN SPRINT WITH TARGET ${gamePlayState.gameParameters['target']}: ");
          int currentScore= 0;
          for(int i=0;i<gamePlayState.scoreSummary.length; i++) {
            currentScore = currentScore + gamePlayState.scoreSummary[i]["score"] as int;
          }
          
          if (currentScore >= gamePlayState.gameParameters["target"]) {

            gamePlayState.pauseTimer();

            Future.delayed(const Duration(milliseconds: 1000), () {
              print("*** game over due to target points reached! ***");
              didCompleteGame = true;
              didAchieveObjective = true;
              reward = 2000;
              xp = 5;
              gamePlayState.gameResultData.update("didCompleteGame", (v)=> didCompleteGame);
              gamePlayState.gameResultData.update("didAchieveObjective", (v)=> didAchieveObjective);
              gamePlayState.gameResultData.update("reward", (v)=> reward);
              gamePlayState.gameResultData.update("xp", (v)=> xp);
              if (context.mounted) {
                executeGameOverLogic(context,gamePlayState);
              }
            });

          }
        }
      }

    }
  }



  void executeGameOverLogic(BuildContext context, GamePlayState gamePlayState,) {
    gamePlayState.setIsGameOver(true);
    if (gamePlayState.isTutorial) {
      gamePlayState.refreshTutorialData();
    }

    

    print("in the checkGameOver function - game params =>  ${gamePlayState.gameParameters}");

    Animations().startGameOverOverlayAnimation(gamePlayState);

    // navigates to the game over screen after a 500 ms delay
    Future.delayed(Duration(milliseconds: 500), () {
      if (context.mounted) {
        // Navigator.pop(context);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const GameOverScreen())
        );
        
      }
    });       
  }

  void restartTimer(GamePlayState gamePlayState, String type) {
    // get the tile animation duration for the delay value
    bool isTimeToPlace = gamePlayState.gameParameters["timeToPlace"]!=null; 

    if (isTimeToPlace) {
      gamePlayState.pauseStopWatchTimer();
      Animations().startStopwatchRewindAnimation(gamePlayState);
      Map<String,dynamic> animationDurationData = gamePlayState.animationLengths.firstWhere((e)=>e["type"]=="stopwatch-rewind",orElse: ()=>{}); 
      Future.delayed(Duration(milliseconds: (animationDurationData["stops"]*animationDurationData["interval"])), () {
        gamePlayState.startStopWatch();
      });     
    }
  }  


  void checkTimeExpired(BuildContext context, GamePlayState gamePlayState) {

    if (gamePlayState.isGameStarted && !gamePlayState.isGamePaused && !gamePlayState.isGameOver ) {

      
      bool isTimeToPlace = gamePlayState.gameParameters["timeToPlace"]!=null;
      String gameType = gamePlayState.gameParameters["gameType"];

      if (isTimeToPlace) {
        if (gamePlayState.stopWatchDuration.inMilliseconds <= 0 ) {
          // kill spot
          WidgetsBinding.instance.addPostFrameCallback((_) {
            killSpot(gamePlayState);
            checkGameOver(gamePlayState, context);
          });
        }
      }

      if (gameType == "tutorial") {
        int turn = gamePlayState.tutorialData["currentTurn"];
        Map<String,dynamic> tutorialStep = gamePlayState.tutorialData["steps"][turn];
        if (tutorialStep["moveType"]=="kill") {
          if (gamePlayState.stopWatchDuration.inMilliseconds <= 0 ) {
            // kill spot
            WidgetsBinding.instance.addPostFrameCallback((_) {
              killSpot(gamePlayState);
              checkGameOver(gamePlayState, context);
              gamePlayState.tutorialData.update("currentTurn", (v)=>turn+1);
              gamePlayState.setTutorialData(gamePlayState.tutorialData);
              gamePlayState.pauseStopWatchTimer();
        
            });
          }          
        }

      }

      // if (isTimeToPlace || gameType == "tutorial") {
        
      //   // print("gamePlayState.stopWatchDuration.inMilliseconds = ${gamePlayState.stopWatchDuration.inMilliseconds}");

      //   if (gamePlayState.stopWatchDuration.inMilliseconds <= 0 ) {
      //     // kill spot
      //     WidgetsBinding.instance.addPostFrameCallback((_) {
      //       // setState(() {
      //         killSpot(gamePlayState);

      //         checkGameOver(gamePlayState, context);

      //         if (gameType == "tutorial") {
      //           int turn = gamePlayState.tutorialData["currentTurn"];
      //           gamePlayState.tutorialData.update("currentTurn", (v)=>turn+1);
      //           gamePlayState.setTutorialData(gamePlayState.tutorialData);
      //           gamePlayState.pauseStopWatchTimer();
      //         }
      //       // });
      //     });
      //   }

      // }

      if (gamePlayState.countDownDuration != null) {
        if (gamePlayState.countDownDuration!.inSeconds <= 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // setState(() {
              // gamePlayState.timer.cancel();
              // gamePlayState.stopWatchTimer.cancel();
              // gamePlayState.countDownTimer.cancel();
              // gamePlayState.setIsGameOver(true);
              checkGameOver(gamePlayState, context);
            });
          // });
        }
      } 

    }

  }

  void validateTutorialFinish(BuildContext context, GamePlayState gamePlayState, SettingsController settings) {
    if (gamePlayState.isTutorial) {
      // print("current step = ${gamePlayState.tutorialData["currentTurn"]}");
      if (gamePlayState.tutorialData["currentTurn"]==gamePlayState.tutorialData["steps"].length-1) {

        // Future.delayed(const Duration(milliseconds: 1500), () {
       

        // print("message at game over => ${step["message"]}");
        Map<String,dynamic> userData = settings.userData.value as Map<String,dynamic>;
        late int rewardCoins = 0;
        late int rewardXp = 0;
        if (userData["parameters"]["tutorialComplete"]) {
          rewardCoins = 0;
          rewardXp = 0;
        } else {
          rewardCoins = 2000;
          rewardXp = 5;
          // userData["parameters"].update("tutorialComplete":)
        }
        gamePlayState.gameResultData.update("didCompleteGame", (v)=> true);
        gamePlayState.gameResultData.update("didAchieveObjective", (v)=> true);
        gamePlayState.gameResultData.update("reward", (v)=> rewardCoins);
        gamePlayState.gameResultData.update("xp", (v)=> rewardXp);        

        executeGameOverLogic(context,gamePlayState);        
      
        //   }
        // });
      }
    }

  }

  void cancelSwap(GamePlayState gamePlayState) {
    Map<String,dynamic> res = gamePlayState.tileData.firstWhere((e)=> e["swapping"]==true,orElse: ()=>{});
    res.update("swapping", (v)=>false);
  }

  void cancelPerk(GamePlayState gamePlayState) {
    Map<String,dynamic> perkOpen = gamePlayState.tileMenuOptions.firstWhere((e)=>e["open"]==true,orElse: ()=>{});
    if (perkOpen.isNotEmpty) {
      perkOpen.update("open", (v)=>false);
      perkOpen.update("selected", (v)=>false);
      Animations().startSelectPerkAnimation(gamePlayState, perkOpen["item"],false);
    }  
  }

  // void validateLongPress(BuildContext context, GamePlayState gamePlayState, ColorPalette palette) {
  //   if (gamePlayState.isLongPress) {

  //     Map<String,dynamic> pointedElement = Helpers().getPointerElement(gamePlayState, gamePlayState.currentGestureLocation!);
  //     Map<String,dynamic> swappingTile = Helpers().getSwappingTile(gamePlayState);
  //     bool isOpenMenuTile = gamePlayState.openMenuTile==null ? false : true;
  //     bool isTileBeingDragged = gamePlayState.draggedElementData==null ? false : true;

  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       // setState(() {

  //         if (!isOpenMenuTile) {
  //           if (pointedElement["type"]!="reserve") {
  //             if (swappingTile.isEmpty) {
  //               if (pointedElement.isNotEmpty && !isTileBeingDragged) {
  //                 print("open menu of options for a tile: explode, freeze, swap");
  //                 executeOpenTileMenu(gamePlayState, pointedElement);
  //               }
  //             } else {
  //               print("swap with this guy!");

  //               if (swappingTile["key"]!=pointedElement["key"]) {
  //                 print("swapping tile: ${swappingTile["key"]} | pointed element: ${pointedElement["key"]}");
  //                 executeSwap(gamePlayState, palette, context, pointedElement);
                  
  //               } else {
  //                 cancelSwap(gamePlayState);
  //               }
  //             }
  //           }
  //         }

  //       });
  //     // });            
  //   }    
  // }




  void storeEndOfGameData(SettingsController settings, GamePlayState gamePlayState) {

    late Map<String,dynamic> userData = settings.userData.value as Map<String,dynamic>;
    late List<dynamic> gameHistory = userData["gameHistory"];

    late List<String> badgeKeys = [];
    late List<int> multiWords = [];
    late List<int> streaks = [];
    late List<Map<dynamic,dynamic>> badgesEarned = [];
    late List<dynamic> achievementData = settings.achievementData.value;
    late int xpEarnedFromBadges = 0;
    late bool shouldSaveData = true;
    

    if (gamePlayState.gameParameters["gameType"]=="tutorial" && userData["parameters"]["tutorialComplete"]) {
      shouldSaveData = false;
    }
    // final bool isTutorialComplete = userData["parameters"]["tutorialComplete"];

    // if (!isTutorialComplete) {
    for (int i=0; i < gamePlayState.scoreSummary.length; i++) {
      Map<String,dynamic> scoreObject = gamePlayState.scoreSummary[i];
      int wordsMultiplier = scoreObject["multipliers"]["words"];
      if (!multiWords.contains(wordsMultiplier)) {
        multiWords.add(wordsMultiplier);
      }

      int streakMultiplier = scoreObject["multipliers"]["streak"];
      if (!streaks.contains(streakMultiplier)) {
        streaks.add(streakMultiplier);
      }      

      if (scoreObject["validStrings"].isNotEmpty) {
        List<Map<String,dynamic>> validStrings = scoreObject["validStrings"];
        // List<int> uniqueIds = [];
        List<int> wordRows = [];
        List<int> wordColumns = [];
        for (int j=0; j<validStrings.length; j++) {
          Map<String,dynamic> validStringObject = validStrings[j];
          List<int> ids = validStringObject["ids"];
          // List<int> uniqueIds = [];

          for (int k=0; k<ids.length; k++) {
            Map<String,dynamic> tileObject = gamePlayState.tileData.firstWhere((v)=>v["key"]==ids[k],orElse: ()=>{});
            if (tileObject.isNotEmpty) {
              int row = tileObject["row"];
              int column = tileObject["column"];
              if (!wordRows.contains(row)) {
                wordRows.add(row);
              }
              if (!wordColumns.contains(column)) {
                wordColumns.add(column);
              }
            }
          }
        }
        if (wordRows.length>1 && wordColumns.length>1) {
          int? numAxis1;
          int? numAxis2;          
          if (wordRows.length == wordColumns.length) {
            numAxis1 = wordRows.length;
            numAxis2 = wordColumns.length;
          } else {
            numAxis1 = min(wordRows.length,wordColumns.length);
            numAxis2 = max(wordRows.length,wordColumns.length);   
          }


          Map<String,dynamic> correspondingBadge = achievementData.firstWhere((e)=>
            e["completed"] == false && 
            e["target"] == "crosswords" && 
            e["data"]["axis1"] == numAxis1 && 
            e["data"]["axis2"] == numAxis2,
            orElse: () => <String,dynamic>{}
          );

          if (correspondingBadge.isNotEmpty) {
            final String badgeKey = correspondingBadge["badgeKey"];
            if (!badgeKeys.contains(badgeKey)) {
              badgeKeys.add(badgeKey);
              badgesEarned.add(correspondingBadge);
            }
          }
        }        
      }
    }

    for (int i=0; i<multiWords.length; i++) {
      int wordsVal = multiWords[i];
      Map<String,dynamic> correspondingBadge = achievementData.firstWhere((e)=>
        e["completed"] == false && 
        e["target"] == "words" && 
        e["data"]["count"] == wordsVal,
        orElse: () => <String,dynamic>{}
      );
      if (correspondingBadge.isNotEmpty) {
        final String badgeKey = correspondingBadge["badgeKey"];
        if (!badgeKeys.contains(badgeKey)) {
          badgeKeys.add(badgeKey);
          badgesEarned.add(correspondingBadge);
        }
      }           
    }

    
    for (int i=0; i<streaks.length; i++) {
      int streakVal = streaks[i];
      Map<String,dynamic> correspondingBadge = achievementData.firstWhere((e)=>
        e["completed"] == false && 
        e["target"] == "streak" && 
        e["data"]["count"] == streakVal,
        orElse: () => <String,dynamic>{}
      );
      if (correspondingBadge.isNotEmpty) {
        final String badgeKey = correspondingBadge["badgeKey"];
        if (!badgeKeys.contains(badgeKey)) {
          badgeKeys.add(badgeKey);
          badgesEarned.add(correspondingBadge);
        }
      }           
    }

    List<dynamic> totalUniqueWords = [];
    for (int i=0; i<gameHistory.length; i++) {
      List<dynamic> gameWords = gameHistory[i]["uniqueWords"];
      for (int j=0;j<gameWords.length;j++) {
        if (!totalUniqueWords.contains(gameWords[j])) {
          totalUniqueWords.add(gameWords[j]);
        }
      }
    }
    final List<String> gameWords = Helpers().getUniqueWords(gamePlayState);
    for (int i=0; i<gameWords.length; i++) {
      if (!totalUniqueWords.contains(gameWords[i])) {
        totalUniqueWords.add(gameWords[i]);
      }
    }

    List<dynamic> openGlobalWordAchievements = settings.achievementData.value.where(
      (e)=>e["completed"]==false &&
      e["type"]=="global" &&
      e["target"]=="words"
      ).toList();

      
    for (int i=0; i<openGlobalWordAchievements.length; i++) {
      Map<dynamic,dynamic> badgeObject = openGlobalWordAchievements[i];

      if (totalUniqueWords.length>badgeObject["data"]["count"]) {
        String badgeKey = badgeObject["badgeKey"];

        if (!badgeKeys.contains(badgeKey)) {
          badgeKeys.add(badgeKey);
          badgesEarned.add(badgeObject);
        }        

      }
    }
    

    for (int i=0; i<badgesEarned.length;i++) {
      Map<dynamic,dynamic> badge = badgesEarned[i];
      int xp = badge["xp"];
      xpEarnedFromBadges = xpEarnedFromBadges + xp;
      badge.update("completed", (v)=>true);
      badge.update("dateCompleted", (v)=>DateTime.now().toIso8601String());
    }

    if (shouldSaveData) {
      // print("don't save, tutorial was completed");
      // final int currentXP = settings.xp.value;
      final int currentXP = userData["xp"];
      final int xpEarnedInGame = gamePlayState.gameResultData["xp"]??0;
      gamePlayState.gameResultData.update("xp",(v) => xpEarnedInGame+xpEarnedFromBadges);
      final int newXpValue = currentXP + xpEarnedFromBadges + xpEarnedInGame;
      // settings.setXP(newXpValue);
      
      final int currentCoins = userData["coins"]; //settings.coins.value;
      final int coinsAwarded = gamePlayState.gameResultData["reward"];
      final int newCoinsValue = currentCoins+coinsAwarded;
      // settings.setCoins(newCoinsValue);


      final int score = Helpers().calculateScore(gamePlayState);
      final int turns = Helpers().countTurns(gamePlayState);
      final int streak = Helpers().getLongestStreak(gamePlayState);
      final int crosswords = Helpers().countCrosswords(gamePlayState);
      final int biggestTurn = Helpers().getBiggestTurn(gamePlayState);  

      final Map<String,dynamic> gameParams = Map<String,dynamic>.from(gamePlayState.gameParameters); 
      gameParams.remove("mediaQueryData");     


      final Map<String,dynamic> data = {
        "createdAt": DateTime.now().toIso8601String(),
        "score": score,
        "uniqueWords":gameWords,
        "turns":turns,
        "streak":streak,
        "crosswords":crosswords,
        "biggestTurn":biggestTurn,
        "durationSeconds":gamePlayState.duration.inSeconds,
        "gameResultData": gamePlayState.gameResultData,
        "gameParameters": gameParams, //{"gameType": gameType,"target":target,"targetType":targetType,"boardAxis":boardAxis,"durationInMinutes":durationInMinutes},

      };

      print("""
=1=1=1=1=1=1=1=1=1==1=1=1=1=1=1=1
game params:
${gameParams}
in the store data function => 
${data}
=1=1=1=1=1=1=1=1=1==1=1=1=1=1=1=1
""");

      // Map<String,dynamic> userData = settings.userData.value as Map<String,dynamic>;
      // List<dynamic> history = userData["gameHistory"];


      // updatedHistory.add(data);
      // settings.setUserGameHistory(updatedHistory);
      gamePlayState.gameResultData.update("badges", (v) => badgesEarned);

      settings.setAchievementData(achievementData);
      FirestoreMethods().updateAchievementData(settings,badgesEarned);
      FirestoreMethods().updateGameHistory(settings, data);
      FirestoreMethods().updateDailyPuzzleGameComplete(settings,data);
      FirestoreMethods().updateUserDoc(settings,"coins",newCoinsValue);
      FirestoreMethods().updateUserDoc(settings,"xp",newXpValue);
      if (!userData["parameters"]["tutorialComplete"]) {
        FirestoreMethods().updateParameters(settings, "tutorialComplete", true);
      }
    }
  }

  void updateRank(SettingsController settings, GamePlayState gamePlayState) {

    Map<String,dynamic> userData = settings.userData.value as Map<String,dynamic>;

    String? newRank = null;
    newRank = Helpers().getNewRank(settings,gamePlayState);

    if (newRank != null) {
      userData.update("rank", (v)=>newRank);
      settings.setUserData(userData);

      FirestoreMethods().updateUserDoc(settings, "rank", newRank);

      gamePlayState.gameResultData.update("newRank", (v) => newRank);
    } 
  }

  void updateDecorationData(GamePlayState gamePlayState,Random random, ColorPalette palette) {
      final List<Color> colors = [
        // const Color.fromARGB(255, 182, 21, 21),
        // const Color.fromARGB(255, 253, 115, 35),
        // const Color.fromARGB(255, 18, 112, 21),
        // const Color.fromARGB(255, 90, 175, 168),
        // const Color.fromARGB(255, 66, 79, 201),
        // const Color.fromARGB(255, 142, 77, 180),
        // const Color.fromARGB(255, 176, 39, 96)

        palette.tileColor1,
        palette.tileColor2,
        palette.tileColor3,
        palette.tileColor4,
        palette.tileColor5,        
      ];
      
      if (gamePlayState.tileDecorationData["interval"] == 50) {
        gamePlayState.tileDecorationData.update("interval", (v) => 0);
        int currentColorIndex = colors.indexOf(gamePlayState.tileDecorationData["nextColor"]);

        gamePlayState.tileDecorationData.update("previousColor", (v) => gamePlayState.tileDecorationData["nextColor"]);
        List<int> listOfIndexes = List.generate(colors.length, (e)=>e);
        listOfIndexes.removeAt(currentColorIndex);
        int nextColorIndex = listOfIndexes[random.nextInt(listOfIndexes.length)];
        Color nextColor = colors[nextColorIndex];
        gamePlayState.tileDecorationData.update("nextColor", (v) => nextColor);
        
      } else {
        gamePlayState.tileDecorationData.update("interval", (v) => gamePlayState.tileDecorationData["interval"]+1);
      }    
  }



}