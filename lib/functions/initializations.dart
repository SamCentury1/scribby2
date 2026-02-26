import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:scribby_flutter_v2/audio/audio_service.dart';
import 'package:scribby_flutter_v2/functions/game_logic.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/functions/styling_utils.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
import 'package:scribby_flutter_v2/resources/storage_methods.dart';
import 'package:scribby_flutter_v2/screens/game_screen/game_screen.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';

class Initializations {



  Future<void> initializeDeviceSizePropertiesAndTheme(SettingsController settings, ColorPalette palette,) async {
  
  }


  // Here - User? user is the snapshot data from the future
  Future<void> initializeAppData1(SettingsController settings) async {

    try {

      await StorageMethods().saveUpdatesToLocalStorage(settings);



      
      // get info data to local storage
      if (settings.gameInfoData.value.isEmpty) {
        await StorageMethods().saveGameInfoDataFromJsonFileToLocalStorage(settings);
      }

      // DateTime? lastGamePlayedDate = Helpers().getLatestGamePlayed(settings);
      // print("lastGamePlayedDate: ${lastGamePlayedDate}");        


      // get achievement data from db to local storage
      await StorageMethods().saveAchievementDataToLocalStorage(settings);

      // get the ranks from db to local storage
      await StorageMethods().saveRankDataToLocalStorage(settings);

      // save alphabet 
      await StorageMethods().saveAlphabetToLocalStorage(settings);



      // final audioService = AudioService(settings: settings);
      // await audioService.init();
      // await audioService.preload("assets/audio/sfx/glass_break_1.wav");
      // await audioService.preload("assets/audio/sfx/explode.wav");
      
      // save list of words to the phone storage
      final Box wordBox = Hive.box('wordBox');
      if (wordBox.isEmpty) {
        await FirestoreMethods().downloadWordList("english");
      }   
    } catch (e,t) {
      debugPrint("there was an error initializing app data: $e | $t");
    }
 
  }

  // Here - User? user is the snapshot data from the future
  Future<void> initializeAppData2(SettingsController settings, ColorPalette palette, User? user) async {
    print("executing initializeAppData2");
    try {
      
      Map<String,dynamic> firestoreUserData = await FirestoreMethods().getFirestoreDocument(user!.uid);

      if (firestoreUserData.isNotEmpty) {

        // save the userdata to local storage
        await StorageMethods().saveUserDocumentToLocalStorage(settings,firestoreUserData);



        // get daily puzzle from db - save it to localstorage
        await FirestoreMethods().saveDailyPuzzlesToLocalStorage(settings);
                
      } else {
        print("the firestore user data is empty damn it!");
      }







    } catch (e,t) {
      debugPrint("there was an error initializing app data 2: $e | $t");
    }
 
  }  


  // Future<void> initializeAppData(SettingsController settings, ColorPalette palette, User? user) async {


  //   // // WidgetsBinding.instance.addPostFrameCallback((_) {
  //   // StorageMethods().saveDeviceSizeInfoToSettings(settings);
  //   // palette.getThemeColors('default');  

  //   // print("set this shit up???");    
  //   // // });      

  //   // await StorageMethods().saveDeviceSizeInfoToSettings(settings);
  //   // if local storage is empty - get the level data as json payload and set it
  //   // levels to play
  //   // text explaining the types of games
  //   if (settings.gameInfoData.value.isEmpty) {
  //     await StorageMethods().saveGameInfoDataFromJsonFileToLocalStorage(settings);
  //   }

  //   if (settings.achievementData.value.isEmpty) {
  //     await StorageMethods().saveAchievementDataFromJsonFileToLocalStorage(settings);
  //   }

  //   if (settings.rankData.value.isEmpty) {
  //     await StorageMethods().saveRankDataFromJsonFileToLocalStorage(settings);
  //   }

  //   if (settings.alphabet.value.isEmpty) {
  //     // print("just added the english alphabet");
  //     await StorageMethods().saveAlphabetToSettings(settings,"english");
  //   }


    
  //   // userGameHistory.removeLast();
  //   // settings.setUserGameHistory(userGameHistory);
    


  //   // if (settings.dailyPuzzleData.value.isEmpty) {
  //   await FirestoreMethods().saveDailyPuzzlesToLocalStorage(settings);
  //   // }


  //   final Box wordBox = Hive.box('wordBox');
  //   if (wordBox.isEmpty) {
  //     await FirestoreMethods().downloadWordList("english");
  //   }


  //   settings.setUserData(userData);

  //   print("userData => ${userData["gameHistory"].length}");
    
  //   // if (userData.isNotEmpty) {
  //   //   // fix bug of old user doc in firebase which saved the theme as a bool in parameters
  //   //   // palette.getThemeColors(userData["parameters"]["theme"]);
  //   //   print("user data is not empty!");
  //   //   palette.getThemeColors(settings.theme.value);
  //   // }

    

  //   // await StorageMethods().saveDummyUserToSettings(settings,palette);
  // }


  Future<void> initializeDeviceData(SettingsController settings) async {
    try {
      
      await StorageMethods().saveDeviceSizeInfoToSettings(settings);
      await StorageMethods().saveLanguageLocalesToSettings(settings);
      await StorageMethods().initializeThemeColor(settings);



    } catch (e,t) {
      debugPrint("error in the initializeDeviceData function : $e | traceback: $t");
    }
  }

  void printAllSettingsData(SettingsController settings) {

    debugPrint("""
========================================================================
    deviceSizeInfo:     ${settings.deviceSizeInfo.value}
    ----------------------------------------------------------------
    language:           ${settings.language.value}
    ----------------------------------------------------------------
    theme:              ${settings.theme.value}
    ----------------------------------------------------------------
    user:               ${settings.user.value}
    ----------------------------------------------------------------
    userData:           ${settings.userData.value}
    ----------------------------------------------------------------
    soundsOn:           ${settings.soundsOn.value}
    ----------------------------------------------------------------
    coins:              ${settings.coins.value}
    ----------------------------------------------------------------
    xp:                 ${settings.xp.value}
    ----------------------------------------------------------------
    userGameHistory:    ${settings.userGameHistory.value}
    ----------------------------------------------------------------
    achievements:       ${settings.achievements.value}
    ----------------------------------------------------------------
    levelData:          ${settings.levelData.value}
    ----------------------------------------------------------------
    gameInfoData:       ${settings.gameInfoData.value}
    ----------------------------------------------------------------
    alphabet:           ${settings.alphabet.value}
    ----------------------------------------------------------------
    dictionary:         ${settings.dictionary.value}
    ----------------------------------------------------------------
    rankData:           ${settings.rankData.value}
    ----------------------------------------------------------------
    achievementData:    ${settings.achievementData.value}
    ----------------------------------------------------------------
    dailyPuzzleData:    ${settings.dailyPuzzleData.value}
    ----------------------------------------------------------------

=====================================================================
""");
  }


  void resizeScreen(GamePlayState gamePlayState, MediaQueryData mediaQuery) {
    Map<String,dynamic> elementSizes = gamePlayState.elementSizes;

    if (mediaQuery.size != elementSizes["screenSize"]) {
      // resize the screen
      // initializeElementSizes(gamePlayState,mediaQuery);
      // initializeElementPositions(gamePlayState,mediaQuery);
      
    } else {

    }

  }

  void initializeTileData(GamePlayState gamePlayState, int numRows, int numCols) {

    // int numRows = gamePlayState.gameParameters["rows"];
    // int numCols = gamePlayState.gameParameters["columns"];
    Random random = Random();
    // List<String> alphabet = [
    //   "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", 
    //   "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", 
    // ];
    List<Map<String,dynamic>> tileObjects = [];
    for (int r=0; r<numRows; r++) {
      for (int c=0; c<numCols; c++) {
        int tileId = tileObjects.length;
        // int randomIndex = random.nextInt(4);
        Map<String,dynamic> decorationData = StylingUtils().generateNewTileStyle(gamePlayState,random);
        decorationData["gradientOffset"] = random.nextInt(4);
        late Map<String,dynamic> tileObject = {
          "type": "board",
          "key": tileId,
          "row": r+1,
          "column" : c+1,
          "body": "",//alphabet[randomIndex],
          "active": true,
          "dragging":false,
          "menuOpen":false,
          "menuData":null,
          "frozen": false,
          "swapping": false,
          "decorationData": decorationData
        };
        tileObjects.add(tileObject);
      }
    }
    gamePlayState.setTileData(tileObjects);


    List<Map<String,dynamic>> reserveObjects = [];
    for (int i=0; i<5; i++) {
      int tileId = (reserveObjects.length+1)*1000;
      // int randomIndex = random.nextInt(alphabet.length);
      Map<String,dynamic> decorationData = StylingUtils().generateNewTileStyle(gamePlayState,random);
      decorationData["gradientOffset"] = random.nextInt(4);      
      late Map<String,dynamic> tileObject = {
        "key": tileId,
        "type": "reserve",
        "body": "", // alphabet[randomIndex],
        "active": true,
        "dragging": false,
        "decorationData": decorationData,
      };
      reserveObjects.add(tileObject);
    }
    gamePlayState.setReserveTileData(reserveObjects);    
  }

  void initializeDictionary(SettingsController settings, GamePlayState gamePlayState) {
    // String dictionaryRaw = settings.dictionary.value;
    // List<String> dictionary = dictionaryRaw.split(',').map((word) => word.trim()).toList();
    // gamePlayState.setDictionary(dictionary);
  }


  Size getPlayAreaSize2(GamePlayState gamePlayState, MediaQueryData mediaQuery) {
    // final double maxScreenWidth = 550.0;
    final double maxScreenHeight = 1000.0;

    final double effectiveWidth = mediaQuery.size.width;
    final double effectiveHeight = mediaQuery.size.height-mediaQuery.padding.top-mediaQuery.padding.bottom;
    // final double effectiveHeight = mediaQuery.size.height;

    late double resWidth = effectiveWidth;
    late double resHeight = effectiveHeight;

    if (effectiveHeight > maxScreenHeight) {
      resHeight = maxScreenHeight;
    }
    
    final double aspectRatioWidth = (resHeight*0.98) * (9/16);
    if (aspectRatioWidth > effectiveWidth) {
      resWidth = effectiveWidth;
    } else {
      resWidth = aspectRatioWidth;
    }

    late double playAreaWidth = resWidth*0.96;
    late double playAreaHeight = resHeight*0.98;    

    return Size(playAreaWidth,playAreaHeight);
  }

  // takes in the size of the phone and determines how big each elenent should be
  // saves that to a variable in the GamePlayState class
  void initializeElementSizes(GamePlayState gamePlayState, MediaQueryData mediaQuery) {

    final double safePadding = mediaQuery.padding.top+mediaQuery.padding.bottom;

    // effective height is less
    final double effectiveHeight = mediaQuery.size.height-safePadding;
    final double effectiveWidth = mediaQuery.size.width;

    Size effectiveSize = Size(effectiveWidth,effectiveHeight);

    Size playAreaSize = getPlayAreaSize2(gamePlayState,mediaQuery);

    int numRows = gamePlayState.gameParameters["rows"]; // Helpers().getNumberAxis(gamePlayState,'row');
    int numCols = gamePlayState.gameParameters["columns"]; // Helpers().getNumberAxis(gamePlayState,'column');
    double tileWidth = StylingUtils().getTileSize(playAreaSize, numRows, numCols);

    final double boardHeight = tileWidth*numRows;
    final double randomLettersHeight = tileWidth*2.5;
    final double reserveLettersHeight = tileWidth*1.5;

    final double scoreboardHeightShare = 0.08;
    final double bonusAreaHeightShare = 0.05;
    final double randomLettersHeightShare = randomLettersHeight/playAreaSize.height;
    final double boardHeightShare = boardHeight/playAreaSize.height;
    final double reserveLetterHeightShare = reserveLettersHeight/playAreaSize.height;
    final double perksAreaHeightShare = 0.05;

    final double totalGap = 1.0-(scoreboardHeightShare+bonusAreaHeightShare+perksAreaHeightShare+randomLettersHeightShare+boardHeightShare+reserveLetterHeightShare);

    final Size scoreboardAreaSize = Size(effectiveSize.width,scoreboardHeightShare*playAreaSize.height);
    final Size bonusAreaSize = Size(playAreaSize.width,bonusAreaHeightShare*playAreaSize.height);
    final Size randomLettersAreaSize = Size(playAreaSize.width,randomLettersHeightShare*playAreaSize.height);
    final Size boardAreaSize = Size(numCols*tileWidth,boardHeightShare*playAreaSize.height);
    final Size reserveLettersAreaSize = Size(playAreaSize.width,reserveLetterHeightShare*playAreaSize.height);
    final Size perksAreaSize = Size(playAreaSize.width,perksAreaHeightShare*playAreaSize.height);
    final Size gapSize = Size(playAreaSize.width,(totalGap/3)*playAreaSize.height);

    Map<String,dynamic> sizeData = {
      "tileSize":Size(tileWidth,tileWidth),
      "appBarSize": AppBar().preferredSize,
      "screenSize": mediaQuery.size,
      "effectiveSize": effectiveSize,
      "playAreaSize": playAreaSize,
      "scoreboardAreaSize":scoreboardAreaSize,
      "bonusAreaSize":bonusAreaSize,
      "randomLettersAreaSize":randomLettersAreaSize,
      "boardAreaSize":boardAreaSize,
      "reserveLettersAreaSize":reserveLettersAreaSize,
      "perksAreaSize":perksAreaSize,
      "gapSize":gapSize,
    };

    gamePlayState.setElementSizes(sizeData);    
  }

  void initializeElementPositions(GamePlayState gamePlayState, MediaQueryData mediaQuery) {
    Map<String,dynamic> sizeData = gamePlayState.elementSizes;

    Size screenSize = sizeData["screenSize"];
    Size playAreaSize = sizeData["playAreaSize"];
    Size appBarSize = sizeData["appBarSize"];
    Size scoreboardSize = sizeData["scoreboardAreaSize"];
    Size gapSize = sizeData["gapSize"];
    Size bonusAreaSize = sizeData["bonusAreaSize"];
    Size randomLettersAreaSize = sizeData["randomLettersAreaSize"];
    Size boardAreaSize = sizeData["boardAreaSize"];
    Size reserveLettersAreaSize = sizeData["reserveLettersAreaSize"];
    Size perksAreaSize = sizeData["perksAreaSize"];

    print("size in initialization : ${mediaQuery.size}");


    // double safeAreaGap = mediaQuery.padding.top+mediaQuery.padding.bottom;
    // Offset screenCenter = Offset(screenSize.width/2,(screenSize.height/2)+(safeAreaGap/2));
    Offset screenCenter = Offset(screenSize.width/2,screenSize.height/2);
    Offset effectiveCenter = Offset(screenCenter.dx, screenCenter.dy + (mediaQuery.padding.top/2) - (mediaQuery.padding.bottom/2));

    // final Offset effectiveAreaCenter = 

    final double statusBarHeight = mediaQuery.padding.top*1.25;
    final double appBarHeight = appBarSize.height;
    // final double appBarY = statusBarHeight+appBarHeight/2;
    final double appBarY = (statusBarHeight/2) + (appBarHeight/2);


    final double commonCenterX = effectiveCenter.dx;

    final double playAreaTop = effectiveCenter.dy-playAreaSize.height/2;
    final double scoreboardY = playAreaTop+(scoreboardSize.height/2);

    final double gap1Y = scoreboardY+(scoreboardSize.height/2) + gapSize.height/2;

    final double bounusY = gap1Y+(gapSize.height/2) + bonusAreaSize.height/2;

    final double gap2Y = bounusY+ (bonusAreaSize.height/2)+ gapSize.height/2;

    final double randomLettersY = gap2Y + (gapSize.height/2) + randomLettersAreaSize.height/2;

    final double boardY = randomLettersY + (randomLettersAreaSize.height/2) + boardAreaSize.height/2;

    final double reserveLettersY = boardY + (boardAreaSize.height/2) + reserveLettersAreaSize.height/2;

    final double perksY = reserveLettersY + (reserveLettersAreaSize.height/2) + perksAreaSize.height/2;

    final double gap3Y = perksY + (perksAreaSize.height/2) + gapSize.height/2;

    Offset scoreboardCenter = Offset(commonCenterX,scoreboardY);
    Offset appBarCenter = Offset(commonCenterX, appBarY);
    Offset gap1Center = Offset(commonCenterX,gap1Y);
    Offset bonusCenter = Offset(commonCenterX,bounusY);
    Offset gap2Center = Offset(commonCenterX,gap2Y);
    Offset randomLettersCenter = Offset(commonCenterX,randomLettersY);
    Offset boardCenter = Offset(commonCenterX,boardY);
    Offset reserveLettersCenter = Offset(commonCenterX,reserveLettersY);
    Offset perksCenter = Offset(commonCenterX,perksY);
    Offset gap3Center = Offset(commonCenterX,gap3Y);

    Map<String,dynamic> positionData = {
      "screenCenter": screenCenter,
      "effectiveCenter": effectiveCenter,
      "appBarCenter": appBarCenter,
      "scoreboardCenter":scoreboardCenter,
      "gap1Center": gap1Center ,
      "bonusCenter": bonusCenter,
      "gap2Center": gap2Center,
      "randomLettersCenter": randomLettersCenter,
      "boardCenter": boardCenter,
      "reserveLettersCenter": reserveLettersCenter,
      "perksCenter":perksCenter,
      "gap3Center": gap3Center,
    };

    print("""
=================================
element sizes at initialization:
---------------------------------

${positionData}

==================================
""");

    gamePlayState.setElementPositions(positionData);

    initializeTilePositions(gamePlayState); 
  }

  void initializeTilePositions(GamePlayState gamePlayState) {

    Map<String,dynamic> elementPositions = gamePlayState.elementPositions;
    final Size tileSize = gamePlayState.elementSizes["tileSize"];
    final Offset boardCenter = elementPositions["boardCenter"];
    final Offset reserveLettersCenter = elementPositions["reserveLettersCenter"];
    final Offset perksCenter = elementPositions["perksCenter"];
    final Size perksAreaSize = gamePlayState.elementSizes["perksAreaSize"];
    // final Offset randomLettersCenter = elementPositions["randomLetters"];

    final int numRows = gamePlayState.gameParameters["rows"]; //Helpers().getNumAxis(gamePlayState.tileData)[0];
    final int numCols = gamePlayState.gameParameters["columns"]; //Helpers().getNumAxis(gamePlayState.tileData)[1];

    final double actualBoardWidth = numCols*tileSize.width;
    final double actualBoardHeight = numRows*tileSize.height;

    final double boardTopY = boardCenter.dy-(actualBoardHeight/2);
    final double boardLeftX = boardCenter.dx-(actualBoardWidth/2);

    for (int i=0; i<gamePlayState.tileData.length; i++) {
      Map<String,dynamic> tileObject = gamePlayState.tileData[i];
      final int row = tileObject["row"];
      final int col = tileObject["column"];
      final double tileCenterX = boardLeftX + (tileSize.width*(col-1)) + (tileSize.width/2);
      final double tileCenterY = boardTopY + (tileSize.height*(row-1)) + (tileSize.height/2);
      final Offset tileCenter = Offset(tileCenterX,tileCenterY);
      
      gamePlayState.tileData[i]["center"] = tileCenter;
      Path tilePath = Path();
      tilePath.moveTo(tileCenter.dx-(tileSize.width/2), tileCenter.dy-(tileSize.height/2));
      tilePath.lineTo(tileCenter.dx+(tileSize.width/2), tileCenter.dy-(tileSize.height/2));
      tilePath.lineTo(tileCenter.dx+(tileSize.width/2), tileCenter.dy+(tileSize.height/2));
      tilePath.lineTo(tileCenter.dx-(tileSize.width/2), tileCenter.dy+(tileSize.height/2));
      tilePath.close();
      gamePlayState.tileData[i]["path"] = tilePath;    
    }

    final Size reserveTileSize = Size(tileSize.width*0.8,tileSize.height*0.8);
    final double reserveLetterRectWidth = (gamePlayState.reserveTileData.length) * (reserveTileSize.width);
    final double reserveLetterLeftX = reserveLettersCenter.dx-(reserveLetterRectWidth/2);

    for (int i=0; i<gamePlayState.reserveTileData.length; i++) {
      final int col = i;
      final double tileCenterX = reserveLetterLeftX + (reserveTileSize.width*(col)) + (reserveTileSize.width/2);
      final double tileCenterY = reserveLettersCenter.dy;  
      final Offset tileCenter = Offset(tileCenterX,tileCenterY);

      gamePlayState.reserveTileData[i]["center"] = tileCenter;

      Path tilePath = Path();
      tilePath.moveTo(tileCenter.dx-(reserveTileSize.width/2), tileCenter.dy-(reserveTileSize.height/2));
      tilePath.lineTo(tileCenter.dx+(reserveTileSize.width/2), tileCenter.dy-(reserveTileSize.height/2));
      tilePath.lineTo(tileCenter.dx+(reserveTileSize.width/2), tileCenter.dy+(reserveTileSize.height/2));
      tilePath.lineTo(tileCenter.dx-(reserveTileSize.width/2), tileCenter.dy+(reserveTileSize.height/2));
      tilePath.close();
      gamePlayState.reserveTileData[i]["path"] = tilePath;    
    }

    final Size perkSize = Size(perksAreaSize.height,perksAreaSize.height);
    final int nPerks = gamePlayState.tileMenuOptions.length;
    final double perksAreaWidth = perksAreaSize.width*0.8;
    final double perksAreaLeftX = perksCenter.dx-(perksAreaWidth/2);
    final double perksOccupiedWidth = perkSize.width * nPerks;
    final double perksBarEmptyArea = perksAreaWidth-perksOccupiedWidth;
    final int nGaps = nPerks+1;
    final double perksGapWidth = perksBarEmptyArea/nGaps;

    late int countGap = 0;
    late int countPerk = 0;
    late double runningDx = perksAreaLeftX;
        
    for (int i=0; i<(nPerks+nGaps); i++) {
      

      // if i%2 = 0 (is pair) - it's a gap
      if (i%2==0) {
        runningDx = runningDx + perksGapWidth;
        countGap += 1;
      } else {
        
        double perkCenterX = runningDx + perkSize.width/2;  
        runningDx = runningDx + perkSize.width;
        print("perk : $countPerk  = $perkCenterX");
        Map<String,dynamic> perkObject = gamePlayState.tileMenuOptions[countPerk];
        final Offset perkCenter = Offset(perkCenterX,perksCenter.dy);
        perkObject["center"]= perkCenter;

        Path perkPath = Path();
        perkPath.moveTo(perkCenter.dx-(perkSize.width/2), perkCenter.dy-(perkSize.height/2));
        perkPath.lineTo(perkCenter.dx+(perkSize.width/2), perkCenter.dy-(perkSize.height/2));
        perkPath.lineTo(perkCenter.dx+(perkSize.width/2), perkCenter.dy+(perkSize.height/2));
        perkPath.lineTo(perkCenter.dx-(perkSize.width/2), perkCenter.dy+(perkSize.height/2));
        perkPath.close();
        perkObject["path"] = perkPath;         
        countPerk += 1;

      }
      // final int col = i;
      // final double perkCenterX = reserveLetterLeftX + (reserveTileSize.width*(col)) + (reserveTileSize.width/2);
      // final double perkCenterY = reserveLettersCenter.dy;        
    }

  }

  void initializeAlphabet(SettingsController settings, GamePlayState gamePlayState) {
  // TEMPORARY FOR DEV ONLY
    // Random random = Random();
    // List<Map<String,dynamic>> letterValues = [];
    // List<String> letters = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
    // for (int i=0; i<letters.length;i++) {
    //   String letter = letters[i];
    //   int value = random.nextInt(4)+1;
    //   letterValues.add({"letter":letter,"value":value});
    // }

    List<Map<String,dynamic>> alphabet = List<Map<String, dynamic>>.from(settings.alphabet.value); 

    gamePlayState.setAlphabet(alphabet);
      
  }

  void initializeTileDecorationData(GamePlayState gamePlayState, ColorPalette palette) {

    final List<Color> colors = [
      palette.tileColor1,
      palette.tileColor2,
      palette.tileColor3,
      palette.tileColor4,
      palette.tileColor5,
      // const Color.fromARGB(255, 182, 21, 21),
      // const Color.fromARGB(255, 253, 115, 35),
      // const Color.fromARGB(255, 18, 112, 21),
      // const Color.fromARGB(255, 90, 175, 168),
      // const Color.fromARGB(255, 66, 79, 201),
      // const Color.fromARGB(255, 142, 77, 180),
      // const Color.fromARGB(255, 176, 39, 96)
    ];  

    Random random = Random();
    List<int> res = List.generate(colors.length, (e) => e+0);
    int randomIndex1 = res[random.nextInt(res.length)];
    res.removeAt(randomIndex1);
    int randomIndex2 = res[random.nextInt(res.length)];

    Color previousColor = colors[randomIndex1];
    gamePlayState.tileDecorationData.update("previousColor", (v) => previousColor); 

    Color nextColor = colors[randomIndex2];
    gamePlayState.tileDecorationData.update("nextColor", (v) => nextColor);

    gamePlayState.setTileDecorationData(gamePlayState.tileDecorationData);    

  }

  void initializeRandomLetterData(GamePlayState gamePlayState) {
    Random random = Random();
    List<Map<String,dynamic>> alphabet = gamePlayState.alphabet;

    print(alphabet);

    for (int i=0; i<2; i++) {
      int randomIndex = random.nextInt(alphabet.length);
      Map<String, dynamic> randomLetterObject = alphabet[randomIndex];
      String body = randomLetterObject["letter"];
      // randomLetterObject.update("count", (value) => randomLetterObject["count"] - 1);
      // randomLetterObject.update("inPlay", (value) => randomLetterObject["inPlay"] + 1);

      // startingLetters.add(alphabet[randomIndex]["letter"]);
      // alphabet.removeAt(randomIndex);
      gamePlayState.tileDecorationData.update("interval", (v) => gamePlayState.tileDecorationData["interval"]+1);

      int randomGradientIndex = random.nextInt(4);
      Map<String,dynamic> decorationData = StylingUtils().generateNewTileStyle(gamePlayState,random);
      decorationData["gradientOffset"]=randomGradientIndex; //{"gradientOffset":randomGradientIndex};
      Map<String,dynamic> startingLetterObject = {"body":body, "decorationData":decorationData};

      gamePlayState.setRandomLetterData([...gamePlayState.randomLetterData, startingLetterObject]);
    }
  }

  void initializeStringCombinations(GamePlayState gamePlayState) {
    
    int rows = gamePlayState.gameParameters["rows"]; // Helpers().getNumberAxis(gamePlayState, 'row');
    int cols = gamePlayState.gameParameters["columns"]; // Helpers().getNumberAxis(gamePlayState, 'column');

    // horizontal words JUST ONE ROW
    List<List<int>> res = [];
    for (int a=0;a<rows;a++) {
      for (int i=3; i<cols+1; i++) {
        int numCombinations = (cols-i)+1;
        for (int j=0;j<numCombinations;j++) {
          List<int> ids = [];
          for (int k=1;k<i+1; k++) {
            int val =  k+j;
            Map<String,dynamic> correspondingObject = gamePlayState.tileData.firstWhere((e)=> e["row"]==(a+1) && e["column"]==val,orElse: ()=>{});
            if(correspondingObject.isNotEmpty){
              int key= correspondingObject["key"];
              ids.add(key);
            } else {
              print("there was an error at row ${(a+1)} col $val");
            }
          }
          res.add(ids);
        }
      }
    }

    // // vertical
    for (int a=0;a<cols;a++) {
      for (int i=3; i<rows+1; i++) {
        int numCombinations = (rows-i)+1;
        for (int j=0;j<numCombinations;j++) {
          List<int> ids = [];
          for (int k=1;k<i+1; k++) {
            int val = k+j;
            Map<String,dynamic> correspondingObject = gamePlayState.tileData.firstWhere((e)=> e["column"]==(a+1) && e["row"]==val,orElse: ()=>{});
            if(correspondingObject.isNotEmpty){
              int key= correspondingObject["key"];
              ids.add(key);
            } else {
              print("there was an error at row ${(a+1)} col $val");
            }            
            // ids.add(val);
          }
          res.add(ids);
        }
      }
    }

    gamePlayState.setValidIdCombinations(res);
  }


  void initializeTime(GamePlayState gamePlayState, String gameType, int? durationInMinutes, int? timeToPlace) {
    // int? durationInMinutes = gamePlayState.gameParameters["durationInMinutes"];

      if (durationInMinutes != null) {
        Duration gameDuration = Duration(seconds: durationInMinutes*60);
        gamePlayState.setCountDownDuration(gameDuration);
      } else {
        gamePlayState.setCountDownDuration(null);
      }



      if (timeToPlace != null) {
        gamePlayState.setStopWatchLimit(timeToPlace * 1000);
      } 


    // if (gameType=="classic") {
    //   int duration = durationInMinutes != null ? durationInMinutes*60 : 600;
    //   Duration gameDuration = Duration(seconds: duration); 
    //   gamePlayState.setCountDownDuration(gameDuration);
    // } 

    // if (gameType == "timed-move") {
    //   int duration = durationInMinutes != null ? durationInMinutes*60 : 600;
    //   Duration gameDuration = Duration(seconds: duration);
    //   gamePlayState.setCountDownDuration(gameDuration);
    //   // gamePlayState.setStopWatchLimit(6 * 1000);
    // }

    // if (gameType == "sprint") {
    //   gamePlayState.setCountDownDuration(null);
    // }

    // if (gameType == "arcade") {
    //   gamePlayState.setCountDownDuration(null);
    //   gamePlayState.setStopWatchLimit(6 * 1000);
      
    // }

    if (gameType== "tutorial") {
      // gamePlayState.setStopWatchLimit(6 * 1000);
      gamePlayState.setCountDownDuration(null);
      gamePlayState.startHighlightEffectTimer();
    }

        
  }


  void initializeGame(SettingsController settings, GamePlayState gamePlayState, ColorPalette palette) {

    initializeTileDecorationData(gamePlayState, palette);

    initializeAlphabet(settings, gamePlayState);

    initializeRandomLetterData(gamePlayState);
  
    initializeStringCombinations(gamePlayState);

  }




  void terminateGame(BuildContext context, GamePlayState gamePlayState) {

    gamePlayState.gameResultData.update("didCompleteGame", (v)=> false);
    gamePlayState.gameResultData.update("didAchieveObjective", (v)=> false);
    gamePlayState.gameResultData.update("reward", (v)=> 0);
    gamePlayState.gameResultData.update("badges", (v)=> []);
    gamePlayState.gameResultData.update("xp", (v)=> 0);

    GameLogic().executeGameOverLogic(context,gamePlayState);

  }



  void initializeTutorial(SettingsController settings, GamePlayState gamePlayState, ColorPalette palette) {

    gamePlayState.setIsTutorial(true);
    
    initializeTileDecorationData(gamePlayState,palette);

    initializeAlphabet(settings, gamePlayState);

    initializeTutorialRandomLetterData(gamePlayState);
  
    initializeStringCombinations(gamePlayState);
  }


  void initializeTutorialRandomLetterData(GamePlayState gamePlayState) {
    Random random = Random();
    Map<String,dynamic> tutorialData = gamePlayState.tutorialData;
    List<String> tutorialLetters = tutorialData["randomLetters"];

    for (int i=0; i<tutorialLetters.length; i++) {
      
      String body = tutorialLetters[i];

      gamePlayState.tileDecorationData.update("interval", (v) => gamePlayState.tileDecorationData["interval"]+1);

      int randomGradientIndex = random.nextInt(4);
      Map<String,dynamic> decorationData = StylingUtils().generateNewTileStyle(gamePlayState,random);
      decorationData["gradientOffset"]=randomGradientIndex; //{"gradientOffset":randomGradientIndex};
      Map<String,dynamic> startingLetterObject = {"body":body, "decorationData":decorationData};

      gamePlayState.setRandomLetterData([...gamePlayState.randomLetterData, startingLetterObject]);
    }


  }

  void startGame(
    GamePlayState gamePlayState, 
    String gameTypeChoice, 
    int? duration, 
    int? targetPoints, 
    int? rowValue, 
    int? colValue, 
    int? timeToPlace, 
    String? puzzleId,
    SettingsController settings,
    MediaQueryData mediaQueryData,
    BuildContext context,
    ColorPalette palette,
    ) {

    gamePlayState.setGameParameters({
      "gameType":gameTypeChoice,
      "target":targetPoints,
      "targetType": null,
      "rows":rowValue,
      "columns":colValue,
      "durationInMinutes":duration,
      "timeToPlace": timeToPlace,
      "puzzleId": puzzleId,
      "mediaQueryData": mediaQueryData,
    });
    Map<String,dynamic> deviceSizeData = settings.deviceSizeInfo.value as Map<String,dynamic>;
    gamePlayState.setScalor(deviceSizeData["scalor"]);
    Initializations().initializeTime(gamePlayState,gameTypeChoice, duration,timeToPlace,);
    Initializations().initializeTileData(gamePlayState,rowValue!,colValue!);
    Initializations().initializeElementSizes(gamePlayState,mediaQueryData);
    Initializations().initializeElementPositions(gamePlayState,mediaQueryData);
    // Initializations().initializeDictionary(settings,gamePlayState);

    if (gameTypeChoice == "tutorial") {
      Initializations().initializeTutorial(settings, gamePlayState,palette);
    } else {
      Initializations().initializeGame(settings, gamePlayState,palette);
    }


    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const GameScreen())
      // MaterialPageRoute(builder: (context) => const TempScreen())
    );      
  }







}