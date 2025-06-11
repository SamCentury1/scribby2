import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      },
      "language": "english",
      "createdAt": DateTime.now().toIso8601String(),
      "providerData": providerData,
      "os": os,
      "balance": 200,
      "rank":"1_1",     
    };
    await _firestore.collection("users").doc(uid).set(userDocument);
  }

}