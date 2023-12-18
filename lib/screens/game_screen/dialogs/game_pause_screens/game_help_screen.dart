import 'package:flutter/material.dart';
import 'package:scribby_flutter_v2/components/dialog_widget.dart';
import 'package:scribby_flutter_v2/functions/game_logic.dart';
import 'package:scribby_flutter_v2/utils/states.dart';

class GameHelpScreen extends StatefulWidget {
  const GameHelpScreen({super.key})  ;

  @override
  State<GameHelpScreen> createState() => _GameHelpScreenState();
}

class _GameHelpScreenState extends State<GameHelpScreen> {
  Key? get key => null;

  @override
  Widget build(BuildContext context) {
    return DialogWidget(
      key, 
      "Instructions", 
      SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _instructionsHeading("Objective"),
            _instructionsText("The objective of the game is to create words with the randomly generated letters."),

            _instructionsHeading("Demo"),
            _instructionsText("The two letters at the top are randomly generated. The center letter (A) gets placed next"),

            DemoBoardState(demoBoardState: demoBoardState_1 ),
            _instructionsText("When the letter (A) is placed inside the board, the letter to the right (K) will become the center letter and a new random letter will be generated and take its spot"),
            _instructionsText("A new letter (U) is randomly generated to be place after the next letter (K) is placed."),                   
                    
                                  
            DemoBoardState(demoBoardState: demoBoardState_2 ),

            _instructionsText("Place your letters strategically to create words. In this case, we see the 'S' coming after the 'U'"),
                     

            DemoBoardState(demoBoardState: demoBoardState_3 ),

            _instructionsText("The 'U' is placed below the 'K' so the 'S' can be placed between the 'A' and the 'K' and create the word 'ASK'"),


            DemoBoardState(demoBoardState: demoBoardState_4 ),

            _instructionsText("The 'S' is placed in between the 'A' and 'K'. The letters animate and you are granted points for the letters."),


            _instructionsHeading("Swipe to 'Settings' to understand how points are allocated"),
                      
            DemoBoardState(demoBoardState: demoBoardState_5 ),
            
            _instructionsText("After an animation plays, the letters from the word 'ASK' will disappear from the board and the spaces will become available for new letters."),

            DemoBoardState(demoBoardState: demoBoardState_6 ),

            _instructionsText("The spaces become available for the new letters to be placed")

                                  

          ],
        ),
      ),
      null
    );


  }
}


class DemoBoardState extends StatefulWidget {
  final List<Map<String,dynamic>> demoBoardState;
  const DemoBoardState({
    super.key,
    required this.demoBoardState,
  });

  @override
  State<DemoBoardState> createState() => _DemoBoardStateState();
}

class _DemoBoardStateState extends State<DemoBoardState> {
  @override
  Widget build(BuildContext context) {


    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          SizedBox(
            height: 70,
            width: 200,

            child: Row(
              children: [
                const Expanded(flex: 1, child: Center(),),  
                Expanded(
                  flex: 1,  
                  child: Center(
                    child: Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        // border: Border.all(
                        //   color: Colors.black
                        // ),
                        borderRadius: BorderRadius.circular(10.0),
                        color: const Color.fromRGBO(202, 176, 228, 1),
                      ),
                      child: Center(
                        child: Text(
                          GameLogic().displayTileLetter(widget.demoBoardState, "0_0"),
                          style: const TextStyle(
                            fontSize: 42
                          ),
                        ),
                      ),
                    ),
                  ),
                ),  
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        // border: Border.all(
                        //   color: Colors.black
                        // ),
                        borderRadius: BorderRadius.circular(10.0),
                        color: const Color.fromRGBO(202, 176, 228, 1),
                      ),
                      child: Center(
                        child: Text(
                          GameLogic().displayTileLetter(widget.demoBoardState, "0_1"),
                          style: const TextStyle(
                            fontSize: 26
                          ),                          
                        ),
                      ),                                
                    ),
                  ),
                ),                                                                                  
              ],
            ),                                 
          ),
          const SizedBox(height: 10,),
          Container(
            width: 200,
            height: 170,

            margin: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            child: Column(
              children: [
                for (var i=0; i<3; i++)
                Row(
                  children: [
                    for( var j=0; j<3; j++)
                    
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Container(
                        width: 50,
                        height: 50,                                                    
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: GameLogic().displayTileLetter(widget.demoBoardState, "${(i+1).toString()}_${(j+1).toString()}") == "" 
                            ? const Color.fromRGBO(202, 176, 228, 1) 
                            : const Color.fromRGBO(0, 0, 0, 0),
                            width: 2,
                          ),
                          color: GameLogic().displayTileLetter(widget.demoBoardState, "${(i+1).toString()}_${(j+1).toString()}") == "" 
                            ? const Color.fromRGBO(0, 0, 0, 0) 
                            : GameLogic().getTileState(widget.demoBoardState, "${(i+1).toString()}_${(j+1).toString()}")["active"]
                              ? const Color.fromRGBO(107, 6, 209, 1) 
                              : const Color.fromRGBO(202, 176, 228, 1) ,
                          borderRadius: BorderRadius.circular(10.0)                            
                        ),
                        margin: const EdgeInsets.all(2.0),                                                
                          child: Center(
                            child: Text(
                              GameLogic().displayTileLetter(widget.demoBoardState, "${(i+1).toString()}_${(j+1).toString()}"),
                              style: TextStyle(
                                fontSize: 22,
                                color: GameLogic().getTileState(widget.demoBoardState, "${(i+1).toString()}_${(j+1).toString()}")["active"]
                                  ? const Color.fromRGBO(255, 255, 255, 1) 
                                  : const Color.fromRGBO(0, 0, 0, 1) ,
                              ),                                
                            ) 
                          )
                        ),
                      ),
                    )
                  ],
                )
    
              ],
            ),
          ),
        ],
      ),
    );

  }
}

Widget _instructionsHeading(String body) {
  return Container(
    margin: const EdgeInsets.all(4.0),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        body,
        style: const TextStyle(
          fontWeight: FontWeight.bold
        ),
      ),
    ),
    
  );
}


Widget _instructionsText(String body) {
  return Container(
    margin: const EdgeInsets.all(4.0),
    child: Text(body),
  ); 
}