// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';

// import 'package:provider/provider.dart';
// import 'package:scribby_flutter_v2/components/background_painter.dart';
// import 'package:scribby_flutter_v2/functions/game_logic.dart';
// import 'package:scribby_flutter_v2/functions/gestures.dart';
// import 'package:scribby_flutter_v2/functions/helpers.dart';
// import 'package:scribby_flutter_v2/functions/initializations.dart';

// import 'package:scribby_flutter_v2/providers/game_play_state.dart';

// import 'package:scribby_flutter_v2/screens/game_screen/components/dialogs/buy_more_dialog.dart';
// import 'package:scribby_flutter_v2/screens/game_screen/components/dialogs/start_game_dialog.dart';
// import 'package:scribby_flutter_v2/screens/game_screen/components/drawer/game_screen_drawer.dart';

// import 'package:scribby_flutter_v2/screens/game_screen/components/painters/main_canvas_painter.dart';


// class GameScreen extends StatefulWidget {
//   const GameScreen({super.key});

//   @override
//   State<GameScreen> createState() => _GameScreenState();
// }

// class _GameScreenState extends State<GameScreen> with WidgetsBindingObserver {

//   int? _activePointerId; // Tracks the active pointer ID
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     // initializeBannerAd();
//   }


//   @override
//   Widget build(BuildContext context) {

//     return Consumer<GamePlayState>(
//       builder: (context,gamePlayState,child) {

//           final double menuPositionTop = MediaQuery.of(context).padding.top-5;

//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             setState(() {
//               Initializations().resizeScreen(gamePlayState, MediaQuery.of(context));
//             });
//           });



//           if (gamePlayState.isLongPress) {

//             Map<String,dynamic> pointedElement = Helpers().getPointerElement(gamePlayState, gamePlayState.currentGestureLocation!);
//             Map<String,dynamic> swappingTile = Helpers().getSwappingTile(gamePlayState);
//             bool isOpenMenuTile = gamePlayState.openMenuTile==null ? false : true;

//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               setState(() {

//                 if (!isOpenMenuTile) {
//                   if (pointedElement["type"]!="reserve") {
//                     if (swappingTile.isEmpty) {
//                       print("open menu of options for a tile: explode, freeze, swap");
//                       GameLogic().executeOpenTileMenu(gamePlayState, pointedElement);
//                     } else {
//                       print("swap with this guy!");

//                       if (swappingTile["key"]!=pointedElement["key"]) {
//                         print("swapping tile: ${swappingTile["key"]} | pointed element: ${pointedElement["key"]}");
//                         GameLogic().executeSwap(gamePlayState,pointedElement);
//                       } else {
//                         Helpers().cancelSwap(gamePlayState);
//                       }
//                     }
//                   }
//                 }

//               });
//             });            
//           }
        
    
//         // print("tile state = ${gamePlayState.tileData}");
//         // final AnimationState animationState = Provider.of<AnimationState>(context, listen: false);
//         return PopScope(
//           canPop: false,
//           child: SizedBox(
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height,            
//             child: Stack(
//               children: [
//                 CustomPaint(painter: GradientBackground(),),              
//                 Scaffold(
//                   // backgroundColor: Colors.transparent,
//                   key: _scaffoldKey,
//                   onDrawerChanged: (var details) {
//                     GameLogic().executePauseDialogPopScope(gamePlayState);
//                     gamePlayState.setIsGamePaused(false);
//                   },
//                   drawer: GameScreenDrawer(scaffoldState: _scaffoldKey.currentState,),
//                   body: SizedBox(
//                     width: MediaQuery.of(context).size.width,
//                     height: MediaQuery.of(context).size.height,
                  
//                         child: Listener(
//                           onPointerDown: (PointerDownEvent details) {
                
//                             bool isTapInForbiddenZone = Helpers().getIsTapInForbiddenZone(details,gamePlayState);
                
//                             if (isTapInForbiddenZone) {
//                               print("tapping in forbidden zone");
//                               return;
//                             }
                
//                             if (_activePointerId == null) {
//                               _activePointerId = details.pointer;
//                               // GameLogic().executePointerDownBehavior(gamePlayState, animationState, details);
//                               Gestures().executePointerDownBehavior(gamePlayState, details);
//                             }                  
//                           },
//                           onPointerMove: (PointerMoveEvent details) {          
//                             if (_activePointerId == details.pointer) {
//                               Gestures().executePointerMoveBehavior(gamePlayState, details);
//                             }                    
//                           },
//                           onPointerUp: (PointerUpEvent details) {
                
//                             if (_activePointerId == details.pointer) {
//                               Gestures().executePointerUpBehavior2(gamePlayState,details,_scaffoldKey.currentState!, context);
//                               // GameLogic().executePointerUpBehavior(context,gamePlayState,animationState,  details,_scaffoldKey.currentState!);
//                               _activePointerId = null; // Reset the active pointer
//                             }            
//                           },
//                           onPointerCancel: (PointerCancelEvent details) {
//                             if (_activePointerId == details.pointer) {
//                               _activePointerId = null; // Reset the active pointer
//                             }                         
//                           },
//                           child: CustomPaint(
//                             painter: MainCanvasPainter(gamePlayState: gamePlayState)
//                           ),
//                         ),
                  
//                   ),
//                 ),
            
            
//                 Positioned(
//                   top: menuPositionTop,
//                   left: MediaQuery.of(context).size.width*0.01,
//                   child: SizedBox(
//                     width: 50,
//                     height: 50,
//                     child:gamePlayState.isGamePaused 
//                     ? SizedBox()

//                     :  IconButton(
//                       onPressed: () {
//                         _scaffoldKey.currentState!.openDrawer();
//                         gamePlayState.setIsGamePaused(true);              
//                       }, 
//                       icon: Icon(
//                         Icons.menu,
//                         size:30,
//                         color: Color.fromRGBO(233, 233, 233, 1.0)
//                       )
//                     ),
//                   ) 
//                 ),
                    
//                 BuyMoreModal(),
            
//                 StartGameOverlay(),

                
//               ],
//             ),
//           ),
//         );
//       }
//     );    
//   }
// }

