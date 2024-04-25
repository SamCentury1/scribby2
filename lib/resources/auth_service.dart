import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  /// needs to be called as soon as the app loads
  Future<User?> getOrCreateUser() async {
    if (currentUser == null) {
      // try {
      UserCredential cred = await _firebaseAuth.signInAnonymously();
      await _firestore.collection("users").doc(cred.user!.uid).set({
        "uid": cred.user!.uid,
        "username": "",
        "parameters": {
          "currentLanguage": "",
          "darkMode": false,
          "languages": [],
          "muted": false,
          "soundOn": true,
          "hasSeenTutorial": false,
        },
        "createdAt": DateTime.now(),
        "highScores": {}
      });
    }

    return currentUser;
  }

  Future<void> updateUsername(String userId, String newName) async {
    final docRef = _firestore.collection("users").doc(userId);
    docRef.update({"username": newName});
  }
}
