import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/components/background_painter.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/screens/statistics_screen.dart/components/game_summary_card.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';

class GameHistoryScreen extends StatefulWidget {
  const GameHistoryScreen({super.key});

  @override
  State<GameHistoryScreen> createState() => _GameHistoryScreenState();
}

class _GameHistoryScreenState extends State<GameHistoryScreen> {
  late SettingsController settings;
  late ColorPalette palette;
  late double scalor = 1.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    settings = Provider.of<SettingsController>(context, listen: false);
    palette = Provider.of<ColorPalette>(context, listen: false);
    scalor = Helpers().getScalor(settings);
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          // top: 1,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,//-MediaQuery.of(context).padding.top-MediaQuery.of(context).padding.bottom,
            child: CustomPaint(
              painter: GradientBackground(settings: settings, palette: palette, decorationData: []),
            ),
          ),
        ),         
        Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(0, 49, 49, 49),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: palette.appBarText,),
              onPressed: () => Navigator.of(context).pop(true),
            ),

            title: Text(
              "Game History",
              style: palette.mainAppFont(
                textStyle: TextStyle(
                  color: palette.appBarText,
                  fontSize: 36*scalor,
                ),                        
              )
            )
          ),
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0 * scalor),
            child: Builder(
              builder: (context) {
                if (settings.userGameHistory.value.isEmpty) {
                  return SizedBox(
                    child: Text(
                      "No games played yet...",
                      style: palette.counterFont(
                        textStyle: TextStyle(
                          fontSize: 22 * scalor,
                          color: palette.text1,
                        ),
                      ) 
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: settings.userGameHistory.value.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GameSummaryCard(gameData: settings.userGameHistory.value[index],palette: palette,);
                    }
                  );
                }
              }
            )
          )  
        ),
      ],
    );
  }
}