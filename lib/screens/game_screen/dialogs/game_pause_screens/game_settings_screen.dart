import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/components/dialog_widget.dart';
// import 'package:scribby_flutter_v2/functions/game_logic.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';
// import 'package:scribby_flutter_v2/utils/states.dart';

class GameSettings extends StatelessWidget {
  const GameSettings({super.key});

  @override
  Widget build(BuildContext context) {
    // final settings = context.watch<SettingsController>();
    return Consumer<SettingsController>(
      builder: (context, settings, child) {
        return DialogWidget(
          key, 
          "Settings", 

          SingleChildScrollView(
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Parameters",
                    style: TextStyle(
                      fontSize: 22
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Card(
                    
                    child: SizedBox(
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Expanded(
                              flex: 3,
                              child: Text(
                                "Sound On",
                                style: TextStyle(
                                  fontSize: 22
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: ValueListenableBuilder<bool>(
                                valueListenable: settings.soundsOn,
                                builder: (context, soundsOn, child) => IconButton(
                                  onPressed: () => settings.toggleSoundsOn(),
                                  icon: soundsOn ? const Icon(Icons.volume_up) : const Icon(Icons.volume_off),
                                  color: soundsOn ? const Color.fromRGBO(44, 222, 253, 1) : const Color.fromRGBO(49, 49, 49, 1) ,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Scoring",
                    style: TextStyle(
                      fontSize: 22
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(4.0),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Letter Values",
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  
                ),                    
                Container(
                  margin: const EdgeInsets.all(4.0),
                  child: const Text("All letters have a predetermined value. When a word is found the score is tabulated according to the value of each letter in the word"),
                ),  
                Container(
                  margin: const EdgeInsets.all(4.0),
                  child: const Text("All letters have a predetermined value. When a word is found the score is tabulated according to the value of each letter in the word"),
                ),

                // LetterValuesTable(letters: widget.letters),
                const LetterValuesTable(),

                Container(
                  margin: const EdgeInsets.all(4.0),                        
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Multipliers - Word Lengths",
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),                      

                ),                            
                Container(
                  margin: const EdgeInsets.all(4.0),
                  child: const Text("To arrive to a total score for the turn, first, each word is multiplied by the Word Length Multiplier."),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Table(
                    border: TableBorder.all(),
                    columnWidths: const <int, TableColumnWidth>{
                      0: FlexColumnWidth(3),
                      1: FlexColumnWidth(),
                      2: FlexColumnWidth(),
                      3: FlexColumnWidth(),
                      4: FlexColumnWidth(),
                    },                        
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: const <TableRow>[
                      TableRow(
                        children: <Widget>[
                          Center(
                            child: Text("Word Length")
                          ),
                          Center(
                            child: Text("3")
                          ),
                          Center(
                            child: Text("4")
                          ),
                          Center(
                            child: Text("5")
                          ),
                          Center(
                            child: Text("6")
                          ),                                                                                                                        
                        ]
                      ),
                      TableRow(
                        children: <Widget>[
                          Center(
                            child: Text("Multiplier")
                          ),
                          Center(
                            child: Text("1x")
                          ),
                          Center(
                            child: Text("1x")
                          ),
                          Center(
                            child: Text("2x")
                          ),
                          Center(
                            child: Text("3x")
                          ),                                                                                                                        
                        ]
                      ),                          
                    ],
                  ),
                ),
                const SizedBox(height: 20,),
                Container(
                  margin: const EdgeInsets.all(4.0),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Multipliers - Streaks",
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),                      
                ),
                Container(
                  margin: const EdgeInsets.all(4.0),
                  child: const Text("The streak is defined by the number of consecutive turns where at least one word was found"),
                ),

                const SizedBox(height: 20,),
                Container(
                  margin: const EdgeInsets.all(4.0),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Multipliers - Crosswords",
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),                      
                ),
                Container(
                  margin: const EdgeInsets.all(4.0),
                  child: const Text("If multiple words are found, at least one in a row, and one in a column - then a crossword as been found. "),
                ), 
                Container(
                  margin: const EdgeInsets.all(4.0),
                  child: const Text("The multiplier for crosswords will always be 2x"),
                ),   

                const SizedBox(height: 20,),
                Container(
                  margin: const EdgeInsets.all(4.0),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Multipliers - Word Count",
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),                      
                ),
                Container(
                  margin: const EdgeInsets.all(4.0),
                  child: const Text("The final score is multiplied by the number of words that were found"),
                ),                                                                                                                                                             
              ],
            ),          
          ), 
          null
        );
      },
    );
  }
}

class LetterValuesTable extends StatelessWidget {
  const LetterValuesTable({super.key});

  String getLetterValue(List<Map<String,dynamic>> letterDictionary, String letter ) {
    String res = "";
    if (letter == "") {
      res = "";
    } else {
      Map<String,dynamic> letterObject = letterDictionary.firstWhere((element) => element["letter"] == letter);
      int value = letterObject["points"];
      res = "$letter - ${value.toString()}";
    }
    return res;
  }  

  @override
  Widget build(BuildContext context) {

    // late Map<String,dynamic> initialRandomData = GameLogic().startingRandomLetterData(initialRandomLetterState);
    // late List<Map<String,dynamic>> letterDictionary = initialRandomData['state'] ;

    late GamePlayState gamePlayState = Provider.of<GamePlayState>(context, listen: false);
    late List<Map<String,dynamic>> letterDictionary = gamePlayState.alphabetState;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Table(
        border: TableBorder.all(),
        columnWidths: const <int, TableColumnWidth>{
          0: FlexColumnWidth(),
          1: FlexColumnWidth(),
          2: FlexColumnWidth(),
          3: FlexColumnWidth(),
        }, 
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: <TableRow>[
          TableRow(
            children: <Widget>[
              Center(
                child: Text(getLetterValue(letterDictionary, "A"))
              ), 
              Center(
                child: Text(getLetterValue(letterDictionary, "H"))
                        
              ), 
              Center(
                child: Text(getLetterValue(letterDictionary, "O"))
                        
              ), 
              Center(
                child: Text(getLetterValue(letterDictionary, "U"))
                        
              ),                                                                                                                
            ]
          ),
          TableRow(
            children: <Widget>[
              Center(
                child: Text(getLetterValue(letterDictionary, "B"))
                        
              ), 
              Center(
                child: Text(getLetterValue(letterDictionary, "I"))
                        
              ), 
              Center(
                child: Text(getLetterValue(letterDictionary, "P"))
                        
              ), 
              Center(
                child: Text(getLetterValue(letterDictionary, "W"))
                        
              ),                                                                                                                
            ]
          ),
          TableRow(
            children: <Widget>[
              Center(
                child: Text(getLetterValue(letterDictionary, "C"))
                        
              ), 
              
              Center(
                child: Text(getLetterValue(letterDictionary, "J"))
        
              ),
               
              
              Center(
                child: Text(getLetterValue(letterDictionary, "Q"))
        
              ),
               
              
              Center(
                child: Text(getLetterValue(letterDictionary, "W"))
        
              ),
                                                                                                                              
            ]
          ),
          TableRow(
            children: <Widget>[
              
              Center(
                child: Text(getLetterValue(letterDictionary, "D"))
        
              ),
               
              
              Center(
                child: Text(getLetterValue(letterDictionary, "K"))
        
              ),
               
              
              Center(
                child: Text(getLetterValue(letterDictionary, "R"))
        
              ),
               
              
              Center(
                child: Text(getLetterValue(letterDictionary, "X"))
        
              ),
                                                                                                                              
            ]
          ),
          TableRow(
            children: <Widget>[
              
              Center(
                child: Text(getLetterValue(letterDictionary, "E"))
        
              ),
               
              
              Center(
                child: Text(getLetterValue(letterDictionary, "L"))
        
              ),
               
              
              Center(
                child: Text(getLetterValue(letterDictionary, "S"))
        
              ),
               
              
              Center(
                child: Text(getLetterValue(letterDictionary, "Y"))
        
              ),
                                                                                                                              
            ]
          ),
          TableRow(
            children: <Widget>[
              
              Center(
                child: Text(getLetterValue(letterDictionary, "F"))
        
              ),
               
              
              Center(
                child: Text(getLetterValue(letterDictionary, "M"))
        
              ),
               
              
              Center(
                child: Text(getLetterValue(letterDictionary, "T"))
        
              ),
               
              
              Center(
                child: Text(getLetterValue(letterDictionary, "Z"))
        
              ),
                                                                                                                              
            ]
          ),
          TableRow(
            children: <Widget>[
              
              Center(
                child: Text(getLetterValue(letterDictionary, "G"))
        
              ),
               
              
              Center(
                child: Text(getLetterValue(letterDictionary, "N"))
        
              ),
               
              
              Center(
                child: Text(getLetterValue(letterDictionary, ""))
        
              ),
               
              
              Center(
                child: Text(getLetterValue(letterDictionary, ""))
              
              ),
                                                                                                                              
            ]
          )                                                            

        ]        
      ),
    );
  }
}