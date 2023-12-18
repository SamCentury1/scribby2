
// import 'package:expansion_tile_card/expansion_tile_card.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/components/dialog_widget.dart';
import 'package:scribby_flutter_v2/functions/game_logic.dart';
// import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
// import 'package:scribby_flutter_v2/providers/game_state.dart';
// import 'package:scribby_flutter_v2/styles/buttons.dart';

class GameSummaryScreen extends StatelessWidget {
  const GameSummaryScreen({super.key});

  // @override
  // State<GameSummaryScreen> createState() => _GameSummaryScreenState();
// }

// class _GameSummaryScreenState extends State<GameSummaryScreen> {
  @override
  Key? get key => null;

  @override
  Widget build(BuildContext context) {

    // var gamePlayState = Provider.of<GamePlayState>(context, listen: false);
    
    // late GamePlayState gamePlayState = Provider.of<GamePlayState>(context, listen: false);
    // late GamePlayState _gamePlayState = Provider.of<GamePlayState>(context, listen: false);
    
    return Consumer<GamePlayState>(
      builder: (context, gamePlayState, child) {

        // if (gamePlayState == null) {
        //   return const CircularProgressIndicator(); // or another loading widget
        // }
        return DialogWidget(
          key, 
          "Game Summary", 
          GameSummaryContent(gamePlayState),
          null
        );
        // return !gamePlayState.isGameStarted 
        // ? DialogWidget(
        //   key, 
        //   "Start Game", 
        //   SingleChildScrollView(
        //     child: Column(
        //       children: [
        //         const Text("Are you ready to start the game?"),
        //         const SizedBox(height: 20,),
        //         _iconAndText(
        //           const Icon(Icons.help),
        //           "If you need a refresher on how the game is played, tap the help icon or swipe to the help tab for a demonstration"
        //         ),
        //         const SizedBox(height: 20,),
        //         _iconAndText(
        //           const Icon(Icons.settings),
        //           "If you want to mute the game or if you want to understand the logic of the game more in depth (how points are calculated) tap the settings icon or swipe to the settings tab for more details"
        //         ),
        //         const SizedBox(height: 20,),
        //         _iconAndText(
        //           const Icon(Icons.exit_to_app),
        //           "If you want to leave or restart the game at any moment, tap the exit icon or swipe to the exit tab for more options"
        //         ),
        //         const SizedBox(height: 20,),                                         
      
          
        //       ],
        //     ),
        //   ),
        //   Expanded(
        //     child: Padding(
        //       padding: EdgeInsets.all(12.0),
        //       child: ElevatedButton(
        //         style: startGameButton,
        //         onPressed: () {
        //           gamePlayState.setIsGameStarted(true);
        //           // gamePlayState.setIsGamePaused(false,0);
        //           // gamePlayState.startTimer();
        //           // gamePlayState.countDownController.reset();
        //           // gamePlayState.countDownController.start();                
        //         },
        //         child: Text("Start"),
        //       ),
        //     ),
        //   )     
        // )
        // : DialogWidget(
        //   key, 
        //   "Game Summary", 
        //   GameSummaryContent(gamePlayState),
        //   null
        // )
        // ;
      }

    );
  }
}


// Widget _iconAndText(Icon icon, String text) {
//   return Row(
//     children: [
//       icon,
//       const SizedBox(width: 10,),
//       Flexible(
//         child: Text(text)
//       )
//     ],
//   );
// }

class GameSummaryContent extends StatefulWidget {
  final GamePlayState gamePlayState;
  // final GameState gameState;
  const GameSummaryContent(
    this.gamePlayState, 
    // this.gameState, 
    {super.key}
  );

  @override
  State<GameSummaryContent> createState() => _GameSummaryContentState();
}

class _GameSummaryContentState extends State<GameSummaryContent> {

  late bool displayWords;

  @override
  void initState() {
    super.initState();
    displayWords = false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GamePlayState>(
      builder: (context, gamePlayState, child) {
        return displayWords
        ? SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "All ${widget.gamePlayState.summaryData['uniqueWords'].length} Unique Words",
                    style: const TextStyle(fontSize: 24),
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              widget.gamePlayState.summaryData.isEmpty ? const Text("No words found yet...") : 
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Table(
                    border: const TableBorder(
                      horizontalInside: BorderSide(
                        width: 1,
                        color: Colors.grey,
                        style: BorderStyle.solid
                      ),
                    ),
                    columnWidths: const {
                      0: FixedColumnWidth(1),
                      1: FixedColumnWidth(200),
                    },

                    children: [
                      for (int i=0; i<widget.gamePlayState.summaryData['uniqueWords'].length; i++)
                      TableRow(
                        children: [
                          TableCell(
                            child: Text(
                              (i+1).toString(),
                              style: const TextStyle(
                                fontSize: 22,
                              ),
                            )
                          ),
                          TableCell(
                            child: Text(
                              widget.gamePlayState.summaryData['uniqueWords'][i],
                              style: const TextStyle(
                                fontSize: 22,
                              ),                        
                            )
                          ),
                        ]
                      )
                    ],
                  ),

                ),
              ),
              Row(
                children: [
                  const Expanded(flex: 1, child: SizedBox()),
                  const Icon(Icons.arrow_upward, size: 24),
                  const SizedBox(width: 10,),
                  InkWell(
                    child: const Text(
                      "Hide",
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        displayWords = !displayWords;
                      });
                    }
                  ),              
                ],
              )
            ],
          ),
        )
        
        : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
        
              /// DURATION
              _levelAndTimeItems(
                const Icon(Icons.bar_chart),
                gamePlayState.currentLevel.toString(),
                const Icon(Icons.query_builder,size: 22),  
                GameLogic().formatTime(widget.gamePlayState.duration.inSeconds)
              ),
              const Expanded(flex: 1,child: SizedBox()),

              _label("YOUR SCORE"),
              /// POINTS
              _pointsStatItem(
                context,
                const Icon(Icons.star, size: 52), 
                "Points", 
                widget.gamePlayState.summaryData.isEmpty ? "0" : widget.gamePlayState.summaryData['points'].toString()
              ),

              const Expanded(flex: 1,child: SizedBox()),
              
        
              // _label("WORDS"),
              InkWell(
                onTap: () {
                  setState(() {
                    displayWords = !displayWords;
                  });                
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "WORDS",
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                    SizedBox(width: 10,),
                    Icon(Icons.read_more, size: 26,)

                  ],
                ),
              ),

              /// UNIQUE WORDS
              
              _wordsStatItem(
                context,
                const Icon(Icons.book_rounded, size: 52,), 
                "Words", 
                widget.gamePlayState.summaryData.isEmpty ? "0" : widget.gamePlayState.summaryData['uniqueWords'].length.toString()
              ),  
              const Expanded(flex: 3,child: SizedBox()),        
        
        
        

        


              // Container(
              //   width: double.infinity,
              //   height: 40,
              //   color: Colors.amber,
              //   child: Text(
              //     "Instructions"
              //   ),
              // ),
              _navButton(1,"How To Play", gamePlayState, const Icon(Icons.info)),
              const Expanded(flex: 1,child: SizedBox()),

              _navButton(2,"Settings", gamePlayState, const Icon(Icons.settings)) , 
              const Expanded(flex: 1,child: SizedBox()),

              _navButton(3,"Quit / Restart", gamePlayState, const Icon(Icons.exit_to_app))  ,
              const Expanded(flex: 1, child: SizedBox()), 
        
            ],
          ),
        );
      },
    );
  }
}



Widget _levelAndTimeItems(Icon levelIcon, String levelData, Icon timeIcon, String data) {
  return SizedBox(
    width: double.infinity,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        levelIcon,
        const SizedBox(width:10),
        Text(
          "level $levelData",
          style: const TextStyle(
            fontSize: 22
          ),
        ),
        const Expanded(flex: 1,child: SizedBox(),),
        timeIcon,
        const SizedBox(width: 10,),
        Text(
          data,
          style: const TextStyle(
            fontSize: 22,
          ),
        )
      ],
    ),
  );
}

Widget _pointsStatItem(BuildContext context, Icon icon, String body, String data) {
  return SizedBox(
    height: 60,
    // color: Colors.amber,
    width: MediaQuery.of(context).size.width*0.66,
    child: Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  bottomLeft: Radius.circular(50.0), 

                  topRight: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),                                    
            ),            
          ),
          child: Row(
            children: [
              const Expanded(flex: 2, child: SizedBox()), 
              Text(
                data,
                style: const TextStyle(
                  fontSize: 42,
                ),
              ),
              const Expanded(flex: 1, child: SizedBox()), 
            ],
          )
        ),

        Positioned(
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: icon
            )
          )
        ),        

      ],
    ),

  );
}

Widget _navButton(int page, String text, GamePlayState gamePlayState, Icon icon) {
  return Container(
    width: double.infinity,
    height: 40,
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      color: Colors.amber,
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          gamePlayState.pageController.jumpToPage(page);
        },
        child: Row(
          children: [
            icon,
            const SizedBox(width: 10,),
            Text(
              text,
              style: const TextStyle(
                fontSize: 19
              ),
            )
          ],
        ),
      ),
    )
  );
}

Widget _label(String text) {
  return Align(
    alignment: Alignment.center,
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 22,
      ),
    )
  );  
}

Widget _wordsStatItem(BuildContext context, Icon icon, String body, String data) {
  return SizedBox(
    height: 60,
    // color: Colors.amber,
    width: MediaQuery.of(context).size.width*0.66,
    child: Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  bottomLeft: Radius.circular(50.0), 

                  topRight: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),                                    
            ),            
          ),
          child: Row(
            children: [
              const Expanded(flex: 2, child: SizedBox()), 
              Text(
                data,
                style: const TextStyle(
                  fontSize: 42,
                ),
              ),
              const Expanded(flex: 1, child: SizedBox()), 
            ],
          )
        ),

        Positioned(
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: icon
            )
          )
        ),        

      ],
    ),

  );
}



// Widget _statItem2(Icon icon, String body, String data, double width) {
//   return Container(
//     width: width ,
//     height: width*1.3,
//     color: Color.fromARGB(0, 0, 0, 0),
//     child: Stack(
//       children: [


//         /// ========== ICON ===================
//         Positioned(
//           top: 0,
//           left: 4,
//           child: Container(
//             width: (width/3),
//             height: (width/3),
//             color: Color.fromARGB(0, 0, 0, 0),
//             child: icon,
//           ),
//         ),   

//         /// =========== TEXT BODY ==================
//         Positioned(
//           bottom: 00,
//           left: 0,
//           child: Container(
//             width: (width),
//             height: (width*0.5),
//             color: Color.fromARGB(0, 0, 0, 0),
//             child: Align(
//               alignment: Alignment.center,
//               child: Text(
//                 body,
//                 style: TextStyle(
//                   fontSize: (width*0.25),
//                   height: 1.0, // the height between text, default is null
//                   letterSpacing: -1.0 // the white space between letter, default is 0.0             
//                 ),
//                 textAlign: TextAlign.center,
//               )
//             ),
//           ),
//         ),


//         /// ======== DATA ===========
//         Positioned(
//           top:-5,
//           left: 0,
//           child: Container(
//             width: width,
//             height: width*1.3,
//             color: Color.fromARGB(0, 0, 0, 0),
//             child: Align(
//               alignment: Alignment.center,
//               child: Text(
//                 data,
//                 style: TextStyle(
//                   fontSize: (width*0.55),
//                 ),
                
//               ),
//             ),          
//           )
//         ),                      
//       ],
//     ),
//   );
// }