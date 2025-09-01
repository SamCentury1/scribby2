import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/animations.dart';
import 'package:scribby_flutter_v2/functions/game_logic.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/ad_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'dart:ui' as ui;

import 'package:scribby_flutter_v2/screens/game_screen/components/painters/navigation_painters.dart';
import 'package:scribby_flutter_v2/screens/home_screen/home_screen.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';

class BuyMoreModal extends StatefulWidget {
  const BuyMoreModal({super.key});

  @override
  State<BuyMoreModal> createState() => _BuyMoreModalState();
}

class _BuyMoreModalState extends State<BuyMoreModal> {
  late AdState _adState;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _adState = Provider.of<AdState>(context,listen: false);

    // _adState.loadGameOverRewardedAd();
    GamePlayState gamePlayState = Provider.of<GamePlayState>(context,listen: false);
    ColorPalette palette = Provider.of<ColorPalette>(context,listen: false);
    _adState.loadRewardedAd(gamePlayState,palette);

  }
  
  @override
  Widget build(BuildContext context) {

    

    return Consumer<AdState>(
      builder: (context,adState,child) {

        SettingsController settings = Provider.of<SettingsController>(context,listen: false);
        ColorPalette palette = Provider.of<ColorPalette>(context,listen: false);

        



        return Consumer<GamePlayState>(
          builder: (context,gamePlayState,child) {

            // print("in the buy more modal widget: ${gamePlayState.tileMenuBuyMoreModalData}");
            bool isModalOpen = gamePlayState.tileMenuBuyMoreModalData["open"]??false;
        
            if (isModalOpen) {

              Map<String,dynamic> tileMenuBuyMoreModalData = gamePlayState.tileMenuBuyMoreModalData;
              String perk = tileMenuBuyMoreModalData["item"];

              String perkImagePath = getPerkImagePath(perk);
              Map<String,dynamic> optionData = tileMenuBuyMoreModalData["options"].firstWhere((e)=>e["key"]==1,orElse:()=><String,dynamic>{});

              Widget option1Image = Icon(Icons.play_arrow_rounded, size: 30*gamePlayState.scalor,);
              Widget option2Image = Image(width: 30*gamePlayState.scalor, height: 30*gamePlayState.scalor, image: AssetImage("assets/images/coin_image.png"),);

              void option1Callback() {
                adState.gameRewardedAd?.show(
                  onUserEarnedReward: (ad, reward) {
                    // GameLogic().closeTileMenuBuyMoreModal(gamePlayState,palette,0);
                    GameLogic().executePauseDialogPopScope(gamePlayState,palette);
                    if (optionData.isNotEmpty) {
                      Animations().startAddPerksAnimation(gamePlayState,perk,optionData);                                  
                    }
                  },
                  // onAdDismissedFullScreenContent
                );                
                setState(() {
                  adState.setGameRewardedAd(null);
                  adState.setIsGameRewardedAdLoaded(false);
                });       
              }

              void option2Callback() {
                int coins = settings.coins.value;
                print("### ${tileMenuBuyMoreModalData["options"]}");
                
                if (optionData.isNotEmpty) {
                  int cost = optionData["cost"];
                  settings.setCoins(coins-cost);
                  GameLogic().closeTileMenuBuyMoreModal(gamePlayState,palette,1);
                  GameLogic().executePauseDialogPopScope(gamePlayState,palette);
                }
              }
                      
              
              // final double width = MediaQuery.of(context).size.width*0.8;
              // final double height = MediaQuery.of(context).size.width*1.2;
              final double tileSize = gamePlayState.elementSizes["tileSize"].width;
              final Size size = gamePlayState.elementSizes["playAreaSize"];
              final BorderRadius borderRadius = BorderRadius.all(Radius.circular(tileSize*0.24));
        
              return Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      // print("ya tapped me fack");
                      // gamePlayState.tileMenuBuyMoreModalData.update("tile", (v)=>null);
                      // gamePlayState.tileMenuBuyMoreModalData.update("open", (v)=>false);
                      // gamePlayState.tileMenuBuyMoreModalData.update("item", (v)=>null);
                      // gamePlayState.tileMenuBuyMoreModalData.update("message", (v)=>"");
                      // gamePlayState.tileMenuBuyMoreModalData.update("options", (v)=>[]);
                      // gamePlayState.setTileMenuBuyMoreModalData(gamePlayState.tileMenuBuyMoreModalData);
                      // gamePlayState.setIsGamePaused(false);
                      GameLogic().closeTileMenuBuyMoreModal(gamePlayState,palette, null);
                      GameLogic().executePauseDialogPopScope(gamePlayState, palette);
                      // Navigator.pop(context);
                    },
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: const Color.fromARGB(118, 0, 0, 0),
                    ),
                  ),
                  Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0))
                    ),
                    child: Container(
                      // color: const Color.fromARGB(255, 70, 70, 70),
                      decoration: BoxDecoration(
                        // color: Color.fromARGB(255, 70, 70, 70),
                        gradient: RadialGradient(
                          colors: [const Color.fromARGB(255, 103, 95, 214),Color.fromARGB(255, 3, 29, 177)],
                          radius: 0.8
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(12.0))
                      ),
                      
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4.0,20.0,4.0,8.0),
                            child: DefaultTextStyle(
                              style: GoogleFonts.luckiestGuy(
                                color: const ui.Color.fromARGB(255, 255, 255, 255),
                                fontSize: 36 *gamePlayState.scalor //getFontSize(36,size),
                              ),
                              textAlign: TextAlign.center,
                              child: Text("Uh Oh!"),
                            ),
                          ),  
                  
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DefaultTextStyle(
                              style: GoogleFonts.luckiestGuy(
                                color: const ui.Color.fromARGB(255, 255, 255, 255),
                                fontSize: 24*gamePlayState.scalor, // getFontSize(24,size),
                              ),
                              textAlign: TextAlign.center,
                              child: Text("You've run out of this perk!"),
                            ),
                          ),

                          SizedBox(
                            width: 100*gamePlayState.scalor,
                            height: 100*gamePlayState.scalor,
                            child: Image(image: AssetImage(perkImagePath)),
                          ),



                          adState.isgameRewardedAdLoaded
                          ? BuyMoreDialogButton(
                            rewardAmount: "+5",
                            costString: "Watch Ad",
                            costImage: option1Image,
                            onPressed: option1Callback,
                            scalor: gamePlayState.scalor,
                          ) 
                          : Center(child: CircularProgressIndicator(),),


                          BuyMoreDialogButton(
                            rewardAmount: "+3",
                            costString: "2000x",
                            costImage: option2Image,
                            onPressed: option2Callback,
                            scalor: gamePlayState.scalor,
                          ),
                     
                        ],
                      ),
                    ),
                  ),
                ],
              );
        

              
            } else {
              return SizedBox();
            }
        
          }
        );
      }
    );
     
  }
}



double getFontSize(double defaultFontSize, Size screenSize) {
        
  final double screenHypo = sqrt( pow(screenSize.width,2) + pow(screenSize.height,2) );
  final double baseHypo = sqrt( pow(450,2) + pow(800,2) );
  final double hypoRatio = screenHypo/baseHypo;

  final double res = defaultFontSize * hypoRatio;
  return res;
}

String getPerkImagePath(String perk) {
  String res = "";
  if (perk=="freeze") {
    res = "assets/images/snowflake_icon.png";
  }
  if (perk=="explode") {
    res = "assets/images/bomb_icon.png";
  }
  if (perk=="swap") {
    res = "assets/images/swap_image.png";
  }

  return res;
}

class BuyMoreDialogButton extends StatelessWidget {
  final String rewardAmount;
  final String costString;
  final Widget costImage;
  final Function onPressed;
  final double scalor;
  const BuyMoreDialogButton({
    super.key,
    required this.rewardAmount,
    required this.costString,
    required this.costImage,
    required this.onPressed,
    required this.scalor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28.0,8,28.0,8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 0, 5, 54),
          shadowColor:Colors.blue,
          foregroundColor: const Color.fromARGB(255, 243, 243, 243),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0*scalor))
          ),
          minimumSize: Size(250*scalor, 40*scalor),
          padding: EdgeInsets.symmetric(horizontal: 8.0*scalor)
        ),                           
        onPressed: () => onPressed(),
        child: Row(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  rewardAmount,
                  style: GoogleFonts.alfaSlabOne(
                    fontSize: 26*scalor,
                    // color: Colors.black
                  ),
                ),
              ),
            ),

            SizedBox(width: 20*scalor,),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0*scalor),
              child: Text(
                costString,
                style: GoogleFonts.alfaSlabOne(
                  fontSize: 18*scalor,
                  // color: Colors.black
                ),
              ),
            ),

            // SizedBox()
            costImage                                 
          ],
        ),
      )
    );
  }
}
