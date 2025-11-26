import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/components/bonus_icons.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/screens/instructions_screen/components/demo_board_element.dart';
import 'package:scribby_flutter_v2/screens/instructions_screen/components/feature_description_card.dart';
import 'package:scribby_flutter_v2/screens/instructions_screen/components/instructions_text_element.dart';

class InstructionsColumn extends StatefulWidget {
  final double scalor;
  final double screenWidth;
  final SettingsState settingsState;
  final ColorPalette palette;
  const InstructionsColumn({
    super.key,
    required this.scalor,
    required this.screenWidth,
    required this.settingsState,
    required this.palette,
  });

  @override
  State<InstructionsColumn> createState() => _InstructionsColumnState();
}

class _InstructionsColumnState extends State<InstructionsColumn> {

  late double demoBoardSize = widget.screenWidth;
  late double elementWidth = widget.screenWidth;

  late ColorPalette palette;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    elementWidth = widget.screenWidth*0.7;
    demoBoardSize = widget.screenWidth*0.55;    
    
    startTimer();

    palette = Provider.of<ColorPalette>(context, listen: false);

  }
  
  Timer? _timer;
  int _elapsedMilliseconds = 0;

  Timer? _tilePlacementTimer;
  double _tilePlacementProgress = 0;

  void startTimer() {

    _timer = Timer.periodic(const Duration(milliseconds: 10), (Timer t) {
      setState(() {
        _elapsedMilliseconds++;
      });
    });

    late int tilePlacementCount = 0; 
    _tilePlacementTimer = Timer.periodic(const Duration(milliseconds: 15), (Timer t) {

      if (tilePlacementCount == 80) {
        setState(() {
          tilePlacementCount=0;
        });
      }
      setState(() {
        tilePlacementCount++;
      });
      _tilePlacementProgress=tilePlacementCount/40 > 1.0 ? 1.0 : tilePlacementCount/40;

    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer?.cancel();
    _tilePlacementTimer?.cancel();
    super.dispose();
  }





  @override
  Widget build(BuildContext context) {


    return Flexible(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            InstructionsTextElement(
              isLabel: true, 
              body: "Walkthrough", 
              scalor: widget.scalor,
            ),

            InstructionsTextElement(
              isLabel: false, 
              body: "The following steps with visuals explain what happens in the game", 
              scalor: widget.scalor,
            ),

            InstructionsTextElement(
              isLabel: false, 
              body: "The bigger letter is the one you place, the smaller one next to it is coming up right after", 
              scalor: widget.scalor,
            ),

            DemoBoardElement(
              settingsState: widget.settingsState,
              currentStep: 0,
              boardSize: demoBoardSize,
              ellapsedTimeMs: _elapsedMilliseconds,
              tilePlacedProgress: _tilePlacementProgress,
              scalor: widget.scalor,
              palette: palette,
            ),

            InstructionsTextElement(
              isLabel: false, 
              body: "To place a letter, tap on an empty tile",
              scalor: widget.scalor,
            ), 

            DemoBoardElement(
              settingsState: widget.settingsState,
              currentStep: 1,
              boardSize: demoBoardSize,
              ellapsedTimeMs: _elapsedMilliseconds,
              tilePlacedProgress: _tilePlacementProgress,
              scalor: widget.scalor,
              palette: palette,
            ),

            InstructionsTextElement(
              isLabel: false, 
              body: "Here we want to make the word CAT",
              scalor: widget.scalor,
            ), 


            DemoBoardElement(
              settingsState: widget.settingsState,
              currentStep: 2,
              boardSize: demoBoardSize,
              ellapsedTimeMs: _elapsedMilliseconds,
              tilePlacedProgress: _tilePlacementProgress,
              scalor: widget.scalor,
              palette: palette,
            ),



            InstructionsTextElement(
              isLabel: false, 
              body: "Words under 3 letters in length will not be counted...",
              scalor: widget.scalor,
            ), 



            DemoBoardElement(
              settingsState: widget.settingsState,
              currentStep: 3,
              boardSize: demoBoardSize,
              ellapsedTimeMs: _elapsedMilliseconds,
              tilePlacedProgress: _tilePlacementProgress,
              scalor: widget.scalor,
              palette: palette,
            ),


            InstructionsTextElement(
              isLabel: false, 
              body: "In this turn, we only get credited for the word CAT and not AT",
              scalor: widget.scalor,
            ),

            InstructionsTextElement(
              isLabel: false, 
              body: "However, we have an S coming up! if we were patient, we could have played CATS getting credit for CAT and CATS...",
              scalor: widget.scalor,
            ),


            DemoBoardElement(
              settingsState: widget.settingsState,
              currentStep: 4,
              boardSize: demoBoardSize,
              ellapsedTimeMs: _elapsedMilliseconds,
              tilePlacedProgress: _tilePlacementProgress,
              scalor: widget.scalor,
              palette: palette,
            ),                    

            InstructionsTextElement(
              isLabel: false, 
              body: "We will review how we can use the reserve tiles at the bottom to achieve this",
              scalor: widget.scalor,
            ),

            InstructionsTextElement(
              isLabel: false, 
              body: "Let's start by playing the S",
              scalor: widget.scalor,
            ),
        

            DemoBoardElement(
              settingsState: widget.settingsState,
              currentStep: 5,
              boardSize: demoBoardSize,
              ellapsedTimeMs: _elapsedMilliseconds,
              tilePlacedProgress: _tilePlacementProgress,
              scalor: widget.scalor,
              palette: palette,
            ),                      

            InstructionsTextElement(
              isLabel: false, 
              body: "At this point, we could play the word SEA with the two letters we know will follow next...",
              scalor: widget.scalor,
            ),


            InstructionsTextElement(
              isLabel: false, 
              body: "However, we know that an L is coming up afterwards, which means we can play the word SEAL too",
              scalor: widget.scalor,
            ),
  


            DemoBoardElement(
              settingsState: widget.settingsState,
              currentStep: 6,
              boardSize: demoBoardSize,
              ellapsedTimeMs: _elapsedMilliseconds,
              tilePlacedProgress: _tilePlacementProgress,
              scalor: widget.scalor,
              palette: palette,
            ),
            

            InstructionsTextElement(
              isLabel: false, 
              body: "To achieve this, place the A in the reserves, which you will be able to drag onto the board later on",
              scalor: widget.scalor,
            ),
    

            DemoBoardElement(
              settingsState: widget.settingsState,
              currentStep: 7,
              boardSize: demoBoardSize,
              ellapsedTimeMs: _elapsedMilliseconds,
              tilePlacedProgress: _tilePlacementProgress,
              scalor: widget.scalor,
              palette: palette,
            ),

            InstructionsTextElement(
              isLabel: false, 
              body: "Now we can put the L at the end of the word",
              scalor: widget.scalor,
            ),
            
            DemoBoardElement(
              settingsState: widget.settingsState,
              currentStep: 8,
              boardSize: demoBoardSize,
              ellapsedTimeMs: _elapsedMilliseconds,
              tilePlacedProgress: _tilePlacementProgress,
              scalor: widget.scalor,
              palette: palette,
            ),

            InstructionsTextElement(
              isLabel: false, 
              body: "Now we drag the A from the reserve onto the board",
              scalor: widget.scalor,
            ), 

            DemoBoardElement(
              settingsState: widget.settingsState,
              currentStep: 9,
              boardSize: demoBoardSize,
              ellapsedTimeMs: _elapsedMilliseconds,
              tilePlacedProgress: _tilePlacementProgress,
              scalor: widget.scalor,
              palette: palette,
            ),

            InstructionsTextElement(
              isLabel: false, 
              body: "There you have it! We have found the words SEA and SEAL",
              scalor: widget.scalor,
            ),
            
            DemoBoardElement(
              settingsState: widget.settingsState,
              currentStep: 10,
              boardSize: demoBoardSize,
              ellapsedTimeMs: _elapsedMilliseconds,
              tilePlacedProgress: _tilePlacementProgress,
              scalor: widget.scalor,
              palette: palette,
            ),

            InstructionsTextElement(
              isLabel: false, 
              body: "Next up, we will review a new concept",
              scalor: widget.scalor,
            ),
              
            DemoBoardElement(
              settingsState: widget.settingsState,
              currentStep: 11,
              boardSize: demoBoardSize,
              ellapsedTimeMs: _elapsedMilliseconds,
              tilePlacedProgress: _tilePlacementProgress,
              scalor: widget.scalor,
              palette: palette,
            ),

            InstructionsTextElement(
              isLabel: false, 
              body: "This is the concept of multiplying your score using crossing words",
              scalor: widget.scalor,
            ),

            DemoBoardElement(
              settingsState: widget.settingsState,
              currentStep: 12,
              boardSize: demoBoardSize,
              ellapsedTimeMs: _elapsedMilliseconds,
              tilePlacedProgress: _tilePlacementProgress,
              scalor: widget.scalor,
              palette: palette,
            ),
            InstructionsTextElement(
              isLabel: false, 
              body: "Playing words on multiple axis is encouraged as it multiplies your score",
              scalor: widget.scalor,
            ),

            DemoBoardElement(
              settingsState: widget.settingsState,
              currentStep: 13,
              boardSize: demoBoardSize,
              ellapsedTimeMs: _elapsedMilliseconds,
              tilePlacedProgress: _tilePlacementProgress,
              scalor: widget.scalor,
              palette: palette,
            ),
            InstructionsTextElement(
              isLabel: false, 
              body: "With the O coming up, we have DOG and TOE as a possible play",
              scalor: widget.scalor,
            ),
          
      
            DemoBoardElement(
              settingsState: widget.settingsState,
              currentStep: 14,
              boardSize: demoBoardSize,
              ellapsedTimeMs: _elapsedMilliseconds,
              tilePlacedProgress: _tilePlacementProgress,
              scalor: widget.scalor,
              palette: palette,
            ),

            InstructionsTextElement(
              isLabel: false, 
              body: "All that's left here is the centerpiece!",
              scalor: widget.scalor,
            ),

            DemoBoardElement(
              settingsState: widget.settingsState,
              currentStep: 15,
              boardSize: demoBoardSize,
              ellapsedTimeMs: _elapsedMilliseconds,
              tilePlacedProgress: _tilePlacementProgress,
              scalor: widget.scalor,
              palette: palette,
            ),

            InstructionsTextElement(
              isLabel: false, 
              body: "The score is quadrupled! 2x for the crosswords, and 2x for the two words!",
              scalor: widget.scalor,
            ),

            DemoBoardElement(
              settingsState: widget.settingsState,
              currentStep: 16,
              boardSize: demoBoardSize,
              ellapsedTimeMs: _elapsedMilliseconds,
              tilePlacedProgress: _tilePlacementProgress,
              scalor: widget.scalor,
              palette: palette,
            ),
            
            InstructionsTextElement(
              isLabel: false, 
              body: "These bonus' chain on, so you can imagine, had we played DOGS with TOE, we would sixtuple our socre (crossword x 3 words)",
              scalor: widget.scalor,
            ),

            
            InstructionsTextElement(
              isLabel: false, 
              body:"These multipliers are defined in the section below",
              scalor: widget.scalor,
            ),                       


            SizedBox(height: 40 * widget.scalor,),
            Divider(color: widget.palette.text1, thickness: 2.0 * widget.scalor,),
            SizedBox(height: 40 * widget.scalor,),


            InstructionsTextElement(
              isLabel: true, 
              body: "Bonus Items",
              scalor: widget.scalor,
            ), 


            InstructionsTextElement(
              isLabel: false, 
              body: "These are ways to multiply your score by making the right plays at the right times.",
              scalor: widget.scalor,
            ),                            


            FeatureDescriptionCard(
              drawerWidth: elementWidth,
              scalor: widget.scalor,
              label: "Streak",
              body: "Multiplies your score by the number of conscutive turns where at least one word was found",
              iconImage: CustomPaint(painter: BonusIconPaitner(bonusType: "streak",scalor: widget.scalor,color: palette.text1),),
            ),

            FeatureDescriptionCard(
              drawerWidth: elementWidth,
              scalor: widget.scalor,
              label: "Multi Words",
              body: "Multiplies your score by the number of words found in the turn",
              iconImage: CustomPaint(painter: BonusIconPaitner(bonusType: "words",scalor: widget.scalor,color: palette.text1),),
            ),                        

            FeatureDescriptionCard(
              drawerWidth: elementWidth,
              scalor: widget.scalor,
              label: "Cross Words",
              body: "Doubles the turns score when words are found on both axis",
              iconImage: CustomPaint(painter: BonusIconPaitner(bonusType: "cross",scalor: widget.scalor,color: palette.text1),),
            ),


            Divider(color: widget.palette.text1, thickness: 2.0 * widget.scalor,),

            InstructionsTextElement(
              isLabel: true, 
              body: "Perks",
              scalor: widget.scalor,
            ),


            InstructionsTextElement(
              isLabel: false, 
              body: "The icons on the side of the screen can serve a serious purpose!",
              scalor: widget.scalor,
            ),                            

            FeatureDescriptionCard(
              drawerWidth: elementWidth,
              scalor: widget.scalor,
              label: "Bombs Away!",
              body: "Lets you get rid of any tile on the board!",
              iconImage: Image(image: AssetImage("assets/images/bomb_icon.png")),
            ),

            FeatureDescriptionCard(
              drawerWidth: elementWidth,
              scalor: widget.scalor,
              label: "Freeze!",
              body: "Makes a letter unusable until you decide to unfreeze it",
              iconImage: Image(image: AssetImage("assets/images/snowflake_icon.png")),
            ),

            FeatureDescriptionCard(
              drawerWidth: elementWidth,
              scalor: widget.scalor,
              label: "Swap!",
              body: "Lets you select two letters to switch spots on the board",
              iconImage: Image(image: AssetImage("assets/images/swap_image.png")),
            ),                        

          ],
        ),
      ),
    );
  }
}