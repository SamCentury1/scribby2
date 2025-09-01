import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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
    final String photoURL = userData["photoURL"];
    final String providerData = userData["providerData"];

    final Map<String,dynamic> userDocument = {
      "uid": uid,
      "username": displayName,
      "email": email,
      "photoUrl": photoURL,
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
}