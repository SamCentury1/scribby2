import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';


class StorageMethods {

  Future<List<String>> downloadWordList(String language) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    final String fileName = 'all_valid_${language}_words.txt';
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final File downloadToFile = File('${appDocDir.path}/$fileName');
    print(downloadToFile);
    late List<String> res = [];


    try {
      await storage.ref(fileName).writeToFile(downloadToFile);
      // Read the file and convert it to a list
      String contents = await downloadToFile.readAsString();
      List<String> words = contents.split(',').map((word) => word.trim()).toList(); // Split by commas and trim whitespace

      res = words;
      // Store words to local storage (e.g., shared_preferences or hive)
      // ...
    } catch (e) {
      // Handle errors
    }
    return res;
  }

    // Future<void> downloadWordList() async {
    //   final FirebaseStorage storage = FirebaseStorage.instance;
    //   final String fileName = 'all_valid_english_words.txt'; // Name of the file in Firebase Storage
    //   final Directory appDocDir = await getApplicationDocumentsDirectory();
    //   final File downloadToFile = File('${appDocDir.path}/$fileName');

    //   try {
    //     await storage.ref(fileName).writeToFile(downloadToFile); // Download the file
    //     print()
    //     // Remaining code...
    //   } catch (e) {
    //     // Handle errors
    //     print(e);  // Print the error for more detailed information
    //   }
    // }    

}
