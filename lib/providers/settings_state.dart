import 'package:flutter/material.dart';

class SettingsState extends ChangeNotifier {






  late Map<String,dynamic> _gameOverCountAnimation = {};
  Map<String,dynamic> get gameOverCountAnimation => _gameOverCountAnimation;
  void setGameOverCountAnimation(Map<String,dynamic> value) {
    _gameOverCountAnimation = value;
    notifyListeners();
  }

  final Map<int,dynamic> _demoBoardState = {
    0: {
      "random_1":"C",  "random_2":"A", "random_3":"",
      "0_0":"",   "0_1":"",   "0_2":"",   "0_3":"",
      "1_0":"",   "1_1":"",   "1_2":"",   "1_3":"",
      "2_0":"",   "2_1":"",   "2_2":"",   "2_3":"",
      "3_0":"",   "3_1":"",   "3_2":"",   "3_3":"",
      "res_0":"",  "res_1":"",  "res_2":"",
      "wordFoundIds": [],
      "placedTiles":[{"origin":"random_3","destination":"random_2"},{"origin":"random_2","destination":"random_1"},]
    },
    
    1: {
      "random_1":"A","random_2":"T", "random_3":"",
      "0_0":"",   "0_1":"",   "0_2":"",   "0_3":"",
      "1_0":"C",  "1_1":"",   "1_2":"",   "1_3":"",
      "2_0":"",   "2_1":"",   "2_2":"",   "2_3":"",
      "3_0":"",   "3_1":"",   "3_2":"",   "3_3":"",
      "res_0":"","res_1":"","res_2":"",
      "wordFoundIds": [],
      "placedTiles": [{"origin":"random_3","destination":"random_2"},{"origin":"random_2","destination":"random_1"},{"origin":"random_1","destination":"1_0"}],
    },

    2: {
      "random_1":"T","random_2":"S", "random_3":"",
      "0_0":"",   "0_1":"",   "0_2":"",   "0_3":"",
      "1_0":"C",  "1_1":"A",  "1_2":"",   "1_3":"",
      "2_0":"",   "2_1":"",   "2_2":"",   "2_3":"",
      "3_0":"",   "3_1":"",   "3_2":"",   "3_3":"",
      "res_0":"","res_1":"","res_2":"",
      "wordFoundIds": [],
      "placedTiles": [{"origin":"random_3","destination":"random_2"},{"origin":"random_2","destination":"random_1"},{"origin":"random_1","destination":"1_1"}],
    },

    3: {
      "random_1":"S","random_2":"E", "random_3":"",
      "0_0":"",   "0_1":"",   "0_2":"",   "0_3":"",
      "1_0":"C",  "1_1":"A",  "1_2":"T",  "1_3":"",
      "2_0":"",   "2_1":"",   "2_2":"",   "2_3":"",
      "3_0":"",   "3_1":"",   "3_2":"",   "3_3":"",
      "res_0":"","res_1":"","res_2":"",
      "wordFoundIds": [],
      "placedTiles": [{"origin":"random_3","destination":"random_2"},{"origin":"random_2","destination":"random_1"},{"origin":"random_1","destination":"1_2"}],

    },

    4: {
      "random_1":"S","random_2":"E", "random_3":"",
      "0_0":"",   "0_1":"",   "0_2":"",   "0_3":"",
      "1_0":"C",  "1_1":"A",  "1_2":"T",  "1_3":"",
      "2_0":"",   "2_1":"",   "2_2":"",   "2_3":"",
      "3_0":"",   "3_1":"",   "3_2":"",   "3_3":"",
      "res_0":"","res_1":"","res_2":"",
      "wordFoundIds": ["1_0","1_1","1_2"],
      "placedTiles": [{"origin":"random_2","destination":"random_2"},{"origin":"random_1","destination":"random_1"}],

    },  

   

    5: {
      "random_1":"E","random_2":"A", "random_3":"",
      "0_0":"",   "0_1":"",   "0_2":"",   "0_3":"S",
      "1_0":"",   "1_1":"",   "1_2":"",   "1_3":"",
      "2_0":"",   "2_1":"",   "2_2":"",   "2_3":"",
      "3_0":"",   "3_1":"",   "3_2":"",   "3_3":"",
      "res_0":"","res_1":"","res_2":"",
      "wordFoundIds": [],
      "placedTiles": [{"origin":"random_3","destination":"random_2"},{"origin":"random_2","destination":"random_1"},{"origin":"random_1","destination":"0_3"}],
    },

    6: {
      "random_1":"A","random_2":"L", "random_3":"",
      "0_0":"",   "0_1":"",   "0_2":"",   "0_3":"S",
      "1_0":"",   "1_1":"",   "1_2":"",   "1_3":"E",
      "2_0":"",   "2_1":"",   "2_2":"",   "2_3":"",
      "3_0":"",   "3_1":"",   "3_2":"",   "3_3":"",
      "res_0":"","res_1":"","res_2":"",
      "wordFoundIds": [],
      "placedTiles": [{"origin":"random_3","destination":"random_2"},{"origin":"random_2","destination":"random_1"},{"origin":"random_1","destination":"1_3"}],
    },

    7: {
      "random_1":"L","random_2":"D", "random_3":"",
      "0_0":"",   "0_1":"",   "0_2":"",   "0_3":"S",
      "1_0":"",   "1_1":"",   "1_2":"",   "1_3":"E",
      "2_0":"",   "2_1":"",   "2_2":"",   "2_3":"",
      "3_0":"",   "3_1":"",   "3_2":"",   "3_3":"",
      "res_0":"A","res_1":"","res_2":"",
      "wordFoundIds": [],
      "placedTiles": [{"origin":"random_3","destination":"random_2"},{"origin":"random_2","destination":"random_1"},{"origin":"random_1","destination":"res_0"}],
    },

    8: {
      "random_1":"D","random_2":"G", "random_3":"",
      "0_0":"",   "0_1":"",   "0_2":"",   "0_3":"S",
      "1_0":"",   "1_1":"",   "1_2":"",   "1_3":"E",
      "2_0":"",   "2_1":"",   "2_2":"",   "2_3":"",
      "3_0":"",   "3_1":"",   "3_2":"",   "3_3":"L",
      "res_0":"A","res_1":"","res_2":"",
      "wordFoundIds": [],
      "placedTiles": [{"origin":"random_3","destination":"random_2"},{"origin":"random_2","destination":"random_1"},{"origin":"random_1","destination":"3_3"}],
    },

    9: {
      "random_1":"D","random_2":"G", "random_3":"",
      "0_0":"",   "0_1":"",   "0_2":"",   "0_3":"S",
      "1_0":"",   "1_1":"",   "1_2":"",   "1_3":"E",
      "2_0":"",   "2_1":"",   "2_2":"",   "2_3":"A",
      "3_0":"",   "3_1":"",   "3_2":"",   "3_3":"L",
      "res_0":"","res_1":"","res_2":"",
      "wordFoundIds": [],
      "placedTiles": [{"origin":"res_0","destination":"2_3"},{"origin":"random_1","destination":"random_1"},{"origin":"random_2","destination":"random_2"}],
    },    


    10: {
      "random_1":"D","random_2":"G", "random_3":"",
      "0_0":"",   "0_1":"",   "0_2":"",   "0_3":"S",
      "1_0":"",   "1_1":"",   "1_2":"",   "1_3":"E",
      "2_0":"",   "2_1":"",   "2_2":"",   "2_3":"A",
      "3_0":"",   "3_1":"",   "3_2":"",   "3_3":"L",
      "res_0":"","res_1":"","res_2":"",
      "wordFoundIds": ["0_3","1_3","2_3","3_3"],
      "placedTiles": [{"origin":"random_2","destination":"random_2"},{"origin":"random_1","destination":"random_1"}],
    },  


    11: {
      "random_1":"G","random_2":"T", "random_3":"",
      "0_0":"",   "0_1":"D",   "0_2":"",   "0_3":"",
      "1_0":"",   "1_1":"",   "1_2":"",   "1_3":"",
      "2_0":"",   "2_1":"",   "2_2":"",   "2_3":"",
      "3_0":"",   "3_1":"",   "3_2":"",   "3_3":"",
      "res_0":"","res_1":"","res_2":"",
      "wordFoundIds": [],
      "placedTiles": [{"origin":"random_3","destination":"random_2"},{"origin":"random_2","destination":"random_1"},{"origin":"random_1","destination":"0_1"}],
    },  

    12: {
      "random_1":"T","random_2":"E", "random_3":"",
      "0_0":"",   "0_1":"D",  "0_2":"",   "0_3":"",
      "1_0":"",   "1_1":"",   "1_2":"",   "1_3":"",
      "2_0":"",   "2_1":"G",  "2_2":"",   "2_3":"",
      "3_0":"",   "3_1":"",   "3_2":"",   "3_3":"",
      "res_0":"","res_1":"","res_2":"",
      "wordFoundIds": [],
      "placedTiles": [{"origin":"random_3","destination":"random_2"},{"origin":"random_2","destination":"random_1"},{"origin":"random_1","destination":"2_1"}],
    },  

    13: {
      "random_1":"E","random_2":"O", "random_3":"",
      "0_0":"",   "0_1":"D",  "0_2":"",   "0_3":"",
      "1_0":"T",   "1_1":"",  "1_2":"",   "1_3":"",
      "2_0":"",   "2_1":"G",  "2_2":"",   "2_3":"",
      "3_0":"",   "3_1":"",   "3_2":"",   "3_3":"",
      "res_0":"","res_1":"","res_2":"",
      "wordFoundIds": [],
      "placedTiles": [{"origin":"random_3","destination":"random_2"},{"origin":"random_2","destination":"random_1"},{"origin":"random_1","destination":"1_0"}],
    },
    14: {
      "random_1":"O","random_2":"V", "random_3":"",
      "0_0":"",   "0_1":"D",  "0_2":"",   "0_3":"",
      "1_0":"T",  "1_1":"",   "1_2":"E",  "1_3":"",
      "2_0":"",   "2_1":"G",  "2_2":"",   "2_3":"",
      "3_0":"",   "3_1":"",   "3_2":"",   "3_3":"",
      "res_0":"","res_1":"","res_2":"",
      "wordFoundIds": [],
      "placedTiles": [{"origin":"random_3","destination":"random_2"},{"origin":"random_2","destination":"random_1"},{"origin":"random_1","destination":"1_2"}],
    },  

    15: {
      "random_1":"V","random_2":"U", "random_3":"",
      "0_0":"",   "0_1":"D",  "0_2":"",   "0_3":"",
      "1_0":"T",  "1_1":"O",   "1_2":"E",  "1_3":"",
      "2_0":"",   "2_1":"G",  "2_2":"",   "2_3":"",
      "3_0":"",   "3_1":"",   "3_2":"",   "3_3":"",
      "res_0":"","res_1":"","res_2":"",
      "wordFoundIds": [],
      "placedTiles": [{"origin":"random_3","destination":"random_2"},{"origin":"random_2","destination":"random_1"},{"origin":"random_1","destination":"1_1"}],
    },      

    16: {
      "random_1":"V","random_2":"U", "random_3":"",
      "0_0":"",   "0_1":"D",  "0_2":"",   "0_3":"",
      "1_0":"T",  "1_1":"O",  "1_2":"E",  "1_3":"",
      "2_0":"",   "2_1":"G",  "2_2":"",   "2_3":"",
      "3_0":"",   "3_1":"",   "3_2":"",   "3_3":"",
      "res_0":"","res_1":"","res_2":"",
      "wordFoundIds": ["0_1","1_1","2_1","1_0","1_2",],
      "placedTiles": [{"origin":"random_2","destination":"random_2"},{"origin":"random_1","destination":"random_1"}],
    }, 

            
  };
  Map<int,dynamic> get demoBoardState => _demoBoardState; 
}