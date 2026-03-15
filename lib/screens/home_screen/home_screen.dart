import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/components/background_painter.dart';
import 'package:scribby_flutter_v2/functions/game_logic.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/functions/initializations.dart';
import 'package:scribby_flutter_v2/functions/styling_utils.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/resources/auth_service.dart';
import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
import 'package:scribby_flutter_v2/resources/storage_methods.dart';
import 'package:scribby_flutter_v2/screens/game_over_screen/game_over_screen.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/ads/game_screen_banner_ad.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/painters/tile_painters.dart';
import 'package:scribby_flutter_v2/screens/game_screen/game_screen.dart';
import 'package:scribby_flutter_v2/screens/home_screen/components/coin_holdings.dart';
import 'package:scribby_flutter_v2/screens/home_screen/components/drawer_avatar.dart';
import 'package:scribby_flutter_v2/screens/home_screen/components/home_screen_drawer_button.dart';
import 'package:scribby_flutter_v2/screens/home_screen/components/home_screen_utils.dart';
import 'package:scribby_flutter_v2/screens/home_screen/components/new_game_dialog.dart';
import 'package:scribby_flutter_v2/screens/home_screen/components/new_rank_overlay.dart';
import 'package:scribby_flutter_v2/screens/home_screen/components/tutorial_modal.dart';
import 'package:scribby_flutter_v2/screens/home_screen/components/xp_holdings.dart';
import 'package:scribby_flutter_v2/screens/instructions_screen/instructions_screen.dart';
// import 'package:scribby_flutter_v2/screens/temp_screen.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Map<String,dynamic>> backgroundFigures = [];
  
  // final GlobalKey<ScaffoldState> _homeScaffoldKey = GlobalKey();

  late SettingsController settings;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    settings = Provider.of<SettingsController>(context,listen: false);
    Map<String,dynamic> userData = settings.userData.value as Map<String,dynamic>;

    print("userData: ${userData}");

    if (userData.isEmpty) {
      AuthService().signOut(settings);
    } else {
      bool tutorialComplete = userData["parameters"]["shownTutorialModal"] ?? false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!tutorialComplete) {

          setState(() {
            MediaQueryData mediaQueryData = MediaQuery.of(context);
            openTutorialModal(context, mediaQueryData);

            Map<String,dynamic> params = userData["parameters"];
            // if (params["shownTutorialModal"]!=)
            params.update("shownTutorialModal", (v) => true);
            settings.setUserData(userData);

            FirestoreMethods().updateParameters(settings, "shownTutorialModal", true);
          });
        }
      });

    }
    

    Random random = Random(); 

    final int numCols = 4;
    final int numRows = 4;
    for (int i=0; i<numRows; i++) {

      for (int j=0; j<numCols; j++) {

        late double dx = (random.nextDouble()  * (1 / numCols)) + ((1/numCols)*(i)) ;  //(random.nextDouble() * 100) / 100; 
        late double dy = (random.nextDouble()  * (1 / numRows)) + ((1/numRows)*(j)) ;
        final double size = (random.nextDouble() * 100) + 20;
        final double opacity = (random.nextDouble() * 0.2) + 0.05 ;
        final double angle = random.nextDouble() * 2 * pi;

        late Map<String,dynamic> figureObject = {
          "dx": dx,
          "dy": dy,
          "size": size,
          "opacity" : opacity,
          "angle": angle
        };
        backgroundFigures.add(figureObject);        

      }

    }
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsController>(
      builder: (context,settings,child) {

              final double scalor = Helpers().getScalor(settings);
              final GamePlayState gamePlayState = Provider.of<GamePlayState>(context,listen: false);

              return Consumer<ColorPalette>(
                builder: (context,palette,child) {
                  return PopScope(
                    canPop: false,
                    child: SafeArea(
                      
                      child: Stack(
                        children: [
                          Positioned(
                            // top: 1,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,//-MediaQuery.of(context).padding.top-MediaQuery.of(context).padding.bottom,
                              child: CustomPaint(
                                painter: GradientBackground(settings: settings, palette: palette, decorationData: backgroundFigures),
                              ),
                            ),
                          ),                   
                          Scaffold(
                            backgroundColor: const Color.fromARGB(0, 209, 209, 209),                   
                            appBar: AppBar(
                              backgroundColor: const Color.fromARGB(0, 49, 49, 49),
                              leading: Builder(
                                builder: (context) {
                                  return IconButton(
                                    onPressed: () {
                                      
                                      // if (Scaffold.of(context).isDrawerOpen != null) {
                                        if (Scaffold.of(context).isDrawerOpen) {
                                          // _homeScaffoldKey.currentState!.closeDrawer();
                                          Scaffold.of(context).closeDrawer();
                          
                                        } else {
                                          // _homeScaffoldKey.currentState!.openDrawer();
                                          Scaffold.of(context).openDrawer();
                                        }
                                      // }
                                    }, 
                                    color: palette.appBarText,
                                    icon: Icon(Icons.menu, color: palette.appBarText,)
                                  );
                                }
                              ),
                              actions: [
                                XPHoldings(),
                                CoinHoldings()
                              ],
                            ),
                          
                            drawer: Drawer(
                              // backgroundColor: palette.bg1,
                              backgroundColor: palette.drawerBg,
                              width: MediaQuery.of(context).size.width*0.8,
                              child: Column(
                                children: [
                                                
                                  SizedBox(height: AppBar().preferredSize.height),
                                                
                                  Container(
                                    height: 200*scalor,
                                    child: Center(
                                      child: SizedBox(
                                        child: Center(
                                          child: Image.asset('assets/images/scribby_label_1.png'),
                                        ),
                                      )
                                    ),
                                  ),
                                    
                                  SizedBox(height: 22 * scalor,),
                                  HomeScreenDrawerButton(
                                    icon: Icons.question_mark,
                                    body: "How to Play?", 
                                    onPress: () => HomeScreenUtils().navigateToInstructionsScreen(context,true)
                                  ),
                                                                                    
                                  HomeScreenDrawerButton(
                                    icon: Icons.bar_chart,
                                    body: "Statistics", 
                                    onPress: () => HomeScreenUtils().navigateToUserGameHistoryScreen(context,true)
                                  ),
                                                
                                  HomeScreenDrawerButton(
                                    icon: Icons.person_4_outlined,
                                    body: "User Profile", 
                                    onPress: () => HomeScreenUtils().navigateToUserProfileScreen(context,true)
                                  ),
                              
                              
                              
                                  Expanded(child: SizedBox()),
                              
                              
                                                
                                  HomeScreenDrawerButton(
                                    icon: Icons.close,
                                    body: "Sign Out", 
                                    onPress: () => AuthService().signOut(settings)
                                  ),
                              
                                ],
                              ),
                          
                            ),
                              
                            body: Padding(
                              padding: EdgeInsets.fromLTRB( 30.0 * scalor,10.0 * scalor,30.0 * scalor,30.0 * scalor),
                              child: Column(
                                children: [
                              
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: Stack(
                                        children: [
              
                                            // CustomPaint(
                                            //   painter: ScribbyLogoPainter(settings: settings, palette: palette),
                                            // ),
              
                                          
              
                                          Column(
                                            children: [
                                              Expanded(
                                                flex: 9,
                                                child: Container(
                                                  width: double.infinity,
                                                  // height: double.infinity,                                          
                                                  decoration: BoxDecoration(
                                                    color: palette.navigationButtonBg1,
                                                    borderRadius: BorderRadius.all(Radius.circular(12.0 * scalor))
                                                  ),
              
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: SizedBox()
                                                        ),
                                                        Expanded(
                                                          flex: 3,
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Flexible(
                                                                child: Text(
                                                                  "Pick up where we left off...",
                                                                  style: palette.mainAppFont(
                                                                    textStyle: TextStyle(
                                                                    color: palette.navigationButtonText1,
                                                                    fontWeight: FontWeight.w700,
                                                                    fontSize: 26*scalor
                                                                    )
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(height: 20,),
                                                              ElevatedButton(
                                                                style: ElevatedButton.styleFrom(
                                                                  backgroundColor: palette.navigationButtonBg3,
                                                                  foregroundColor: palette.navigationButtonText3,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.all(Radius.circular(8*scalor))
                                                                  ),
                                                                  shadowColor: palette.widgetShadow1,
                                                              
                                                                ),
                                                                onPressed: () =>HomeScreenUtils().navigateToDailyPuzzlesScreen(context,false),
                                                                
                                                                child: Text(
                                                                  "Daily Puzzles",
                                                                  style: palette.mainAppFont(
                                                                    // color: Colors.white,
                                                                    textStyle: TextStyle(
                                                                      fontSize: 18*scalor,
                                                                    ),
                                                                  ),
                                                                )
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
              
                                                ),
                                              ),
                                              Expanded(flex:1, child: SizedBox())
                                            ],
                                          ),
              
                                          IgnorePointer(
                                            child: SizedBox(
                                              width: double.infinity,
                                              height: double.infinity,
                                              child: CustomPaint(
                                                painter: ScribbyLogoPainter(settings: settings, palette: palette),
                                              ),
                                            ),
                                          ),                                            
                                          // Positioned(
                                          //   bottom: -5,
                                          //   left: -40,
                                          //   child: SizedBox(
                                          //     width: 200,
                                          //     height: 200,
                                          //     child: Image(
                                          //       semanticLabel: "",
                                          //       image: AssetImage(
                                          //         'assets/images/home_page_tiles.png'
                                          //       )
                                          //     ),
                                          //   ),
                                          // )
                                        ],
                                      ),
                                    )
                                  ),
              
                                  // SizedBox(height: 30 * scalor,),
                              
                                  Expanded(
                                    flex: 5,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child:Container(
                                                  decoration: BoxDecoration(
                                                    color: palette.navigationButtonBg2,
                                                    borderRadius: BorderRadius.all(Radius.circular(12.0 * scalor))
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        width: double.infinity,
                                                        height: double.infinity,
                                                        // decoration: BoxDecoration(
                                                        //   color: palette.navigationButtonBg1,
                                                        //   borderRadius: BorderRadius.all(Radius.circular(12.0 * scalor))
                                                        // ),
                                                        child: CustomPaint(
                                                          painter: HowToPlayTilePainter(settings: settings, palette: palette),
                                                        ),
                                                      ),
              
              
                                                      Padding(
                                                        padding: EdgeInsets.all(12.0*scalor),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                "How to Play",
                                                                style: palette.mainAppFont(
                                                                  // color: Colors.white,
                                                                  textStyle: TextStyle(
                                                                    fontSize: 22*scalor,
                                                                    color: palette.navigationButtonText2
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            
                                                            Expanded(
                                                              child: Align(
                                                                alignment: Alignment.centerLeft,
                                                                child: ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                    backgroundColor: palette.widget1,
                                                                    foregroundColor: palette.widgetText1,
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.all(Radius.circular(8*scalor))
                                                                    ),
                                                                    padding: EdgeInsets.all(8.0*scalor),
                                                                    elevation: 3.0 *scalor
                                                                  ),
                                                                  onPressed: () => HomeScreenUtils().navigateToInstructionsScreen(context,false),
                                                                  child: FittedBox(
                                                                    fit: BoxFit.scaleDown,
                                                                    child: Row(
                                                                      children: [
                                                                        Icon(Icons.help,size: 18 * scalor,),
                                                                        SizedBox(width: 10*scalor,),
                                                                        Text(
                                                                        "Instructions",
                                                                          style: palette.mainAppFont(
                                                                            // color: Colors.white,
                                                                            textStyle: TextStyle(
                                                                              fontSize: 18*scalor,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(width: 10*scalor,),
                                                                      ],
                                                                    ),
                                                                  ),                                                                
                                                                  
                                                                ),
                                                              ),
                                                            ),
              
                                                            Expanded(
                                                              child: Align(
                                                                alignment: Alignment.centerLeft,
                                                                child: ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                    backgroundColor: palette.navigationButtonBg3,
                                                                    foregroundColor: palette.navigationButtonText3,
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.all(Radius.circular(8*scalor))
                                                                    ),
                                                                    padding: EdgeInsets.all(8.0*scalor),
                                                                    elevation: 3.0 *scalor
                                                                  ),
                                                                  onPressed: () => HomeScreenUtils().navigateToTutorial(context,gamePlayState,settings, palette),
                                                                  child: FittedBox(
                                                                    fit: BoxFit.scaleDown,
                                                                    child: Row(
                                                                      children: [
                                                                        Icon(Icons.play_arrow,size: 18 * scalor,),
                                                                        SizedBox(width: 10*scalor,),
                                                                        Text(
                                                                        "Tutorial",
                                                                          style: palette.mainAppFont(
                                                                            // color: Colors.white,
                                                                            textStyle: TextStyle(
                                                                              fontSize: 18*scalor,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(width: 10*scalor,),
                                                                      ],
                                                                    ),
                                                                  ),                                                                
                                                                  
                                                                ),
                                                              ),
                                                            ),                                                            
                                                            
                                                            
              
              
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                // child: ElevatedButton(
                                                //   style: ElevatedButton.styleFrom(
                                                //     backgroundColor: palette.widget2,
                                                //     foregroundColor: palette.widgetText2,
                                                //     shape: RoundedRectangleBorder(
                                                //       borderRadius: BorderRadius.all(Radius.circular(8*scalor))
                                                //     ),
                                                //     // shadowColor: palette.widgetShadow1,
                                                //     padding: EdgeInsets.all(8.0*scalor)
                                                
                                                //   ),
                                                //   onPressed: () => HomeScreenUtils().navigateToTutorial(context,gamePlayState,settings),
                                                //   // child: Padding(
                                                //     // padding: EdgeInsets.all(8.0 * scalor),
                                                //     child: Stack(
                                                //       // crossAxisAlignment: CrossAxisAlignment.start,
                                                //       children: [
                                                
                                                //         SizedBox(
                                                //           width: double.infinity,
                                                //           height: double.infinity,
                                                //           child: CustomPaint(
                                                //             painter: HowToPlayTilePainter(settings: settings, palette: palette),
                                                //           ),
                                                //         ),
                                                //         Text(
                                                //           "How to Play?",
                                                //           style: palette.mainAppFont(
                                                //             // color: Colors.white,
                                                //             textStyle: TextStyle(
                                                //               fontSize: 22*scalor,
                                                //             ),
                                                //           ),
                                                //         ),
                                                //         // Flexible(
                                                //         //   child: Image(
                                                //         //     semanticLabel: "",
                                                //         //     image: AssetImage(
                                                //         //       'assets/images/how_to_play_icon.png'
                                                //         //     )
                                                //         //   ),
                                                //         // ),                                                        
                                                                                                    
                                                //       ],
                                                //     ),
                                                //   // ),
                                                // )
                                              ),
              
                                              SizedBox(height: 20,),
                              
                                              Expanded(
                                                flex: 1,
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: palette.navigationButtonBg3,
                                                    foregroundColor: palette.navigationButtonText3,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.all(Radius.circular(8*scalor))
                                                    ),
                                                    // shadowColor: palette.widgetShadow1,
                                                    padding: EdgeInsets.all(8.0*scalor)
                                                
                                                  ),
                                                  onPressed: () => HomeScreenUtils().navigateToShopScreen(context, false),
                                                  child: Stack(
                                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                                                                  
              
                                                      SizedBox(
                                                        width: double.infinity,
                                                        height: double.infinity,
                                                        child: CustomPaint(
                                                          painter: ShopTilePainter(settings: settings, palette: palette),
                                                        ),
                                                      ),                                                        
              
                                                                                                              
                                                      FittedBox(
                                                        fit: BoxFit.scaleDown,
                                                        child: Text(
                                                          "Shop",
                                                          style: palette.mainAppFont(
                                                            // color: Colors.white,
                                                            textStyle: TextStyle(
                                                              fontSize: 24*scalor,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
              
                                                      Center(child: Icon(Icons.store_rounded, size: 100 * scalor, color: palette.text1.withAlpha(255),))
                                                      // Flexible(
                                                      //   child: Image(
                                                      //     semanticLabel: "",
                                                      //     image: AssetImage(
                                                      //       'assets/images/shop_image.png'
                                                      //     )
                                                      //   ),
                                                      // ),                                                       
                                                    ],
                                                  ),                                                  
                                                ),
                                              ),                                            
                                            ],
                                          )
                                        ),
                                        SizedBox(width: 20,),
              
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  decoration: BoxDecoration(
                                                    // color: const Color.fromARGB(255, 168, 168, 214),
                                                    borderRadius: BorderRadius.all(Radius.circular(12.0 * scalor))
                                                  ),
              
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: palette.navigationButtonBg3,
                                                      foregroundColor: palette.navigationButtonText3,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(8*scalor))
                                                      ),
                                                      // shadowColor: palette.widgetShadow1,
                                                      padding: EdgeInsets.all(8.0*scalor)
                                                  
                                                    ),
                                                    // onPressed: () => HomeScreenUtils().navigateToLeaderboardsScreen(context,false),
                                                    onPressed: () => HomeScreenUtils().navigateToGameHistoryScreen(context,false),
                                                    child: Stack(
                                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [                                          
                                                        Center(
                                                          child: FittedBox(
                                                            fit: BoxFit.scaleDown,
                                                            child: Text(
                                                              "Game History",
                                                              style: palette.mainAppFont(
                                                                // color: Colors.white,
                                                                textStyle: TextStyle(
                                                                  fontSize: 24*scalor,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ),
                                              SizedBox(height: 20,),
                                              Expanded(
                                                flex: 3,
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: palette.navigationButtonBg1,
                                                    foregroundColor: palette.navigationButtonText1,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.all(Radius.circular(8*scalor))
                                                    ),
                                                    // shadowColor: palette.widgetShadow1,
                                                    padding: EdgeInsets.all(8.0*scalor)
                                                
                                                  ),
                                                  onPressed: () => HomeScreenUtils().navigateToUserGameHistoryScreen(context,false),                                                  
                                                  child: Stack(
                                                    children: [
                                                      // Positioned.fill(
                                                      //   child: Image(
                                                      //     semanticLabel: "",
                                                      //     image: AssetImage('assets/images/analytics_image.jpeg'),
                                                      //     fit: BoxFit.cover,
                                                      //   ),
                                                      // ),
                                                                                                  
                                                      SizedBox(
                                                        width: double.infinity,
                                                        height: double.infinity,
                                                        child: CustomPaint(
                                                          painter: StatsTile(settings: settings, palette: palette),
                                                        ),
                                                      ),
              
                                                      Column(
                                                        children: [
                                                          Text(
                                                            "Stats & Badges",
                                                            softWrap: true,
                                                            overflow: TextOverflow.visible,
                                                            style: palette.mainAppFont(
                                                              textStyle: TextStyle(
                                                                fontSize: 24 * scalor,
                                                                color: palette.navigationButtonText1, // Optional: for visibility over image
                                                              ),
                                                            ),
                                                          ),
                                                          Center(child: Icon(Icons.bar_chart, size: 100 * scalor, color: palette.navigationButtonText1.withAlpha(200),))                                                          
              
              
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 20,),
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: Colors.transparent, //const Color.fromARGB(255, 134, 100, 255),
                                                    borderRadius: BorderRadius.all(Radius.circular(12.0 * scalor))
                                                  ),
              
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: palette.navigationButtonBg2,
                                                      foregroundColor: palette.navigationButtonText2,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(8*scalor))
                                                      ),
                                                      // shadowColor: palette.widgetShadow1,
                                                      padding: EdgeInsets.all(8.0*scalor)
                                                  
                                                    ),
                                                    onPressed: () => HomeScreenUtils().navigateToUserProfileScreen(context, false),
                                                    child: Stack(
                                                      children: [                                          
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
              
                                                            Icon(Icons.person_2, size: 26 * scalor, color: palette.navigationButtonText2,),
                                                            SizedBox(width: 10*scalor,),
                                                            Text(
                                                              "Profile",
                                                              style: palette.mainAppFont(
                                                                // color: Colors.white,
                                                                textStyle: TextStyle(
                                                                  fontSize: 24*scalor,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),                                                                                                   
              
                                                )
                                              ),                                                                                            
                                            ],
                                          ),
                                        ),                                      
                                      ],
                                    )
                                  ),
                                  SizedBox(height: 20,),
              
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: palette.navigationButtonBg3,
                                          foregroundColor: palette.navigationButtonText3,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(8*scalor))
                                          ),
                                          shadowColor: palette.widgetShadow1,
                                      
                                        ),
                                        onPressed: () {
                                          openNewGameDialog(context, MediaQuery.of(context));
                                        },
                                        
                                        child: Text(
                                          "New Game!",
                                          style: palette.mainAppFont(
                                            // color: Colors.white,
                                            textStyle: TextStyle(
                                              fontSize: 36*scalor,
                                            ),
                                          ),
                                        )
                                      ),
                                    )
                                  )
                                          
                                ],
                              ),
                            ),
                            // bottomNavigationBar: GameScreenBannerAd(),
                          ),
              
                          // Overlay()
                          NewRankOverlay()
                        ],
                      )
                    ),
                  );
                }
              );        
      }
    );
  }
}


List<Widget> listDailyPuzzles(double scalor) {
  List<Widget> res = [];
  for (int i=0; i<8;i++) {
    Widget widget = Padding(
      padding: EdgeInsets.all(2.0*scalor),
      child: Container(
        width: 155*scalor,
        height: 55*scalor,
        // height: 50,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 56, 56, 56)
        ),            
        child: Padding(
          padding: EdgeInsets.all(8.0*scalor),
          child: Center(
            child: Text(
              (i+1).toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18*scalor
              ),
            ),
          ),
        ),
      ),
    );
    res.add(widget);
  }
  return res;
}




// Future<void> initializeAppData(SettingsController settings, ColorPalette palette) async {


//   // if local storage is empty - get the level data as json payload and set it
//   // levels to play
//   await StorageMethods().saveLevelDataFromJsonFileToLocalStorage(settings);
//   // text explaining the types of games
//   await StorageMethods().saveGameInfoDataFromJsonFileToLocalStorage(settings);

//   if (settings.achievementData.value.isEmpty) {
//     // print("loading achievements");
//     await StorageMethods().saveAchievementDataFromJsonFileToLocalStorage(settings);
//   }
//   if (settings.rankData.value.isEmpty) {
//     print("loading ranks");
//     await StorageMethods().saveRankDataFromJsonFileToLocalStorage(settings);
//   }



//   await saveDeviceSizeInfoToSettings(settings);


  
//   // print("deviceSizeInfo runtimeType: ${settings.deviceSizeInfo.value.runtimeType}");
//   // print("deviceSizeInfo value: ${settings.deviceSizeInfo.value}");

//   // print("userData runtimeType: ${settings.userData.value.runtimeType}");
//   // print("userData value: ${settings.userData.value}");  

//   // List<dynamic> userDataList = settings.userData.value as List<dynamic>;
//   // for (dynamic item in userDataList) {
//   //   print(item);
//   //   print("=========");
//   // }
//   // Map<String,dynamic> userData = userDataList[0];
  
//   // print(userData);
//   // settings.setXP(849);
  
//   Map<String,dynamic> userData = settings.userData.value as Map<String,dynamic>;
//   // if (userData.isEmpty) {
//   //   print("add template data");
//   //   Object newUserData = {
//   //     "username": Helpers().generateRandomUsername(),
//   //     "displayName": "User",
//   //     "email" : "user@gmail.com",
//   //     "rank": "1_1",
//   //     "language": "en",
//   //     "photoUrl": null,
//   //     "soundOn": true,
//   //     "colorTheme":"default",
//   //     "createdAt": DateTime.now().toIso8601String(),
//   //   };
//   //   settings.setUserData(newUserData);
//   // } 
//   // else {
//   //   userData.update("rank", (v)=>"4_4");
//   // }
//   if (userData["colorTheme"] != null) {
//     palette.getThemeColors(userData["colorTheme"]);
//   } else {
//     palette.getThemeColors("default");
//   }

//   // Object userData = {
//   //   "username": "Mimou the Terrible",
//   //   "displayName": "Mimou Grimm",
//   //   "email" : "mimou.grimm@gmail.com",
//   //   "language": "english",
//   //   "photoUrl": "",
//   // };

  




// }


Future<void> openTutorialModal(BuildContext context, MediaQueryData mediaQueryData) async {

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return TutorialDialog(mediaQueryData: mediaQueryData,);
    }
  );
}




Future<void> openNewGameDialog(BuildContext context, MediaQueryData mediaQueryData) async {

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return NewGameDialog(mediaQueryData: mediaQueryData,);
    }
  );
}


Future<void> saveDeviceSizeInfoToSettings(SettingsController settings) async {
  // First get the FlutterView.
  FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;

  // // Dimensions in physical pixels (px)
  // Size size = view.physicalSize;
  // double width = size.width;
  // double height = size.height;
  // Dimensions in logical pixels (dp)
  Size size = view.physicalSize / view.devicePixelRatio;

  print("----------------- ${view.physicalSize} --------------------");
  double width = size.width;
  double height = size.height;
  final double standardHeight = 890;
  final double scalor = height/standardHeight;

  Object deviceSizeInfo = {
    "width": width,
    "height":height,
    "scalor":scalor,
  };

  settings.setDeviceSizeInfo(deviceSizeInfo);

}


class HowToPlayTilePainter extends CustomPainter {
  final SettingsController settings;
  final ColorPalette palette;
  const HowToPlayTilePainter({
    required this.settings,
    required this.palette,
  });

  @override
  void paint(Canvas canvas, Size size) {

    // Paint decorationSquarePaint = Paint();
    // final double boardWidth = size.width *0.7;
    // final Offset boardCenter = Offset(size.width*0.5, size.height*0.6);
    // final double boardLeftX = boardCenter.dx - boardWidth/2; 
    // final double boardTopY = boardCenter.dy - boardWidth/2;


    List<Map<String,dynamic>> tileInfo = [
      {"offset": [0.50,0.50], "angle": 0.20 * pi, "size": 22.0 },
      {"offset": [0.20,0.30], "angle": 1.20 * pi, "size": 18.0 },
      {"offset": [0.50,0.30], "angle": 0.80 * pi, "size": 35.0 },
      {"offset": [0.80,0.20], "angle": 1.70 * pi, "size": 22.0 },
      {"offset": [0.10,0.40], "angle": 1.90 * pi, "size": 21.0 },
      {"offset": [0.30,0.63], "angle": 0.02 * pi, "size": 36.0 },
      {"offset": [0.12,0.83], "angle": 1.53 * pi, "size": 25.0 },
      {"offset": [0.72,0.62], "angle": 0.40 * pi, "size": 25.0 },
      {"offset": [0.85,0.42], "angle": 0.30 * pi, "size": 25.0 },
      {"offset": [0.62,0.80], "angle": 0.20 * pi, "size": 18.0 },


    ];

    final int red = (255*palette.navigationButtonBg1.r).round();
    final int green = (255*palette.navigationButtonBg1.g).round();
    final int blue = (255*palette.navigationButtonBg1.b).round();

    Paint rectPaint = Paint()
    ..color = Color.fromARGB(50, red, green, blue);

    for (int i=0; i< tileInfo.length; i++) {
      Map<String,dynamic> tileData = tileInfo[i];
      Offset tileCenter = Offset(size.width * tileData["offset"][0],size.height * tileData["offset"][1]);
      canvas.save();      

      canvas.translate(tileCenter.dx, tileCenter.dy);
      canvas.rotate(tileData["angle"]);
      canvas.translate(-tileCenter.dx, -tileCenter.dy);

      Rect rect = Rect.fromCenter(center: tileCenter, width: tileData["size"], height: tileData["size"]);
      RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(tileData["size"]*0.2));
      canvas.drawRRect(rrect, rectPaint);


      final int textRed = (255*palette.navigationButtonText3.r).round();
      final int textGreen = (255*palette.navigationButtonText3.g).round();
      final int textBlue = (255*palette.navigationButtonText3.b).round();      

      final textPainter = TextPainter(
        text: TextSpan(
          text: "?",
          style: TextStyle(
            fontSize: tileData["size"]*0.8,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(50, textRed, textGreen, textBlue),//Color.fromARGB(255, 143, 143, 143),
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      final textOffset = Offset(tileCenter.dx-textPainter.width / 2, tileCenter.dy-textPainter.height / 2);
      textPainter.paint(canvas, textOffset);               


      canvas.restore();      
    }



    // List<Map<String,dynamic>> tileInfo = [
    //   {"row": 1, "col":0, "body": "P"},
    //   {"row": 1, "col":1, "body": "L"},
    //   {"row": 1, "col":2, "body": "S"},

    //   {"row": 2, "col":0, "body": "H"},
    //   {"row": 2, "col":1, "body": "E"},
    //   {"row": 2, "col":2, "body": "L"},
    //   {"row": 2, "col":3, "body": "P"},
    // ];
    
    // for (int i=0; i<4; i++) {

    //   for (int j=0; j<4; j++) {

    //     decorationSquarePaint.color = Color.fromRGBO(255, 255, 255, 0.7);
    //     final double squareSize = boardWidth/4;
    //     final double tileX = boardLeftX + (j * squareSize) + (squareSize/2);
    //     final double tileY = boardTopY + (i * squareSize) + (squareSize/2);

    //     Rect rect = Rect.fromCenter(center: Offset(tileX,tileY), width: squareSize*0.8, height: squareSize*0.8);
    //     RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(squareSize*0.15));


    //     canvas.drawRRect(rrect, decorationSquarePaint);

    //     Map<String,dynamic> tileObject = tileInfo.firstWhere((e) => e["row"]==i && e["col"]==j, orElse: ()=>{});
    //     final textPainter = TextPainter(
    //       text: TextSpan(
    //         text: tileObject["body"],
    //         style: TextStyle(
    //           fontSize: 12,
    //           fontWeight: FontWeight.bold,
    //           color: Color.fromARGB(255, 12, 12, 12),
    //         ),
    //       ),
    //       textAlign: TextAlign.center,
    //       textDirection: TextDirection.ltr,
    //     );
    //     textPainter.layout();

    //     final textOffset = Offset(tileX-textPainter.width / 2, tileY-textPainter.height / 2);
    //     textPainter.paint(canvas, textOffset);            
    //   }

    // }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ShopTilePainter extends CustomPainter {
  final SettingsController settings;
  final ColorPalette palette;
  const ShopTilePainter({
    required this.settings,
    required this.palette,
  });

  @override
  void paint(Canvas canvas, Size size) {




    List<Map<String,dynamic>> circles = [
      {"center": Offset(size.width*0.2, size.height*0.4), "size" : 10.0, "width":30.0,},
      {"center": Offset(size.width*0.7, size.height*0.5), "size" : 20.0, "width":30.0,},
      {"center": Offset(size.width*0.4, size.height*0.8), "size" : 10.0, "width":22.0,},
    ];
    for (int i=0; i < circles.length; i++) {
      Paint circlePaint = Paint()
      ..color = Color.lerp(palette.navigationButtonText2, Colors.transparent, 0.7)??Colors.transparent // const Color.fromARGB(225, 38, 29, 116)
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;
      // ..strokeWidth = circles[i]["width"];
        


      canvas.drawCircle(circles[i]["center"], circles[i]["size"], circlePaint);


    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}




class StatsTile extends CustomPainter {
  final SettingsController settings;
  final ColorPalette palette;
  const StatsTile({
    required this.settings,
    required this.palette,
  });

  @override
  void paint(Canvas canvas, Size size) {




    List<Map<String,dynamic>> circles = [
      {"center": Offset(size.width*0.5, size.height*0.15), "size" : 25.0, "width":30.0,},
      {"center": Offset(size.width*0.7, size.height*0.5), "size" : 20.0, "width":30.0,},
      {"center": Offset(size.width*0.4, size.height*0.8), "size" : 10.0, "width":22.0,},
      {"center": Offset(size.width*0.6, size.height*0.9), "size" : 10.0, "width":22.0,},
    ];
    for (int i=0; i < circles.length; i++) {
      Paint circlePaint = Paint()
      ..color = Color.lerp(palette.navigationButtonText1, Colors.transparent, 0.8)??palette.navigationButtonText1 //const Color.fromARGB(225, 38, 29, 116)
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;
      // ..strokeWidth = circles[i]["width"];
        


      canvas.drawCircle(circles[i]["center"], circles[i]["size"], circlePaint);


    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}



class ScribbyLogoPainter extends CustomPainter {
  final SettingsController settings;
  final ColorPalette palette;
  const ScribbyLogoPainter({
    required this.settings,
    required this.palette,
  });

  @override
  void paint(Canvas canvas, Size size) {


    // Map<dynamic,dynamic> userData = Map<dynamic,dynamic>.from(settings.userData.value as Map<dynamic,dynamic>);
    // userData.forEach((k,v) {
    //   print("$k : $v");
    // });


    final Color baseColor = const Color.fromARGB(255, 239, 240, 241);
    const Map<String,dynamic> offsetData  = {"dx1":0,"dy1":0, "dx2": 50, "dy2":50};

    List<Map<String,dynamic>> decorationData = [
      {"letter": "S", "offsets":[0.20,0.10], "angle": (1.90 * pi), "faceColor":const Color.fromARGB(255, 83, 157, 218), "gradientOffset": 1,},
      {"letter": "C", "offsets":[0.12,0.27], "angle": (0.27 * pi), "faceColor":const Color.fromARGB(255, 79, 33, 243), "gradientOffset": 2,},
      {"letter": "R", "offsets":[0.26,0.34], "angle": (1.95 * pi), "faceColor":const Color.fromARGB(255, 20, 116, 71), "gradientOffset": 3,},
      {"letter": "I", "offsets":[0.16,0.48], "angle": (0.02 * pi), "faceColor":const Color.fromARGB(255, 92, 52, 19), "gradientOffset": 0,},
      {"letter": "B", "offsets":[0.07,0.63], "angle": (0.124 * pi), "faceColor":const Color.fromARGB(255, 114, 28, 126), "gradientOffset": 3,},
      {"letter": "B", "offsets":[0.20,0.68], "angle": (0.03 * pi), "faceColor":const Color.fromARGB(255, 238, 86, 26), "gradientOffset": 2,},
      {"letter": "Y", "offsets":[0.32,0.75], "angle": (0.15 * pi), "faceColor":const Color.fromARGB(255, 223, 167, 16), "gradientOffset": 1,},
    ];     

    for (int i=0; i<decorationData.length; i++) {
      Map<String,dynamic> decorationObject = decorationData[i];
      final Offset tileCenter = Offset(size.width*decorationObject["offsets"][0], size.height*decorationObject["offsets"][1]);
      Map<String,dynamic> tileDecoration = {
        "offsetData":offsetData,
        "baseColor": baseColor,
        "bodyColor": Color.lerp(baseColor, Colors.white, 0.6)??baseColor,
        "edgeColors": [baseColor,Color.lerp(baseColor, Colors.black, 0.7)??Colors.black,],
        "faceColors":[decorationObject["faceColor"],decorationObject["faceColor"],],
        "gradientOffset" : decorationObject["gradientOffset"],
      };
      final double tileAngle = decorationObject["angle"];

      canvas.save();      
      canvas.translate(tileCenter.dx, tileCenter.dy);
      canvas.rotate(tileAngle);
      canvas.translate(-tileCenter.dx, -tileCenter.dy);      
      TilePainters().drawTile2(canvas, tileCenter, decorationObject["letter"], Size(45,45), "board-full", tileDecoration, palette);
      
      canvas.restore();      

    }



  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

Future<void> loadTutorialOpen(SettingsController settings, BuildContext context) async {
  Map<String,dynamic> userData = settings.user.value as Map<String,dynamic>;
  bool tutorialShown = userData["parameters"]["shownTutorialModal"];
  if (!tutorialShown) {
    openTutorialModal(context, MediaQuery.of(context));
  }
} 