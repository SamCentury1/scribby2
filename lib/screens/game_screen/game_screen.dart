import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/ads/ad_mob_service.dart';
import 'package:scribby_flutter_v2/ads/banner_ad_widget.dart';
import 'package:scribby_flutter_v2/components/background_painter.dart';
import 'package:scribby_flutter_v2/functions/animations.dart';
import 'package:scribby_flutter_v2/functions/game_logic.dart';
import 'package:scribby_flutter_v2/functions/gestures.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/functions/initializations.dart';
import 'package:scribby_flutter_v2/providers/ad_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/ads/game_screen_banner_ad.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/dialogs/buy_more_dialog.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/dialogs/start_game_dialog.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/drawer/game_screen_drawer.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/painters/bonus_painters.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/painters/main_canvas_painter.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/painters/navigation_painters.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/painters/painters.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/painters/scoreboard_painters.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/painters/stop_watch_painters.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/painters/tile_painters.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/painters/tutorial_painters.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with WidgetsBindingObserver {

  int? _activePointerId; // Tracks the active pointer ID
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  // late BannerAd _bannerAd;
  // bool _isBannerAdLoaded = false;
  // late AdState _adState;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // initializeBannerAd();

    
  }


  @override
  Widget build(BuildContext context) {
    // final banner = context.watch<AdState>().bannerAd;
    // _banner = _adState.bannerAd;
    return Consumer<GamePlayState>(
      builder: (context,gamePlayState,child) {
        SettingsController settings = Provider.of<SettingsController>(context,listen: false);
        ColorPalette palette = Provider.of<ColorPalette>(context,listen: false);

        // bool isModalOpen = gamePlayState.tileMenuBuyMoreModalData["open"]??false;


        final double menuPositionTop = MediaQuery.of(context).padding.top-5;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            Initializations().resizeScreen(gamePlayState, MediaQuery.of(context));

            GameLogic().validateTutorialFinish(context, gamePlayState, settings);
          });
        });


    
        GameLogic().checkTimeExpired(context,gamePlayState);

        

        // GameLogic().validateLongPress(context,gamePlayState,palette);

        return PopScope(
          canPop: false,
          child: Consumer<ColorPalette>(
            builder: (context,palette,child) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,            
                child: Stack(
                  children: [
                    // CustomPaint(
                    //   painter: GradientBackground(settings: settings, palette: palette, decorationData: []),
                    // ),             
                    // CustomPaint(painter: GradientBackground(palette: palette, settings: settings, decorationData: []),), 
                    Scaffold(
                      // backgroundColor: Colors.transparent,
                      key: _scaffoldKey,
                      onDrawerChanged: (var details) {
                        GameLogic().executePauseDialogPopScope(gamePlayState,palette);
                        gamePlayState.setIsGamePaused(false);
                      },
                      drawer: GameScreenDrawer(scaffoldState: _scaffoldKey.currentState,),
                      body: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                      
                            child: Listener(
                              onPointerDown: (PointerDownEvent details) {
                    

                    
                                if (_activePointerId == null) {
                                  _activePointerId = details.pointer;
                                  Gestures().executePointerDownBehavior(gamePlayState, details);
                                }                  
                              },
                              onPointerMove: (PointerMoveEvent details) {     
                                if (_activePointerId == details.pointer) {
                                  Gestures().executePointerMoveBehavior(gamePlayState, details);
                                }                    
                              },
                              onPointerUp: (PointerUpEvent details) {
                                if (_activePointerId == details.pointer) {
                                  Gestures().executePointerUpBehavior2(gamePlayState,palette,details,_scaffoldKey.currentState!, context);
                                  // Gestures().executePointerUpBehavior3(gamePlayState,palette,details,_scaffoldKey.currentState!, context);
                                  _activePointerId = null; // Reset the active pointer
                                }            
                              },
                              onPointerCancel: (PointerCancelEvent details) {
                                if (_activePointerId == details.pointer) {
                                  _activePointerId = null; // Reset the active pointer
                                }                         
                              },
                              child: CustomPaint(
                                painter: MainCanvasPainter(gamePlayState: gamePlayState,palette: palette)
                              ),
                            ),
                      
                      ),
                    ),
                
                
                    Positioned(
                      top: menuPositionTop,
                      left: MediaQuery.of(context).size.width*0.01,
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child:gamePlayState.isGamePaused 
                        ? SizedBox()
                        :  IconButton(
                          onPressed: () {
                            _scaffoldKey.currentState!.openDrawer();
                            print("================ ALPHABET STATE =====================");
                            for (Map<String,dynamic> alphabetObject in gamePlayState.alphabet) {
                              print(alphabetObject);
                            }
                            print("=======================================================");

                            gamePlayState.setIsGamePaused(true);             
                          }, 
                          icon: Icon(
                            Icons.menu,
                            size:30,
                            color: palette.text1
                          )
                        ),
                      ) 
                    ),
                        
                    BuyMoreModal(),
                
                    StartGameOverlay(),

                  ],
                ),
              );
            }
          ),
        );
      }
    );    
  }
}