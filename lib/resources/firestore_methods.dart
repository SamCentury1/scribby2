import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';

class FirestoreMethods {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<Map<String,dynamic>> getFirestoreDocument(String uid) async {
    late DocumentSnapshot<Map<String,dynamic>> docStream;
    docStream = await _firestore.collection("users").doc(uid).get();
    return docStream.data() as Map<String, dynamic>;
  }  

  // Future<List<Map<dynamic,dynamic>>> getLevelsFromFirestore() async {

  //   late QuerySnapshot gamesPlayedQuerySnapshot;
  //   gamesPlayedQuerySnapshot = await _firestore.collection("games")
  //   .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
  //   .get();


  //   List<Map<dynamic,dynamic>> gamesPlayed = [];
  //   List<String> completedLevelsIds = [];
  //   for (DocumentSnapshot gameDocumentSnapshot in gamesPlayedQuerySnapshot.docs) {
  //     late Map<dynamic,dynamic> gameData = gameDocumentSnapshot.data() as Map;
  //     gameData["gameId"] = gameDocumentSnapshot.id;
  //     gamesPlayed.add(gameData);
  //     completedLevelsIds.add(gameData["levelId"]);
  //   }


  //   late QuerySnapshot qSnap; 
  //   qSnap = await _firestore.collection("levels").orderBy("level").get();
  //   late List<Map<dynamic, dynamic>> levels = [];

  //   print(completedLevelsIds);

  //   for (DocumentSnapshot qDocSnap in qSnap.docs) {
  //     late Map<dynamic,dynamic> levelData = qDocSnap.data() as Map; // as Map<dynamic, dynamic>;
    
  //       // search if played game
  //       late Map<dynamic,dynamic> playedGameDocument = {};
  //       // print(qDocSnap.id);
  //       if (completedLevelsIds.contains(qDocSnap.id)) {
  //         playedGameDocument = gamesPlayed.firstWhere((value) => value["levelId"] == qDocSnap.id);
  //       }

  //       Map<dynamic,dynamic> wheelData = {};
  //       levelData["wheelData"].forEach((key,value) {
  //         int newKey = int.parse(key);
  //         wheelData[newKey] = value;
  //       });

  //       Map<dynamic,dynamic> clues = {};
  //       levelData["clues"].forEach((key, value) {
  //         int newKey = int.parse(key);
  //         clues[newKey] = value;
  //       });
  //       Map<dynamic,dynamic> data = {
  //         "level": levelData["level"],
  //         "key": levelData["key"],
  //         "wheelData": wheelData, 
  //         "clues":clues,
  //         "playedData":playedGameDocument,
  //       };

  //       levels.add(data);
  //   }
  //   return levels;
  // }


  // /// generates a map that can be used in various sign in methods
  // Map<String,dynamic> generateUserDocument(String uid, String? username, String? email, String? photoUrl, String provider, String os) {
  //   return {
  //       "uid": uid,
  //       "username": username,
  //       "email": email,
  //       "photoUrl": null,
  //       "parameters" : {
  //         "muted": false,
  //         "soundOn": true,
  //         "theme": 'dark',
  //       },
  //       "createdAt": DateTime.now().toIso8601String(),
  //       "providerData": provider,
  //       "os": os,
  //       "balance": 200      
  //   };
  // }

  Future<Map<String, dynamic>?> getUserData(
    String uid,
  ) async {
    late Map<String, dynamic>? res = {};
    try {
      final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
      final docSnap = await docRef.get();
      final Map<String, dynamic>? docData = docSnap.data();
      res = docData;
    } catch (e) {
      print("error in getUserData: ${e.toString()}");
    }
    return res;
  }


  Future<void> saveUserToDatabase(Map<String,dynamic> userData) async {
    late String os = "";
    if (Platform.isAndroid) {
      os = 'android';
    } else {
      os = 'iOS';
    }

    final String uid = userData["uid"];
    final String displayName = userData["displayName"];
    final String email = userData["email"];
    // final String photoURL = userData["photoURL"];
    final String providerData = userData["providerData"];

    final Map<String,dynamic> userDocument = {
      "uid": uid,
      "username": displayName,
      "email": email,
      // "photoUrl": photoURL,
      "parameters" : {
        "soundOn": true,
        "theme": 'default',
        'tutorialComplete':false,
      },
      "gameHistory": [],
      "language": "en",
      "createdAt": DateTime.now().toIso8601String(),
      "providerData": providerData,
      "os": os,
      "balance": 200,
      "coins": 0,
      "xp": 0,
      "rank":"1_1",    
    };
    await _firestore.collection("users").doc(uid).set(userDocument);
  }

  Future<void> updateParameters(SettingsController settings, String parameter, dynamic updatedValue) async {
    try {
      Map<String,dynamic> userData = settings.userData.value as Map<String,dynamic>;
      final docRef = FirebaseFirestore.instance.collection('users').doc(userData["uid"]);
      final docSnap = await docRef.get();
      final Map<String, dynamic> docData = docSnap.data() as Map<String, dynamic>;
      Map<String, dynamic> parameters = docData['parameters'];
      parameters.update(parameter, (value) => updatedValue);

      await docRef.update({"parameters": parameters});
    } catch (e) {
      debugPrint("caught an error running 'updateParameters()' ${e.toString()}");
    }
  }

  Future<void> updateUserDoc(SettingsController settings, String field, dynamic updatedValue) async {
    try {
      Map<String,dynamic> userData = settings.userData.value as Map<String,dynamic>;
      final docRef = FirebaseFirestore.instance.collection('users').doc(userData["uid"]);
      await docRef.update({field: updatedValue});
    } catch (e) {
      debugPrint("caught an error running 'updateParameters()' ${e.toString()}");
    }
  }

  Future<void> updateGameHistory(SettingsController settings, Map<String,dynamic> gameData) async {
    try {
      print("saving gmae data!");
      Map<String,dynamic> userData = settings.userData.value as Map<String,dynamic>;
      final docRef = FirebaseFirestore.instance.collection('users').doc(userData["uid"]);
      final docSnap = await docRef.get();
      final Map<String, dynamic> docData = docSnap.data() as Map<String, dynamic>;
      List<dynamic> gameHistory = docData['gameHistory'];
      print("game data to save: ${gameData} | $gameHistory");

      gameHistory.add(gameData);
      print("game history now ... $gameHistory");
      await docRef.update({"gameHistory": gameHistory});
    } catch (e) {
      debugPrint("caught an error running 'updateGameHistory()' ${e.toString()}");
    }
  }

  Future<void> updateDailyPuzzleGameComplete(SettingsController settings, Map<String,dynamic> gameData) async {
    try {
      print("printing puzzle id : ${gameData["gameParameters"]["puzzleId"]}");
      Map<String,dynamic> userData = settings.userData.value as Map<String,dynamic>;
      if (gameData["gameParameters"]["puzzleId"] != null) {
        String puzzleId = gameData["gameParameters"]["puzzleId"];
        List<String> puzzleIdComponents = puzzleId.split("-");
        final String year = puzzleIdComponents[0];
        final String month = puzzleIdComponents[1];
        final String day = puzzleIdComponents[2];
        final String difficulty = puzzleIdComponents[3];
        String dateString = '$year-$month-$day';

        final docRef = FirebaseFirestore.instance.collection('puzzles').doc(dateString);
        final docSnap = await docRef.get();
        final dynamic docData = docSnap.data() as dynamic;

        Map<String,dynamic> completedPuzzle = docData[difficulty];
        List<dynamic> scoreData = [];
        if (completedPuzzle["data"] != null) {
          scoreData = completedPuzzle["data"];
        }
        int scoreValue = gameData["score"];
        if (completedPuzzle["gameType"]=='sprint') {
          scoreValue = gameData["durationSeconds"];
        }

        Map<String,dynamic> userScoreObject = scoreData.firstWhere((e)=>e["uid"]==userData["uid"],orElse:() => <String,dynamic>{});
        if (userScoreObject.isNotEmpty) {
          if (completedPuzzle["gameType"]=='sprint') {
            if (userScoreObject["score"]>scoreValue) {
              userScoreObject.update("score", (v) => scoreValue);
            }
          } else if (completedPuzzle["gameType"]=='classic') {
            if (userScoreObject["score"]<scoreValue) {
              userScoreObject.update("score", (v) => scoreValue);
            }            
          }
        } else {
          scoreData.add({"uid":userData["uid"],"username":userData["username"], "score": scoreValue});
          completedPuzzle["data"]=scoreData;
        }
        
        // docData.update(difficulty, (v) => completedPuzzle);
        Map<String,dynamic> savedPuzzleObject = settings.dailyPuzzleData.value as Map<String,dynamic>;
        savedPuzzleObject.update(difficulty, (v) => completedPuzzle);
        settings.setDailyPuzzleData(savedPuzzleObject);
        // settings.setDailyPuzzleData(docData);

        await docRef.update({difficulty: completedPuzzle});

        print("IN THE updateDailyPuzzleGameComplete FUNC:");
        print("doc data: $docData");     
        // await
      }
    } catch (e,s) {
      debugPrint("Error: $e | Stack: $s");
    }
  }

  

  

  

  Future<void> downloadWordList(String? language) async {
    late String? actualLanguage = 'english';
    if  (language != '' || language != null) {
      actualLanguage = language;
    }
    final FirebaseStorage storage = FirebaseStorage.instance;
    final String fileName = 'all_valid_${actualLanguage}_words.txt';
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final File downloadToFile = File('${appDocDir.path}/$fileName');
    // late List<String> res = [];
    late String contents = "";
    final Box wordBox = Hive.box('wordBox');

    try {
      await storage.ref(fileName).writeToFile(downloadToFile);
      // Read the file and convert it to a list
      contents = await downloadToFile.readAsString();
      // List<String> words = contents.split(',').map((word) => word.trim()).toList(); // Split by commas and trim whitespace

      // res = words;
      // Store words to local storage (e.g., shared_preferences or hive)
      // ...

      List<String> words = contents
          .split(',')
          .map((word) => word.trim())
          .where((word) => word.isNotEmpty)
          .toList();

      // Save to Hive using the language as key
      await wordBox.put('words_$actualLanguage', words);

    } catch (e) {
      // debugPrint("there was an error running downloadWordList() : ${e.toString()} ");
      // Handle errors
    }
    // return contents;
  }


  // Future<List<dynamic>> getDailyPuzzles() async {
  //   late List<dynamic> res = [];
  //   try {
  //     final now = DateTime.now().toUtc();
  //     final year = now.year.toString().padLeft(4, '0');
  //     final month = now.month.toString().padLeft(2, '0');
  //     final day = now.day.toString().padLeft(2, '0');
  //     String dateString = '$year-$month-${day}T00:00:00.000Z';      
  //     QuerySnapshot docRefs = await FirebaseFirestore.instance.collection('puzzles').where("date", isEqualTo: dateString).get();
  //     List<dynamic> puzzles = [];

  //     for (DocumentSnapshot qDocSnap in docRefs.docs) {
  //       late Map<dynamic,dynamic> levelData = qDocSnap.data() as Map;
  //       puzzles.add(levelData);
  //       print("docRefs: $levelData");
  //     }
  //     res = puzzles;
  //   } catch (e) {
  //     print("error in getDailyPuzzles: ${e.toString()}");
  //   }

  //   print("res: $res");
  //   return res;
  // }

  Future<Map<String,dynamic>> getDailyPuzzleObject(String? puzzleId) async {

    Map<String,dynamic> completedPuzzle = {};
    try {
      if (puzzleId != null) {
        List<String> puzzleIdComponents = puzzleId.split("-");
        final String year = puzzleIdComponents[0];
        final String month = puzzleIdComponents[1];
        final String day = puzzleIdComponents[2];
        final String difficulty = puzzleIdComponents[3];
        String dateString = '$year-$month-$day';

        final docRef = FirebaseFirestore.instance.collection('puzzles').doc(dateString);
        final docSnap = await docRef.get();
        final dynamic docData = docSnap.data() as dynamic;

        completedPuzzle = docData[difficulty];
      }
    } catch (e, t) {
      print("error: $e | traceback: $t");
    }
    return completedPuzzle;
  }

  Future<void> saveDailyPuzzlesToLocalStorage(SettingsController settings) async {
    try {
      final now = DateTime.now().toUtc();
      final year = now.year.toString().padLeft(4, '0');
      final month = now.month.toString().padLeft(2, '0');
      final day = now.day.toString().padLeft(2, '0');
      String dateString = '$year-$month-${day}T00:00:00.000Z';
      String date = '$year-$month-${day}';
      // String dateString = '2025-03-11T00:00:00.000Z';   

      bool syncPuzzles = false;
      print("""

in the saveDailyPuzzlesToLocalStorage???
  ${settings.dailyPuzzleData.value}
---------------------------------------

""");
      // if ((settings.dailyPuzzleData.value as dynamic).length > 0) {
        dynamic puzzleData = settings.dailyPuzzleData.value as dynamic;
        print("puzzleData in saveDailyPuzzlesToLocalStorage | $puzzleData");

        if (puzzleData.isEmpty) {
          syncPuzzles = true;
        } else {
          if (puzzleData["date"]!=date) {
            print("${puzzleData["date"]} | $date");
            print("there's data in settings but date don't match up");
            syncPuzzles = true;
          }
        }
        print("should sync puzz? $syncPuzzles");

        if (syncPuzzles) {

          final docRef = FirebaseFirestore.instance.collection('puzzles').doc(date);
          final docSnap = await docRef.get();
          final dynamic docData = docSnap.data() as dynamic;
          print("doc data: $docData");     
          settings.setDailyPuzzleData(docData);        
        }
      // }

      

    } catch (e,t) {
      print("error in saveDailyPuzzlesToLocalStorage: ${e.toString() } | traceback: $t");
    }

    // print("res: $res");
    // return res;
  }    



}