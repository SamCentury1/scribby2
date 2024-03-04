import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';


class StorageMethods {

  Future<List<String>> downloadWordList(String language) async {

    late String actualLanguage = 'english';
    if  (language != '' || language != null) {
      actualLanguage = language;
    }
    
    final FirebaseStorage storage = FirebaseStorage.instance;
    final String fileName = 'all_valid_${actualLanguage}_words.txt';
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final File downloadToFile = File('${appDocDir.path}/$fileName');
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
      debugPrint("there was an error running downloadWordList() : ${e.toString()} ");
      // Handle errors
    }
    return res;
  }



Future<Map<String,dynamic>> getWordDefinition(String language, String word) async {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final String fileName = '${word}.json';
  final Directory appDocDir = await getApplicationDocumentsDirectory();
  final String filePath = '${appDocDir.path}/definitions/$language/$fileName';
  final File downloadToFile = File(filePath);
  late Map<String, dynamic> res = {};

  try {
    // Ensure the directory exists before attempting to download the file
    final directory = await Directory('${appDocDir.path}/definitions/$language').create(recursive: true);

    // Correct the reference to match the file's location in Firebase Storage
    final String storagePath = 'definitions/$language/$fileName';
    await storage.ref(storagePath).writeToFile(downloadToFile);

    final String jsonString = await downloadToFile.readAsString();
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    res = jsonMap;
  } catch (e) {
    // If an error occurs, print it to the console and return an empty map
    print("Error reading JSON file: $e");
    return {};
  }
  return res;
}


}
