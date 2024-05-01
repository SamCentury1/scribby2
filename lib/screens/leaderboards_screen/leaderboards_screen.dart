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


  // late bool isLoading = false;
  // late List<Map<String, dynamic>> _pointsList = [];
  // late Map<String, dynamic> _userData = {};

  // @override
  // void initState() {
  //   super.initState();
  //   // getData();
  // }

  Future<Map<String,dynamic>> getData() async {
    // setState(() {
    //   isLoading = true;
    // });

    late Map<String,dynamic> res = {};

    try {
      final userData = await FirestoreMethods().getUserData(AuthService().currentUser!.uid) as Map<String, dynamic>;
      final List<Map<String, dynamic>> leaderboard = await FirestoreMethods()
        .getDataForLeaderboards(userData['parameters']['currentLanguage']) as List<Map<String, dynamic>>;

      // setState(() {
        // _pointsList = leaderboard;
        // _userData = userData;
        // isLoading = false;
      // });

      res = {"leaderboard" : leaderboard, 'userData': userData};
    } catch (e) {
      debugPrint(e.toString());
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
                        // snapshot.data!['leaderboard'], 
                        leaderboardList,
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

List<Map<String,dynamic>> leaderboardList = [
  {"username":"Joe the Crow","points":9982},
  {"username":"Dyson the Bison","points":9629},
  {"username":"Thor the Boar","points":9555},
  {"username":"Bruce the Moose","points":9457},
  {"username":"Sniper the Viper","points":9363},
  {"username":"Jewel the Mule","points":9358},
  {"username":"Link the Mink","points":9315},
  {"username":"Sam the Ram","points":8721},
  {"username":"Uma the Puma","points":8429},
  {"username":"Jack the Yak","points":8394},
  {"username":"Jove the Dove","points":8392},
  {"username":"Gail the Whale","points":8231},
  {"username":"Pierre the Deer","points":8123},
  {"username":"Powell the Owl","points":7960},
  {"username":"Drake the Snake","points":7799},
  {"username":"Brock the Hawk","points":7766},
  {"username":"Claire the Bear","points":7554},
  {"username":"Maude the Toad","points":7345},
  {"username":"Lana the Llama","points":7297},
  {"username":"Bree the Flea","points":7168},
  {"username":"Sven the Wren","points":7134},
  {"username":"Dee the Bee","points":7019},
  {"username":"Porcha the Orca","points":7018},
  {"username":"Kate the Ape","points":6574},
  {"username":"Mark the Lark","points":6277},
  {"username":"Ab the Crab","points":6206},
  {"username":"Blair the Hare","points":5893},
  {"username":"Myrtle the Turtle","points":5866},
  {"username":"Matt the Bat","points":5574},
  {"username":"Tony the Pony","points":5558},
  {"username":"Echo the Gecko","points":4812},
  {"username":"Grinch the Finch","points":4693},
  {"username":"Hull the Gull","points":4554},
  {"username":"Seymour the Lemur","points":4541},
  {"username":"Juan the Swan","points":4492},
  {"username":"Casp the Wasp","points":4337},
  {"username":"Drew the Shrew","points":4332},
  {"username":"Pat the Rat","points":4220},
  {"username":"Neal the Seal","points":3519},
  {"username":"Roth the Sloth","points":3420},
  {"username":"Rolf the Wolf","points":3367},
  {"username":"Meryl the Squirrel","points":3293},
  {"username":"Ziggy the Piggy","points":2835},
  {"username":"Alcon the Falcon","points":2191},
  {"username":"Ryan the Lion","points":2144},
  {"username":"Monroe the Crow","points":1340},
  {"username":"Knox the Fox","points":1232},
  {"username":"Holt the Colt","points":1217},
  {"username":"Ben the Hen","points":1095},
  {"username":"Chuck the Duck","points":1084},
  {"username":"Abbot the Rabbit","points":958},
  {"username":"Trish the Fish","points":923},
  {"username":"Grant the Ant","points":607},
  {"username":"Broach the Roach","points":237},
  {"username":"Paola the Koala","points":68},
];

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
