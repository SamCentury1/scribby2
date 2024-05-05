import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/audio/audio_controller.dart';
import 'package:scribby_flutter_v2/audio/sounds.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/resources/auth_service.dart';
import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
import 'package:scribby_flutter_v2/screens/welcome_user/welcome_user.dart';
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
              return SafeArea(
                child: Scaffold(
                    appBar: AppBar(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(30.0)
                        )
                      ),                      
                      leading: IconButton(
                        onPressed: () {
                          audioController.playSfx(SfxType.optionSelected);
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const WelcomeUser(),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: palette.textColor1,
                          size: 24*settingsState.sizeFactor,
                        )
                      ),
                      title: Text(
                        Helpers().translateText(gamePlayState.currentLanguage, "Leaderboard"),
                        // "Leaderboard",
                        style: TextStyle(
                          color: palette.textColor2,
                          fontSize: 26*settingsState.sizeFactor
                        ),
                      ),
                      backgroundColor: palette.appBarColor,
                    ),
                    backgroundColor: palette.screenBackgroundColor,
                    body: Container(
                      color: palette.screenBackgroundColor,
                      child: getLeaderboard(
                        snapshot.data!['leaderboard'], 
                        palette, 
                        snapshot.data!['userData'], 
                        gamePlayState.currentLanguage, 
                        settingsState.sizeFactor
                      ),
                    )),
              );
            }         
          },
        );
  }
}

Widget getLeaderboard(List<Map<String, dynamic>> list, ColorPalette palette, Map<String, dynamic> user, String language, double sizeFactor) {
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
              height: 80*sizeFactor,
              width: double.infinity,
              color: Colors.transparent,
              child: Row(
                children: [
                  const Expanded(flex: 3, child: SizedBox(),),
                  Icon(
                    Icons.emoji_events,
                    size: 36*sizeFactor,
                    color: palette.textColor2,
                  ),
                  // const SizedBox(
                  //   width: 10,
                  // ),
                  const Expanded(flex: 1, child: SizedBox(),),
                  Column(
                    children: [
                      Text(
                        Helpers().translateText(language, "High Score:"),
                        // "High Score: ${user['highScores'][user['parameters']['currentLanguage']] ?? 0}",
                        style: TextStyle(fontSize: 22*sizeFactor, color: palette.textColor2),
                      ),
                      Text(
                        "${user['highScores'][user['parameters']['currentLanguage']] ?? 0}",
                        // "High Score: ${user['highScores'][user['parameters']['currentLanguage']] ?? 0}",
                        style: TextStyle(fontSize: 22*sizeFactor, color: palette.textColor2),
                      ),                  
                    ],
                  ),
                  const Expanded(flex: 1, child: SizedBox(),),
                  Icon(
                    Icons.emoji_events,
                    size: 36*sizeFactor,
                    color: palette.textColor2,
                  ),
                  const Expanded(flex: 3, child: SizedBox(),),             
                ],
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
                        color: palette.optionButtonBgColor3,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5.0),
                            topRight: Radius.circular(5.0))),
                    children: [
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Center(
                            child: Text(
                          // "Rank",
                          Helpers().translateText(language, "Rank"),
                          style: TextStyle(
                              fontSize: 18*sizeFactor,
                              color: palette.textColor2,
                              fontWeight: FontWeight.bold),
                        )),
                      )),
                      TableCell(
                        child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  Helpers().translateText(language, "Username"),
                                  // "Username",
                                  style: TextStyle(
                                      fontSize: 18*sizeFactor,
                                      color: palette.textColor2,
                                      fontWeight: FontWeight.bold),
                                ))),
                      ),
                      TableCell(
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(4.0, 4.0, 8.0, 4.0),
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  // "Score",
                                  Helpers().translateText(language, "Score"),
                                  style: TextStyle(
                                      fontSize: 18*sizeFactor,
                                      color: palette.textColor2,
                                      fontWeight: FontWeight.bold),
                                ))),
                      ),
                    ]),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Table(
                  border: const TableBorder(
                    horizontalInside: BorderSide(
                        width: 1, color: Colors.grey, style: BorderStyle.solid),
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
                              color: (i + 1).isEven
                                  ? palette.optionButtonBgColor2
                                  : palette.optionButtonBgColor),
                          children: [
                            TableCell(
                              child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Center(
                                      child: Text(
                                        (i + 1).toString(),
                                    style: TextStyle(
                                        fontSize: 18*sizeFactor,
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
                                        Helpers()
                                            .capitalizeName(list[i]['username']),
                                        style: TextStyle(
                                            fontSize: 18*sizeFactor,
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
                                            fontSize: 18*sizeFactor,
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
