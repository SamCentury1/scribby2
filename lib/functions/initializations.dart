import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
import 'package:scribby_flutter_v2/resources/storage_methods.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';

class Initializations {



  Future<void> initializeDeviceSizePropertiesAndTheme(SettingsController settings, ColorPalette palette,) async {
  
  }

  Future<void> initializeAppData(SettingsController settings, ColorPalette palette, User? user) async {

    // // WidgetsBinding.instance.addPostFrameCallback((_) {
    // StorageMethods().saveDeviceSizeInfoToSettings(settings);
    // palette.getThemeColors('default');  

    // print("set this shit up???");    
    // // });      

    // await StorageMethods().saveDeviceSizeInfoToSettings(settings);
    // if local storage is empty - get the level data as json payload and set it
    // levels to play
    if (settings.levelData.value.isEmpty) {
      await StorageMethods().saveLevelDataFromJsonFileToLocalStorage(settings);
    }
    // text explaining the types of games
    if (settings.gameInfoData.value.isEmpty) {
      await StorageMethods().saveGameInfoDataFromJsonFileToLocalStorage(settings);
    }

    if (settings.achievementData.value.isEmpty) {
      await StorageMethods().saveAchievementDataFromJsonFileToLocalStorage(settings);
    }

    if (settings.rankData.value.isEmpty) {
      await StorageMethods().saveRankDataFromJsonFileToLocalStorage(settings);
    }


    Map<String,dynamic> userData = await FirestoreMethods().getFirestoreDocument(user!.uid);
    settings.setUserData(userData);

    print("userData => $userData");
    
    if (userData.isNotEmpty) {
      palette.getThemeColors(userData["parameters"]["theme"]);
    }

    // await StorageMethods().saveDummyUserToSettings(settings,palette);

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

  // void initializeTileData(GamePlayState gamePlayState, int numRows, int numCols) {

  //   // int numRows = gamePlayState.gameParameters["rows"];
  //   // int numCols = gamePlayState.gameParameters["columns"];
  //   Random random = Random();
  //   // List<String> alphabet = [
  //   //   "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", 
  //   //   "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", 
  //   // ];
  //   List<Map<String,dynamic>> tileObjects = [];
  //   for (int r=0; r<numRows; r++) {
  //     for (int c=0; c<numCols; c++) {
  //       int tileId = tileObjects.length;
  //       // int randomIndex = random.nextInt(4);
  //       Map<String,dynamic> decorationData = StylingUtils().generateNewTileStyle(gamePlayState,random);
  //       decorationData["gradientOffset"] = random.nextInt(4);
  //       late Map<String,dynamic> tileObject = {
  //         "type": "board",
  //         "key": tileId,
  //         "row": r+1,
  //         "column" : c+1,
  //         "body": "",//alphabet[randomIndex],
  //         "active": true,
  //         "dragging":false,
  //         "menuOpen":false,
  //         "menuData":null,
  //         "frozen": false,
  //         "swapping": false,
  //         "decorationData": decorationData
  //       };
  //       tileObjects.add(tileObject);
  //     }
  //   }
  //   gamePlayState.setTileData(tileObjects);


  //   List<Map<String,dynamic>> reserveObjects = [];
  //   for (int i=0; i<5; i++) {
  //     int tileId = (reserveObjects.length+1)*1000;
  //     // int randomIndex = random.nextInt(alphabet.length);
  //     Map<String,dynamic> decorationData = StylingUtils().generateNewTileStyle(gamePlayState,random);
  //     decorationData["gradientOffset"] = random.nextInt(4);      
  //     late Map<String,dynamic> tileObject = {
  //       "key": tileId,
  //       "type": "reserve",
  //       "body": "", // alphabet[randomIndex],
  //       "active": true,
  //       "dragging": false,
  //       "decorationData": decorationData,
  //     };
  //     reserveObjects.add(tileObject);
  //   }
  //   gamePlayState.setReserveTileData(reserveObjects);    
  // }


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

  // // takes in the size of the phone and determines how big each elenent should be
  // // saves that to a variable in the GamePlayState class
  // void initializeElementSizes(GamePlayState gamePlayState, MediaQueryData mediaQuery) {

  //   final double safePadding = mediaQuery.padding.top+mediaQuery.padding.bottom;

  //   // effective height is less
  //   final double effectiveHeight = mediaQuery.size.height-safePadding;
  //   final double effectiveWidth = mediaQuery.size.width;

  //   Size effectiveSize = Size(effectiveWidth,effectiveHeight);

  //   Size playAreaSize = getPlayAreaSize2(gamePlayState,mediaQuery);

  //   int numRows = gamePlayState.gameParameters["rows"]; // Helpers().getNumberAxis(gamePlayState,'row');
  //   int numCols = gamePlayState.gameParameters["columns"]; // Helpers().getNumberAxis(gamePlayState,'column');
  //   double tileWidth = StylingUtils().getTileSize(playAreaSize, numRows, numCols);

  //   final double boardHeight = tileWidth*numRows;
  //   final double randomLettersHeight = tileWidth*2.5;
  //   final double reserveLettersHeight = tileWidth*1.5;

  //   final double scoreboardHeightShare = 0.08;
  //   final double bonusAreaHeightShare = 0.05;
  //   final double randomLettersHeightShare = randomLettersHeight/playAreaSize.height;
  //   final double boardHeightShare = boardHeight/playAreaSize.height;
  //   final double reserveLetterHeightShare = reserveLettersHeight/playAreaSize.height;
  //   final double totalGap = 1.0-(scoreboardHeightShare+bonusAreaHeightShare+randomLettersHeightShare+boardHeightShare+reserveLetterHeightShare);

  //   final Size scoreboardAreaSize = Size(effectiveSize.width,scoreboardHeightShare*playAreaSize.height);
  //   final Size bonusAreaSize = Size(playAreaSize.width,bonusAreaHeightShare*playAreaSize.height);
  //   final Size randomLettersAreaSize = Size(playAreaSize.width,randomLettersHeightShare*playAreaSize.height);
  //   final Size boardAreaSize = Size(numCols*tileWidth,boardHeightShare*playAreaSize.height);
  //   final Size reserveLettersAreaSize = Size(playAreaSize.width,reserveLetterHeightShare*playAreaSize.height);
  //   final Size gapSize = Size(playAreaSize.width,(totalGap/3)*playAreaSize.height);

  //   Map<String,dynamic> sizeData = {
  //     "tileSize":Size(tileWidth,tileWidth),
  //     "appBarSize": AppBar().preferredSize,
  //     "screenSize": mediaQuery.size,
  //     "effectiveSize": effectiveSize,
  //     "playAreaSize": playAreaSize,
  //     "scoreboardAreaSize":scoreboardAreaSize,
  //     "bonusAreaSize":bonusAreaSize,
  //     "randomLettersAreaSize":randomLettersAreaSize,
  //     "boardAreaSize":boardAreaSize,
  //     "reserveLettersAreaSize":reserveLettersAreaSize,
  //     "gapSize":gapSize,
  //   };

  //   gamePlayState.setElementSizes(sizeData);    
  // }

  // void initializeElementPositions(GamePlayState gamePlayState, MediaQueryData mediaQuery) {
  //   Map<String,dynamic> sizeData = gamePlayState.elementSizes;

  //   Size screenSize = sizeData["screenSize"];
  //   Size playAreaSize = sizeData["playAreaSize"];
  //   Size appBarSize = sizeData["appBarSize"];
  //   Size scoreboardSize = sizeData["scoreboardAreaSize"];
  //   Size gapSize = sizeData["gapSize"];
  //   Size bonusAreaSize = sizeData["bonusAreaSize"];
  //   Size randomLettersAreaSize = sizeData["randomLettersAreaSize"];
  //   Size boardAreaSize = sizeData["boardAreaSize"];
  //   Size reserveLettersAreaSize = sizeData["reserveLettersAreaSize"];

  //   print("size in initialization : ${mediaQuery.size}");


  //   // double safeAreaGap = mediaQuery.padding.top+mediaQuery.padding.bottom;
  //   // Offset screenCenter = Offset(screenSize.width/2,(screenSize.height/2)+(safeAreaGap/2));
  //   Offset screenCenter = Offset(screenSize.width/2,screenSize.height/2);
  //   Offset effectiveCenter = Offset(screenCenter.dx, screenCenter.dy + (mediaQuery.padding.top/2) - (mediaQuery.padding.bottom/2));

  //   // final Offset effectiveAreaCenter = 

  //   final double statusBarHeight = mediaQuery.padding.top*1.25;
  //   final double appBarHeight = appBarSize.height;
  //   // final double appBarY = statusBarHeight+appBarHeight/2;
  //   final double appBarY = (statusBarHeight/2) + (appBarHeight/2);


  //   final double commonCenterX = effectiveCenter.dx;

  //   final double playAreaTop = effectiveCenter.dy-playAreaSize.height/2;
  //   final double scoreboardY = playAreaTop+(scoreboardSize.height/2);

  //   final double gap1Y = scoreboardY+(scoreboardSize.height/2) + gapSize.height/2;

  //   final double bounusY = gap1Y+(gapSize.height/2) + bonusAreaSize.height/2;

  //   final double gap2Y = bounusY+ (bonusAreaSize.height/2)+ gapSize.height/2;

  //   final double randomLettersY = gap2Y + (gapSize.height/2) + randomLettersAreaSize.height/2;

  //   final double boardY = randomLettersY + (randomLettersAreaSize.height/2) + boardAreaSize.height/2;

  //   final double reserveLettersY = boardY + (boardAreaSize.height/2) + reserveLettersAreaSize.height/2;

  //   final double gap3Y = reserveLettersY + (reserveLettersAreaSize.height/2) + gapSize.height/2;

  //   Offset scoreboardCenter = Offset(commonCenterX,scoreboardY);
  //   Offset appBarCenter = Offset(commonCenterX, appBarY);
  //   Offset gap1Center = Offset(commonCenterX,gap1Y);
  //   Offset bonusCenter = Offset(commonCenterX,bounusY);
  //   Offset gap2Center = Offset(commonCenterX,gap2Y);
  //   Offset randomLettersCenter = Offset(commonCenterX,randomLettersY);
  //   Offset boardCenter = Offset(commonCenterX,boardY);
  //   Offset reserveLettersCenter = Offset(commonCenterX,reserveLettersY);
  //   Offset gap3Center = Offset(commonCenterX,gap3Y);

  //   Map<String,dynamic> positionData = {
  //     "screenCenter": screenCenter,
  //     "effectiveCenter": effectiveCenter,
  //     "appBarCenter": appBarCenter,
  //     "scoreboardCenter":scoreboardCenter,
  //     "gap1Center": gap1Center ,
  //     "bonusCenter": bonusCenter,
  //     "gap2Center": gap2Center,
  //     "randomLettersCenter": randomLettersCenter,
  //     "boardCenter": boardCenter,
  //     "reserveLettersCenter": reserveLettersCenter,
  //     "gap3Center": gap3Center,
  //   };

    

  //   gamePlayState.setElementPositions(positionData);


  //   initializeTilePositions(gamePlayState); 
  // }

  // void initializeTilePositions(GamePlayState gamePlayState) {

  //   Map<String,dynamic> elementPositions = gamePlayState.elementPositions;
  //   final Size tileSize = gamePlayState.elementSizes["tileSize"];
  //   final Offset boardCenter = elementPositions["boardCenter"];
  //   final Offset reserveLettersCenter = elementPositions["reserveLettersCenter"];
  //   // final Offset randomLettersCenter = elementPositions["randomLetters"];

  //   final int numRows = gamePlayState.gameParameters["rows"]; //Helpers().getNumAxis(gamePlayState.tileData)[0];
  //   final int numCols = gamePlayState.gameParameters["columns"]; //Helpers().getNumAxis(gamePlayState.tileData)[1];

  //   final double actualBoardWidth = numCols*tileSize.width;
  //   final double actualBoardHeight = numRows*tileSize.height;

  //   final double boardTopY = boardCenter.dy-(actualBoardHeight/2);
  //   final double boardLeftX = boardCenter.dx-(actualBoardWidth/2);

  //   for (int i=0; i<gamePlayState.tileData.length; i++) {
  //     Map<String,dynamic> tileObject = gamePlayState.tileData[i];
  //     final int row = tileObject["row"];
  //     final int col = tileObject["column"];
  //     final double tileCenterX = boardLeftX + (tileSize.width*(col-1)) + (tileSize.width/2);
  //     final double tileCenterY = boardTopY + (tileSize.height*(row-1)) + (tileSize.height/2);
  //     final Offset tileCenter = Offset(tileCenterX,tileCenterY);
      
  //     gamePlayState.tileData[i]["center"] = tileCenter;
  //     Path tilePath = Path();
  //     tilePath.moveTo(tileCenter.dx-(tileSize.width/2), tileCenter.dy-(tileSize.height/2));
  //     tilePath.lineTo(tileCenter.dx+(tileSize.width/2), tileCenter.dy-(tileSize.height/2));
  //     tilePath.lineTo(tileCenter.dx+(tileSize.width/2), tileCenter.dy+(tileSize.height/2));
  //     tilePath.lineTo(tileCenter.dx-(tileSize.width/2), tileCenter.dy+(tileSize.height/2));
  //     tilePath.close();
  //     gamePlayState.tileData[i]["path"] = tilePath;    
  //   }

  //   final Size reserveTileSize = Size(tileSize.width*0.8,tileSize.height*0.8);
  //   final double reserveLetterRectWidth = (gamePlayState.reserveTileData.length) * (reserveTileSize.width);
  //   final double reserveLetterLeftX = reserveLettersCenter.dx-(reserveLetterRectWidth/2);
  //   for (int i=0; i<gamePlayState.reserveTileData.length; i++) {
  //     final int col = i;
  //     final double tileCenterX = reserveLetterLeftX + (reserveTileSize.width*(col)) + (reserveTileSize.width/2);
  //     final double tileCenterY = reserveLettersCenter.dy;  
  //     final Offset tileCenter = Offset(tileCenterX,tileCenterY);

  //     gamePlayState.reserveTileData[i]["center"] = tileCenter;

  //     Path tilePath = Path();
  //     tilePath.moveTo(tileCenter.dx-(reserveTileSize.width/2), tileCenter.dy-(reserveTileSize.height/2));
  //     tilePath.lineTo(tileCenter.dx+(reserveTileSize.width/2), tileCenter.dy-(reserveTileSize.height/2));
  //     tilePath.lineTo(tileCenter.dx+(reserveTileSize.width/2), tileCenter.dy+(reserveTileSize.height/2));
  //     tilePath.lineTo(tileCenter.dx-(reserveTileSize.width/2), tileCenter.dy+(reserveTileSize.height/2));
  //     tilePath.close();
  //     gamePlayState.reserveTileData[i]["path"] = tilePath;    
  //   }

  // }

  // void initializeAlphabet(GamePlayState gamePlayState) {
  // // TEMPORARY FOR DEV ONLY
  //   Random random = Random();
  //   List<Map<String,dynamic>> letterValues = [];
  //   List<String> letters = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
  //   for (int i=0; i<letters.length;i++) {
  //     String letter = letters[i];
  //     int value = random.nextInt(4)+1;
  //     letterValues.add({"letter":letter,"value":value});
  //   }
  //   gamePlayState.setAlphabet(letterValues);
      
  // }

  // void initializeTileDecorationData(GamePlayState gamePlayState) {

  //   final List<Color> colors = [
  //     const Color.fromARGB(255, 182, 21, 21),
  //     const Color.fromARGB(255, 253, 115, 35),
  //     const Color.fromARGB(255, 18, 112, 21),
  //     const Color.fromARGB(255, 90, 175, 168),
  //     const Color.fromARGB(255, 66, 79, 201),
  //     const Color.fromARGB(255, 142, 77, 180),
  //     const Color.fromARGB(255, 176, 39, 96)
  //   ];  

  //   Random random = Random();
  //   List<int> res = List.generate(colors.length, (e) => e+0);
  //   int randomIndex1 = res[random.nextInt(res.length)];
  //   res.removeAt(randomIndex1);
  //   int randomIndex2 = res[random.nextInt(res.length)];

  //   Color previousColor = colors[randomIndex1];
  //   gamePlayState.tileDecorationData.update("previousColor", (v) => previousColor); 

  //   Color nextColor = colors[randomIndex2];
  //   gamePlayState.tileDecorationData.update("nextColor", (v) => nextColor);

  //   gamePlayState.setTileDecorationData(gamePlayState.tileDecorationData);    

  // }

  // void initializeRandomLetterData(GamePlayState gamePlayState) {
  //   Random random = Random();
  //   List<Map<String,dynamic>> alphabet = gamePlayState.alphabet;

  //   for (int i=0; i<2; i++) {
  //     int randomIndex = random.nextInt(alphabet.length);
  //     String body = alphabet[randomIndex]["letter"];
  //     // startingLetters.add(alphabet[randomIndex]["letter"]);
  //     // alphabet.removeAt(randomIndex);
  //     gamePlayState.tileDecorationData.update("interval", (v) => gamePlayState.tileDecorationData["interval"]+1);

  //     int randomGradientIndex = random.nextInt(4);
  //     Map<String,dynamic> decorationData = StylingUtils().generateNewTileStyle(gamePlayState,random);
  //     decorationData["gradientOffset"]=randomGradientIndex; //{"gradientOffset":randomGradientIndex};
  //     Map<String,dynamic> startingLetterObject = {"body":body, "decorationData":decorationData};

  //     gamePlayState.setRandomLetterData([...gamePlayState.randomLetterData, startingLetterObject]);
  //   }
  // }

  // void initializeStringCombinations(GamePlayState gamePlayState) {
    
  //   int rows = gamePlayState.gameParameters["rows"]; // Helpers().getNumberAxis(gamePlayState, 'row');
  //   int cols = gamePlayState.gameParameters["columns"]; // Helpers().getNumberAxis(gamePlayState, 'column');

  //   // horizontal words JUST ONE ROW
  //   List<List<int>> res = [];
  //   for (int a=0;a<rows;a++) {
  //     for (int i=3; i<cols+1; i++) {
  //       int numCombinations = (cols-i)+1;
  //       for (int j=0;j<numCombinations;j++) {
  //         List<int> ids = [];
  //         for (int k=1;k<i+1; k++) {
  //           int val =  k+j;
  //           Map<String,dynamic> correspondingObject = gamePlayState.tileData.firstWhere((e)=> e["row"]==(a+1) && e["column"]==val,orElse: ()=>{});
  //           if(correspondingObject.isNotEmpty){
  //             int key= correspondingObject["key"];
  //             ids.add(key);
  //           } else {
  //             print("there was an error at row ${(a+1)} col $val");
  //           }
  //         }
  //         res.add(ids);
  //       }
  //     }
  //   }

  //   // // vertical
  //   for (int a=0;a<cols;a++) {
  //     for (int i=3; i<rows+1; i++) {
  //       int numCombinations = (rows-i)+1;
  //       for (int j=0;j<numCombinations;j++) {
  //         List<int> ids = [];
  //         for (int k=1;k<i+1; k++) {
  //           int val = k+j;
  //           Map<String,dynamic> correspondingObject = gamePlayState.tileData.firstWhere((e)=> e["column"]==(a+1) && e["row"]==val,orElse: ()=>{});
  //           if(correspondingObject.isNotEmpty){
  //             int key= correspondingObject["key"];
  //             ids.add(key);
  //           } else {
  //             print("there was an error at row ${(a+1)} col $val");
  //           }            
  //           // ids.add(val);
  //         }
  //         res.add(ids);
  //       }
  //     }
  //   }

  //   gamePlayState.setValidIdCombinations(res);
  // }


  // void initializeTime(GamePlayState gamePlayState, String gameType, int? durationInMinutes) {
  //   // int? durationInMinutes = gamePlayState.gameParameters["durationInMinutes"];

  //   if (gameType=="classic") {
  //     int duration = durationInMinutes != null ? durationInMinutes*60 : 600;
  //     Duration gameDuration = Duration(seconds: duration); 
  //     gamePlayState.setCountDownDuration(gameDuration);
  //   } 

  //   if (gameType == "timed-move") {
  //     int duration = durationInMinutes != null ? durationInMinutes*60 : 600;
  //     Duration gameDuration = Duration(seconds: duration);
  //     gamePlayState.setCountDownDuration(gameDuration);
  //     gamePlayState.setStopWatchLimit(6 * 1000);
  //   }

  //   if (gameType == "sprint") {
  //     gamePlayState.setCountDownDuration(null);
  //   }

  //   if (gameType == "arcade") {
  //     gamePlayState.setCountDownDuration(null);
  //     gamePlayState.setStopWatchLimit(6 * 1000);
      
  //   }

  //   if (gameType== "tutorial") {
  //     // gamePlayState.setStopWatchLimit(6 * 1000);
  //     gamePlayState.setCountDownDuration(null);
  //     gamePlayState.startHighlightEffectTimer();
  //   }

        
  // }


  // void initializeGame(GamePlayState gamePlayState) {

  //   initializeTileDecorationData(gamePlayState);

  //   initializeAlphabet(gamePlayState);

  //   initializeRandomLetterData(gamePlayState);
  
  //   initializeStringCombinations(gamePlayState);

  // }




  // void terminateGame(BuildContext context, GamePlayState gamePlayState) {

  //   gamePlayState.gameResultData.update("didCompleteGame", (v)=> false);
  //   gamePlayState.gameResultData.update("didAchieveObjective", (v)=> false);
  //   gamePlayState.gameResultData.update("reward", (v)=> 0);
  //   gamePlayState.gameResultData.update("badges", (v)=> []);
  //   gamePlayState.gameResultData.update("xp", (v)=> 0);

  //   GameLogic().executeGameOverLogic(context,gamePlayState);

  // }



  // void initializeTutorial(GamePlayState gamePlayState) {

  //   gamePlayState.setIsTutorial(true);
    
  //   initializeTileDecorationData(gamePlayState);

  //   initializeAlphabet(gamePlayState);

  //   initializeTutorialRandomLetterData(gamePlayState);
  
  //   initializeStringCombinations(gamePlayState);
  // }


  // void initializeTutorialRandomLetterData(GamePlayState gamePlayState) {
  //   Random random = Random();
  //   Map<String,dynamic> tutorialData = gamePlayState.tutorialData;
  //   List<String> tutorialLetters = tutorialData["randomLetters"];

  //   for (int i=0; i<tutorialLetters.length; i++) {
      
  //     String body = tutorialLetters[i];

  //     gamePlayState.tileDecorationData.update("interval", (v) => gamePlayState.tileDecorationData["interval"]+1);

  //     int randomGradientIndex = random.nextInt(4);
  //     Map<String,dynamic> decorationData = StylingUtils().generateNewTileStyle(gamePlayState,random);
  //     decorationData["gradientOffset"]=randomGradientIndex; //{"gradientOffset":randomGradientIndex};
  //     Map<String,dynamic> startingLetterObject = {"body":body, "decorationData":decorationData};

  //     gamePlayState.setRandomLetterData([...gamePlayState.randomLetterData, startingLetterObject]);
  //   }    
  // }



}