import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/resources/auth_service.dart';
import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
import 'package:scribby_flutter_v2/screens/menu_screen/menu_screen.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class LeaderboardsScreen extends StatefulWidget {
  const LeaderboardsScreen({super.key});

  @override
  State<LeaderboardsScreen> createState() => _LeaderboardsScreenState();
}

class _LeaderboardsScreenState extends State<LeaderboardsScreen>
    with TickerProviderStateMixin {
  late bool isLoading = false;
  late List<Map<String, dynamic>> _pointsList = [];
  late Map<String, dynamic> _userData = {};

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final userData = await FirestoreMethods()
          .getUserData(AuthService().currentUser!.uid) as Map<String, dynamic>;
      final List<Map<String, dynamic>> leaderboard = await FirestoreMethods()
              .getDataForLeaderboards(userData['parameters']['currentLanguage'])
          as List<Map<String, dynamic>>;

      setState(() {
        _pointsList = leaderboard;
        _userData = userData;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorPalette palette =
        Provider.of<ColorPalette>(context, listen: false);
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const MenuScreen(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: palette.textColor1,
                  )),
              title: Text(
                "Leaderboard (${Helpers().capitalize(_userData['parameters']['currentLanguage'])})",
                style: TextStyle(
                  color: palette.textColor2,
                ),
              ),
              backgroundColor: palette.modalNavigationBarBgColor,
            ),
            body: Container(
              color: palette.screenBackgroundColor,
              child: getLeaderboard(_pointsList, palette, _userData),
            ));
  }
}

Widget getLeaderboard(List<Map<String, dynamic>> list, ColorPalette palette,
    Map<String, dynamic> user) {
  bool checkIfUser(Map<String, dynamic> user, Map<String, dynamic> item) {
    late bool res = false;
    if (user['uid'] == item['user']) res = true;
    return res;
  }

  return Padding(
    padding: const EdgeInsets.fromLTRB(18.0, 8.0, 18.0, 8.0),
    child: Column(
      children: [
        Container(
          height: 80,
          width: double.infinity,
          color: Colors.transparent,
          child: Row(
            children: [
              Icon(
                Icons.emoji_events,
                size: 22,
                color: palette.textColor2,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                "High Score: ${user['highScores'][user['parameters']['currentLanguage']] ?? 0}",
                style: TextStyle(fontSize: 22, color: palette.textColor2),
              )
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
            3: FlexColumnWidth(2),
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
                      "Rank",
                      style: TextStyle(
                          fontSize: 18,
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
                              "Username",
                              style: TextStyle(
                                  fontSize: 18,
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
                              "Score",
                              style: TextStyle(
                                  fontSize: 18,
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
                                    fontSize: 18,
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
                                        fontSize: 18,
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
                                        fontSize: 18,
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
  );
}
