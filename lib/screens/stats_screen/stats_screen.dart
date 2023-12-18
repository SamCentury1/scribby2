// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:scribby_flutter_v2/functions/game_logic.dart';
// import 'package:scribby_flutter_v2/player_progress/player_progress.dart';
// import 'package:scribby_flutter_v2/resources/auth_service.dart';
// import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
// import 'package:scribby_flutter_v2/screens/menu_screen/menu_screen.dart';
// import 'package:scribby_flutter_v2/screens/stats_screen/components/game_stats_card.dart';
// import 'package:scribby_flutter_v2/settings/settings.dart';
// import 'package:scribby_flutter_v2/styles/palette.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class StatsScreen extends StatefulWidget {
//   const StatsScreen({super.key});

//   @override
//   State<StatsScreen> createState() => _StatsScreenState();
// }




// class _StatsScreenState extends State<StatsScreen> with TickerProviderStateMixin{

//   late List<Map<String,dynamic>?> _gameData = [];
//   late bool isLoading = false;
//   final List<String> sortChoices = <String>['Points', 'Words', 'Date', 'Duration'];
//   late String dropdownValue;
//   late final TabController _tabController;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getUserGameData('Points');
//     _tabController = TabController(length: 2, vsync: this);
//     dropdownValue = sortChoices.first;

//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }


//   Future<void> getUserGameData(String property) async {
//     setState(() {
//       isLoading = true;
//     });
//     final List<Map<String,dynamic>?> gameData = await FirestoreMethods().getUserGames(AuthService().currentUser!.uid);
//     try {
//       // print("here you go boss: ${gameData}");
//       setState(() {
//         _gameData = gameData;
//         isLoading = false;
//       });
//       sortBasedOnProperty(property);
//     } catch (e) {
//       print(e.toString());
//     }

//   }

//   void sortBasedOnProperty(String property) {
//     String converted = convertStringForDropdown(property);
//     _gameData.sort((a,b) => (
//       (b![converted]))
//       .compareTo(
//         (a![converted])
//       )
//     );
//   }

//   String convertStringForDropdown(String property) {
//     String res = "points";
//     switch (property) {
//       case "Points": res = "points";
//         break;
//       case "Words": res = "uniqueWords";
//         break;
//       case "Date": res = "timeStamp";
//         break;
//       case "Duration": res = "duration";
//         break;    
//     }
//     return res;
//   }

//   List<Map<String,dynamic>?> reOrderGames(String property, List<Map<String,dynamic>?> games) {
//     late List<Map<String,dynamic>?> res = games;
//     String converted = convertStringForDropdown(property);
//     res.sort((a,b) => (
//       (b![converted]))
//       .compareTo(
//         (a![converted])
//       )
//     );
//     return res;  
//   }





//   @override
//   Widget build(BuildContext context) {

//     // final playerProgress = context.watch<PlayerProgress>();
//     // List<Map<String,dynamic>> previousGames = playerProgress.gamesPlayed;
//     final SettingsController settings = Provider.of<SettingsController>(context, listen: false);
//     final Palette palette = Provider.of<Palette>(context, listen: false);

    

//     return isLoading ? Center(child: CircularProgressIndicator(),) :
//     Scaffold(

//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {Navigator.pop(context);},
//           icon: Icon(
//             Icons.arrow_back,
//             color: GameLogic().getColor(settings.darkTheme.value, palette, "timer_text"),
//           )
//         ),
//         bottom: TabBar(
//           controller: _tabController,
//           indicatorColor: Colors.deepPurple,
//           labelColor: GameLogic().getColor(settings.darkTheme.value, palette, "timer_text"),
//           labelStyle: TextStyle( fontSize: 16, fontWeight: FontWeight.bold),
//           unselectedLabelStyle : TextStyle(fontWeight: FontWeight.normal),
//           unselectedLabelColor: GameLogic().getColor(settings.darkTheme.value, palette, "timer_text"),
//           tabs: [
//             Tab(
//               text: "Highlights",
//             ),
//             Tab(text: "My Games",),
//           ],
//         ),        
//         title: Text(
//           "Statistics",
//           style: TextStyle(
//             color: GameLogic().getColor(settings.darkTheme.value, palette, "timer_text"),
//           ),
//         ),       
//         backgroundColor: GameLogic().getColor(settings.darkTheme.value, palette, "screen_background"),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: <Widget>[

//           highlightsWidget(_gameData, settings, palette),
//           // Container(
//           //   width: double.infinity,
//           //   height: double.infinity,
//           //   color: GameLogic().getColor(settings.darkTheme.value, palette, "screen_background"),
//           //   child: Column(
//           //     children: [
//           //       Text("Highlights")
//           //     ],
//           //   ),
//           // ),



//           Container(
//             width: double.infinity,
//             height: double.infinity,
//             color: GameLogic().getColor(settings.darkTheme.value, palette, "screen_background"),
//             child: SafeArea(
          
//               child: Column(
//                 children: [
//                   const SizedBox(height: 10,),
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
//                     child: Row(
//                       children: [
//                         Text(
//                           "Sort by:",
//                           style: TextStyle(
//                             color: GameLogic().getColor(settings.darkTheme.value, palette, "timer_text"),
//                             fontSize: 22,
//                           ),
//                         ), 
//                         const SizedBox(width: 20,),
//                         DropdownButton<String>(
//                           value: dropdownValue,
//                           icon: const Icon(Icons.arrow_downward),
//                           autofocus: true,
//                           borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                           dropdownColor: GameLogic().getColor(settings.darkTheme.value, palette, "bottom_navigation_bar"),
//                           elevation: 1,
//                           style: TextStyle(
//                             color: GameLogic().getColor(settings.darkTheme.value, palette, "timer_text"),
//                             fontSize: 22
//                           ),
//                           underline: Container(
//                             height: 2,
//                             color: Colors.deepPurpleAccent,
//                           ),
//                           onChanged: (String? value) {
//                             // This is called when the user selects an item.
//                             setState(() {
//                               dropdownValue = value!;
//                               _gameData = reOrderGames(value, _gameData);
//                             });
          
//                             // getUserGameData(dropdownValue);
//                           },
//                           items: sortChoices.map<DropdownMenuItem<String>>((String value) {
//                             return DropdownMenuItem<String>(
//                               value: value,
//                               child: Text(value),
//                             );
//                           }).toList(),
//                         ),                   
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 10,),

//                   gamesListWidget(_gameData,settings,palette),
         
//                 ],
//               ),
          
//             ),
//           ),          
//         ],
//       ),
//     );
//   }
// }


// Widget gamesListWidget(List<Map<String, dynamic>?> gameDataList, SettingsController settings, Palette palette) {

//   return Expanded(
//     child: ListView.builder(
//       itemCount: gameDataList.length,
//       itemBuilder: (context, index) {
//         Map<String, dynamic>? gameData = gameDataList[index];
//         // final gameDateText = DateFormat.yMMMd().format(DateTime.parse(gameData['timeStamp']),);
//         return GameStatsCard(
//           index: index, 
//           gameData: gameData!,
//           settings: settings,
//           palette: palette,
//         );
//       },
//     ),
//   );
// }


// Widget highlightsWidget(List<Map<String, dynamic>?> gameDataList, SettingsController settings, Palette palette) {

//   int getTotalGamesPlayed(List<Map<String, dynamic>?> gameDataList) {
//     int res = gameDataList.length;
//     return res;
//   }

//   int getTotalPointsScored(List<Map<String, dynamic>?> gameDataList) {
//     num res = 0;
//     for (Map<String,dynamic>? item in gameDataList) {
//       res = res + item!["points"];
//     }    
//     return res.floor();
//   }


//   Map<String,dynamic> getWordData(List<Map<String, dynamic>?> gameDataList) {
//     Map<String,dynamic> res = {};
//     num three = 0;
//     num four = 0;
//     num five = 0;
//     num six = 0;
//     List<String> uniqueWords = [];

//     for (Map<String,dynamic>? item in gameDataList) {
//       for (String word in item!["uniqueWordsList"]) {
//         if (!uniqueWords.contains(word)) {
//           uniqueWords.add(word);
//           int wordLength = word.length;
//           switch (wordLength) {
//             case 3:  three++ ;
//               break;
//             case 4:  four++ ;
//               break;
//             case 5:  five++ ;
//               break;
//             case 6:  six++ ;
//               break;                                          
//           }
//         }
//       }
//     }
//     res = {"total": uniqueWords.length, "three" :three , "four" :four , "five" :five , "six" :six };    
//     return res;
//   }

//   int getLongestStreak(List<Map<String, dynamic>?> gameDataList) {
//     int res = 0;

//     for (Map<String,dynamic>? item in gameDataList) {
//       if (item!["longestStreak"] > res) {
//         res = item["longestStreak"];
//       }
//     }
//     return res;
//   }

//   int getTotalCrossWords(List<Map<String, dynamic>?> gameDataList) {
//     num res = 0;
//     for (Map<String,dynamic>? item in gameDataList) {
//         res =  res + item!["crossWords"];
      
//     }    
//     return res.floor();
//   }


//   return Container(
//     width: double.infinity,
//     height: double.infinity,
//     color: GameLogic().getColor(settings.darkTheme.value, palette, "screen_background"),
//     child: Column(
//       children: [
//         // Text(
//         //   "Highlights",
//         //   style: TextStyle(
//         //     color: GameLogic().getColor(settings.darkTheme.value, palette, "timer_text"),
//         //     fontSize: 22,
//         //   ),
//         // ),

//         SizedBox(height: 35,),
//         // Text("Games Played: ${getTotalGamesPlayed(gameDataList)}"),
//         totalGamesPlayedCard(getTotalGamesPlayed(gameDataList)),
//         // Text("Total Points: ${getTotalPointsScored(gameDataList)}"),
//         Padding(
//           padding: const EdgeInsets.all(18.0),
//           child: Row(
//             children: <Widget>[
//               totalStatHalf(getTotalPointsScored(gameDataList), "Total Points",22),
//               totalStatHalf(getWordData(gameDataList)["total"], "Unique Words",22),
//             ],
//           ),
//         ),

//         Padding(
//           padding: const EdgeInsets.all(18.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[

//               totalStatQuarter(getWordData(gameDataList)["three"],"3",16),
//               totalStatQuarter(getWordData(gameDataList)["four"],"4",16),
//               totalStatQuarter(getWordData(gameDataList)["five"],"5",16),
//               totalStatQuarter(getWordData(gameDataList)["six"],"6",16),
//             ],
//           ),
//         ),

//         statItemFullCard(getLongestStreak(gameDataList),"Longest Streak", Icon(Icons.bolt)),
//         statItemFullCard(getTotalCrossWords(gameDataList),"Most Crosswords", Icon(Icons.close)),


//       ],
//     ),
//   );
// }

// Widget totalGamesPlayedCard(int value) {
//   return Padding(
//     padding: const EdgeInsets.fromLTRB(28.0, 6.0, 28.0, 6.0),
//     child: Container(
//       width: double.infinity,
//       height: 70,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//         color: Colors.amber,
//       ),
//       child: Row(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Container(
//               width: 60,
//               height: 60,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                 color:  Colors.orange,
//               ),
//               child: Center(
//                 child: Text(
//                   value.toString(),
//                   style: const TextStyle(
//                     fontSize: 22,
//                   ),
//                 ),
//               ),
//             ),
//           ), 
//           const SizedBox(width: 10,),
//           const Expanded(
//             child: Center(
//               child: Text(
//                 "Total Games Played",
//                 style: TextStyle(
//                   fontSize: 22,
//                 ),
//               ) ,
//             )
//           )
//         ]
//       ),
//     ),
//   );
// }

// Widget totalStatHalf(int value, String body, double textSize) {

//   return Expanded(
//     child: Padding(
//       padding: EdgeInsets.all(8.0),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.all(Radius.circular(10.0)),
//           color: Colors.lightBlue,
//         ),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.fromLTRB(4.0,4.0,4.0,0.0),
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                   color: Colors.lightGreenAccent,
//                 ),
//                 child: Center(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 8.0 ),
//                     child: Align(
//                       child: Text(
//                         value.toString(),
//                         style: TextStyle(
//                           fontSize: 26,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   )
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(8.0,0.0,8.0,0.0),
//               child: Container(
//                 child: Center(
//                   child: Text(
//                     body,
//                     style: TextStyle(
//                       fontSize: textSize,
//                       height: 1.0
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),
//             )
            
//           ],
//         ),
//       ),
//     )
//   );
// }


// Widget totalStatQuarter(int value, String body, double textSize) {
//   // return Expanded(
//   return Container(
//     child: Padding(
//       padding: EdgeInsets.all(8.0),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.all(Radius.circular(10.0)),
//           color: Colors.lightBlue,
//         ),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.fromLTRB(4.0,4.0,4.0,0.0),
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                   // color: Colors.lightGreenAccent,
//                 ),
//                 child: Center(
//                   child: Padding(
//                     padding: const EdgeInsets.fromLTRB(4.0,8.0,4.0,8.0),
//                     child: Align(
//                       child: Text(
//                         value.toString(),
//                         style: TextStyle(
//                           fontSize: 26,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   )
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(8.0,0.0,8.0,0.0),
//               child: Container(
//                 child: Center(
//                   child: Column(
//                     children: [

//                       Text(
//                         "$body-letter",
//                         style: TextStyle(
//                           fontSize: textSize,
//                           height: 1.0
//                         ),
//                         textAlign: TextAlign.center,
//                       ),

//                       Text(
//                         "words",
//                         style: TextStyle(
//                           fontSize: textSize,
//                           height: 1.0
//                         ),
//                         textAlign: TextAlign.center,
//                       ),                      
//                     ],
//                   )
//                 ),
//               ),
//             )
            
//           ],
//         ),
//       ),
//     )
//   );
// }

// Widget statItemFullCard(int value, String body, Icon icon) {
//   return Padding(
//     padding: const EdgeInsets.fromLTRB(28.0, 6.0, 28.0, 6.0),
//     child: Container(
//       width: double.infinity,
//       height: 70,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//         color: Colors.amber,
//       ),
//       child: Row(
//         children: [
//           // const SizedBox(width: 10,),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Container(
//               width: 50,
//               height: 50,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.all(Radius.circular(100.0)),
//                 color:  Colors.orange,
//               ),
//               child: Center(
//                 child: icon,
//               ),
//             ),
//           ),           
//           Expanded(
//             child: Center(
//               child: Text(
//                 body,
//                 style: TextStyle(
//                   fontSize: 22,
//                 ),
//               ) ,
//             )
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Container(
//               width: 60,
//               height: 60,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                 color:  Colors.orange,
//               ),
//               child: Center(
//                 child: Text(
//                   value.toString(),
//                   style: const TextStyle(
//                     fontSize: 22,
//                   ),
//                 ),
//               ),
//             ),
//           ),           
//         ]
//       ),
//     ),
//   );
// }






