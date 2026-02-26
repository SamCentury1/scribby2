import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/audio/audio_controller.dart';
import 'package:scribby_flutter_v2/audio/audio_service.dart';
import 'package:scribby_flutter_v2/functions/animations.dart';
import 'package:scribby_flutter_v2/functions/game_logic.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/functions/widget_utils.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';

class Gestures {



  void executePointerDownBehavior(GamePlayState gamePlayState, PointerDownEvent details) {
    GameLogic().getElementTappedDown(gamePlayState, details);
    Map<String,dynamic>? tappedDownElement = gamePlayState.tappedDownElement;
    Map<String,dynamic>? openMenuTile = gamePlayState.openMenuTile;
    Map<String,dynamic> swappingTile = Helpers().getSwappingTile(gamePlayState);
    bool isTapInForbiddenZone = Helpers().getIsTapInForbiddenZone(details,gamePlayState);
    // bool buyMoreModalOpen = gamePlayState.tileMenuBuyMoreModalData["open"];
    Map<String,dynamic> isPerkSelectionDetected =  Helpers().detectPerkSelection(gamePlayState, details.localPosition);
    Map<String,dynamic> openPerk =  Helpers().getSelectedPerk(gamePlayState);

    try {
      print("========= tap dow started ================");
      if (!isTapInForbiddenZone) {

        // ensure that there is no tile with a menu open
        if (openPerk.isEmpty) {

          // enusre there is no swapping tile
          if (isPerkSelectionDetected.isEmpty) {

            //  ensure that there is a tapped down element
            
            if (tappedDownElement!=null) {

              if (tappedDownElement.isNotEmpty) {
                // query animations to check if it's currently active - if yes prevent input
                Map<String,dynamic> animationObject = gamePlayState.animationData.firstWhere((e)=>e["key"]==tappedDownElement["key"],orElse: ()=>{});

                // prevent input if there's an animation currently playing
                if (animationObject.isEmpty) {


                  // allow input if the body is empty and active = true;
                  if (tappedDownElement["body"]=="" && tappedDownElement["active"]) {

                    
                    
                    // 
                    gamePlayState.setIsPointerDown(true);
                    gamePlayState.setFocusedElement(tappedDownElement);
                    gamePlayState.setSelectedElementsWhileDrag([...gamePlayState.selectedElementsWhileDrag,tappedDownElement["key"]]);
                    Animations().startTapDownAnimation(gamePlayState, tappedDownElement["key"]);

                  } else if (tappedDownElement["body"]!= "" ) {

                    print('TAPPED DOWN ON A TILE THAT IS NOT EMPTY HA! ${tappedDownElement}');
                    // gamePlayState.detectLongPress();
                  
                  } else if (tappedDownElement["body"]=="" && !tappedDownElement["active"]) {
                    print("TUTORIAL TEST - $tappedDownElement");
                    // gamePlayState.detectLongPress();
                  } else {

                    // if the tapped element is a reserve tile, set it to dragging
                    if (tappedDownElement["type"]=="reserve") {
                      gamePlayState.setReserveTileToDragging(tappedDownElement["key"]);
                    }
                  }
                }
              }

            } else {
              // tapped outside an element
            }
          } else {
            // tapping while the tile is swapping
            print(" ------------------------- TAPPED WHILE PERK IS SELECTED BUT NOT ACTIVE --------------------------- ");
            isPerkSelectionDetected["selected"]=true;
            String perk = isPerkSelectionDetected["item"]; 
            Animations().startSelectPerkAnimation(gamePlayState,perk,true);             
            
            
          }
        } else {
          print(" ------------------------- TAPPED WHILE PERK IS ACTIVE --------------------------- ");
          // tapping while the menu is open
        }
      }
      gamePlayState.setCurrentGestureLocation(details.position);
      print("========= tap down finished ================");
    } catch (e) {
      log("CAUGHT AN IN ERROR executePointerDownBehavior ${e.toString()}",);
    }

  }



  void executePointerMoveBehavior(GamePlayState gamePlayState, PointerMoveEvent details) {
    Map<String,dynamic>? tappedDownElement = gamePlayState.tappedDownElement;

    Map<String,dynamic>? openMenuTile = gamePlayState.openMenuTile;

    Map<String,dynamic> swappingTile = Helpers().getSwappingTile(gamePlayState);

    bool isTapInForbiddenZone = Helpers().getIsTapInForbiddenZone(details, gamePlayState);
      // check if a tile has its menu open
    Map<String,dynamic> selectedPerk =  Helpers().detectPerkSelection(gamePlayState, details.localPosition);

    Map<String,dynamic> perkOpen =  Helpers().getSelectedPerk(gamePlayState);

    try {

      if (!isTapInForbiddenZone) {

        if (selectedPerk.isEmpty) {

          if (perkOpen.isEmpty) {
            
            // check if the user is swapping a tile
            if (swappingTile.isEmpty) {

              
              
              // check if the user started their tap outside of the board, if not, do not do anything
              if (gamePlayState.draggedElementData == null) {
                
                if (tappedDownElement!=null) {
                  // get the object of the tile that is CURRENTLY being moved on
                  Map<String,dynamic> pointerElement = Helpers().getPointerElement(gamePlayState,details.localPosition);

                  // if the object is not empty, user is hovering on the board or reserves
                  if (pointerElement.isNotEmpty) {

                    // The user is currently moving over a BOARD TILE, 
                    if (pointerElement["type"]=="board" || pointerElement["type"]=="reserve") {

                      // query animation data to see if that tile is animating
                      Map<String,dynamic> animationObject = gamePlayState.animationData.firstWhere((e)=>e["key"]==pointerElement["key"] && e["type"]!="tap-down" ,orElse: ()=>{});

                      // if object is empty - good to tap in it
                      if (animationObject.isEmpty) {

                        // at each new coord, we want to verify that the tile being moved on, matches the one from the previous frame
                        // if the currently pointed tile does not matches the stored focus tile - do nothing
                        if (gamePlayState.focusedElement?["key"] != pointerElement["key"]) {

                          // if we are in a new tile, check whether this new tile is empty, if it is, execute logic
                          if (pointerElement["body"] == "" && pointerElement["active"]) {

                            // if we are in a new tile, add its key to the list of tiles being pointed over in one "swipe"
                            gamePlayState.setSelectedElementsWhileDrag([...gamePlayState.selectedElementsWhileDrag,pointerElement["key"]]);

                            /// CHECK IF SELECTED BOARD TILES WHILE DRAG HAS ONLY ONE ELEMENT (CURRENT). 
                            /// IF SO, USER STARTED DRAGGING, WENT OUT OF BOUNDS, NOW DRAGGING ON BOARD AGAIN.
                            /// OR - THE USER IS TAPPING ON THE SAME TILE ??
                            /// 
                            
                            // if (!gamePlayState.isTutorial) {

                              if (gamePlayState.selectedElementsWhileDrag.length==1) {

                                /// ONLY EXECUTE TAP DOWN ANIMATION FOR THIS TILE, THERE IS NO PREVIOUS TILE
                                Animations().startTapDownAnimation(gamePlayState, pointerElement["key"]);

                              } else {
                                int currentKey = gamePlayState.selectedElementsWhileDrag[gamePlayState.selectedElementsWhileDrag.length-1];
                                int previousKey = gamePlayState.selectedElementsWhileDrag[gamePlayState.selectedElementsWhileDrag.length-2];

                                // if the current key is not equal to the previous key, remove the tap down animation of the previous key
                                // and begin the tap down animation of the current key
                                if (currentKey != previousKey) {
                                  Animations().removeTapDownAnimationObjectWhenDraggingToOtherTile(gamePlayState,previousKey);
                                  Animations().startTapDownAnimation(gamePlayState, currentKey);

                                // otherwise, if the current key is equal to the previous key, it means you are now in a new tile  
                                // and can begin the tap down animation
                                } else {
                                  
                                  Animations().startTapDownAnimation(gamePlayState, currentKey);
                                }
                              }
                            // }


                          } else {

                            // the user started their tap in an empty tile and is not pointing over a full or animating tile
                            if (tappedDownElement["key"]==pointerElement["key"]) {

                              // UPDATES THE POSITION OF THE RESERVE TILE BEING DRAGGED ONTO THE BOARD
                              if (pointerElement["type"]=="reserve") {
                                gamePlayState.setDraggedElementData({"key": tappedDownElement["key"], "location": details.localPosition});
                              }
                              
                            }

                            // run the tap cancel for the previous tile if the previously dragged over elenents list is not empty
                            if (gamePlayState.selectedElementsWhileDrag.isNotEmpty) {

                              // get the key of the previously dragged over tile so we can animate it cancelling
                              int previousKey = gamePlayState.selectedElementsWhileDrag[gamePlayState.selectedElementsWhileDrag.length-1];
                              Animations().removeTapDownAnimationObjectWhenDraggingToOtherTile(gamePlayState,previousKey);
                            }              


                          }

                          // if user is pointing to a new tile than the previous, update the focused
                          gamePlayState.setFocusedElement(pointerElement);     


                        } else {
                          // the pointed to tile and the focus tile are the same - don't do anything
                        }
                      } 
                      // if not empty - tile is animating prevent input
                      else {
                        // 
                        if (gamePlayState.selectedElementsWhileDrag.isNotEmpty) {
                          int previousKey = gamePlayState.selectedElementsWhileDrag.last;
                          Animations().removeTapDownAnimationObjectWhenDraggingToOtherTile(gamePlayState,previousKey);
                        }
                      }


                    }
                  } else {
                    // CURRENTLY OUT OF BOUNDS.
                    // check if the last tile was a reserve tile. if yes, then execute drag and drop functionality
                    if (gamePlayState.selectedElementsWhileDrag.isNotEmpty) {
                      Animations().removeTapDownAnimationObjectWhenDraggingToOtherTile(gamePlayState,gamePlayState.selectedElementsWhileDrag.last);
                    }

                    gamePlayState.setSelectedElementsWhileDrag([]);
                  }
              } else {
                // Animations().removeTapDownAnimationObjectWhenDraggingToOtherTile(gamePlayState,gamePlayState.selectedElementsWhileDrag.last);
              }
              // print("draggedElementData ${gamePlayState.draggedElementData}");

            // UPDATE the reserve tile being dragged
            } else {
              // print("yo so what's the move u tryna smizash?");
              gamePlayState.draggedElementData!.update("location",(e)=> details.position);
              gamePlayState.setDraggedElementData(gamePlayState.draggedElementData);          
            }
          }
        } else {

          // print("selected: $selectedPerk");
          selectedPerk.update("selected", (v)=>false);
          // for (int i=0;i<gamePlayState.tileMenuOptions.length; i++) {
          //   gamePlayState.tileMenuOptions[i]["selected"]=false;
          // }          
        }
        print("selected perk: ${selectedPerk}");
        Helpers().releaseSelectedPerk(gamePlayState, details.localPosition);
      }
    }
    gamePlayState.setCurrentGestureLocation(details.position);
    }catch (e) {
      log("CAUGHT AN IN ERROR executePointerMoveBehavior ${e.toString()}",);
    }
  }



  void executePointerUpBehavior2(
    GamePlayState gamePlayState, 
    ColorPalette palette, 
    PointerUpEvent details, 
    ScaffoldState scaffoldState, 
    BuildContext context,
    ) {

    // check if the tile pointed down on is null.
    Map<String,dynamic> pointedElement = Helpers().getPointerElement(gamePlayState, details.localPosition);

    bool isTileBeingDragged = gamePlayState.draggedElementData==null ? false : true;
    bool isOpenMenuTile = gamePlayState.openMenuTile==null ? false : true;
    String? elementType = pointedElement.isEmpty ? null : pointedElement["type"];
    bool? isActive = pointedElement.isEmpty ? null : pointedElement["active"];
    String? body = pointedElement.isEmpty ? null : pointedElement["body"];
    Map<String,dynamic> swappingTile = Helpers().getSwappingTile(gamePlayState);
    bool buyMoreModalOpen = gamePlayState.tileMenuBuyMoreModalData["open"];
    bool isTapInForbiddenZone = Helpers().getIsTapInForbiddenZone(details,gamePlayState);
    bool isTutorialDropPermitted = Helpers().validateTutorialDragDropGesture(gamePlayState,pointedElement);
    bool isSwapActivated = swappingTile.isNotEmpty;
    Map<String,dynamic> isPerkSelectionDetected =  Helpers().detectPerkSelection(gamePlayState, details.localPosition);
    Map<String,dynamic> perkOpen =  Helpers().getSelectedPerk(gamePlayState);
    AudioService audioService = context.read<AudioService>();


    // Map<String,dynamic> behavior = 

    // user tapped on the background - PAUSE the game

    try {
      // print("---------- tap up started ---------------");
      
      // late bool isTutorialFinished = Helpers().validateTutorialComplete(gamePlayState);
      // if (isTutorialFinished) {
      //   print("isTutorial finished? YES");
      //   GameLogic().executeTutorialStep(gamePlayState,context);
      // }       

      Helpers().validateTutorialComplete(gamePlayState,context);
      
      // release is not in forbidden zone
      if (!isTapInForbiddenZone) {
        // print("- 1. tap is NOT in forbidden zone");
        
        if (!buyMoreModalOpen) {

          if (perkOpen.isEmpty) {
            print("perk menu is closed - is perk selected? ${isPerkSelectionDetected.isNotEmpty}");


            if (isPerkSelectionDetected.isEmpty) {

              // print("-- 2. buy more modal is NOT activated");
              // if (!isOpenMenuTile) {
                // print("--- 3. perk menu is NOT activated");
                  /// There are 6 possible outcomes out of 16 scenarios
                  /// 1. releasing DRAGGING onto a BOARD tile that is ACTIVE and EMPTY
                  /// 2. releasing while NOT DRAGGING onto a BOARD tile that is ACTIVE with a BODY
                  /// 3. releasing while NOT DRAGGING onto a BOARD tile that is ACTIVE that is EMPTY
                  /// 4. releasing while NOT DRAGGING onto a BOARD tile that is INACTIVE that is EMPTY
                  /// 5. releasing while NOT DRAGGING onto a RESERVE tile that is ACTIVE that is EMPTY
              if (isTileBeingDragged) {
                // print("---- 4. tile is being dragged");

                // if (elementType=="board" && isActive==true && body=="" && swappingTile.isEmpty && isDropPermitted) {
                if (isTutorialDropPermitted) {
                  // print("----- 5. drop is permitted - execute move");
                  print("executed the move via drag and drop");
                  GameLogic().executeMove(context,details,gamePlayState,palette,pointedElement);


                } else {
                  // print("----- 5. you can't release a dragged tile here");
                }
              } else {
                // print("---- 4. tile is not being dragged");

                if (isSwapActivated) {
                  // print("----- 5. SWAPPING TILE IS ACTIVE |  released over ${pointedElement}--");
                  if (pointedElement.isEmpty) {
                    // print("------ 6. released over nothing - cancel swap");
                    GameLogic().cancelSwap(gamePlayState);
                  } else {
                    // print("------ 6. released over a tile");
                    if (pointedElement["body"]!="") {
                      // print("------- 7. released over a valid tile");
                      if (swappingTile["key"]!=pointedElement["key"]) {
                        // print("-------- 8. the tile is not the same as the initial swipe - execute swipe");
                        GameLogic().executeSwap(gamePlayState,palette, context, pointedElement);
                      } else {
                        // print("-------- 8. the tile is the same as the initial swipe - cancel the swipe");
                        GameLogic().cancelSwap(gamePlayState);
                      }
                    }
                  }
                } else {
                  // print("----- 5. SWAPPING IS NOT ACTIVE");
                  if (gamePlayState.isTutorial) {
                    Map<String,dynamic> step = Helpers().getTutorialStepObject(gamePlayState);
                    if (step.isNotEmpty) {
                      if (step["moveType"]=="tap") {
                        if (elementType=="board" && body=="") {
                          if (isActive!) {
                            print("executing move via tile type being board and body is empty");
                            GameLogic().executeMove(context,details,gamePlayState,palette,pointedElement);
                          } else {
                          }
                        } else if (elementType=="reserve" && body=="") {
                          print("executing move via tile type being reserve and body is empty");
                          GameLogic().executeMove(context, details, gamePlayState,palette, pointedElement); 
                        }                        
                      }
                    }
                  } else {
                    if (elementType=="board" && body=="") {
                      // print("------ 7. release on BOARD with body");
                      if (isActive!) {
                        // print("------- 8. release on active tile");
                        print("executing move via tile type being board and body is empty");
                        GameLogic().executeMove(context,details,gamePlayState,palette,pointedElement);
                      } else {
                        // // print("------- 9. release on inactive tile");
                        // if (gamePlayState.isLongPress) {
                        //   print("is long press");
                        //   GameLogic().executeOpenTileMenu(gamePlayState, pointedElement);
                        // }
                      }
                    } else if (elementType=="reserve" && body=="") {
                      // print("------ 7. is  reserve - execute move");
                      print("executing move via tile type being reserve and body is empty");
                      GameLogic().executeMove(context, details, gamePlayState,palette, pointedElement); 
                    }
                  }
                }            
              }
            } else {
              print(" ------------------------- RELEASED WHILE PERK IS SELECTED BUT *NOT* ACTIVE  --------------------------- ");
              print(isPerkSelectionDetected);
              isPerkSelectionDetected["open"]=true;
              if (gamePlayState.isTutorial) {
                int turn = gamePlayState.tutorialData["currentTurn"];
                Map<String,dynamic> tutorialStep = gamePlayState.tutorialData["steps"][turn];
                if (tutorialStep['moveType']=='drag') {
                  print("do nothing!");
                } else {
                  GameLogic().executePerkSelectedBehaviour(context,gamePlayState,);
                  isPerkSelectionDetected["selected"]=false;
                }
              } else {
                GameLogic().executePerkSelectedBehaviour(context,gamePlayState,);
                isPerkSelectionDetected["selected"]=false;                
              }

            }
          

          } else {
            print(" ------------------------- RELEASED WHILE PERK IS ACTIVE --------------------------- ");

              // highlight tiles where perk can be applied
              // GameLogic().executePerkSelectedBehaviour(gamePlayState);
              if (pointedElement.isNotEmpty) {
                // print("EXECUTE ${perkType} FOR TILE: ${pointedElement["key"]}");
                print(pointedElement["key"]);
                perkOpen.update("selected", (v) => false);
                GameLogic().executePerk(context,gamePlayState,palette,pointedElement["key"]);

              } else {
                GameLogic().cancelPerk(gamePlayState);
                GameLogic().cancelSwap(gamePlayState);
              }


          }

          // print(gamePlayState.)

          gamePlayState.setDraggedElementData(null);
          gamePlayState.setSelectedElementsWhileDrag([]);
          gamePlayState.setFocusedElement({});
        }
        else {
          print("buy more modal is open - you tapped outside the modal - close it and resume the game");
          gamePlayState.tileMenuBuyMoreModalData.update("open", (v)=>false);
          gamePlayState.tileMenuBuyMoreModalData.update("message", (v)=>"");
          gamePlayState.tileMenuBuyMoreModalData.update("options", (v)=>[]);
          GameLogic().executePauseDialogPopScope(gamePlayState,palette);
          gamePlayState.setIsGamePaused(false);
        }
        
      }
      

      print("---------- tap up finished ---------------");

      gamePlayState.setCurrentGestureLocation(null);
      Helpers().releaseSelectedPerk(gamePlayState,details.localPosition);
      
      // gamePlayState.setIsLongPress(false);

    } catch (e,s) {
      // log("CAUGHT AN IN ERROR executePointerUpBehavior ${e.toString()}",);
      Helpers().printError('executePointerUpBehavior2', e, s);
    }
  }
  


Future<void> openViewDefinitionDialog(BuildContext context, String word) async {
  return showDialog(
    context: context, 
    builder:(context) {

      final double scalor = 1.0;
      final String language = "english";
      final ColorPalette palette = Provider.of<ColorPalette>(context,listen: false);

      return FutureBuilder<Map<String,dynamic>>(
        future: Helpers().fetchDefinition(word, language),
        builder: (context, snapshot) {
          late Map<String,dynamic> res = {};
          if (snapshot.connectionState == ConnectionState.waiting) {
            res = {"result" : "loading", "data": "loading..."};
            return WidgetUtils().definitionModal(scalor, palette ,word,res);
          } else if (snapshot.hasError) {
            res = {"result" : "fail", "data": "Error fetching definition"};
            return WidgetUtils().definitionModal(scalor, palette ,word,res);
          } else {
            if (snapshot.data != null) {
              return WidgetUtils().definitionModal(scalor, palette ,word, snapshot.data!);
            } else {
              res = {"result" : "fail", "data": "No definition available at this time"};
              return WidgetUtils().definitionModal(scalor, palette ,word,res);
            }
          }                    
        },
      
      );
    },                  
  );
}






}