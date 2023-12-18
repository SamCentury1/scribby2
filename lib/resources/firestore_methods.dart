import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
// import 'package:scribby_flutter_v2/providers/game_play_state.dart';
// import 'package:scribby_flutter_v2/providers/settings_state.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String,dynamic>?> getUserData(String uid,) async {
    late Map<String,dynamic>? res = {};
    try {
      final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
      final docSnap = await docRef.get();
      final Map<String, dynamic>? docData = docSnap.data() ;
      res = docData;
    } catch (e) {
      debugPrint(e.toString());
    }
    return res;
  } 


  // Future<void> saveGameToFirestore(String uid, Map<String,dynamic> gameData) async {
  //   final Map<String,dynamic> data = {
  //     "user" : uid,
  //     "timeStamp" : gameData["timeStamp"] ,
  //     "duration": gameData["duration"], 
  //     "points" : gameData["points"], 
  //     "uniqueWords": gameData["uniqueWords"], 
  //     "uniqueWordsList": gameData["uniqueWordsList"], 
  //     "longestStreak": gameData["longestStreak"],
  //     "mostWords": gameData["mostWords"],
  //     "mostPoints": gameData["mostPoints"], 
  //     "crossWords": gameData["crossWords"], 
  //     "level": gameData["level"],
  //     "language": gameData["language"], // TO DO: CHANGE THIS ONCE MORE LANGUAGES ARE ADDED
  //   };
  //   try {
  //     final newGameRef = _firestore.collection('games').doc();
  //     await newGameRef.set(data);

  //     final userSnap = _firestore.collection("users").doc();
  //     final DocumentSnapshot documentSnap = await userSnap.get();
  //     print(documentSnap);

  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }


  Future<void> saveHighScore(String uid,  Map<String,dynamic> gameData) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
      final docSnap = await docRef.get();
      final Map<String, dynamic> docData = docSnap.data() as Map<String,dynamic> ;
      String language = docData['parameters']['currentLanguage'];
      late Map<String,dynamic> userHighScores = docData['highScores'];
      int currentHighScore = userHighScores[language];
      if (gameData['points'] > currentHighScore) {
        userHighScores.update(language, (value) => gameData['points']);
        await _firestore.collection("users").doc(uid).update({
          "highScores" : userHighScores,
        });         
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Future<void> test(String uid, Map<String,dynamic> gameData) async {

  //   try {


  //     final userSnap = _firestore.collection("users").doc(uid);
  //     final documentSnap = await userSnap.get();
  //     final Map<String, dynamic>? docData = documentSnap.data() ;

  //     int wordsHS = docData!['highScores'][gameData["language"]]['words'];
  //     int pointsHS = docData['highScores'][gameData["language"]]['points'];

  //     late Map<String,dynamic> newHighScoresForLanguage = {
  //       "points": pointsHS > gameData["points"] ? pointsHS : gameData["points"],
  //       "words": wordsHS > gameData["uniqueWords"] ? wordsHS : gameData["uniqueWords"],
  //     };

  //     late Map<String,dynamic> newHighScoresDocument = {};

  //     docData!['highScores'].forEach((key, value) {
  //       // print("$key : $value");
  //       if (key == gameData["language"]) {
  //         newHighScoresDocument[gameData["language"]] = newHighScoresForLanguage;
  //       } else {
  //         newHighScoresDocument[key] = value;
  //       }
  //     });

  //     await _firestore.collection("users").doc(uid).update({
  //       "highScores" : newHighScoresDocument 
  //     });      

      
  //   } catch (e) {
  //     // print(e.toString());
  //   }

  // }  


  // Future<List<Map<String,dynamic>?>> getUserGames(String uid) async {
  //   late List<Map<String,dynamic>> res = [];


  //   try {
  //     QuerySnapshot qSnap =  await _firestore.collection("games")
  //     .where("user", isEqualTo: uid)
  //     // .orderBy("points",descending: true)
  //     // .limit(5)
  //     .get();

  //     for (DocumentSnapshot qDocSnap in qSnap.docs) {
  //       late Map<String,dynamic>? gameData = qDocSnap.data() as Map<String,dynamic>;
  //       res.add(gameData);
  //     }          

  //   } catch (e) {
  //     print(e.toString());
  //   }
  //   return res;
  // }

  Future<List<Map<String,dynamic>>?> getDataForLeaderboards(String currentLanguage) async {
    late List<Map<String,dynamic>> res = [];
    try {

      // /// We get the document data of the current user and identify the current language
      // final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
      // final docSnap = await docRef.get();
      // final Map<String, dynamic> docData = docSnap.data() as Map<String,dynamic> ;
      // final String currentLanguage = docData['parameters']['currentLanguage'];

      QuerySnapshot qSnap =  await _firestore
        .collection("users")
        .where("highScores.$currentLanguage", isGreaterThan: 0)
        .orderBy("highScores.$currentLanguage", descending: true)
        .limit(50)
        .get();      

      late List<Map<String,dynamic>> userList = [];
      for (DocumentSnapshot qDocSnap in qSnap.docs)  {
        late Map<String,dynamic> userData = qDocSnap.data() as Map<String,dynamic>;
        userList.add({
          "user": userData['uid'],
          "username" : userData['username'],
          "points": userData['highScores'][currentLanguage],
        });
      }
      res = userList;
    } catch (e) {
      debugPrint(e.toString());
    }
    return res;    
  }


  // Future<void> updateLanguageSelection(String uid, List<String> newLanguages) async {
  //   try {
  //     final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
  //     final docSnap = await docRef.get();
  //     final Map<String, dynamic> docData = docSnap.data() as Map<String,dynamic> ;

  //     final String currentLanguage = docData['parameters']['currentLanguage'];
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }

    
  // }


  // Future<Map<String,dynamic>?> getLeaderboards(String uid) async {
  //   late Map<String, dynamic>? res = {};




  //   try {
  //     QuerySnapshot qSnap =  await _firestore.collection("users")
  //     // .where("languages", arrayContains : "english")
  //     // .orderBy("points",descending: true)
  //     // .limit(5)
  //     .get();



  //     late List<Map<String,dynamic>> userList = [];      

  //     for (DocumentSnapshot qDocSnap in qSnap.docs)  {
  //       late Map<String,dynamic>? userData = qDocSnap.data() as Map<String,dynamic>;

  //       if (userData['parameters']['languages'].contains(userData['parameters']['currentLanguage'])) {

  //         // print("user data $userData");
  //         userList.add({
  //           "user": userData['uid'],
  //           "username" : userData['username'],
  //           "points": userData['highScores']['english']['points'],
  //           "words": userData['highScores']['english']['words'],
  //         });
  //       }
  //     }



  //     // print(" user list $userList");

  //     // pointsList.sort((a,b) => (b.compareTo(a));

  //     // pointsList.sort((a,b) => a['points'].compareTo(b['points']));
  //     // wordsList.sort((a,b) => a['words'].compareTo(b['words']));

  //     userList.sort((a,b) => b['points'].compareTo(a['points']));
  //     late List<Map<String,dynamic>> pointsList = userList;
  //     // print("points ==== ${pointsList}");
      
      
  //     // print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");


  //     userList.sort((a,b) => b['words'].compareTo(a['words']));
  //     late List<Map<String,dynamic>> wordsList = userList;
  //     // print("words ==== ${wordsList}");

  //     // res = {
  //     //   "english" : {
  //     //     "points" : pointsList,
  //     //     "words" : wordsList,
  //     //   }
  //     // };

  //     res = {
  //       "english": userList
  //     };

  //     // print("firestore method : $res");


  //   } catch (e) {
  //     print(e.toString());

  //   }
  //     return res;
  // }


  Future<List<dynamic>> getAlphabet(String uid) async {

    late List<dynamic> res = [];

    try {
      final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
      final docSnap = await docRef.get();
      final Map<String, dynamic> docData = docSnap.data() as Map<String, dynamic>;

      String language = docData['parameters']['currentLanguage'];


      QuerySnapshot qSnap =  await _firestore.collection("alphabets")
      .where("language", isEqualTo: language)
      .get();

      List<Map<String,dynamic>> documents = [];

      for (DocumentSnapshot qDocSnap in qSnap.docs) {
        late Map<String,dynamic> alphabetData = qDocSnap.data() as Map<String,dynamic>;
        documents.add(alphabetData);
      }   

      Map<String,dynamic> alphabetDoc = documents.firstWhere((element) => element['language'] == language);

      res = alphabetDoc['alphabet'];

      
    } catch (e) {
      debugPrint(e.toString());
    }

    return res;

  }



  Future<void> selectLanguage(String uid, String currentLanguage, List<String> languages) async {
    try {
      final docRef = _firestore.collection('users').doc(uid);
      final docSnap = await docRef.get();
      final Map<String, dynamic> docData = docSnap.data() as Map<String, dynamic>;


      Map<String, dynamic> newParams = {
        "currentLanguage" : currentLanguage,
        "languages": languages,
        "darkMode" : docData['parameters']['darkMode'],
        "muted": docData['parameters']['muted'],
        "soundOn" : docData['parameters']['soundOn'],
      };
      await docRef.update({"parameters" : newParams});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Future<void> uploadAlphabet(List<Map<String,dynamic>> alphabets) async {

  //   try {
  //     for (Map<String,dynamic> alphabet in alphabets)  {
  //       final alphabetDoc = _firestore.collection('alphabets').doc();
  //       await alphabetDoc.set(alphabet);
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }

  // }


  Future<void> toggleDarkTheme(String uid, bool value) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
      final docSnap = await docRef.get();
      final Map<String, dynamic> docData = docSnap.data() as Map<String,dynamic>;
      Map<String, dynamic> newParams = {
        "currentLanguage" : docData['parameters']['currentLanguage'],
        "languages": docData['parameters']['languages'],
        "darkMode" : value,
        "muted": docData['parameters']['muted'],
        "soundOn" : docData['parameters']['soundOn'],
      };   

      await docRef.update({"parameters" : newParams});   
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // EXECUTES IN THE SETTINGS PAGE - IN THE DROPOWN MENU FOR CHANGING THE CURRENT LANGUAGE
  Future<void> updateParameters(String uid, String parameter, dynamic updatedValue) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
      final docSnap = await docRef.get();
      final Map<String, dynamic> docData = docSnap.data() as Map<String,dynamic>;

      Map<String,dynamic> parameters = docData['parameters'];

      parameters.update(parameter, (value) => updatedValue);

      await docRef.update({"parameters" : parameters});   
    } catch (e) {
      debugPrint(e.toString());
    }
  }  





}
