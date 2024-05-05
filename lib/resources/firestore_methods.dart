import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      // debugPrint("caught an error running 'getUserData()' ${e.toString()}");
    }
    return res;
  }


  Future<void> saveHighScore(String uid, Map<String, dynamic> gameData) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
      final docSnap = await docRef.get();
      final Map<String, dynamic> docData =
          docSnap.data() as Map<String, dynamic>;
      String language = docData['parameters']['currentLanguage'];
      late Map<String, dynamic> userHighScores = docData['highScores'];
      if (userHighScores[language] != null) {
        int currentHighScore = userHighScores[language];
        if (gameData['points'] > currentHighScore) {
          userHighScores.update(language, (value) => gameData['points']);
          await _firestore.collection("users").doc(uid).update({
            "highScores": userHighScores,
          });
        }
      } else {
        // userHighScores.update(language, (value) => gameData['points']);
        userHighScores[language] = gameData['points'];
        await _firestore.collection("users").doc(uid).update({
          "highScores": userHighScores,
        });
      }
    } catch (e) {
      // debugPrint("caught an error running 'saveHighScore()' ${e.toString()}");
    }
  }


  Future<List<Map<String, dynamic>>?> getDataForLeaderboards(String currentLanguage) async {
    late List<Map<String, dynamic>> res = [];
    try {
      QuerySnapshot qSnap = await _firestore
          .collection("users")
          .where("highScores.$currentLanguage", isGreaterThan: 0)
          .orderBy("highScores.$currentLanguage", descending: true)
          .limit(50)
          .get();

      late List<Map<String, dynamic>> userList = [];
      for (DocumentSnapshot qDocSnap in qSnap.docs) {
        late Map<String, dynamic> userData =
            qDocSnap.data() as Map<String, dynamic>;
        userList.add({
          "user": userData['uid'],
          "username": userData['username'],
          "points": userData['highScores'][currentLanguage],
        });
      }
      res = userList;
    } catch (e) {
      // debugPrint("caught an error running 'getDataForLeaderboards()' ${e.toString()}");
    }
    return res;
  }

  Future<List<dynamic>> getAlphabet(String uid) async {
    late List<dynamic> res = [];

    try {
      final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
      final docSnap = await docRef.get();
      final Map<String, dynamic> docData =
          docSnap.data() as Map<String, dynamic>;

      String language = docData['parameters']['currentLanguage'];

      QuerySnapshot qSnap = await _firestore
          .collection("alphabets")
          .where("language", isEqualTo: language)
          .get();

      List<Map<String, dynamic>> documents = [];

      for (DocumentSnapshot qDocSnap in qSnap.docs) {
        late Map<String, dynamic> alphabetData =
            qDocSnap.data() as Map<String, dynamic>;
        documents.add(alphabetData);
      }

      Map<String, dynamic> alphabetDoc =
          documents.firstWhere((element) => element['language'] == language);

      res = alphabetDoc['alphabet'];
    } catch (e) {
      // debugPrint("caught an error running 'getAlphabet()' ${e.toString()}");
    }

    return res;
  }

  Future<void> saveAlphabetToLocalStorage(String uid, SettingsController settings) async {

    try {
      final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
      final docSnap = await docRef.get();
      final Map<String, dynamic> docData = docSnap.data() as Map<String, dynamic>;

      late String language = 'english';
      
      if (docData['parameters']['currentLanguage'] != "") {
        language = docData['parameters']['currentLanguage'];
      } 

      QuerySnapshot qSnap = await _firestore
          .collection("alphabets")
          .where("language", isEqualTo: language)
          .get();

      List<Map<String, dynamic>> documents = [];

      for (DocumentSnapshot qDocSnap in qSnap.docs) {
        late Map<String, dynamic> alphabetData =
            qDocSnap.data() as Map<String, dynamic>;
        documents.add(alphabetData);
      }

      Map<String, dynamic> alphabetDoc = documents.firstWhere((element) => element['language'] == language);

      settings.setAlphabet(alphabetDoc);
    } catch (e) {
      // debugPrint("caught an error running 'saveAlphabetToLocalStorage()' ${e.toString()}");
    }
  }

  Future<void> selectLanguage(String uid, String currentLanguage, List<String> languages) async {
    try {
      final docRef = _firestore.collection('users').doc(uid);


      await docRef.update({"parameters.currentLanguage": currentLanguage});
      await docRef.update({"parameters.languages": languages});
    } catch (e) {
      // debugPrint("caught an error running 'selectLanguage()' ${e.toString()}");
    }
  }



  // EXECUTES IN THE SETTINGS PAGE - IN THE DROPOWN MENU FOR CHANGING THE CURRENT LANGUAGE
  Future<void> updateParameters( String uid, String parameter, dynamic updatedValue) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
      final docSnap = await docRef.get();
      final Map<String, dynamic> docData =
          docSnap.data() as Map<String, dynamic>;

      Map<String, dynamic> parameters = docData['parameters'];

      parameters.update(parameter, (value) => updatedValue);

      await docRef.update({"parameters": parameters});
    } catch (e) {
      // debugPrint("caught an error running 'updateParameters()' ${e.toString()}");
    }
  }

  Future<void> updateSettingsState(SettingsState settings, String uid) async {
    try {
      Map<String, dynamic> userData = await getUserData(uid) as Map<String, dynamic>;
      settings.updateUserData(userData);
    } catch (e) {
      // debugPrint("caught an error running 'updateSettingsState()' ${e.toString()}");
    }
  }


}
