// import 'package:scribby_flutter_v2/functions/game_logic.dart';

List<Map<String, dynamic>> initialBoardState = [
  // ROW 1
  {
    "tileId": "1_1",
    "row": 1,
    "column": 1,
    "letter": "",
    "active": false,
    "alive": true
  },
  {
    "tileId": "1_2",
    "row": 1,
    "column": 2,
    "letter": "",
    "active": false,
    "alive": true
  },
  {
    "tileId": "1_3",
    "row": 1,
    "column": 3,
    "letter": "",
    "active": false,
    "alive": true
  },
  {
    "tileId": "1_4",
    "row": 1,
    "column": 4,
    "letter": "",
    "active": false,
    "alive": true
  },
  {
    "tileId": "1_5",
    "row": 1,
    "column": 5,
    "letter": "",
    "active": false,
    "alive": true
  },
  {
    "tileId": "1_6",
    "row": 1,
    "column": 6,
    "letter": "",
    "active": false,
    "alive": true
  },
  // ROW 2
  {
    "tileId": "2_1",
    "row": 2,
    "column": 1,
    "letter": "",
    "active": false,
    "alive": true
  },
  {
    "tileId": "2_2",
    "row": 2,
    "column": 2,
    "letter": "",
    "active": false,
    "alive": true
  },
  {
    "tileId": "2_3",
    "row": 2,
    "column": 3,
    "letter": "",
    "active": false,
    "alive": true
  },
  {
    "tileId": "2_4",
    "row": 2,
    "column": 4,
    "letter": "",
    "active": false,
    "alive": true
  },
  {
    "tileId": "2_5",
    "row": 2,
    "column": 5,
    "letter": "",
    "active": false,
    "alive": true
  },
  {
    "tileId": "2_6",
    "row": 2,
    "column": 6,
    "letter": "",
    "active": false,
    "alive": true
  },
  // ROW 3
  {
    "tileId": "3_1",
    "row": 3,
    "column": 1,
    "letter": "",
    "active": false,
    "alive": true
  },
  {
    "tileId": "3_2",
    "row": 3,
    "column": 2,
    "letter": "",
    "active": false,
    "alive": true
  },
  {
    "tileId": "3_3",
    "row": 3,
    "column": 3,
    "letter": "",
    "active": false,
    "alive": true
  },
  {
    "tileId": "3_4",
    "row": 3,
    "column": 4,
    "letter": "",
    "active": false,
    "alive": true
  },
  {
    "tileId": "3_5",
    "row": 3,
    "column": 5,
    "letter": "",
    "active": false,
    "alive": true
  },
  {
    "tileId": "3_6",
    "row": 3,
    "column": 6,
    "letter": "",
    "active": false,
    "alive": true
  },
  // ROW 4
  {
    "tileId": "4_1",
    "row": 4,
    "column": 1,
    "letter": "",
    "active": false,
    "alive": true
  },
  {
    "tileId": "4_2",
    "row": 4,
    "column": 2,
    "letter": "",
    "active": false,
    "alive": true
  },
  {
    "tileId": "4_3",
    "row": 4,
    "column": 3,
    "letter": "",
    "active": false,
    "alive": true
  },
  {
    "tileId": "4_4",
    "row": 4,
    "column": 4,
    "letter": "",
    "active": false,
    "alive": true
  },
  {
    "tileId": "4_5",
    "row": 4,
    "column": 5,
    "letter": "",
    "active": false,
    "alive": true
  },
  {
    "tileId": "4_6",
    "row": 4,
    "column": 6,
    "letter": "",
    "active": false,
    "alive": true
  },
  // ROW 5
  {
    "tileId": "5_1",
    "row": 5,
    "column": 1,
    "letter": "",
    "active": false,
    "alive": true
  },
  {
    "tileId": "5_2",
    "row": 5,
    "column": 2,
    "letter": "",
    "active": false,
    "alive": true
  },
  {
    "tileId": "5_3",
    "row": 5,
    "column": 3,
    "letter": "",
    "active": false,
    "alive": true
  },
  {
    "tileId": "5_4",
    "row": 5,
    "column": 4,
    "letter": "",
    "active": false,
    "alive": true
  },
  {
    "tileId": "5_5",
    "row": 5,
    "column": 5,
    "letter": "",
    "active": false,
    "alive": true
  },
  {
    "tileId": "5_6",
    "row": 5,
    "column": 6,
    "letter": "",
    "active": false,
    "alive": true
  },
  // ROW 6
  {
    "tileId": "6_1",
    "row": 6,
    "column": 1,
    "letter": "",
    "active": false,
    "alive": true
  },
  {
    "tileId": "6_2",
    "row": 6,
    "column": 2,
    "letter": "",
    "active": false,
    "alive": true
  },
  {
    "tileId": "6_3",
    "row": 6,
    "column": 3,
    "letter": "",
    "active": false,
    "alive": true
  },
  {
    "tileId": "6_4",
    "row": 6,
    "column": 4,
    "letter": "",
    "active": false,
    "alive": true
  },
  {
    "tileId": "6_5",
    "row": 6,
    "column": 5,
    "letter": "",
    "active": false,
    "alive": true
  },
  {
    "tileId": "6_6",
    "row": 6,
    "column": 6,
    "letter": "",
    "active": false,
    "alive": true
  },
];

List<Map<String, dynamic>> alphabets = [
  {
    "language": "english",
    "alphabet": englishAlphabet,
  },
  {
    "language": "french",
    "alphabet": frenchAlphabet,
  },
];

// List<Map<String,dynamic>> initialRandomLetterState = [
//   {"letter" : "A", "type" : "vowel",      "points": 1,  "count": 86, "inPlay": 0},
//   {"letter" : "B", "type" : "consonant",  "points": 3,  "count": 24, "inPlay": 0},
//   {"letter" : "C", "type" : "consonant",  "points": 1,  "count": 33, "inPlay": 0},
//   {"letter" : "D", "type" : "consonant",  "points": 2,  "count": 39, "inPlay": 0},
//   {"letter" : "E", "type" : "vowel",      "points": 1,  "count": 111, "inPlay": 0},
//   {"letter" : "F", "type" : "consonant",  "points": 3,  "count": 17, "inPlay": 0},
//   {"letter" : "G", "type" : "consonant",  "points": 1,  "count": 27, "inPlay": 0},
//   {"letter" : "H", "type" : "consonant",  "points": 1,  "count": 27, "inPlay": 0},
//   {"letter" : "I", "type" : "vowel",      "points": 1,  "count": 64, "inPlay": 0},
//   {"letter" : "J", "type" : "consonant",  "points": 10, "count": 4, "inPlay": 0},
//   {"letter" : "K", "type" : "consonant",  "points": 1,  "count": 21, "inPlay": 0},
//   {"letter" : "L", "type" : "consonant",  "points": 2,  "count": 54, "inPlay": 0},
//   {"letter" : "M", "type" : "consonant",  "points": 1,  "count": 30, "inPlay": 0},
//   {"letter" : "N", "type" : "consonant",  "points": 2,  "count": 49, "inPlay": 0},
//   {"letter" : "O", "type" : "vowel",      "points": 1,  "count": 64, "inPlay": 0},
//   {"letter" : "P", "type" : "consonant",  "points": 1,  "count": 29, "inPlay": 0},
//   {"letter" : "Q", "type" : "consonant",  "points": 10, "count": 2, "inPlay": 0},
//   {"letter" : "R", "type" : "consonant",  "points": 1,  "count": 67, "inPlay": 0},
//   {"letter" : "S", "type" : "consonant",  "points": 1,  "count": 95, "inPlay": 0},
//   {"letter" : "T", "type" : "consonant",  "points": 2,  "count": 50, "inPlay": 0},
//   {"letter" : "U", "type" : "vowel",      "points": 2,  "count": 21, "inPlay": 0}, // count originally 41
//   {"letter" : "V", "type" : "consonant",  "points": 2,  "count": 11, "inPlay": 0},
//   {"letter" : "W", "type" : "consonant",  "points": 2,  "count": 15, "inPlay": 0},
//   {"letter" : "X", "type" : "consonant",  "points": 5,  "count": 4, "inPlay": 0},
//   {"letter" : "Y", "type" : "consonant",  "points": 5,  "count": 27, "inPlay": 0},
//   {"letter" : "Z", "type" : "consonant",  "points": 9,  "count": 7, "inPlay": 0},
// ];

// List<Map<String,dynamic>> initialRandomLetterState = getInitialRandomLetterState()

// List<Map<String,dynamic>> startingAlphabetState = GameLogic().generateStartingStates(initialRandomLetterState, initialBoardState, [])['startingAlphabet'];
// List<String> randomLetterListState = GameLogic().generateStartingStates(initialRandomLetterState, initialBoardState, [])['startingRandomLetterList'];
// List<Map<String,dynamic>> startingTileState = GameLogic().generateStartingStates(initialRandomLetterState, initialBoardState, [])['startingTileState'];
// List<String> randomLetterListState = [];

List<Map<String, dynamic>> turnSummaryState = [];

List<Map<String, dynamic>> stringCombinations = [
  {
    'len': 3,
    'arr': ['1_1', '1_2', '1_3'],
    'axis': 'row'
  },
  {
    'len': 3,
    'arr': ['1_2', '1_3', '1_4'],
    'axis': 'row'
  },
  {
    'len': 3,
    'arr': ['1_3', '1_4', '1_5'],
    'axis': 'row'
  },
  {
    'len': 3,
    'arr': ['1_4', '1_5', '1_6'],
    'axis': 'row'
  },
  {
    'len': 3,
    'arr': ['2_1', '2_2', '2_3'],
    'axis': 'row'
  },
  {
    'len': 3,
    'arr': ['2_2', '2_3', '2_4'],
    'axis': 'row'
  },
  {
    'len': 3,
    'arr': ['2_3', '2_4', '2_5'],
    'axis': 'row'
  },
  {
    'len': 3,
    'arr': ['2_4', '2_5', '2_6'],
    'axis': 'row'
  },
  {
    'len': 3,
    'arr': ['3_1', '3_2', '3_3'],
    'axis': 'row'
  },
  {
    'len': 3,
    'arr': ['3_2', '3_3', '3_4'],
    'axis': 'row'
  },
  {
    'len': 3,
    'arr': ['3_3', '3_4', '3_5'],
    'axis': 'row'
  },
  {
    'len': 3,
    'arr': ['3_4', '3_5', '3_6'],
    'axis': 'row'
  },
  {
    'len': 3,
    'arr': ['4_1', '4_2', '4_3'],
    'axis': 'row'
  },
  {
    'len': 3,
    'arr': ['4_2', '4_3', '4_4'],
    'axis': 'row'
  },
  {
    'len': 3,
    'arr': ['4_3', '4_4', '4_5'],
    'axis': 'row'
  },
  {
    'len': 3,
    'arr': ['4_4', '4_5', '4_6'],
    'axis': 'row'
  },
  {
    'len': 3,
    'arr': ['5_1', '5_2', '5_3'],
    'axis': 'row'
  },
  {
    'len': 3,
    'arr': ['5_2', '5_3', '5_4'],
    'axis': 'row'
  },
  {
    'len': 3,
    'arr': ['5_3', '5_4', '5_5'],
    'axis': 'row'
  },
  {
    'len': 3,
    'arr': ['5_4', '5_5', '5_6'],
    'axis': 'row'
  },
  {
    'len': 3,
    'arr': ['6_1', '6_2', '6_3'],
    'axis': 'row'
  },
  {
    'len': 3,
    'arr': ['6_2', '6_3', '6_4'],
    'axis': 'row'
  },
  {
    'len': 3,
    'arr': ['6_3', '6_4', '6_5'],
    'axis': 'row'
  },
  {
    'len': 3,
    'arr': ['6_4', '6_5', '6_6'],
    'axis': 'row'
  },
  {
    'len': 4,
    'arr': ['1_1', '1_2', '1_3', '1_4'],
    'axis': 'row'
  },
  {
    'len': 4,
    'arr': ['1_2', '1_3', '1_4', '1_5'],
    'axis': 'row'
  },
  {
    'len': 4,
    'arr': ['1_3', '1_4', '1_5', '1_6'],
    'axis': 'row'
  },
  {
    'len': 4,
    'arr': ['2_1', '2_2', '2_3', '2_4'],
    'axis': 'row'
  },
  {
    'len': 4,
    'arr': ['2_2', '2_3', '2_4', '2_5'],
    'axis': 'row'
  },
  {
    'len': 4,
    'arr': ['2_3', '2_4', '2_5', '2_6'],
    'axis': 'row'
  },
  {
    'len': 4,
    'arr': ['3_1', '3_2', '3_3', '3_4'],
    'axis': 'row'
  },
  {
    'len': 4,
    'arr': ['3_2', '3_3', '3_4', '3_5'],
    'axis': 'row'
  },
  {
    'len': 4,
    'arr': ['3_3', '3_4', '3_5', '3_6'],
    'axis': 'row'
  },
  {
    'len': 4,
    'arr': ['4_1', '4_2', '4_3', '4_4'],
    'axis': 'row'
  },
  {
    'len': 4,
    'arr': ['4_2', '4_3', '4_4', '4_5'],
    'axis': 'row'
  },
  {
    'len': 4,
    'arr': ['4_3', '4_4', '4_5', '4_6'],
    'axis': 'row'
  },
  {
    'len': 4,
    'arr': ['5_1', '5_2', '5_3', '5_4'],
    'axis': 'row'
  },
  {
    'len': 4,
    'arr': ['5_2', '5_3', '5_4', '5_5'],
    'axis': 'row'
  },
  {
    'len': 4,
    'arr': ['5_3', '5_4', '5_5', '5_6'],
    'axis': 'row'
  },
  {
    'len': 4,
    'arr': ['6_1', '6_2', '6_3', '6_4'],
    'axis': 'row'
  },
  {
    'len': 4,
    'arr': ['6_2', '6_3', '6_4', '6_5'],
    'axis': 'row'
  },
  {
    'len': 4,
    'arr': ['6_3', '6_4', '6_5', '6_6'],
    'axis': 'row'
  },
  {
    'len': 5,
    'arr': ['1_1', '1_2', '1_3', '1_4', '1_5'],
    'axis': 'row'
  },
  {
    'len': 5,
    'arr': ['1_2', '1_3', '1_4', '1_5', '1_6'],
    'axis': 'row'
  },
  {
    'len': 5,
    'arr': ['2_1', '2_2', '2_3', '2_4', '2_5'],
    'axis': 'row'
  },
  {
    'len': 5,
    'arr': ['2_2', '2_3', '2_4', '2_5', '2_6'],
    'axis': 'row'
  },
  {
    'len': 5,
    'arr': ['3_1', '3_2', '3_3', '3_4', '3_5'],
    'axis': 'row'
  },
  {
    'len': 5,
    'arr': ['3_2', '3_3', '3_4', '3_5', '3_6'],
    'axis': 'row'
  },
  {
    'len': 5,
    'arr': ['4_1', '4_2', '4_3', '4_4', '4_5'],
    'axis': 'row'
  },
  {
    'len': 5,
    'arr': ['4_2', '4_3', '4_4', '4_5', '4_6'],
    'axis': 'row'
  },
  {
    'len': 5,
    'arr': ['5_1', '5_2', '5_3', '5_4', '5_5'],
    'axis': 'row'
  },
  {
    'len': 5,
    'arr': ['5_2', '5_3', '5_4', '5_5', '5_6'],
    'axis': 'row'
  },
  {
    'len': 5,
    'arr': ['6_1', '6_2', '6_3', '6_4', '6_5'],
    'axis': 'row'
  },
  {
    'len': 5,
    'arr': ['6_2', '6_3', '6_4', '6_5', '6_6'],
    'axis': 'row'
  },
  {
    'len': 6,
    'arr': ['1_1', '1_2', '1_3', '1_4', '1_5', '1_6'],
    'axis': 'row'
  },
  {
    'len': 6,
    'arr': ['2_1', '2_2', '2_3', '2_4', '2_5', '2_6'],
    'axis': 'row'
  },
  {
    'len': 6,
    'arr': ['3_1', '3_2', '3_3', '3_4', '3_5', '3_6'],
    'axis': 'row'
  },
  {
    'len': 6,
    'arr': ['4_1', '4_2', '4_3', '4_4', '4_5', '4_6'],
    'axis': 'row'
  },
  {
    'len': 6,
    'arr': ['5_1', '5_2', '5_3', '5_4', '5_5', '5_6'],
    'axis': 'row'
  },
  {
    'len': 6,
    'arr': ['6_1', '6_2', '6_3', '6_4', '6_5', '6_6'],
    'axis': 'row'
  },
  {
    'len': 3,
    'arr': ['1_1', '2_1', '3_1'],
    'axis': 'column'
  },
  {
    'len': 3,
    'arr': ['1_2', '2_2', '3_2'],
    'axis': 'column'
  },
  {
    'len': 3,
    'arr': ['1_3', '2_3', '3_3'],
    'axis': 'column'
  },
  {
    'len': 3,
    'arr': ['1_4', '2_4', '3_4'],
    'axis': 'column'
  },
  {
    'len': 3,
    'arr': ['1_5', '2_5', '3_5'],
    'axis': 'column'
  },
  {
    'len': 3,
    'arr': ['1_6', '2_6', '3_6'],
    'axis': 'column'
  },
  {
    'len': 3,
    'arr': ['2_1', '3_1', '4_1'],
    'axis': 'column'
  },
  {
    'len': 3,
    'arr': ['2_2', '3_2', '4_2'],
    'axis': 'column'
  },
  {
    'len': 3,
    'arr': ['2_3', '3_3', '4_3'],
    'axis': 'column'
  },
  {
    'len': 3,
    'arr': ['2_4', '3_4', '4_4'],
    'axis': 'column'
  },
  {
    'len': 3,
    'arr': ['2_5', '3_5', '4_5'],
    'axis': 'column'
  },
  {
    'len': 3,
    'arr': ['2_6', '3_6', '4_6'],
    'axis': 'column'
  },
  {
    'len': 3,
    'arr': ['3_1', '4_1', '5_1'],
    'axis': 'column'
  },
  {
    'len': 3,
    'arr': ['3_2', '4_2', '5_2'],
    'axis': 'column'
  },
  {
    'len': 3,
    'arr': ['3_3', '4_3', '5_3'],
    'axis': 'column'
  },
  {
    'len': 3,
    'arr': ['3_4', '4_4', '5_4'],
    'axis': 'column'
  },
  {
    'len': 3,
    'arr': ['3_5', '4_5', '5_5'],
    'axis': 'column'
  },
  {
    'len': 3,
    'arr': ['3_6', '4_6', '5_6'],
    'axis': 'column'
  },
  {
    'len': 3,
    'arr': ['4_1', '5_1', '6_1'],
    'axis': 'column'
  },
  {
    'len': 3,
    'arr': ['4_2', '5_2', '6_2'],
    'axis': 'column'
  },
  {
    'len': 3,
    'arr': ['4_3', '5_3', '6_3'],
    'axis': 'column'
  },
  {
    'len': 3,
    'arr': ['4_4', '5_4', '6_4'],
    'axis': 'column'
  },
  {
    'len': 3,
    'arr': ['4_5', '5_5', '6_5'],
    'axis': 'column'
  },
  {
    'len': 3,
    'arr': ['4_6', '5_6', '6_6'],
    'axis': 'column'
  },
  {
    'len': 4,
    'arr': ['1_1', '2_1', '3_1', '4_1'],
    'axis': 'column'
  },
  {
    'len': 4,
    'arr': ['1_2', '2_2', '3_2', '4_2'],
    'axis': 'column'
  },
  {
    'len': 4,
    'arr': ['1_3', '2_3', '3_3', '4_3'],
    'axis': 'column'
  },
  {
    'len': 4,
    'arr': ['1_4', '2_4', '3_4', '4_4'],
    'axis': 'column'
  },
  {
    'len': 4,
    'arr': ['1_5', '2_5', '3_5', '4_5'],
    'axis': 'column'
  },
  {
    'len': 4,
    'arr': ['1_6', '2_6', '3_6', '4_6'],
    'axis': 'column'
  },
  {
    'len': 4,
    'arr': ['2_1', '3_1', '4_1', '5_1'],
    'axis': 'column'
  },
  {
    'len': 4,
    'arr': ['2_2', '3_2', '4_2', '5_2'],
    'axis': 'column'
  },
  {
    'len': 4,
    'arr': ['2_3', '3_3', '4_3', '5_3'],
    'axis': 'column'
  },
  {
    'len': 4,
    'arr': ['2_4', '3_4', '4_4', '5_4'],
    'axis': 'column'
  },
  {
    'len': 4,
    'arr': ['2_5', '3_5', '4_5', '5_5'],
    'axis': 'column'
  },
  {
    'len': 4,
    'arr': ['2_6', '3_6', '4_6', '5_6'],
    'axis': 'column'
  },
  {
    'len': 4,
    'arr': ['3_1', '4_1', '5_1', '6_1'],
    'axis': 'column'
  },
  {
    'len': 4,
    'arr': ['3_2', '4_2', '5_2', '6_2'],
    'axis': 'column'
  },
  {
    'len': 4,
    'arr': ['3_3', '4_3', '5_3', '6_3'],
    'axis': 'column'
  },
  {
    'len': 4,
    'arr': ['3_4', '4_4', '5_4', '6_4'],
    'axis': 'column'
  },
  {
    'len': 4,
    'arr': ['3_5', '4_5', '5_5', '6_5'],
    'axis': 'column'
  },
  {
    'len': 4,
    'arr': ['3_6', '4_6', '5_6', '6_6'],
    'axis': 'column'
  },
  {
    'len': 5,
    'arr': ['1_1', '2_1', '3_1', '4_1', '5_1'],
    'axis': 'column'
  },
  {
    'len': 5,
    'arr': ['1_2', '2_2', '3_2', '4_2', '5_2'],
    'axis': 'column'
  },
  {
    'len': 5,
    'arr': ['1_3', '2_3', '3_3', '4_3', '5_3'],
    'axis': 'column'
  },
  {
    'len': 5,
    'arr': ['1_4', '2_4', '3_4', '4_4', '5_4'],
    'axis': 'column'
  },
  {
    'len': 5,
    'arr': ['1_5', '2_5', '3_5', '4_5', '5_5'],
    'axis': 'column'
  },
  {
    'len': 5,
    'arr': ['1_6', '2_6', '3_6', '4_6', '5_6'],
    'axis': 'column'
  },
  {
    'len': 5,
    'arr': ['2_1', '3_1', '4_1', '5_1', '6_1'],
    'axis': 'column'
  },
  {
    'len': 5,
    'arr': ['2_2', '3_2', '4_2', '5_2', '6_2'],
    'axis': 'column'
  },
  {
    'len': 5,
    'arr': ['2_3', '3_3', '4_3', '5_3', '6_3'],
    'axis': 'column'
  },
  {
    'len': 5,
    'arr': ['2_4', '3_4', '4_4', '5_4', '6_4'],
    'axis': 'column'
  },
  {
    'len': 5,
    'arr': ['2_5', '3_5', '4_5', '5_5', '6_5'],
    'axis': 'column'
  },
  {
    'len': 5,
    'arr': ['2_6', '3_6', '4_6', '5_6', '6_6'],
    'axis': 'column'
  },
  {
    'len': 6,
    'arr': ['1_1', '2_1', '3_1', '4_1', '5_1', '6_1'],
    'axis': 'column'
  },
  {
    'len': 6,
    'arr': ['1_2', '2_2', '3_2', '4_2', '5_2', '6_2'],
    'axis': 'column'
  },
  {
    'len': 6,
    'arr': ['1_3', '2_3', '3_3', '4_3', '5_3', '6_3'],
    'axis': 'column'
  },
  {
    'len': 6,
    'arr': ['1_4', '2_4', '3_4', '4_4', '5_4', '6_4'],
    'axis': 'column'
  },
  {
    'len': 6,
    'arr': ['1_5', '2_5', '3_5', '4_5', '5_5', '6_5'],
    'axis': 'column'
  },
  {
    'len': 6,
    'arr': ['1_6', '2_6', '3_6', '4_6', '5_6', '6_6'],
    'axis': 'column'
  },
];

List<Map<String, dynamic>> demoBoardState_1 = [
  // Random Letters
  {"tileId": "0_0", "row": 0, "column": 0, "letter": "A", "active": false},
  {"tileId": "0_1", "row": 0, "column": 1, "letter": "K", "active": false},
  // Board
  {"tileId": "1_1", "row": 1, "column": 1, "letter": "", "active": false},
  {"tileId": "1_2", "row": 1, "column": 2, "letter": "", "active": false},
  {"tileId": "1_3", "row": 1, "column": 3, "letter": "", "active": false},
  {"tileId": "2_1", "row": 2, "column": 1, "letter": "", "active": false},
  {"tileId": "2_2", "row": 2, "column": 2, "letter": "", "active": false},
  {"tileId": "2_3", "row": 2, "column": 3, "letter": "", "active": false},
  {"tileId": "3_1", "row": 3, "column": 1, "letter": "", "active": false},
  {"tileId": "3_2", "row": 3, "column": 2, "letter": "", "active": false},
  {"tileId": "3_3", "row": 3, "column": 3, "letter": "", "active": false},
];

List<Map<String, dynamic>> demoBoardState_2 = [
  // Random Letters
  {"tileId": "0_0", "row": 0, "column": 0, "letter": "K", "active": false},
  {"tileId": "0_1", "row": 0, "column": 1, "letter": "U", "active": false},
  // Board
  {"tileId": "1_1", "row": 1, "column": 1, "letter": "A", "active": false},
  {"tileId": "1_2", "row": 1, "column": 2, "letter": "", "active": false},
  {"tileId": "1_3", "row": 1, "column": 3, "letter": "", "active": false},
  {"tileId": "2_1", "row": 2, "column": 1, "letter": "", "active": false},
  {"tileId": "2_2", "row": 2, "column": 2, "letter": "", "active": false},
  {"tileId": "2_3", "row": 2, "column": 3, "letter": "", "active": false},
  {"tileId": "3_1", "row": 3, "column": 1, "letter": "", "active": false},
  {"tileId": "3_2", "row": 3, "column": 2, "letter": "", "active": false},
  {"tileId": "3_3", "row": 3, "column": 3, "letter": "", "active": false},
];

List<Map<String, dynamic>> demoBoardState_3 = [
  // Random Letters
  {"tileId": "0_0", "row": 0, "column": 0, "letter": "U", "active": false},
  {"tileId": "0_1", "row": 0, "column": 1, "letter": "S", "active": false},
  // Board
  {"tileId": "1_1", "row": 1, "column": 1, "letter": "A", "active": false},
  {"tileId": "1_2", "row": 1, "column": 2, "letter": "", "active": false},
  {"tileId": "1_3", "row": 1, "column": 3, "letter": "K", "active": false},
  {"tileId": "2_1", "row": 2, "column": 1, "letter": "", "active": false},
  {"tileId": "2_2", "row": 2, "column": 2, "letter": "", "active": false},
  {"tileId": "2_3", "row": 2, "column": 3, "letter": "", "active": false},
  {"tileId": "3_1", "row": 3, "column": 1, "letter": "", "active": false},
  {"tileId": "3_2", "row": 3, "column": 2, "letter": "", "active": false},
  {"tileId": "3_3", "row": 3, "column": 3, "letter": "", "active": false},
];

List<Map<String, dynamic>> demoBoardState_4 = [
  // Random Letters
  {"tileId": "0_0", "row": 0, "column": 0, "letter": "S", "active": false},
  {"tileId": "0_1", "row": 0, "column": 1, "letter": "E", "active": false},
  // Board
  {"tileId": "1_1", "row": 1, "column": 1, "letter": "A", "active": false},
  {"tileId": "1_2", "row": 1, "column": 2, "letter": "", "active": false},
  {"tileId": "1_3", "row": 1, "column": 3, "letter": "K", "active": false},
  {"tileId": "2_1", "row": 2, "column": 1, "letter": "", "active": false},
  {"tileId": "2_2", "row": 2, "column": 2, "letter": "", "active": false},
  {"tileId": "2_3", "row": 2, "column": 3, "letter": "U", "active": false},
  {"tileId": "3_1", "row": 3, "column": 1, "letter": "", "active": false},
  {"tileId": "3_2", "row": 3, "column": 2, "letter": "", "active": false},
  {"tileId": "3_3", "row": 3, "column": 3, "letter": "", "active": false},
];

List<Map<String, dynamic>> demoBoardState_5 = [
  // Random Letters
  {"tileId": "0_0", "row": 0, "column": 0, "letter": "E", "active": false},
  {"tileId": "0_1", "row": 0, "column": 1, "letter": "N", "active": false},
  // Board
  {"tileId": "1_1", "row": 1, "column": 1, "letter": "A", "active": true},
  {"tileId": "1_2", "row": 1, "column": 2, "letter": "S", "active": true},
  {"tileId": "1_3", "row": 1, "column": 3, "letter": "K", "active": true},
  {"tileId": "2_1", "row": 2, "column": 1, "letter": "", "active": false},
  {"tileId": "2_2", "row": 2, "column": 2, "letter": "", "active": false},
  {"tileId": "2_3", "row": 2, "column": 3, "letter": "U", "active": false},
  {"tileId": "3_1", "row": 3, "column": 1, "letter": "", "active": false},
  {"tileId": "3_2", "row": 3, "column": 2, "letter": "", "active": false},
  {"tileId": "3_3", "row": 3, "column": 3, "letter": "", "active": false},
];

List<Map<String, dynamic>> demoBoardState_6 = [
  // Random Letters
  {"tileId": "0_0", "row": 0, "column": 0, "letter": "E", "active": false},
  {"tileId": "0_1", "row": 0, "column": 1, "letter": "N", "active": false},
  // Board
  {"tileId": "1_1", "row": 1, "column": 1, "letter": "", "active": false},
  {"tileId": "1_2", "row": 1, "column": 2, "letter": "", "active": false},
  {"tileId": "1_3", "row": 1, "column": 3, "letter": "", "active": false},
  {"tileId": "2_1", "row": 2, "column": 1, "letter": "", "active": false},
  {"tileId": "2_2", "row": 2, "column": 2, "letter": "", "active": false},
  {"tileId": "2_3", "row": 2, "column": 3, "letter": "U", "active": false},
  {"tileId": "3_1", "row": 3, "column": 1, "letter": "", "active": false},
  {"tileId": "3_2", "row": 3, "column": 2, "letter": "", "active": false},
  {"tileId": "3_3", "row": 3, "column": 3, "letter": "", "active": false},
];

List<Map<String, dynamic>> englishAlphabet = [
  {"letter": "A", "type": "vowel", "points": 1, "count": 86, "inPlay": 0},
  {"letter": "B", "type": "consonant", "points": 3, "count": 24, "inPlay": 0},
  {"letter": "C", "type": "consonant", "points": 1, "count": 33, "inPlay": 0},
  {"letter": "D", "type": "consonant", "points": 2, "count": 39, "inPlay": 0},
  {"letter": "E", "type": "vowel", "points": 1, "count": 111, "inPlay": 0},
  {"letter": "F", "type": "consonant", "points": 3, "count": 17, "inPlay": 0},
  {"letter": "G", "type": "consonant", "points": 1, "count": 27, "inPlay": 0},
  {"letter": "H", "type": "consonant", "points": 1, "count": 27, "inPlay": 0},
  {"letter": "I", "type": "vowel", "points": 1, "count": 64, "inPlay": 0},
  {"letter": "J", "type": "consonant", "points": 10, "count": 4, "inPlay": 0},
  {"letter": "K", "type": "consonant", "points": 1, "count": 21, "inPlay": 0},
  {"letter": "L", "type": "consonant", "points": 2, "count": 54, "inPlay": 0},
  {"letter": "M", "type": "consonant", "points": 1, "count": 30, "inPlay": 0},
  {"letter": "N", "type": "consonant", "points": 2, "count": 49, "inPlay": 0},
  {"letter": "O", "type": "vowel", "points": 1, "count": 64, "inPlay": 0},
  {"letter": "P", "type": "consonant", "points": 1, "count": 29, "inPlay": 0},
  {"letter": "Q", "type": "consonant", "points": 10, "count": 2, "inPlay": 0},
  {"letter": "R", "type": "consonant", "points": 1, "count": 67, "inPlay": 0},
  {"letter": "S", "type": "consonant", "points": 1, "count": 95, "inPlay": 0},
  {"letter": "T", "type": "consonant", "points": 2, "count": 50, "inPlay": 0},
  {
    "letter": "U",
    "type": "vowel",
    "points": 2,
    "count": 21,
    "inPlay": 0
  }, // count originally 41
  {"letter": "V", "type": "consonant", "points": 2, "count": 11, "inPlay": 0},
  {"letter": "W", "type": "consonant", "points": 2, "count": 15, "inPlay": 0},
  {"letter": "X", "type": "consonant", "points": 5, "count": 4, "inPlay": 0},
  {"letter": "Y", "type": "consonant", "points": 5, "count": 27, "inPlay": 0},
  {"letter": "Z", "type": "consonant", "points": 9, "count": 7, "inPlay": 0},
];

List<Map<String, dynamic>> frenchAlphabet = [
  {"letter": "A", "type": "vowel", "points": 1, "count": 90, "inPlay": 0},
  {"letter": "B", "type": "consonant", "points": 3, "count": 20, "inPlay": 0},
  {"letter": "C", "type": "consonant", "points": 1, "count": 20, "inPlay": 0},
  {"letter": "D", "type": "consonant", "points": 2, "count": 30, "inPlay": 0},
  {"letter": "E", "type": "vowel", "points": 1, "count": 150, "inPlay": 0},
  {"letter": "F", "type": "consonant", "points": 4, "count": 20, "inPlay": 0},
  {"letter": "G", "type": "consonant", "points": 2, "count": 20, "inPlay": 0},
  {"letter": "H", "type": "consonant", "points": 4, "count": 20, "inPlay": 0},
  {"letter": "I", "type": "vowel", "points": 1, "count": 80, "inPlay": 0},
  {"letter": "J", "type": "consonant", "points": 8, "count": 10, "inPlay": 0},
  {"letter": "K", "type": "consonant", "points": 10, "count": 10, "inPlay": 0},
  {"letter": "L", "type": "consonant", "points": 1, "count": 50, "inPlay": 0},
  {"letter": "M", "type": "consonant", "points": 2, "count": 30, "inPlay": 0},
  {"letter": "N", "type": "consonant", "points": 1, "count": 60, "inPlay": 0},
  {"letter": "O", "type": "vowel", "points": 1, "count": 60, "inPlay": 0},
  {"letter": "P", "type": "consonant", "points": 3, "count": 20, "inPlay": 0},
  {"letter": "Q", "type": "consonant", "points": 8, "count": 3, "inPlay": 0},
  {"letter": "R", "type": "consonant", "points": 1, "count": 60, "inPlay": 0},
  {"letter": "S", "type": "consonant", "points": 1, "count": 60, "inPlay": 0},
  {"letter": "T", "type": "consonant", "points": 1, "count": 60, "inPlay": 0},
  {
    "letter": "U",
    "type": "vowel",
    "points": 1,
    "count": 60,
    "inPlay": 0
  }, // count originally 41
  {"letter": "V", "type": "consonant", "points": 4, "count": 20, "inPlay": 0},
  {"letter": "W", "type": "consonant", "points": 10, "count": 3, "inPlay": 0},
  {"letter": "X", "type": "consonant", "points": 10, "count": 3, "inPlay": 0},
  {"letter": "Y", "type": "consonant", "points": 10, "count": 3, "inPlay": 0},
  {"letter": "Z", "type": "consonant", "points": 10, "count": 3, "inPlay": 0},
];

List<Map<String, dynamic>> tutorial_board_1 = [
  // // Random Letters
  // {"tileId" : "0_0", "row":0 , "column":0 , "letter" : "E", "active": false},
  // {"tileId" : "0_1", "row":0 , "column":1 , "letter" : "N", "active": false},
  // Board
  {
    "index": 0,
    "tileId": "1_1",
    "row": 1,
    "column": 1,
    "letter": "",
    "active": false
  },
  {
    "index": 1,
    "tileId": "1_2",
    "row": 1,
    "column": 2,
    "letter": "",
    "active": false
  },
  {
    "index": 2,
    "tileId": "1_3",
    "row": 1,
    "column": 3,
    "letter": "",
    "active": false
  },
  {
    "index": 3,
    "tileId": "1_4",
    "row": 1,
    "column": 4,
    "letter": "",
    "active": false
  },
  {
    "index": 4,
    "tileId": "1_5",
    "row": 1,
    "column": 5,
    "letter": "",
    "active": false
  },
  {
    "index": 5,
    "tileId": "1_6",
    "row": 1,
    "column": 6,
    "letter": "",
    "active": false
  },

  {
    "index": 6,
    "tileId": "2_1",
    "row": 2,
    "column": 1,
    "letter": "",
    "active": false
  },
  {
    "index": 7,
    "tileId": "2_2",
    "row": 2,
    "column": 2,
    "letter": "",
    "active": false
  },
  {
    "index": 8,
    "tileId": "2_3",
    "row": 2,
    "column": 3,
    "letter": "",
    "active": false
  },
  {
    "index": 9,
    "tileId": "2_4",
    "row": 2,
    "column": 4,
    "letter": "",
    "active": false
  },
  {
    "index": 10,
    "tileId": "2_5",
    "row": 2,
    "column": 5,
    "letter": "",
    "active": false
  },
  {
    "index": 11,
    "tileId": "2_6",
    "row": 2,
    "column": 6,
    "letter": "",
    "active": false
  },

  {
    "index": 12,
    "tileId": "3_1",
    "row": 3,
    "column": 1,
    "letter": "",
    "active": false
  },
  {
    "index": 13,
    "tileId": "3_2",
    "row": 3,
    "column": 2,
    "letter": "",
    "active": false
  },
  {
    "index": 14,
    "tileId": "3_3",
    "row": 3,
    "column": 3,
    "letter": "",
    "active": false
  },
  {
    "index": 15,
    "tileId": "3_4",
    "row": 3,
    "column": 4,
    "letter": "",
    "active": false
  },
  {
    "index": 16,
    "tileId": "3_5",
    "row": 3,
    "column": 5,
    "letter": "",
    "active": false
  },
  {
    "index": 17,
    "tileId": "3_6",
    "row": 3,
    "column": 6,
    "letter": "",
    "active": false
  },

  {
    "index": 18,
    "tileId": "4_1",
    "row": 4,
    "column": 1,
    "letter": "",
    "active": false
  },
  {
    "index": 19,
    "tileId": "4_2",
    "row": 4,
    "column": 2,
    "letter": "",
    "active": false
  },
  {
    "index": 20,
    "tileId": "4_3",
    "row": 4,
    "column": 3,
    "letter": "",
    "active": false
  },
  {
    "index": 21,
    "tileId": "4_4",
    "row": 4,
    "column": 4,
    "letter": "",
    "active": false
  },
  {
    "index": 22,
    "tileId": "4_5",
    "row": 4,
    "column": 5,
    "letter": "",
    "active": false
  },
  {
    "index": 23,
    "tileId": "4_6",
    "row": 4,
    "column": 6,
    "letter": "",
    "active": false
  },

  {
    "index": 24,
    "tileId": "5_1",
    "row": 5,
    "column": 1,
    "letter": "",
    "active": false
  },
  {
    "index": 25,
    "tileId": "5_2",
    "row": 5,
    "column": 2,
    "letter": "",
    "active": false
  },
  {
    "index": 26,
    "tileId": "5_3",
    "row": 5,
    "column": 3,
    "letter": "",
    "active": false
  },
  {
    "index": 27,
    "tileId": "5_4",
    "row": 5,
    "column": 4,
    "letter": "",
    "active": false
  },
  {
    "index": 28,
    "tileId": "5_5",
    "row": 5,
    "column": 5,
    "letter": "",
    "active": false
  },
  {
    "index": 29,
    "tileId": "5_6",
    "row": 5,
    "column": 6,
    "letter": "",
    "active": false
  },

  {
    "index": 30,
    "tileId": "6_1",
    "row": 6,
    "column": 1,
    "letter": "",
    "active": false
  },
  {
    "index": 31,
    "tileId": "6_2",
    "row": 6,
    "column": 2,
    "letter": "",
    "active": false
  },
  {
    "index": 32,
    "tileId": "6_3",
    "row": 6,
    "column": 3,
    "letter": "",
    "active": false
  },
  {
    "index": 33,
    "tileId": "6_4",
    "row": 6,
    "column": 4,
    "letter": "",
    "active": false
  },
  {
    "index": 34,
    "tileId": "6_5",
    "row": 6,
    "column": 5,
    "letter": "",
    "active": false
  },
  {
    "index": 35,
    "tileId": "6_6",
    "row": 6,
    "column": 6,
    "letter": "O",
    "active": false
  },
];
