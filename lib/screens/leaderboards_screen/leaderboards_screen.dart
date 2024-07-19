import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/audio/audio_controller.dart';
import 'package:scribby_flutter_v2/audio/sounds.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/resources/auth_service.dart';
import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/play_area/decorations/decorations.dart';
import 'package:scribby_flutter_v2/screens/menu_screen/menu_screen.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class LeaderboardsScreen extends StatefulWidget {
  const LeaderboardsScreen({super.key});

  @override
  State<LeaderboardsScreen> createState() => _LeaderboardsScreenState();
}

class _LeaderboardsScreenState extends State<LeaderboardsScreen> with TickerProviderStateMixin {

  Future<Map<String,dynamic>> getData() async {

    late Map<String,dynamic> res = {};

    try {
      final userData = await FirestoreMethods().getUserData(AuthService().currentUser!.uid) as Map<String, dynamic>;
      final List<Map<String, dynamic>> leaderboard = await FirestoreMethods()
        .getDataForLeaderboards(userData['parameters']['currentLanguage']) as List<Map<String, dynamic>>;

      res = {"leaderboard" : leaderboard, 'userData': userData};
    } catch (e) {
      // debugPrint(e.toString());
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    final ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
    final SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);
    final GamePlayState gamePlayState = Provider.of<GamePlayState>(context, listen: false);
    final AudioController audioController =Provider.of<AudioController>(context, listen: false);

    final double screenWidth = settingsState.screenSizeData['width'];
    final double screenHeight = settingsState.screenSizeData['height'];
    final List<Map<String,dynamic>> decorationDetails = gamePlayState.decorationData;   
    // return isLoading
        // ? const Center(child: CircularProgressIndicator(),): 
        return FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(),);
            } else if (snapshot.hasError ) {
              return const Center(child: Text("Error"),);
            } else if (snapshot.data!.isEmpty) {
              return const Center(child: Text("Error"),);
            } else {
              print(snapshot.data!);
              return SafeArea(
                child: Stack(                   
                  children: [
                    CustomPaint(size: Size(screenWidth, screenHeight), painter: CustomBackground(palette: palette)),  
                    Decorations().decorativeSquare(decorationDetails[0]),
                    Decorations().decorativeSquare(decorationDetails[1]),
                    Decorations().decorativeSquare(decorationDetails[2]),
                    Decorations().decorativeSquare(decorationDetails[3]),
                    Decorations().decorativeSquare(decorationDetails[4]),
                    Decorations().decorativeSquare(decorationDetails[5]),
                    Decorations().decorativeSquare(decorationDetails[6]),
                    Decorations().decorativeSquare(decorationDetails[7]),
                    Decorations().decorativeSquare(decorationDetails[8]),
                    Decorations().decorativeSquare(decorationDetails[9]),
                    Decorations().decorativeSquare(decorationDetails[10]),
                    Positioned.fill(
                      child: Scaffold(
                          appBar: PreferredSize(
                            preferredSize: Size(double.infinity,gamePlayState.tileSize),
                            
                            child: AppBar(     
                              backgroundColor: Colors.transparent,
                              leading: SizedBox(),
                                flexibleSpace: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.arrow_back),
                                        iconSize: gamePlayState.tileSize*0.44,
                                        color: palette.textColor1,
                                        onPressed: () {
                                          audioController.playSfx(SfxType.optionSelected);
                                          // Navigator.of(context).pushReplacement(
                                          //   MaterialPageRoute(
                                          //     builder: (context) => const MenuScreen(),
                                          //   ),
                                          // );
                                          Navigator.of(context).pushAndRemoveUntil(
                                            MaterialPageRoute(
                                              builder: (context) => const MenuScreen(),
                                            ), (Route<dynamic> route) => false
                                          );                                          
                                        },
                                      ),                                         
                                      Text(Helpers().translateText(gamePlayState.currentLanguage, 'Leaderboard',settingsState),
                                        style: TextStyle(
                                          color: palette.textColor1,
                                          fontSize: gamePlayState.tileSize*0.4
                                        ),
                                                                        
                                      ),
                                    ],
                                  ),
                                ), 
                            ),
                          ),              
                          // backgroundColor: palette.screenBackgroundColor,
                          backgroundColor: Colors.transparent,
                          body: Container(
                            // color: palette.screenBackgroundColor,
                            child: getLeaderboard(
                              snapshot.data!['leaderboard'], 
                              palette, 
                              snapshot.data!['userData'], 
                              gamePlayState.currentLanguage, 
                              // settingsState.sizeFactor
                              gamePlayState.tileSize,
                              settingsState
                            ),
                          )),
                    ),
                  ],
                ),
              );
            }         
          },
        );
  }
}

Widget getLeaderboard(List<Map<String, dynamic>> list, ColorPalette palette, Map<String, dynamic> user, String language, double tileSize, SettingsState settingsState) {
  bool checkIfUser(Map<String, dynamic> user, Map<String, dynamic> item) {
    late bool res = false;
    if (user['uid'] == item['user']) res = true;
    return res;
  }

  return Align(
    alignment: Alignment.center,
    child: ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 600
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18.0, 8.0, 18.0, 8.0),
        child: Column(
          children: [
            Container(
              // height: tileSize*2,
              width: double.infinity,
              color: Colors.transparent,
              child: Center(
                child: Row(
                  children: [
                    const Expanded(flex: 3, child: SizedBox(),),
                    Icon(
                      Icons.emoji_events,
                      size: tileSize*0.5,
                      color: palette.textColor2,
                    ),
                    // const SizedBox(
                    //   width: 10,
                    // ),
                    const Expanded(flex: 1, child: SizedBox(),),
                    Column(
                      children: [
                        Text(
                          Helpers().translateText(language, "High Score:",settingsState),
                          // "High Score: ${user['highScores'][user['parameters']['currentLanguage']] ?? 0}",
                          style: TextStyle(fontSize: tileSize*0.35, color: palette.textColor2),
                        ),
                        Text(
                          "${user['highScores'][user['parameters']['currentLanguage']] ?? 0}",
                          // "High Score: ${user['highScores'][user['parameters']['currentLanguage']] ?? 0}",
                          style: TextStyle(fontSize: tileSize*0.35, color: palette.textColor2),
                        ),                  
                      ],
                    ),
                    const Expanded(flex: 1, child: SizedBox(),),
                    Icon(
                      Icons.emoji_events,
                      size: tileSize*0.5,
                      color: palette.textColor2,
                    ),
                    const Expanded(flex: 3, child: SizedBox(),),             
                  ],
                ),
              ),
            ),
            Table(
              border: const TableBorder(
                horizontalInside: BorderSide(
                    width: 1, color: Colors.grey, style: BorderStyle.solid),
              ),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(3),
                3: FlexColumnWidth(3),
              },
              children: [
                TableRow(
                    decoration: BoxDecoration(
                        // color: palette.optionButtonBgColor3,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5.0),
                            topRight: Radius.circular(5.0))),
                    children: [
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                Helpers().translateText(language, "Rank",settingsState),
                                style: TextStyle(
                                fontSize: tileSize*0.3,
                                color: palette.textColor2,
                                fontWeight: FontWeight.bold),
                                                      ),
                            )),
                      )),
                      TableCell(
                        child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    Helpers().translateText(language, "Username",settingsState),
                                    style: TextStyle(
                                        fontSize: tileSize*0.3,
                                        color: palette.textColor2,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ))),
                      ),
                      TableCell(
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(4.0, 4.0, 8.0, 4.0),
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    Helpers().translateText(language, "Score",settingsState),
                                    style: TextStyle(
                                        fontSize: tileSize*0.3,
                                        color: palette.textColor2,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ))),
                      ),
                    ]),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Table(
                  border: TableBorder(
                    horizontalInside: BorderSide(
                        width: 1, color: Colors.grey.withOpacity(0.3), style: BorderStyle.solid),
                  ),
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(3),
                    3: FlexColumnWidth(2),
                  },
                  children: [
                    for (int i = 0; i < list.length; i++)
                      TableRow(
                          decoration: BoxDecoration(
                              // color: (i + 1).isEven
                              //     ? palette.optionButtonBgColor2
                              //     : palette.optionButtonBgColor
                              ),
                          children: [
                            TableCell(
                              child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Center(
                                      child: Text(
                                        (i + 1).toString(),
                                    style: TextStyle(
                                        fontSize: tileSize*0.3,
                                        color: palette.textColor2,
                                        fontWeight: checkIfUser(user, list[i])
                                            ? FontWeight.w800
                                            : FontWeight.normal),
                                  ))),
                            ),
                            TableCell(
                              child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        // Helpers()
                                        //     .capitalizeName(list[i]['username']),
                                        list[i]['username'],
                                        style: TextStyle(
                                            fontSize: tileSize*0.3,
                                            color: palette.textColor2,
                                            fontWeight: checkIfUser(user, list[i])
                                                ? FontWeight.w800
                                                : FontWeight.normal),
                                      ))),
                            ),
                            TableCell(
                              child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(4.0, 4.0, 8.0, 4.0),
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        list[i]["points"].toString(),
                                        style: TextStyle(
                                            fontSize: tileSize*0.3,
                                            color: palette.textColor2,
                                            fontWeight: checkIfUser(user, list[i])
                                                ? FontWeight.w800
                                                : FontWeight.normal),
                                      ))),
                            ),
                          ])
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
