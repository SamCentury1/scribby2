import 'dart:convert';
// import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:scribby_flutter_v2/models/tile_model.dart';


class StorageMethods {

  Future<List<String>> downloadWordList(String? language) async {
    late String? actualLanguage = 'english';
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
      // debugPrint("there was an error running downloadWordList() : ${e.toString()} ");
      // Handle errors
    }
    return res;
  }


Future<List<Map<String,dynamic>>> downloadInitialBoardState() async {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final String fileName = 'utilities/initialBoardState.json';
  final Directory appDocDir = await getApplicationDocumentsDirectory();
  final String filePath = '${appDocDir.path}/$fileName';
  final File downloadToFile = File(filePath);
  late List<Map<String,dynamic>> res = [];

  try {
    // Ensure the directory exists
    await downloadToFile.parent.create(recursive: true);

    print('Downloading file to: $filePath');

    // Download the file
    await storage.ref(fileName).writeToFile(downloadToFile);

    print('File downloaded successfully');

    // Read the file and convert it to a list
    final String jsonString = await downloadToFile.readAsString();
    final parsed = jsonDecode(jsonString).cast<Map<String, dynamic>>();
    res = parsed;
  } catch (e) {
    print('Error: $e');
  }

  return res;
}

Future<List<Tile>> downloadInitialBoardState2() async {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final String fileName = 'utilities/initialBoardState.json';
  final Directory appDocDir = await getApplicationDocumentsDirectory();
  final String filePath = '${appDocDir.path}/$fileName';
  final File downloadToFile = File(filePath);
  late List<Tile> res = [];

  try {
    // Ensure the directory exists
    await downloadToFile.parent.create(recursive: true);
    // Download the file
    await storage.ref(fileName).writeToFile(downloadToFile);

    // Read the file and convert it to a list
    final String jsonString = await downloadToFile.readAsString();

    final parsed = jsonDecode(jsonString).cast<Map<String, dynamic>>();
    res = parsed.map<Tile>((json) => Tile.fromJson(json)).toList();  
    // return parsed.map<Tile>((json) => Tile.fromJson(json)).toList();    
    // final List<dynamic> jsonMap = jsonDecode(jsonString);
    // res = jsonMap;
  } catch (e) {
    print('Error: $e');
  }

  return res;
}



Future<Map<String,dynamic>> downloadStates2() async {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final String fileName = 'utilities/states.json';
  final Directory appDocDir = await getApplicationDocumentsDirectory();
  final String filePath = '${appDocDir.path}/$fileName';
  final File downloadToFile = File(filePath);
  late Map<String,dynamic> res = {};

  try {
    // Ensure the directory exists
    await downloadToFile.parent.create(recursive: true);

    // Download the file
    await storage.ref(fileName).writeToFile(downloadToFile);

    // Read the file and convert it to a list
    final String jsonString = await downloadToFile.readAsString();
    final parsed = jsonDecode(jsonString);
    res = parsed;
  } catch (e) {
    print('Error: $e');
  }

  return res;
}


// Future<dynamic> downloadStates() async {
//   final FirebaseStorage storage = FirebaseStorage.instance;
//   final String fileName = 'utilities/states.json';
//   final Directory appDocDir = await getApplicationDocumentsDirectory();
//   final String filePath = '${appDocDir.path}/$fileName';
//   final File downloadToFile = File(filePath);
//   late dynamic res = [];

//   try {
//     // Ensure the directory exists
//     await downloadToFile.parent.create(recursive: true);

//     print('Downloading file to: $filePath');

//     // Download the file
//     await storage.ref(fileName).writeToFile(downloadToFile);

//     print('File downloaded successfully');

//     // Read the file and convert it to a list
//     final String jsonString = await downloadToFile.readAsString();
//     final dynamic jsonMap = jsonDecode(jsonString);
//     res = jsonMap;
//   } catch (e) {
//     print('Error: $e');
//   }

//   return res;
// }


// Future<Map<String,dynamic>> getWordDefinition(String language, String word) async {
//   final FirebaseStorage storage = FirebaseStorage.instance;
//   final String fileName = '$word.json';
//   final Directory appDocDir = await getApplicationDocumentsDirectory();
//   final String filePath = '${appDocDir.path}/definitions/$language/$fileName';
//   final File downloadToFile = File(filePath);
//   late Map<String, dynamic> res = {};

//   try {
//     // Ensure the directory exists before attempting to download the file
//     // final directory = await Directory('${appDocDir.path}/definitions/$language').create(recursive: true);

//     // Correct the reference to match the file's location in Firebase Storage
//     final String storagePath = 'definitions/$language/$fileName';
//     await storage.ref(storagePath).writeToFile(downloadToFile);

//     final String jsonString = await downloadToFile.readAsString();
//     final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
//     res = jsonMap;
//   } catch (e) {
//     // If an error occurs, print it to the console and return an empty map
//     return {};
//   }
//   return res;
// }






  Future<List<List<dynamic>>> downloadCombinations() async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    final String fileName = 'utilities/combinations.json';
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String filePath = '${appDocDir.path}/$fileName';
    final File downloadToFile = File(filePath);
    late List<List<dynamic>> res = [];
    try {
      await downloadToFile.parent.create(recursive: true);
      await storage.ref(fileName).writeToFile(downloadToFile);
      final String jsonString = await downloadToFile.readAsString();
      final parsed = jsonDecode(jsonString).cast<List<dynamic>>();
      res = parsed;
    } catch (e) {
      print('Error: $e');
    }
    return res;
  }


  Future<Map<dynamic,dynamic>> downloadDemoBoardStates() async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    late Map<dynamic,dynamic> res = {
      "demoBoardState1":[],
      "demoBoardState2":[],
      "demoBoardState3":[],
      "demoBoardState4":[],
      "demoBoardState5":[],
      "demoBoardState6":[],
    };
    try {
      for (int i=1; i<7;i++) {
        final String name = "demoBoardState${i}";
        final String fileName = "utilities/$name.json";
        final String filePath = '${appDocDir.path}/$fileName';       
        final File downloadToFile = File(filePath);
        await downloadToFile.parent.create(recursive: true);
        await storage.ref(fileName).writeToFile(downloadToFile);
        final String jsonString = await downloadToFile.readAsString();
        final parsed = jsonDecode(jsonString).cast<Map<String,dynamic>>();
        res[name] = parsed;
      }
    } catch (e) {
      print('Error: $e');
    }
    return res;
  }



  Future<Map<dynamic,dynamic>> downloadDemoStateDynamicLetters() async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    final String fileName = 'utilities/demoStateDynamicLetters.json';
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String filePath = '${appDocDir.path}/$fileName';
    final File downloadToFile = File(filePath);
    late Map<dynamic,dynamic> res = {};
    try {
      await downloadToFile.parent.create(recursive: true);
      await storage.ref(fileName).writeToFile(downloadToFile);
      final String jsonString = await downloadToFile.readAsString();
      final parsed = jsonDecode(jsonString);
      res = parsed;
    } catch (e) {
      print('Error: $e');
    }
    return res;
  }  


  Future<List<Map<String,dynamic>>> downloadTranslations() async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    final String fileName = 'utilities/translations.json';
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String filePath = '${appDocDir.path}/$fileName';
    final File downloadToFile = File(filePath);
    late List<Map<String,dynamic>> res = [];
    try {
      await downloadToFile.parent.create(recursive: true);
      await storage.ref(fileName).writeToFile(downloadToFile);
      final String jsonString = await downloadToFile.readAsString();
      final parsed = jsonDecode(jsonString).cast<Map<String,dynamic>>();
      res = parsed;
    } catch (e) {
      print('Error: $e');
    }
    return res;
  }    
}
