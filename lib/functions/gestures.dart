import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

    try {

      if (!isTapInForbiddenZone) {

        // ensure that there is no tile with a menu open
        if (openMenuTile == null) {

          // enusre there is no swapping tile
          if (swappingTile.isEmpty) {

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
                    gamePlayState.detectLongPress();
                  
                  } else if (tappedDownElement["body"]=="" && !tappedDownElement["active"]) {
                    print("TUTORIAL TEST - $tappedDownElement");
                    gamePlayState.detectLongPress();
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
          }
        } else {
          // tapping while the menu is open
        }
      }
      gamePlayState.setCurrentGestureLocation(details.position);
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

    try {

      if (!isTapInForbiddenZone) {

        if (openMenuTile == null) {

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
            print("draggedElementData ${gamePlayState.draggedElementData}");

          // UPDATE the reserve tile being dragged
          } else {
            // print("yo so what's the move u tryna smizash?");
            gamePlayState.draggedElementData!.update("location",(e)=> details.position);
            gamePlayState.setDraggedElementData(gamePlayState.draggedElementData);          
          }
        }
      }
    }
    gamePlayState.setCurrentGestureLocation(details.position);
    }catch (e) {
      log("CAUGHT AN IN ERROR executePointerMoveBehavior ${e.toString()}",);
    }
  }



  void executePointerUpBehavior2(GamePlayState gamePlayState, ColorPalette palette, PointerUpEvent details, ScaffoldState scaffoldState, BuildContext context) {

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
    bool isDropPermitted = Helpers().validateTutorialDragDropGesture(gamePlayState,pointedElement);

    

    // Map<String,dynamic> behavior = 

    // user tapped on the background - PAUSE the game

    try {
      
      // late bool isTutorialFinished = Helpers().validateTutorialComplete(gamePlayState);
      // if (isTutorialFinished) {
      //   print("isTutorial finished? YES");
      //   GameLogic().executeTutorialStep(gamePlayState,context);
      // }       

      Helpers().validateTutorialComplete(gamePlayState,context);
      // release is not in forbidden zone
      if (!isTapInForbiddenZone) {
        
        if (!buyMoreModalOpen) {
          if (!isOpenMenuTile) {

              /// There are 6 possible outcomes out of 16 scenarios
              /// 1. releasing DRAGGING onto a BOARD tile that is ACTIVE and EMPTY
              /// 2. releasing while NOT DRAGGING onto a BOARD tile that is ACTIVE with a BODY
              /// 3. releasing while NOT DRAGGING onto a BOARD tile that is ACTIVE that is EMPTY
              /// 4. releasing while NOT DRAGGING onto a BOARD tile that is INACTIVE that is EMPTY
              /// 5. releasing while NOT DRAGGING onto a RESERVE tile that is ACTIVE that is EMPTY
              if (isTileBeingDragged) {



                // if (elementType=="board" && isActive==true && body=="" && swappingTile.isEmpty && isDropPermitted) {
                if (isDropPermitted) {

                  GameLogic().executeMove(context,details,gamePlayState,palette,pointedElement);


                } else {
                  print("you can't release a dragged tile here");
                }
              } else {

                // print(" ${swappingTile["key"]} | ${pointedElement["key"]} ");

                  // //execute open tile menu
                  if (swappingTile.isEmpty) {
                    print("--SWAPPING TILE IS EMPTY | isTileBeingDragged : $isTileBeingDragged --");
                    print("in theory, nothing happens here?");
                  //   print("open menu of options for a tile: explode, freeze, swap");
                  //   GameLogic().executeOpenTileMenu(gamePlayState, pointedElement);
                  } else {
                    print("--SWAPPING TILE IS **NOT** EMPTY--");
                    print("${pointedElement}");
                    if (pointedElement.isEmpty) {
                      GameLogic().cancelSwap(gamePlayState);
                    } else {
                      if (pointedElement["body"]!="") {
                        if (swappingTile["key"]!=pointedElement["key"]) {
                          GameLogic().executeSwap(gamePlayState,palette, context, pointedElement);
                        } else {
                          GameLogic().cancelSwap(gamePlayState);
                        }
                      }
                    }
                  } 
                

                if (elementType=="board" && isActive==true && body=="" && swappingTile.isEmpty) {

                  GameLogic().executeMove(context,details,gamePlayState,palette,pointedElement);
                
                }

                if (elementType=="board" && isActive==false && body=="" && !isTileBeingDragged) {
                  print("open menu of options for dead tile such as: revive, swap ");
                  // pointedElement.update("menuOpen", (v)=>true);
                  if (swappingTile.isEmpty) {
                    if (gamePlayState.isLongPress) {
                      GameLogic().executeOpenTileMenu(gamePlayState, pointedElement);
                    }
                  } else {
                    // print("acacaca??");
                    // print("swap with this inactive mf");
                    // executeSwap(gamePlayState,pointedElement);
                  }
                }

                

                if (elementType=="board" && body=="" && swappingTile.isNotEmpty) {
                  GameLogic().cancelSwap(gamePlayState);
                }

                if (elementType=="reserve" && isActive==true && body=="" && swappingTile.isEmpty) {
                  // GameLogic().executeTileTappedLogic(gamePlayState,pointedElement);
                  GameLogic().executeMove(context, details, gamePlayState,palette, pointedElement);
                }                
              }

          } else {
            print("menu tile ${gamePlayState.openMenuTile} is open");
            print("AND ALSO!!! THE FUKIN ISLONGPRESS?? ${gamePlayState.isLongPress}");
            if (gamePlayState.isLongPress) {
              print("okay you opened the menu. don't close it");
            } else {
              GameLogic().executeOpenMenuTapRelease(gamePlayState,palette, context,details);      
            }
          }

          // print(gamePlayState.)

          gamePlayState.setDraggedElementData(null);
          gamePlayState.setSelectedElementsWhileDrag([]);
          gamePlayState.setFocusedElement({});
        }
        else {
          gamePlayState.tileMenuBuyMoreModalData.update("open", (v)=>false);
          gamePlayState.tileMenuBuyMoreModalData.update("message", (v)=>"");
          gamePlayState.tileMenuBuyMoreModalData.update("options", (v)=>[]);
          GameLogic().executePauseDialogPopScope(gamePlayState,palette);
          gamePlayState.setIsGamePaused(false);
        }
      }


      gamePlayState.setCurrentGestureLocation(null);
      gamePlayState.setIsLongPress(false);
    } catch (e) {
      log("CAUGHT AN IN ERROR executePointerUpBehavior ${e.toString()}",);
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